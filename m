Return-Path: <linux-kernel-owner+w=401wt.eu-S1755776Ab0AWATv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776Ab0AWATv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 19:19:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755573Ab0AWATI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 19:19:08 -0500
Received: from kroah.org ([198.145.64.141]:35128 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755429Ab0AWATF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 19:19:05 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Jan 22 16:11:14 2010
Message-Id: <20100123001113.909714109@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 22 Jan 2010 16:10:13 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [29/29] perf: Honour event state for aux stream data
In-Reply-To: <20100123001145.GA7391@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

commit 22e190851f8709c48baf00ed9ce6144cdc54d025 upstream.

Anton reported that perf record kept receiving events even after calling
ioctl(PERF_EVENT_IOC_DISABLE). It turns out that FORK,COMM and MMAP
events didn't respect the disabled state and kept flowing in.

Reported-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Tested-by: Anton Blanchard <anton@samba.org>
LKML-Reference: <1263459187.4244.265.camel@laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/perf_event.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -3229,6 +3229,9 @@ static void perf_event_task_output(struc
 
 static int perf_event_task_match(struct perf_event *event)
 {
+	if (event->state != PERF_EVENT_STATE_ACTIVE)
+		return 0;
+
 	if (event->cpu != -1 && event->cpu != smp_processor_id())
 		return 0;
 
@@ -3345,6 +3348,9 @@ static void perf_event_comm_output(struc
 
 static int perf_event_comm_match(struct perf_event *event)
 {
+	if (event->state != PERF_EVENT_STATE_ACTIVE)
+		return 0;
+
 	if (event->cpu != -1 && event->cpu != smp_processor_id())
 		return 0;
 
@@ -3472,6 +3478,9 @@ static void perf_event_mmap_output(struc
 static int perf_event_mmap_match(struct perf_event *event,
 				   struct perf_mmap_event *mmap_event)
 {
+	if (event->state != PERF_EVENT_STATE_ACTIVE)
+		return 0;
+
 	if (event->cpu != -1 && event->cpu != smp_processor_id())
 		return 0;
 


