Return-Path: <linux-kernel-owner+w=401wt.eu-S1753548AbZIPBdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548AbZIPBdg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 21:33:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751042AbZIPBdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 21:33:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:64174 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbZIPBdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 21:33:32 -0400
Subject: Re: [PATCHv2] tracing - support multiple pids in set_pid_ftrace
 file
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: jolsa@redhat.com, mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <4AB038A7.2070108@cn.fujitsu.com>
References: <1253019893-30131-1-git-send-email-jolsa@redhat.com>
	 <4AB038A7.2070108@cn.fujitsu.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 15 Sep 2009 21:33:33 -0400
Message-Id: <1253064813.20020.171.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-16 at 09:00 +0800, Li Zefan wrote:
> jolsa@redhat.com wrote:
> > Adding the possibility to set more than 1 pid in the set_pid_ftrace file,
> > thus allowing to trace more than 1 independent processes.
> > 
> > Usage:
> > 
> > sh-4.0# echo 284 > ./set_ftrace_pid 
> > sh-4.0# cat ./set_ftrace_pid 
> > 284
> > sh-4.0# echo 1 >> ./set_ftrace_pid 
> > sh-4.0# echo 0 >> ./set_ftrace_pid 
> > sh-4.0# cat ./set_ftrace_pid 
> > swapper tasks
> > 1
> > 284
> > sh-4.0# echo 4 > ./set_ftrace_pid 
> > sh-4.0# cat ./set_ftrace_pid 
> > 4
> > sh-4.0# echo > ./set_ftrace_pid 
> > sh-4.0# cat ./set_ftrace_pid 
> > no pid
> > sh-4.0# 
> > 
> > 
> > wbr,
> > jirka
> > 
> > Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> 
> Looks good.
> 
> Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>

Thanks!

> 
> a few nitpicks.
> 
> >  /* set when tracing only a pid */
> 
> This comment should be removed too.

Yeah, it goes with the deleted pointer below.

> 
> > -struct pid *ftrace_pid_trace;
> >  static struct pid * const ftrace_swapper_pid = &init_struct_pid;
> >  
> ...
> > +static int ftrace_pid_add(int p)
> > +{
> > +	struct pid *pid;
> > +	struct ftrace_pid *fpid;
> > +	int ret = -EINVAL;
> > +
> > +	mutex_lock(&ftrace_lock);
> > +
> > +	if (!p)
> > +		pid = ftrace_swapper_pid;
> > +	else
> > +		pid = find_get_pid(p);
> > +
> > +	if (!pid)
> > +		goto out;
> > +
> > +	list_for_each_entry(fpid, &ftrace_pids, list)
> > +		if (fpid->pid == pid)
> > +			goto out_put;
> 
> rather than returning EINVAL, return EEXIST or just return 0?

I agree, return 0, if it already exists, there's no harm in it returning
success.

-- Steve


