Return-Path: <linux-kernel-owner+w=401wt.eu-S1759939AbYDCAmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759939AbYDCAmo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 20:42:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755344AbYDCAme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 20:42:34 -0400
Received: from pat.uio.no ([129.240.10.15]:48105 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753670AbYDCAmd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 20:42:33 -0400
Subject: Re: [patch 01/10] vfs: add path_create() and path_mknod()
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       dave@linux.vnet.ibm.com, ezk@cs.sunysb.edu,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080402234758.GS9785@ZenIV.linux.org.uk>
References: <20080402201247.358430231@szeredi.hu>
	 <20080402201321.062856131@szeredi.hu>
	 <20080402205450.GO9785@ZenIV.linux.org.uk>
	 <E1JhAF9-0007Zx-Rq@pomaz-ex.szeredi.hu>
	 <20080402214824.GP9785@ZenIV.linux.org.uk>
	 <1207174890.722.12.camel@heimdal.trondhjem.org>
	 <20080402223637.GQ9785@ZenIV.linux.org.uk>
	 <1207178398.20254.19.camel@heimdal.trondhjem.org>
	 <20080402234043.GR9785@ZenIV.linux.org.uk>
	 <20080402234758.GS9785@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Wed, 02 Apr 2008 20:42:09 -0400
Message-Id: <1207183329.20254.49.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=5.0, autolearn=disabled, none)
X-UiO-Scanned: 814E4F7F45F5D5802A9CD2D009D28ACAB6728181
X-UiO-SR-test: A05A7DD31B56E95911292100F5AD9A24AC6374AF
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 96 total 7673142 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-04-03 at 00:47 +0100, Al Viro wrote:
> On Thu, Apr 03, 2008 at 12:40:43AM +0100, Al Viro wrote:
> > Anyway, what the hell for?  It's more complex and buys you nothing
> > useful.
> 
> BTW, what it gives you is an extra headache for scenarios like
> 
> task A:
> 	write(fd, ...)
> task B:	/* shares descriptor table with A */
> 	close(fd)
> task C: umount(<mountpoint of tree where fd is>)
> ...
> task A: still writing
> 
> At the very least, you want "that thing is still busy" on normal umount -
> we are still in the middle of write(2) and hell knows how long it's going
> to last.  So you need to play with refcount of vfsmount in a very nasty
> way, for all your pains. 

We already call fget_light()/fput_light() around the whole call to
vfs_write(). Substituting a call to something which takes a reference to
the new structure is trivial.

Once the write() syscall is done, and the file is closed, why should we
refuse the umount request? There should be nothing more going on that
depends on the namespace.

>  Again, what for?

It allows you to get rid of the vfsmount 'argument' when opening a file,
which again lowers the barrier for stacking filesystems.

As far as the filesystems themselves are concerned, the effect is to
enforce your assertion that file operations should not depend on the
namespace.


