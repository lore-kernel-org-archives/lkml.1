Return-Path: <linux-kernel-owner+w=401wt.eu-S1756372AbZFYWsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372AbZFYWsb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 18:48:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753516AbZFYWsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 18:48:24 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:33318 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440AbZFYWsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 18:48:23 -0400
Date: Thu, 25 Jun 2009 15:48:12 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Scott James Remnant <scott@ubuntu.com>, linux-kernel@vger.kernel.org,
       Matt Helsley <matthltc@us.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>,
       Containers <containers@lists.linux-foundation.org>,
       Sukadev <sukadev@us.ibm.com>
Subject: Re: [PATCH] proc connector: add event for process becoming session
	leader
Message-ID: <20090625224812.GD17502@count0.beaverton.ibm.com>
References: <E1MGUmL-00036A-EE@zelda.netsplit.com> <20090622161909.e5706885.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090622161909.e5706885.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 22, 2009 at 04:19:09PM -0700, Andrew Morton wrote:
> Let's cc the Process Events developer..
> 
> On Mon, 15 Jun 2009 13:03:08 +0100
> Scott James Remnant <scott@ubuntu.com> wrote:
> 
> > The act of a process becoming a session leader is a useful signal to a
> > supervising init daemon such as Upstart.
> > 
> > While a daemon will normally do this as part of the process of becoming
> > a daemon, it is rare for its children to do so.  When the children do,
> > it is nearly always a sign that the child should be considered detached
> > from the parent and not supervised along with it.
> > 
> > The poster-child example is OpenSSH; the per-login children call setsid()
> > so that they may control the pty connected to them.  If the primary daemon
> > dies or is restarted, we do not want to consider the per-login children
> > and want to respawn the primary daemon without killing the children.
> > 
> > This patch adds a new PROC_SID_EVENT and associated structure to the
> > proc_event event_data union, it arranges for this to be emitted when
> > the special PIDTYPE_SID pid is set.
> > 
> 
> hm, well, I don't have much useful to say about the overall idea, but
> it seems to slot into the existing code simply enough.
> 
> > ---
> >  drivers/connector/cn_proc.c |   25 +++++++++++++++++++++++++
> >  include/linux/cn_proc.h     |   10 ++++++++++
> >  kernel/exit.c               |    4 +++-
> >  3 files changed, 38 insertions(+), 1 deletions(-)
> 
> We seem to have forgotten to document this entire interface, so I can't
> ding you for forgetting to update the forgotten documentation.
> 
> > diff --git a/drivers/connector/cn_proc.c b/drivers/connector/cn_proc.c
> > index c5afc98..7d48cd9 100644
> > --- a/drivers/connector/cn_proc.c
> > +++ b/drivers/connector/cn_proc.c
> > @@ -139,6 +139,31 @@ void proc_id_connector(struct task_struct *task, int which_id)
> >  	cn_netlink_send(msg, CN_IDX_PROC, GFP_KERNEL);
> >  }
> >  
> > +void proc_sid_connector(struct task_struct *task)
> 
> It would be nice to have a nice comment explaining what this function
> does.  Ditto all the others in there, really.
> 
> > +{
> > +	struct cn_msg *msg;
> > +	struct proc_event *ev;
> > +	struct timespec ts;
> > +	__u8 buffer[CN_PROC_MSG_SIZE];
> > +
> > +	if (atomic_read(&proc_event_num_listeners) < 1)
> > +		return;
> > +
> > +	msg = (struct cn_msg*)buffer;
> > +	ev = (struct proc_event*)msg->data;
> 
> Please pass all patches through scripts/checkpatch.pl.
> 
> > +	get_seq(&msg->seq, &ev->cpu);
> > +	ktime_get_ts(&ts); /* get high res monotonic timestamp */
> > +	put_unaligned(timespec_to_ns(&ts), (__u64 *)&ev->timestamp_ns);
> > +	ev->what = PROC_EVENT_SID;
> > +	ev->event_data.sid.process_pid = task->pid;
> 
> This is a bit of a worry.  In a containerised environment, pids are not
> unique.  Now what do we do?

I have been looking for ways to fix this. No good answers so far but
there's even more to worry about :(. Because we report uids and gids via
this interface any namespace-safe solution must work for combinations of
pidns and userns.

Cheers,
	-Matt Helsley
