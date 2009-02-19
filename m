Return-Path: <linux-kernel-owner+w=401wt.eu-S1756864AbZBSSzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864AbZBSSzF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 13:55:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755711AbZBSSys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 13:54:48 -0500
Received: from mx2.redhat.com ([66.187.237.31]:49847 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755591AbZBSSyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 13:54:47 -0500
Date: Thu, 19 Feb 2009 19:51:59 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Andrew Morton <akpm@osdl.org>, roland@redhat.com, daniel@hozac.com,
       Containers <containers@lists.osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7][v8] SI_USER: Masquerade si_pid when crossing pid
	ns boundary
Message-ID: <20090219185159.GA374@redhat.com>
References: <20090219030207.GA18783@us.ibm.com> <20090219030743.GG18990@us.ibm.com> <m1y6w21k6d.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1y6w21k6d.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19, Eric W. Biederman wrote:
>
> Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com> writes:
>
> > From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> > Date: Wed, 24 Dec 2008 14:14:18 -0800
> > Subject: [PATCH 7/7][v8] SI_USER: Masquerade si_pid when crossing pid ns
> > boundary
> >
> > When sending a signal to a descendant namespace, set ->si_pid to 0 since
> > the sender does not have a pid in the receiver's namespace.
> >
> > Note:
> > 	- If rt_sigqueueinfo() sets si_code to SI_USER when sending a
> > 	  signal across a pid namespace boundary, the value in ->si_pid
> > 	  will be cleared to 0.
> >
> > Changelog[v5]:
> > 	- (Oleg Nesterov) Address both sys_kill() and sys_tkill() cases
> > 	  in send_signal() to simplify code (this drops patch 7/7 from
> > 	  earlier version of patchset).
> >
> > Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> > ---
> >  kernel/signal.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> >
> > diff --git a/kernel/signal.c b/kernel/signal.c
> > index c94355b..a416d77 100644
> > --- a/kernel/signal.c
> > +++ b/kernel/signal.c
> > @@ -883,6 +883,8 @@ static int __send_signal(int sig, struct siginfo *info,
> > struct task_struct *t,
> >  			break;
> >  		default:
> >  			copy_siginfo(&q->info, info);
> > +			if (from_ancestor_ns)
> > +				q->info.si_pid = 0;
>
> This is wrong.  siginfo is a union and you need to inspect
> code to see if si_pid is present in the current union.

SI_FROMUSER() == T, unless we have more (hopefully not) in-kernel
users which send SI_FROMUSER() signals, .si_pid must be valid?

kill_pid_info_as_uid() was the only known sender of SI_FROMUSER
signal, it was converted to use __send_signal(from_ancestor_ns => 0).

Oleg.

