Return-Path: <linux-kernel-owner+w=401wt.eu-S1752078AbYJaMpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078AbYJaMpA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 08:45:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751147AbYJaMou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 08:44:50 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:57245 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbYJaMot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 08:44:49 -0400
To: ncunningham@crca.org.au
CC: miklos@szeredi.hu, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
In-reply-to: <1225452484.6574.35.camel@nigel-laptop> (message from Nigel
	Cunningham on Fri, 31 Oct 2008 22:28:04 +1100)
Subject: Re: [linux-pm] Freezer: Don't count threads waiting for
	frozen	filesystems.
References: <Pine.LNX.4.44L0.0810300955020.2401-100000@iolanthe.rowland.org>
	 <1225403060.6574.10.camel@nigel-laptop>
	 <E1Kvpgo-00045l-GU@pomaz-ex.szeredi.hu>
	 <1225444253.6574.21.camel@nigel-laptop>
	 <E1Kvq72-00049W-O1@pomaz-ex.szeredi.hu> <1225452484.6574.35.camel@nigel-laptop>
Message-Id: <E1KvtMn-0004YD-00@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 31 Oct 2008 13:44:41 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Oct 2008, Nigel Cunningham wrote:
> You don't. You just use FUSE_MIGHT_FREEZE to stop them before they take
> locks that might cause problems. So my suggestion is:

Before?  FUSE_MIGHT_FREEZE is called _after_ i_mutex is taken by the
VFS.

> 1) Stop new requests at FUSE_MIGHT_FREEZE
> 2) Handle existing requests by using freezer_do_not_count in
> request_send and request_send_nowait before the spin_lock and
> freezer_count after the spin_unlock.
> 
> With #2, we don't need to care about whether the request is completed
> before freezing completes or post-resume.
> 
> If the userspace process tries to use an already frozen fuse filesystem
> and gets frozen, that's okay because we'll sit waiting for an answer,
> not be counted by the freezer and so not contribute to any failure to
> freeze processes.
> 
> If the userspace process completes its work, we'll either get caught at
> the freezer_count (if we've already been told to freeze) or be gotten
> later, after exiting the fuse code.

Yes, this is the variant of categorizing sleeps to freezing and
non-freezing.  The problem is, you need to do that with all
mutex_lock(&inode->i_mutex) instances as well.  Try grepping for that
in fs/*.c!

It _is_ possible, it's just not practical.

Miklos
