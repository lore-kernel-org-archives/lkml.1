Return-Path: <linux-kernel-owner+w=401wt.eu-S1762787AbYGaAOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762787AbYGaAOw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 20:14:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756046AbYGaANu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 20:13:50 -0400
Received: from mx1.suse.de ([195.135.220.2]:38776 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762124AbYGaANs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 20:13:48 -0400
Date: Wed, 30 Jul 2008 16:58:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Victor <avictor.za@gmail.com>
Subject: [patch 27/62] rtc-at91rm9200: avoid spurious irqs
Message-ID: <20080730235848.GA12896@suse.de>
References: <20080730233050.332789722@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="rtc-at91rm9200-avoid-spurious-irqs.patch"
In-Reply-To: <20080730234915.GA12426@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26 -stable review patch.  If anyone has any objections, please let
us know.

------------------
From: David Brownell <dbrownell@users.sourceforge.net>

commit 449321b39f6c6ebfa15d6da24f134240bd51db29 upstream

This fixes kernel http://bugzilla.kernel.org/show_bug.cgi?id=11112 (bogus
RTC update IRQs reported) for rtc-at91rm9200 by scrubbing old IRQ status
before enabling IRQs.

It also removes nonfunctional periodic IRQ support from this driver;
only update IRQs are reported, or provided by the hardware.

I suspect some other RTCs probably have versions of #11112; it's easy to
overlook, since most non-RTC drivers don't care about spurious IRQs:
they're not reported to userspace.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Report-by: W Unruh <unruh@physics.ubc.ca>
Cc: Andrew Victor <avictor.za@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/rtc/rtc-at91rm9200.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

--- a/drivers/rtc/rtc-at91rm9200.c
+++ b/drivers/rtc/rtc-at91rm9200.c
@@ -175,8 +175,10 @@ static int at91_rtc_setalarm(struct devi
 		| BIN2BCD(tm.tm_mday) << 24
 		| AT91_RTC_DATEEN | AT91_RTC_MTHEN);
 
-	if (alrm->enabled)
+	if (alrm->enabled) {
+		at91_sys_write(AT91_RTC_SCCR, AT91_RTC_ALARM);
 		at91_sys_write(AT91_RTC_IER, AT91_RTC_ALARM);
+	}
 
 	pr_debug("%s(): %4d-%02d-%02d %02d:%02d:%02d\n", __func__,
 		at91_alarm_year, tm.tm_mon, tm.tm_mday, tm.tm_hour,
@@ -195,28 +197,22 @@ static int at91_rtc_ioctl(struct device 
 
 	pr_debug("%s(): cmd=%08x, arg=%08lx.\n", __func__, cmd, arg);
 
+	/* important:  scrub old status before enabling IRQs */
 	switch (cmd) {
 	case RTC_AIE_OFF:	/* alarm off */
 		at91_sys_write(AT91_RTC_IDR, AT91_RTC_ALARM);
 		break;
 	case RTC_AIE_ON:	/* alarm on */
+		at91_sys_write(AT91_RTC_SCCR, AT91_RTC_ALARM);
 		at91_sys_write(AT91_RTC_IER, AT91_RTC_ALARM);
 		break;
 	case RTC_UIE_OFF:	/* update off */
-	case RTC_PIE_OFF:	/* periodic off */
 		at91_sys_write(AT91_RTC_IDR, AT91_RTC_SECEV);
 		break;
 	case RTC_UIE_ON:	/* update on */
-	case RTC_PIE_ON:	/* periodic on */
+		at91_sys_write(AT91_RTC_SCCR, AT91_RTC_SECEV);
 		at91_sys_write(AT91_RTC_IER, AT91_RTC_SECEV);
 		break;
-	case RTC_IRQP_READ:	/* read periodic alarm frequency */
-		ret = put_user(AT91_RTC_FREQ, (unsigned long *) arg);
-		break;
-	case RTC_IRQP_SET:	/* set periodic alarm frequency */
-		if (arg != AT91_RTC_FREQ)
-			ret = -EINVAL;
-		break;
 	default:
 		ret = -ENOIOCTLCMD;
 		break;

-- 
