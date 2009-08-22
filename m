Return-Path: <linux-kernel-owner+w=401wt.eu-S1755702AbZHVKgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702AbZHVKgO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 06:36:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755515AbZHVKgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 06:36:14 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:41195 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755343AbZHVKgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 06:36:13 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4A8FCA03.6090107@s5r6.in-berlin.de>
Date: Sat, 22 Aug 2009 12:35:47 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.22) Gecko/20090630 SeaMonkey/1.1.17
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Is adding requeue_delayed_work() a good idea
References: <adazl9uw3w1.fsf@cisco.com> <20090821115547.GA6901@redhat.com> <adaab1sx29p.fsf@cisco.com>
In-Reply-To: <adaab1sx29p.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
[Oleg Nesterov wrote]
> Perhaps the semantics are sufficiently fuzzy and not general enough, so
> that the best answer is my special-case open coded change for my
> specific case.  I don't know whether other places would even want a
> requeue_delayed_work() ... I simply raise this point because when I find
> myself reimplementing the structure of work_struct + timer because
> delayed_work API is lacking, then it seems prudent to consider extending
> delayed_work API instead.

There are two or three use cases of rescheduling a delayed work in 
drivers/firewire, but in one regard they are simpler than your case:

The work only needs to be pushed back in time, never scheduled earlier 
than it was originally scheduled.  This is easily implemented with the 
existing delayed work API by letting the work check whether it is 
entered too early; if yes, reschedule itself.

Further requirements of this use case:
   - It doesn't matter on which CPU this kind of work runs on.
   - If the event which necessitates rescheduling happens when the
     work is already running, then it might depend on the outcome of
     the work whether it needs to be scheduled again.  I think the
     requeue_delayed_work should do nothing in that case and the
     work needs to test how it went and rearm if necessary.

Well, considering the latter point, there is no harm in keeping all of 
the requeue_delayed_work logic concentrated in the work itself in these 
FireWire use cases.

[These use cases are high-level protocols for resource acquisition over 
the FireWire bus.  Cooperative fairness schemes require them to be timed 
after a grace period for resource re-acquisition by holders of older 
resources, following after bus reset events which may happen any time.]

So, the question is whether there is any user besides IB which needs to 
pull a delayed work forward in time.

Or another thought:  Would it hurt if you ignored any shortening of 
timeouts, i.e. reduce your use case also to only ever _deferring_ work, 
never rescheduling to an earlier point in time?
-- 
Stefan Richter
-=====-==--= =--- =-==-
http://arcgraph.de/sr/
