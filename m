Return-Path: <linux-kernel-owner+w=401wt.eu-S1753326AbZHaEw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326AbZHaEw0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 00:52:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752646AbZHaEwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 00:52:25 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:38713 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475AbZHaEwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 00:52:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Pr/+T1HzPiXqNHUeZwbcdgDASjc1T/cz1yh5pZ0fWr6gkeXuMvYWRjhmcMIyb2rrsX
         eRFhPW24ju2bs/SszceEmqSuD5ou8KhEyIJn+10MwW+4z7tU5DHSI6KbP3NssrVwNo5F
         TgUgpHxc6BuH7xfUnjJenz2v1I42o6Qc+fnOg=
Date: Mon, 31 Aug 2009 06:52:23 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 3/4] perf tools: Unify swapper tasks naming
Message-ID: <20090831045222.GA6603@nowhere>
References: <1251682323-10395-1-git-send-email-fweisbec@gmail.com> <1251693921-6579-3-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251693921-6579-3-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 31, 2009 at 06:45:20AM +0200, Frederic Weisbecker wrote:
> In perf tools, we hardcode the pid 0 cmdline resolving to "idle"
> because the init task is not included in the COMM events.
> 
> But the idle tasks secondary cpus are resolved into their "init"
> name through the COMM events.
> We have then such strange result in perf report (ditto with trace):
> 
>     19.66%       init    [kernel]          [k] acpi_idle_enter_c1
>     17.32%       [idle]  [kernel]          [k] acpi_idle_enter_c1
>


And BTW, idle/boot cpu is the only task that has square brackets.
Either these should be removed or we could add these brackets
to every kernel task coms.

I've tried with the following patch. It doesn't change anything, I'm not
sure why, I haven't yet investigate much for now:

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index d988dfb..3753c39 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -3230,10 +3230,15 @@ static void perf_counter_comm_event(struct perf_comm_event *comm_event)
 	struct perf_cpu_context *cpuctx;
 	struct perf_counter_context *ctx;
 	unsigned int size;
-	char comm[TASK_COMM_LEN];
+	char comm[TASK_COMM_LEN + 2]; /* Also reserve square backets */
 
 	memset(comm, 0, sizeof(comm));
-	strncpy(comm, comm_event->task->comm, sizeof(comm));
+
+	if (comm_event->task->mm)
+		strncpy(comm, comm_event->task->comm, sizeof(comm));
+	else
+		snprintf(comm, sizeof(comm), "[%s]", comm_event->task->comm);
+
 	size = ALIGN(strlen(comm)+1, sizeof(u64));
 
 	comm_event->comm = comm;


