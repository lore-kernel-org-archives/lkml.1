Return-Path: <linux-kernel-owner+w=401wt.eu-S1753306AbXD3Wpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306AbXD3Wpn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 18:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751738AbXD3Wpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 18:45:43 -0400
Received: from holomorphy.com ([66.93.40.71]:58648 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753673AbXD3Wpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 18:45:41 -0400
Date: Mon, 30 Apr 2007 15:45:36 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Matt Keenan <tank.en.mate@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Bradley Chapman <kakadu@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: CONFIG_HIGHMEM4G and 1GB RAM
Message-ID: <20070430224536.GQ19966@holomorphy.com>
References: <e294b46e0704281326w60f9cecfuace3442791f147b3@mail.gmail.com> <20070430001755.e9f203c9.akpm@linux-foundation.org> <20070430074044.GB19966@holomorphy.com> <46366B34.3050003@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46366B34.3050003@gmail.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III wrote:
>> The CONFIG_VMSPLIT config options were merged for such cases.
>> It should be able to split on any 4MB-aligned boundary in
>> CONFIG_HIGHMEM4G. CONFIG_VMSPLIT_3G_OPT appears to do something of
>> this sort to use an entire 1GB RAM with minimal user address space
>> reduction.
>> This is an ELF ABI violation but the number of major applications
>> that break is apparently low.

On Mon, Apr 30, 2007 at 11:18:28PM +0100, Matt Keenan wrote:
> wine and some java implementations being two of the big caveats.

Understand that when I say this, I remain one of the more staunch
critics of the ABI-violating aspect of the CONFIG_VMSPLIT options.

I would be more in favor of reorganizing the kernel virtual address
space for the case of 1GB laptops. The primary reason it now requires
highmem is that otherwise vmallocspace would alias ZONE_NORMAL, which
is not handled.

The way to handle the aliasing is simple except for the case of vmap();
simply allocate the backing pages for vmalloc() from the virtual
address range aliasing it. IOW, implement vmalloc() as __get_free_pages(),
save for supporting cases beyond power-of-two alignment. vmap() must
carry out a similar reservation to obtain a virtually contiguous range
of memory; however, it must not use the underlying pages. Instead, it
must map the physical pages specified by the caller in the range of
virtual address space reserved in tandem with the physically contiguous
allocation. The physical pages underlying the virtual mapping window,
without a way to window into them as per CONFIG_HIGHMEM, merely stay
reserved until the virtual mapping established by vmap() that clashes
with their static virtual mapping is undone.

In such a manner the static virtualspace reservation for vmallocspace
can be eliminated, and the case of 1GB laptops handled efficiently with
neither highmem nor ABI violations.

If this sounds invasive or difficult, that's because it probably is.
Taking this idea seriously is indicative of the gravity I consider
the issues of laptop/desktop users to have.


-- wli
