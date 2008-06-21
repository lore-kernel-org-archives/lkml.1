Return-Path: <linux-kernel-owner+w=401wt.eu-S1753892AbYFURBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892AbYFURBk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 13:01:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751783AbYFURBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 13:01:17 -0400
Received: from saeurebad.de ([85.214.36.134]:43259 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751671AbYFURBO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 13:01:14 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Adrian Bunk <bunk@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Bernhard Walle <bwalle@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org
Subject: Re: 2.6.26-rc7: x86 build error
In-Reply-To: <20080621095537.GA27069@cs181133002.pp.htv.fi> (Adrian Bunk's
	message of "Sat, 21 Jun 2008 12:55:37 +0300")
References: <alpine.LFD.1.10.0806201626140.3167@woody.linux-foundation.org>
	<20080621095537.GA27069@cs181133002.pp.htv.fi>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
Date: Sat, 21 Jun 2008 19:01:02 +0200
Message-ID: <87y74yn2nl.fsf@skyscraper.fehenstaub.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Adrian Bunk <bunk@kernel.org> writes:

> Commit d3942cff620bea073fc4e3c8ed878eb1e84615ce
> (x86: use BOOTMEM_EXCLUSIVE on 32-bit)
> causes the following compile error:
>
> <--  snip  -->
>
> ...
>   CC      arch/x86/kernel/setup_32.o
> /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/x86/kernel/setup_32.c: In function ‘reserve_crashkernel’:
> /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/x86/kernel/setup_32.c:536: error: void value not ignored as it ought to be
> make[2]: *** [arch/x86/kernel/setup_32.o] Error 1
>
> <--  snip  -->
>
> CONFIG_KEXEC=y, CONFIG_NEED_MULTIPLE_NODES=y and the fact that 
> reserve_bootmem_node() returns void seems to cause it.

Yes, this triggers it since reserve_bootmem() is then defined to be
reserve_bootmem_node() which returns void while the
!CONFIG_HAVE_ARCH_BOOTMEM_NODE version of reserve_bootmem() in bootmem.c
already returns int.

The following fix is needed:

---

From: Bernhard Walle <bwalle@suse.de>
Subject: Add return value to reserve_bootmem_node()

This patch changes the function reserve_bootmem_node() from void to int,
returning -ENOMEM if the allocation fails.


Signed-off-by: Bernhard Walle <bwalle@suse.de>;

---

Actually, there was a discussion to return -EBUSY instead of -ENOMEM but
in the end it does not matter, because callsites just check for negative
return values.  -hannes

 include/linux/bootmem.h |    2 +-
 mm/bootmem.c            |    6 ++++--
 2 files changed, 5 insertions(+), 3 deletions(-)
--- a/include/linux/bootmem.h
+++ b/include/linux/bootmem.h
@@ -94,7 +94,7 @@ extern unsigned long init_bootmem_node(p
 				       unsigned long freepfn,
 				       unsigned long startpfn,
 				       unsigned long endpfn);
-extern void reserve_bootmem_node(pg_data_t *pgdat,
+extern int reserve_bootmem_node(pg_data_t *pgdat,
 				 unsigned long physaddr,
 				 unsigned long size,
 				 int flags);
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -442,15 +442,17 @@ unsigned long __init init_bootmem_node(p
 	return init_bootmem_core(pgdat, freepfn, startpfn, endpfn);
 }
 
-void __init reserve_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
+int __init reserve_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
 				 unsigned long size, int flags)
 {
 	int ret;
 
 	ret = can_reserve_bootmem_core(pgdat->bdata, physaddr, size, flags);
 	if (ret < 0)
-		return;
+		return -ENOMEM;
 	reserve_bootmem_core(pgdat->bdata, physaddr, size, flags);
+
+	return 0;
 }
 
 void __init free_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
