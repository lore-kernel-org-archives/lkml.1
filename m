Return-Path: <linux-kernel-owner+w=401wt.eu-S1755505AbYAXJf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505AbYAXJf3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 04:35:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753632AbYAXJfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 04:35:14 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:16116 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307AbYAXJfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 04:35:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=Td0MEw1CKFxGhudL4RFxMUWVONIpWEHynJm17+sTU0RzukCIjD3zlA53/EFMQ1sNQAyrAOoY0w1fdVah4vPgIO4lcABAJbb2SwqaRc671LaDAEsR6fglrPmK6iNDOgtmM/9BVkKvubCNQgNlhWU7kX+D8regYYSw8jhmhZBp+2c=
Message-ID: <47985BCA.2050500@gmail.com>
Date: Thu, 24 Jan 2008 11:35:06 +0200
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080109)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Strange interaction between latencytop and the scheduler
References: <47962DD1.9050800@gmail.com> <47963E2E.9020501@linux.intel.com> <47964572.2060002@gmail.com>
In-Reply-To: <47964572.2060002@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Török Edwin wrote:
>   
>> The performance aspect... collecting the data isn't cheap (which is
>> why it's made a sysctl),
>> I still plan to look at optimizing it but it won't ever be free.
>>     
>
> Yes, I understand that. Is there a way latencytop could track its own
> overhead? I suppose it would lead to more accurate results
> (not that there would be anything wrong with the current ones).
>   

Latencytop userspace tool shows latencies > 0.1 msec, thus capturing
backtraces for latencies <0.1msec could be avoided.
If I apply the patch below, then enabling latencytop doesn't freeze X
when running the "10-threads doing infloop usleep(1)" test.
Still, I don't want to loose track of the latencies we didn't collect
backtraces for, so I added a special "untraced" category, reported as
first line in /proc/latency_stats. If needed, instead of hardcoding the
threshold, it could be made a sysctl, or set via writing to
/proc/latency_stats,...

While I am running the test-program:
$ grep untraced /proc/latency_stats
4875605 5120414 49 untraced

On an idle system:
$ grep untraced /proc/latency_stats
532 3287 47 untraced
$ grep untraced /proc/latency_stats
853 5778 47 untraced
$ grep untraced /proc/latency_stats
950 6788 47 untraced
$ grep untraced /proc/latency_stats
1343 9977 49 untraced
$ grep untraced /proc/latency_stats
1448 11075 49 untraced

Best regards,
--Edwin

---
latencytop.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)
--- /tmp/linux-2.6.24-rc8/kernel/latencytop.c    2008-01-24
11:27:32.727487585 +0200
+++ kernel/latencytop.c    2008-01-24 10:42:25.000000000 +0200
@@ -24,8 +24,11 @@
 static DEFINE_SPINLOCK(latency_lock);
 
 #define MAXLR 128
+/* we are not interested in latencies less than 0.1msec, so
+ * don't get backtraces for latencies <0.05msec.*/
+#define LATENCY_TRACE_THRESHOLD 50
 static struct latency_record latency_record[MAXLR];
-
+static struct latency_record untraced;
 int latencytop_enabled;
 
 void clear_all_latency_tracing(struct task_struct *p)
@@ -47,6 +50,7 @@
 
     spin_lock_irqsave(&latency_lock, flags);
     memset(&latency_record, 0, sizeof(latency_record));
+    memset(&untraced, 0, sizeof(untraced));
     spin_unlock_irqrestore(&latency_lock, flags);
 }
 
@@ -124,6 +128,15 @@
     if (inter && usecs > 5000)
         return;
 
+    if(usecs < LATENCY_TRACE_THRESHOLD) {
+        /* don't get stacktrace for very low latencies */
+        untraced.time += usecs;
+        if(usecs > untraced.max)
+            untraced.max = usecs;
+        untraced.count++;
+        return;
+    }
+
     memset(&lat, 0, sizeof(lat));
     lat.count = 1;
     lat.time = usecs;
@@ -177,6 +190,10 @@
 
     seq_puts(m, "Latency Top version : v0.1\n");
 
+    seq_printf(m, "%i %li %li untraced \n",
+            untraced.count,
+            untraced.time,
+            untraced.max);
     for (i = 0; i < MAXLR; i++) {
         if (latency_record[i].backtrace[0]) {
             int q;

