Return-Path: <linux-kernel-owner+w=401wt.eu-S1758762AbZEFH2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758762AbZEFH2U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 03:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752797AbZEFH2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 03:28:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44417 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014AbZEFH2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 03:28:08 -0400
Date: Wed, 6 May 2009 09:27:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [FOR REVIEW, PATCH 2/2] introduce "struct wait_opts" to
	simplify do_wait() pathes
Message-ID: <20090506072756.GA17457@elte.hu>
References: <20090506053324.GA31988@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090506053324.GA31988@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Oleg Nesterov <oleg@redhat.com> wrote:

> Introduce "struct wait_opts" which holds the parameters for misc 
> helpers in do_wait() pathes.
> 
> This adds 17 lines to kernel/exit.c, but saves 256 bytes from .o 
> and imho makes the code much more readable.
> 
> (untested, not signed)
> 
>  kernel/exit.c |  211 +++++++++++++++++++++++++++++++---------------------------
>  1 file changed, 114 insertions(+), 97 deletions(-)

> +struct wait_opts {
> +	enum pid_type		wtype;
> +	struct pid		*wpid;
> +	int			wflags;
> +
> +	struct siginfo __user	*winfo;
> +	int __user		*wstat;
> +	struct rusage __user	*wrusage;
> +
> +	int			notask_error;
> +};

Nice idea!

One small nit with the definition above: when using vertical spacing 
(which really looks nice) we tend to put the asterix to the type 
itself, not to the variable. I.e.:

	enum pid_type		wtype;
	struct pid *		wpid;
	int			wflags;

( This is done to separate the field name from the type - the 
  pointer nature of the field is part of the type, not part of the
  name. )

It's impressive how well the function prototypes get compressed and 
cleaned up by this helper structure:

> -static int eligible_child(enum pid_type type, struct pid *pid, int options,
> -			  struct task_struct *p)
> +static int eligible_child(struct wait_opts *wopts, struct task_struct *p)

> -static int wait_noreap_copyout(struct task_struct *p, pid_t pid, uid_t uid,
> -			       int why, int status,
> -			       struct siginfo __user *infop,
> -			       struct rusage __user *rusagep)
> +static int wait_noreap_copyout(struct wait_opts *wopts, struct task_struct *p,
> +				pid_t pid, uid_t uid, int why, int status)

> -static int wait_task_zombie(struct task_struct *p, int options,
> -			    struct siginfo __user *infop,
> -			    int __user *stat_addr, struct rusage __user *ru)
> +static int wait_task_zombie(struct wait_opts *wopts, struct task_struct *p)

> -static int wait_task_stopped(int ptrace, struct task_struct *p,
> -			     int options, struct siginfo __user *infop,
> -			     int __user *stat_addr, struct rusage __user *ru)
> +static int wait_task_stopped(struct wait_opts *wopts,
> +				int ptrace, struct task_struct *p)

> -static int wait_task_continued(struct task_struct *p, int options,
> -			       struct siginfo __user *infop,
> -			       int __user *stat_addr, struct rusage __user *ru)
> +static int wait_task_continued(struct wait_opts *wopts, struct task_struct *p)

> -static int wait_consider_task(struct task_struct *parent, int ptrace,
> -			      struct task_struct *p, int *notask_error,
> -			      enum pid_type type, struct pid *pid, int options,
> -			      struct siginfo __user *infop,
> -			      int __user *stat_addr, struct rusage __user *ru)
> +static int wait_consider_task(struct wait_opts *wopts, struct task_struct *parent,
> +				int ptrace, struct task_struct *p)

> -static int do_wait_thread(struct task_struct *tsk, int *notask_error,
> -			  enum pid_type type, struct pid *pid, int options,
> -			  struct siginfo __user *infop, int __user *stat_addr,
> -			  struct rusage __user *ru)
> +static int do_wait_thread(struct wait_opts *wopts, struct task_struct *tsk)

> -static int ptrace_do_wait(struct task_struct *tsk, int *notask_error,
> -			  enum pid_type type, struct pid *pid, int options,
> -			  struct siginfo __user *infop, int __user *stat_addr,
> -			  struct rusage __user *ru)
> +static int ptrace_do_wait(struct wait_opts *wopts, struct task_struct *tsk)

> -static long do_wait(enum pid_type type, struct pid *pid, int options,
> -		    struct siginfo __user *infop, int __user *stat_addr,
> -		    struct rusage __user *ru)
> +static long do_wait(struct wait_opts *wopts)

One small (style) detail here as well:

> -	ret = do_wait(type, pid, options, infop, NULL, ru);
> +
> +	wopts.wtype = type;
> +	wopts.wpid = pid;
> +	wopts.wflags = options;
> +
> +	wopts.winfo = infop;
> +	wopts.wstat = NULL;
> +	wopts.wrusage = ru;
> +
> +	ret = do_wait(&wopts);

it makes sense to write this as:

> +	wopts.wtype	= type;
> +	wopts.wpid	= pid;
> +	wopts.wflags	= options;
> +
> +	wopts.winfo	= infop;
> +	wopts.wstat	= NULL;
> +	wopts.wrusage	= ru;
> +
> +	ret = do_wait(&wopts);

(and in other places as well). Vertical spacing for assignments 
looks messy if done for 1-3 assignment lines, but in the case above 
we've got 6 of them so it has a nice vertical structure already that 
helps readability.

Regarding the patch itself: i guess we could do it as-is - but if 
you think there's regression risks, a safer approach would be to 
create 5-6 patches to build up all the structure parameters one by 
one. Such a series is a lot easier to check (and a lot easier to 
bisect to).

Anyway ... provided you give it some testing:

Reviewed-by: Ingo Molnar <mingo@elte.hu>

	Ingo
