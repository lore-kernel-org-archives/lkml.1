Return-Path: <linux-kernel-owner+w=401wt.eu-S1759030AbYJXEvB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759030AbYJXEvB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 00:51:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758724AbYJXEum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 00:50:42 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:55858 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758204AbYJXEuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 00:50:39 -0400
Date: Thu, 23 Oct 2008 21:49:48 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Keith Packard <keithp@keithp.com>
Cc: Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Dave Airlie <airlied@linux.ie>,
       Yinghai Lu <yinghai@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add io-mapping functions to dynamically map large
 device apertures
Message-Id: <20081023214948.0c248345.randy.dunlap@oracle.com>
In-Reply-To: <1224746087-13991-2-git-send-email-keithp@keithp.com>
References: <20081022093615.GF12453@elte.hu>
	<1224746087-13991-1-git-send-email-keithp@keithp.com>
	<1224746087-13991-2-git-send-email-keithp@keithp.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Oct 2008 00:14:46 -0700 Keith Packard wrote:

>  Documentation/io-mapping.txt |   84 ++++++++++++++++++++++++++++
>  include/linux/io-mapping.h   |  125 ++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 209 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/io-mapping.txt
>  create mode 100644 include/linux/io-mapping.h
> 
> diff --git a/Documentation/io-mapping.txt b/Documentation/io-mapping.txt
> new file mode 100644
> index 0000000..ebf6dc5
> --- /dev/null
> +++ b/Documentation/io-mapping.txt
> @@ -0,0 +1,84 @@
> +The io_mapping functions in linux/io.h provide an abstraction for

                                     io-mapping.h ?

> +efficiently mapping small regions of an io device to the CPU. The initial

                                           IO or I/O, please

> +usage is to support the large graphics aperture on 32-bit processors where
> +ioremap_wc cannot be used to statically map the entire aperture to the CPU
> +as it would consume too much of the kernel address space.
> +
> +A mapping object is created during driver initialization using
> +
> +	struct io_mapping *
> +	io_mapping_create_wc(unsigned long base, unsigned long size)
> +
> +		'base' is the bus address of the region to be made
> +		mappable, while 'size' indicates how large a mapping region to
> +		enable. Both are in bytes.
> +
> +		This _wc variant provides a mapping which may only be used
> +		with the io_mapping_map_atomic_wc or io_mapping_map_wc.
> +
> +With this mapping object, individual pages can be mapped either atomically
> +or not, depending on the necessary scheduling environment. Of course, atomic
> +maps are more efficient:
> +
> +	void *
> +	io_mapping_map_atomic_wc(struct io_mapping *mapping, unsigned long offset)
> +
> +		'offset' is the offset within the defined mapping region.
> +		Accessing addresses beyond the region specified in the
> +		creation function yields undefined results. Using an offset
> +		which is not page aligned yields an undefined result. The
> +		return value points to a single page in CPU address space.
> +
> +		This _wc variant returns a write-combining map to the
> +		page and may only be used with 

		                          with <TBD>...

> +
> +		Note that the task may not sleep while holding this page
> +		mapped.
> +
> +	void
> +	io_mapping_unmap_atomic(void *vaddr)
> +
> +		'vaddr' must be the the value returned by the last
> +		io_mapping_map_atomic_wc call. This unmaps the specified
> +		page, and allows the task to sleep once again.

s/,//

> +
> +If you need to sleep while holding the lock, you can use the non-atomic
> +variant, although they may be significantly slower;

s/;/./

> +
> +	void *
> +	io_mapping_map_wc(struct io_mapping *mapping, unsigned long offset)
> +
> +		This works like io_mapping_map_atomic_wc except it allows
> +		the task to sleep while holding the page mapped.
> +
> +	void
> +	io_mapping_unmap(void *vaddr)
> +
> +		This works like io_mapping_unmap_atomic, except it is used
> +		for pages mapped with io_mapping_map_wc.
> +
> +At driver close time, the io_mapping object must be freed:
> +
> +	void
> +	io_mapping_free(struct io_mapping *mapping)
> +
> +Current Implementation:
> +
> +The initial implementation of these functions use existing mapping

                                                 uses

> +mechanisms and so provide only an abstraction layer and no new

                     provides

> +functionality.
> +
> +On 64-bit processors, io_mapping_create_wc calls ioremap_wc for the whole
> +range, creating a permanent kernel-visible mapping to the resource. The
> +map_atomic and map functions add the requested offset to the base of the
> +virtual address returned by ioremap_wc.
> +
> +On 32-bit processors with HIGHMEM defined, io_mapping_map_atomic_wc uses
> +kmap_atomic_pfn to map the specified page in an atomic fashion;
> +kmap_atomic_pfn isn't really supposed to be used with device pages, but it
> +provides an efficient mapping for this usage.
> +
> +On 32-bit processors without HIGHMEM defined, io_mapping_map_atomic_wc and
> +io_mapping_map_wc both use ioremap_wc, a terribly inefficient function which
> +performs an IPI to inform all processors about the new mapping. This results
> +in a significant performance penalty.


And I wish you could lose that horrible (non-Linux kernel) style of function
return type on a separate line.

---
~Randy
