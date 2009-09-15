Return-Path: <linux-kernel-owner+w=401wt.eu-S1753401AbZIOMgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401AbZIOMgk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 08:36:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753165AbZIOMgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 08:36:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32871 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753051AbZIOMge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 08:36:34 -0400
Date: Tue, 15 Sep 2009 14:36:17 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: mingo@elte.hu, rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracing - support multiple pids in set_pid_ftrace file
Message-ID: <20090915123617.GA26284@jolsa.lab.eng.brq.redhat.com>
References: <1253005169-32709-1-git-send-email-jolsa@redhat.com> <4AAF60F7.6040107@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AAF60F7.6040107@cn.fujitsu.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15, 2009 at 05:40:07PM +0800, Li Zefan wrote:
> jolsa@redhat.com wrote:
SNIP

> > +	list_for_each_entry_safe(fpid, safe, &ftrace_pids, list) {
> > +		struct pid *pid = fpid->pid;
> > +
> > +		clear_ftrace_pid_task(&pid);
> 
> Now we can change clear_ftrace_pid_task() to take struct pid *
> instead of struct pid**.
> 
changed

> > +
> > +		if (pid != ftrace_swapper_pid)
> > +			put_pid(pid);
> > +
> 
> clear_ftrace_pid_task() already called put_pid().
> 
oops, you're right.. missed that

> > +		list_del(&fpid->list);
> > +		kfree(fpid);
> > +	}
> > +
> > +	ftrace_update_pid_func();
> > +	ftrace_startup_enable(0);
> > +
> > +	mutex_unlock(&ftrace_lock);
> > +}
> > +
> ...
> >  static ssize_t
> >  ftrace_pid_write(struct file *filp, const char __user *ubuf,
> >  		   size_t cnt, loff_t *ppos)
> >  {
> > -	struct pid *pid;
> >  	char buf[64];
> >  	long val;
> >  	int ret;
> > @@ -2897,57 +3016,36 @@ ftrace_pid_write(struct file *filp, const char __user *ubuf,
> >  
> >  	buf[cnt] = 0;
> >  
> > +	/*
> > +	 * Allow the "echo > set_ftrace_pid" to clean
> > +	 * the pids quietly.
> > +	 */
> > +	if (!*ppos && *buf == '\n' && cnt == 1)
> > +		return 1;
> > +
> 
> How about:
> 	strstrip(buf);
> 	if (strlen(buf) == 0)
> 		return 1;
> 
thats better, changed

> So "echo -n '' > set_ftrace_pid" works too.
> 
> >  	ret = strict_strtol(buf, 10, &val);
> >  	if (ret < 0)
> >  		return ret;
> >  
> 

I'll send out v2 shortly, thanks
jirka
