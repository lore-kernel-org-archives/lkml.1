Return-Path: <linux-kernel-owner+w=401wt.eu-S1756533AbYGZQQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533AbYGZQQf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 12:16:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752779AbYGZQQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 12:16:28 -0400
Received: from ackle.nomi.cz ([81.31.33.35]:59767 "EHLO ackle.nomi.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752707AbYGZQQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 12:16:28 -0400
X-Greylist: delayed 1635 seconds by postgrey-1.27 at vger.kernel.org; Sat, 26 Jul 2008 12:16:28 EDT
Date: Sat, 26 Jul 2008 16:46:17 +0100
From: Tomas Janousek <tomi@nomi.cz>
To: linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>,
       Alessandro Zummo <alessandro.zummo@towertech.it>
Subject: [PATCH] rtc-dev: stop periodic interrupts on device release
Message-ID: <20080726154617.GA5613@notes.lisk.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Solves http://bugzilla.kernel.org/show_bug.cgi?id=11127

The old rtc.c driver did it, some drivers (like rtc-sh) do it in their release
function too, but rtc-cmos does not -- because it provides the irq_set_state
op -- so the rtc framework itself should care about it. This patch makes it do
so.

I am aware that some drivers, like rtc-sh, handle userspace PIE sets in their
ioctl op, exporting the irq_set_state op at the same time. The logic in
rtc_irq_set_state should make sure it doesn't matter and the driver should not
need to care stopping periodic interrupts in its release routine any more.
I did not look at other drivers though.

Signed-off-by: Tomas Janousek <tomi@nomi.cz>
Cc: Alessandro Zummo <alessandro.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
---
 drivers/rtc/rtc-dev.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/rtc/rtc-dev.c b/drivers/rtc/rtc-dev.c
index 90dfa0d..6fafa62 100644
--- a/drivers/rtc/rtc-dev.c
+++ b/drivers/rtc/rtc-dev.c
@@ -408,6 +408,8 @@ static int rtc_dev_release(struct inode *inode, struct file *file)
 #ifdef CONFIG_RTC_INTF_DEV_UIE_EMUL
 	clear_uie(rtc);
 #endif
+	rtc_irq_set_state(rtc, NULL, 0);
+
 	if (rtc->ops->release)
 		rtc->ops->release(rtc->dev.parent);
 
-- 
1.5.6


-- 
Tomáš Janoušek, a.k.a. Liskni_si, http://work.lisk.in/
