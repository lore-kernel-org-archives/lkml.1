Return-Path: <linux-kernel-owner+w=401wt.eu-S1752905AbYHLHby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905AbYHLHby (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 03:31:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751509AbYHLHbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 03:31:46 -0400
Received: from smtp111.mail.mud.yahoo.com ([209.191.84.64]:26265 "HELO
	smtp111.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751505AbYHLHbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 03:31:45 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=RihO0Ng8sOVZAFVHOUCB3sMZ6YtXQZCslav5Ir/Wmnz47jVAAN4zLJuwDWaz/mWdGHwRyBKq+bED9rNBuq0qmIlYgga6g5kXeZ/QyToR4ZTsaeiXAJ5s8swDxjo5qEBDpg1tKwjmO+C7ViSX8rUfcdQ64HSWd8Q0LQWiNyV3yqk=  ;
X-YMail-OSG: tX52f_kVM1ml5CVqSdmpIWEHBMG.jnFT.W10Iq9ZxPNgqupjkk27HntBq3sHokwSDg5l2uZ_wCTIuAkS.4LW0lxpwAewNxAbEpc8.HuCqh79N9RKQN1wg4Xu396Dbex86Kg-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [git pull] core fixes
Date: Tue, 12 Aug 2008 17:31:36 +1000
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Paul E McKenney <paulmck@linux.vnet.ibm.com>
References: <20080811222026.GA20579@elte.hu> <200808121613.24846.nickpiggin@yahoo.com.au> <1218525442.10800.152.camel@twins>
In-Reply-To: <1218525442.10800.152.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808121731.37296.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 August 2008 17:17, Peter Zijlstra wrote:
> On Tue, 2008-08-12 at 16:13 +1000, Nick Piggin wrote:
> > On Tuesday 12 August 2008 08:20, Ingo Molnar wrote:
> > > Nick Piggin (1):
> > >       generic-ipi: fix stack and rcu interaction bug in
> > > smp_call_function_mask()
> >
> > I'm still not 100% sure that I have this patch right... I might have seen
> > a lockup trace implicating the smp call function path... which may have
> > been due to some other problem or a different bug in the new call
> > function code, but if some more people can take a look at it before
> > merging?
>
> Right - so we cannot use synchronize_rcu() because the caller of
> smp_call_function_mask() might not be in a preemptible context.
>
> Therefore you implement this barrier like function, that uses the single
> call ipi to validate that all the cpus are done processing the
> call_function_queue - because that is with IRQs disabled, and this other
> IPI cannot interrupt. Thereby guaranteeing that there are no more
> references to any former elements on said list.
>
> Clever. But as you say, rather expensive.

Yeah... Aside, I think this is how some OSes implement a lot of
scalable read side primitives without RCU. Downside is that it
requires interrupt disabled read side, upside is much simpler and
potentially more deterministic to quiesce. (and fewer patents I
guess!)
