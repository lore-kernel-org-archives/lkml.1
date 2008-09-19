Return-Path: <linux-kernel-owner+w=401wt.eu-S1756935AbYISAfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935AbYISAfZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 20:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755518AbYISAfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 20:35:14 -0400
Received: from byss.tchmachines.com ([208.76.80.75]:50304 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755720AbYISAfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 20:35:13 -0400
Date: Thu, 18 Sep 2008 17:35:09 -0700
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] printk: Print cpuid along with the timestamp with
	CONFIG_PRINTK_TIME
Message-ID: <20080919003509.GB21915@localdomain>
References: <20080918193720.GA21915@localdomain> <20080918125123.1a76978f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080918125123.1a76978f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2008 at 12:51:23PM -0700, Andrew Morton wrote:
>On Thu, 18 Sep 2008 12:37:20 -0700
>Ravikiran G Thirumalai <kiran@scalex86.org> wrote:
>> 
>> Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>
>> 
>> Index: linux-git/kernel/printk.c
>> ===================================================================
>> --- linux-git.orig/kernel/printk.c	2008-09-16 15:37:48.000000000 -0700
>> +++ linux-git/kernel/printk.c	2008-09-18 12:27:10.489662938 -0700
>> @@ -739,9 +739,10 @@ asmlinkage int vprintk(const char *fmt, 
>>  
>>  				t = cpu_clock(printk_cpu);
>>  				nanosec_rem = do_div(t, 1000000000);
>> -				tlen = sprintf(tbuf, "[%5lu.%06lu] ",
>> +				tlen = sprintf(tbuf, "[%5lu.%06lu:%d] ",
>>  						(unsigned long) t,
>> -						nanosec_rem / 1000);
>> +						nanosec_rem / 1000,
>> +						printk_cpu);
>>  
>>  				for (tp = tbuf; tp < tbuf + tlen; tp++)
>>  					emit_log_char(*tp);
>
>
>Your patch illogically ties the cpu-id-printing feature to the
>printk.time feature.  I guess that's liveable with, but
>Documentation/kernel-parameters.txt should be updated.
>

Didn't realize Documentation/kernel-parameters.txt had reference and even a
runtime parameter to control this!  I always enabled CONFIG_PRINTK_TIME
to get timestamps. Here's an updated patch.

As for the cpuid with the timestamp, the timestamp that is being
is  the printed the cpu's time stamp.

---

Add cpuid information to printk if CONFIG_PRINTK_TIME is enabled.
This information is useful to debug hangs and boot issues.

Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>

Index: linux-git/kernel/printk.c
===================================================================
--- linux-git.orig/kernel/printk.c	2008-09-16 15:37:48.000000000 -0700
+++ linux-git/kernel/printk.c	2008-09-18 12:27:10.489662938 -0700
@@ -739,9 +739,10 @@ asmlinkage int vprintk(const char *fmt, 
 
 				t = cpu_clock(printk_cpu);
 				nanosec_rem = do_div(t, 1000000000);
-				tlen = sprintf(tbuf, "[%5lu.%06lu] ",
+				tlen = sprintf(tbuf, "[%5lu.%06lu:%d] ",
 						(unsigned long) t,
-						nanosec_rem / 1000);
+						nanosec_rem / 1000,
+						printk_cpu);
 
 				for (tp = tbuf; tp < tbuf + tlen; tp++)
 					emit_log_char(*tp);
Index: linux-git/Documentation/kernel-parameters.txt
===================================================================
--- linux-git.orig/Documentation/kernel-parameters.txt	2008-09-16 11:30:13.000000000 -0700
+++ linux-git/Documentation/kernel-parameters.txt	2008-09-18 17:11:35.167079714 -0700
@@ -1687,7 +1687,10 @@ and is between 256 and 4096 characters. 
 			default: off.
 
 	printk.time=	Show timing data prefixed to each printk message line
-			Format: <bool>  (1/Y/y=enable, 0/N/n=disable)
+			Format: <bool>  (1/Y/y=enable, 0/N/n=disable).
+			Per-cpu timestamps are prefixed as
+			"[sssss.uuuuuu:cpuid]" on each and every line printed,
+			if this option is enabled.
 
 	profile=	[KNL] Enable kernel profiling via /proc/profile
 			Format: [schedule,]<number>
