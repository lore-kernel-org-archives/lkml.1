Return-Path: <linux-kernel-owner+w=401wt.eu-S1755635AbYIHWdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635AbYIHWdv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 18:33:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754326AbYIHWdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 18:33:41 -0400
Received: from mail.vyatta.com ([216.93.170.194]:38999 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753828AbYIHWdk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 18:33:40 -0400
X-Spam-Flag: NO
X-Spam-Score: -1.53
Date: Mon, 8 Sep 2008 15:33:37 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: "Dushan Tcholich" <dusanc@gmail.com>, "David Miller" <davem@davemloft.net>
Cc: romieu@fr.zoreil.com, hancockr@shaw.ca, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org
Subject: Re: [PATCH] bridge: don't allow setting hello time to zero
Message-ID: <20080908153337.002e1401@extreme>
In-Reply-To: <a08621850809081435g6c0c9d5bwdd8cf937eec9e2db@mail.gmail.com>
References: <20080831100537.6929c51e@extreme>
	<20080831104309.780cc01f@extreme>
	<20080904154709.48fe0775@extreme>
	<20080908.134650.26179244.davem@davemloft.net>
	<a08621850809081435g6c0c9d5bwdd8cf937eec9e2db@mail.gmail.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Sep 2008 23:35:19 +0200
"Dushan Tcholich" <dusanc@gmail.com> wrote:

> On Mon, Sep 8, 2008 at 10:46 PM, David Miller <davem@davemloft.net> wrote:
> > From: Stephen Hemminger <shemminger@vyatta.com>
> > Date: Thu, 4 Sep 2008 15:47:09 -0700
> >
> >> The bridge hello time can't be safely set to values less than 1 second,
> >> otherwise it is possible to end up with a runaway timer.
> >>
> >> Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
> >
> > Applied, thanks Stephen.
> >
> > I added more information to the commit message so that Dushan's
> > incredibly contribution to this bug getting fixed are mentioned.
> > I don't see how we would have figured out Bridging as even the
> > cause without his detective work.  So it's definitely wrong not
> > to give him at least some mention in the commit message :-/
> >
> 
> I don't know what to say :)
> 
> Thank you
> > bridge: don't allow setting hello time to zero
> >
> > Dushan Tcholich reports that on his system ksoftirqd can consume
> > between %6 to %10 of cpu time, and cause ~200 context switches per
> > second.
> >
> A little nitpick: 200 times greater context switch rate :), like
> 100000 per second.
> 
> > He then correlated this with a report by bdupree@techfinesse.com:
> >
> >        http://marc.info/?l=linux-kernel&m=119613299024398&w=2
> >
> > and the culprit cause seems to be starting the bridge interface.
> > In particular, when starting the bridge interface, his scripts
> > are specifying a hello timer interval of "0".
> >
> > The bridge hello time can't be safely set to values less than 1
> > second, otherwise it is possible to end up with a runaway timer.
> 
> Btw. is there a way to make the command to turn STP off work too?
> brctl stp br0 off
> Because AFAIK if I shut down STP the hello timer should shut down too,
> but it still continues to work.
> 
> Thank you for your time and effort
> 
> Dushan Tcholich
>

The basics:
* Hello timer is always enabled
* STP defaults to off unless you turn it on
* Turn STP on/off with brctl.

In the existing design, the hello timer always runs, even when STP
is not turned on. If STP is not enabled, the packet is just never
created.  Fixing it would not be hard (or gain much), but would have
to deal with complex lock ordering and timer problems, so it isn't
worth fixing for current releases.

