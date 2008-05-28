Return-Path: <linux-kernel-owner+w=401wt.eu-S1753334AbYE1M3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334AbYE1M3V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 08:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752071AbYE1M3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 08:29:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39706 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049AbYE1M3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 08:29:10 -0400
Date: Wed, 28 May 2008 14:28:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       xen-devel <xen-devel@lists.xensource.com>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       x86@kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: [bisected] Re: [PATCH 05 of 12] xen: add p2m mfn_list_list
Message-ID: <20080528122813.GA5502@elte.hu>
References: <patchbomb.1211550067@localhost> <a405e5f9ddf6f5f142ea.1211550072@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a405e5f9ddf6f5f142ea.1211550072@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> When saving a domain, the Xen tools need to remap all our mfns to 
> portable pfns.  In order to remap our p2m table, it needs to know 
> where all its pages are, so maintain the references to the p2m table 
> for it to use.

-tip tree auto-testing found the following early bootup hang:

-------------->
get_memcfg_from_srat: assigning address to rsdp
RSD PTR  v0 [Nvidia]
BUG: Int 14: CR2 ffd00040
     EDI 8092fbfe  ESI ffd00040  EBP 80b0aee8  ESP 80b0aed0
     EBX 000f76f0  EDX 0000000e  ECX 00000003  EAX ffd00040
     err 00000000  EIP 802c055a   CS 00000060  flg 00010006
Stack: ffd00040 80bc78d0 80b0af6c 80b1dbfe 8093d8ba 00000008 80b42810 80b4ddb4
       80b42842 00000000 80b0af1c 801079c8 808e724e 00000000 80b42871 802c0531
       00000100 00000000 0003fff0 80b0af40 80129999 00040100 00040100 00000000
Pid: 0, comm: swapper Not tainted 2.6.26-rc4-sched-devel.git #570
 [<802c055a>] ? strncmp+0x11/0x25
 [<80b1dbfe>] ? get_memcfg_from_srat+0xb4/0x568
 [<801079c8>] ? mcount_call+0x5/0x9
 [<802c0531>] ? strcmp+0xa/0x22
 [<80129999>] ? printk+0x38/0x3a
 [<80129999>] ? printk+0x38/0x3a
 [<8011b122>] ? memory_present+0x66/0x6f
 [<80b216b4>] ? setup_memory+0x13/0x40c
 [<80b16b47>] ? propagate_e820_map+0x80/0x97
 [<80b1622a>] ? setup_arch+0x248/0x477
 [<80129999>] ? printk+0x38/0x3a
 [<80b11759>] ? start_kernel+0x6e/0x2eb
 [<80b110fc>] ? i386_start_kernel+0xeb/0xf2
 =======================
<------

with this config:

   http://redhat.com/~mingo/misc/config-Wed_May_28_01_33_33_CEST_2008.bad

The thing is, the crash makes little sense at first sight. We crash on a 
benign-looking printk. The code around it got changed in -tip but 
checking those topic branches individually did not reproduce the bug.

Bisection led to this commit:

|   d5edbc1f75420935b1ec7e65df10c8f81cea82de is first bad commit
|   commit d5edbc1f75420935b1ec7e65df10c8f81cea82de
|   Author: Jeremy Fitzhardinge <jeremy@goop.org>
|   Date:   Mon May 26 23:31:22 2008 +0100
|
|   xen: add p2m mfn_list_list

Which is somewhat surprising, as on native hardware Xen client side 
should have little to no side-effects.

After some head scratching, it turns out the following happened: 
randconfig enabled the following Xen options:

  CONFIG_XEN=y
  CONFIG_XEN_MAX_DOMAIN_MEMORY=8
  # CONFIG_XEN_BLKDEV_FRONTEND is not set
  # CONFIG_XEN_NETDEV_FRONTEND is not set
  CONFIG_HVC_XEN=y
  # CONFIG_XEN_BALLOON is not set

which activated this piece of code in arch/x86/xen/mmu.c:

> @@ -69,6 +69,13 @@
>  	__attribute__((section(".data.page_aligned"))) =
>  		{ [ 0 ... TOP_ENTRIES - 1] = &p2m_missing[0] };
>  
> +/* Arrays of p2m arrays expressed in mfns used for save/restore */
> +static unsigned long p2m_top_mfn[TOP_ENTRIES]
> +	__attribute__((section(".bss.page_aligned")));
> +
> +static unsigned long p2m_top_mfn_list[TOP_ENTRIES / P2M_ENTRIES_PER_PAGE]
> +	__attribute__((section(".bss.page_aligned")));

The problem is, you must only put variables into .bss.page_aligned that 
have a _size_ that is _exactly_ page aligned. In this case the size of 
p2m_top_mfn_list is not page aligned:

 80b8d000 b p2m_top_mfn
 80b8f000 b p2m_top_mfn_list
 80b8f008 b softirq_stack
 80b97008 b hardirq_stack
 80b9f008 b bm_pte

So all subsequent variables get unaligned which, depending on luck, 
breaks the kernel in various funny ways. In this case what killed the 
kernel first was the misaligned bootmap pte page, resulting in that 
creative crash above.

Anyway, this was a fun bug to track down :-)

I think the moral is that .bss.page_aligned is a dangerous construct in 
its current form, and the symptoms of breakage are very non-trivial, so 
i think we need build-time checks to make sure all symbols in 
.bss.page_aligned are truly page aligned.

Sam, any ideas how to accomplish that best?

The Xen fix below gets the kernel booting again. I suspect we really 
need this list to stay in its separate page due to Xen assumptions, even 
though it's only 8 bytes large?

	Ingo

---
 arch/x86/xen/mmu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux/arch/x86/xen/mmu.c
===================================================================
--- linux.orig/arch/x86/xen/mmu.c
+++ linux/arch/x86/xen/mmu.c
@@ -73,7 +73,8 @@ static unsigned long *p2m_top[TOP_ENTRIE
 static unsigned long p2m_top_mfn[TOP_ENTRIES]
 	__attribute__((section(".bss.page_aligned")));
 
-static unsigned long p2m_top_mfn_list[TOP_ENTRIES / P2M_ENTRIES_PER_PAGE]
+static unsigned long p2m_top_mfn_list[
+			PAGE_ALIGN(TOP_ENTRIES / P2M_ENTRIES_PER_PAGE)]
 	__attribute__((section(".bss.page_aligned")));
 
 static inline unsigned p2m_top_index(unsigned long pfn)
