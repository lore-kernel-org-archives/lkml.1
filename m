Return-Path: <linux-kernel-owner+w=401wt.eu-S1754613AbXL0Xz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613AbXL0Xz0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 18:55:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753692AbXL0XzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 18:55:18 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:48168 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567AbXL0XzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 18:55:16 -0500
Date: Thu, 27 Dec 2007 23:54:37 +0000
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
Subject: Re: SLUB sysfs support
Message-ID: <20071227235437.GI27894@ZenIV.linux.org.uk>
References: <20071223141500.GB6430@one.firstfloor.org> <20071224034530.GB16658@thunk.org> <Pine.LNX.4.64.0712241120230.8849@schroedinger.engr.sgi.com> <20071224233701.GB9784@kernel.org> <Pine.LNX.4.64.0712261330030.16904@schroedinger.engr.sgi.com> <20071226221631.GD27894@ZenIV.linux.org.uk> <Pine.LNX.4.64.0712262149000.19009@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0712271222190.31582@schroedinger.engr.sgi.com> <20071227225947.GH27894@ZenIV.linux.org.uk> <Pine.LNX.4.64.0712271508080.917@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0712271508080.917@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 27, 2007 at 03:22:28PM -0800, Christoph Lameter wrote:
> > a) remove symlink when slab goes away
> 
> Ok. Need to think about how to code that.

Huh?  Just call it from kmem_cache_destroy(); what business does that symlink
have being around after that point?

> > b) instead of kfree() in slab removal do kobject_put() if you have sysfs stuff
> 
> Hmmmm.... Okay. Patch follows but its strange to do a kobject_put after a 
> kobject_del().

kobject_del() undoes the effect of kobject_add().  And then you are left
with the refcount you had before kobject_add(), i.e. from kobject_init().

Think of it that way: kobject refcount controls the lifetime of structure
the sucker's embedded into.  Depending on kobject methods, you might
be unable to do cleanup of non-kobject parts of that animal until after
kobject_del().  IOW, you _can't_ have kobject_del() dropping the (hopefully)
final reference to kobject - only the caller knows what might have to be
done in between.
