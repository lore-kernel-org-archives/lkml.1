Return-Path: <linux-kernel-owner+w=401wt.eu-S1753139AbYGYU1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139AbYGYU1F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 16:27:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751237AbYGYU0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 16:26:54 -0400
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:30504 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751223AbYGYU0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 16:26:53 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=UQ+t+Wr1inTDcuGa04xW56lFrL5ti6n040VZDfBqrKFRHhfTsk2N40uZfrNGb0m/z2TN2z9Vlk3A6w34nnUwXVXSgS1vbCn9grPZ92L9tkmW/rzi+CWhxKvu/sN4rhvAgWe8bJ3gZgAScSXLcJVmGSYSIJ+NUq/RoC8uAOyMpaY=  ;
X-YMail-OSG: 6br4onwVM1lKUlhhdhDT5x1gSLt_TKgTohlwMJmcU_uxAdbrWjTWEiUPCb9vOv1y16h.ychXnwkjpPFo2_SFaViIYMTemDEdvRXzIWOQHxb6611tlR.OR_h3rox3OGxIc.E-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org
Subject: [patch 2.6.26-git] pm selftest:  rtc paranoia
Date: Fri, 25 Jul 2008 13:26:51 -0700
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807251326.51987.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Cope with a quirk of some RTCs (notably ACPI ones) which
aren't guaranteed to implement oneshot behavior when they
woke the system from sleeep:  forcibly disable the alarm,
just in case.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 kernel/power/main.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/kernel/power/main.c	2008-07-22 16:38:32.000000000 -0700
+++ b/kernel/power/main.c	2008-07-22 16:39:15.000000000 -0700
@@ -635,6 +635,13 @@ static void __init test_wakealarm(struct
 	}
 	if (status < 0)
 		printk(err_suspend, status);
+
+	/* Some platforms can't detect that the alarm triggered the
+	 * wakeup, or (accordingly) disable it after it afterwards.
+	 * It's supposed to give oneshot behavior; cope.
+	 */
+	alm.enabled = false;
+	rtc_set_alarm(rtc, &alm);
 }
 
 static int __init has_wakealarm(struct device *dev, void *name_ptr)
