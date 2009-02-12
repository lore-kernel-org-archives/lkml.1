Return-Path: <linux-kernel-owner+w=401wt.eu-S1761304AbZBLWXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761304AbZBLWXq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 17:23:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758471AbZBLWXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 17:23:38 -0500
Received: from smtp-out.google.com ([216.239.45.13]:15261 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756963AbZBLWXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 17:23:37 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=to:subject:cc:message-id:date:from:x-system-of-record;
	b=VucAU1hYhyxTvdMi0LdUukOp0CcOa8vC5/D/WAe/JTVz8n8Nuwn44r5lV/q6csHBn
	TTZTxFwGy/mfzTJdHZ9ow==
To: mbligh@google.com, tglx@linutronix.de
Subject: [PATCH] clockevents: avoid unnecessary reprograming of event timer
Cc: linux-kernel@vger.kernel.org
Message-Id: <20090212222326.394E121B187@localhost>
Date: Thu, 12 Feb 2009 14:23:25 -0800 (PST)
From: md@google.com (Michael Davidson)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Davidson <md@google.com>

Don't reprogram the event timer if it is already set to expire
at the correct time.

Signed-off-by: Michael Davidson <md@google.com>
---
--- linux-2.6.29-rc4.orig/kernel/time/clockevents.c	2009-02-12 13:13:24.000000000 -0800
+++ linux-2.6.29-rc4/kernel/time/clockevents.c	2009-02-12 13:25:42.525558000 -0800
@@ -103,6 +103,9 @@
 	if (delta <= 0)
 		return -ETIME;
 
+	if (ktime_equal(dev->next_event, expires))
+		return 0;
+
 	dev->next_event = expires;
 
 	if (dev->mode == CLOCK_EVT_MODE_SHUTDOWN)
