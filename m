Return-Path: <linux-kernel-owner+w=401wt.eu-S1758429AbZKYISW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758429AbZKYISW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 03:18:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752448AbZKYIST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 03:18:19 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:56547 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934553AbZKYISP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 03:18:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=GDCzMJA0GEf9K+L8ITxzZkgo1Rflbwq2ILCVtl5NpN6WPm5HYYUDeR9WPXGd1/vYlo
         3I4rn6gWiSvO9yWTbePj5StlnaJ93i/u+Wj2Yu5Pcw4zQzPQh8y0XEuWLshVUZJezcWs
         q6wvs1IIju2+2xBFkFGVi74hT9DMhHpPJQEIQ=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, linux-sh@vger.kernel.org, johnstul@us.ibm.com,
       lethal@linux-sh.org, Magnus Damm <magnus.damm@gmail.com>,
       tglx@linutronix.de
Date: Wed, 25 Nov 2009 17:12:55 +0900
Message-Id: <20091125081255.25416.85126.sendpatchset@rxone.opensource.se>
In-Reply-To: <20091125081235.25416.32481.sendpatchset@rxone.opensource.se>
References: <20091125081235.25416.32481.sendpatchset@rxone.opensource.se>
Subject: [PATCH 02/02] clocksource: Start CMT at clocksource resume
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Add code to start the CMT timer on clocksource resume.

This makes sure the timer is started during sysdev_resume().
Without this patch the clocksource may be read as suspended,
this after sysdev resume but before platform device resume.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 drivers/clocksource/sh_cmt.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- 0001/drivers/clocksource/sh_cmt.c
+++ work/drivers/clocksource/sh_cmt.c	2009-11-25 16:02:52.000000000 +0900
@@ -432,6 +432,13 @@ static void sh_cmt_clocksource_disable(s
 	sh_cmt_stop(cs_to_sh_cmt(cs), FLAG_CLOCKSOURCE);
 }
 
+static void sh_cmt_clocksource_resume(struct clocksource *cs)
+{
+	struct sh_cmt_priv *p = cs_to_sh_cmt(cs);
+
+	sh_cmt_start(p, FLAG_CLOCKSOURCE);
+}
+
 static int sh_cmt_register_clocksource(struct sh_cmt_priv *p,
 				       char *name, unsigned long rating)
 {
@@ -442,6 +449,7 @@ static int sh_cmt_register_clocksource(s
 	cs->read = sh_cmt_clocksource_read;
 	cs->enable = sh_cmt_clocksource_enable;
 	cs->disable = sh_cmt_clocksource_disable;
+	cs->resume = sh_cmt_clocksource_resume;
 	cs->mask = CLOCKSOURCE_MASK(sizeof(unsigned long) * 8);
 	cs->flags = CLOCK_SOURCE_IS_CONTINUOUS;
 	pr_info("sh_cmt: %s used as clock source\n", cs->name);
