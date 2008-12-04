Return-Path: <linux-kernel-owner+w=401wt.eu-S1755977AbYLDNqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977AbYLDNqd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 08:46:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753419AbYLDNqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 08:46:23 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:32942 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104AbYLDNqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 08:46:22 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Steven Rostedt <srostedt@redhat.com>, containers@lists.osdl.org,
       Ingo Molnar <mingo@elte.hu>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3] ftrace: use struct pid
References: <20081204052638.425740534@goodmis.org>
	<20081204052735.175697908@goodmis.org>
	<m1d4g8un6b.fsf@frodo.ebiederm.org> <1228395378.13111.23.camel@nimitz>
	<1228396022.13111.27.camel@nimitz>
Date: Thu, 04 Dec 2008 05:40:00 -0800
In-Reply-To: <1228396022.13111.27.camel@nimitz> (Dave Hansen's message of
	"Thu, 04 Dec 2008 05:07:02 -0800")
Message-ID: <m1prk8t5xr.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: No (on mx04.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen <dave@linux.vnet.ibm.com> writes:

> On Thu, 2008-12-04 at 04:56 -0800, Dave Hansen wrote:
>> On Thu, 2008-12-04 at 04:42 -0800, Eric W. Biederman wrote:
>> > 
>> > > +static void clear_ftrace_pid_task(struct pid **pid)
>> > > +{
>> > > +     struct task_struct *p;
>> > > +
>> >         rcu_read_lock();
>> > 
>> > > +     do_each_pid_task(*pid, PIDTYPE_PID, p) {
>> > > +             clear_tsk_trace_trace(p);
>> > > +     } while_each_pid_task(*pid, PIDTYPE_PID, p);
>> >         rcu_read_unlock()
>> > 
>> > > +     put_pid(*pid);
>> > > +
>> > > +     *pid = NULL;
>> > > +}
>> 
>> Could we get away with sticking the rcu_read_{un}lock() inside those
>> macros?  Those are going to get used in pretty high level code and we're
>> allowed to nest rcu_read_lock().  No danger of deadlocks or lock
>> inversions.
>
> Why don't any of the other users of do_each_pid_task() use
> rcu_read_lock()?  They all seem to be under read_lock(&tasklist_lock)
> (except one is under a write lock of the same).

We probably should.  Historically read_lock(&tasklist_lock) implies
rcu_read_lock().  And the tasklist lock is what we hold when it is safe.

But if you look at find_vpid we should be holding just the rcu lock there.

Eric
