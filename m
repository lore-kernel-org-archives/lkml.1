Return-Path: <linux-kernel-owner+w=401wt.eu-S1752377AbXLZTaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377AbXLZTaU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 14:30:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751476AbXLZTaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 14:30:09 -0500
Received: from www2.coraid.com ([65.14.39.133]:29772 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751466AbXLZTaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 14:30:08 -0500
Date: Wed, 26 Dec 2007 14:28:22 -0500
From: "Ed L. Cashin" <ecashin@coraid.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/13] remove race between use and initialization of
	locks
Message-ID: <20071226192822.GG9411@coraid.com>
References: <1198188961-25147-1-git-send-email-ecashin@coraid.com> <1198188961-25147-9-git-send-email-ecashin@coraid.com> <20071221220040.5862b43b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071221220040.5862b43b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2007 at 10:00:40PM -0800, Andrew Morton wrote:
> On Thu, 20 Dec 2007 17:15:57 -0500 "Ed L. Cashin" <ecashin@coraid.com> wrote:
...
> > +static __DECLARE_SEMAPHORE_GENERIC(emsgs_sema, 0);
...
> > -	sema_init(&emsgs_sema, 0);
> > -	spin_lock_init(&emsgs_lock);
> >  	aoe_class = class_create(THIS_MODULE, "aoe");
> >  	if (IS_ERR(aoe_class)) {
> >  		unregister_chrdev(AOE_MAJOR, "aoechr");
> 
> I think it would be better to go back to initialising emsgs_lock at runtime
> rather than fattening the exported semaphore API like this.

I don't think there is anything wrong with having a complete set of
initialization routines for a semaphore, but it's certainly easy
enough to go back to Alexey Dobriyan's original suggestion, which was
to simply move the initialization calls before register_chardev.

I will follow this email with a patch that does that.

> emssgs_sema is a weird-looking thing.  There really should be some comments
> in there because it is unobvious what the code is attempting to do.
> 
> What is the code attempting to do?

There is a ring buffer of error messages.  Userland processes can read
these error messages by reading /dev/etherd/err, blocking if there are
no error messages to read yet.

The emsgs_sema semaphore is used to manage the reader(s) waiting for
error messages.  When there are sleepers waiting, "up" is used to wake
one up when a new error message is produced.  A reader gets a single
message, not just some text with a mixture of different errors.

If I do,

  cat /dev/etherd/err > /my/log/file

... then I can hit control-c or send a SIGTERM to stop it.

> It appears to me that nblocked_emsgs_readers gets incorrectly
> decremented if the down_interruptible() got interrupted, btw.

The counter will be incremented again if the process goes back to
sleep waiting for an error message, but the process might be getting
killed.  The counter is really just for sleeping readers.

-- 
  Ed L Cashin <ecashin@coraid.com>
