Return-Path: <linux-kernel-owner+w=401wt.eu-S1756980AbZHQG6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980AbZHQG6d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 02:58:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753371AbZHQG6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 02:58:32 -0400
Received: from araneidae.co.uk ([62.3.233.233]:3449 "EHLO araneidae.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752460AbZHQG6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 02:58:32 -0400
Date: Mon, 17 Aug 2009 07:58:29 +0100 (BST)
From: Michael Abbott <michael@araneidae.co.uk>
To: Amerigo Wang <xiyou.wangcong@gmail.com>
cc: Jan Engelhardt <jengelh@medozas.de>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Re: /proc/uptime idle counter remains at 0
In-Reply-To: <20090817062324.GN5039@cr0.nay.redhat.com>
Message-ID: <Pine.LNX.4.64.0908170743300.1592@venus.araneidae.co.uk>
References: <alpine.LSU.2.00.0905090957490.27646@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0908141315310.1670@venus.araneidae.co.uk>
 <20090817052502.GJ5039@cr0.nay.redhat.com> <Pine.LNX.4.64.0908170707550.1592@venus.araneidae.co.uk>
 <20090817062324.GN5039@cr0.nay.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Aug 2009, Amerigo Wang wrote:
> On Mon, Aug 17, 2009 at 07:12:36AM +0100, Michael Abbott wrote:
> >On Mon, 17 Aug 2009, Amerigo Wang wrote:
> >> On Fri, Aug 14, 2009 at 01:18:08PM +0100, Michael Abbott wrote:
> >> >commit 6d67e34f45a92f347388e35bd84bf0361e660d3b
> >> >Author: Michael Abbott <michael.abbott@diamond.ac.uk>
> >> >Date:   Mon May 11 07:14:19 2009 +0100
> >> >
> >> >    Fix idle time field in /proc/uptime
> >> >    
> >> >    Git commit 79741dd changes idle cputime accounting, but unfortunately
> >> >    the /proc/uptime file hasn't caught up.  Here the idle time calculation
> >> >    from /proc/stat is copied over.  Further changes from commit e1c8053
> >> >    are also included in this fix.
> >> >    
> >> >    Signed-off-by: Michael Abbott <michael.abbott@diamond.ac.uk>
> >> >
> >> >diff --git a/fs/proc/uptime.c b/fs/proc/uptime.c
> >> >index 0c10a0b..be286b4 100644
> >> >--- a/fs/proc/uptime.c
> >> >+++ b/fs/proc/uptime.c
> >> >@@ -4,22 +4,32 @@
> >> > #include <linux/sched.h>
> >> > #include <linux/seq_file.h>
> >> > #include <linux/time.h>
> >> >+#include <linux/kernel_stat.h>
> >> > #include <asm/cputime.h>
> >> >+#include <asm/div64.h>
> >> > 
> >> > static int uptime_proc_show(struct seq_file *m, void *v)
> >> > {
> >> > 	struct timespec uptime;
> >> >-	struct timespec idle;
> >> >-	cputime_t idletime = cputime_add(init_task.utime, init_task.stime);
> >> >+	int i;
> >> >+	cputime64_t idle = cputime64_zero;
> >> >+	unsigned long int idle_mod;
> >> >+
> >> >+	for_each_possible_cpu(i) {
> >> >+		idle = cputime64_add(idle, kstat_cpu(i).cpustat.idle);
> >> >+#ifdef arch_idle_time
> >> >+		idle = cputime64_add(idle, arch_idle_time(i));
> >> >+#endif
> >> 
> >> 
> >> This ugly #ifdef can be removed, check fs/proc/stat.c.
> >
> >I'm sorry?  Are you sure?  Here is what fs/proc/stat.c has to say:
> >
> >#ifndef arch_idle_time
> >#define arch_idle_time(cpu) 0
> >#endif
> >...
> >		idle = cputime64_add(idle, arch_idle_time(i));
> >
> >
> >I think what you're actually saying is the #ifdef can be moved to 
> >somewhere where it can be easily missed.  For this very reason, I'd rather 
> >be more explicit about it.
> 
> Yes, indeed.
> 
> I was suggesting to move that #ifdef into some header so that
> both two files can use it. For me, this is the better fix.

Yes, you're right, this is a much better idea.  In fact, the definition of 
the arch_idle_time symbol itself should be fixed.

My problem here is I'm not getting much traction getting little patches 
like this in;  your suggestion is almost to make this patch larger!


Oh, that's nasty.  Looks as if arch_idle_time only exists in 
	arch/s390/include/asm/cputime.h
and there are 20 other architecture specific cputime.h files as well as 
asm-generic/cputime.h.  I guess asm-generic/cputime.h is only included if 
an architecture specific cputime.h doesn't exist, so it would seem that 
the direct solution would be to add
	#define arch_idle_time(cpu) 0
to *all* the other cputime.h files.  Ewww.

I'm sorry, I really don't know how detailed cpu time accounting works, and 
I have no confidence of getting a patch in after the necessary work has 
been done.


The thing that seems to be killing this patch is all the extra associated 
issues.  It looks as if detailed CPU accounting is actually in a bit of a 
mess ... but I am wholly unqualified to work on this (for a start, all my 
work is uniprocessor!)

Could we just get this patch in, please, and then maybe use this as a 
trigger to clean up everything else?
