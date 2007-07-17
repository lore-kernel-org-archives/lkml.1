Return-Path: <linux-kernel-owner+w=401wt.eu-S933596AbXGQQQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933596AbXGQQQl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 12:16:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754173AbXGQQQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 12:16:34 -0400
Received: from smtp-out.google.com ([216.239.33.17]:15535 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165AbXGQQQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 12:16:33 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=OCseodxZHjQ6BjKGUBCtjir66YzOWTbIrPH+f7w/BO7qj/MR/UjcMejQJxPktRnhS
	1EHmsxRFxQ+BU6ShgDeYA==
Message-ID: <6599ad830707170915p46794c61g3baba1ab0af5db7@mail.gmail.com>
Date: Tue, 17 Jul 2007 09:15:58 -0700
From: "=?ISO-2022-JP?B?UGF1bCAoGyRCSnVOXBsoQikgTWVuYWdl?=" 
	<menage@google.com>
To: "Dave Hansen" <haveblue@us.ibm.com>
Subject: Re: Containers: css_put() dilemma
Cc: balbir@linux.vnet.ibm.com, dhaval@linux.vnet.ibm.com,
       "linux kernel mailing list" <linux-kernel@vger.kernel.org>,
       "Pavel Emelianov" <xemul@sw.ru>, "Paul Jackson" <pj@sgi.com>,
       "Linux Containers" <containers@lists.osdl.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <1184688131.6454.109.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <469BBE00.8000709@linux.vnet.ibm.com>
	 <6599ad830707161203o7f148c75p52e77d4be3ace487@mail.gmail.com>
	 <469C2792.6050009@linux.vnet.ibm.com>
	 <6599ad830707161935n69776f1t98292fc9990f4766@mail.gmail.com>
	 <20070717070031.GA22410@linux.vnet.ibm.com>
	 <6599ad830707170018p180cb7dfr53e609fd0b186e30@mail.gmail.com>
	 <469C99D1.7090807@linux.vnet.ibm.com>
	 <6599ad830707170849v11fe8cecs6d172cd38d247e09@mail.gmail.com>
	 <1184688131.6454.109.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/17/07, Dave Hansen <haveblue@us.ibm.com> wrote:
> On Tue, 2007-07-17 at 08:49 -0700, Paul (宝瑠) Menage wrote:
> > Because as soon as you do the atomic_dec_and_test() on css->refcnt and
> > the refcnt hits zero, then theoretically someone other thread (that
> > already holds container_mutex) could check that the refcount is zero
> > and free the container structure.
>
> Then that other task had a reference and itself should have bumped the
> count, and the other user would never have seen it hit zero.

Nope. The container could have been empty (of tasks) and hence had a zero count.

The liveness model used by containers is that when the refcount hits
zero, the container isn't immediately destroyed (since it can contain
useful historical usage data, etc) but simply becomes eligible for
destruction by userspace via an rmdir().

>
> Even if there are still pages attached to the container, why not just
> have those take a reference, and don't bother actually freeing the
> container until the last true reference is dropped?

Yes, we could potentially just use the main count variable rather than
having separate per-subsystem extra refcounts. The main reasons to do
it this way are:

- the root subsystem state for a subsystem can shift between different
"struct container" objects if it was previously inactive and gets
mounted as part of a hierarchy (or similarly, gets unmounted and goes
inactive). Possibly we could get around this by simply saying not
doing refcounting on the subsys states attached to root containers
since they can never be freed anyway.

- At some point I'd like to be able to support shifting subsystems
between active hierarchies, at least in limited cases such as where
the hierarchies are isomorphic, or binding/unbinding subsystems
to/from active hierarchies. At that point we definitely need to be
able to split out the different subsystem state refcounts from one
another in the same hierarchy.

- we'd still have the issue that Balbir wants to be able to drop a
reference in a non-sleeping context, and we want to avoid doing
excessive synchronization in the normal case when the css_put()
doesn't put the reference count to zero.

>
> Does it matter if the destruction callbacks don't happen until well
> after an attempt to destroy the container is made?

Well that's sort of the point of putting a synchronize_rcu() in
container_diput() - it ensures that the actual destruction of the
object doesn't occur until sufficiently after the destruction attempt
is initiated that no one is still using the reference.

The alternative would be something that polls to spot whether
refcounts have reached zero and if so runs the userspace helper. That
doesn't seem particularly palatable when you have large numbers of
containers, if we can avoid it easily.

Paul
