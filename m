Return-Path: <linux-kernel-owner+w=401wt.eu-S1756467AbYJEVY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756467AbYJEVY4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 17:24:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754685AbYJEVYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 17:24:48 -0400
Received: from wr-out-0506.google.com ([64.233.184.228]:23297 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486AbYJEVYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 17:24:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Gj8gVbP126B8pZuf7uQq2K/2d9ooPC6DP5zuF5w0hgADAe3vhRvqZKU032muT7J9jH
         RMfbJYq003QVylQ+Z2NF2lxUpbRwClGoij2iWRgkSy/KCCPYBSCEg8Ux0YPC8TFMPeL2
         DHn7L2ZUWq81Lw5D3xJF6/dQqIZiXN6oHmmM0=
Date: Sun, 5 Oct 2008 17:24:39 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: IvDoorn@gmail.com, hmh@hmh.eng.br, sitsofe@yahoo.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] rfkill-input doesn't work until 5 minutes after boot
Message-ID: <20081005212432.GC11576@amd.corenet.prv>
References: <20081004204342.GA29620@srcf.ucam.org> <20081005004334.GA31844@srcf.ucam.org> <20081005110226.GB4087@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081005110226.GB4087@srcf.ucam.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew,

On Sun, Oct 05, 2008 at 12:02:26PM +0100, Matthew Garrett wrote:
> rfkill-input implements debounce as follows:
> 
>         if (time_after(jiffies, task->last + msecs_to_jiffies(200))) {
> 
> However, task->last is initialised to 0 while jiffies starts at -300*HZ. 
> Any input within 5 minutes of kernel start is therefore ignored. Fix by 
> initialising task->last correctly.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> 

I'd rather have something like below. It should probably go through
David's (networking) tree. since it is in net/.

-- 
Dmitry

Input: rfkill-input doesn't work until 5 minutes after boot

From: Matthew Garrett <mjg59@srcf.ucam.org>

rfkill-input implements debounce as follows:

        if (time_after(jiffies, task->last + msecs_to_jiffies(200))) {

However, task->last is initialised to 0 while jiffies starts at -300*HZ.
Any input within 5 minutes of kernel start is therefore ignored. Fix by
initialising task->last at module load.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 net/rfkill/rfkill-input.c |   28 ++++++++++++++++++----------
 1 files changed, 18 insertions(+), 10 deletions(-)


diff --git a/net/rfkill/rfkill-input.c b/net/rfkill/rfkill-input.c
index e5b6955..775c6ba 100644
--- a/net/rfkill/rfkill-input.c
+++ b/net/rfkill/rfkill-input.c
@@ -109,21 +109,24 @@ static DEFINE_RFKILL_TASK(rfkill_uwb, RFKILL_TYPE_UWB);
 static DEFINE_RFKILL_TASK(rfkill_wimax, RFKILL_TYPE_WIMAX);
 static DEFINE_RFKILL_TASK(rfkill_wwan, RFKILL_TYPE_WWAN);
 
+static struct rfkill_task *rfkill_tasks[] = {
+	&rfkill_wlan,
+	&rfkill_bt,
+	&rfkill_uwb,
+	&rfkill_wimax,
+	&rfkill_wwan,
+};
+
 static void rfkill_schedule_evsw_rfkillall(int state)
 {
+	int i;
+
 	/* EVERY radio type. state != 0 means radios ON */
 	/* handle EPO (emergency power off) through shortcut */
 	if (state) {
-		rfkill_schedule_set(&rfkill_wwan,
-				    RFKILL_STATE_UNBLOCKED);
-		rfkill_schedule_set(&rfkill_wimax,
-				    RFKILL_STATE_UNBLOCKED);
-		rfkill_schedule_set(&rfkill_uwb,
-				    RFKILL_STATE_UNBLOCKED);
-		rfkill_schedule_set(&rfkill_bt,
-				    RFKILL_STATE_UNBLOCKED);
-		rfkill_schedule_set(&rfkill_wlan,
-				    RFKILL_STATE_UNBLOCKED);
+		for (i = 0; i < ARRAY_SIZE(rfkill_tasks); i++)
+			rfkill_schedule_set(rfkill_tasks[i],
+					    RFKILL_STATE_UNBLOCKED);
 	} else
 		rfkill_schedule_epo();
 }
@@ -255,6 +258,11 @@ static struct input_handler rfkill_handler = {
 
 static int __init rfkill_handler_init(void)
 {
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(rfkill_tasks); i++)
+		rfkill_tasks[i]->last = jiffies - HZ / 5;
+
 	return input_register_handler(&rfkill_handler);
 }
 
