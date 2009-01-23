Return-Path: <linux-kernel-owner+w=401wt.eu-S1759609AbZAWFcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759609AbZAWFcV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 00:32:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751224AbZAWFcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 00:32:13 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56543 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750793AbZAWFcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 00:32:12 -0500
Date: Thu, 22 Jan 2009 21:31:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-kernel@vger.kernel.org, andi@firstfloor.org, viro@ZenIV.linux.org.uk,
       oleg@redhat.com, linux-api@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH, RFC] Remove fasync() BKL usage, take 3325
Message-Id: <20090122213105.74142908.akpm@linux-foundation.org>
In-Reply-To: <20090122221500.4c62aa54@tpl>
References: <20090115153211.663df310@bike.lwn.net>
	<20090122065104.2787df2d.akpm@linux-foundation.org>
	<20090122221500.4c62aa54@tpl>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 22 Jan 2009 22:15:00 -0700 Jonathan Corbet <corbet@lwn.net> wrote:
> On Thu, 22 Jan 2009 06:51:04 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > OK, replacing a lock_kernel() with a spin_lock(&global_lock) is pretty
> > straightforwad.  But it's really really sad.  It basically leaves a
> > great big FIXME in there.  It'd be better to fix it.
> > 
> > We don't have a handy lock in struct file which could be borrowed.
> 
> Yeah, I noticed that too.
>  
> > - We could add one
> 
> The problem there is that this bloats struct file, and that seemed like
> something worth avoiding.

Not a big deal, really.  There's one of these for each presently-open file.
It's not like dentries and inodes, which we cache after userspace has
closed off the file handles.

>  It could easily be done, but I don't know
> why we would before knowing that the global spinlock is a problem. 
> 
> But... it's *already* protected by a global spinlock (the BKL) which is
> (still) more widely used.
> 
> > - We could borrow file->f_path.dentry->d_inode->i_lock
> 
> I didn't think of that one.  Using a lock which is three indirections
> away seems a little obscure; again, I guess we could do that if the
> global spinlock actually turns out to be a problem.
> 
> > - We could convert that field to long and use bitops (sounds nice?)
> 
> I did think of that one.  Reasons not to include growing struct file
> and the fact that there are places which set more than one flag at
> once.  So we'd replace assignments with loops - and we still don't
> solve the fasync() problem.
> 

I don't know what "the fasync() problem" is?
