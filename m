Return-Path: <linux-kernel-owner+w=401wt.eu-S1763100AbYBMMBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763100AbYBMMBR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 07:01:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756158AbYBMMBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 07:01:05 -0500
Received: from gw.goop.org ([64.81.55.164]:50999 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755536AbYBMMBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 07:01:04 -0500
Message-ID: <47B2DBA5.6030001@goop.org>
Date: Wed, 13 Feb 2008 22:59:33 +1100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jody Belka <lists-lkml@pimb.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Ian Campbell <ijc@hellion.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andi Kleen <andi@firstfloor.org>,
       Mika Penttila <mika.penttila@kolumbus.fi>
Subject: Re: 2.6.25-rc1 xen pvops regression
References: <20080212235404.GY7980@pimb.org>
In-Reply-To: <20080212235404.GY7980@pimb.org>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/mixed;
 boundary="------------040007070409010408000207"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040007070409010408000207
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Jody Belka wrote:
> Hi all,
>
> I thought I'd try out 2.6.25-rc1 as a xen 32-bit pae domU the other day.
> Unfortunately, I didn't get very far very fast, as the domain just crashed
> immediately upon booting, without any direct feedback (I did have messages
> on the xen message buffer, which helped). This even with earlyprintk turned on.
>
> After a long, arduous journey, I managed to track this down to the following:
>
> ----------
> commit	551889a6e2a24a9c06fd453ea03b57b7746ffdc0
>
> x86: construct 32-bit boot time page tables in native format.
>
> Specifically the boot time page tables in a CONFIG_X86_PAE=y enabled
> kernel are in PAE format.
>
> early_ioremap is updated to use the standard page table accessors.
>
> Clear any mappings beyond max_low_pfn from the boot page tables in
> native_pagetable_setup_start because the initial mappings can extend
> beyond the range of physical memory and into the vmalloc area.
>
> Derived from patches by Eric Biederman and H. Peter Anvin.
>
> [ jeremy@goop.org: PAE swapper_pg_dir needs to be page-sized fix ]
> ----------
>
> However, to make life more interesting, just reverting this isn't quite
> enough to get us to the promised land. If we try, we find that although
> we do now start booting, we crash again a short way into the process.
>
> In a different manner though. Specifically, in early_ioremap_clear.
> Reverting the above commit /except/ for the changes to arch/x86/mm/ioremap.c
> gets everything working again.
>
> Well, except that we can't shutdown/reboot properly, but I've sent a patch
> for that in another email.
>
>
> I'm afraid i've no idea what needs to be done to get the change to work
> with xen, but i'm willing to try out any patches people come up with.
> Please cc me on any replies, as i'm not subscribed, thanks.

Hi,

Although I'm on vacation, I happened to download a recent copy of 
x86.git and found that it crashes early.  Here's a couple of patches to 
apply; I don't know if they apply to current git, but I hope it helps.

    J

--------------040007070409010408000207
Content-Type: text/x-patch;
 name="x86-fix-early_ioremap.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x86-fix-early_ioremap.patch"

Subject: x86/early_ioremap: don't assume we're using swapper_pg_dir

At the early stages of boot, before the kernel pagetable has been
fully initialized, a Xen kernel will still be running off the
Xen-provided pagetables rather than swapper_pg_dir[].  Therefore,
readback cr3 to determine the base of the pagetable rather than
assuming swapper_pg_dir[].

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

---
 arch/x86/mm/ioremap.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

===================================================================
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -265,7 +265,9 @@
 
 static inline pmd_t * __init early_ioremap_pmd(unsigned long addr)
 {
-	pgd_t *pgd = &swapper_pg_dir[pgd_index(addr)];
+	/* Don't assume we're using swapper_pg_dir at this point */
+	pgd_t *base = __va(read_cr3());
+	pgd_t *pgd = &base[pgd_index(addr)];
 	pud_t *pud = pud_offset(pgd, addr);
 	pmd_t *pmd = pmd_offset(pud, addr);
 

--------------040007070409010408000207
Content-Type: text/x-patch;
 name="xen-unpin-init_pt.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="xen-unpin-init_pt.patch"

Subject: xen: unpin initial Xen pagetable once we're finished with it

Unpin the Xen-provided pagetable once we've finished with it, so it
doesn't cause stray references which cause later swapper_pg_dir
pagetable updates to fail.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

---
 arch/x86/xen/enlighten.c |    4 ++++
 1 file changed, 4 insertions(+)

===================================================================
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -798,6 +798,10 @@
 	 * added to the table can be prepared properly for Xen.
 	 */
 	xen_write_cr3(__pa(base));
+
+	/* Unpin initial Xen pagetable */
+	pin_pagetable_pfn(MMUEXT_UNPIN_TABLE,
+			  PFN_DOWN(__pa(xen_start_info->pt_base)));
 }
 
 static __init void xen_pagetable_setup_done(pgd_t *base)

--------------040007070409010408000207--
