Return-Path: <linux-kernel-owner+w=401wt.eu-S1755558AbYFJHKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558AbYFJHKs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 03:10:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751872AbYFJHKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 03:10:38 -0400
Received: from mail37.messagelabs.com ([216.82.244.163]:54634 "EHLO
	mail37.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbYFJHKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 03:10:37 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-15.tower-37.messagelabs.com!1213081836!1970449!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.14]
Date: Tue, 10 Jun 2008 09:10:32 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: Magnus Damm <magnus.damm@gmail.com>
CC: Paul Mundt <lethal@linux-sh.org>, "Hans J. Koch" <hjk@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [PATCH] uio_pdrv: Unique IRQ Mode
Message-ID: <20080610071032.GB22814@digi.com>
References: <20080605090916.GA3198@local> <aec7e5c30806050246t248abc39vbc1e71d4475a0a0d@mail.gmail.com> <20080605112744.GB3198@local> <aec7e5c30806080319y7b9b6a89icacbfa67b117fb2b@mail.gmail.com> <20080608205455.GA3191@local> <aec7e5c30806081812m532882e0p7ad3ef9a74f53337@mail.gmail.com> <20080609084411.GA3223@local> <20080609090123.GA12080@linux-sh.org> <20080609123406.GB27803@digi.com> <aec7e5c30806092140s21cc8cbdtbaf69f864dd2bda7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aec7e5c30806092140s21cc8cbdtbaf69f864dd2bda7@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 10 Jun 2008 07:10:33.0238 (UTC) FILETIME=[12C7CB60:01C8CAC9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Magnus Damm wrote:
> Hi Uwe,
> 
> Thanks for your help.
> 
> On Mon, Jun 9, 2008 at 9:34 PM, Uwe Kleine-König
> <Uwe.Kleine-Koenig@digi.com> wrote:
> > Paul Mundt wrote:
> >>                                   [...] the constructive way forward
> >> seems to be to follow Uwe's suggestions and respin the patch.
> > Just to let you know: I'm willing to look on a new version.  And I like
> > "User IRQ Mode".
> 
> Sure, let's go with that name then.
> 
> But shall we really go down the path with separate exported functions?
> I think we discussed that earlier. Why I'm asking is that this adds
> extra complexity - function prototypes in header files,
> EXPORT_SYMBOL() stuff and more lines of code needed for each driver
> instance.
Well, at this point I agree with Hans that being explicit here is
preferable.

I think you can implement the handler and irqcontrol functions static
inline.  Then the need to statically compile uio goes away.  And if all
uio_pdrv devices are registered in the same .c file you don't even have
a (binary) size penalty.

> Isn't it enough to add a kconfig option for CONFIG_UIO_PDRV_USER_IRQ
> which depends on CONFIG_SUPERH (if we really want that) and wrap the
> code in CONFIG_UIO_PDRV_USER_IRQ?
No, I definitely don't like that.  Your last patch is completly
compatible with the current implementation.  It only uses a situation
(i.e. registering a uio_pdrv with no handler) a feature.  So
CONFIG_UIO_PDRV_USER_IRQ wouldn't break anything, only not having it.
So it should be enabled by default and then you don't need it.
(Note, this should not count as a +1 for implementing it without the
Kconfig symbol.)
 
> Let me know what you want and I'll respin the patch. Thanks!
... I started describing in detail my suggestion, but actually it's
easier to do the patch myself.  So here it comes.  Note it's not even
compile tested, but you should be able to get my intentions.

As a reply on this mail I will send a small cleanup patch that should
not conflict with any of the pending patches for uio.

Best regards
Uwe


From: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
Date: Tue, 10 Jun 2008 09:06:24 +0200
Subject: [PATCH] UIO: wip

Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
---
 include/linux/uio_driver.h |   33 +++++++++++++++++++++++++++++++++
 1 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/include/linux/uio_driver.h b/include/linux/uio_driver.h
index cdf338d..671a7a8 100644
--- a/include/linux/uio_driver.h
+++ b/include/linux/uio_driver.h
@@ -63,6 +63,7 @@ struct uio_info {
 	long			irq;
 	unsigned long		irq_flags;
 	void			*priv;
+	unsigned int		flags;
 	irqreturn_t (*handler)(int irq, struct uio_info *dev_info);
 	int (*mmap)(struct uio_info *info, struct vm_area_struct *vma);
 	int (*open)(struct uio_info *info, struct inode *inode);
@@ -92,4 +93,36 @@ extern void uio_event_notify(struct uio_info *info);
 #define UIO_MEM_LOGICAL	2
 #define UIO_MEM_VIRTUAL 3
 
+/* defines for uio_info->flags */
+#define UIO_FLAGS_IRQDISABLED 0
+
+static inline irqreturn_t uio_userirq_handler(int irq,
+		struct uio_info *dev_info)
+{
+	int ret;
+
+	if (likely(dev_info->irqcontrol)) {
+		ret = dev_info->irqcontrol(dev_info, 0);
+		if (ret) {
+			pr_warning("%s: failed to disable irq\n", __func__);
+			return IRQ_NONE;
+		} else
+			return IRQ_HANDLED;
+	} else
+		return IRQ_NONE;
+}
+
+static inline int uio_userirq_irqcontrol(struct uio_info *info, s32 irq_on)
+{
+	if (irq_on) {
+		if (test_and_clear_bit(UIO_FLAGS_IRQDISABLED, &info->flags))
+			enable_irq(info->irq);
+	} else {
+		if (!test_and_set_bit(UIO_FLAGS_IRQDISABLED, &info->flags))
+			disable_irq(info->irq);
+	}
+
+	return 0;
+}
+
 #endif /* _LINUX_UIO_DRIVER_H_ */
-- 
1.5.5.3


-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
