Return-Path: <linux-kernel-owner+w=401wt.eu-S1759378AbYDNCOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759378AbYDNCOg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 22:14:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754140AbYDNCO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 22:14:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59230 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753617AbYDNCO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 22:14:27 -0400
Date: Sun, 13 Apr 2008 19:13:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Benjamin Herrenschmidt <benh@ozlabs.org>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       linuxppc-dev@ozlabs.org, takata@linux-m32r.org,
       linux-m32r@ml.linux-m32r.org, Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH 1/2] Add thread_info_cache_init() to all archs
Message-Id: <20080413191338.9776ebd0.akpm@linux-foundation.org>
In-Reply-To: <1208133506.6958.82.camel@pasglop>
References: <20080410032354.90CB1DDF0F@ozlabs.org>
	<20080413171953.bde5e9ac.akpm@linux-foundation.org>
	<1208133506.6958.82.camel@pasglop>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2008 10:38:26 +1000 Benjamin Herrenschmidt <benh@ozlabs.org> wrote:

> > > +#ifndef thread_info_cache_init
> > > +#define thread_info_cache_init	do { } while(0)
> > > +#endif
> > 
> > This trick does cause a bit of a problem: it is undefined which arch header
> > file is to provide the alternative definition of thread_info_cache_init.
> 
> I this case it's well defined: thread_info.h. Maybe I should add a
> comment ?
> 
> > So we can (and have) ended up in the situation where the override appears
> > in different files on different architectures and various screwups ensue.
> 
> Yup.
> 
> > So I'd suggest that we have a bigfatcomment telling implementors which file
> > the override should be implemented in.  And make sure that this arch file is
> > directly included from within sched.h.
> 
> Will do.
> 
> > I have a suspicion that we can still get in a mess if .c files include the
> > per-arch file and don't include sched.h, but I forget where this happened
> > and why it broke stuff.
> 
> In this case, there's only one call site and will only every be one, so
> that shouldn't be a problem. I don't see init/main.c not including
> sched.h

As long as init.c directly includes sched.h, and as long as sched.h
directly includes thread_info.h and as long as all architectures which
provide the override put it in their thread_info.h, and as long as the same
applies to all future .c users, we're good.  That's a lot of "as long as"'s ;)

> > Sigh.  A nice, coded-in-C implementation within each and every architecture
> > remains the best implementation, and all the little tricks-to-save-typing
> > have failure modes.
> 
> Well, I started doing it in all arch, and people around here told me
> that was not a good idea , that it would be trouble if the prototype
> ever had to change (adding an arg, etc... though very unlikely to happen
> in that case, granted).

Bah.  Use of grep and basic typing skills: not so hard.

> > otoh, if only one .c file will ever call this function then I think that
> > all problems are solved by
> > 
> > a) moving the above ifdeffery into the .c file
> > b) adding a comment explaining which arch file must provide the override
> > c) directly including that file from within the .c file.
> 
> I can definitely do that. I have no problem either way. I can add to all
> archs too, it's just that whatever way I choose, some people won't be
> happy with it :-)
> 
> Anyway, I'll move the ifdeferry to init/main.c then.

Thanks ;)

I'm still wounded by my recent encounter with set_softirq_pending()
and or_softirq_pending().
