Return-Path: <linux-kernel-owner+w=401wt.eu-S1755459AbXJCMvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459AbXJCMvt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 08:51:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753601AbXJCMvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 08:51:42 -0400
Received: from gir.skynet.ie ([193.1.99.77]:44175 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753152AbXJCMvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 08:51:41 -0400
Date: Wed, 3 Oct 2007 13:51:39 +0100
To: Ingo Molnar <mingo@elte.hu>
Cc: Bill Davidsen <davidsen@tmr.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
Subject: Re: Linux 2.6.23-rc9 and a heads-up for the 2.6.24 series..
Message-ID: <20071003125138.GA8636@skynet.ie>
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org> <1191326858.28962.8.camel@localhost> <20071002121556.GA22864@elte.hu> <20071002172135.GA12182@skynet.ie> <4702C1AD.3090701@tmr.com> <1191371855.2708.26.camel@localhost> <20071003082157.GB32218@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20071003082157.GB32218@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (03/10/07 10:21), Ingo Molnar didst pronounce:
> 
> * Mel Gorman <mel@csn.ul.ie> wrote:
> 
> > > > Nice one Ingo - got it first try. The problem commit was 
> > > > dd41f596cda0d7d6e4a8b139ffdfabcefdd46528 and it's clear that the 
> > > > code removed in this commit is put back by this latest patch.  
> > > > When applied, profile=sleep works as long as CONFIG_SCHEDSTAT is 
> > > > set.
> > > > 
> > > And if it isn't set? I can easily see building a new kernel with 
> > > stats off and forgetting to change the boot options.
> > 
> > If CONFIG_SCHEDSTAT is off and profile=sleep is set, you see with 
> > Ingo's patch and readprofile;
> > 
> >      0 *unknown*
> >      0 total                                      0.0000
> > 
> > That is a tad confusing hence my follow-up patch which would say 
> > "/proc/profile" doesn't exist when readprofile is used and the warning 
> > in dmesg.
> 
> yep - that's the best we can do for the stable release.
> 

Agreed. The less change the better this late in the game.

> We could improve quality of behavior here by not offering /proc/profile 
> in that case and by printk-ing something if profile=sleep is specified 
> on a !CONFIG_SCHEDSTATS kernel. I'm willing to apply patches that do 
> that :)
> 

I included a candidate patch in the last mail but it was shoved down at
the bottom so it could easily have been missed.

==============
Subject: Document profile=sleep requiring CONFIG_SCHEDSTATS

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
+				Requires CONFIG_SCHEDSTATS
 
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
-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
