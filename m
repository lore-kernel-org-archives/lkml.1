Return-Path: <linux-kernel-owner+w=401wt.eu-S1760063AbZBYIK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760063AbZBYIK3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 03:10:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752816AbZBYIKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 03:10:20 -0500
Received: from smtp112.mail.mud.yahoo.com ([209.191.84.65]:44594 "HELO
	smtp112.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752633AbZBYIKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 03:10:20 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=u0Q6t0yI8Cu5WqUsPxZbTDhFyIaNsXBgI+zWb1TcYnq2u8gKK4JtwX3E2MizUdAWrmztVIPjHtLEknHHzpoJ/o1nc27aq1/e7ut8hxFw9Xu+0euTnjOYNdEjn0O8K1NXN3FEUW/XAVbUV0c9RgGNYRjTDPBnBT7VoxYxASG8rfM=  ;
X-YMail-OSG: qYQtSkoVM1nFNvfC13sa8RcCsB8OMELrrPzg8XEdD7oQ4WgQsazeNeuEunKYv4SohQqDKwCZTGgSs1z0CY6xBbFjHUa4X2YAWdjrAbsbyO2hhwSJthh6xlIALlAldQq_D8RR70I8A6sJaroSOSWxD3r52HwH29XnQgleUDyzzUJ0Tb1loYHlRBogLrpWTyYNN59I2ge3qFLkp4yjikilfs_9m.kXNrDJsDo-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] x86, mm: pass in 'total' to __copy_from_user_*nocache()
Date: Wed, 25 Feb 2009 19:09:42 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Salman Qazi <sqazi@google.com>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>
References: <20090224020304.GA4496@google.com> <200902251423.58861.nickpiggin@yahoo.com.au> <20090225072503.GD21903@elte.hu>
In-Reply-To: <20090225072503.GD21903@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902251909.42928.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 February 2009 18:25:03 Ingo Molnar wrote:
> * Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > On Wednesday 25 February 2009 02:52:34 Linus Torvalds wrote:
> > > On Tue, 24 Feb 2009, Nick Piggin wrote:
> > > > > it does make some kind of sense to try to avoid the noncached
> > > > > versions for small writes - because small writes tend to be for
> > > > > temp-files.
> > > >
> > > > I don't see the significance of a temp file. If the pagecache is
> > > > truncated, then the cachelines remain dirty and so you can't avoid an
> > > > eventual store back to RAM?
> > >
> > > No, because many small files end up being used as scratch-pads (think
> > > shell script sequences etc), and get read back immediately again. Doing
> > > non-temporal stores might just be bad simply because trying to play
> > > games with caching may simply do the wrong thing.
> >
> > OK, for that angle it could make sense. Although as has been
> > noted earlier, at this point of the copy, we don't have much
> > idea about the length of the write passed into the vfs (and
> > obviously will never know the higher level intention of
> > userspace).
> >
> > I don't know if we can say a 1 page write is nontemporal, but
> > anything smaller is temporal. And having these kinds of
> > behavioural cutoffs I would worry will create strange
> > performance boundary conditions in code.
>
> I agree in principle.
>
> The main artifact would be the unaligned edges around a bigger
> write. In particular the tail portion of a big write will be
> cached.
>
> For example if we write a 100,000 bytes file, we'll copy the
> first 24 pages (98304 bytes) uncached, while the final 1696
> bytes cached. But there is nothing that necessiates this
> assymetry.
>
> For that reason it would be nice to pass down the total size of
> the write to the assembly code. These are single-usage-site APIs
> anyway so it should be easy.
>
> I.e. something like the patch below (untested). I've extended
> the copy APIs to also pass down a 'total' size as well, and
> check for that instead of the chunk 'len'. Note that it's
> checked in the inlined portion so all the "total == len" special
> cases will optimize out the new parameter completely.

This does give more information, not exactly all (it could be
a big total write with many smaller writes especially if the
source is generated on the fly and will be in cache, or if the
source is not in cache, then we would also want to do nontemporal
loads from there etc etc).


> This should express the 'large vs. small' question adequately,
> with no artifacts. Agreed?

Well, no artifacts, but it still has a boundary condition where
one might cut from temporal to nontemporal behaviour.

If it is a *really* important issue, maybe some flags should be
incorporated into an extended API? It not, then I wonder if it
is important enough to add such complexity for?

