Return-Path: <linux-kernel-owner+w=401wt.eu-S1752412AbZH0O3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412AbZH0O3c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 10:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752241AbZH0O3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 10:29:32 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42300 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155AbZH0O3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 10:29:30 -0400
Date: Thu, 27 Aug 2009 16:29:27 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Li_Xin2@emc.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: TCP keepalive timer problem
Message-ID: <20090827142927.GA17220@basil.fritz.box>
References: <0939B589FC103041945B9F13274963E303B1A9D4@CORPUSMX90A.corp.emc.com> <4A93E36C.8070502@gmail.com> <0939B589FC103041945B9F13274963E303B1AD89@CORPUSMX90A.corp.emc.com> <4A967FCE.3000807@gmail.com> <87skfdl6qt.fsf@basil.nowhere.org> <4A969566.3070606@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4A969566.3070606@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 27, 2009 at 04:17:10PM +0200, Eric Dumazet wrote:
> Andi Kleen a écrit :
> > Eric Dumazet <eric.dumazet@gmail.com> writes:
> >> Now, 7200 seconds might be inappropriate for special needs, and considering
> >> there is no way to change tcp_retries2 for a given socket (only choice being the global
> >> tcp_retries2 setting), I would vote for a change in our stack, to *relax* RFC,
> >> and get smaller keepalive timers if possible.
> > 
> > I think the better fix would be to just to only do that when
> > tcp_retries2 > keep alive time. So keep the existing behaviour
> > with default keep alive, but switch when the user defined
> > a very short keep alive.
> > 
> 
> tcp_retries2 is a number of retries, its difficult to derive a time from it.

That shouldn't be too hard. 

> 
> Also, it's not clear what behavior you are refering to.
> Imagine we can be smart and compute tcp_retries2_time (in jiffies) from tcp_retries2
> If keepalive_timer fires and we have packets in flight, what heuristic do you suggest ?

I didn't suggest to change something at firing time, just pattern
the code you removed with if (keepalive_time > retries2 time)

That's not perfect, but likely good enough.


> if (tp->packets_out || tcp_send_head(sk))
> 	if (tcp_retries2_time < keepalive_time_when(tp))
> 		goto resched;
> elapsed = tcp_time_stamp - tp->rcv_tstamp;
> ...
> 
> What would be the gain ?
> Arming timer exactly every keepalive_time_when(tp)
> instead of keepalive_time_when(tp) - (tcp_time_stamp - tp->rcv_tstamp) ?

The gain would be that you don't send unnecessary packets by default (following the RFC), but 
still give expected behaviour to users who explicitely set short keepalives.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
