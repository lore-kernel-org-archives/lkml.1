Return-Path: <linux-kernel-owner+w=401wt.eu-S1757910AbXLGUBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910AbXLGUBp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 15:01:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754548AbXLGUBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 15:01:35 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:34414 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502AbXLGUBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 15:01:34 -0500
Date: Fri, 7 Dec 2007 15:00:13 -0500
Message-Id: <200712072000.lB7K0DZ5013256@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, linux-kernel@vger.kernel.org,
       nfs@lists.sourceforge.net, "Eric W. Biederman" <ebiederm@xmission.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       Pavel Emelyanov <xemul@openvz.org>,
       "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [NFS] NFSv2/3 broken exporting/mounting (permission denied) in 2.6.24-rc4 
In-reply-to: Your message of "Thu, 06 Dec 2007 21:55:04 EST."
             <20071207025504.GA3070@fieldses.org> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20071207025504.GA3070@fieldses.org>, "J. Bruce Fields" writes:
> On Thu, Dec 06, 2007 at 09:20:41PM -0500, Erez Zadok wrote:
> > I get a "permission denied" when trying to mount a localhost nfsv2/3
> > exported volume, on v2.6.24-rc4-124-gf194d13.  It works w/ nfsv4 mounting.
> > It worked fine in 2.6.24-rc3.  Here's a sequence of ops I tried:
> > 
> > # mount -t ext2 /dev/hdb1 /n/lower/b0
> > # exportfs -o no_root_squash,rw localhost:/n/lower/b0
> > # mount -t nfs -o nfsvers=3 localhost:/n/lower/b0 /mnt
> 
> What do you see if you watch the network traffic in ethereal?
> 
> --b.

Bruce, I'm using nfs-utils-1.0.10-14.fc6 on an FC6 system with all latest
FC6 patches.  Using git-bisect I was able to find the patch which broke it:

commit 2b1e300a9dfc3196ccddf6f1d74b91b7af55e416
Author: Eric W. Biederman <ebiederm@xmission.com>
Date:   Sun Dec 2 00:33:17 2007 +1100

    [NETNS]: Fix /proc/net breakage
    
    Well I clearly goofed when I added the initial network namespace support
    for /proc/net.  Currently things work but there are odd details visible to
    user space, even when we have a single network namespace.
    
    Since we do not cache proc_dir_entry dentries at the moment we can just
    modify ->lookup to return a different directory inode depending on the
    network namespace of the process looking at /proc/net, replacing the
    current technique of using a magic and fragile follow_link method.
    
    To accomplish that this patch:
    - introduces a shadow_proc method to allow different dentries to
      be returned from proc_lookup.
    - Removes the old /proc/net follow_link magic
    - Fixes a weakness in our not caching of proc generic dentries.
    
    As shadow_proc uses a task struct to decided which dentry to return we can
    go back later and fix the proc generic caching without modifying any code
    that uses the shadow_proc method.
    
    Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
    Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
    Cc: Pavel Machek <pavel@ucw.cz>
    Cc: Pavel Emelyanov <xemul@openvz.org>
    Cc: "David S. Miller" <davem@davemloft.net>
    Cc: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

With the above patch, rpc.mountd is unable to open /proc/fs/nfsd/filehandle.
Strace shows:

open("/proc/fs/nfsd/filehandle", O_RDWR|O_LARGEFILE) = -1 ENOENT (No such file or directory)

Without the above patch, /proc/fs/nfsd is populated with a number of files,
including "filehandle".

Erez.
