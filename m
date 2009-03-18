Return-Path: <linux-kernel-owner+w=401wt.eu-S1755683AbZCRCrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683AbZCRCrV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 22:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753884AbZCRCrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 22:47:12 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:50660 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746AbZCRCrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 22:47:11 -0400
Date: Wed, 18 Mar 2009 11:47:04 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [Patch] Fix the possibility of insane return value of hpet_calibrate() against SMI. (take 2)
Cc: Clemens Ladisch <clemens@ladisch.de>,
       Linux Kernel ML <linux-kernel@vger.kernel.org>, robert.picco@hp.com,
       venkatesh.pallipadi@intel.com, vojtech@suse.cz, mingo@redhat.com
In-Reply-To: <20090318094346.7BA9.E1E9C6FF@jp.fujitsu.com>
References: <49BFA1D7.8020302@windriver.com> <20090318094346.7BA9.E1E9C6FF@jp.fujitsu.com>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20090318113948.7BAD.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.01 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> > >>> Each calibration of this has 1 milli second.
> > >>> Do you think 5 msec is too long?
> > >>>       
> > >> This shouldn't matter when booting.  Anyway, I think it's possible to
> > >> increase TICK_CALIBRATE without losing too much accuracy.
> > >>     
> > >
> > > Hmm. If the person who is trying to reduce boot time for fastboot dislikes this impact,
> > > then I'll try Vojtech-san's way.
> > >   
> > 
> > That probably makes sense -- if it is extremely rare, and if you get two
> > values that are the same (within some small delta) then you probably
> > are 99.99% confident that you have the right data.
> 
> Ok. I'll make it.
> 
> Thanks for your comment.

Here is updated version.

--------

hpet_calibrate() has a possibility of miss-calibration due to SMI.
If SMI interrupts in the while loop of calibration, then return value
will be big. This change calibrates until stabilizing by the return
value with a small value.


Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>


---
 drivers/char/hpet.c |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

Index: hpet_test/drivers/char/hpet.c
===================================================================
--- hpet_test.orig/drivers/char/hpet.c	2009-03-12 15:47:45.000000000 +0900
+++ hpet_test/drivers/char/hpet.c	2009-03-18 11:12:42.000000000 +0900
@@ -713,7 +713,7 @@
  */
 #define	TICK_CALIBRATE	(1000UL)
 
-static unsigned long hpet_calibrate(struct hpets *hpetp)
+static unsigned long __hpet_calibrate(struct hpets *hpetp)
 {
 	struct hpet_timer __iomem *timer = NULL;
 	unsigned long t, m, count, i, flags, start;
@@ -750,6 +750,25 @@
 	return (m - start) / i;
 }
 
+static unsigned long hpet_calibrate(struct hpets *hpetp)
+{
+	unsigned long ret = ~0UL, tmp;
+
+	/*
+	 * Try to calibrate until return value becomes stable small value.
+	 * If SMI interruption occurs in calibration loop, the return value
+	 * will be big. This avoids its impact.
+	 */
+	do {
+		tmp = __hpet_calibrate(hpetp);
+		if (ret <= tmp)
+			break;
+		ret = tmp;
+	} while (1);
+
+	return ret;
+}
+
 int hpet_alloc(struct hpet_data *hdp)
 {
 	u64 cap, mcfg;

-- 
Yasunori Goto 


