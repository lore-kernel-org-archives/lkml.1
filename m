Return-Path: <linux-kernel-owner+w=401wt.eu-S1753819AbXJWAID@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819AbXJWAID (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 20:08:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751339AbXJWAHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 20:07:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50344 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330AbXJWAHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 20:07:52 -0400
Date: Mon, 22 Oct 2007 20:07:42 -0400
From: Rik van Riel <riel@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xemul@openvz.org,
       Ian Kent <raven@themaw.net>
Subject: Re: futex strangeness in 2.6.23-mm1/UML
Message-ID: <20071022200742.6f3acbb2@bree.surriel.com>
In-Reply-To: <20071022172926.03ca122a@bree.surriel.com>
References: <E1Ik15P-0001wg-00@dorka.pomaz.szeredi.hu>
	<20071022145321.195d929b@bree.surriel.com>
	<E1Ik4Ch-000273-00@dorka.pomaz.szeredi.hu>
	<20071022172926.03ca122a@bree.surriel.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Oct 2007 17:29:26 -0400
Rik van Riel <riel@redhat.com> wrote:

> On Mon, 22 Oct 2007 22:48:51 +0200
> Miklos Szeredi <miklos@szeredi.hu> wrote:
> 
> > > > I'm getting a process stuck in pthread_rwlock_wrlock(), even
> > > > though it looks like the lock is not held by anybody.
> > > > 
> > > > I think the last -mm was OK.  Any ideas?
> > > > 
> > > > If not, I'll go searching for the offending patch.
> > > 
> > > I wonder if that's the same bug that's breaking autofs for me.
> > 
> > Probably.
> > 
> > > Oct 22 14:39:01 kenny automount[2299]: cache_readlock: mapent
> > > cache rwlock lock failed
> > > Oct 22 14:39:01 kenny automount[2299]: unexpected pthreads error:
> > > 11 at 65 in cache.c
> > > 
> > > I'm bisecting 2.6.23-mm1 today to find the problem patch, with
> > > some luck I'll have it this afternoon.
> > > 
> > > With the series applied up to
> > > whitespace-fixes-task-exit-handling.patch things work.
> > > 
> > > It breaks before
> > > kswapd-should-only-wait-on-io-if-there-is-io.patch
> > > 
> > > That leaves only about 60-80 patches to look at :)
> > 
> > OK, the first patch that breaks something for me is:
> > 
> >   pid-namespaces-move-alloc_pid-lower-in-copy_process.patch
> 
> Confirmed.  That same patch is the point where the bisect
> here starts breaking autofs.

Oww man.  Getting into heisenbug territory now :(

I bisected down to the point where I had these two patches between
good and bad:

# GOOD
pid-namespaces-move-alloc_pid-lower-in-copy_process.patch
pid-namespaces-make-proc-have-multiple-superblocks-one-for-each-namespace.patch
# BAD

Applying them one by one and rebuilding the kernel after each one
gave me a working kernel, though!

Bisecting them from the top (quilt pop) resulted in a broken kernel,
bisecting from the bottom (quilt push) results in a working one.

I have no idea what is going on any more...

-- 
"Debugging is twice as hard as writing the code in the first place.
Therefore, if you write the code as cleverly as possible, you are,
by definition, not smart enough to debug it." - Brian W. Kernighan
