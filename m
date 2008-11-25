Return-Path: <linux-kernel-owner+w=401wt.eu-S1752899AbYKYN3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899AbYKYN3q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 08:29:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750837AbYKYN3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 08:29:37 -0500
Received: from rv-out-0506.google.com ([209.85.198.238]:33215 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbYKYN3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 08:29:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=bCluSHWbHbU7w/XcNzCm251qRgv7W9OoFVokDqdLUpurP5YSq0THlXhflne+FIbtmP
         9Ag1UBx7hPN2h2xLy/kPPDHLf+JZqmxZhia4avi0mvmNuCw2lTg2X3HbNPbzCDF9NiFc
         MNb5/reWQi6km659nMYdVcYQLqmwAnGXTuDIs=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, lethal@linux-sh.org, johnstul@us.ibm.com,
       magnus.damm@gmail.com, mingo@redhat.com,
       Magnus Damm <magnus.damm@gmail.com>, tglx@linutronix.de
Date: Tue, 25 Nov 2008 22:28:23 +0900
Message-Id: <20081125132823.8698.83248.sendpatchset@rx1.opensource.se>
Subject: [RFC] Reentrant clock sources
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

Is there any special reason behind the non-reentrant clock source
code? I'm writing some timer help code and getting the struct
clocksource as argument to the callbacks would make the code much
cleaner and better.

Extending the callbacks to be able to start and stop clock sources
for improved power management would be good too in my opinion.
Any thoughts?

I realize that there are quite a few clock source drivers
that need to be modified, any recommendation on which tree
to do it against and how to split up the patch? Thanks.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 include/linux/clocksource.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- 0001/include/linux/clocksource.h
+++ work/include/linux/clocksource.h	2008-11-25 21:07:13.000000000 +0900
@@ -61,14 +61,14 @@ struct clocksource {
 	char *name;
 	struct list_head list;
 	int rating;
-	cycle_t (*read)(void);
+	cycle_t (*read)(struct clocksource *cs);
 	cycle_t mask;
 	u32 mult;
 	u32 mult_orig;
 	u32 shift;
 	unsigned long flags;
-	cycle_t (*vread)(void);
-	void (*resume)(void);
+	cycle_t (*vread)(struct clocksource *cs);
+	void (*resume)(struct clocksource *cs);
 #ifdef CONFIG_IA64
 	void *fsys_mmio;        /* used by fsyscall asm code */
 #define CLKSRC_FSYS_MMIO_SET(mmio, addr)      ((mmio) = (addr))
@@ -170,7 +170,7 @@ static inline u32 clocksource_hz2mult(u3
  */
 static inline cycle_t clocksource_read(struct clocksource *cs)
 {
-	return cs->read();
+	return cs->read(cs);
 }
 
 /**
