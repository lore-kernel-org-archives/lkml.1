Return-Path: <linux-kernel-owner+w=401wt.eu-S1752792AbYJDGGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792AbYJDGGv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 02:06:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751201AbYJDGGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 02:06:43 -0400
Received: from ozlabs.org ([203.10.76.45]:56145 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751186AbYJDGGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 02:06:43 -0400
Date: Sat, 4 Oct 2008 16:05:06 +1000
From: David Gibson <david@gibson.dropbear.id.au>
To: eranian@gmail.com
Cc: linux-kernel@vger.kernel.org,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Subject: Re: perfmon3 interface overview
Message-ID: <20081004060506.GO30184@yookeroo.seuss>
Mail-Followup-To: David Gibson <david@gibson.dropbear.id.au>,
	eranian@gmail.com, linux-kernel@vger.kernel.org,
	perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
References: <7c86c4470809231432j4231cfa4g7dd158a7fe9c9277@mail.gmail.com> <7c86c4470809251448j65fb99f1nfdb3980e0716149a@mail.gmail.com> <20081003061713.GL3002@yookeroo.seuss> <7c86c4470810030354x6984372akfe18761da7504a0c@mail.gmail.com> <7c86c4470810030358m1a0fdcc5i5512a1c2a6696457@mail.gmail.com> <7c86c4470810030412l34d3dc13mef10c9320884d635@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c86c4470810030412l34d3dc13mef10c9320884d635@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2008 at 01:12:09PM +0200, stephane eranian wrote:
> David,
> >> [snip]
> >> > III) attaching and detaching
> >> >
> >> >   With v2.81:
> >> >      int pfm_load_context(int fd, pfarg_load_t *load);
> >> >      int pfm_unload_context(int fd);
> >> >
> >> >   With v3.0:
> >> >      int pfm_attach_session(int fd, int flags, int target);
> >> >      int pfm_detach_session(int fd, int flags);
> >>
> >> Couldn't you get rid of one more syscall here by making detach a
> >> special case of attach with a special "null" value for target, or a
> >> special flag?
> >
> >
> >  We could combine the two and use the flag field to indicate attach/detach.
> >  The target is not a pointer but an int. Some people suggested I use an
> >  unsigned long instead. In anycase, we could not use 0 to indicate "detach"
> >  because CPU0 is a valid choice for system-wide. Thus we would have to
> >  pick another value to mean "nothing", e.g, -1.
> >
> >  >  IV) starting and stopping
> >  >
> >  >    With v2.81:
> >  >       int pfm_start(int fd, pfarg_start_t *st);
> >  >       int pfm_stop(int fd);
> >  >       int pfm_restart(int fd);
> >  >
> >  >    With v3.0:
> >  >       int pfm_start_session(int fd, int flags);
> >  >       int pfm_stop_session(int fd, int flags);
> >
> >> Likewise, couldn't you cut this down by one more syscall by making it
> >>        int pfm_set_session_state(int fd, int flags);
> >> and having a 'RUNNING' flag, which selects start or stop behaviour?
> >
> >  That one we can certainly do. That's a good idea.
> 
> Some more thoughts on this.
> 
> If we wanted to go even further, we could combine start/stop, attach/detach
> into  a single syscall:

Well, you could.  But the attach/detach take a parameter which
start/stop don't, making it a less obvious merge to make.

>    int pfm_control_session(int fd, int flags, int target);
>    With flags:
>        PFM_CTFL_START  : start monitoring
>        PFM_CTFL_STOP    : stop monitoring
>        PFM_CTFL_RESTART: resume after overflow notification
> 
>        PFM_CTFL_ATTACH: attach to thread or cpu designated by 'target'
>        PFM_CTFL_DETACH: detach session
> 
> But then, this is a form of ioctl() which people don't like....

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
