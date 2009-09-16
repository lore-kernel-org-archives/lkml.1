Return-Path: <linux-kernel-owner+w=401wt.eu-S1756120AbZIPMAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120AbZIPMAl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 08:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756049AbZIPMAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 08:00:40 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51798 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756042AbZIPMAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 08:00:39 -0400
Date: Wed, 16 Sep 2009 13:01:27 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jamie Lokier <jamie@shareable.org>
Cc: Alan Cox <alan@linux.intel.com>, Eric Paris <eparis@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Evgeniy Polyakov <zbr@ioremap.net>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       netdev@vger.kernel.org, viro@zeniv.linux.org.uk, hch@infradead.org
Subject: Re: fanotify as syscalls
Message-ID: <20090916130127.439c9222@lxorguk.ukuu.org.uk>
In-Reply-To: <20090916114107.GB29359@shareable.org>
References: <20090912094110.GB24709@ioremap.net>
	<20090914001759.GB30621@shareable.org>
	<20090914140720.GA8564@ioremap.net>
	<1252955295.2246.35.camel@dhcp231-106.rdu.redhat.com>
	<20090915201620.GB32192@ioremap.net>
	<1253051699.5213.18.camel@dhcp231-106.rdu.redhat.com>
	<alpine.LFD.2.01.0909151643540.4950@localhost.localdomain>
	<1253064391.5213.37.camel@dhcp231-106.rdu.redhat.com>
	<20090916075219.GA22024@shareable.org>
	<20090916114111.2228f0fc@linux.intel.com>
	<20090916114107.GB29359@shareable.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You can't rely on the name being non-racy, but you _can_ reliably
> invalidate application-level caches from the sequence of events
> including file writes, creates, renames, links, unlinks, mounts.  And
> revalidate such caches by the absence of pending events.

You can't however create the caches reliably because you've no idea if
you are referencing the right object in the first place - which is why
you want a handle in these cases. I see fanotify as a handle producing
addition to inotify, not as a replacement (plus some other bits around
open blocking for HSM etc)

> Clearly, I'm going to have to explain with working code :-)

Always a good demo

> > but it is somewhat inadequate for indexers
> 
> For indexers, the real inadequacy is the need to attach inotify
> watches to every directory at system startup, and to stat() everything
> to check it hasn't changed since the indexer was last running.  Both

stat doesn't help you - inode numbers are only guaranteed unqiue (and
constant) while a reference to the object is held.

> Descriptors don't tell you which subtree a file is in any better than
> inotify watches.  I.e. they do, if you track them and their containing
> directories all individually.

Don't get me wrong - I don't think fanotify is sufficient on its own -
and this is one reason. Some things care about the namespace, some about
getting the exact content.

> > chroot isn't a security model. You can already do this with AF_UNIX
> > sockets (and there are apps that intentionally use fchdir that way)
> 
> Ah, no.  AF_UNIX works with explicit sender cooperation.
> 
> fanotify gives you access to files without sender cooperation, as it
> intercepts every open().

and is currently not general user accessible for this reason.

> > Inside of containers - unlikely.
> 
> Why not?  Some people run entire distributions in containiners, and
> present them as VMs to the world for other people to admin.

In a word - performance. In two words performance and security. It isn't
a sensible setup because you want to scan the most efficient way possible
and you want to keep your malware scan as far away from attackers, so it
makes sense to keep it outside of the containers and do the job once
- one scan, one database of things to keep current.

Alan
