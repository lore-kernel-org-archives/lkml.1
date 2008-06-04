Return-Path: <linux-kernel-owner+w=401wt.eu-S1755177AbYFDBk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177AbYFDBk1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 21:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751708AbYFDBkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 21:40:15 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:45822 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751311AbYFDBkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 21:40:13 -0400
X-Sasl-enc: 4BljcQzSp59vCM32AOdUqYzH0SVWusTjI9RyaSF7a8YO 1212543611
Subject: Re: Linux 2.6.26-rc4
From: Ian Kent <raven@themaw.net>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Jeff Moyer <jmoyer@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Miklos Szeredi <miklos@szeredi.hu>, jesper@krogh.cc,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20080603191859.GG28946@ZenIV.linux.org.uk>
References: <20080603104035.GT28946@ZenIV.linux.org.uk>
	 <E1K3U1F-0005le-07@pomaz-ex.szeredi.hu>
	 <20080603105258.GV28946@ZenIV.linux.org.uk>
	 <1212499623.3025.46.camel@raven.themaw.net>
	 <alpine.LFD.1.10.0806030751040.3473@woody.linux-foundation.org>
	 <1212509263.3025.66.camel@raven.themaw.net>
	 <alpine.LFD.1.10.0806030926330.3473@woody.linux-foundation.org>
	 <1212513189.3025.101.camel@raven.themaw.net>
	 <20080603173029.GD28946@ZenIV.linux.org.uk>
	 <x49ej7ejtry.fsf@segfault.boston.devel.redhat.com>
	 <20080603191859.GG28946@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Wed, 04 Jun 2008 09:36:56 +0800
Message-Id: <1212543417.3146.16.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-06-03 at 20:18 +0100, Al Viro wrote:
> On Tue, Jun 03, 2008 at 01:46:41PM -0400, Jeff Moyer wrote:
> 
> > Well, let me know what level of dump you'd like.  I can give the 50,000
> > foot view, or I can give you the history of things that happened to get
> > us to where we are today, or anything inbetween.  The more specific
> > your request, the quicker I can respond.  A full brain-dump would take
> > some time!
> 
> a) what the hell is going on in autofs4_free_ino()?  It checks for
> ino->dentry, when the only caller has just set it to NULL.

I know.
I need to clean that up.

> 
> b) while we are at it, what's ino->inode doing there?  AFAICS, it's
> a write-only field...

I know.
And I think it has never been used anywhere either but I haven't removed
it from the info structure.

> 
> c) what are possible states of autofs4 dentry and what's the supposed
> life cycle of these beasts?
> 
> d)
> /* For dentries of directories in the root dir */
> static struct dentry_operations autofs4_root_dentry_operations = {
>         .d_revalidate   = autofs4_revalidate,
>         .d_release      = autofs4_dentry_release,
> };
> 
> /* For other dentries */
> static struct dentry_operations autofs4_dentry_operations = {
>         .d_revalidate   = autofs4_revalidate,
>         .d_release      = autofs4_dentry_release,
> };
> 
> Just what is the difference?

There isn't any difference.
There's no real reason to keep them different except that there are two
distinct sets of operations. I don't see any harm in retaining this.
 
> 
> e) in autofs4_tree_busy() we do atomic_read() on ino->count and dentry->d_count
> What's going to keep these suckers consistent with each other in any useful
> way?

The only time ino->count is changed is in ->mkdir(), ->rmdir and
->symlink() and ->unlink(). So it is supposed to represent the minimal
reference count. The code in autofs4_free_ino() should go but that may
be a bug, I need to check.


