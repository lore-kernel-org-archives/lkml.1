Return-Path: <linux-kernel-owner+w=401wt.eu-S1753316AbXFOFxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbXFOFxT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 01:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752003AbXFOFxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 01:53:10 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:37307 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063AbXFOFxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 01:53:09 -0400
Date: Fri, 15 Jun 2007 09:52:53 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org
Subject: Re: w1_therm_read_bin: suspicious usage of flush_signals()
Message-ID: <20070615055253.GA12796@2ka.mipt.ru>
References: <20070615042856.GA22786@2ka.mipt.ru> <20070615051007.524434D059F@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070615051007.524434D059F@magilla.localdomain>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Fri, 15 Jun 2007 09:52:58 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2007 at 10:10:07PM -0700, Roland McGrath (roland@redhat.com) wrote:
> > Well, it can be uninterruptible sleep, but why?
> > It is not allowed to return to userspace until transaction is completed,
> > so having uninterruptible sleep will result in exactly same lost of
> > signals.
> 
> Delay, not loss.

Yep, you are right. I missed that state checks are performed after
signal was queued.

I've chcked other usage of signals in w1 and they are only related to
the control thread and unloading time when signals are used only to 
indicate that another check must be performed.
This patch resolves the issue with reading from temperature sensor.

Thanks for pointing to that issue.

Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

diff --git a/drivers/w1/slaves/w1_therm.c b/drivers/w1/slaves/w1_therm.c
index 732db47..1a6937d 100644
--- a/drivers/w1/slaves/w1_therm.c
+++ b/drivers/w1/slaves/w1_therm.c
@@ -191,11 +191,7 @@ static ssize_t w1_therm_read_bin(struct kobject *kobj, char *buf, loff_t off, si
 
 			w1_write_8(dev, W1_CONVERT_TEMP);
 
-			while (tm) {
-				tm = msleep_interruptible(tm);
-				if (signal_pending(current))
-					flush_signals(current);
-			}
+			msleep(tm);
 
 			if (!w1_reset_select_slave(sl)) {
 


Signed-

-- 
	Evgeniy Polyakov
