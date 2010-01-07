Return-Path: <linux-kernel-owner+w=401wt.eu-S932584Ab0AGEsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932584Ab0AGEsx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 23:48:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932437Ab0AGEsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 23:48:52 -0500
Received: from mail.gmx.net ([213.165.64.20]:51562 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932526Ab0AGEsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 23:48:52 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18rTERET7creD4IIIA9uimqZIm6ANRCfWzlODGxcU
	8RcgXU4qIFLPaL
Subject: Re: tools/perf: "perf record" restricted to root in latest kernel?
From: Mike Galbraith <efault@gmx.de>
To: Miles Bader <miles@gnu.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <buovdfeocht.fsf@dhlpc061.dev.necel.com>
References: <buopr5nol26.fsf@dhlpc061.dev.necel.com>
	 <20100106205911.GC18919@ghostprotocols.net>
	 <buovdfeocht.fsf@dhlpc061.dev.necel.com>
Content-Type: text/plain
Date: Thu, 07 Jan 2010 05:48:43 +0100
Message-Id: <1262839723.6303.5.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.49
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-07 at 11:49 +0900, Miles Bader wrote:

> Perhaps the newer version of perf works better with newer kernels

Yup.  Bisects back to 60ab271617cec607380099f3ed8e84916e48323b.  If
running latest kernel, normal user can record fine.  Running 31 or 32
kernel with latest perf though, I see the same permission error.  Not
immediately obvious to me why reverting this commit does indeed fix it. 

commit 60ab271617cec607380099f3ed8e84916e48323b
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Wed Dec 16 17:55:56 2009 +0100

    perf record: Use per-task-per-cpu events for inherited events
    
    Create events with a pid and cpu contraint for inherited events
    so that we get a stream per cpu, instead of all cpus contending
    on a single stream.
    
    Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
    Cc: fweisbec@gmail.com
    Cc: Paul Mackerras <paulus@samba.org>
    LKML-Reference: <20091216165904.987643843@chello.nl>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 9b7c6d8..63136d0 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -278,7 +278,7 @@ static void create_counter(int counter, int cpu, pid_t pid)
 
 	attr->mmap		= track;
 	attr->comm		= track;
-	attr->inherit		= (cpu < 0) && inherit;
+	attr->inherit		= inherit;
 	attr->disabled		= 1;
 
 try_again:
@@ -537,7 +537,7 @@ static int __cmd_record(int argc __used, const char **argv)
 	}
 
 
-	if (!system_wide || profile_cpu != -1) {
+	if ((!system_wide && !inherit) || profile_cpu != -1) {
 		open_counters(profile_cpu, target_pid);
 	} else {
 		for (i = 0; i < nr_cpus; i++)


