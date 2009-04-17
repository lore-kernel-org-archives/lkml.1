Return-Path: <linux-kernel-owner+w=401wt.eu-S932096AbZDQReq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096AbZDQReq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 13:34:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758813AbZDQReg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 13:34:36 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46578 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756924AbZDQReg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 13:34:36 -0400
Date: Fri, 17 Apr 2009 18:34:22 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alessio Igor Bogani <abogani@texware.it>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH -tip] remove the BKL: Replace BKL in mount/umount
	syscalls with a mutex
Message-ID: <20090417173422.GJ26366@ZenIV.linux.org.uk>
References: <1239892078-6039-1-git-send-email-abogani@texware.it> <20090416160645.GB17804@elte.hu> <20090416235649.GF26366@ZenIV.linux.org.uk> <20090417000142.GF21405@elte.hu> <20090417001345.GH26366@ZenIV.linux.org.uk> <20090417002744.GB29630@elte.hu> <20090417003805.GI26366@ZenIV.linux.org.uk> <20090417165643.GL8253@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090417165643.GL8253@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 17, 2009 at 06:56:43PM +0200, Ingo Molnar wrote:

> Stupid question regarding c): wouldnt such data structures go via 
> the VFS - which you said was free of BKL constraints? Or are there 
> interconnected private data structures between certain types of 
> closely related filesystems that the VFS does not know about? (and 
> hence might have BKL assumptions)

Shared between different instances of this fs type.  E.g. if FAT had
its hashtable not per-superblock (as it is now) but system-wide (as it
used to be prior to [PATCH] FAT: the inode hash from per module to per sb),
it would be suspicious.  In this particular case, it was OK from the
very beginning (I'd used a system-wide spinlock to protect it when it
had been introduced and per-superblock splitup made that spinlock per-sb
along with the hash table).

IOW, I wouldn't particulary worry about interactions between different
fs _types_ - it's interactions between the different fs _instances_
within the same driver that are likely sources of PITA.

ObOtherQuestion: no, I don't think that bdev open and bdev ioctls situation
is related to this group of BKL users.  sb_set_blocksize() might, in principle,
want a memory barrier of some kind, but that's it.
