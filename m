Return-Path: <linux-kernel-owner+w=401wt.eu-S1754574AbZFWRhJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574AbZFWRhJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 13:37:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752720AbZFWRg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 13:36:58 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39879 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751893AbZFWRg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 13:36:57 -0400
Date: Tue, 23 Jun 2009 13:39:00 -0400
From: Josef Bacik <jbacik@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, rjones@redhat.com, linux-fsdevel@vger.kernel.org
Subject: [PATCH][REGRESSION] vfs: fix ref counting error
Message-ID: <20090623173900.GF27045@dhcp231-156.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a regression introduced by

2a737871108de9ba8930f7650d549f1383767f8b

which causes a ref counting bug which keeps us from being able to umount a
volume.

When doing a do_filp_lookup, we do not do a path_put on the cached root path if
we succeed in creating a file, we only do it in the failure case.  This causes
the following testcase to be unable to unmount the volume

=== Wrapper script ===
#!/bin/sh -

set -e

dd if=/dev/zero of=/tmp/fs bs=1024k count=10
/sbin/mkfs.ext2 -F /tmp/fs

rm -rf /tmp/mnt
mkdir /tmp/mnt

mount -o loop /tmp/fs /tmp/mnt

/tmp/test

====

=== test code ===

#define _XOPEN_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>

int
main (int argc, char *argv[])
{
  int fd, r;

  if (chdir ("/") == -1) {
    perror ("chdir");
    exit (1);
  }

  if (chroot ("/tmp/mnt") == -1) {
    perror ("chroot#1");
    exit (1);
  }
  fd = open ("/hello", O_WRONLY|O_CREAT|O_NOCTTY, 0666);
  if (fd == -1) {
    perror ("open");
    exit (1);
  }
  if (chroot (".") == -1) {
    perror ("chroot#2");
    exit (1);
  }
  if (close (fd) == -1) {
    perror ("close");
    exit (1);
  }

  r = system ("umount /tmp/mnt");
  if (r == -1 || WEXITSTATUS(r) != 0) {
    fprintf (stderr, "umount failed\n");
    exit (1);
  }

  exit (0);
}

===

This testcase was provided by Richard Jones, and with this patch it exits
successfully.  This patch was also tested with a broader testsuite that the
problem was originally exposed by and was fixed.  Thanks, 

Signed-off-by: Josef Bacik <jbacik@redhat.com>
Reported-by: Richard Jones <rjones@redhat.com>
Tested-by: Richard Jones <rjones@redhat.com>
---
 fs/namei.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 527119a..94c52b3 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1758,6 +1758,9 @@ do_last:
 			goto exit;
 		}
 		filp = nameidata_to_filp(&nd, open_flag);
+
+		if (nd.root.mnt)
+			path_put(&nd.root);
 		mnt_drop_write(nd.path.mnt);
 		return filp;
 	}
@@ -1812,6 +1815,8 @@ ok:
 		goto exit;
 	}
 	filp = nameidata_to_filp(&nd, open_flag);
+	if (nd.root.mnt)
+		path_put(&nd.root);
 	/*
 	 * It is now safe to drop the mnt write
 	 * because the filp has had a write taken
-- 
1.6.2.2

