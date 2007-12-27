Return-Path: <linux-kernel-owner+w=401wt.eu-S1753364AbXL0Fv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364AbXL0Fv4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 00:51:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750894AbXL0Fvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 00:51:48 -0500
Received: from relay2.sgi.com ([192.48.171.30]:39206 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750797AbXL0Fvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 00:51:47 -0500
Date: Wed, 26 Dec 2007 21:51:42 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: Theodore Tso <tytso@mit.edu>, Andi Kleen <andi@firstfloor.org>,
       Willy Tarreau <w@1wt.eu>, Steven Rostedt <rostedt@goodmis.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Major regression on hackbench with SLUB (more numbers)
In-Reply-To: <20071226221631.GD27894@ZenIV.linux.org.uk>
Message-ID: <Pine.LNX.4.64.0712262149000.19009@schroedinger.engr.sgi.com>
References: <20071222192550.GD28891@thunk.org>
 <alpine.LFD.0.9999.0712221251110.21557@woody.linux-foundation.org>
 <20071222221050.GA20753@1wt.eu> <Pine.LNX.4.58.0712221954530.19187@gandalf.stny.rr.com>
 <20071223051241.GA4449@1wt.eu> <20071223141500.GB6430@one.firstfloor.org>
 <20071224034530.GB16658@thunk.org> <Pine.LNX.4.64.0712241120230.8849@schroedinger.engr.sgi.com>
 <20071224233701.GB9784@kernel.org> <Pine.LNX.4.64.0712261330030.16904@schroedinger.engr.sgi.com>
 <20071226221631.GD27894@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Dec 2007, Al Viro wrote:

> Erm...  Let me spell it out: current lifetime rules are completely broken.
> As it is, create/destroy/create cache sequence will do kobject_put() on
> kfree'd object.  Even without people playing with holding sysfs files
> open or doing IO on those.

Urgh. Help! Isnt there some sanity with sysfs? 

> a) you have kobject embedded into struct with the lifetime rules of its
> own.  When its refcount hits zero you kfree() the sucker, even if you
> still have references to embedded kobject.

So alloate it separately?

> b) your symlinks stick around.  Even when cache is long gone you still
> have a sysfs symlink with its embedded kobject as a target.  They are
> eventually removed when cache with the same name gets created.  _Then_
> you get the target kobject dropped - when the memory it used to be in
> had been freed for hell knows how long and reused by something that would
> not appreciate slub.c code suddenly deciding to decrement some word in
> that memory.

Hmmmm.. That would also be addressed by a having a separately allocated 
kobject?
 
> c) you leak references to these kobject; kobject_del() only removes it
> from the tree undoing the effect of kobject_add() and you still need
> kobject_put() to deal with the last reference.

Patches would be appreciated.... Had a hard time to get the sysfs support 
to work right.
