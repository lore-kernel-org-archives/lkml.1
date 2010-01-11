Return-Path: <linux-kernel-owner+w=401wt.eu-S1752974Ab0AKVaF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974Ab0AKVaF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 16:30:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753958Ab0AKVaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 16:30:00 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:50852 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319Ab0AKV1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 16:27:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=HcQ/8tnkWfQu9rqoLHuQ0WIlnfsHmYNU7fbSMB/KdqmArfCTqWMjwwRRuxK6x06h9a
         ZuQnVatcZ/lpVgs4i+AUX6Ixq277B52E4WFM/XPnqhXdYX70IxLhYiaaccgvyU/5vFkg
         Dpdwf923UGJov8QHLN7VX4+3tqerItaYj/Zps=
From: John Kacur <jkacur@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Cc: Clark Williams <williams@redhat.com>, John Kacur <jkacur@redhat.com>
Subject: [PATCH 16/26] timer_stats: Convert to raw_spinlocks
Date: Mon, 11 Jan 2010 22:26:46 +0100
Message-Id: <1263245216-14754-17-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1263245216-14754-16-git-send-email-jkacur@redhat.com>
References: <1263245216-14754-1-git-send-email-jkacur@redhat.com>
 <1263245216-14754-2-git-send-email-jkacur@redhat.com>
 <1263245216-14754-3-git-send-email-jkacur@redhat.com>
 <1263245216-14754-4-git-send-email-jkacur@redhat.com>
 <1263245216-14754-5-git-send-email-jkacur@redhat.com>
 <1263245216-14754-6-git-send-email-jkacur@redhat.com>
 <1263245216-14754-7-git-send-email-jkacur@redhat.com>
 <1263245216-14754-8-git-send-email-jkacur@redhat.com>
 <1263245216-14754-9-git-send-email-jkacur@redhat.com>
 <1263245216-14754-10-git-send-email-jkacur@redhat.com>
 <1263245216-14754-11-git-send-email-jkacur@redhat.com>
 <1263245216-14754-12-git-send-email-jkacur@redhat.com>
 <1263245216-14754-13-git-send-email-jkacur@redhat.com>
 <1263245216-14754-14-git-send-email-jkacur@redhat.com>
 <1263245216-14754-15-git-send-email-jkacur@redhat.com>
 <1263245216-14754-16-git-send-email-jkacur@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert locks which cannot sleep in preempt-rt to raw_spinlocks.

See also 54852508231ef28058a88480b2f9ab9b859b0e38
Completes the conversion started in ecb49d1a639acbacfc3771cae5ec07bed5df3847

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 kernel/time/timer_stats.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/time/timer_stats.c b/kernel/time/timer_stats.c
index 2f3b585..30cb955 100644
--- a/kernel/time/timer_stats.c
+++ b/kernel/time/timer_stats.c
@@ -81,7 +81,7 @@ struct entry {
 /*
  * Spinlock protecting the tables - not taken during lookup:
  */
-static DEFINE_SPINLOCK(table_lock);
+static DEFINE_RAW_SPINLOCK(table_lock);
 
 /*
  * Per-CPU lookup locks for fast hash lookup:
@@ -188,7 +188,7 @@ static struct entry *tstat_lookup(struct entry *entry, char *comm)
 	prev = NULL;
 	curr = *head;
 
-	spin_lock(&table_lock);
+	raw_spin_lock(&table_lock);
 	/*
 	 * Make sure we have not raced with another CPU:
 	 */
@@ -215,7 +215,7 @@ static struct entry *tstat_lookup(struct entry *entry, char *comm)
 			*head = curr;
 	}
  out_unlock:
-	spin_unlock(&table_lock);
+	raw_spin_unlock(&table_lock);
 
 	return curr;
 }
-- 
1.6.5.2

