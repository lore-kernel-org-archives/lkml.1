Return-Path: <linux-kernel-owner+w=401wt.eu-S932911AbXJORnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932911AbXJORnr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 13:43:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758763AbXJORnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 13:43:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47692 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758298AbXJORng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 13:43:36 -0400
Date: Mon, 15 Oct 2007 19:43:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Michael Buesch <mb@bu3sch.de>
Cc: Al Viro <viro@ftp.linux.org.uk>, gregkh@suse.de,
       David Brownell <dbrownell@users.sourceforge.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-kernel@vger.kernel.org
Subject: [patch] usb: fix ssb_ohci_probe() build bug
Message-ID: <20071015174321.GA27428@elte.hu>
References: <20071014032948.GA25760@elte.hu> <20071014033549.GQ8181@ftp.linux.org.uk> <20071015105344.GA17028@elte.hu> <200710151458.54817.mb@bu3sch.de> <20071015135041.GB30221@elte.hu> <20071015173840.GA26109@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071015173840.GA26109@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> find attached another config that reproduces the build failure above.
> 
> i think the reason is this:
> 
> CONFIG_SSB=m
> CONFIG_USB_OHCI_HCD=y
> CONFIG_USB_OHCI_HCD_SSB=y

the patch below fixes this for me.

	Ingo

----------------------->
Subject: usb: fix ssb_ohci_probe() build bug
From: Ingo Molnar <mingo@elte.hu>

fix ssb_ohci_probe() build bug:

 drivers/built-in.o: In function `ssb_ohci_probe':
 ohci-hcd.c:(.text+0xbff39): undefined reference to `ssb_device_enable'
 ohci-hcd.c:(.text+0xbff6f): undefined reference to `ssb_admatch_base'
 ohci-hcd.c:(.text+0xbff8b): undefined reference to `ssb_admatch_size'
 ohci-hcd.c:(.text+0xbffe5): undefined reference to `ssb_device_disable'
 [...]

the reason was that this Kconfig combination was allowed:

 CONFIG_SSB=m
 CONFIG_USB_OHCI_HCD=y
 CONFIG_USB_OHCI_HCD_SSB=y

the fix is to require a modular USB_OHCI_HCD build when SSB is modular.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/usb/host/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/usb/host/Kconfig
===================================================================
--- linux.orig/drivers/usb/host/Kconfig
+++ linux/drivers/usb/host/Kconfig
@@ -156,7 +156,7 @@ config USB_OHCI_HCD_PCI
 
 config USB_OHCI_HCD_SSB
 	bool "OHCI support for Broadcom SSB OHCI core"
-	depends on USB_OHCI_HCD && SSB && EXPERIMENTAL
+	depends on USB_OHCI_HCD && (SSB = y || SSB = CONFIG_USB_OHCI_HCD) && EXPERIMENTAL
 	default n
 	---help---
 	  Support for the Sonics Silicon Backplane (SSB) attached
