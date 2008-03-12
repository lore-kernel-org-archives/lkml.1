Return-Path: <linux-kernel-owner+w=401wt.eu-S1753726AbYCLQl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726AbYCLQl4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 12:41:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751761AbYCLQlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 12:41:49 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:7036 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbYCLQls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 12:41:48 -0400
Message-ID: <47D807BA.7020102@hp.com>
Date: Wed, 12 Mar 2008 12:41:30 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, npiggin@suse.de, dgc@sgi.com
Subject: Re: [PATCH 0/7] IO CPU affinity testing series
References: <1205322940-20127-1-git-send-email-jens.axboe@oracle.com>
In-Reply-To: <1205322940-20127-1-git-send-email-jens.axboe@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Subject: [PATCH] Fixed race: using potentially invalid pointer

When data->flags & CSD_FLAG_ALLOC is true, the data could be freed by the other processor before we check for CSD_FLAG_WAIT.

Also: removed old comment, doesn't quite fit anymore.

This is applied against Jens' git tree w/ the ia64 additional commit.

Signed-off-by: Alan D. Brunelle <alan.brunelle@hp.com>
---
 arch/ia64/kernel/smp.c   |    5 ++---
 arch/x86/kernel/smp_32.c |    5 ++---
 arch/x86/kernel/smp_64.c |    5 ++---
 3 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/arch/ia64/kernel/smp.c b/arch/ia64/kernel/smp.c
index 521bc52..ad153e2 100644
--- a/arch/ia64/kernel/smp.c
+++ b/arch/ia64/kernel/smp.c
@@ -407,8 +407,7 @@ void __smp_call_function_single(int cpu, struct call_single_data *data)
 {
 	struct call_single_queue *dst;
 	unsigned long flags;
-	/* prevent preemption and reschedule on another processor */
-	int ipi;
+	int ipi, wait_done = data->flags & CSD_FLAG_WAIT;
 
 	/* Can deadlock when called with interrupts disabled */
 	WARN_ON((data->flags & CSD_FLAG_WAIT) && irqs_disabled());
@@ -424,7 +423,7 @@ void __smp_call_function_single(int cpu, struct call_single_data *data)
 	if (ipi)
 		send_IPI_single(cpu, IPI_CALL_FUNC_SINGLE);
 
-	if (data->flags & CSD_FLAG_WAIT) {
+	if (wait_done) {
 		/* Wait for response */
 		while (data->flags)
 			cpu_relax();
diff --git a/arch/x86/kernel/smp_32.c b/arch/x86/kernel/smp_32.c
index dcbb89c..8239814 100644
--- a/arch/x86/kernel/smp_32.c
+++ b/arch/x86/kernel/smp_32.c
@@ -638,8 +638,7 @@ void __smp_call_function_single(int cpu, struct call_single_data *data)
 	cpumask_t mask = cpumask_of_cpu(cpu);
 	struct call_single_queue *dst;
 	unsigned long flags;
-	/* prevent preemption and reschedule on another processor */
-	int ipi;
+	int ipi, wait_done = data->flags & CSD_FLAG_WAIT;
 
 	/* Can deadlock when called with interrupts disabled */
 	WARN_ON((data->flags & CSD_FLAG_WAIT) && irqs_disabled());
@@ -655,7 +654,7 @@ void __smp_call_function_single(int cpu, struct call_single_data *data)
 	if (ipi)
 		send_IPI_mask(mask, CALL_FUNCTION_SINGLE_VECTOR);
 
-	if (data->flags & CSD_FLAG_WAIT) {
+	if (wait_done) {
 		/* Wait for response */
 		while (data->flags)
 			cpu_relax();
diff --git a/arch/x86/kernel/smp_64.c b/arch/x86/kernel/smp_64.c
index 7e4e300..c89a4f7 100644
--- a/arch/x86/kernel/smp_64.c
+++ b/arch/x86/kernel/smp_64.c
@@ -458,8 +458,7 @@ void __smp_call_function_single(int cpu, struct call_single_data *data)
 	cpumask_t mask = cpumask_of_cpu(cpu);
 	struct call_single_queue *dst;
 	unsigned long flags;
-	/* prevent preemption and reschedule on another processor */
-	int ipi;
+	int ipi, wait_done = data->flags & CSD_FLAG_WAIT;
 
 	/* Can deadlock when called with interrupts disabled */
 	WARN_ON((data->flags & CSD_FLAG_WAIT) && irqs_disabled());
@@ -475,7 +474,7 @@ void __smp_call_function_single(int cpu, struct call_single_data *data)
 	if (ipi)
 		send_IPI_mask(mask, CALL_FUNCTION_SINGLE_VECTOR);
 
-	if (data->flags & CSD_FLAG_WAIT) {
+	if (wait_done) {
 		/* Wait for response */
 		while (data->flags)
 			cpu_relax();
-- 
1.5.2.5

