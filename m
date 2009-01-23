Return-Path: <linux-kernel-owner+w=401wt.eu-S1759609AbZAWFrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759609AbZAWFrA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 00:47:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751179AbZAWFqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 00:46:51 -0500
Received: from waste.org ([66.93.16.53]:51214 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751172AbZAWFqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 00:46:51 -0500
Subject: Re: [PATCH, RFC] Remove fasync() BKL usage, take 3325
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, viro@ZenIV.linux.org.uk, oleg@redhat.com,
       linux-api@vger.kernel.org, alan@lxorguk.ukuu.org.uk
In-Reply-To: <20090122213105.74142908.akpm@linux-foundation.org>
References: <20090115153211.663df310@bike.lwn.net>
	 <20090122065104.2787df2d.akpm@linux-foundation.org>
	 <20090122221500.4c62aa54@tpl>
	 <20090122213105.74142908.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 22 Jan 2009 23:45:49 -0600
Message-Id: <1232689549.5202.385.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-22 at 21:31 -0800, Andrew Morton wrote:
> > On Thu, 22 Jan 2009 22:15:00 -0700 Jonathan Corbet <corbet@lwn.net> wrote:
> > On Thu, 22 Jan 2009 06:51:04 -0800
> > Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > OK, replacing a lock_kernel() with a spin_lock(&global_lock) is pretty
> > > straightforwad.  But it's really really sad.  It basically leaves a
> > > great big FIXME in there.  It'd be better to fix it.
> > > 
> > > We don't have a handy lock in struct file which could be borrowed.
> > 
> > Yeah, I noticed that too.
> >  
> > > - We could add one
> > 
> > The problem there is that this bloats struct file, and that seemed like
> > something worth avoiding.
> 
> Not a big deal, really.  There's one of these for each presently-open file.
> It's not like dentries and inodes, which we cache after userspace has
> closed off the file handles.

I have to agree with Christoph. The priority here is breaking down the
BKL and document all the things being protected by it and we've got a
reasonably obvious patch in that direction. Meanwhile, there's not
currently a pressing demand to make fasync in particular scale that I'm
aware of.

Having a single big lock here is quite possibly something we'll want to
fix down the road, agreed, but until we can actually measure it hurting
us, debating about whether to use a bit lock or reuse an existing lock
or add a new lock to all struct files is a bit premature.

-- 
http://selenic.com : development and support for Mercurial and Linux


