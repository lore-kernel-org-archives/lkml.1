Return-Path: <linux-kernel-owner+w=401wt.eu-S933896AbYD1MD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933896AbYD1MD6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 08:03:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765318AbYD1MDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 08:03:49 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:33001 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754756AbYD1MDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 08:03:48 -0400
Date: Mon, 28 Apr 2008 17:33:43 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: get_online_cpus() && workqueues
Message-ID: <20080428120343.GD23162@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20080423035802.GA8895@in.ibm.com> <20080424150714.GA8273@osiris.boeblingen.de.ibm.com> <1209052984.7115.369.camel@twins> <20080424155946.GA11160@tv-sign.ru> <20080424194810.GA4821@osiris.boeblingen.de.ibm.com> <20080424192706.GA165@tv-sign.ru> <20080425064044.GA10817@osiris.boeblingen.de.ibm.com> <20080426144330.GA6150@tv-sign.ru> <20080428070256.GB14285@in.ibm.com> <20080428105649.GE143@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080428105649.GE143@tv-sign.ru>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 02:56:49PM +0400, Oleg Nesterov wrote:
> On 04/28, Gautham R Shenoy wrote:
> >
> > On Sat, Apr 26, 2008 at 06:43:30PM +0400, Oleg Nesterov wrote:
> > > 
> > > Can't we add another nested lock which is dropped right after __cpu_die()?
> > > (in fact I think it could be dropped after __stop_machine_run).
> > > 
> > > The new read-lock is get_online_map() (just a random name for now). The only
> > > difference wrt get_online_cpus() is that it doesn't protect against CPU_DEAD,
> > > but most users of get_online_cpus() doesn't need this, they only need a
> > > stable cpu_online_map and sometimes they need to be sure that some per-cpu
> > > object (say, cpu_workqueue_struct->thread) can't be destroyed under this
> > > lock.
> > > 
> > > get_online_map() seem to fit for this, and can be used from work->func().
> > > (actually, I think most users of use get_online_cpus() could use the new
> > > helper instead, but this doen't matter).
> > 
> > However, subsystems such as cpufreq require serialization with respect
> > to the whole CPU-Hotplug operation since they do initialization and
> > cleanup pre and  post the change of the cpu_online_map.
> > The current code, or this patch doesn't help in such cases
> > when such subsystems have multithreaded workqueues!
> 
> Yes, I see, thanks. Heiko has pointed this too.
> 
> > One of the thoughts I have is to provide an API along the lines of
> > try_get_online_cpus() which will return 1 if there is no CPU Hotplug
> > operation in progress and will return 0 otherwise. In case where
> > a cpu-hotplug operation is in progress, the workitem could simply
> > do nothing other than requeue itself and wait for the cpu-hotplug
> > operation to complete.
>
> Yes, possible, but it is not nice that work->func() can't just use
> get_online_cpus()...

Like I said, it depends on what they want to use it for. If it is just
protection against the changing of the cpu_online_map then, it's simple
as using get_online_map(), i.e the patch you provided.

BTW, the other thing I am concerned about is the
naming. Dont the names get_online_cpus() and get_online_map()
appear very similar. The last thing we want is driver writers getting
confused over what API to use!

>
> > Else, we might want to do something like what slab.c does.
> > It sets the per-cpu work.func of the cpu-going down to NULL in
> > CPU_DOWN_PREPARE.


>
> Yes, but this is different. Please note also that this particular
> work must not use get_online_cpus(), no matter what changes we can
> make. Otherwise cancel_delayed_work_sync() can deadlock.
>
> What do you think about another patch I sent? I am not happy with it,
> and it certainly uglifies cpu.c, but it is simple...

I am currently testing out the patchstack sent
by peterz. Once that's done I will see if I can integrate this patch
with the previous patches and repost the whole series.

>
> Oleg.

-- 
Thanks and Regards
gautham
