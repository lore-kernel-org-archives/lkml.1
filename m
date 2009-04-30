Return-Path: <linux-kernel-owner+w=401wt.eu-S1754323AbZD3Haw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323AbZD3Haw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 03:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754114AbZD3Hal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 03:30:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41264 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398AbZD3Hak (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 03:30:40 -0400
From: Nikanth Karthikesan <knikanth@novell.com>
Organization: Novell
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][RFC] Handle improbable possibility of io_context->refcount overflow
Date: Thu, 30 Apr 2009 12:58:15 +0530
User-Agent: KMail/1.11.1 (Linux/2.6.27.21-0.1-default; KDE/4.2.1; x86_64; ; )
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
References: <200904291221.40361.knikanth@novell.com> <200904291533.07377.knikanth@novell.com> <20090429081558.acaa2a9a.akpm@linux-foundation.org>
In-Reply-To: <20090429081558.acaa2a9a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904301258.17040.knikanth@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 April 2009 20:45:58 Andrew Morton wrote:
> On Wed, 29 Apr 2009 15:33:06 +0530 Nikanth Karthikesan <knikanth@novell.com> 
wrote:
> > On Wednesday 29 April 2009 13:29:30 Andrew Morton wrote:
> > > On Wed, 29 Apr 2009 12:21:39 +0530 Nikanth Karthikesan 
<knikanth@novell.com> wrote:
> > > > Hi Jens
> > > >
> > > > Currently io_context has an atomic_t(int) as refcount. In case of
> > > > cfq, for each device a task does I/O, a reference to the io_context
> > > > would be taken. And when there are multiple process sharing
> > > > io_contexts(CLONE_IO) would also have a reference to the same
> > > > io_context. Theoretically the possible maximum number of processes
> > > > sharing the same io_context + the number of disks/cfq_data referring
> > > > to the same io_context can overflow the 32-bit counter on a very
> > > > high-end machine. Even though it is an improbable case, let us make
> > > > it difficult by changing the refcount to atomic64_t(long).
> > >
> > > Sorry, atomic64_t isn't implemented on 32 bit architectures.
> > >
> > > Perhaps it should be, but I expect it'd be pretty slow.
> >
> > Oh! Sorry, I didn't notice the #ifdef earlier. I guess thats why there is
> > only a single in-tree user for atomic64_t!
>
> Yes, it's a bit irritating.
>
> > In this case, could we make it atomic64_t only on 64-bit architectures
> > and keep it as atomic_t on 32-bit machines?
>
> Sure.
>
> > Something like the attached patch.
>
> Check out atomic_long_t ;)
>

Oh, thanks! I was about to re-invent it. :) Sending a patch using that in a 
seperate mail.

> > I wonder whether we should also add BUG_ON's whenever the refcount is
> > about to wrap? Or try to handle it gracefully. Another approach would be
> > to impose an artificial limit on the no of tasks that could share an
> > io_context. Or resort to lock protection. The problem is not very
> > serious/common.
>
> For a long time there was a debug patch in -mm which would warn if
> atomic_dec() ever took any atomic_t from zero to -1.  I don't think it
> ever triggered false positives and it did find a couple of bugs.
>
> I forget what happened to the patch - probably it died when the atomic
> code got altered.
>
> It could well be that a similar kernel-wide check for atomic_inc()
> overflows would be similarly useful.

Sending a patch for this as well as a seperate mail.

Thanks
Nikanth
