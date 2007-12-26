Return-Path: <linux-kernel-owner+w=401wt.eu-S1752588AbXLZWRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588AbXLZWRc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 17:17:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751689AbXLZWRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 17:17:23 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:39491 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbXLZWRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 17:17:23 -0500
Date: Wed, 26 Dec 2007 22:16:32 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Christoph Lameter <clameter@sgi.com>
Cc: Theodore Tso <tytso@mit.edu>, Andi Kleen <andi@firstfloor.org>,
       Willy Tarreau <w@1wt.eu>, Steven Rostedt <rostedt@goodmis.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Major regression on hackbench with SLUB (more numbers)
Message-ID: <20071226221631.GD27894@ZenIV.linux.org.uk>
References: <20071222192550.GD28891@thunk.org> <alpine.LFD.0.9999.0712221251110.21557@woody.linux-foundation.org> <20071222221050.GA20753@1wt.eu> <Pine.LNX.4.58.0712221954530.19187@gandalf.stny.rr.com> <20071223051241.GA4449@1wt.eu> <20071223141500.GB6430@one.firstfloor.org> <20071224034530.GB16658@thunk.org> <Pine.LNX.4.64.0712241120230.8849@schroedinger.engr.sgi.com> <20071224233701.GB9784@kernel.org> <Pine.LNX.4.64.0712261330030.16904@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0712261330030.16904@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 26, 2007 at 01:31:35PM -0800, Christoph Lameter wrote:
> On Mon, 24 Dec 2007, Theodore Tso wrote:
> 
> > So two questions: why isn't -f the default?  And is /sys/slab
> 
> Because it gives misleading output. It displays the name of the first 
> of multiple slabs that share the same storage structures.

Erm...  Let me spell it out: current lifetime rules are completely broken.
As it is, create/destroy/create cache sequence will do kobject_put() on
kfree'd object.  Even without people playing with holding sysfs files
open or doing IO on those.

a) you have kobject embedded into struct with the lifetime rules of its
own.  When its refcount hits zero you kfree() the sucker, even if you
still have references to embedded kobject.

b) your symlinks stick around.  Even when cache is long gone you still
have a sysfs symlink with its embedded kobject as a target.  They are
eventually removed when cache with the same name gets created.  _Then_
you get the target kobject dropped - when the memory it used to be in
had been freed for hell knows how long and reused by something that would
not appreciate slub.c code suddenly deciding to decrement some word in
that memory.

c) you leak references to these kobject; kobject_del() only removes it
from the tree undoing the effect of kobject_add() and you still need
kobject_put() to deal with the last reference.
