Return-Path: <linux-kernel-owner+w=401wt.eu-S1753394AbZA1DJK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbZA1DJK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 22:09:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751819AbZA1DI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 22:08:56 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:39894 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbZA1DIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 22:08:55 -0500
Date: Tue, 27 Jan 2009 19:05:18 -0800
From: Joel Becker <Joel.Becker@oracle.com>
To: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       cluster-devel@redhat.com, swhiteho <swhiteho@redhat.com>
Subject: Re: [PATCH] configfs: Silence lockdep on mkdir(), rmdir() and
	configfs_depend_item()
Message-ID: <20090128030518.GB7244@mail.oracle.com>
Mail-Followup-To: Peter Zijlstra <peterz@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, cluster-devel@redhat.com,
	swhiteho <swhiteho@redhat.com>
References: <20081218092744.GB30789@mail.oracle.com> <1229601399.9487.218.camel@twins> <1229603308.9487.227.camel@twins> <20081218225837.GB21870@mail.oracle.com> <1232973009.4863.76.camel@laptop> <20090126132453.GD7532@hawkmoon.kerlabs.com> <1232977283.4863.79.camel@laptop> <20090126140032.GE7532@hawkmoon.kerlabs.com> <1232979562.4863.101.camel@laptop> <20090126145536.GG7532@hawkmoon.kerlabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090126145536.GG7532@hawkmoon.kerlabs.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010203.497FCBD1.00D2:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you both for keeping up on this.  I owe Louis some review that I'm
going to try to get to.

On Mon, Jan 26, 2009 at 03:55:36PM +0100, Louis Rilling wrote:
> On 26/01/09 15:19 +0100, Peter Zijlstra wrote:
> > On Mon, 2009-01-26 at 15:00 +0100, Louis Rilling wrote:
> > 
> > > > Its not a locking correctness thing, but simply not being able to do it
> > > > from the vfs calls because those assume locks held?
> > > > 
> > > > Can't you simply punt the work to a worklet once you've created/removed
> > > > the non-default group, which can be done from within the vfs callback ?
> > > 
> > > I'm not sure to understand your suggestion. Is this:
> > > 1) for mkdir(), create the non-default group, but without its default groups,
> > > and defer their creation to a worker which won't have constraints on locks held
> > > by any caller;
> > > 2) for rmdir(), unlink the non-default group, but without unlinking its default
> > > groups, and defer the recursive work to a lock-free context?
> > > 
> > > For mkdir(), this may work. Maybe a bit confusing for userspace, since mkdir(A)
> > > returns as soon as A is created, but A may be populated later and userspace may
> > > rely on A being populated as soon as it is created (current behavior). As a
> > > configfs user, this makes my life harder...
> > 
> > Right, so that is the whole crux of the matter?

	The "appearance" of the entire default group hierarchy should be
atomic.  When mkdir(2) returns, it is all there.  This does make our
lives a little difficult inside configfs, but it makes everyone else's
lives much easier.

> Probably not. I'm not the maintainer of configfs, but I guess that Joel is a bit
> reluctant to deeply rework parts of something that actually works (conflicts
> with lockdep excepted).

	That is true - it works, and safely, and the lockdep conflict is
the only real known issue.  I'm not wary of changing it, I'm only wary
of breaking it.  That is, I want to understand what is being changed and
be sure that we're keeping the correctness we have so far.  I don't want
to change it and "hope" we got it right, you know?  This makes me
cautious, but don't think I'm against change.  As I stated, having
lockdep work for us is a good thing.

	More replies to the other mails coming.

Joel

-- 

You can use a screwdriver to screw in screws or to clean your ears,
however, the latter needs real skill, determination and a lack of fear
of injuring yourself.  It is much the same with JavaScript.
	- Chris Heilmann

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
