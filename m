Return-Path: <linux-kernel-owner+w=401wt.eu-S1756509AbZCLP1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509AbZCLP1w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 11:27:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754702AbZCLP1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 11:27:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:45241 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293AbZCLP1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 11:27:41 -0400
Date: Thu, 12 Mar 2009 10:30:48 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Cedric Le Goater <legoater@free.fr>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [RFC][PATCH 00/11] track files for checkpointability
Message-ID: <20090312153048.GA11147@hallyn.com>
References: <20090305174037.GA2274@x200.localdomain> <1236280567.22399.99.camel@nimitz> <20090305210840.GA2499@x200.localdomain> <1236288427.22399.122.camel@nimitz> <20090305220044.GA2819@x200.localdomain> <1236352121.5732.80.camel@bahia> <20090306153549.GA898@us.ibm.com> <49B15F35.2010909@free.fr> <20090306183055.GA6729@us.ibm.com> <49B76D91.1020807@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B76D91.1020807@free.fr>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Cedric Le Goater (legoater@free.fr):
> >> And if Ingo's requirement is fulfilled, would any C/R patchset be acceptable ?
> > 
> > Yup, no matter how hideous  :)  Ok not really.
> > 
> > But the point was that it wasn't Dave not understanding Alexey's
> > suggestion, but Greg not understanding Ingo's.  If you think Ingo's
> > goal isn't worthwhile or achievable, then argue that (as I am), don't
> > keep elaborating on something we all agree will be needed (Alexey's
> > suggestion or some other way of doing a true may-be-checkpointed test).
> 
> I rather spend my time on enabling things rather than forbid them. 

That sure sounds productive.  How could I argue with that.

But wait, haven't several teams been doing that for years?  So why is
c/r not in the upstream kernel?  Could it be that ignoring the
upstream maintainers' concerns about (a) treating the feature as a
toy, (b) long-term maintainability, and (c) c/r becoming an impediment
to future features, and instead hacking away at our toy feature, is
*not* always the best course?

Now I actually don't think you believe it's politically possible for
c/r to get upstream.  But I do.

Getting back on track.  Ingo's concern is that this turn into a toy feature
rather than something which serious apps can rely on.  To address that
he wants an application to be able to tell whether or not it is
checkpointable, and, if not, then why not.

Now Alexey also has a suggestion for addressing this.  It has (at least)
two shortcomings relative to Dave's:

	1. it is more prone to race conditions.  If an app opens an
uncheckpointable file briefly and then closes it, and later reopens
it, then it may think it is checkpointable even though it could have
already known it is not always.  If you want to argue that returning
-EAGAIN is better in that case, that seems reasonable.

	2. For repeatedly checking the checkpointability of large
applications it could be much more costly.  For instance, if we have
to check the flags on each vma, and an application has 10s or 100s of
gigs of memory, each check for checkpointability would require walking
all those vmas each time.  Dave's approach has the advantage of only
checking those when the resource is opened.

Hmm, plus

	3. One of the things Ingo likes about Dave's approach, which
you may think is bogus, is that users of an uncheckpointable application
will scream more loudly if the app becomes permanently uncheckpointable
(and they know why), than if it sometimes works and sometimes doesn't
(-EAGAIN).

The funny thing is, for simplicity I actually prefer Alexey's approach.
It's easier (and therefore seems more robust) to tell if a task has a
particular sort of file at a definite point in time, than to try and
catch all the ways such an open file can be opened or received.  Which
is where Ingo's LSM suggestion is seductive, but I'm convinced that
approach would be politically impossible.

-serge
