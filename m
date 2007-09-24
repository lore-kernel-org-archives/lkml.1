Return-Path: <linux-kernel-owner+w=401wt.eu-S1760735AbXIXRMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760735AbXIXRMT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 13:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754322AbXIXRMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 13:12:10 -0400
Received: from mail.fieldses.org ([66.93.2.214]:44371 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754115AbXIXRMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 13:12:09 -0400
Date: Mon, 24 Sep 2007 13:12:00 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Reuben Farrelly <reuben-linuxkernel@reub.net>,
       linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@openvz.org>
Subject: Re: 2.6.23-rc7-mm1
Message-ID: <20070924171200.GB22868@fieldses.org>
References: <20070924021716.9bfe7dfb.akpm@linux-foundation.org> <46F7CF2E.9030609@reub.net> <20070924095929.76fce85c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070924095929.76fce85c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2007 at 09:59:29AM -0700, Andrew Morton wrote:
> On Tue, 25 Sep 2007 00:52:30 +1000 Reuben Farrelly <reuben-linuxkernel@reub.net> wrote:
> 
> > 
> > 
> > On 24/09/2007 7:17 PM, Andrew Morton wrote:
> > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc7/2.6.23-rc7-mm1/
> > > 
> > > - New git tree git-powerpc-galak.patch added to the -mm lineup: ppc32
> > >   things, mainly (Kumar Gala <galak@gate.crashing.org>)
> > 
> > I'm observing a problem with this kernel (as well as 2.6.23-rc6-mm1) which 
> > manifests itself only in my Postfix/application mail.logs:
> > 
> > Sep 25 00:25:40 tornado postfix/smtp[12520]: fatal: select lock: Cannot allocate 
> > memory
> > Sep 25 00:25:41 tornado postfix/master[8002]: warning: process 
> > /usr/lib64/postfix/smtp pid 12520 exit status 1
> > 
> > This is happening frequently with processes started via 'master' (smtp, smtpd 
> > and cleanup), but it does not appear to have any noticeable operational impact 
> > apart from logging a lot of copies of this message.
> > 
> > The corresponding code in Postfix which triggers this is (choice of 3 files in 
> > src/master are all possibilities which all have much the same code)

Oog.  Looks like it's the "Memory shortage can result in inconsistent
flocks state" patch--the error variable is being set in some cases when
it shouldn't be.  Does the following fix it?

That's in my git tree, not in mainline.  I'll fix up my copy.

And I'll spend some time today figuring out what to do about regression
testing for the posix lock, flock, and lease code.

Thanks for the bug report!

--b.

diff --git a/fs/locks.c b/fs/locks.c
index a6c5917..3e8bfd2 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -740,6 +740,7 @@ static int flock_lock_file(struct file *filp, struct file_lock *request)
 		new_fl = locks_alloc_lock();
 		if (new_fl == NULL)
 			goto out;
+		error = 0;
 	}
 
 	for_each_lock(inode, before) {
