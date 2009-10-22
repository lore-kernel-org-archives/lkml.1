Return-Path: <linux-kernel-owner+w=401wt.eu-S1756324AbZJVOve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756324AbZJVOve (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 10:51:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755890AbZJVOvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 10:51:33 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:60637 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258AbZJVOvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 10:51:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=E57Pwb8KnOqudjCfPWXemicrz7IngJ2rqBC1p3DqgQth2GiVguYkO20RlHmVxX5fKn
         PJJjEocZXFpLlC8HFYab2V6h80nHc0WzM+WdJ7X6tk2GEIcNDBHftOt04UKG2D52cOIO
         J+R9ossbCrneQvc7swTzEuq9oefGOmal2fcjo=
From: Stephane Eranian <eranian@googlemail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, paulus@samba.org, a.p.zijlstra@chello.nl,
       perfmon2-devel@lists.sf.net, Stephane Eranian <eranian@gmail.com>
Subject: [PATCH] perf_events: fix validate_event bug
Date: Thu, 22 Oct 2009 16:51:31 +0200
Message-Id: <1256223091-6002-1-git-send-email-eranian@gmail.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
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
	after hw_perf_pmu_init().
	
	Signed-off-by: Stephane Eranian <eranian@gmail.com>
--
 arch/x86/kernel/cpu/perf_event.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 2e20bca..d321ff7 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -2229,10 +2229,7 @@ validate_event(struct cpu_hw_events *cpuc, struct perf_event *event)
 {
 	struct hw_perf_event fake_event = event->hw;
 
-	if (event->pmu != &pmu)
-		return 0;
-
-	return x86_schedule_event(cpuc, &fake_event);
+	return x86_schedule_event(cpuc, &fake_event) >= 0;
 }
 
 static int validate_group(struct perf_event *event)
