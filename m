Return-Path: <linux-kernel-owner+w=401wt.eu-S1759208AbXEKIqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759208AbXEKIqU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 04:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754640AbXEKIqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 04:46:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38140 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbXEKIqK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 04:46:10 -0400
Date: Fri, 11 May 2007 10:45:31 +0200
From: Tomas Janousek <tjanouse@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: john stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org,
       tsmetana@redhat.com, riel@redhat.com
Subject: Re: [PATCH] Use boot based time for process start time and boot
	time in /proc
Message-ID: <20070511084531.GA31854@redhat.com>
References: <3108b4e2c91097ec9469420b3f0836f0499068a6.1178816485.git.tomi@nomi.cz> <f3c12bbf0772543db18c7a5251ce92f4f4f6758e.1178816485.git.tomi@nomi.cz> <20070510164047.263a9524.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20070510164047.263a9524.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, May 10, 2007 at 04:40:47PM -0700, Andrew Morton wrote:
> Tomas Janousek <tjanouse@redhat.com> wrote:
> > @@ -445,12 +445,14 @@ static int show_stat(struct seq_file *p, void *v)
> >  	unsigned long jif;
> >  	cputime64_t user, nice, system, idle, iowait, irq, softirq, steal;
> >  	u64 sum = 0;
> > +	struct timespec boottime;
> >  
> >  	user = nice = system = idle = iowait =
> >  		irq = softirq = steal = cputime64_zero;
> > -	jif = - wall_to_monotonic.tv_sec;
> > -	if (wall_to_monotonic.tv_nsec)
> > -		--jif;
> > +	getboottime(&boottime);
> > +	jif = boottime.tv_sec;
> > +	if (boottime.tv_nsec)
> > +		++jif;
> >
> 
> Is the switch from --jif to ++jif a functional change?  If so, how come?

Yes, I'm afraid it was.

-----------------------
From: Tomas Janousek <tjanouse@redhat.com>
Date: Fri, 11 May 2007 10:34:55 +0200
Subject: [PATCH] Lower the boot time to seconds, not ceil

Restores the original behaviour of boot time calculation.

Signed-off-by: Tomas Janousek <tjanouse@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Tomas Smetana <tsmetana@redhat.com>
Cc: John Stultz <johnstul@us.ibm.com>
---
 fs/proc/proc_misc.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/proc/proc_misc.c b/fs/proc/proc_misc.c
index d84956c..60b6210 100644
--- a/fs/proc/proc_misc.c
+++ b/fs/proc/proc_misc.c
@@ -452,8 +452,6 @@ static int show_stat(struct seq_file *p, void *v)
 		irq = softirq = steal = cputime64_zero;
 	getboottime(&boottime);
 	jif = boottime.tv_sec;
-	if (boottime.tv_nsec)
-		++jif;
 
 	for_each_possible_cpu(i) {
 		int j;
-- 
1.5.1.4

-- 
Tomas Janousek, SW Engineer, Red Hat, Inc.
