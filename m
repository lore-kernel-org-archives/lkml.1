Return-Path: <linux-kernel-owner+w=401wt.eu-S1755211Ab0A1Muw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211Ab0A1Muw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 07:50:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932204Ab0A1Muv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 07:50:51 -0500
Received: from ozlabs.org ([203.10.76.45]:36037 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753788Ab0A1Mut (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 07:50:49 -0500
Date: Thu, 28 Jan 2010 23:48:54 +1100
From: Anton Blanchard <anton@samba.org>
To: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org
Subject: [PATCH 1/2] percpu_counter: Make __percpu_counter_add an inline
 function on UP
Message-ID: <20100128124854.GF2996@kryten>
References: <20100118044142.GS12666@kryten>
 <tip-43f85eab1411905afe5db510fbf9841b516e7e6a@git.kernel.org>
 <661de9471001270534ve6f7bf0nb58ef58f9a6ff10e@mail.gmail.com>
 <20100127132212.cd43cd94.akpm@linux-foundation.org>
 <1264628600.4283.2080.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264628600.4283.2080.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Even though batch isn't used on UP, we may want to pass one in to keep the
SMP and UP code paths similar. Convert __percpu_counter_add to an inline
function so we wont get variable unused warnings if we do.
 
Signed-off-by: Anton Blanchard <anton@samba.org>
---

diff --git a/include/linux/percpu_counter.h b/include/linux/percpu_counter.h
index a7684a5..794662b 100644
--- a/include/linux/percpu_counter.h
+++ b/include/linux/percpu_counter.h
@@ -98,9 +98,6 @@ static inline void percpu_counter_set(struct percpu_counter *fbc, s64 amount)
 	fbc->count = amount;
 }
 
-#define __percpu_counter_add(fbc, amount, batch) \
-	percpu_counter_add(fbc, amount)
-
 static inline void
 percpu_counter_add(struct percpu_counter *fbc, s64 amount)
 {
@@ -109,6 +106,12 @@ percpu_counter_add(struct percpu_counter *fbc, s64 amount)
 	preempt_enable();
 }
 
+static inline void
+__percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch)
+{
+	percpu_counter_add(fbc, amount);
+}
+
 static inline s64 percpu_counter_read(struct percpu_counter *fbc)
 {
 	return fbc->count;
