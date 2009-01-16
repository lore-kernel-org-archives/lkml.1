Return-Path: <linux-kernel-owner+w=401wt.eu-S935794AbZAPXJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935794AbZAPXJt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 18:09:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761698AbZAPXJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 18:09:40 -0500
Received: from smtp5.Stanford.EDU ([171.67.219.85]:50237 "EHLO
	smtp5.stanford.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760371AbZAPXJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 18:09:39 -0500
Subject: [Fwd: [LAU] [PATCH] [RT] tasklets: fix typo in tasklet_hi_action]
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain
Date: Fri, 16 Jan 2009 15:09:37 -0800
Message-Id: <1232147377.3081.8.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't know if you are aware of this patch (see below), it was
apparently not xposted to lkml. If fixes the loooong standing midi
problems in 2.6.26.x. I've tested (not very deeply) and it seems to work
(and others have also reported success with it). It is not in rt13...

-- Fernando


-------- Forwarded Message --------
From: Adam Sampson <ats@offog.org>
To: linux-rt-users@vger.kernel.org
Cc: linux-audio-user@lists.linuxaudio.org
Subject: [LAU] [PATCH] [RT] tasklets: fix typo in tasklet_hi_action
Date: Sun, 4 Jan 2009 15:20:58 +0000

[l-a-u CCed because we've been talking about this problem there
recently, and that's what prodded me to do the bisection to track it
down... fortunately the -rt8 to -rt9 interdiff was pretty small!]

Subject: [PATCH] [RT] tasklets: fix typo in tasklet_hi_action

Fix a typo in tasklet_hi_action -- using the wrong tasklet list when removing
actions.

This appears to be what was causing the ALSA sequencer device not to work in
2.6.26 with the RT patch: the sequencer was flaky in -rt1 to -rt8, and just
hung in -rt9 and later, after tasklets-fix-tasklet_hi_schedule.patch which
fixed the same typo when adding to the list. I guess that's because before -rt9
the actions were going onto the wrong list, whereas after -rt9 they were being
lost entirely once the first one had been performed. It seems happy now,
anyway.

Signed-off-by: Adam Sampson <ats@offog.org>

--- linux-2.6.26/kernel/softirq.c_orig	2009-01-04 14:41:06.000000000 +0000
+++ linux-2.6.26/kernel/softirq.c	2009-01-04 14:41:49.000000000 +0000
@@ -657,7 +657,7 @@
 	local_irq_disable();
 	list = __get_cpu_var(tasklet_hi_vec).head;
 	__get_cpu_var(tasklet_hi_vec).head = NULL;
-	__get_cpu_var(tasklet_hi_vec).tail = &__get_cpu_var(tasklet_vec).head;
+	__get_cpu_var(tasklet_hi_vec).tail = &__get_cpu_var(tasklet_hi_vec).head;
 	local_irq_enable();
 
 	__tasklet_action(a, list);


