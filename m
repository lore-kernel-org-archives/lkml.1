Return-Path: <linux-kernel-owner+w=401wt.eu-S1752997AbYKFUV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997AbYKFUV0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 15:21:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751042AbYKFUVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 15:21:18 -0500
Received: from crmm.lgl.lu ([158.64.72.228]:51681 "EHLO lll.lu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751041AbYKFUVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 15:21:17 -0500
Date: Thu, 6 Nov 2008 21:21:12 +0100
From: Alain Knaff <alain@knaff.lu>
Message-Id: <200811062021.mA6KLCEp030336@hitchhiker.org.lu>
Subject: [PATCH] VFS: lseek(fd, 0, SEEK_CUR) race condition
To: <viro@zeniv.linux.org.uk>, <linux-fsdevel@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, <alain@knaff.lu>
X-Mailer: mail (GNU Mailutils 1.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a race condition in lseek. While it is expected that
unpredictable behaviour may result while repositioning the offset of a
file descriptor concurrently with reading/writing to the same file
descriptor, this should not happen when merely *reading* the file
descriptor's offset.

Unfortunately, the only portable way in Unix to read a file
descriptor's offset is lseek(fd, 0, SEEK_CUR); however executing this
concurrently with read/write may mess up the position, as shown by the
testcase below:

#include <sys/types.h>
#include <stdio.h>
#include <pthread.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <pthread.h>


void *loop(void *ptr)
{
  fprintf(stderr, "Starting seek thread\n");
  while(1) {
    if(lseek(0, 0LL, SEEK_CUR) < 0LL)
      perror("seek");
  }
}

int main(int argc, char **argv) {
  long long l=0;
  int r;
  char buf[4096];

  pthread_t thread;
  pthread_create(&thread, 0, loop, 0);

  for(r=0; 1 ; r++) {
    int n = read(0, buf, 4096);
    if(n == 0)
      break;
    if(n < 4096) {
      fprintf(stderr, "Short read %d %s\n", n, strerror(errno));
    }
    l+= n;
  }
  fprintf(stderr, "Read %lld bytes\n", l);
  
  return 0;
}

Compile this and run it on a multi-processor machine as
 ./a.out <bigFile

where bigFile is a 1 Gigabyte file. It should print 1073741824.
However, on a buggy kernel, it usually produces a bigger number. The
problem only happens on a multiprocessor machine. This is because an
lseek(fd, 0, SEEK_CUR) running concurrently with a read() or write()
will reset the position back to what it used to be when the read()
started.

This behavior was observed "in the wild" when using udpcast which uses
lseek to monitor progress of reading/writing the uncompressed data.

The patch below fixes the issue by "special-casing" the lseek(fd, 0,
SEEK_CUR) pattern.

Apparently, an attempt was already made to fix the issue by the
following code:

		if (offset != file->f_pos) {
			file->f_pos = offset;
			file->f_version = 0;
		}

However, this doesn't work if file->f_pos was changed (by read() or
write()) between the time offset was computed, and the time where it
considers writing it back.

Signed-off-by: Alain Knaff <alain@knaff.lu>

---

diff -pur kernel.orig/fs/read_write.c kernel/fs/read_write.c
--- kernel.orig/fs/read_write.c	2008-10-11 14:12:07.000000000 +0200
+++ kernel/fs/read_write.c	2008-11-06 19:55:59.000000000 +0100
@@ -42,6 +42,8 @@ generic_file_llseek_unlocked(struct file
 			offset += inode->i_size;
 			break;
 		case SEEK_CUR:
+			if(offset == 0)
+				return file->f_pos;
 			offset += file->f_pos;
 	}
 	retval = -EINVAL;
