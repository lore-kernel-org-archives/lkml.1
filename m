Return-Path: <linux-kernel-owner+w=401wt.eu-S1758518AbYEFMKF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758518AbYEFMKF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 08:10:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753355AbYEFMJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 08:09:52 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:55001 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181AbYEFMJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 08:09:51 -0400
Date: Tue, 6 May 2008 06:09:34 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: AIM7 40% regression with 2.6.26-rc1
Message-ID: <20080506120934.GH19219@parisc-linux.org>
References: <1210052904.3453.30.camel@ymzhang> <20080506114449.GC32591@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080506114449.GC32591@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2008 at 01:44:49PM +0200, Ingo Molnar wrote:
> * Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:
> > After I manually reverted the patch against 2.6.26-rc1 while fixing 
> > lots of conflictions/errors, aim7 regression became less than 2%.
> 
> hm, which exact semaphore would that be due to?
> 
> My first blind guess would be the BKL - there's not much other semaphore 
> use left in the core kernel otherwise that would affect AIM7 normally. 
> The VFS still makes frequent use of the BKL and AIM7 is very VFS 
> intense. Getting rid of that BKL use from the VFS might be useful to 
> performance anyway.

That's slightly slanderous to the VFS ;-)  The BKL really isn't used
that much any more.  So little that I've gone through and produced a
list of places it's used:

fs/block_dev.c		opening and closing a block device.  Unlikely to be
			provoked by AIM7.
fs/char_dev.c		chrdev_open.  Unlikely to be provoked by AIM7.
fs/compat.c		mount.  Unlikely to be provoked by AIM7.
fs/compat_ioctl.c	held around calls to ioctl translator.
fs/exec.c		coredump.  If this is a contention problem ...
fs/fcntl.c		held around call to ->fasync.
fs/ioctl.c		held around f_op ->ioctl call (tmpfs doesn't have
			ioctl).  ditto bmap.  there's fasync, as previously
			mentioned.
fs/locks.c		hellhole.  I hope AIM7 doesn't use locks.
fs/namespace.c		mount, umount.  Unlikely to be provoked by AIM7.
fs/read_write.c		llseek.  tmpfs uses the unlocked version.
fs/super.c		shtdown, remount.  Unlikely to be provoked by AIM7.

So the only likely things I can see are:

 - file locks
 - fasync

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
