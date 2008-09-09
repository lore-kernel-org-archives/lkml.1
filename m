Return-Path: <linux-kernel-owner+w=401wt.eu-S1755901AbYIIJDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901AbYIIJDx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 05:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754075AbYIIJDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 05:03:45 -0400
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:44969 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754010AbYIIJDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 05:03:44 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=11UuCgJkcq4H+/tGtcX2vvn+FEN1Pu1YbbJC4Xi5CtJ2YXPYCb1utEUCyyKcBa9RyiFDG0YJXbi+UF2jpcyUPnUj891rjB1TzqvBrjg9HUFEw3J9H06QMpRl4DvDw1lIxadAfcjlyQGaNfvqN8ip/+PHI1iIvtYN3F/ebv0MqMg=  ;
X-YMail-OSG: wQS3n5IVM1lW95TV_HkTT__S43bmLJog2ZJu._Zew0377u3Bsj_flnfVPomGbfsKmx9baXpB_oLaGgo0_mNuEYy_umoWIM7uKuaJXKJWqlKHx5hyqO_QQ0WowH6uYmehbig-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC PATCH v2 0/7] Tunable sched_mc_power_savings=n
Date: Tue, 9 Sep 2008 19:03:24 +1000
User-Agent: KMail/1.9.5
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       "svaidy@linux.vnet.ibm.com" <svaidy@linux.vnet.ibm.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Andi Kleen <andi@firstfloor.org>, David Collier-Brown <davecb@sun.com>,
       Tim Connors <tconnors@astro.swin.edu.au>,
       Max Krasnyansky <maxk@qualcomm.com>
References: <20080908131334.3221.61302.stgit@drishya.in.ibm.com> <200809091759.13327.nickpiggin@yahoo.com.au> <1220948723.18239.1091.camel@twins.programming.kicks-ass.net>
In-Reply-To: <1220948723.18239.1091.camel@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809091903.24836.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 September 2008 18:25, Peter Zijlstra wrote:
> On Tue, 2008-09-09 at 17:59 +1000, Nick Piggin wrote:

> > But it's all per-cpu, so you'd have to iterate down other CPU's child
> > domains. Which may get dirtied by that CPU. So you get cacheline
> > bounces.
>
> Humm, are you saying each cpu has its own domain tree? My understanding
> was that its a global structure, eg. given:
>
>    domain[0-1]
>
> domain[0] domain[1]
>
> cpu0's parent domain is the same instance as cpu1's.

I haven't looked recently, but that's how I wrote it. Has that changed?


> > You also lose flexibility (although nobody really takes full advantage
> > of it) of totally arbitrary topology on a per-cpu basis.
>
> Afaict the only flexibility you loose is that you cannot make groups
> larger/smaller than the child domain - which given that the whole
> premesis of the groups existence is that the inner-group balancing
> should be done by the level below - doesn't make sense anyway.

But you *also* cannot have per-cpu domain trees.


> > > So my idea was to ditch the groups and just iterate over the child
> > > domains.
> >
> > I'm not saying you couldn't do it (reasonably well -- cacheline bouncing
> > might be a problem if you propose to traverse other CPU's domains), but
> > what exactly does that gain you?
>
> Those cacheline bounces could be mitigated by splitting sched_domain
> into two parts with a cacheline aligned dummy and keep the rarely
> modified data separate from the frequently modified data.

You could.


> As to the gains - a graph walk with a single type seems more elegant to
> me.

It's fundamentally two different things anyway though. I don't
see any theoretical improvement, and it definitely wouldn't
improve the practical side much if any because the biggest problem
I don't think is the simple walks themselves but the calculations
and stuff.

If it can yield something clearly better that is impossible using
domains and groups, I could change my mind.

