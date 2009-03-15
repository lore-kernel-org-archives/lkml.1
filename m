Return-Path: <linux-kernel-owner+w=401wt.eu-S1758302AbZCOKEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758302AbZCOKEp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 06:04:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752702AbZCOKEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 06:04:34 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:32916 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757445AbZCOKEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 06:04:33 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=CPPXAwf3yY5KJzeKQ5cFUgzuclVtjQ5N2rpvHhCvPGMl7FoB10LktszkipoVC82twYVGxNq28q3vN6xq8wC/dsbFvzkDTzc62MlcP/uHxHFFWIorQhH/cYyQlX5tjtIQ7dp3DMQ6n6wxOq/Nk69ewcQZqZy53N97CgFWJb4F1XA=  ;
X-YMail-OSG: 7EyqJ2kVM1kSE5n4NmXvDon1GIRUEK_TtFBSIrfGNEhSOnNZjWqKHT2acDUToSmm_97fmMi9XASEwyHwaXiUOsYsLFYwqezeQ4klzzvubOaR7PF9vcuyn3cvnx1X7XvJMt1efmZ2AxkjwJnVOZRAmD3NXQKe4s5nsiT6EafYugjg6vqknzfHHH1heCw5nMKk5eVPzDlBW0tiEX269GnzAkRMfWrtCw--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: SLOB lockup (was: Re: [tip:core/locking] lockdep: annotate reclaim context (__GFP_NOFS), fix SLOB)
Date: Sun, 15 Mar 2009 21:04:24 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-tip-commits@vger.kernel.org,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com
References: <20090128135457.350751756@chello.nl> <200903152006.21160.nickpiggin@yahoo.com.au> <20090315094704.GA21169@elte.hu>
In-Reply-To: <20090315094704.GA21169@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903152104.25683.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 15 March 2009 20:47:04 Ingo Molnar wrote:
> * Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > On Sunday 15 March 2009 17:48:18 Ingo Molnar wrote:
> > > > Cc: Nick Piggin <npiggin@suse.de>
> > > > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > > LKML-Reference: <20090128135457.350751756@chello.nl>
> > > > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > >
> > > and with this fixed, and with SLOB now being tested in -tip, the
> > > new lockdep assert attached below (followed by a real lockup)
> > > pops up.
> > >
> > > Seems like a genuine SLOB bug, probably present upstream as
> > > well.
> >
> > Hmmf. debugobjects calls back into the slab allocator from the
> > page allocator. The following patch would improve SLOB, but I
> > think it would be a good idea to avoid a dependency in that
> > direction. Can debugobjects defer this freeing?
>
> dunno - that's a question for Thomas.

Well I think it could, and it should (just add them to a list and
kick off a workqueue or something). It is not a good idea for
fringe debug functionality like this to introduce such a connection
between core code like this. Unless there is a *really* good reason.

Apart from the locking issue, I wonder if the recursion is bounded?


> this lockup does not trigger under any of the other allocators.

SLAB I suspect could trigger it (AFAIKS it frees pages back to the
allocator with locks held), but it has much more queueing and buffering
than SLOB, so it would probably be much harder to trigger it.

