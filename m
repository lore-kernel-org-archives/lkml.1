Return-Path: <linux-kernel-owner+w=401wt.eu-S1752499AbYJVJdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499AbYJVJdi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 05:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754498AbYJVJdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 05:33:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38694 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754178AbYJVJdV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 05:33:21 -0400
Date: Wed, 22 Oct 2008 11:33:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Fisher <bug-track@fisher-privat.net>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Ricardo Cerqueira <v4l@cerqueira.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Hartmut Hackmann <hartmut.hackmann@t-online.de>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] saa7134: fix resource map sanity check conflict
Message-ID: <20081022093302.GE12453@elte.hu>
References: <1224340447.5325.4.camel@zwerg> <20081020205702.GI7829@linux-os.sc.intel.com> <1224570426.5287.1.camel@zwerg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224570426.5287.1.camel@zwerg>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexey Fisher <bug-track@fisher-privat.net> wrote:

> Thanks, suresh! this patch working for me. dmesg is attached.

thanks Alexey!

I've Cc:-ed the saa7134 developers - please pick up Suresh's fix below. 
A new debug check in ioremap() caught a bug in the saa7134 driver.

	Ingo

---------------->
>From afed66317accd2fdfeb57061102c20796fb9ff66 Mon Sep 17 00:00:00 2001
From: Suresh Siddha <suresh.b.siddha@intel.com>
Date: Mon, 20 Oct 2008 13:57:02 -0700
Subject: [PATCH] saa7134: fix resource map sanity check conflict

Impact: driver could possibly stomp on resources outside of its scope

Alexey Fisher reported:

> resource map sanity check conflict: 0xcfeff800 0xcff007ff 0xcfe00000
> 0xcfefffff PCI Bus 0000:01

BAR base is located in the middle of the 4K page and the hardcoded
size argument makes the request span two pages causing the conflict.

Fix the hard coded size argument in ioremap().

Reported-by: Alexey Fisher <bug-track@fisher-privat.net>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Tested-by: Alexey Fisher <bug-track@fisher-privat.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/media/video/saa7134/saa7134-core.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/saa7134/saa7134-core.c b/drivers/media/video/saa7134/saa7134-core.c
index b686bfa..0c13821 100644
--- a/drivers/media/video/saa7134/saa7134-core.c
+++ b/drivers/media/video/saa7134/saa7134-core.c
@@ -941,7 +941,8 @@ static int __devinit saa7134_initdev(struct pci_dev *pci_dev,
 		       dev->name,(unsigned long long)pci_resource_start(pci_dev,0));
 		goto fail1;
 	}
-	dev->lmmio = ioremap(pci_resource_start(pci_dev,0), 0x1000);
+	dev->lmmio = ioremap(pci_resource_start(pci_dev, 0),
+			     pci_resource_len(pci_dev, 0));
 	dev->bmmio = (__u8 __iomem *)dev->lmmio;
 	if (NULL == dev->lmmio) {
 		err = -EIO;

