Return-Path: <linux-kernel-owner+w=401wt.eu-S1757957AbZEKS0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757957AbZEKS0l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 14:26:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755727AbZEKS0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 14:26:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47671 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754983AbZEKS0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 14:26:32 -0400
Message-ID: <4A086D9E.60308@suse.com>
Date: Mon, 11 May 2009 14:25:34 -0400
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Al Viro <viro@ftp.linux.org.uk>
Subject: [PATCH] dup2: Fix return value with oldfd == newfd and invalid fd
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

 The return value of dup2 when oldfd == newfd and the fd isn't valid is not
 getting properly sign extended. We end up with 4294967287 instead of -EBADF.

 I've reproduced this on SLE11 (2.6.27.21), openSUSE Factory (2.6.29-rc5),
 and Ubuntu 9.04 (2.6.28).

 This patch uses a signed int for the error value so it is properly extended.

 Commit 6c5d0512a091480c9f981162227fdb1c9d70e555 introduced this regression.

Reported-by: Jiri Dluhos <jdluhos@novell.com>
Signed-off-by: Jeff Mahoney <jeffm@suse.com>
- ---
 fs/fcntl.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

- --- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -115,13 +115,14 @@ out_unlock:
 
 SYSCALL_DEFINE2(dup2, unsigned int, oldfd, unsigned int, newfd)
 {
+	int ret = oldfd;
 	if (unlikely(newfd == oldfd)) { /* corner case */
 		struct files_struct *files = current->files;
 		rcu_read_lock();
 		if (!fcheck_files(files, oldfd))
- -			oldfd = -EBADF;
+			ret = -EBADF;
 		rcu_read_unlock();
- -		return oldfd;
+		return ret;
 	}
 	return sys_dup3(oldfd, newfd, 0);
 }

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkoIbZcACgkQLPWxlyuTD7JBVACgnNFiWRb4lhW9JgqR36BnT6SD
4uQAoJDcfqV2jsjCV340HlQLkk585Yw6
=IBqW
-----END PGP SIGNATURE-----
