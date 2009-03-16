Return-Path: <linux-kernel-owner+w=401wt.eu-S1761504AbZCPJ5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761504AbZCPJ5W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 05:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759935AbZCPJuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 05:50:13 -0400
Received: from smtp118.mail.mud.yahoo.com ([209.191.84.167]:43049 "HELO
	smtp118.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760125AbZCPJuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 05:50:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=mKnOZBgXUap7NyVDuDcvz/3GMWtHWIfxu+8wxiglPD9WePIBlQXB8bQTOMEfCK2mev3bkURBvOBZp9CJO2wgZ358v5ZH8RzQtal+DakXlH6RvVqswY+t48EQPbH+8+mUHsXeSk/f0txGjNL4XAHQ8ZiHYu0vImDi5UQnRPnr7DM=  ;
X-YMail-OSG: I7LZVxsVM1nqtITAcWZd58zOhasZJribFuScjkGWEyRb4VwODmbD.cHCWsaYPr5SCMgO.06Ma4.Fcs5hJoJHvyNV49iL68WiNNSbOmnnwX5bfTzbzvfgcKhoNJx1XcGucLV4z2D_XydWFRgmCHSqcKWj.9a3wgtu80f_zxCkzwAByClSRc52FsOXRIXS9mr.b76meI7mc51jEend2IKMxtKHhlg0ig--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: SLOB lockup (was: Re: [tip:core/locking] lockdep: annotate reclaim context (__GFP_NOFS), fix SLOB)
Date: Mon, 16 Mar 2009 20:49:57 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Ingo Molnar <mingo@elte.hu>, linux-tip-commits@vger.kernel.org,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com
References: <20090128135457.350751756@chello.nl> <200903152104.25683.nickpiggin@yahoo.com.au> <alpine.LFD.2.00.0903151614320.29264@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903151614320.29264@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903162049.58058.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 March 2009 02:16:34 Thomas Gleixner wrote:
> On Sun, 15 Mar 2009, Nick Piggin wrote:
> > On Sunday 15 March 2009 20:47:04 Ingo Molnar wrote:
> > > * Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > > > On Sunday 15 March 2009 17:48:18 Ingo Molnar wrote:
> > > > > > Cc: Nick Piggin <npiggin@suse.de>
> > > > > > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > > > > LKML-Reference: <20090128135457.350751756@chello.nl>
> > > > > > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > > > >
> > > > > and with this fixed, and with SLOB now being tested in -tip, the
> > > > > new lockdep assert attached below (followed by a real lockup)
> > > > > pops up.
> > > > >
> > > > > Seems like a genuine SLOB bug, probably present upstream as
> > > > > well.
> > > >
> > > > Hmmf. debugobjects calls back into the slab allocator from the
> > > > page allocator. The following patch would improve SLOB, but I
> > > > think it would be a good idea to avoid a dependency in that
> > > > direction. Can debugobjects defer this freeing?
> > >
> > > dunno - that's a question for Thomas.
> >
> > Well I think it could, and it should (just add them to a list and
> > kick off a workqueue or something). It is not a good idea for
> > fringe debug functionality like this to introduce such a connection
> > between core code like this. Unless there is a *really* good reason.
> >
> > Apart from the locking issue, I wonder if the recursion is bounded?
>
> Yes. debugobject free does not call back into debugobjects, but you
> are right it should defer the free. I have rcu based deferred free in
> -rt for the very same reason. I'll whip up a solution for mainline as
> well.

Oh good, thanks for that.

