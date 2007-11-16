Return-Path: <linux-kernel-owner+w=401wt.eu-S932312AbXKPM7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932312AbXKPM7R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 07:59:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758166AbXKPM7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 07:59:06 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33617 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758203AbXKPM7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 07:59:04 -0500
Date: Fri, 16 Nov 2007 13:58:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mark Lord <lkml@rtr.ca>, perex@perex.cz, Takashi Iwai <tiwai@suse.de>
Cc: Pavel Machek <pavel@ucw.cz>, Mark Lord <liml@rtr.ca>,
       Thomas Gleixner <tglx@linutronix.de>, len.brown@intel.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, rjw@sisk.pl,
       Len Brown <lenb@kernel.org>
Subject: [patch] snd hda suspend latency: shorten codec read
Message-ID: <20071116125824.GA28082@elte.hu>
References: <20071115181418.GA6603@ucw.cz> <473C825E.3030307@rtr.ca> <20071115193424.GA31691@elte.hu> <20071115193612.GA751@elte.hu> <473CC6D4.2010909@rtr.ca> <20071116055531.GA16273@elte.hu> <20071116071522.GA1453@elte.hu> <20071116082146.GA14685@elte.hu> <20071116112317.GA12724@elte.hu> <20071116124319.GA21978@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071116124319.GA21978@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


snd hda suspend latency goes down a second via the patch below.

	Ingo

------------->
Subject: snd hda suspend latency: shorten codec read
From: Ingo Molnar <mingo@elte.hu>

not sleeping for every codec read/write but doing a short udelay and
a conditional reschedule has cut suspend+resume latency by about 1
second on my T60.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 sound/pci/hda/hda_intel.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux/sound/pci/hda/hda_intel.c
===================================================================
--- linux.orig/sound/pci/hda/hda_intel.c
+++ linux/sound/pci/hda/hda_intel.c
@@ -555,7 +555,8 @@ static unsigned int azx_rirb_get_respons
 		}
 		if (!chip->rirb.cmds)
 			return chip->rirb.res; /* the last value */
-		schedule_timeout_uninterruptible(1);
+		udelay(10);
+		cond_resched();
 	} while (time_after_eq(timeout, jiffies));
 
 	if (chip->msi) {
