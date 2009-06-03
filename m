Return-Path: <linux-kernel-owner+w=401wt.eu-S1755077AbZFCTO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077AbZFCTO6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 15:14:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753810AbZFCTOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 15:14:51 -0400
Received: from mail-px0-f182.google.com ([209.85.216.182]:36365 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592AbZFCTOv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 15:14:51 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.1.10.0906031458250.9269@gentwo.org>
References: <20090530230022.GO6535@oblivion.subreption.com>
	 <alpine.DEB.1.10.0906031047390.15621@gentwo.org>
	 <20090603182949.5328d411@lxorguk.ukuu.org.uk>
	 <alpine.LFD.2.01.0906031032390.4880@localhost.localdomain>
	 <20090603180037.GB18561@oblivion.subreption.com>
	 <alpine.LFD.2.01.0906031109150.4880@localhost.localdomain>
	 <20090603183939.GC18561@oblivion.subreption.com>
	 <alpine.LFD.2.01.0906031142390.4880@localhost.localdomain>
	 <alpine.LFD.2.01.0906031145460.4880@localhost.localdomain>
	 <alpine.DEB.1.10.0906031458250.9269@gentwo.org>
Date: Wed, 3 Jun 2009 15:14:52 -0400
Message-ID: <7e0fb38c0906031214lf4a2ed2x688da299e8cb1034@mail.gmail.com>
Subject: Re: Security fix for remapping of page 0 (was [PATCH] Change 
	ZERO_SIZE_PTR to point at unmapped space)
From: Eric Paris <eparis@parisplace.org>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Larry H." <research@subreption.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-mm@kvack.org,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       pageexec@freemail.hu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 3, 2009 at 2:59 PM, Christoph Lameter
<cl@linux-foundation.org> wrote:
> We could just move the check for mmap_min_addr out from
> CONFIG_SECURITY?
>
>
> Use mmap_min_addr indepedently of security models
>
> This patch removes the dependency of mmap_min_addr on CONFIG_SECURITY.
> It also sets a default mmap_min_addr of 4096.
>
> mmapping of addresses below 4096 will only be possible for processes
> with CAP_SYS_RAWIO.
>
>
> Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

NAK  with SELinux on you now need both the SELinux mmap_zero
permission and the CAP_SYS_RAWIO permission.  Previously you only
needed one or the other, depending on which was the predominant
LSM.....

Even if you want to argue that I have to take CAP_SYS_RAWIO in the
SELinux case what about all the other places?  do_mremap?  do_brk?
expand_downwards?

-Eric


> ===================================================================
> --- linux-2.6.orig/mm/mmap.c    2009-06-03 13:48:01.000000000 -0500
> +++ linux-2.6/mm/mmap.c 2009-06-03 13:48:10.000000000 -0500
> @@ -87,6 +87,9 @@ int sysctl_overcommit_ratio = 50;     /* def
>  int sysctl_max_map_count __read_mostly = DEFAULT_MAX_MAP_COUNT;
>  struct percpu_counter vm_committed_as;
>
> +/* amount of vm to protect from userspace access */
> +unsigned long mmap_min_addr = CONFIG_DEFAULT_MMAP_MIN_ADDR;
> +
>  /*
>  * Check that a process has enough memory to allocate a new virtual
>  * mapping. 0 means there is enough memory for the allocation to
> @@ -1043,6 +1046,9 @@ unsigned long do_mmap_pgoff(struct file
>                }
>        }
>
> +       if ((addr < mmap_min_addr) && !capable(CAP_SYS_RAWIO))
> +               return -EACCES;
> +
>        error = security_file_mmap(file, reqprot, prot, flags, addr, 0);
>        if (error)
>                return error;
