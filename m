Return-Path: <linux-kernel-owner+w=401wt.eu-S1758806AbXE0QNM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758806AbXE0QNM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 12:13:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756456AbXE0QM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 12:12:58 -0400
Received: from mail.fieldses.org ([66.93.2.214]:51163 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755994AbXE0QM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 12:12:57 -0400
Date: Sun, 27 May 2007 12:12:52 -0400
To: David Howells <dhowells@redhat.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] AFS: Implement file locking
Message-ID: <20070527161252.GA12804@fieldses.org>
References: <20070527022502.GB10867@fieldses.org> <20070526022342.GA20905@fieldses.org> <20070524165554.22292.38887.stgit@warthog.cambridge.redhat.com> <7436.1180223730@redhat.com> <18750.1180255870@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18750.1180255870@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 27, 2007 at 09:51:10AM +0100, David Howells wrote:
> J. Bruce Fields <bfields@fieldses.org> wrote:
> > So if I request a write lock while holding a read lock, my request will
> > be denied?
> 
> At the moment, yes.  Don't the POSIX and flock lock-handling routines in the
> kernel normally do that anyway?

No, they'd upgrade in that case.

> > This is a little strange, though--if there's somebody waiting for a
> > write lock on an inode (because somebody else already holds a read lock
> > on it), that shouldn't block requests for read locks.
> 
> That depends on whether you want fairness or not.

Neither posix nor flock locks delay a lock because of pending
conflicting locks.  SUS, as I read it, wouldn't allow that.

> Allowing read locks to jump the queue like this can lead to starvation
> for your writers.

If you want fairness the best that you can do is to ensure that when
more than one pending lock can be applied, the one that has been waiting
longest will be chosen.  But you can't make all such lock requests wait
for a lock that hasn't even been applied yet.

You can contrive examples of applications that would be correct given
the standard fcntl behavior, but that would deadlock on a system that
didn't allow read locks to jump the queue in the above situation.  I
have no idea whether such applications actually exist in practice, but
I'd be uneasy about changing the standard behavior without inventing
some new kind of lock.

--b.
