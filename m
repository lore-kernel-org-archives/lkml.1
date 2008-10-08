Return-Path: <linux-kernel-owner+w=401wt.eu-S1755008AbYJHPwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008AbYJHPwf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 11:52:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754110AbYJHPw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 11:52:26 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:44814 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753167AbYJHPw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 11:52:26 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=RN4EFoatBjzsqHSIDKR3wPQmzbLq4Tf32xoDp8PDucOOAJivy57haH67FdOZQex1UCyDci/VXWOIOH8X9tlQ6VZzjZ70Jun/EdvqrV3qDu/waM2yNcUvf2hJ9LH0vEk16RVEBSDlI//nuCVpmJ4XA1jqfNE3L09/LEHZe901lNI=  ;
X-YMail-OSG: 7u_cYOQVM1lcCvtbxiaHYHW37djpf1JD5nkLWCj.0Os635Uw2Bkya1JHMzmdiwXwfFThS5yGq4tPhbyDSx0hGPMnhcTCu5nPCZoFuwkm9CZx_Nap._MCK7414zGC_34yBgZewKxDm1.sX6WDJSbKkpqocOo8pygq9M7GYuQSgQ--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC][PATCH 7/7] lockdep: spin_lock_nest_lock()
Date: Thu, 9 Oct 2008 02:52:14 +1100
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       David Miller <davem@davemloft.net>, hugh@veritas.com, mingo@elte.hu,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       davej@redhat.com, srostedt@redhat.com
References: <20080804130317.994042639@chello.nl> <alpine.LFD.1.10.0808041230070.3340@nehalem.linux-foundation.org> <20081008152708.GA11207@goodmis.org>
In-Reply-To: <20081008152708.GA11207@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810090252.15384.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 October 2008 02:27, Steven Rostedt wrote:
> On Mon, Aug 04, 2008 at 12:31:22PM -0700, Linus Torvalds wrote:
> > On Mon, 4 Aug 2008, Jeremy Fitzhardinge wrote:
> > > OK.  I don't actually need to do this, but I was asking for
> > > completeness.  But to clarify, you only need to do the reverse unlock
> > > if you do it after unlocking the outer lock?  If you're still holding
> > > the outer lock, you can unlock in any order?
> >
> > Release order should always be totally irrelevant, whether you hold outer
> > locks or not. Only the order of _getting_ locks matter.
>
> Technically, you are 100% correct.
>
> > And yes, if there is an outer lock, even the order of getting locks is
> > irrelevant, as long as anybody who gets more than one inner lock always
> > holds the outer one.
>
> But I need to disagree on a programming practice style.  Unlocking locks
> in a non nested order is just bad programming practice. Unless there is
> a good reason to do so, one should never release locks in a non reverse
> order they were taken.

An outer one might be more likely to be contended, so you might want
to release it asap.

Other times, you have lock A and lock B held (like scheduler rqs).
You can say unlock(A); unlock(B);
or if (A < B) unlock(B); unlock(A); if (A > B) unlock (B);


> This can be a source of bugs, where people might notice an outer lock
> being released and think the inner locks were too.
>
> Lately the kernel has been going through a lot of clean ups that have
> been making the kernel a much more maintainable beast. I feel we should
> enforce the rule of unlocking order (again, unless there is a good
> reason not to). Not for a technical reason, but just for a more
> maintainable one.

I don't really think it would make things more maintainable, FWIW.
