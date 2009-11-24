Return-Path: <linux-kernel-owner+w=401wt.eu-S932920AbZKXN1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932920AbZKXN1S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 08:27:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932770AbZKXN1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 08:27:18 -0500
Received: from smtp-out.google.com ([216.239.33.17]:18684 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932685AbZKXN1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 08:27:17 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:subject:from:reply-to:in-reply-to:to:cc:x-system-of-record;
	b=R0bxqizmN4qUBr51zGJXh/Pt7Ni96OnA5oA17x0N88PNX6lyb4Jah0RCcZoFSQsnu
	86m4Y6bu32ytOj6iHSCKg==
Message-ID: <4b0bdf36.1818d00a.07cc.25ae@mx.google.com>
Date: Tue, 24 Nov 2009 05:27:18 -0800 (PST)
Subject: [PATCH] perf_events: fix validate_event bug
From: Stephane Eranian <eranian@google.com>
Reply-to: eranian@google.com
In-Reply-to: <1256223091-6002-1-git-send-email-eranian@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org,
       perfmon2-devel@lists.sourceforge.net, eranian@google.com,
       eranian@gmail.com
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	The validate_event() was failing on valid event
	combinations. The function was assuming that if
	x86_schedule_event() returned 0, it meant error.
	But x86_schedule_event() returns the counter index
	and 0 is a perfectly valid value. An error is returned
	if the function returns a negative value.

	Furthermore, validate_event() was also failing for
	event groups because the event->pmu was not set until
	after hw_perf_event_init().
	
	Signed-off-by: Stephane Eranian <eranian@google.com>
--
 arch/x86/kernel/cpu/perf_event.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index bd87430..c1bbed1 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -2229,10 +2229,10 @@ validate_event(struct cpu_hw_events *cpuc, struct perf_event *event)
 {
 	struct hw_perf_event fake_event = event->hw;
 
-	if (event->pmu != &pmu)
+	if (event->pmu && event->pmu != &pmu)
 		return 0;
 
-	return x86_schedule_event(cpuc, &fake_event);
+	return x86_schedule_event(cpuc, &fake_event) >= 0;
 }
 
 static int validate_group(struct perf_event *event)
