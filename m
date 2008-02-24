Return-Path: <linux-kernel-owner+w=401wt.eu-S1754272AbYBXP6N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272AbYBXP6N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 10:58:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752213AbYBXP6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 10:58:04 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:17950 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbYBXP6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 10:58:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=GUlgevoEZZZbFvylBO/bw7USdj/ePFcNWrAUqo9KYPyZ8VFgrf5yTGhHXitTi17fbCBLiZXwPZCsaZV39gyLE87M8PP7qiCS6FYrBF5nnHOS94J9DrlccfbOuEpMAKaSVRWHI+K2m1sIbgYC7wS6b63TcIcm66JMuJJkQsZ8c9s=
Date: Sun, 24 Feb 2008 17:55:15 +0200
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Rusty Russell <rusty@rustcorp.com.au>
Cc: LKML <linux-kernel@vger.kernel.org>, lguest@ozlabs.org,
       akpm <akpm@linux-foundation.org>
Subject: [BUG + PATCH/Bugfix] x86/lguest: fix pgdir pmd index calculation
Message-ID: <20080224155515.GA24831@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Beginning from commits close to v2.6.25-rc2, running lguest always oopses
the host kernel. Oops is at [1].

Bisection led to the following commit:

commit 37cc8d7f963ba2deec29c9b68716944516a3244f

    x86/early_ioremap: don't assume we're using swapper_pg_dir
    
    At the early stages of boot, before the kernel pagetable has been
    fully initialized, a Xen kernel will still be running off the
    Xen-provided pagetables rather than swapper_pg_dir[].  Therefore,
    readback cr3 to determine the base of the pagetable rather than
    assuming swapper_pg_dir[].
    
 static inline pmd_t * __init early_ioremap_pmd(unsigned long addr)
 {
-	pgd_t *pgd = &swapper_pg_dir[pgd_index(addr)];
+	/* Don't assume we're using swapper_pg_dir at this point */
+	pgd_t *base = __va(read_cr3());
+	pgd_t *pgd = &base[pgd_index(addr)];
 	pud_t *pud = pud_offset(pgd, addr);
 	pmd_t *pmd = pmd_offset(pud, addr);
 
Trying to analyze the problem, it seems on the guest side of lguest, 
%cr3 has a different value from &swapper_pg-dir (which
is AFAIK fine on a pravirt guest): 

Putting some debugging messages in early_ioremap_pmd:

/* Appears 3 times */
[    0.000000] ***************************
[    0.000000] __va(%cr3) = c0000000, &swapper_pg_dir = c02cc000
[    0.000000] ***************************

After 8 hours of debugging and staring on lguest code, I noticed something
strange in paravirt_ops->set_pmd hypercall invocation:

static void lguest_set_pmd(pmd_t *pmdp, pmd_t pmdval)
{
	*pmdp = pmdval;	
	lazy_hcall(LHCALL_SET_PMD, __pa(pmdp)&PAGE_MASK,
		   (__pa(pmdp)&(PAGE_SIZE-1))/4, 0);
}

The first hcall parameter is global pgdir which looks fine. The second
parameter is the pmd index in the pgdir which is suspectful.

AFAIK, calculating the index of pmd does not need a divisoin over four. 
Removing the division made lguest work fine again . Patch is at [2].

I am not sure why the division over four existed in the first place. It
seems bogus, maybe the Xen patch just made the problem appear ?

[2]: The patch:

[PATCH] lguest: fix pgdir pmd index cacluation

Remove an error in index calculation which leads to removing
a not existing shadow page table (leading to a Null dereference).

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
---
diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
index 5afdde4..6636750 100644
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -489,7 +489,7 @@ static void lguest_set_pmd(pmd_t *pmdp, pmd_t pmdval)
 {
 	*pmdp = pmdval;
 	lazy_hcall(LHCALL_SET_PMD, __pa(pmdp)&PAGE_MASK,
-		   (__pa(pmdp)&(PAGE_SIZE-1))/4, 0);
+		   (__pa(pmdp)&(PAGE_SIZE-1)), 0);
 }
 
 /* There are a couple of legacy places where the kernel sets a PTE, but we


[1]: The oops:

[    9.936880] BUG: unable to handle kernel NULL pointer dereference at 00000ff8
[    9.938015] IP: [<c0204ef6>] release_pgd+0x6/0x60
[    9.938379] *pde = 00000000 
[    9.938618] Oops: 0000 [#1] 
[    9.938680] Modules linked in:
[    9.938680] 
[    9.938680] Pid: 173, comm: lguest Not tainted (2.6.25-rc2-dirty #59)
[    9.938680] EIP: 0060:[<c0204ef6>] EFLAGS: 00000202 CPU: 0
[    9.938680] EIP is at release_pgd+0x6/0x60
[    9.938680] EAX: c7cfe000 EBX: c7d06fb8 ECX: 00000000 EDX: 00000ff8
[    9.938680] ESI: c7cfe004 EDI: 00000ff8 EBP: 00000000 ESP: c7cebe5c
[    9.938680]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0058
[    9.938680] Process lguest (pid: 173, ti=c7cea000 task=c7c94ac0 task.ti=c7cea000)
[    9.938680] Stack: c7d06fb8 c7cfe004 c7cfe004 00000000 c0204a61 00000000 00000246 00000246 
[    9.938680]        c7cbd528 c10ed500 b5d65000 00000002 c02110f4 076a8067 c0151ccc c7cc8668 
[    9.938680]        01d65000 c7cbd528 00000007 c7cc8668 00000000 b5d65000 c01531b8 00000246 
[    9.938680] Call Trace:
[    9.938680]  [<c0204a61>] do_hcall+0x1a1/0x230
[    9.938680]  [<c02110f4>] _spin_unlock+0x14/0x20
[    9.938680]  [<c0151ccc>] follow_page+0x9c/0x190
[    9.938680]  [<c01531b8>] get_user_pages+0x108/0x2c0
[    9.938680]  [<c01bd9af>] copy_to_user+0x3f/0x70
[    9.938680]  [<c0206ae0>] read+0x0/0xb8
[    9.938680]  [<c0204ba9>] do_hypercalls+0xb9/0x2a0
[    9.938680]  [<c0207b5a>] lguest_arch_run_guest+0xfa/0x1d0
[    9.938680]  [<c0204651>] run_guest+0xc1/0x110
[    9.938680]  [<c0206ae0>] read+0x0/0xb8
[    9.938680]  [<c02045bb>] run_guest+0x2b/0x110
[    9.938680]  [<c01655df>] vfs_read+0x8f/0xc0
[    9.938680]  [<c0165ab6>] sys_pread64+0x76/0x80
[    9.938680]  [<c0103864>] sysenter_past_esp+0x6d/0xc5
[    9.938680]  =======================
[    9.938680] Code: 75 03 5b c3 90 89 d8 e8 39 dc f0 ff 90 8b 1d d8 44 4f c0 c1 e8 0c c1 e0 05 01 d8 5b e9 24 81 f4 ff 8d 74 26 00 55 57 89 d7 56 53 <8b> 02 e8 f3 db f0 ff 90 a8 01 74 3f 8b 07 e8 e7 db f0 ff 90 25 
[    9.938680] EIP: [<c0204ef6>] release_pgd+0x6/0x60 SS:ESP 0058:c7cebe5c
[    9.939759] ---[ end trace 0cda9e589a597173 ]---

Regards,

-- 

"Better to light a candle, than curse the darkness"

Ahmed S. Darwish
Homepage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com

