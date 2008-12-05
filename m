Return-Path: <linux-kernel-owner+w=401wt.eu-S1755154AbYLEDSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154AbYLEDSS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 22:18:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752591AbYLEDSD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 22:18:03 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:36309 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748AbYLEDSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 22:18:00 -0500
Date: Fri, 5 Dec 2008 08:47:36 +0530
From: Dipankar Sarma <dipankar@in.ibm.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Steven Rostedt <srostedt@redhat.com>, containers@lists.osdl.org,
       Ingo Molnar <mingo@elte.hu>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3] ftrace: use struct pid
Message-ID: <20081205031736.GA5265@in.ibm.com>
Reply-To: dipankar@in.ibm.com
References: <20081204052638.425740534@goodmis.org> <20081204052735.175697908@goodmis.org> <m1d4g8un6b.fsf@frodo.ebiederm.org> <1228395378.13111.23.camel@nimitz> <1228396022.13111.27.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1228396022.13111.27.camel@nimitz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2008 at 05:07:02AM -0800, Dave Hansen wrote:
> On Thu, 2008-12-04 at 04:56 -0800, Dave Hansen wrote:
> > On Thu, 2008-12-04 at 04:42 -0800, Eric W. Biederman wrote:
> > > 
> > > > +static void clear_ftrace_pid_task(struct pid **pid)
> > > > +{
> > > > +     struct task_struct *p;
> > > > +
> > >         rcu_read_lock();
> > > 
> > > > +     do_each_pid_task(*pid, PIDTYPE_PID, p) {
> > > > +             clear_tsk_trace_trace(p);
> > > > +     } while_each_pid_task(*pid, PIDTYPE_PID, p);
> > >         rcu_read_unlock()
> > > 
> > > > +     put_pid(*pid);
> > > > +
> > > > +     *pid = NULL;
> > > > +}
> > 
> > Could we get away with sticking the rcu_read_{un}lock() inside those
> > macros?  Those are going to get used in pretty high level code and we're
> > allowed to nest rcu_read_lock().  No danger of deadlocks or lock
> > inversions.
> 
> Why don't any of the other users of do_each_pid_task() use
> rcu_read_lock()?  They all seem to be under read_lock(&tasklist_lock)
> (except one is under a write lock of the same).

The pid hash list is protected by tasklist_lock, right ? If so,
holding read_lock(&tasklist_lock) will make this safe, you don't
need rcu_read_lock/unlock(). This isn't a lock-free reader.

Thanks
Dipankar
