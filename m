Return-Path: <linux-kernel-owner+w=401wt.eu-S934097AbZGQDgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934097AbZGQDgB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 23:36:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934085AbZGQDgB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 23:36:01 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:35756 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934079AbZGQDgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 23:36:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=g1yfqrpXsHPxRq0J9Lh/18cxfgj5U/cXk3jo4etR+DVq5Stg2QwyZIDkMulN0HknlK
         OSTMeK5SUwMIAPovRQb9alD9UPpUgCKBRkPVSqQVTKEl18yT7a1uOVuc5q8g33/zjXxF
         yR/iwV/ui7MWR2ebxqLLKvbhQrteQbMlWloBk=
Date: Thu, 16 Jul 2009 23:35:53 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] tracing/function: fix the return value of
	ftrace_trace_onoff_callback()
Message-ID: <20090717033551.GA4977@nowhere>
References: <4A5D5B12.2050802@cn.fujitsu.com> <20090715142814.GA6184@nowhere> <4A5EF2F7.3090706@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A5EF2F7.3090706@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 16, 2009 at 05:29:27PM +0800, Li Zefan wrote:
> >> ftrace_trace_onoff_callback() will return error even if we do the
> >> right operation, for example:
> >>
> >> # echo _spin_*:traceon:10 > set_ftrace_filter
> >> -bash: echo: write error: Invalid argument
> >> # cat set_ftrace_filter
> >> #### all functions enabled ####
> >> _spin_trylock_bh:traceon:count=10
> >> _spin_unlock_irq:traceon:count=10
> >> _spin_unlock_bh:traceon:count=10
> >> _spin_lock_irq:traceon:count=10
> >> _spin_unlock:traceon:count=10
> >> _spin_trylock:traceon:count=10
> >> _spin_unlock_irqrestore:traceon:count=10
> >> _spin_lock_irqsave:traceon:count=10
> >> _spin_lock_bh:traceon:count=10
> >> _spin_lock:traceon:count=10
> >>
> >> We want to set _spin_*:traceon:10 to set_ftrace_filter, it complain
> >> with "Invalid argument", but the operation is successful.
> >> So, this patch fix it.
> >>
> >> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> > 
> > Looks good, thanks.
> > 
> > Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
> > 
> 
> Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
> 


Thanks!
I'm queuing it in the fixes for 2.6.31 and also add a Cc: stable@kernel.org
tag because the fix also applies on .30

I've also detailed a bit more the changelog, see below:
---
>From 04aef32d39cc4ef80087c0ce8ed113c6d64f1a6b Mon Sep 17 00:00:00 2001
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Date: Wed, 15 Jul 2009 12:29:06 +0800
Subject: [PATCH] tracing/function: Fix the return value of ftrace_trace_onoff_callback()

ftrace_trace_onoff_callback() will return an error even if we do the
right operation, for example:

 # echo _spin_*:traceon:10 > set_ftrace_filter
 -bash: echo: write error: Invalid argument
 # cat set_ftrace_filter
 #### all functions enabled ####
 _spin_trylock_bh:traceon:count=10
 _spin_unlock_irq:traceon:count=10
 _spin_unlock_bh:traceon:count=10
 _spin_lock_irq:traceon:count=10
 _spin_unlock:traceon:count=10
 _spin_trylock:traceon:count=10
 _spin_unlock_irqrestore:traceon:count=10
 _spin_lock_irqsave:traceon:count=10
 _spin_lock_bh:traceon:count=10
 _spin_lock:traceon:count=10

We want to set _spin_*:traceon:10 to set_ftrace_filter, it complains
with "Invalid argument", but the operation is successful.

This is because ftrace_process_regex() returns the number of functions that
matched the pattern. If the number is not 0, this value is returned
by ftrace_regex_write() whereas we want to return the number of bytes
virtually written.
Also the file offset pointer is not updated in this case.

If the number of matched functions is lower than the number of bytes written
by the user, this results to a reprocessing of the string given by the user with
a lower size, leading to a malformed ftrace regex and then a -EINVAL returned.

So, this patch fixes it by returning 0 if no error occured.
The fix also applies on 2.6.30

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: stable@kernel.org
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace_functions.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index 7402144..75ef000 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -363,7 +363,7 @@ ftrace_trace_onoff_callback(char *glob, char *cmd, char *param, int enable)
  out_reg:
 	ret = register_ftrace_function_probe(glob, ops, count);
 
-	return ret;
+	return ret < 0 ? ret : 0;
 }
 
 static struct ftrace_func_command ftrace_traceon_cmd = {
-- 
1.6.2.3


