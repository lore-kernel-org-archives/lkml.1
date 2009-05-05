Return-Path: <linux-kernel-owner+w=401wt.eu-S1757597AbZEEQTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757597AbZEEQTe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 12:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754834AbZEEQSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 12:18:11 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50002 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754316AbZEEQSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 12:18:09 -0400
Message-Id: <20090505155437.022272933@chello.nl>
References: <20090505155020.309162852@chello.nl>
User-Agent: quilt/0.46-1
Date: Tue, 05 May 2009 17:50:23 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 3/7] perf_counter: ioctl(PERF_COUNTER_IOC_RESET)
Content-Disposition: inline; filename=perf_counter-reset.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a way to reset an existing counter.

Similar to read() it doesn't collapse pending child counters.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_counter.h |    1 +
 kernel/perf_counter.c        |    8 ++++++++
 2 files changed, 9 insertions(+)

Index: linux-2.6/include/linux/perf_counter.h
===================================================================
--- linux-2.6.orig/include/linux/perf_counter.h
+++ linux-2.6/include/linux/perf_counter.h
@@ -160,6 +160,7 @@ struct perf_counter_hw_event {
 #define PERF_COUNTER_IOC_ENABLE		_IO ('$', 0)
 #define PERF_COUNTER_IOC_DISABLE	_IO ('$', 1)
 #define PERF_COUNTER_IOC_REFRESH	_IOW('$', 2, u32)
+#define PERF_COUNTER_IOC_RESET		_IO ('$', 3)
 
 /*
  * Structure of the page that can be mapped via mmap
Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -1288,6 +1288,11 @@ static unsigned int perf_poll(struct fil
 	return events;
 }
 
+static void perf_counter_reset(struct perf_counter *counter)
+{
+	atomic_set(&counter->count, 0);
+}
+
 static long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct perf_counter *counter = file->private_data;
@@ -1303,6 +1308,9 @@ static long perf_ioctl(struct file *file
 	case PERF_COUNTER_IOC_REFRESH:
 		perf_counter_refresh(counter, arg);
 		break;
+	case PERF_COUNTER_IOC_RESET:
+		perf_counter_reset(counter);
+		break;
 	default:
 		err = -ENOTTY;
 	}

-- 

