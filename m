Return-Path: <linux-kernel-owner+w=401wt.eu-S1752185AbYJaL2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185AbYJaL2T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 07:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751016AbYJaL2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 07:28:09 -0400
Received: from mail.crca.org.au ([67.207.131.56]:33955 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753AbYJaL2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 07:28:08 -0400
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [linux-pm] Freezer: Don't count threads waiting for
	frozen	filesystems.
From: Nigel Cunningham <ncunningham@crca.org.au>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <E1Kvq72-00049W-O1@pomaz-ex.szeredi.hu>
References: <Pine.LNX.4.44L0.0810300955020.2401-100000@iolanthe.rowland.org>
	 <1225403060.6574.10.camel@nigel-laptop>
	 <E1Kvpgo-00045l-GU@pomaz-ex.szeredi.hu>
	 <1225444253.6574.21.camel@nigel-laptop>
	 <E1Kvq72-00049W-O1@pomaz-ex.szeredi.hu>
Content-Type: text/plain
Organization: Christian Reformed Churches of Australia
Date: Fri, 31 Oct 2008 22:28:04 +1100
Message-Id: <1225452484.6574.35.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again.

On Fri, 2008-10-31 at 10:16 +0100, Miklos Szeredi wrote:
> On Fri, 31 Oct 2008, Nigel Cunningham wrote:
> > Hi.
> > 
> > On Fri, 2008-10-31 at 09:49 +0100, Miklos Szeredi wrote:
> > > On Fri, 31 Oct 2008, Nigel Cunningham wrote:
> > > > I'm not sure that's true. You see, I'm thinking of this as not that
> > > > different to the problem of unmounting filesystems. There, too, we need
> > > > to unmount in a particular order, and let transactions on each
> > > > filesystem stop cleanly before we can unmount them. Even if there are
> > > > differences, perhaps looking at how we handle unmounting will help with
> > > > handling freezing.
> > > 
> > > There's nothing magic about umount, it just uses a refcount on the fs.
> > > 
> > > But umount changes the namespace, that's the big difference.  For
> > > example if a process is accessing path P which has a component inside
> > > the mount, it _will_ get different results before and after the
> > > umount.  This is not acceptable for freezing.
> > > 
> > > For freezing to work with such a refcounting scheme, we'd have to
> > > count _future_ uses of the fs as well, not just current ones, which is
> > > obviously impossible.
> > 
> > I must be missing something. If you're freezing future users of the
> > filesystem before they can start anything new, doesn't that deal with
> > this problem?
> 
> How do you determine which are the future users?

You don't. You just use FUSE_MIGHT_FREEZE to stop them before they take
locks that might cause problems. So my suggestion is:

1) Stop new requests at FUSE_MIGHT_FREEZE
2) Handle existing requests by using freezer_do_not_count in
request_send and request_send_nowait before the spin_lock and
freezer_count after the spin_unlock.

With #2, we don't need to care about whether the request is completed
before freezing completes or post-resume.

If the userspace process tries to use an already frozen fuse filesystem
and gets frozen, that's okay because we'll sit waiting for an answer,
not be counted by the freezer and so not contribute to any failure to
freeze processes.

If the userspace process completes its work, we'll either get caught at
the freezer_count (if we've already been told to freeze) or be gotten
later, after exiting the fuse code.

Regards,

Nigel

