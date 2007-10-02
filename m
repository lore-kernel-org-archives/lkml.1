Return-Path: <linux-kernel-owner+w=401wt.eu-S1755472AbXJBRVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472AbXJBRVq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 13:21:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753472AbXJBRVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 13:21:39 -0400
Received: from gir.skynet.ie ([193.1.99.77]:34238 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753009AbXJBRVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 13:21:38 -0400
Date: Tue, 2 Oct 2007 18:21:35 +0100
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
Subject: Re: Linux 2.6.23-rc9 and a heads-up for the 2.6.24 series..
Message-ID: <20071002172135.GA12182@skynet.ie>
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org> <1191326858.28962.8.camel@localhost> <20071002121556.GA22864@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20071002121556.GA22864@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (02/10/07 14:15), Ingo Molnar didst pronounce:
> 
> * Mel Gorman <mel@csn.ul.ie> wrote:
> 
> > Dirt. Booting with "profile=sleep,2" is broken in 2.6.23-rc9 and 
> > 2.6.23-rc8 but working in 2.6.22. I was checking it out as part of a 
> > discussion in another thread and noticed it broken in -mm as well 
> > (2.6.23-rc8-mm2). Bisect is in progress but suggestions as to the 
> > prime candidates are welcome or preferably, pointing out that I'm an 
> > idiot because I missed twiddling some config change.
> 
> Mel, does the patch below fix this bug for you? (Note: you will need to 
> enable CONFIG_SCHEDSTATS=y too.)
> 

Nice one Ingo - got it first try. The problem commit was
dd41f596cda0d7d6e4a8b139ffdfabcefdd46528 and it's clear that the code removed
in this commit is put back by this latest patch.  When applied, profile=sleep
works as long as CONFIG_SCHEDSTAT is set.

Thanks.

> if yes, then Linus please pull this single fix from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git
> 
>   | Ingo Molnar (1):
>   |      sched: fix profile=sleep
>   |
>   |  sched_fair.c |   10 ++++++++++
>   |  1 file changed, 10 insertions(+)
> 
> risk is low: the new code only runs with CONFIG_SCHEDSTATS=y 
> (default:off) and profile=sleep (default:off), so it ought to be fairly 
> safe to add at this point. (and we had very similar code in v2.6.22 
> anyway)
> 
> 	Ingo
> 
> ------------------------->
> Subject: sched: fix profile=sleep
> From: Ingo Molnar <mingo@elte.hu>
> 
> fix sleep profiling - we lost this chunk in the CFS merge.
> 
> Found-by: Mel Gorman <mel@csn.ul.ie>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

Tested-by: Mel Gorman <mel@csn.ul.ie>

That said, I am not super-keen on this only working when SCHEDSTAT is set
without telling the user about it. It's not urgent enough to pick up as a
late-late fix but prehaps something like this?

=============

profile=sleep only works if CONFIG_SCHEDSTATS is set. This patch notes the
limitation in Documentation/kernel-parameters.txt and prints a warning at
boot-time if profile=sleep is used without CONFIG_SCHEDSTAT.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
--- 
 Documentation/kernel-parameters.txt |    3 ++-
 kernel/profile.c                    |    5 +++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff -rup -X /usr/src/patchset-0.6/bin//dontdiff linux-2.6.23-rc9-005_ingo_profile_fix/Documentation/kernel-parameters.txt linux-2.6.23-rc9-010_document_profilesleep/Documentation/kernel-parameters.txt
--- linux-2.6.23-rc9-005_ingo_profile_fix/Documentation/kernel-parameters.txt	2007-10-02 04:24:52.000000000 +0100
+++ linux-2.6.23-rc9-010_document_profilesleep/Documentation/kernel-parameters.txt	2007-10-02 16:43:41.000000000 +0100
@@ -1395,7 +1395,8 @@ and is between 256 and 4096 characters. 
 			Param: "schedule" - profile schedule points.
 			Param: <number> - step/bucket size as a power of 2 for
 				statistical time based profiling.
-			Param: "sleep" - profile D-state sleeping (millisecs)
+			Param: "sleep" - profile D-state sleeping (millisecs).
+				Requires CONFIG_SCHEDSTATS to work
 
 	processor.max_cstate=	[HW,ACPI]
 			Limit processor to maximum C-state
diff -rup -X /usr/src/patchset-0.6/bin//dontdiff linux-2.6.23-rc9-005_ingo_profile_fix/kernel/profile.c linux-2.6.23-rc9-010_document_profilesleep/kernel/profile.c
--- linux-2.6.23-rc9-005_ingo_profile_fix/kernel/profile.c	2007-10-02 04:24:52.000000000 +0100
+++ linux-2.6.23-rc9-010_document_profilesleep/kernel/profile.c	2007-10-02 16:44:50.000000000 +0100
@@ -60,6 +60,7 @@ static int __init profile_setup(char * s
 	int par;
 
 	if (!strncmp(str, sleepstr, strlen(sleepstr))) {
+#ifdef CONFIG_SCHEDSTATS
 		prof_on = SLEEP_PROFILING;
 		if (str[strlen(sleepstr)] == ',')
 			str += strlen(sleepstr) + 1;
@@ -68,6 +69,10 @@ static int __init profile_setup(char * s
 		printk(KERN_INFO
 			"kernel sleep profiling enabled (shift: %ld)\n",
 			prof_shift);
+#else
+		printk(KERN_WARNING
+			"kernel sleep profiling requires CONFIG_SCHEDSTATS\n");
+#endif /* CONFIG_SCHEDSTATS */
 	} else if (!strncmp(str, schedstr, strlen(schedstr))) {
 		prof_on = SCHED_PROFILING;
 		if (str[strlen(schedstr)] == ',')
