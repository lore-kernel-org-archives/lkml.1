Return-Path: <linux-kernel-owner+w=401wt.eu-S1755488AbXIQO7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488AbXIQO7n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 10:59:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754135AbXIQO7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 10:59:36 -0400
Received: from mail.fieldses.org ([66.93.2.214]:55315 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753586AbXIQO7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 10:59:35 -0400
Date: Mon, 17 Sep 2007 10:59:34 -0400
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, devel@openvz.org
Subject: Re: [PATCH] Wake up mandatory locks waiter on chmod
Message-ID: <20070917145934.GA4957@fieldses.org>
References: <46E94993.3090506@openvz.org> <20070916194135.GC31801@fieldses.org> <46EE20C4.1060405@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46EE20C4.1060405@openvz.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2007 at 10:37:56AM +0400, Pavel Emelyanov wrote:
> J. Bruce Fields wrote:
> > Is there a small chance that a lock may be applied after this check:
> > 
> >> +	mandatory = (inode->i_flock && MANDATORY_LOCK(inode));
> >> +
> > 
> > but early enough that someone can still block on the lock while the file
> > is still marked for mandatory locking?  (And is the inode->i_flock check
> > there really necessary?)
> 
> There is, but as you have noticed:

OK, but why not just remove the inode->i_flock check there?  I can't see
how it helps anyway.

> > Well, there are probably worse races in the mandatory locking code.
> 
> ...there are. The inode->i_lock is protected with lock_kernel() only
> and is not in sync with any other checks for inodes. This is sad :(
> but a good locking for locks is to be done...

I would also prefer a locking scheme that didn't rely on the BKL.  That
said, except for this race:

> > (For example, my impression is that a mandatory lock can be applied just
> > after the locks_mandatory_area() checks but before the io actually
> > completes.)

... I'm not aware of other races in the existing file-locking code.  It
sounds like you might be.  Could you give specific examples?

--b.
