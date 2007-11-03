Return-Path: <linux-kernel-owner+w=401wt.eu-S1759307AbXKCUNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759307AbXKCUNc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 16:13:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757114AbXKCUNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 16:13:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47305 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755749AbXKCUNX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 16:13:23 -0400
Date: Sat, 3 Nov 2007 21:12:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Hansen <haveblue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>, Ulrich Drepper <drepper@redhat.com>,
       linux-kernel@vger.kernel.org,
       "Dinakar Guniguntala [imap]" <dino@in.ibm.com>,
       Sripathi Kodi <sripathik@in.ibm.com>
Subject: Re: [patch] PID namespace design bug, workaround
Message-ID: <20071103201251.GB26366@elte.hu>
References: <20071101144307.GA29566@elte.hu> <4729E7E4.8070208@openvz.org> <4729E936.4040400@redhat.com> <4729EB3C.9050102@openvz.org> <472A6D91.1020300@redhat.com> <472AD7D6.80900@openvz.org> <20071102010419.23f3db5c.akpm@linux-foundation.org> <1194024622.6271.108.camel@localhost> <alpine.LFD.0.999.0711021038480.3342@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0711021038480.3342@woody.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, 2 Nov 2007, Dave Hansen wrote:
> > 
> > There are certainly more of these, but here is one In the futex 
> > userspace address, we install the current pid's vnr into a userspace 
> > address.
> 
> Now, realistically, why not just say "you can't use these things 
> across namespaces"? Does anybody really care? After all, somebody who 
> screws this up only screws himself, not anybody else.

i see two main categories of problems:

- one problem is that this condition is 'invisible'. If two namespaces 
  happen to access the same robust futex (say a yum update from two 
  PID namespaces sharing the same read-mostly filesystem) there's silent
  breakage and data corruption due to PID overlap. The other
  namespaces have no such problems. I think the "dont do that" answer is
  lame because most apps _will_ work across PID namespaces because 
  things like fcntl based locking does work. And there's no valid
  technical excuse why futexes shouldnt work: it's all controlled by the
  same native kernel, there's no untrusted network separating the nodes,
  etc.

- so via this we isolate an important category of syscalls from
  cross-namespace use perhaps forever. Pick just about any other kernel
  resource and they can be shared between namespaces. But not futexes -
  which happen to be the most scalable locking primitive and people will
  almost certainly want to use them across namespaces. A
  completely new breed of futexes has to be introduced and trickled
  through userspace and all the architectures to make it work again
  across namespaces. Who will do that work? Generally the people who
  introduce a new concept are the ones who should do that. But in this
  case they are apparently not interested in making it generic enough
  (they are concentrated on their 'isolate it all' aspect) so
  nobody else will do and we are stuck with an incomplete concept.

The answer of user-space/apps is predictable: they'll gravitate towards 
the path of least resistance, and that will be "dont use futexes". PID 
namespaces basically single out an important API category and use the 
natural pressure of the other 300 syscalls and tens of thousands of apps 
against this category. Linux is basically used against itself. The 
counter-force is relatively weak and there's no solution available _at 
all_ presently so it's not even the fight of patches against each other, 
it's the sheer lack of a feature which has an obvious end-result.

We've already got way too many incomplete concepts and APIs in the 
kernel. Maybe i'm over-worrying, but i fear we end up like with 
capabilities or sendfile - code merged too soon and never completed for 
many years - perhaps never completed at all. VMS and WNT did those 
things a bit better i think - their API frameworks were/are pervasive 
and complete, even in the corner cases.

Whether it's the right approach to force reasonable perfection of 
frameworks like this from the get go is another question - but in 
practice even for relatively popular new APIs like epoll we see a way 
too slow movement towards the 'completion of the API', and that hinders 
adoption of new APIs very much. (With splice being a notable exception - 
there the central concept was so strong that it quickly pushed itself to 
total completion - combined with a capable maintainer of the API.) But 
it's not that easy for futexes and we put another roadblock in the path 
of futexes.

	Ingo
