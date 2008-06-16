Return-Path: <linux-kernel-owner+w=401wt.eu-S1756807AbYFPS2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807AbYFPS2z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 14:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751013AbYFPS2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 14:28:47 -0400
Received: from brick.kernel.dk ([87.55.233.238]:29311 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717AbYFPS2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 14:28:47 -0400
Date: Mon, 16 Jun 2008 20:28:44 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Tom Zanussi <tzanussi@gmail.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, righi.andrea@gmail.com
Subject: Re: [PATCH 2/3] relay: Fix race condition which occurs when reading across CPUs.
Message-ID: <20080616182843.GS20851@kernel.dk>
References: <20080613040958.4f52ee29@linux360.ro> <1213417601.8237.37.camel@charm-linux> <20080614181103.17617db1@linux360.ro> <20080616122249.GB18561@Krystal> <20080616162212.27a8c119@linux360.ro> <20080616164609.GM20851@kernel.dk> <84144f020806161118n70a876aeyb5ccac7b1e21d842@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020806161118n70a876aeyb5ccac7b1e21d842@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16 2008, Pekka Enberg wrote:
> Hi Jens,
> 
> On Mon, Jun 16 2008, Eduard - Gabriel Munteanu wrote:
> >> In any case, if we use relay in a hot path, we are doing debugging, so
> >> a couple of atomic operations won't be a big problem. Along with
> >> setting affinity, this shouldn't be a problem.
> 
> On Mon, Jun 16, 2008 at 7:46 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
> > Ehm no, that is a completely false claim. Relay speed does matter, a
> > great deal. We rely heavily on eg blktrace being as ligt weight as
> > possible to capture millions of events in a very short time frame
> > without impacting performance too much. Relay is NOT just for debugging.
> >
> > So I completely agree with Mathieu here, and I'm not a big fan of the
> > proposed solution.
> 
> OK, so we just document that fact that you're not supposed to read
> from different CPU and be done with that? Or do you have any
> alternative fix in mind?

Hmm dunno, that is what blktrace also did but primarily for performance
reasons. It's tricky - Tom stated that he is working on a lib to
abstract this from applications. While that is handy for telling you
what to do, it also an annoyance that you HAVE to do it that way (it's
supposed to just be a "normal" fs, not with funky restrictions).

So perhaps provide both versions in-kernel and let the kernel user
device. For blktrace, we have one app and we know we can use the faster
variant since readers are affine. For more debug style exports or where
you don't know your consumer, use the safer variant (which should be the
default action).

-- 
Jens Axboe

