Return-Path: <linux-kernel-owner+w=401wt.eu-S1757902AbZEESfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757902AbZEESfY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 14:35:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756198AbZEESet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 14:34:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:58293 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754415AbZEESes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 14:34:48 -0400
Date: Tue, 5 May 2009 18:34:12 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20090505155437.022272933@chello.nl>
References: <20090505155437.022272933@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: add ioctl(PERF_COUNTER_IOC_RESET)
Message-ID: <tip-6de6a7b95705b859b61430fa3afa1403034eb3e6@git.kernel.org>
Git-Commit-ID: 6de6a7b95705b859b61430fa3afa1403034eb3e6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 05 May 2009 18:34:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6de6a7b95705b859b61430fa3afa1403034eb3e6
Gitweb:     http://git.kernel.org/tip/6de6a7b95705b859b61430fa3afa1403034eb3e6
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 5 May 2009 17:50:23 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 5 May 2009 20:18:31 +0200

perf_counter: add ioctl(PERF_COUNTER_IOC_RESET)

Provide a way to reset an existing counter - this eases PAPI
libraries around perfcounters.

Similar to read() it doesn't collapse pending child counters.

[ Impact: new perfcounter fd ioctl method to reset counters ]

Suggested-by: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <20090505155437.022272933@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |    1 +
 kernel/perf_counter.c        |    8 ++++++++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 17b6310..0fcbf34 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -160,6 +160,7 @@ struct perf_counter_hw_event {
 #define PERF_COUNTER_IOC_ENABLE		_IO ('$', 0)
 #define PERF_COUNTER_IOC_DISABLE	_IO ('$', 1)
 #define PERF_COUNTER_IOC_REFRESH	_IOW('$', 2, u32)
+#define PERF_COUNTER_IOC_RESET		_IO ('$', 3)
 
 /*
  * Structure of the page that can be mapped via mmap
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index ba5e921..6e6834e 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1288,6 +1288,11 @@ static unsigned int perf_poll(struct file *file, poll_table *wait)
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
@@ -1303,6 +1308,9 @@ static long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case PERF_COUNTER_IOC_REFRESH:
 		perf_counter_refresh(counter, arg);
 		break;
+	case PERF_COUNTER_IOC_RESET:
+		perf_counter_reset(counter);
+		break;
 	default:
 		err = -ENOTTY;
 	}
