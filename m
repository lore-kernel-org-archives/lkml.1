Return-Path: <linux-kernel-owner+w=401wt.eu-S1752827AbYIXMcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827AbYIXMcg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 08:32:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751318AbYIXMc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 08:32:28 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37462 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbYIXMc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 08:32:27 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 1/2] Report the pagesize backing a VMA in /proc/pid/smaps
Cc: kosaki.motohiro@jp.fujitsu.com, Dave Hansen <dave@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
In-Reply-To: <20080923194655.GA25542@csn.ul.ie>
References: <20080923211140.DC16.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080923194655.GA25542@csn.ul.ie>
Message-Id: <20080924210309.8C3B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Wed, 24 Sep 2008 21:32:24 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Dave, please let me know getpagesize() function return to 4k or 64k on ppc64.
> > I think the PageSize line of the /proc/pid/smap and getpagesize() result should be matched.
> > 
> > otherwise, enduser may be confused.
> > 
> 
> To distinguish between the two, I now report the kernel pagesize and the
> mmu pagesize like so
> 
> KernelPageSize:       64 kB
> MMUPageSize:           4 kB
> 
> This is running a kernel with a 64K base pagesize on a PPC970MP which
> does not support 64K hardware pagesizes.
> 
> Does this make sense?

Hmmm, Who want to this infomation?

I agreed with
  - An administrator want to know these page are normal or huge.
  - An administrator want to know hugepage size.
    (e.g. x86_64 has two hugepage size (2M and 1G))

but above ppc64 case seems deeply implementation depended infomation and
nobody want to know it.

it seems a bottleneck of future enhancement.

then I disagreed with
  - show both KernelPageSize and MMUPageSize in normal page.


I like following two choice


1) in normal page, show PAZE_SIZE

because, any userland application woks as pagesize==PAZE_SIZE 
on current powerpc architecture.

because

fs/binfmt_elf.c
------------------------------
static int
create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
                unsigned long load_addr, unsigned long interp_load_addr)
{
(snip)
        NEW_AUX_ENT(AT_HWCAP, ELF_HWCAP);
        NEW_AUX_ENT(AT_PAGESZ, ELF_EXEC_PAGESIZE); /* pass ELF_EXEC_PAGESIZE to libc */

include/asm-powerpc/elf.h
-----------------------------
#define ELF_EXEC_PAGESIZE       PAGE_SIZE 


2) in normal page, no display any page size.
   only hugepage case, display page size.

because, An administrator want to hugepage size only. (AFAICS)



Thought?


