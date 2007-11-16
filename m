Return-Path: <linux-kernel-owner+w=401wt.eu-S1761581AbXKPKtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761581AbXKPKtA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 05:49:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751829AbXKPKsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 05:48:53 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:10350 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbXKPKsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 05:48:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KhNI2JGP2v1JCMw/sdYZZCpljcNa0U4pSMrLra27nCpVPWiPbUeG7vE7jmF0HIcsceHSr1rKwuNu9v/mX4YRZnt4NT6t2OmedLxMMKSTjil/eFRhRR9fXIJdxULGM8CM22L/VvJyjGfpRs4zf/M5VO5gXd6V99KNafGjdl2t10o=
Message-ID: <b647ffbd0711160248v444d8f64ic72a17fcb56adc6d@mail.gmail.com>
Date: Fri, 16 Nov 2007 11:48:50 +0100
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Micah Dowty" <micah@vmware.com>
Subject: Re: High priority tasks break SMP balancer?
Cc: "Ingo Molnar" <mingo@elte.hu>, "Christoph Lameter" <clameter@sgi.com>,
       "Kyle Moffett" <mrmacman_g4@mac.com>, "Cyrus Massoumi" <cyrusm@gmx.net>,
       "LKML Kernel" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@osdl.org>, "Mike Galbraith" <efault@gmx.de>,
       "Paul Menage" <menage@google.com>,
       "Peter Williams" <pwil3058@bigpond.net.au>
In-Reply-To: <20071116060700.GD16273@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4734F397.7080802@gmx.net>
	 <2FAA6826-653E-482F-A037-C539BAEEA1DA@mac.com>
	 <20071115191408.GA4914@vmware.com>
	 <Pine.LNX.4.64.0711151206370.28639@schroedinger.engr.sgi.com>
	 <20071115202425.GC4914@vmware.com>
	 <Pine.LNX.4.64.0711151328090.29711@schroedinger.engr.sgi.com>
	 <20071115213510.GA16079@vmware.com>
	 <Pine.LNX.4.64.0711151830260.31691@schroedinger.engr.sgi.com>
	 <20071116024408.GA20322@vmware.com> <20071116060700.GD16273@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/11/2007, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Micah Dowty <micah@vmware.com> wrote:
>
> > > I am a bit at a loss as to how this could relate to the patch. This
> > > looks like a load balance logic issue that causes the load
> > > calculation to go wrong?
> >
> > My best guess is that this has something to do with the timing with
> > which we sample the CPU's instantaneous load when calculating the load
> > averages.. but I still understand only the basics of the scheduler and
> > SMP balancer. All I really know for sure at this point regarding your
> > patch is that git-bisect found it for me.
>
> hm, your code uses timeouts for this, right? The CPU load average that
> is used for SMP load balancing is sampled from the scheduler tick - and
> has been sampled from the scheduler tick for eons. v2.6.23 defaulted to
> a different method but v2.6.24 samples it from the tick again.

yeah... but one of the kernels in question is actually 2.6.23.1, which
does use the 'precise' accounting.

Micah,

could you try to change either :

cat /proc/sys/kernel/sched_stat_granularity

put it to the value equal to a tick on your system

or just remove bit #3 (which is responsible for 8 == 1000) here:

cat /proc/sys/kernel/sched_features

(this one is enabled by default in 2.6.23.1)

anyway, when it comes to calculating rq->cpu_load[], a nice(0) cpu-hog
task (on cpu_0) may generate a similar load (contribute to
rq->cpu_load[]) as e.g. some negatively reniced task (on cpu_1) which
runs only periodically (say, once in a tick for N ms., etc.) [*]

The thing is that the higher a prio of the task, the bigger 'weight'
it has (prio_to_wait[] table in sched.c) ... and roughly, the load it
generates is not only 'proportional' to 'run-time per fixed interval
of time' but also to its 'weight'. That's why the [*] above.

so you may have a situation :

cpu_0 : e.g. a nice(-20) task running periodically every tick and
generating, say ~10% cpu load ;

cpu_1 : 2-3 nice(0) cpu-hog tasks ;

both cpus may be seen with similar rq->load_cpu[]... yeah, one would
argue that one of the cpu hogs could be migrated to cpu_0 and consume
remaining 'time slots' and it would not "disturb" the nice(-20) task
as :
it's able to preempt the lower prio task whenever it want (provided,
fine-grained kernel preemption) and we don't care that much of
trashing of caches here.

btw., without the precise load balancing, there can be situations when
the nice(-20) (or say, a RT periodic task) can be even not seen (i.e.
don't contribute to cpu_load[]) on cpu_0...
we do sampling every tick (sched.c :: update_cpu_load()) and consider
this_rq->ls.load.weight at this particular moment (that is the sum of
'weights' for all runnable tasks on this rq)... and it may well be
that the aforementioned high-priority task is just never (or likely,
rarely) runnable at this particular moment (it runs for short interval
of time in between ticks).


>
>         Ingo
>

-- 
Best regards,
Dmitry Adamushko
