Return-Path: <linux-kernel-owner+w=401wt.eu-S1760959AbZAMOit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760959AbZAMOit (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 09:38:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755490AbZAMOik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 09:38:40 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:43512 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614AbZAMOij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 09:38:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=WA46sZHYyeM7muxiI0gUyqc+yWox7FXYQGXHjlqr5OuBdl9hTDi52u+2IeG944Pek8
         wTrHUqCbynUh1S4fHhXe0j6wiidTniBFs5qzDXt4avLJcn9k2upftcrchk+H0YHrNn4t
         08N9yaE93cP6BIc9dQ3VOBUe5kg6hErcFOYUs=
Date: Tue, 13 Jan 2009 17:38:35 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] oom_kill -- don't call for int_sqrt(0)
Message-ID: <20090113143835.GI7682@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to call for int_sqrt if argument is 0.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---

Please review.

 mm/oom_kill.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

Index: linux-2.6.git/mm/oom_kill.c
===================================================================
--- linux-2.6.git.orig/mm/oom_kill.c
+++ linux-2.6.git/mm/oom_kill.c
@@ -55,7 +55,7 @@ static DEFINE_SPINLOCK(zone_scan_lock);
 
 unsigned long badness(struct task_struct *p, unsigned long uptime)
 {
-	unsigned long points, cpu_time, run_time, s;
+	unsigned long points, cpu_time, run_time;
 	struct mm_struct *mm;
 	struct task_struct *child;
 
@@ -110,12 +110,10 @@ unsigned long badness(struct task_struct
 	else
 		run_time = 0;
 
-	s = int_sqrt(cpu_time);
-	if (s)
-		points /= s;
-	s = int_sqrt(int_sqrt(run_time));
-	if (s)
-		points /= s;
+	if (cpu_time)
+		points /= int_sqrt(cpu_time);
+	if (run_time)
+		points /= int_sqrt(int_sqrt(run_time));
 
 	/*
 	 * Niced processes are most likely less important, so double
