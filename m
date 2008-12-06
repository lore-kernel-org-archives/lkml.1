Return-Path: <linux-kernel-owner+w=401wt.eu-S1757139AbYLFIs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757139AbYLFIs7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 03:48:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752140AbYLFIsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 03:48:50 -0500
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:39142 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053AbYLFIsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 03:48:50 -0500
Date: Sat, 6 Dec 2008 14:12:23 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Jay Lan <jlan@sgi.com>
Cc: Hugh Dickins <hugh@veritas.com>, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Pirko <jpirko@redhat.com>, linux-kernel@vger.kernel.org,
       Jonathan Lim <jlim@sgi.com>
Subject: Re: [PATCH] introduce get_mm_hiwater_xxx(), fix
	taskstats->hiwater_xxx accounting
Message-ID: <20081206084223.GA24782@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: Jay Lan <jlan@sgi.com>, Hugh Dickins <hugh@veritas.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jiri Pirko <jpirko@redhat.com>, linux-kernel@vger.kernel.org,
	Jonathan Lim <jlim@sgi.com>
References: <20081203181220.GA22918@redhat.com> <Pine.LNX.4.64.0812031957570.19174@blonde.anvils> <20081204135250.GA5448@redhat.com> <Pine.LNX.4.64.0812051216020.10157@blonde.anvils> <493975BE.60202@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <493975BE.60202@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jay Lan <jlan@sgi.com> [2008-12-05 10:41:02]:

> Hugh Dickins wrote:
> > On Thu, 4 Dec 2008, Oleg Nesterov wrote:
> >> On 12/03, Hugh Dickins wrote:
> >>> On Wed, 3 Dec 2008, Oleg Nesterov wrote:
> >>>
> >>>> Unless we are going to decrease rss/vm there is no point to call the
> >>>> (racy) update_hiwater_xxx() helpers. Still do_exit() does this, and
> >>> I'm puzzled by this comment.  exit() _is_ about to decrease rss/vm,
> >>> so isn't it right to be calling update_hiwater_xxx()?
> >> Do you mean exit_mm()->...->exit_mmap() ? But this doesn't matter, this
> >> ->mm is going away. Nobody can read these counters when ->mm_users == 0,
> >> no?
> > 
> > I was conceding that point in my next sentence...
> > 
> >>> There is a question of who's going to be able to see the result from
> >>> this point on: I forget whether I was doing it for my own satisfaction,
> >>> or for a real observer.
> > 
> > I've looked back at it now: the hiwater fields already existed, their
> > updates were slowing things down, and nothing in tree was even looking
> > at the results; I changed the way they were updated to minimize the
> > slowdown.
> > 
> > So my principal reason for putting the updates in do_exit() was simply
> > that there had been an update_mem_hiwater(tsk) there in do_exit(), and
> > no examples of how the results would get used, so I thought I'd better
> > update them there too.
> 
> Add Jonathan Lim to cc. He is responsible for CSA. The applications
> using those data are running at user space through the taskstats
> interface. That was the whole point of creating taskstats interface:
> move accounting modules to user space.

Yes, true and getdelays can display all the exported information.

The race does seem concerning, I would vote for keeping the update in
there and disabling preemption around the update, so that hiwater
cannot swing back and forth.

-- 
	Balbir
