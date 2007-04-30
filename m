Return-Path: <linux-kernel-owner+w=401wt.eu-S1161635AbXD3Fem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161635AbXD3Fem (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 01:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161640AbXD3Fem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 01:34:42 -0400
Received: from ozlabs.org ([203.10.76.45]:55049 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161635AbXD3Fel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 01:34:41 -0400
To: Andrew Morton <akpm@osdl.org>
From: Michael Ellerman <michael@ellerman.id.au>
Date: Mon, 30 Apr 2007 15:34:15 +1000
Subject: [PATCH] Propagate errors from find in scripts/gen_initramfs_list.sh
CC: <azarah@nosferatu.za.org>, <sam@ravnborg.org>,
       <linux-kernel@vger.kernel.org>
Message-Id: <20070430053440.8BC3FDDF7A@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If the find(1) in scripts/gen_initramfs_list.sh generates any errors, it
will cause gen_initramfs_list.sh to fail (because of "set -e"), however
the errors from find are not printed to the user. This is rather confusing:

~/src/powerpc$ make O=~/build/powerpc-cell32/
make[2]: *** [usr/initramfs_data.cpio.gz] Error 1
make[1]: *** [usr] Error 2
make[1]: *** Waiting for unfinished jobs....
make[1]: *** wait: No child processes.  Stop.
make: *** [_all] Error 2


It is much easier to work out what the problem is if we let the errors
from find hit the console, eg:

~/src/powerpc$ make O=~/build/powerpc-cell32/
find: /home/michael/initramfs-source/home: Permission denied
find: /home/michael/initramfs-source/lost+found: Permission denied
find: /home/michael/initramfs-source/opt: Permission denied
find: /home/michael/initramfs-source/root: Permission denied
make[2]: *** [usr/initramfs_data.cpio.gz] Error 1
make[1]: *** [usr] Error 2
make[1]: *** Waiting for unfinished jobs....
make[1]: *** wait: No child processes.  Stop.
make: *** [_all] Error 2

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
---

 scripts/gen_initramfs_list.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: powerpc/scripts/gen_initramfs_list.sh
===================================================================
--- powerpc.orig/scripts/gen_initramfs_list.sh
+++ powerpc/scripts/gen_initramfs_list.sh
@@ -171,7 +171,7 @@ dir_filelist() {
 	${dep_list}header "$1"
 
 	srcdir=$(echo "$1" | sed -e 's://*:/:g')
-	dirlist=$(find "${srcdir}" -printf "%p %m %U %G\n" 2>/dev/null)
+	dirlist=$(find "${srcdir}" -printf "%p %m %U %G\n")
 
 	# If $dirlist is only one line, then the directory is empty
 	if [  "$(echo "${dirlist}" | wc -l)" -gt 1 ]; then
