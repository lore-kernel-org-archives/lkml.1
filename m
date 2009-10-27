Return-Path: <linux-kernel-owner+w=401wt.eu-S932211AbZJ0IxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211AbZJ0IxS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 04:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756620AbZJ0IxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 04:53:18 -0400
Received: from mail-yx0-f187.google.com ([209.85.210.187]:64923 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756619AbZJ0IxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 04:53:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=xe4TTt9Grl5DJCuMoVlLS9qCcQ1PMzavGBUGY70bw69daao6dZ+I/CKNwJOZyzVAWk
         wMyK/0QIypwoSLaWhszYYyKr1ByeJ91HWisYnLodrXkyh97RrwtGEHuaPmYFjvh4KZ4u
         hLdUC+l9XTqV2eoMB61H8o0vhBZx6P/VvkYYw=
Date: Tue, 27 Oct 2009 17:52:43 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       vedran.furac@gmail.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       rientjes@google.com
Subject: Re: [RFC][PATCH] oom_kill: avoid depends on total_vm and use real
 RSS/swap value for oom_score (Re: Memory overcommit
Message-Id: <20091027175243.31105265.minchan.kim@barrios-desktop>
In-Reply-To: <20091027173308.cc0eb535.kamezawa.hiroyu@jp.fujitsu.com>
References: <hav57c$rso$1@ger.gmane.org>
	<hb2cfu$r08$2@ger.gmane.org>
	<20091014135119.e1baa07f.kamezawa.hiroyu@jp.fujitsu.com>
	<4ADE3121.6090407@gmail.com>
	<20091026105509.f08eb6a3.kamezawa.hiroyu@jp.fujitsu.com>
	<4AE5CB4E.4090504@gmail.com>
	<20091027122213.f3d582b2.kamezawa.hiroyu@jp.fujitsu.com>
	<2f11576a0910262310g7aea23c0n9bfc84c900879d45@mail.gmail.com>
	<20091027153429.b36866c4.minchan.kim@barrios-desktop>
	<20091027153626.c5a4b5be.kamezawa.hiroyu@jp.fujitsu.com>
	<28c262360910262355p3cac5c1bla4de9d42ea67fb4e@mail.gmail.com>
	<20091027164526.da6a23cb.kamezawa.hiroyu@jp.fujitsu.com>
	<20091027165628.acda4540.kamezawa.hiroyu@jp.fujitsu.com>
	<20091027171441.ca9600ea.minchan.kim@barrios-desktop>
	<20091027173308.cc0eb535.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Oct 2009 17:33:08 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Tue, 27 Oct 2009 17:14:41 +0900
> Minchan Kim <minchan.kim@gmail.com> wrote:
> 
> > On Tue, 27 Oct 2009 16:56:28 +0900
> > KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > 
> > > On Tue, 27 Oct 2009 16:45:26 +0900
> > > KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > >   	/*
> > > >  	 * After this unlock we can no longer dereference local variable `mm'
> > > > @@ -92,8 +93,13 @@ unsigned long badness(struct task_struct
> > > >  	 */
> > > >  	list_for_each_entry(child, &p->children, sibling) {
> > > >  		task_lock(child);
> > > > -		if (child->mm != mm && child->mm)
> > > > -			points += child->mm->total_vm/2 + 1;
> > > > +		if (child->mm != mm && child->mm) {
> > > > +			unsigned long cpoint;
> > > > +			/* At considering child, we don't count swap */
> > > > +			cpoint = get_mm_counter(child->mm, anon_rss) +
> > > > +				 get_mm_counter(child->mm, file_rss);
> > > > +			points += cpoint/2 + 1;
> > > > +		}
> > > >  		task_unlock(child);
> > > 
> > > BTW, I'd like to get rid of this code.
> > > 
> > > Can't we use other techniques for detecting fork-bomb ?
> > > 
> > > This check can't catch following type, anyway.
> > > 
> > >    fork()
> > >      -> fork()
> > >           -> fork()
> > >                -> fork()
> > >                     ....
> > > 
> > > but I have no good idea.
> > > What is the difference with task-launcher and fork bomb()...
> > > 
> > 
> > I think it's good as-is. 
> > Kernel is hard to know it by effiecient method.
> > It depends on applications. so Doesnt's task-launcher 
> > like gnome-session have to control his oom_score? 
> > 
> > Welcome to any ideas if kernel can do it well.
> > 
> Hmmm, check system-wide fork/sec and fork-depth ? Maybe not difficult to calculate..

Yes. We can do anything to achieve the goal in kernel. 
Maybe check the time or fork-depth counting. 
What I have a concern is how we can do it nicely if it is a serious
problem in kernel. ;)

I think most of program which have many child are victims of OOM killing.
It make sense to me. There is some cases to not make sense like task-launcher.
So I think if task-launcher which is very rare and special program can change
oom_adj by itself, it's good than thing that add new heuristic in kernel.

It's just my opinon. :)

> Regards,
> -Kame
> 


-- 
Kind regards,
Minchan Kim
