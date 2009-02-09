Return-Path: <linux-kernel-owner+w=401wt.eu-S1754827AbZBILXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827AbZBILXd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 06:23:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753242AbZBILXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 06:23:23 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:35683 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbZBILXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 06:23:22 -0500
Date: Mon, 9 Feb 2009 11:23:21 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Menage <menage@google.com>, Arjan van de Ven <arjan@infradead.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [cgroup or VFS ?] INFO: possible recursive locking detected
Message-ID: <20090209112321.GW28946@ZenIV.linux.org.uk>
References: <49617D2E.8050502@cn.fujitsu.com> <496576E7.1@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496576E7.1@cn.fujitsu.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2009 at 11:45:43AM +0800, Li Zefan wrote:
> Hi Al Viro,
> 
> I hacked into the kernel with the patch below (I think It's ok for me
> to comment out bdev->bd_mount_sem for testing):

> And ran 2 threads:
> 	for ((; ;))  # thread 1
> 	{
> 		mount -t ext3 /dev/sda9 /mnt1
> 		umount /mnt1
> 	}
> 
> 	for ((; ;))  # thread 2
> 	{
> 		mount -t ext3 /dev/sda9 /mnt2
> 		umount /mnt2
> 	}
> 
> And I got the same lockdep warning immediately, so I think it's
> VFS's issue.

It's a lockdep issue, actually.  It _is_ a false positive; we could get rid
of that if we took destroy_super(s); just before grab_super(), but I really
do not believe that there's any point.

Frankly, I'd rather see if there's any way to teach lockdep that this instance
of lock is getting initialized into "one writer" state and that yes, we know
that it's not visible to anyone, so doing that is safe, TYVM, even though
we are under spinlock.  Then take that sucker to just before set().

In any case, I really do not believe that it might have anything to do with
the WARN_ON() from another thread...

Comments?
