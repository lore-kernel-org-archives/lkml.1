Return-Path: <linux-kernel-owner+w=401wt.eu-S1754214AbYH1O6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214AbYH1O6d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 10:58:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752884AbYH1O6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 10:58:24 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40319 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830AbYH1O6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 10:58:23 -0400
Subject: Re: [BUG] linux-next: Tree for August 26 - Badness at
	kernel/notifier.c:25
From: David Woodhouse <dwmw2@infradead.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>, linuxppc-dev@ozlabs.org,
       linux-next@vger.kernel.org, mingo@elte.hu
In-Reply-To: <1219933410.7107.296.camel@pmac.infradead.org>
References: <20080826184008.6be39f19.sfr@canb.auug.org.au>
	 <48B44B2D.8070809@linux.vnet.ibm.com> <48B46610.1010809@linux.intel.com>
	 <48B53695.3020703@linux.vnet.ibm.com> <48B55B16.7060804@linux.intel.com>
	 <20080828003308.400038e0.sfr@canb.auug.org.au>
	 <20080828003821.d29d2a03.sfr@canb.auug.org.au>
	 <1219933410.7107.296.camel@pmac.infradead.org>
Content-Type: text/plain
Date: Thu, 28 Aug 2008 15:55:07 +0100
Message-Id: <1219935307.7107.302.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-08-28 at 15:23 +0100, David Woodhouse wrote:
> On Thu, 2008-08-28 at 00:38 +1000, Stephen Rothwell wrote:
> > Hi Arjan,
> > 
> > On Thu, 28 Aug 2008 00:33:08 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > >
> > > The original reported trace was during setup_system which is very early in
> > > the boot.
> > 
> > But, of course, that version didn't have the necessary extra dereference
> > of the function address ...
> > 
> > And the later debug patch did not check the address at register time,
> > only at notify time.
> > 
> > The later trace also looks to be early in the boot.
> 
> It's isa_bridge_notify(), which is neither within _[se]text nor
> _[se]inittext, so the core_kernel_text() function disavows it.
> 
> Where are __devinit functions supposed to end up?

The TEXT_TEXT macro defined in <asm-generic/vmlinux.lds.h> should get
this right... but we don't use it. Is there any particular reason for
that, or should we....

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>

--- linux-2.6.26.ppc64/arch/powerpc/kernel/vmlinux.lds.S~	2008-07-13 22:51:29.000000000 +0100
+++ linux-2.6.26.ppc64/arch/powerpc/kernel/vmlinux.lds.S	2008-08-28 15:39:14.000000000 +0100
@@ -35,10 +35,11 @@ SECTIONS
 		ALIGN_FUNCTION();
 		*(.text.head)
 		_text = .;
-		*(.text .fixup .text.init.refok .exit.text.refok)
+		TEXT_TEXT
 		SCHED_TEXT
 		LOCK_TEXT
 		KPROBES_TEXT
+		*(.fixup)
 
 #ifdef CONFIG_PPC32
 		*(.got1)

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



