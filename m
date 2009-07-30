Return-Path: <linux-kernel-owner+w=401wt.eu-S1752004AbZG3Rkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004AbZG3Rkf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 13:40:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751370AbZG3Rkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 13:40:35 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:48647 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbZG3Rke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 13:40:34 -0400
Date: Thu, 30 Jul 2009 19:40:30 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: linux-kernel@vger.kernel.org, Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>,
       Matt Reimer <mreimer@vpop.net>, Anton Vorontsov <cbou@mail.ru>
Subject: Re: [PATCH] ds2760: fix integer overflow for time_to_empty_now
Message-ID: <20090730174030.GY19257@buzzloop.caiaq.de>
References: <1248441573-32712-1-git-send-email-daniel@caiaq.de> <20090730140041.GA25759@oksana.dev.rtsoft.ru> <20090730141259.GV19257@buzzloop.caiaq.de> <20090730142616.GA797@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090730142616.GA797@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 30, 2009 at 06:26:16PM +0400, Anton Vorontsov wrote:
> > > Hm... "(di->current_uA / 100L)" might result to 0, so you'll get
> > > div by zero. Removing the parenthesis will help.
> > 
> > Hmm, no, then it gets the precedence wrong.
> 
> Ah.
> 
> > But checking for values >=
> > 100 of current_uA helps. Thanks for spotting this.
> 
> Yeah, that'll be fine indeed.

Just wanted to make sure you noticed that there was a new patch attached
to this mail :) I copied it again here.

Daniel

>From c60e23e2ba6667bec882338bfe3cb12304ee1ab6 Mon Sep 17 00:00:00 2001
From: Daniel Mack <daniel@caiaq.de>
Date: Fri, 24 Jul 2009 15:08:11 +0200
Subject: [PATCH] ds2760: fix integer overflow for time_to_empty_now

On the device we're currently developing, battery sizes of ~2.8Ah and
current flow of ~600mA are typical.

With that values, the life_sec computation overflows due to the
multiplication by 3600.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>
Cc: Matt Reimer <mreimer@vpop.net>
Cc: Anton Vorontsov <cbou@mail.ru>

Signed-off-by: Daniel Mack <daniel@caiaq.de>
---
 drivers/power/ds2760_battery.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/power/ds2760_battery.c b/drivers/power/ds2760_battery.c
index d545fee..2ef29dd 100644
--- a/drivers/power/ds2760_battery.c
+++ b/drivers/power/ds2760_battery.c
@@ -211,9 +211,9 @@ static int ds2760_battery_read_status(struct ds2760_device_info *di)
 	if (di->rem_capacity > 100)
 		di->rem_capacity = 100;
 
-	if (di->current_uA)
-		di->life_sec = -((di->accum_current_uAh - di->empty_uAh) *
-				 3600L) / di->current_uA;
+	if (di->current_uA >= 100L)
+		di->life_sec = -((di->accum_current_uAh - di->empty_uAh) * 36L)
+					/ (di->current_uA / 100L);
 	else
 		di->life_sec = 0;
 
-- 
1.6.3.3

