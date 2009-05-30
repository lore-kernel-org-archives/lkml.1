Return-Path: <linux-kernel-owner+w=401wt.eu-S932246AbZE3Nln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932246AbZE3Nln (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 09:41:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758673AbZE3Nlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 09:41:37 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:48211 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbZE3Nlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 09:41:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=iIfSrCmNNLr2Yoi1WsPfAP934YjfDFxJk5JDhHA+XqLBbFvSnUhOXLyKImf5ITKLT0
         UgvBSWUzD1D+9DpXH+QzKn28OhBbO4iso1FU/D7eUQgvJCZEmuiKup6abWQS5EFK4VCW
         WMTxNkdFcIK51kfgstLAQRp1QP38yAZf1ZXkY=
Date: Sat, 30 May 2009 15:41:33 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Trenton D. Adams" <trenton.d.adams@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
       Reiserfs <reiserfs-devel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Jeff Mahoney <jeffm@suse.com>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Alexander Beregalov <a.beregalov@gmail.com>
Subject: Re: [PATCH 1/2] kill-the-bkl/reiserfs: acquire the inode mutex
	safely
Message-ID: <20090530134132.GA5969@nowhere>
References: <1242496922-6330-1-git-send-email-fweisbec@gmail.com> <1242496922-6330-2-git-send-email-fweisbec@gmail.com> <9b1675090905292005p2b53de7dy9e36f84368d76f01@mail.gmail.com> <20090530032253.GA5999@nowhere> <9b1675090905292123l7c3de4b6w897e153d60e5a469@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9b1675090905292123l7c3de4b6w897e153d60e5a469@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 29, 2009 at 10:23:44PM -0600, Trenton D. Adams wrote:
> On Fri, May 29, 2009 at 9:22 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > On Fri, May 29, 2009 at 09:05:31PM -0600, Trenton D. Adams wrote:
> >> On Sat, May 16, 2009 at 12:02 PM, Frederic Weisbecker
> >> <fweisbec@gmail.com> wrote:
> >> > While searching a pathname, an inode mutex can be acquired
> >> > in do_lookup() which calls reiserfs_lookup() which in turn
> >> > acquires the write lock.
> >> >
> >> > On the other side reiserfs_fill_super() can acquire the write_lock
> >> > and then call reiserfs_lookup_privroot() which can acquire an
> >> > inode mutex (the root of the mount point).
> >> >
> >> > So we theoretically risk an AB - BA lock inversion that could lead
> >> > to a deadlock.
> >> >
> >> > As for other lock dependencies found since the bkl to mutex
> >> > conversion, the fix is to use reiserfs_mutex_lock_safe() which
> >> > drops the lock dependency to the write lock.
> >> >
> >>
> >> I'm curious, did this get applied, and is it related to the following?
> >>  I was having these in 2.6.30-rc3.  I am now on 2.6.30-rc7 as of
> >> today.  I haven't seen them today.  But then again, I only seen this
> >> happen one time.
> >
> >
> > Hi,
> >
> > No, may be it will come for 2.6.31 but for now it is not merged so
> > it's not related.
> >
> > If you see such warning anymore, don't hesitate to tell about
> > it!
> >
> > Thanks!
> >
> 
> I was trying to imply that the patch might fix the problem I saw, not
> that it was the cause.  I only though that because it mentioned a
> potential deadlock, and it seems like that is what the problem I saw
> was.


Ah ok. No it's part of a tree which reworks the reiserfs locking scheme
by removing the old one based on the legacy and obsolete bkl (big kernel
lock). In this tree I had to fix several deadlocks or at least unsafe
lock states because the bkl is converted into a mutex and some new lock
dependencies were borned after that. But these issues had nothing
to deal with upstream problems.

BTW, would you be interested in giving a try with this reiserfs bkl
removal tree? I really lack testing and feedbacks from users.

Thanks!

Frederic.

