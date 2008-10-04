Return-Path: <linux-kernel-owner+w=401wt.eu-S1754849AbYJDUoB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849AbYJDUoB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 16:44:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753168AbYJDUnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 16:43:53 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:51570 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbYJDUnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 16:43:52 -0400
Date: Sat, 4 Oct 2008 21:43:43 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: dmitry.torokhov@gmail.com, IvDoorn@gmail.com, hmh@hmh.eng.br
Cc: sitsofe@yahoo.com, linux-kernel@vger.kernel.org
Subject: [PATCH] rfkill-input doesn't work until 5 minutes after boot
Message-ID: <20081004204342.GA29620@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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

.27 material?

diff --git a/net/rfkill/rfkill-input.c b/net/rfkill/rfkill-input.c
index e5b6955..de75934 100644
--- a/net/rfkill/rfkill-input.c
+++ b/net/rfkill/rfkill-input.c
@@ -101,6 +101,7 @@ static void rfkill_schedule_toggle(struct rfkill_task *task)
 		.mutex = __MUTEX_INITIALIZER(n.mutex),		\
 		.lock = __SPIN_LOCK_UNLOCKED(n.lock),		\
 		.desired_state = RFKILL_STATE_UNBLOCKED,	\
+		.last = INITIAL_JIFFIES,			\
 	}
 
 static DEFINE_RFKILL_TASK(rfkill_wlan, RFKILL_TYPE_WLAN);

-- 
Matthew Garrett | mjg59@srcf.ucam.org
