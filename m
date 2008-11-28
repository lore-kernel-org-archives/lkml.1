Return-Path: <linux-kernel-owner+w=401wt.eu-S1754622AbYK1MQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbYK1MQ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 07:16:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752320AbYK1MQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 07:16:47 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48424 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740AbYK1MQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 07:16:46 -0500
Date: Fri, 28 Nov 2008 13:16:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: walimis <walimisdev@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ftrace: improve document
Message-ID: <20081128121637.GG18333@elte.hu>
References: <alpine.DEB.1.10.0811272251180.7113@gandalf.stny.rr.com> <1227846079-9197-1-git-send-email-walimisdev@gmail.com> <alpine.DEB.1.10.0811280155140.7113@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0811280155140.7113@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> On Fri, 28 Nov 2008, walimis wrote:
> > 
> > Signed-off-by: walimis <walimisdev@gmail.com>
> > Reviewed-by: Ingo Molnar <mingo@elte.hu>
> > Reviewed-by: Steven Rostedt <srostedt@redhat.com>
> 
> Acked-by: Steven Rostedt <srostedt@redhat.com>

applied it to tip/tracing/ftrace, thanks guys! (Changed the commit log a 
bit, see the final commit below.)

	Ingo

-------------->
>From c072c24975ec4f0ccfcb6f5c8a8040b6eb75ef8f Mon Sep 17 00:00:00 2001
From: walimis <walimisdev@gmail.com>
Date: Fri, 28 Nov 2008 12:21:19 +0800
Subject: [PATCH] ftrace: improve documentation

Impact: extend documentation with notice of using wild cards correctly

We know that we can use wild cards to set set_ftrace_filter, but there's
problem when using them naively such as:

   echo h* > /debug/tracing/set_ftrace_filter

If there are files named with "h" prefix in current directory,
echo "h*" will echo these filenames to set_ftrace_filter, not the
intended "h*".

For example:

  $ cat /debug/tracing/available_filter_functions |grep ^hr |wc -l
  23
  $ ls
  $ touch hraa hrdd
  $ ls
  hraa  hrdd
  $ echo hr* > /debug/tracing/set_ftrace_filter
  $ cat /debug/tracing/set_ftrace_filter

No output in /debug/tracing/set_ftrace_filter!

If we use '' to escape wild cards, it works:

  $ ls
  hraa  hrdd
  $ echo "hr*" > /debug/tracing/set_ftrace_filter
  $ cat /debug/tracing/set_ftrace_filter |wc -l
  23

This problem can lead to unexpected result if current directory has a
lot of files.

Signed-off-by: walimis <walimisdev@gmail.com>
Acked-by: Steven Rostedt <srostedt@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 Documentation/ftrace.txt |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/Documentation/ftrace.txt b/Documentation/ftrace.txt
index de05042..803b131 100644
--- a/Documentation/ftrace.txt
+++ b/Documentation/ftrace.txt
@@ -1251,7 +1251,11 @@ These are the only wild cards which are supported.
 
   <match>*<match> will not work.
 
- # echo hrtimer_* > /debug/tracing/set_ftrace_filter
+Note: It is better to use quotes to enclose the wild cards, otherwise
+  the shell may expand the parameters into names of files in the local
+  directory.
+
+ # echo 'hrtimer_*' > /debug/tracing/set_ftrace_filter
 
 Produces:
 
@@ -1306,7 +1310,7 @@ Again, now we want to append.
  # echo sys_nanosleep > /debug/tracing/set_ftrace_filter
  # cat /debug/tracing/set_ftrace_filter
 sys_nanosleep
- # echo hrtimer_* >> /debug/tracing/set_ftrace_filter
+ # echo 'hrtimer_*' >> /debug/tracing/set_ftrace_filter
  # cat /debug/tracing/set_ftrace_filter
 hrtimer_run_queues
 hrtimer_run_pending
