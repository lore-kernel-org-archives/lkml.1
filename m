Return-Path: <linux-kernel-owner+w=401wt.eu-S1754930AbYFRMwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930AbYFRMwv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 08:52:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753647AbYFRMwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 08:52:44 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51135 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752783AbYFRMwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 08:52:43 -0400
Date: Wed, 18 Jun 2008 14:52:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stefan Assmann <sassmann@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jon Masters <jonathan@jonmasters.org>, Olaf Dabrunz <od@suse.de>,
       LKML <linux-kernel@vger.kernel.org>, Ihno Krumreich <ihno@suse.de>,
       Sven Dietrich <sdietrich@suse.de>, Daniel Gollub <dgollub@suse.de>,
       Felix Foerster <ffoerster@suse.de>
Subject: Re: [PATCH 0/5] Boot IRQ quirks and rerouting [repost]
Message-ID: <20080618125227.GA20056@elte.hu>
References: <12131949173532-git-send-email-sassmann@suse.de> <20080618115819.GA13714@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080618115819.GA13714@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> * Stefan Assmann <sassmann@suse.de> wrote:
> 
> > These patches are against linux-2.6-tip, auto-x86-next.
> > 
> > The AMD/ATI and Broadcomm patches are not included yet, we're working 
> > on getting things ready for submission.
> > 
> > The patch for the bootirqquirk= parameter will be released later.
> 
> applied, thanks Stefan. I have created a new 
> tip/x86/pci-ioapic-boot-irq-quirks topic branch for this. Lets see how 
> these changes work out in practice.

-tip testing found the following build failure:

init/built-in.o: In function `nosmp':
main.c:(.init.text+0x14): undefined reference to `noioapicquirk'
main.c:(.init.text+0x1e): undefined reference to `noioapicreroute'
init/built-in.o: In function `maxcpus':
main.c:(.init.text+0x133): undefined reference to `noioapicquirk'
main.c:(.init.text+0x13d): undefined reference to `noioapicreroute'
arch/x86/kernel/built-in.o: In function `parse_noapic':
io_apic_32.c:(.init.text+0x7836): undefined reference to `noioapicquirk'
io_apic_32.c:(.init.text+0x7840): undefined reference to `noioapicreroute'

with this config:

  http://redhat.com/~mingo/misc/config-Wed_Jun_18_14_23_24_CEST_2008.bad

fixed via the patch below.

	Ingo

--------->
commit 7c01f5c8fc734cfbbdad3b389b88e1aa12c78e5b
Author: Ingo Molnar <mingo@elte.hu>
Date:   Wed Jun 18 14:47:09 2008 +0200

    x86: boot IRQ quirks and rerouting, fix
    
    fix:
    
    init/built-in.o: In function `nosmp':
    main.c:(.init.text+0x14): undefined reference to `noioapicquirk'
    main.c:(.init.text+0x1e): undefined reference to `noioapicreroute'
    init/built-in.o: In function `maxcpus':
    main.c:(.init.text+0x133): undefined reference to `noioapicquirk'
    main.c:(.init.text+0x13d): undefined reference to `noioapicreroute'
    arch/x86/kernel/built-in.o: In function `parse_noapic':
    io_apic_32.c:(.init.text+0x7836): undefined reference to `noioapicquirk'
    io_apic_32.c:(.init.text+0x7840): undefined reference to `noioapicreroute'
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/include/asm-x86/io_apic.h b/include/asm-x86/io_apic.h
index 5f68b1d..3086c26 100644
--- a/include/asm-x86/io_apic.h
+++ b/include/asm-x86/io_apic.h
@@ -157,8 +157,10 @@ extern int timer_through_8259;
 
 static inline void disable_ioapic_setup(void)
 {
+#ifdef CONFIG_PCI
 	noioapicquirk = 1;
 	noioapicreroute = -1;
+#endif
 	skip_ioapic_setup = 1;
 }
 
