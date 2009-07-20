Return-Path: <linux-kernel-owner+w=401wt.eu-S1752368AbZGTBcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368AbZGTBcv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 21:32:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbZGTBct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 21:32:49 -0400
Received: from mail-px0-f193.google.com ([209.85.216.193]:50387 "EHLO
	mail-px0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145AbZGTBct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 21:32:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FFdZm0PPrAy0l/XsSoS7PLYk6+nYWGCk1I2ExjI8igtEaST8pp+/cD7LvJpeGiIo1B
         EflR0xtu+NOKl2MgmH9wCGES8ZTha5zAwsBloqYoQ/N7gZrblRO+3N+PyGzUII4pxbhM
         gZd9N9Y4e08K/gnkQRr/s0G0PIHL3UCv+Rz4k=
Date: Sun, 19 Jul 2009 21:32:25 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing: dont reset set_ftrace_filter/notrace when
	opened with r/w perm
Message-ID: <20090720013219.GB5172@nowhere>
References: <20090716165135.GA4739@jolsa.lab.eng.brq.redhat.com> <4A604654.1090303@cn.fujitsu.com> <20090717111025.GC2891@jolsa.lab.eng.brq.redhat.com> <4A63C09A.80904@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A63C09A.80904@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 20, 2009 at 08:55:54AM +0800, Li Zefan wrote:
> Jiri Olsa wrote:
> > On Fri, Jul 17, 2009 at 05:37:24PM +0800, Li Zefan wrote:
> >> Jiri Olsa wrote:
> >>> If user setup set_ftrace_filter/set_ftrace_notrace files and then opens them
> >>> with read&write permissions, the previous setup will be removed.
> >>>
> >> Currently:
> >>
> >>  # echo 'sys_open sys_close' > set_ftrace_filter
> >>  # cat set_ftrace_filter
> >>  sys_open
> >>  sys_close
> >>
> >> After your patch:
> >>
> >>  # echo 'sys_open sys_close' > set_ftrace_filter
> >>  # cat set_ftrace_filter
> >>  sys_close
> >>
> > 
> > oops, sry I missed this..
> > 
> > Following patch adds new FTRACE_ITER_RESET flag, as the decision needs
> > to be taken in "open" and applied in "write".  I'm not sure whats the
> > policy for adding new flags, but it looks ok to me.
> > 
> 
> I have no strong opinion whether to do the reset in "open" or in first
> "write".
> 
> All said, I think this is cleaner, without introducing a new flag:
> 
> @@ -2260,6 +2256,9 @@ ftrace_regex_write(struct file *file, const char __user *ubuf,
>  		return 0;
>  
>  	mutex_lock(&ftrace_regex_lock);
> +	if (file->f_pos == 0 &&
> +	    (file->f_mode & FMODE_WRITE) && !(file->f_flags & O_APPEND))
> +		ftrace_filter_reset(enable);
>  
>  	if (file->f_mode & FMODE_READ) {
>  		struct seq_file *m = file->private_data;


Yeah, that avoids this need of creating a new flag.
Looks like a good solution.

