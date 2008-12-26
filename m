Return-Path: <linux-kernel-owner+w=401wt.eu-S1753402AbYLZQI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402AbYLZQI6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 11:08:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752456AbYLZQIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 11:08:49 -0500
Received: from mx2.redhat.com ([66.187.237.31]:50099 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752084AbYLZQIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 11:08:49 -0500
Date: Fri, 26 Dec 2008 17:06:52 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [Patch] signal: let valid_signal() check more
Message-ID: <20081226160652.GA14825@redhat.com>
References: <20081226012612.GI3130@hack.private> <20081225180054.GA24116@redhat.com> <20081226144928.GC3156@hack.private> <20081226085654.GE755@elte.hu> <20081226171604.GE3156@hack.private>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081226171604.GE3156@hack.private>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/26, Américo Wang wrote:
>
> On Fri, Dec 26, 2008 at 09:56:54AM +0100, Ingo Molnar wrote:
> >
> >* Américo Wang <xiyou.wangcong@gmail.com> wrote:
> >
> >> >> @@ -727,7 +727,7 @@ int vt_ioctl(struct tty_struct *tty, struct file * file,
> >> >>  	{
> >> >>  		if (!perm || !capable(CAP_KILL))
> >> >>  			goto eperm;
> >> >> -		if (!valid_signal(arg) || arg < 1 || arg == SIGKILL)
> >> >> +		if (!valid_signal((int)arg) || arg == SIGKILL)
> >> >                                  ^^^^^
> >> >
> >> >The patch adds a lot of unnecessary typecasts like this.
> >> 
> >> because it's inline?
> >
> >Why does your patch add a lot of seemingly unnecessary typecasts? [if your 
> >short reply was supposed to be an answer to that question then please 
> >explain it in more detail.]
> 
> Hi, Ingo.
> 
> because I also changed the type of valid_signal():
> 
>  -static inline int valid_signal(unsigned long sig)
>  +static inline int valid_signal(int sig)

and please note that this change itself is a bit dangerous. Suppose that
a bad user does sys_prctl(PR_SET_PDEATHSIG, LONG_MIN | SIGCHLD), and now
valid_signal(arg2) (or valid_signal((int)arg2)) returns T.

(nothing really bad happens because ->pdeath_signal is "int", but still).

Note also that it is correct to do prctl(PR_SET_PDEATHSIG, 0), so the
patch was doubly wrong here.

So, please check very carefully every change you are going to do. Make
sure you don't change the behaviour, unless you think the current code
is buggy. In that case please document the fix.

OTOH, I don't understand why sys_mq_notify() accepts sigev_signo == 0,
perhaps this is oversight. good_sigevent() looks correct, but should
use the helper.

> I noticed that gcc put this kind of warning into
> -Wtraditional-conversion recently, but it is still useful to use
> explicit cast, isn't it?

I'd say explicit casts should be avoided as much as possible.

As for this particular case. Note that valid_signa((int)long_arg)
only helps to hide the problem.

Oleg.

