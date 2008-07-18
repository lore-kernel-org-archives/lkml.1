Return-Path: <linux-kernel-owner+w=401wt.eu-S1758638AbYGRMSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758638AbYGRMSj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 08:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756415AbYGRMS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 08:18:28 -0400
Received: from sinclair.provo.novell.com ([137.65.248.137]:12688 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756478AbYGRMS2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 08:18:28 -0400
Message-Id: <488052D5.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Fri, 18 Jul 2008 06:22:45 -0600
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Cc: <mingo@elte.hu>, <dmitry.adamushko@gmail.com>,
       <torvalds@linux-foundation.org>, "Max Krasnyansky" <maxk@qualcomm.com>,
       <pj@sgi.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpu hotplug,
	sched:Introduce	cpu_active_map	and	redoscheddomainmanagment
	(take 2)
References: <1216122229-4865-1-git-send-email-maxk@qualcomm.com>
 <487DAD86.BA47.005A.0@novell.com> <487E6BD7.3020006@qualcomm.com>
 <487E7B6C.BA47.005A.0@novell.com> <487EF1E9.2040101@qualcomm.com>
 <487EFB71.BA47.005A.0@novell.com> <487F9509.9050802@qualcomm.com>
 <487F6972.BA47.005A.0@novell.com> <1216382024.28405.26.camel@twins>
In-Reply-To: <1216382024.28405.26.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

>>> On Fri, Jul 18, 2008 at  7:53 AM, in message <1216382024.28405.26.camel@twins>,
Peter Zijlstra <a.p.zijlstra@chello.nl> wrote: 
> On Thu, 2008-07-17 at 13:46 -0600, Gregory Haskins wrote:
>> >>> On Thu, Jul 17, 2008 at  2:52 PM, in message 
> <487F9509.9050802@qualcomm..com>,
>> Max Krasnyansky <maxk@qualcomm.com> wrote: 
>> > Gregory Haskins wrote:
>> >>
>> >> Hi Max,
>> >>   Thanks for the pointers.  I see that I did indeed misunderstand the 
> intent 
>> >> of the patch.  It seems you already solved the rebuild problem, and were
>> >> just trying to solve the "migrate to a dead cpu" problem that Linus 
> mentions
>> >> as a solution with cpu_active_map.
>> >
>> > Yes. btw they are definitely related, because the reason we were blowing 
>> > away the domains is to avoid "migration to a dead cpu". ie We were relying
>> > on the fact that domain masks never contain cpus that are either dying or
>> > already dead.
>> 
>> Agreed.
>> 
>> >> 
>> >> Thoughts?
>> >
>> > None at this point :). I need to run right now and will try to look at this
>> > later today. My knowledge of the internal sched structs is definitely 
>> > lacking so I need to look at the rq->rd thing to have and opinion.
>> 
>> Sounds good, Max.  Thanks!
> 
> I'm thinking doing it explicitly with the new cpu mask is clearer and
> easier to understand than 'hiding' the variable in the root domain and
> having to understand all the domain/root-domain stuff.
> 
> I think this was Linus' main point. It should be easier to understand
> this code.

While I can appreciate this sentiment, note that we conceptually require
IMO the notion that the root-domain masks present.  E.g. we really dont
want to migrate to just cpus_active_map, but rather
rq->rd->span & cpus_active_map (otherwise we could route outside
of a disjoint cpuset).  And this is precisely what rq->rd->online is (a
cached version of cpus_active_map & rq->rd->span).

So while I can understand the motivation to keep things simple, note that
I tried to design the root-domain stuff to be as simple as possible while
still meeting the requirements for working within disjoint sets.  I am
open to other suggestions, but I see nothing particularly complex or
wrong with whats going on there currently.  Perhaps this very
conversation is evidence that I needed to comment better ;)

> 
> 
> So, if there is functional overlap with the root domain stuff, it might
> be good to remove that bit and use the cpu_active_map stuff for that
> instead.

I think we would be doing the code that does use it a disservice, per above.

Regards,
-Greg


