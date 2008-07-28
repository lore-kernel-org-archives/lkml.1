Return-Path: <linux-kernel-owner+w=401wt.eu-S1758264AbYG1Uls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758264AbYG1Uls (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 16:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752386AbYG1Ulk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 16:41:40 -0400
Received: from ackle.nomi.cz ([81.31.33.35]:47971 "EHLO ackle.nomi.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751752AbYG1Ulj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 16:41:39 -0400
Date: Mon, 28 Jul 2008 22:41:36 +0200
From: =?iso-8859-2?Q?Tom=E1=B9_Janou=B9ek?= <tomi@nomi.cz>
To: David Brownell <david-b@pacbell.net>
Cc: linux-kernel@vger.kernel.org,
       Alessandro Zummo <alessandro.zummo@towertech.it>
Subject: Re: [PATCH] rtc-dev: stop periodic interrupts on device release
Message-ID: <20080728204136.GA6683@nomi.cz>
References: <20080726154617.GA5613@notes.lisk.in> <200807261350.55524.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <200807261350.55524.david-b@pacbell.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

thanks for your insight about other RTC drivers. I have updated the
description somewhat.

On Sat, Jul 26, 2008 at 01:50:55PM -0700, David Brownell wrote:
> Hmm, I'd think that something like an rtc_dev_ioctl(PIE_OFF) would be
> preferable here ... so that it's not just UIE_EMUL logic which turns
> off the one-per-second update IRQs.

I think it'd be more consistent if the framework only called the rtc api
functions. Like: if the driver doesn't export an op for it and handles it in
the ioctl op, it itself should be responsible to clear the irq in its release
op. (I know there's no op for UIE, so we'd better add it instead of calling
ioctl in the framework's release function.) More explanation in the updated
patch desc.

---

From: Tomas Janousek <tomi@nomi.cz>
Date: Sat, 26 Jul 2008 16:23:36 +0100
Subject: [PATCH] rtc-dev: stop periodic interrupts on device release

Solves http://bugzilla.kernel.org/show_bug.cgi?id=11127

The old rtc.c driver did it and some drivers (like rtc-sh) do it in their
release function, though they should not -- because they should provide the
irq_set_state op and the rtc framework itself should care about it. This patch
makes it do so.

I am aware that some drivers, like rtc-sh, handle userspace PIE sets in their
ioctl op (instead of having the framework call the op), exporting the
irq_set_state op at the same time. The logic in rtc_irq_set_state should make
sure it doesn't matter and the driver should not need to care stopping periodic
interrupts in its release routine any more.

The correct way, in my opinion, should be this:
1) The driver provides the irq_set_state op and does not care closing the
   interrupts in its release op.
2) If the driver does not provide the op and handles PIE in the ioctl op, it's
   reponsible for closing them in its release op.
3) Something similar for other IRQs, like UIE -- if there's no in-kernel API
   like irq_set_state, handle it in ioctl and release ops. The framework will
   be responsible either for everything or for nothing.

Signed-off-by: Tomas Janousek <tomi@nomi.cz>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
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
+       rtc_irq_set_state(rtc, NULL, 0);
+
        if (rtc->ops->release)
                rtc->ops->release(rtc->dev.parent);
 
-- 
1.5.6


-- 
Tomá¹ Janou¹ek, a.k.a. Liskni_si, http://work.lisk.in/
