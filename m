Return-Path: <linux-kernel-owner+w=401wt.eu-S1756714AbZEGNWB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714AbZEGNWB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 09:22:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753487AbZEGNVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 09:21:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:36571 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589AbZEGNVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 09:21:51 -0400
Date: Thu, 7 May 2009 09:21:50 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Li Zefan <lizf@cn.fujitsu.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 7/7] tracing: add hierarchical enabling of events
In-Reply-To: <4A025AAC.2000201@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0905070912120.32734@gandalf.stny.rr.com>
References: <20090507031335.815354104@goodmis.org> <20090507031434.807772092@goodmis.org> <4A025AAC.2000201@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 7 May 2009, Li Zefan wrote:

> > With the current event directory, you can only enable individual events.
> > The file debugfs/tracing/set_event is used to be able to enable or
> > disable several events at once. But that can still be awkward.
> > 
> > This patch adds hierarchical enabling of events. That is, each directory
> > in debugfs/tracing/events has an "enable" file. This file can enable
> > or disable all events within the directory and below.
> > 
> >  # echo 1 > /debugfs/tracing/events/enable
> > 
> > will enable all events.
> > 
> >  # echo 1 > /debugfs/tracing/events/sched/enable
> > 
> > will enable all events in the sched subsystem.
> > 
> >  # echo 1 > /debugfs/tracing/events/enable
> >  # echo 0 > /debugfs/tracing/events/irq/enable
> > 
> > will enable all events, but then disable just the irq subsystem events.
> > 
> > When reading one of these enable files, there are four results:
> > 
> >  0 - all events this file affects are disabled
> >  1 - all events this file affects are enabled
> >  X - there is a mixture of events enabled and disabled
> >  ? - this file does not affect any event
> 
> I would expect reading an enable file will let me know exactly
> which events are disabled and which are enabled.
> 
> I think this is useful especially for events/system/enable.
> 
> Like this:
> 
> $ cat events/irq/enable
> 0 irq_handler_entry
> 0 irq_handler_exit
> 1 softirq_entry
> 1 softirq_exit

I thought about doing something like this, but this idea for the 
hierarchical enabling came to me around 11pm, and I had the code written 
by 11:15pm ;-)

Which means, I figured I would do it as simple as possible. We do have 
"set_event" that gives you a list of enabled events. My thought was still 
having a "1" or "0" if all are either enabled or disabled. And when it is 
a mixture, I would have a list of enabled events.

Though, it is useful. Maybe in the future. But really, the information is 
there, and I did not expect this to be a "what is enabled" file, but 
instead a "I want to enable/disable all these events". In other words, I 
was much more interested in the "write" ability than the read. But who 
knows, maybe this will change in the future.

> 
> > +static ssize_t
> > +system_enable_read(struct file *filp, char __user *ubuf, size_t cnt,
> > +		   loff_t *ppos)
> > +{
> > +	const char *system = filp->private_data;
> > +	struct ftrace_event_call *call;
> > +	char buf[2];
> > +	int set = -1;
> > +	int all = 0;
> > +	int ret;
> > +
> > +	if (system[0] == '*')
> > +		all = 1;
> > +
> > +	mutex_lock(&event_mutex);
> > +	list_for_each_entry(call, &ftrace_events, list) {
> > +		if (!call->name || !call->regfunc)
> > +			continue;
> > +
> > +		if (!all && strcmp(call->system, system) != 0)
> > +			continue;
> > +
> > +		/*
> > +		 * We need to find out if all the events are set
> > +		 * or if all events or cleared, or if we have
> > +		 * a mixture.
> > +		 */
> > +		if (call->enabled) {
> > +			switch (set) {
> > +			case -1:
> > +				set = 1;
> > +				break;
> > +			case 0:
> > +				set = 2;
> > +				break;
> > +			}
> > +		} else {
> > +			switch (set) {
> > +			case -1:
> > +				set = 0;
> > +				break;
> > +			case 1:
> > +				set = 2;
> > +				break;
> > +			}
> > +		}
> > +		/*
> > +		 * If we have a mixture, no need to look further.
> > +		 */
> > +		if (set == 2)
> > +			break;
> 
> How about:
> 
> int set = 0;
> 
> ...
> set |= (1 << call->enabled);

* paranoid *

  set |= (1 << !!call->enabled);

> ...
> 
> set == 0: '?'
> set == 1: '0'
> set == 2: '1'
> set == 3: 'X'
> 
> Will this make the code simpler? :)
> 
> Or we can go even further:
> 
> char result[4] = { '?', '0', '1', 'X' };
> ...
> buf[0] = result[set];

cute, mind sending a patch ;-)


> 
> > +	}
> > +	mutex_unlock(&event_mutex);
> > +
> > +	buf[1] = '\n';
> > +	switch (set) {
> > +	case 0:
> > +		buf[0] = '0';
> > +		break;
> > +	case 1:
> > +		buf[0] = '1';
> > +		break;
> > +	case 2:
> > +		buf[0] = 'X';
> > +		break;
> > +	default:
> > +		buf[0] = '?';
> > +	}
> > +
> > +	ret = simple_read_from_buffer(ubuf, cnt, ppos, buf, 2);
> > +
> > +	return ret;
> > +}
> > +
> > +static ssize_t
> > +system_enable_write(struct file *filp, const char __user *ubuf, size_t cnt,
> > +		    loff_t *ppos)
> > +{
> > +	const char *system = filp->private_data;
> > +	unsigned long val;
> > +	char *command;
> > +	char buf[64];
> > +	ssize_t ret;
> > +
> > +	if (cnt >= sizeof(buf))
> > +		return -EINVAL;
> > +
> > +	if (copy_from_user(&buf, ubuf, cnt))
> > +		return -EFAULT;
> > +
> > +	buf[cnt] = 0;
> > +
> > +	ret = strict_strtoul(buf, 10, &val);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	ret = tracing_update_buffers();
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	switch (val) {
> > +	case 0:
> > +	case 1:
> > +		break;
> > +
> > +	default:
> > +		return -EINVAL;
> > +	}
> > +
> > +	command = kstrdup(system, GFP_KERNEL);
> > +	if (!command)
> > +		return -ENOMEM;
> > +
> > +	ret = ftrace_set_clr_event(command, val);
> 
> I think we should pass "sched:" or "sched:*", instead of "sched",
> the comment in ftrace_set_clr_event():
> 
>          *  <name> (no ':') means all events in a subsystem with
>          *  the name <name> or any event that matches <name>

Yeah, I thought about it too. But writing the patch in 15 minutes, I 
decided that a "kstrdup" was easier than adding a ":" ;-)

I will update it.

Thanks!

-- Steve

> 
> > +	if (ret)
> > +		goto out_free;
> > +
> > +	ret = cnt;
> > +
> > + out_free:
> > +	kfree(command);
> > +
> > +	*ppos += cnt;
> > +
> > +	return ret;
> > +}
> > +
> 
> 
