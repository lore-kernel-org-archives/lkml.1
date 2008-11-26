Return-Path: <linux-kernel-owner+w=401wt.eu-S1753041AbYKZF0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041AbYKZF0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 00:26:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750981AbYKZF0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 00:26:09 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:40234 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbYKZF0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 00:26:07 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, containers@lists.osdl.org,
       fweisbec@gmail.com, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, srostedt@redhat.com,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>
References: <20081125223421.795046329@goodmis.org>
	<20081125223456.976670734@goodmis.org>
	<20081125144221.66eb99ad.akpm@linux-foundation.org>
	<alpine.DEB.1.10.0811251800130.26424@gandalf.stny.rr.com>
	<20081125153104.ecdceed4.akpm@linux-foundation.org>
	<alpine.DEB.1.10.0811251909320.26424@gandalf.stny.rr.com>
	<1227660839.12109.52.camel@nimitz>
	<alpine.DEB.1.10.0811251956570.26424@gandalf.stny.rr.com>
Date: Tue, 25 Nov 2008 21:20:31 -0800
In-Reply-To: <alpine.DEB.1.10.0811251956570.26424@gandalf.stny.rr.com> (Steven
	Rostedt's message of "Tue, 25 Nov 2008 20:01:34 -0500 (EST)")
Message-ID: <m1myfncbc0.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Steven Rostedt <rostedt@goodmis.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 1/3] ftrace: add function tracing to single thread
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> writes:

> On Tue, 25 Nov 2008, Dave Hansen wrote:
>> > 
>> > I think the end result was, if this file can only be changed by root, then 
>> > we do not need to worry about namespaces. This file is a privileged file 
>> > that can only be modified by root.
>> > 
>> > If someday we decide to let non admin users touch this file, then we would
>> > need to care about this.  This file may actually be modified in the future 
>> > by users, so this may become an issue.
>> 
>> This really has very little to do with root vs non-root users.  In fact,
>> we're working towards having cases where we have many "root" users, even
>> those inside namespaces.  It is also quite possible for a normal root
>> user to fork into a new pid namespace.  In that case, root simply won't
>> be able to use this feature because something like:
>> 	
>> 	echo $$ /debugfs/tracing/set_ftrace_pid
>> 	
>> just won't work.  Let's look at a bit of the code.
>> 
>> +static void ftrace_pid_func(unsigned long ip, unsigned long parent_ip)
>> +{
>> +       if (current->pid != ftrace_pid_trace)
>> +               return;
>> +
>> +       ftrace_pid_function(ip, parent_ip);
>> +}
>> 
>> One thing this doesn't deal with is pid wraparound.  Does that matter?
>
> Should not.  This is just a way to trace a particular process. Currently 
> it traces all processes. If we wrap, then we trace the process with the 
> new pid. This should not be an issue.

So.  Using raw pid numbers in the kernel is bad form.  The internal
representation should be struct pid pointers as much as we can make
them.

I would 100% prefer it if ftrace_pid_func was written in terms of struct
pid.  That does guarantee you don't have pid wrap around issues.
It almost makes it clear 

+static void ftrace_pid_func(unsigned long ip, unsigned long parent_ip)
+{
+	if (task_pid(current) == ftrace_pid_trace)
+               return;
+
+       ftrace_pid_function(ip, parent_ip);
+}

We don't need locks to access the pid of current.


>> If you want to fix this a bit, instead of saving off the pid_t in
>> ftrace_pid_trace, you should save a 'struct pid'.  You can get the
>> 'struct pid' for a particular task by doing a find_get_pid(pid_t).  You
>> can then compare that pid_t to current by doing a
>> pid_task(struct_pid_that_i_saved, PIDTYPE_PID).  That will also protect
>> against pid wraparound.
>> 
>> The find_get_pid() is handy because it will do the pid_t lookup in the
>> context of the current task's pid namespace, which is what you want, I
>> think.
>
> Nope, we can not call that in this context. ftrace_pid_func is called 
> directly from mcount, without any protection.

Of course you can't.  But at the same time find_get_pid() is always
supposed to be called on the user space pid ingress path.

> struct pid *find_get_pid(pid_t nr)
> {
> 	struct pid *pid;
>
> 	rcu_read_lock();
> 	pid = get_pid(find_vpid(nr));
> 	rcu_read_unlock();
>
> 	return pid;
> }
> EXPORT_SYMBOL_GPL(find_get_pid);
>
> This means find_get_pid will call mcount which will call ftrace_pid_func, 
> and back again. This can also happen with rcu_read_{un}lock() and 
> get_pid() and find_vpid().
>
> We can not do anything special here.

I don't see the whole path.  But here is the deal.
1) Using struct pid and the proper find_get_pid() means that a user with
   the proper capabilities/permissions who happens to be running in a pid
   namespace can call this and it will just work.

2) The current best practices in the current are to:
   - call find_get_pid() when you capture a user space pid.
   - call put_pid() when you are done with it.

   Perhaps that is just:
   put_pid(ftrace_pid_trace);
   ftrace_pid_trace = find_get_pid(user_provided_pid_value);

3) If you ultimately want to support the full gamut:
   thread/process/process group/session.  You will need
   to use struct pid pointer comparisons.

4) When I looked at the place you were concerned about races 
   a) you were concerned about the wrong race.
   b) I don't see a race.
   c) You were filtering for the tid of a linux task not
      the tgid of a process.  So the code didn't seem to
      be doing what you thought it was doing.

5) I keep thinking current->pid should be removed some day.

So let's do this properly if we can.  This is a privileged operation
so we don't need to support people without the proper capabilities
doing this.  Or multiple comparisons or anything silly like that.  But
doing this with struct pid comparisons seems cleaner and more maintainable.  And that
really should matter.

Eric
