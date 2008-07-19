Return-Path: <linux-kernel-owner+w=401wt.eu-S1752752AbYGSHY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbYGSHY6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 03:24:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751485AbYGSHYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 03:24:49 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:36296 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751478AbYGSHYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 03:24:48 -0400
X-Sasl-enc: Ireyfq8Xk9rtLBC0Z88238JRS0QP91Y3ja9piUjWj4CR 1216452286
Subject: Re: [PATCH 5/7] autofs4 - fix direct mount pending expire race
From: Ian Kent <raven@themaw.net>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       autofs mailing list <autofs@linux.kernel.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <1216433386.3210.16.camel@raven.themaw.net>
References: <20080718023651.12802.59107.stgit@raven.themaw.net>
	 <20080718023725.12802.74137.stgit@raven.themaw.net>
	 <x49bq0vc5wb.fsf@segfault.boston.devel.redhat.com>
	 <1216433386.3210.16.camel@raven.themaw.net>
Content-Type: text/plain
Date: Sat, 19 Jul 2008 15:21:03 +0800
Message-Id: <1216452065.3210.25.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-07-19 at 10:09 +0800, Ian Kent wrote:
> On Fri, 2008-07-18 at 16:08 -0400, Jeff Moyer wrote:
> > 
> > This makes me uneasy.  This should take d_mounted to zero.  Then, when
> > the daemon actually does the unmount, won't the d_mounted drop below
> > zero?  Following calls to d_mountpoint will return a negative value, but
> > everyone treats it as a boolean, so it will evaluate to true for a brief
> > time.  Or did I miss something?
> 
> Yes, I thought about doing exactly that.
> 
> But the thing that effects d_mounted is mounted on the dentry and so
> d_mounted may be decremented during the expire. So if we set it
> explicitly it would be incorrect at the end. While the
> decrement/increment isn't always correct throughout the expire we need
> to handle the mount following in ->follow_link() anyway and then the
> decrement/increment ends up with the correct value once the expire is
> complete.
> 
> One problem that has occurred to me is that user space could could
> manually umount it just when we change it. So a follow up patch to add a
> lock around the increment/decrement in fs/namespace.c and
> fs/autofs4/expire.c is in order. I'm having a look at that now.

DOH, this is rubbish.

I often wonder why I forget what I've done so quickly.

Of course user space can't umount this because every process except the
daemon is blocked in ->follow_link() during the expire. But we can't
rely on the the return from user space and cannot know if the mount was
actually umounted so the decrement/increment will maintain the
status-quo. If d_mounted does become negative during the expire then we
will still be sent to ->follow_link() as follow_down() will fail.

Ian

