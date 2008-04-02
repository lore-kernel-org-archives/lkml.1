Return-Path: <linux-kernel-owner+w=401wt.eu-S1759827AbYDBXxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759827AbYDBXxW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 19:53:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755204AbYDBXxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 19:53:07 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56348 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756235AbYDBXxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 19:53:04 -0400
Date: Thu, 3 Apr 2008 00:47:58 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       dave@linux.vnet.ibm.com, ezk@cs.sunysb.edu,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 01/10] vfs: add path_create() and path_mknod()
Message-ID: <20080402234758.GS9785@ZenIV.linux.org.uk>
References: <20080402201247.358430231@szeredi.hu> <20080402201321.062856131@szeredi.hu> <20080402205450.GO9785@ZenIV.linux.org.uk> <E1JhAF9-0007Zx-Rq@pomaz-ex.szeredi.hu> <20080402214824.GP9785@ZenIV.linux.org.uk> <1207174890.722.12.camel@heimdal.trondhjem.org> <20080402223637.GQ9785@ZenIV.linux.org.uk> <1207178398.20254.19.camel@heimdal.trondhjem.org> <20080402234043.GR9785@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080402234043.GR9785@ZenIV.linux.org.uk>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2008 at 12:40:43AM +0100, Al Viro wrote:
> Anyway, what the hell for?  It's more complex and buys you nothing
> useful.

BTW, what it gives you is an extra headache for scenarios like

task A:
	write(fd, ...)
task B:	/* shares descriptor table with A */
	close(fd)
task C: umount(<mountpoint of tree where fd is>)
...
task A: still writing

At the very least, you want "that thing is still busy" on normal umount -
we are still in the middle of write(2) and hell knows how long it's going
to last.  So you need to play with refcount of vfsmount in a very nasty
way, for all your pains.  Again, what for?
