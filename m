Return-Path: <linux-kernel-owner+w=401wt.eu-S1755789AbYJEAnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789AbYJEAnr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 20:43:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753875AbYJEAnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 20:43:39 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:53606 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754193AbYJEAni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 20:43:38 -0400
Date: Sun, 5 Oct 2008 01:43:34 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: dmitry.torokhov@gmail.com, IvDoorn@gmail.com, hmh@hmh.eng.br
Cc: sitsofe@yahoo.com, linux-kernel@vger.kernel.org
Subject: [PATCH v2] rfkill-input doesn't work until 5 minutes after boot
Message-ID: <20081005004334.GA31844@srcf.ucam.org>
References: <20081004204342.GA29620@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081004204342.GA29620@srcf.ucam.org>
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

Set the last event value at module load time, since otherwise we'll have 
a window of failure if someone loads the module in a few hundred million 
years. I look forward to being rewarded by the post-humans for caring so 
much about them.

diff --git a/net/rfkill/rfkill-input.c b/net/rfkill/rfkill-input.c
index e5b6955..86197bb 100644
--- a/net/rfkill/rfkill-input.c
+++ b/net/rfkill/rfkill-input.c
@@ -255,6 +255,11 @@ static struct input_handler rfkill_handler = {
 
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
