Return-Path: <linux-kernel-owner+w=401wt.eu-S1755072AbYJELCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072AbYJELCk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 07:02:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753328AbYJELCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 07:02:33 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:38061 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987AbYJELCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 07:02:32 -0400
Date: Sun, 5 Oct 2008 12:02:26 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: dmitry.torokhov@gmail.com, IvDoorn@gmail.com, hmh@hmh.eng.br
Cc: sitsofe@yahoo.com, linux-kernel@vger.kernel.org
Subject: [PATCH v3] rfkill-input doesn't work until 5 minutes after boot
Message-ID: <20081005110226.GB4087@srcf.ucam.org>
References: <20081004204342.GA29620@srcf.ucam.org> <20081005004334.GA31844@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081005004334.GA31844@srcf.ucam.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rfkill-input implements debounce as follows:

        if (time_after(jiffies, task->last + msecs_to_jiffies(200))) {

However, task->last is initialised to 0 while jiffies starts at -300*HZ. 
Any input within 5 minutes of kernel start is therefore ignored. Fix by 
initialising task->last correctly.

Signed-off-by: Matthew Garrett <mjg@redhat.com>

---

Document the requirement to initialise the struct.

diff --git a/net/rfkill/rfkill-input.c b/net/rfkill/rfkill-input.c
index e5b6955..6c7baa0 100644
--- a/net/rfkill/rfkill-input.c
+++ b/net/rfkill/rfkill-input.c
@@ -103,6 +103,8 @@ static void rfkill_schedule_toggle(struct rfkill_task *task)
 		.desired_state = RFKILL_STATE_UNBLOCKED,	\
 	}
 
+/* Remember to initialise these in rfkill_handler_init if you add any */
+
 static DEFINE_RFKILL_TASK(rfkill_wlan, RFKILL_TYPE_WLAN);
 static DEFINE_RFKILL_TASK(rfkill_bt, RFKILL_TYPE_BLUETOOTH);
 static DEFINE_RFKILL_TASK(rfkill_uwb, RFKILL_TYPE_UWB);
@@ -255,6 +257,11 @@ static struct input_handler rfkill_handler = {
 
 static int __init rfkill_handler_init(void)
 {
+	rfkill_wlan.last = jiffies - HZ/5;
+	rfkill_bt.last = jiffies - HZ/5;
+	rfkill_uwb.last = jiffies - HZ/5;
+	rfkill_wimax.last = jiffies - HZ/5;
+	rfkill_wwan.last = jiffies - HZ/5;
 	return input_register_handler(&rfkill_handler);
 }
 

-- 
Matthew Garrett | mjg59@srcf.ucam.org
