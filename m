Return-Path: <linux-kernel-owner+w=401wt.eu-S1754462AbZFVXTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462AbZFVXTV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 19:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751314AbZFVXTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 19:19:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60461 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751205AbZFVXTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 19:19:11 -0400
Date: Mon, 22 Jun 2009 16:19:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Scott James Remnant <scott@ubuntu.com>
Cc: linux-kernel@vger.kernel.org, Matt Helsley <matthltc@us.ibm.com>
Subject: Re: [PATCH] proc connector: add event for process becoming session
 leader
Message-Id: <20090622161909.e5706885.akpm@linux-foundation.org>
In-Reply-To: <E1MGUmL-00036A-EE@zelda.netsplit.com>
References: <E1MGUmL-00036A-EE@zelda.netsplit.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let's cc the Process Events developer..

On Mon, 15 Jun 2009 13:03:08 +0100
Scott James Remnant <scott@ubuntu.com> wrote:

> The act of a process becoming a session leader is a useful signal to a
> supervising init daemon such as Upstart.
> 
> While a daemon will normally do this as part of the process of becoming
> a daemon, it is rare for its children to do so.  When the children do,
> it is nearly always a sign that the child should be considered detached
> from the parent and not supervised along with it.
> 
> The poster-child example is OpenSSH; the per-login children call setsid()
> so that they may control the pty connected to them.  If the primary daemon
> dies or is restarted, we do not want to consider the per-login children
> and want to respawn the primary daemon without killing the children.
> 
> This patch adds a new PROC_SID_EVENT and associated structure to the
> proc_event event_data union, it arranges for this to be emitted when
> the special PIDTYPE_SID pid is set.
> 

hm, well, I don't have much useful to say about the overall idea, but
it seems to slot into the existing code simply enough.

> ---
>  drivers/connector/cn_proc.c |   25 +++++++++++++++++++++++++
>  include/linux/cn_proc.h     |   10 ++++++++++
>  kernel/exit.c               |    4 +++-
>  3 files changed, 38 insertions(+), 1 deletions(-)

We seem to have forgotten to document this entire interface, so I can't
ding you for forgetting to update the forgotten documentation.

> diff --git a/drivers/connector/cn_proc.c b/drivers/connector/cn_proc.c
> index c5afc98..7d48cd9 100644
> --- a/drivers/connector/cn_proc.c
> +++ b/drivers/connector/cn_proc.c
> @@ -139,6 +139,31 @@ void proc_id_connector(struct task_struct *task, int which_id)
>  	cn_netlink_send(msg, CN_IDX_PROC, GFP_KERNEL);
>  }
>  
> +void proc_sid_connector(struct task_struct *task)

It would be nice to have a nice comment explaining what this function
does.  Ditto all the others in there, really.

> +{
> +	struct cn_msg *msg;
> +	struct proc_event *ev;
> +	struct timespec ts;
> +	__u8 buffer[CN_PROC_MSG_SIZE];
> +
> +	if (atomic_read(&proc_event_num_listeners) < 1)
> +		return;
> +
> +	msg = (struct cn_msg*)buffer;
> +	ev = (struct proc_event*)msg->data;

Please pass all patches through scripts/checkpatch.pl.

> +	get_seq(&msg->seq, &ev->cpu);
> +	ktime_get_ts(&ts); /* get high res monotonic timestamp */
> +	put_unaligned(timespec_to_ns(&ts), (__u64 *)&ev->timestamp_ns);
> +	ev->what = PROC_EVENT_SID;
> +	ev->event_data.sid.process_pid = task->pid;

This is a bit of a worry.  In a containerised environment, pids are not
unique.  Now what do we do?

> +	ev->event_data.sid.process_tgid = task->tgid;
> +
> +	memcpy(&msg->id, &cn_proc_event_id, sizeof(msg->id));
> +	msg->ack = 0; /* not used */
> +	msg->len = sizeof(*ev);
> +	cn_netlink_send(msg, CN_IDX_PROC, GFP_KERNEL);
> +}
> +
>  void proc_exit_connector(struct task_struct *task)
>  {
>  	struct cn_msg *msg;
> diff --git a/include/linux/cn_proc.h b/include/linux/cn_proc.h
> index b8125b2..47dac5e 100644
> --- a/include/linux/cn_proc.h
> +++ b/include/linux/cn_proc.h
> @@ -52,6 +52,7 @@ struct proc_event {
>  		PROC_EVENT_EXEC = 0x00000002,
>  		PROC_EVENT_UID  = 0x00000004,
>  		PROC_EVENT_GID  = 0x00000040,
> +		PROC_EVENT_SID  = 0x00000080,
>  		/* "next" should be 0x00000400 */
>  		/* "last" is the last process event: exit */
>  		PROC_EVENT_EXIT = 0x80000000
> @@ -89,6 +90,11 @@ struct proc_event {
>  			} e;
>  		} id;
>  
> +		struct sid_proc_event {
> +			__kernel_pid_t process_pid;
> +			__kernel_pid_t process_tgid;
> +		} sid;
> +
>  		struct exit_proc_event {
>  			__kernel_pid_t process_pid;
>  			__kernel_pid_t process_tgid;
> @@ -102,6 +108,7 @@ struct proc_event {
>  void proc_fork_connector(struct task_struct *task);
>  void proc_exec_connector(struct task_struct *task);
>  void proc_id_connector(struct task_struct *task, int which_id);
> +void proc_sid_connector(struct task_struct *task);
>  void proc_exit_connector(struct task_struct *task);
>  #else
>  static inline void proc_fork_connector(struct task_struct *task)
> @@ -114,6 +121,9 @@ static inline void proc_id_connector(struct task_struct *task,
>  				     int which_id)
>  {}
>  
> +static inline void proc_sid_connector(struct task_struct *task)
> +{}
> +
>  static inline void proc_exit_connector(struct task_struct *task)
>  {}
>  #endif	/* CONFIG_PROC_EVENTS */
> diff --git a/kernel/exit.c b/kernel/exit.c
> index b6c90b5..5162589 100644
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -360,8 +360,10 @@ void __set_special_pids(struct pid *pid)
>  {
>  	struct task_struct *curr = current->group_leader;
>  
> -	if (task_session(curr) != pid)
> +	if (task_session(curr) != pid) {
>  		change_pid(curr, PIDTYPE_SID, pid);
> +		proc_sid_connector(curr);
> +	}
>  
>  	if (task_pgrp(curr) != pid)
>  		change_pid(curr, PIDTYPE_PGID, pid);

