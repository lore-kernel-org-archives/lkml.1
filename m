Return-Path: <linux-kernel-owner+w=401wt.eu-S1755058AbZDVLkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058AbZDVLkF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 07:40:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753546AbZDVLjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 07:39:53 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:51438 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbZDVLjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 07:39:52 -0400
To: tj@kernel.org
CC: linux-kernel@vger.kernel.org, fuse-devel@lists.sourceforge.net,
       miklos@szeredi.hu
In-reply-to: <1239674094-30894-1-git-send-email-tj@kernel.org> (message from
	Tejun Heo on Tue, 14 Apr 2009 10:54:48 +0900)
Subject: Re: [PATCHSET] CUSE: implement CUSE, take #3
References: <1239674094-30894-1-git-send-email-tj@kernel.org>
Message-Id: <E1Lwanr-00041r-RP@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 22 Apr 2009 13:39:47 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Tejun,

Sorry for the delay, I was busy reimplementing some of the stuff in
your patchset.  The current state is here:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git cuse-test

  http://git.kernel.org/?p=linux/kernel/git/mszeredi/fuse.git;a=shortlog;h=cuse-test

What I changed (IIRC):

 - Don't store pointer to struct inode, struct fuse_inode, and struct
   file in struct fuse_file.  Instead store nodeid in struct
   fuse_file, no worries about object lifetimes this way.

 - Don't implement fsync and flush in CUSE, they don't really make
   sense on character devices.  At least I can't think of any use for
   them.

 - release() in CUSE can be synchronous.  Asynchronous release causes
   many headaches in fuse, but is necessary due to the possible DoS
   that an unprivileged filesystem could do with an unrelated process.
   Since CUSE servers are always privileged, this should not be an
   issue.

 - Other cleanups.

I still think that the INIT sequence in CUSE is way too complicated
and that the kernel thread is unnecessary.  How about doing the init
with a single CUSE_INIT message which embeds the fuse_init_in and
fuse_init_out structures.  I also don't see the purpose of the
CUSE_INIT_DONE message.  Isn't it enough not to send any other
messages while the initialization is not complete?  This is what fuse
does.

I'm currently testing with ossp and some things do work, but I'm also
having issues with some apps.  But that's a topic for another mail...

Thanks,
Miklos
