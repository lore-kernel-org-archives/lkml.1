Return-Path: <linux-kernel-owner+w=401wt.eu-S1754357AbZHaTuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357AbZHaTuQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 15:50:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752480AbZHaTuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 15:50:15 -0400
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:56212 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751510AbZHaTuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 15:50:14 -0400
X-Trace: 255106400/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.118.155/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.118.155
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAAvGm0pPRXab/2dsb2JhbACBU9gchBoFgVU
X-IronPort-AV: E=Sophos;i="4.44,307,1249254000"; 
   d="scan'208";a="255106400"
Date: Mon, 31 Aug 2009 20:49:38 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Eric B Munson <ebmunson@us.ibm.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org, linux-man@vger.kernel.org,
       mtk.manpages@gmail.com, randy.dunlap@oracle.com
Subject: Re: [PATCH 2/3] Add MAP_HUGETLB for mmaping pseudo-anonymous huge
 page regions
In-Reply-To: <1721a3e8bdf8f311d2388951ec65a24d37b513b1.1251282769.git.ebmunson@us.ibm.com>
Message-ID: <Pine.LNX.4.64.0908312036410.16402@sister.anvils>
References: <cover.1251282769.git.ebmunson@us.ibm.com>
 <1c66a9e98a73d61c611e5cf09b276e954965046e.1251282769.git.ebmunson@us.ibm.com>
 <1721a3e8bdf8f311d2388951ec65a24d37b513b1.1251282769.git.ebmunson@us.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Aug 2009, Eric B Munson wrote:
> This patch adds a flag for mmap that will be used to request a huge
> page region that will look like anonymous memory to user space.  This
> is accomplished by using a file on the internal vfsmount.  MAP_HUGETLB
> is a modifier of MAP_ANONYMOUS and so must be specified with it.  The
> region will behave the same as a MAP_ANONYMOUS region using small pages.
> 
> Signed-off-by: Eric B Munson <ebmunson@us.ibm.com>
> ---
>  include/asm-generic/mman-common.h |    1 +
>  include/linux/hugetlb.h           |    7 +++++++
>  mm/mmap.c                         |   19 +++++++++++++++++++
>  3 files changed, 27 insertions(+), 0 deletions(-)
> 
> diff --git a/include/asm-generic/mman-common.h b/include/asm-generic/mman-common.h
> index 3b69ad3..12f5982 100644
> --- a/include/asm-generic/mman-common.h
> +++ b/include/asm-generic/mman-common.h
> @@ -19,6 +19,7 @@
>  #define MAP_TYPE	0x0f		/* Mask for type of mapping */
>  #define MAP_FIXED	0x10		/* Interpret addr exactly */
>  #define MAP_ANONYMOUS	0x20		/* don't use a file */
> +#define MAP_HUGETLB	0x40		/* create a huge page mapping */
>  
>  #define MS_ASYNC	1		/* sync memory asynchronously */
>  #define MS_INVALIDATE	2		/* invalidate the caches */

I'm afraid you can't put MAP_HUGETLB in mman-common.h: that is picked
up by most or all architectures (which is of course what you wanted!)
but conflicts with a definition in at least one of them.  When I boot
up mmotm on powerpc, I get a warning:

Using mlock ulimits for SHM_HUGETLB deprecated
------------[ cut here ]------------
Badness at fs/hugetlbfs/inode.c:941
NIP: c0000000001f3038 LR: c0000000001f3034 CTR: 0000000000000000
REGS: c0000000275d7960 TRAP: 0700   Not tainted  (2.6.31-rc7-mm2)
MSR: 9000000000029032 <EE,ME,CE,IR,DR>  CR: 24000484  XER: 00000000
TASK = c000000029fa94a0[1321] 'console-kit-dae' THREAD: c0000000275d4000 CPU: 3
GPR00: c0000000001f3034 c0000000275d7be0 c00000000071a908 0000000000000032 
GPR04: 0000000000000000 ffffffffffffffff ffffffffffffffff 0000000000000000 
GPR08: c0000000297dc1d0 c0000000275d4000 d00008008247fa08 0000000000000000 
GPR12: 0000000024000442 c00000000074ba00 000000000fedb9a4 000000001049cd18 
GPR16: 00000000100365d0 00000000104a9100 000000000fefc350 00000000104a9098 
GPR20: 00000000104a9160 000000000fefc238 0000000000000000 0000000000200000 
GPR24: 0000000000000000 0000000001000000 c0000000275d7d20 0000000001000000 
GPR28: c00000000058c738 ffffffffffffffb5 c0000000006a93d0 c000000000791400 
NIP [c0000000001f3038] .hugetlb_file_setup+0xd0/0x254
LR [c0000000001f3034] .hugetlb_file_setup+0xcc/0x254
Call Trace:
[c0000000275d7be0] [c0000000001f3034] .hugetlb_file_setup+0xcc/0x254 (unreliable)
[c0000000275d7cb0] [c0000000000ee240] .do_mmap_pgoff+0x184/0x424
[c0000000275d7d80] [c00000000000a9c8] .sys_mmap+0xc4/0x13c
[c0000000275d7e30] [c0000000000075ac] syscall_exit+0x0/0x40
Instruction dump:
f89a0000 4bef7111 60000000 2c230000 41820034 e93e8018 80090014 2f800000 
40fe0030 e87e80b0 4823ff09 60000000 <0fe00000> e93e8018 38000001 90090014 

Which won't be coming from any use of MAP_HUGETLB, but presumably
from something using MAP_NORESERVE, defined as 0x40 in
arch/powerpc/include/asm/mman.h.

I think you have to put your #define MAP_HUGETLB into
include/asm-generic/mman.h (seems used by only three architectures),
and into the arch/whatever/include/asm/mman.h of each architecture
which uses asm-generic/mman-common.h without asm-generic/mman.h.

Hugh
