Return-Path: <linux-kernel-owner+w=401wt.eu-S1755394AbZKUNoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394AbZKUNoz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 08:44:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754788AbZKUNoy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 08:44:54 -0500
Received: from hera.kernel.org ([140.211.167.34]:32800 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754761AbZKUNow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 08:44:52 -0500
Date: Sat, 21 Nov 2009 13:44:14 GMT
From: tip-bot for Stephane Eranian <eranian@gmail.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       eranian@gmail.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, eranian@gmail.com, mingo@elte.hu
In-Reply-To: <1256302576-6169-1-git-send-email-eranian@gmail.com>
References: <20091120212509.344964101@chello.nl>,
	<1256302576-6169-1-git-send-email-eranian@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf_events: Fix default watermark calculation
Message-ID: <tip-8904b18046c2f050107f6449e887e7c1142b9ab9@git.kernel.org>
Git-Commit-ID: 8904b18046c2f050107f6449e887e7c1142b9ab9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8904b18046c2f050107f6449e887e7c1142b9ab9
Gitweb:     http://git.kernel.org/tip/8904b18046c2f050107f6449e887e7c1142b9ab9
Author:     Stephane Eranian <eranian@gmail.com>
AuthorDate: Fri, 20 Nov 2009 22:19:57 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 21 Nov 2009 14:11:41 +0100

perf_events: Fix default watermark calculation

This patch fixes the default watermark value for the sampling
buffer. With the existing calculation (watermark =
max(PAGE_SIZE, max_size / 2)), no notification was ever received
when the buffer was exactly 1 page. This was because you would
never cross the threshold (there is no partial samples).

In certain configuration, there was no possibilty detecting the
problem because there was not enough space left to store the
LOST record.In fact, there may be a more generic problem here.
The kernel should ensure that there is alaways enough space to
store one LOST record.

This patch sets the default watermark to half the buffer size.
With such limit, we are guaranteed to get a notification even
with a single page buffer assuming no sample is bigger than a
page.

Signed-off-by: Stephane Eranian <eranian@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <20091120212509.344964101@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
LKML-Reference: <1256302576-6169-1-git-send-email-eranian@gmail.com>
---
 kernel/perf_event.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 3ede098..718fa93 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -2340,7 +2340,7 @@ perf_mmap_data_init(struct perf_event *event, struct perf_mmap_data *data)
 	}
 
 	if (!data->watermark)
-		data->watermark = max_t(long, PAGE_SIZE, max_size / 2);
+		data->watermark = max_size / 2;
 
 
 	rcu_assign_pointer(event->data, data);
