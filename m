Return-Path: <linux-kernel-owner+w=401wt.eu-S1752290AbZGaGcJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290AbZGaGcJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 02:32:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751800AbZGaGcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 02:32:08 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:60867 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811AbZGaGcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 02:32:07 -0400
Date: Fri, 31 Jul 2009 08:32:03 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Takashi Iwai <tiwai@suse.de>
Cc: Johannes Berg <johannes@sipsolutions.net>, linuxppc-dev@ozlabs.org,
       alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 5/5] sound/aoa: Add kmalloc NULL tests
In-Reply-To: <s5hws5pid6u.wl%tiwai@suse.de>
Message-ID: <Pine.LNX.4.64.0907310831330.13462@ask.diku.dk>
References: <Pine.LNX.4.64.0907301610550.8734@ask.diku.dk>
 <1248963420.16129.0.camel@johannes.local> <Pine.LNX.4.64.0907301627260.8734@ask.diku.dk>
 <s5hws5pid6u.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Check that the result of kzalloc is not NULL before a dereference.

The semantic match that finds this problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
expression *x;
identifier f;
constant char *C;
@@

x = \(kmalloc\|kcalloc\|kzalloc\)(...);
... when != x == NULL
    when != x != NULL
    when != (x || ...)
(
kfree(x)
|
f(...,C,...,x,...)
|
*f(...,x,...)
|
*x->f
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 sound/aoa/core/gpio-pmf.c           |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/var/linuxes/linux-next/sound/aoa/core/gpio-pmf.c b/var/julia/linuxcopy/sound/aoa/core/gpio-pmf.c
index 5ca2220..1dd0c28 100644
--- a/var/linuxes/linux-next/sound/aoa/core/gpio-pmf.c
+++ b/var/julia/linuxcopy/sound/aoa/core/gpio-pmf.c
@@ -182,6 +182,10 @@ static int pmf_set_notify(struct gpio_runtime *rt,
 	if (!old && notify) {
 		irq_client = kzalloc(sizeof(struct pmf_irq_client),
 				     GFP_KERNEL);
+		if (!irq_client) {
+			err = -ENOMEM;
+			goto out_unlock;
+		}
 		irq_client->data = notif;
 		irq_client->handler = pmf_handle_notify_irq;
 		irq_client->owner = THIS_MODULE;
