Return-Path: <linux-kernel-owner+w=401wt.eu-S1753152AbYIJIEE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152AbYIJIEE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 04:04:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbYIJIDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 04:03:47 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:47046 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751171AbYIJIDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 04:03:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=NDKOzy9E7HCG/to1SFRcPAac05t16KbK2W+HIj0j8wtw7WhXPlx0a8u+fzk05qyVJ2z6XCLmDDfYLttFy9syGuDltwxX6RionfIwaSvwZOr5L87dX+vs3pGti39QcN79e9m64lJ1eCqhIQNXV/h5wjvmKhHDwk4DlkVdjhIMzSY=  ;
X-YMail-OSG: SObFAqcVM1nxXjea0Um5MrSotDX9q.GAWhrMLrDzfByetAkE.OPXcg2VFUffbJPob.QmVbwVzzHmrwiWdv54E.XdNbSZ99UH5b2JeEBfTw7i_8E4Ag1.zS0hzM73UPKfm0rkUccGRd7vmIbPs6zH1JgD
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [2.6.27-rc5] inotify_read's ev_mutex vs do_page_fault's mmap_sem...
Date: Wed, 10 Sep 2008 18:03:19 +1000
User-Agent: KMail/1.9.5
Cc: Daniel J Blueman <daniel.blueman@gmail.com>, torvalds@linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, mingo <mingo@elte.hu>
References: <6278d2220809091403k65187128keec3b401717f1ec0@mail.gmail.com> <200809101407.16323.nickpiggin@yahoo.com.au> <1221033455.31904.1221.camel@twins.programming.kicks-ass.net>
In-Reply-To: <1221033455.31904.1221.camel@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809101803.20758.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 September 2008 17:57, Peter Zijlstra wrote:
> On Wed, 2008-09-10 at 14:07 +1000, Nick Piggin wrote:
> > On Wednesday 10 September 2008 07:03, Daniel J Blueman wrote:
> > > I observed this locking violation [1] while gnome-panel was loading;
> > > this was previously reported at
> > > http://uwsg.iu.edu/hypermail/linux/kernel/0806.3/2881.html .
> > >
> > > Let me know for more information/config/testing. Thanks!
> >
> > Thanks for the report. I've attached a patch you could test. It compiles
> > (and boots a UML here) but I don't think I've actually tested the inotify
> > path at all, so it may explode on you.
> >
> > Peter, this copy_*_user stuff is quite a nightmare... Well actually it
> > isn't, if the code is designed with it in mind from the start, but it is
> > easy for people to forget it can take mmap_sem and filesystem locks... Is
> > there a way to annotate it and say "might take mmap_sem for read" for
> > example? So that these LORs will _always_ trigger rather than just once
> > in a million times when the reclaim gods frown on us?
>
> Sure, how about the below - untested - uncompiled, might eat kittens,
> etc..
>
> Just sprinkle something like:
>
>   might_lock_read(&mm->mmap_sem);
>
> in the right places.

Ahh, very nice, thanks! I'll give that a try...


> ---
> Subject: lockdep: might_lock annotation
>
> useful to establish a lock dependency in case the actual dependency is
> rare or hard to trigger.
>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
> diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
> index 331e5f1..0aa657a 100644
> --- a/include/linux/lockdep.h
> +++ b/include/linux/lockdep.h
> @@ -480,4 +480,22 @@ static inline void print_irqtrace_events(struct
> task_struct *curr) # define lock_map_release(l)			do { } while (0)
>  #endif
>
> +#ifdef CONFIG_PROVE_LOCKING
> +# define might_lock(lock) 						\
> +do {									\
> +	typecheck(struct lockdep_map *, &(lock)->dep_map);		\
> +	lock_acquire(&(lock)->dep_map, 0, 0, 0, 2, NULL, _THIS_IP_);	\
> +	lock_release(&(lock)->dep_map, 0, _THIS_IP_);			\
> +} while (0)
> +# define might_lock_read(lock) 						\
> +do {									\
> +	typecheck(struct lockdep_map *, &(lock)->dep_map);		\
> +	lock_acquire(&(lock)->dep_map, 0, 0, 1, 2, NULL, _THIS_IP_);	\
> +	lock_release(&(lock)->dep_map, 0, _THIS_IP_);			\
> +} while (0)
> +#else
> +# define might_lock(lock) do { } while (0)
> +# define might_lock_read(lock) do { } while (0)
> +#endif
> +
>  #endif /* __LINUX_LOCKDEP_H */
