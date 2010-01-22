Return-Path: <linux-kernel-owner+w=401wt.eu-S1753733Ab0AVBJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733Ab0AVBJs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 20:09:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753334Ab0AVBJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 20:09:47 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38381 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327Ab0AVBJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 20:09:46 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 22 Jan 2010 10:06:28 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       rientjes@google.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] oom-kill: add lowmem usage aware oom kill handling
Message-Id: <20100122100628.593f3394.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <28c262361001211640w4ff6d61mdf682fa706ab61e@mail.gmail.com>
References: <20100121145905.84a362bb.kamezawa.hiroyu@jp.fujitsu.com>
	<1264087124.1818.15.camel@barrios-desktop>
	<20100122084856.600b2dd5.kamezawa.hiroyu@jp.fujitsu.com>
	<28c262361001211640w4ff6d61mdf682fa706ab61e@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jan 2010 09:40:17 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> On Fri, Jan 22, 2010 at 8:48 AM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > On Fri, 22 Jan 2010 00:18:44 +0900
> > Minchan Kim <minchan.kim@gmail.com> wrote:
> >
> >> Hi, Kame.
> >>
> >> On Thu, 2010-01-21 at 14:59 +0900, KAMEZAWA Hiroyuki wrote:
> >> > A patch for avoiding oom-serial-killer at lowmem shortage.
> >> > Patch is onto mmotm-2010/01/15 (depends on mm-count-lowmem-rss.patch)
> >> > Tested on x86-64/SMP + debug module(to allocated lowmem), works well.
> >> >
> >> > ==
> >> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> >> >
> >> > One cause of OOM-Killer is memory shortage in lower zones.
> >> > (If memory is enough, lowmem_reserve_ratio works well. but..)
> >> >
> >> > In lowmem-shortage oom-kill, oom-killer choses a vicitim process
> >> > on their vm size. But this kills a process which has lowmem memory
> >> > only if it's lucky. At last, there will be an oom-serial-killer.
> >> >
> >> > Now, we have per-mm lowmem usage counter. We can make use of it
> >> > to select a good? victim.
> >> >
> >> > This patch does
> >> >   - add CONSTRAINT_LOWMEM to oom's constraint type.
> >> >   - pass constraint to __badness()
> >> >   - change calculation based on constraint. If CONSTRAINT_LOWMEM,
> >> >     use low_rss instead of vmsize.
> >>
> >> As far as low memory, it would be better to consider lowmem counter.
> >> But as you know, {vmsize VS rss} is debatable topic.
> >> Maybe someone doesn't like this idea.
> >>
> > About lowmem, vmsize never work well.
> >
> 
> Tend to agree with you.
> I am just worried about "vmsize lovers".
> 
> You removed considering vmsize totally.
> In case of LOWMEM, lowcount considering make sense.
> But never considering vmsize might be debatable.
> 
> So personllay, I thouhg we could add more weight lowcount
> in case of LOWMEM. But I chaged my mind.
> I think it make OOM heurisic more complated without big benefit.
> 
thanks. I don't want patch-drop again, either :)

> Simple is best.
> 
> >> So don't we need any test result at least?
> > My test result was very artificial, so I didn't attach the result.
> >
> >  - Before this patch, sshd was killed at first.
> >  - After this patch, memory consumer of low-rss was killed.
> 
> Okay. You already anwsered my question by Balbir's reply.
> I had a question it's real problem and how often it happens.
> 
> >
> >> If we don't have this patch, it happens several innocent process
> >> killing. but we can't prevent it by this patch.
> >>
> > I can't catch what you mean.
> 
> I just said your patch's benefit.
> 
> >> Sorry for bothering you.
> >>
> >
> > Hmm, boot option or CONFIG ? (CONFIG_OOMKILLER_EXTENSION ?)
> >
> > I'm now writing fork-bomb detector again and want to remove current
> > "gathering child's vm_size" heuristics. I'd like to put that under
> > the same config, too.
> 
> Totally, I don't like CONFIG option for that.
> But vmsize lovers also don't want to change current behavior.
> So it's desirable until your fork-form detector become mature and
> prove it's good.
> 
Hmm, Okay, I'll add some. Kosaki told me sysctl is better. I'll check
how it looks.

> One more questions about below.
> 
> +       if (constraint != CONSTRAINT_LOWMEM) {
> +               list_for_each_entry(child, &p->children, sibling) {
> +                       task_lock(child);
> +                       if (child->mm != mm && child->mm)
> +                               points += child->mm->total_vm/2 + 1;
> +                       task_unlock(child);
> +               }
> 
> Why didn't you consider child's lowmem counter in case of LOWMEM?
> 
Assume process A, B, C, D. B and C are children of A.
 
  A (low_rss = 0)
  B (low_rss = 20)
  C (low_rss = 20)
  D (low_rss = 20)

When we caluculate A's socre by above logic, A's score may be greater than
B and C, D. We do targetted oom-kill as sniper, not as genocider. So, ignoreing
children here is better, I think.
I'll add some explanation to changelog.

Thanks,
-Kame





