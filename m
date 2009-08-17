Return-Path: <linux-kernel-owner+w=401wt.eu-S1757385AbZHQIUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757385AbZHQIUy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 04:20:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757223AbZHQIUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 04:20:54 -0400
Received: from mail-px0-f196.google.com ([209.85.216.196]:47650 "EHLO
	mail-px0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757220AbZHQIUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 04:20:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mH5Gjl44hXqpMtBRjoxdGBTcpKD5xSYL2bxjNYKOfpwYZVuKrnCy/T8UldbbwJVy5r
         2mfB8Zn36T2LsSdNfoBySwmy2yOu09W5/x4wVvfrtk+P1c37Get+t9zgfK1pOlwLyWUU
         y/OZDLOJa0Dqb8fdRRGQyeU6/YzN1EwwTKIus=
Date: Mon, 17 Aug 2009 16:23:10 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Michael Abbott <michael@araneidae.co.uk>
Cc: Amerigo Wang <xiyou.wangcong@gmail.com>,
       Jan Engelhardt <jengelh@medozas.de>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Re: /proc/uptime idle counter remains at 0
Message-ID: <20090817082310.GB5868@cr0.nay.redhat.com>
References: <alpine.LSU.2.00.0905090957490.27646@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0908141315310.1670@venus.araneidae.co.uk> <20090817052502.GJ5039@cr0.nay.redhat.com> <Pine.LNX.4.64.0908170707550.1592@venus.araneidae.co.uk> <20090817062324.GN5039@cr0.nay.redhat.com> <Pine.LNX.4.64.0908170743300.1592@venus.araneidae.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0908170743300.1592@venus.araneidae.co.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 17, 2009 at 07:58:29AM +0100, Michael Abbott wrote:
>On Mon, 17 Aug 2009, Amerigo Wang wrote:
>> On Mon, Aug 17, 2009 at 07:12:36AM +0100, Michael Abbott wrote:
>> >On Mon, 17 Aug 2009, Amerigo Wang wrote:
>> >> On Fri, Aug 14, 2009 at 01:18:08PM +0100, Michael Abbott wrote:
>> >> >commit 6d67e34f45a92f347388e35bd84bf0361e660d3b
>> >> >Author: Michael Abbott <michael.abbott@diamond.ac.uk>
>> >> >Date:   Mon May 11 07:14:19 2009 +0100
>> >> >
>> >> >    Fix idle time field in /proc/uptime
>> >> >    
>> >> >    Git commit 79741dd changes idle cputime accounting, but unfortunately
>> >> >    the /proc/uptime file hasn't caught up.  Here the idle time calculation
>> >> >    from /proc/stat is copied over.  Further changes from commit e1c8053
>> >> >    are also included in this fix.
>> >> >    
>> >> >    Signed-off-by: Michael Abbott <michael.abbott@diamond.ac.uk>
>> >> >
>> >> >diff --git a/fs/proc/uptime.c b/fs/proc/uptime.c
>> >> >index 0c10a0b..be286b4 100644
>> >> >--- a/fs/proc/uptime.c
>> >> >+++ b/fs/proc/uptime.c
>> >> >@@ -4,22 +4,32 @@
>> >> > #include <linux/sched.h>
>> >> > #include <linux/seq_file.h>
>> >> > #include <linux/time.h>
>> >> >+#include <linux/kernel_stat.h>
>> >> > #include <asm/cputime.h>
>> >> >+#include <asm/div64.h>
>> >> > 
>> >> > static int uptime_proc_show(struct seq_file *m, void *v)
>> >> > {
>> >> > 	struct timespec uptime;
>> >> >-	struct timespec idle;
>> >> >-	cputime_t idletime = cputime_add(init_task.utime, init_task.stime);
>> >> >+	int i;
>> >> >+	cputime64_t idle = cputime64_zero;
>> >> >+	unsigned long int idle_mod;
>> >> >+
>> >> >+	for_each_possible_cpu(i) {
>> >> >+		idle = cputime64_add(idle, kstat_cpu(i).cpustat.idle);
>> >> >+#ifdef arch_idle_time
>> >> >+		idle = cputime64_add(idle, arch_idle_time(i));
>> >> >+#endif
>> >> 
>> >> 
>> >> This ugly #ifdef can be removed, check fs/proc/stat.c.
>> >
>> >I'm sorry?  Are you sure?  Here is what fs/proc/stat.c has to say:
>> >
>> >#ifndef arch_idle_time
>> >#define arch_idle_time(cpu) 0
>> >#endif
>> >...
>> >		idle = cputime64_add(idle, arch_idle_time(i));
>> >
>> >
>> >I think what you're actually saying is the #ifdef can be moved to 
>> >somewhere where it can be easily missed.  For this very reason, I'd rather 
>> >be more explicit about it.
>> 
>> Yes, indeed.
>> 
>> I was suggesting to move that #ifdef into some header so that
>> both two files can use it. For me, this is the better fix.
>
>Yes, you're right, this is a much better idea.  In fact, the definition of 
>the arch_idle_time symbol itself should be fixed.
>
>My problem here is I'm not getting much traction getting little patches 
>like this in;  your suggestion is almost to make this patch larger!


You can send it in another patch. ;)


>
>
>Oh, that's nasty.  Looks as if arch_idle_time only exists in 
>	arch/s390/include/asm/cputime.h
>and there are 20 other architecture specific cputime.h files as well as 
>asm-generic/cputime.h.  I guess asm-generic/cputime.h is only included if 
>an architecture specific cputime.h doesn't exist, so it would seem that 
>the direct solution would be to add
>	#define arch_idle_time(cpu) 0
>to *all* the other cputime.h files.  Ewww.


Yeah, include/asm-generic/cputime.h is the right place to add it, I think.


>
>Could we just get this patch in, please, and then maybe use this as a 
>trigger to clean up everything else?

Well, you can separate the patch and send them together.
