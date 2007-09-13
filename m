Return-Path: <linux-kernel-owner+w=401wt.eu-S1757404AbXIMKIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404AbXIMKIR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 06:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750768AbXIMKII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 06:08:08 -0400
Received: from boogie.lpds.sztaki.hu ([193.224.70.237]:59228 "EHLO
	boogie.lpds.sztaki.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbXIMKIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 06:08:07 -0400
Date: Thu, 13 Sep 2007 12:08:03 +0200
From: Gabor Gombas <gombasg@sztaki.hu>
To: Brent Casavant <bcasavan@sgi.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: O_NOLINK for open()
Message-ID: <20070913100803.GG11567@boogie.lpds.sztaki.hu>
References: <20070912144128.D5573@pkunk.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070912144128.D5573@pkunk.americas.sgi.com>
X-Copyright: Forwarding or publishing without permission is prohibited.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2007 at 03:37:44PM -0500, Brent Casavant wrote:

> System V shmem is right out because the IPC key is publicly
> visible and there is no combination of permissions which
> will allow sharing the segment with just one other process
> (or at least just one other user).  To my knowledge Linux's
> implementation doesn't provide ACLs for SysV shmem.  SGI's
> proposed XPMEM suffers from the same problems for my purposes.

SYSV shared memory has the concept of separate creator and owner ID's,
so you can share the shmem segment between exactly two users. Just use
IPC_SET and set shm_perm.uid to the user ID of the peer process.

> I could mmap a temporary tmpfs file (tmpfs so that if there is a
> machine crash no sensitive data persists) which is created with
> permissions of 0, immediately unlink it, and pass the file
> descriptor through an AF_UNIX socket.  This does open up a very
> small window of vulnerability if another process is able to chmod
> the file and open it before the unlink.

I think your worries about permissions has been cleared by the other
posts, but there is still a problem: the client may call ftruncate() on
the file descriptor, and then your daemon will get a nice SIGBUS when it
tries to access the shared memory. Handling that gracefully may not be
trivial esp. if your daemon is multi-threaded. SYSV shmem is _much_
nicer when you want shared memory between unrelated/untrusted processes.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
