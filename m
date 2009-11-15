Return-Path: <linux-kernel-owner+w=401wt.eu-S1753061AbZKOOEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061AbZKOOEy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 09:04:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753045AbZKOOEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 09:04:53 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:33349 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035AbZKOOEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 09:04:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=e47VIMxO+BxOB5VTPgRQuE+H2jPGTwxk90BIg1D0BXvXMVFWp0us8KYMD/1sS0iab2
         DjoxPDdQQe0cB+M8duOaNd6m0boeZY868AXTzrhYVhRtOyZrXv4i7bjDaRFA1z5Szl9p
         jpLttfntiXgjuT/VwtigPbJBIo6MAmtiCbu4E=
Date: Sun, 15 Nov 2009 12:05:08 -0200
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: perf stat output
Message-ID: <20091115140507.GB21561@skywalker.lan>
References: <193b0f820911121403w35c57158kf3721309e1f2ebd7@mail.gmail.com>
 <20091115091343.GA17358@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091115091343.GA17358@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, following the tested patch you asked. It's a bit different of what you
sent because branch-misses is counted in another struct.


Lucas De Marchi

--
commit 70e98c814153f0026a683c5d19674ed8185d02fa
Author: Lucas De Marchi <lucas.de.marchi@gmail.com>
Date:   Sun Nov 15 11:20:56 2009 -0200

    Do not print ratio when task-clock event is not counted
    
    The ratio between the number of events and the time elapsed makes sense only
    if task-clock event is counted. Otherwise it will be simply a (confusing)
    
    	#      0.000 M/sec
    
    This patch outputs the ratio only if task-clock event is counted. Some test
    examples of before and after:
    
    Before:
    
    	[lucas@skywalker linux.trees.git]$ sudo perf stat -e branch-misses -a -- sleep 1
    
    	 Performance counter stats for 'sleep 1':
    
    		1367818  branch-misses            #      0.000 M/sec
    
    	    1.001494325  seconds time elapsed
    
    After (without task-clock):
    
    	[lucas@skywalker perf]$ sudo ./perf stat -e branch-misses -a -- sleep 1
    
    	 Performance counter stats for 'sleep 1':
    
    		1135044  branch-misses
    
    	    1.001370775  seconds time elapsed
    
    After (with task-clock):
    
    	[lucas@skywalker perf]$ sudo ./perf stat -e branch-misses -e task-clock -a -- sleep 1
    
    	 Performance counter stats for 'sleep 1':
    
    		1070111  branch-misses            #      0.534 M/sec
    	    2002.730893  task-clock-msecs         #      1.999 CPUs
    
    	    1.001640292  seconds time elapsed
    
    Signed-off-by: Lucas De Marchi <lucas.de.marchi@gmail.com>

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index c6df377..c70d720 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -357,7 +357,8 @@ static void abs_printout(int counter, double avg)
 			ratio = avg / total;
 
 		fprintf(stderr, " # %10.3f IPC  ", ratio);
-	} else if (MATCH_EVENT(HARDWARE, HW_BRANCH_MISSES, counter)) {
+	} else if (MATCH_EVENT(HARDWARE, HW_BRANCH_MISSES, counter) &&
+			runtime_branches_stats.n != 0) {
 		total = avg_stats(&runtime_branches_stats);
 
 		if (total)
@@ -365,7 +366,7 @@ static void abs_printout(int counter, double avg)
 
 		fprintf(stderr, " # %10.3f %%    ", ratio);
 
-	} else {
+	} else if (runtime_nsecs_stats.n != 0) {
 		total = avg_stats(&runtime_nsecs_stats);
 
 		if (total)

