Return-Path: <linux-kernel-owner+w=401wt.eu-S1753394AbYLBCV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbYLBCV2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 21:21:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752863AbYLBCVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 21:21:20 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39609 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752829AbYLBCVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 21:21:19 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Regression from 2.6.26: Hibernation (possibly suspend) broken on Toshiba R500 (bisected)
Date: Tue, 2 Dec 2008 03:20:31 +0100
User-Agent: KMail/1.9.9
Cc: Greg KH <greg@kroah.com>, Ingo Molnar <mingo@elte.hu>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812020320.31876.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

For some time I've been having problems with resume from hibernation and
suspend on Toshiba Portege R500 I'm currently testing.  Initially I thought
that was a regression from 2.6.27, because some 2.6.27-based kernels appeared
to work correctly on this box, but today I realized that in fact 2.6.27-rc6
failed too and then I confirmed that the problem was also present in 2.6.27
and in all of the -stable 2.6.27.y kernels.  Still, I was unable to reproduce
the problem with the 2.6.27-rc3 kernel and that made me carry out bisection
between 2.6.27-rc3 and 2.6.27-rc6 that turned up the following commit of yours:

commit 5f17cfce5776c566d64430f543a289e5cfa4538b
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu Sep 4 01:33:59 2008 -0700

    PCI: fix pbus_size_mem() resource alignment for CardBus controllers

Following this, I applied the appended patch on top of the current mainline
and it appears to have fixed my hibernation/resume problems on this box
(at least, with the patch applied the box have survived ~20 hibernation/resume
and suspend/resume cycles in a row, which was not achievable with the mainline
without the patch).

The symptoms of the breakage are that sometimes the box hangs solid during
resume, sometimes it hangs but can be rebooted by pressing Alt-SysRq-b, and
sometimes it just powers off while resuming.  Still, it resumes correctly in
about 75% of cases and that made the issue very hard to debug.  [Interestingly
enough, it was not reproducible with snd_hda_intel unloaded, which made me
think it was related to the driver, but evidently it wasn't.]  Also, I'm sure
hibernation is affected, but recently there have been some other sources of
breakage of resume from suspend to RAM, so I'm not so sure to what extent it
is affected too.

Please let me know if you need debug information from the affected box.

Thanks,
Rafael


Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/setup-bus.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/pci/setup-bus.c
===================================================================
--- linux-2.6.orig/drivers/pci/setup-bus.c
+++ linux-2.6/drivers/pci/setup-bus.c
@@ -352,7 +352,7 @@ static int pbus_size_mem(struct pci_bus 
 				continue;
 			r_size = resource_size(r);
 			/* For bridges size != alignment */
-			align = resource_alignment(r);
+			align = (i < PCI_BRIDGE_RESOURCES) ? r_size : r->start;
 			order = __ffs(align) - 20;
 			if (order > 11) {
 				dev_warn(&dev->dev, "BAR %d bad alignment %llx: "
