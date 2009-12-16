Return-Path: <linux-kernel-owner+w=401wt.eu-S1759844AbZLPP51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759844AbZLPP51 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 10:57:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759022AbZLPP5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 10:57:24 -0500
Received: from one.firstfloor.org ([213.235.205.2]:43684 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758806AbZLPP5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 10:57:22 -0500
Date: Wed, 16 Dec 2009 16:57:14 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Trond Myklebust <trond.myklebust@fys.uio.no>, f@basil.fritz.box
Cc: Andi Kleen <andi@firstfloor.org>, Al Viro <viro@ZenIV.linux.org.uk>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: Re: NFS lockdep lock misordering mmap_sem<->i_mutex_key with
	2.6.32-git1
Message-ID: <20091216155714.GF15031@basil.fritz.box>
References: <20091207115949.GA7610@basil.fritz.box> <20091207211216.E95E.A69D9226@jp.fujitsu.com> <20091207132009.GI18989@one.firstfloor.org> <20091215222134.GA27892@ZenIV.linux.org.uk> <20091215233841.GE22392@basil.fritz.box> <1260921277.3219.18.camel@localhost> <20091216005308.GB3622@basil.fritz.box> <1260968991.3219.57.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260968991.3219.57.camel@localhost>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 08:09:51AM -0500, Trond Myklebust wrote:
> On Wed, 2009-12-16 at 01:53 +0100, Andi Kleen wrote: 
> > > If you want to work around the problem rather than going for something
> > 
> > I am mostly interested in making the ugly warning on my systems
> > go away, preferably without breaking anything in the process.
> > Whatever works.
> > 
> > > like Peter's split up of the mmap() callback, then I'd suggest changing
> > > to using nfs_revalidate_mapping_nolock() instead. The fact that we are
> > > seeing these lock misordering warnings is proof that the call to
> > > nfs_revalidate_mapping() is not always a no-op.
> > 
> > I would say the interesting question is if there is really a expectation
> > that mmap does this kind of synchronization? 
> 
> Usually people who set the 'noac' mount flag will expect these syscalls
> to act as synchronisation points.

It would be definitely a synchronization point if they deadlock in 
mmap due to a ABBA race.

> Typically, their applications will be using some kind of locking scheme
> that does not require POSIX or BSD locks to be set. For instance, they
> may synchronise by means of a token passed through a socket (common in
> MPI iirc).

Still mmap seems like an odd synchronization point. Is not doing it 
in it really likely to break anything?

> > Why in mmap, not somewhere else?
> 
> We do the same thing in the read() and write() syscalls.

Ok I didn't fully understand your suggestion to use the _nolock
variant. Are you saying i_mutex is sometimes not needed?

I thought _nolock was only for the case i_mutex is already hold --
which is not the case here.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
