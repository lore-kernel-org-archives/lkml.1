Return-Path: <linux-kernel-owner+w=401wt.eu-S1759427AbXIQWgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759427AbXIQWgR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 18:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756524AbXIQWgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 18:36:04 -0400
Received: from mail.fieldses.org ([66.93.2.214]:60101 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757319AbXIQWgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 18:36:03 -0400
Date: Mon, 17 Sep 2007 18:36:00 -0400
To: Nix <nix@esperi.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6.22.6] nfsd: fh_verify() `malloc failure' with lots of
	free memory leads to NFS hang
Message-ID: <20070917223600.GA30350@fieldses.org>
References: <874phtkk25.fsf@hades.wkstn.nix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874phtkk25.fsf@hades.wkstn.nix>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2007 at 11:23:46PM +0100, Nix wrote:
> Sep 17 22:57:55 loki warning: kernel: nfsd_dispatch: vers 3 proc 4
> Sep 17 22:57:55 loki warning: kernel: nfsd: ACCESS(3)   36: 01070001 000fb001 00000000 d32ff38f 404811a6 a88d96ab 0x1f
> Sep 17 22:57:55 loki warning: kernel: nfsd: fh_verify(36: 01070001 000fb001 00000000 d32ff38f 404811a6 a88d96ab)
> Sep 17 22:57:55 loki warning: kernel: nfsd: Dropping request due to malloc failure!
> Sep 17 22:58:50 hades notice: kernel: nfs: server loki not responding, still trying
> Sep 17 22:58:50 hades notice: kernel: nfs: server loki not responding, still trying
> Sep 17 22:58:55 hades notice: kernel: nfs: server loki not responding, still trying
> Sep 17 22:59:40 hades notice: kernel: nfs: server loki not responding, still trying
> 
> 
> >From then on, *every* fh_verify() request fails the same way, and
> obviously if you can't verify any fds you can't do much with NFS.
> 
> Looking back in the log I see intermittent malloc failures starting
> almost as soon as I've booted (allowing a couple of minutes for me to
> turn debugging on):
> 
> Sep 17 22:25:50 hades notice: kernel: nfs: server loki OK
> [...]
> Sep 17 22:28:09 loki warning: kernel: nfsd_dispatch: vers 3 proc 19
> Sep 17 22:28:09 loki warning: kernel: nfsd: FSINFO(3)   28: 00070001 000fb001 00000000 d32ff38f 404811a6 a88d96ab
> Sep 17 22:28:09 loki warning: kernel: nfsd: fh_verify(28: 00070001 000fb001 00000000 d32ff38f 404811a6 a88d96ab)
> Sep 17 22:28:09 loki warning: kernel: nfsd: Dropping request due to malloc failure!
> 
> A while later we start seeing runs of malloc failures, which I think
> correlated with the unexplained pauses in NFS response:

Actually, they're nothing to do with malloc failures--the message
printed here is misleading, and isn't even an error; it gets printed
whenever an upcall to mountd is made.  The problem is almost certainly a
problem with kernel<->mountd communication--the kernel depends on mountd
to answer questions about exported filesystems as part of the fh_verify
code.

It's just a shot in the dark, but you might try the latest nfs-utils
(get the latest out of git://linux-nfs.org/nfs-utils if you're already
on the most recent your distro will give you).  Or just apply the
following--which did fix a problem whose symptoms varied depending on
libc behavior.

If that doesn't work, I'd try

	strace -s0 `pidof rpc.mountd`

and also look at the contents of /proc/net/rpc/nfsd.fh/contents.

--b.

commit dd087896285da9e160e13ee9f7d75381b67895e3
Author: J. Bruce Fields <bfields@citi.umich.edu>
Date:   Thu Jul 26 16:30:46 2007 -0400

    Use __fpurge to ensure single-line writes to cache files
    
    On a recent Debian/Sid machine, I saw libc retrying stdio writes that
    returned write errors.  The result is that if an export downcall returns
    an error (which it can in normal operation, since it currently
    (incorrectly) returns -ENOENT on any negative downcall), then subsequent
    downcalls will write multiple lines (including the original line that
    received the error).
    
    The result is that the server fails to respond to any rpc call that
    refers to an unexported mount point (such as a readdir of a directory
    containing such a mountpoint), so client commands hang.
    
    I don't know whether this libc behavior is correct or expected, but it
    seems safest to add the __fpurge() (suggested by Neil) to ensure data is
    thrown away.
    
    Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
    Signed-off-by: Neil Brown <neilb@suse.de>

diff --git a/support/nfs/cacheio.c b/support/nfs/cacheio.c
index a76915b..9d271cd 100644
--- a/support/nfs/cacheio.c
+++ b/support/nfs/cacheio.c
@@ -17,6 +17,7 @@
 
 #include <nfslib.h>
 #include <stdio.h>
+#include <stdio_ext.h>
 #include <ctype.h>
 #include <unistd.h>
 #include <sys/types.h>
@@ -111,7 +112,18 @@ void qword_printint(FILE *f, int num)
 
 int qword_eol(FILE *f)
 {
+	int err;
+
 	fprintf(f,"\n");
+	err = fflush(f);
+	/*
+	 * We must send one line (and one line only) in a single write
+	 * call.  In case of a write error, libc may accumulate the
+	 * unwritten data and try to write it again later, resulting in a
+	 * multi-line write.  So we must explicitly ask it to throw away
+	 * any such cached data:
+	 */
+	__fpurge(f);
 	return fflush(f);
 }
 
