Return-Path: <linux-kernel-owner+w=401wt.eu-S1754806AbYAUSTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806AbYAUSTu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 13:19:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751403AbYAUSTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 13:19:43 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:39894 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbYAUSTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 13:19:42 -0500
Date: Mon, 21 Jan 2008 13:18:41 -0500
From: Jeff Dike <jdike@addtoit.com>
To: tytso@mit.edu, Matt Mackall <mpm@selenic.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] random - add async I/O support
Message-ID: <20080121181841.GA7383@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add async notification support to /dev/random.

A little test case is below.  Without this patch, you get:

$ ./async-random 
Drained the pool
Found more randomness

With it, you get:

$ ./async-random 
Drained the pool
SIGIO
Found more randomness

#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <errno.h>
#include <fcntl.h>

static void handler(int sig)
{
	printf("SIGIO\n");
}

int main(int argc, char **argv)
{
	int fd, n, err, flags;

	if(signal(SIGIO, handler) < 0){
		perror("setting SIGIO handler");
		exit(1);
	}

	fd = open("/dev/random", O_RDONLY);
	if(fd < 0){
		perror("open");
		exit(1);
	}

	flags = fcntl(fd, F_GETFL);
	if (flags < 0){
		perror("getting flags");
		exit(1);
	}

	flags |= O_NONBLOCK;
	if (fcntl(fd, F_SETFL, flags) < 0){
		perror("setting flags");
		exit(1);
	}

	while((err = read(fd, &n, sizeof(n))) > 0) ;

	if(err == 0){
		printf("random returned 0\n");
		exit(1);
	}
	else if(errno != EAGAIN){
		perror("read");
		exit(1);
	}

	flags |= O_ASYNC;
	if (fcntl(fd, F_SETFL, flags) < 0){
		perror("setting flags");
		exit(1);
	}

	if (fcntl(fd, F_SETOWN, getpid()) < 0) {
		perror("Setting SIGIO");
		exit(1);
	}

	printf("Drained the pool\n");
	read(fd, &n, sizeof(n));
	printf("Found more randomness\n");

	return(0);
}

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 drivers/char/random.c |   43 +++++++++++++++++++++++++++++++++----------
 1 file changed, 33 insertions(+), 10 deletions(-)

Index: linux-2.6.22/drivers/char/random.c
===================================================================
--- linux-2.6.22.orig/drivers/char/random.c	2008-01-17 12:51:07.000000000 -0500
+++ linux-2.6.22/drivers/char/random.c	2008-01-21 13:02:02.000000000 -0500
@@ -371,6 +371,8 @@ static struct poolinfo {
 static DECLARE_WAIT_QUEUE_HEAD(random_read_wait);
 static DECLARE_WAIT_QUEUE_HEAD(random_write_wait);
 
+static struct fasync_struct *fasync;
+
 #if 0
 static int debug = 0;
 module_param(debug, bool, 0644);
@@ -751,8 +753,10 @@ static size_t account(struct entropy_sto
 		else
 			r->entropy_count = reserved;
 
-		if (r->entropy_count < random_write_wakeup_thresh)
+		if (r->entropy_count < random_write_wakeup_thresh) {
 			wake_up_interruptible(&random_write_wait);
+			kill_fasync(&fasync, SIGIO, POLL_OUT);
+		}
 	}
 
 	DEBUG_ENT("debiting %d entropy credits from %s%s\n",
@@ -1090,8 +1094,11 @@ random_ioctl(struct inode * inode, struc
 		 * Wake up waiting processes if we have enough
 		 * entropy.
 		 */
-		if (input_pool.entropy_count >= random_read_wakeup_thresh)
+		if (input_pool.entropy_count >= random_read_wakeup_thresh) {
 			wake_up_interruptible(&random_read_wait);
+			kill_fasync(&fasync, SIGIO, POLL_IN);
+		}
+
 		return 0;
 	case RNDADDENTROPY:
 		if (!capable(CAP_SYS_ADMIN))
@@ -1111,8 +1118,10 @@ random_ioctl(struct inode * inode, struc
 		 * Wake up waiting processes if we have enough
 		 * entropy.
 		 */
-		if (input_pool.entropy_count >= random_read_wakeup_thresh)
+		if (input_pool.entropy_count >= random_read_wakeup_thresh) {
 			wake_up_interruptible(&random_read_wait);
+			kill_fasync(&fasync, SIGIO, POLL_IN);
+		}
 		return 0;
 	case RNDZAPENTCNT:
 	case RNDCLEARPOOL:
@@ -1128,17 +1137,31 @@ random_ioctl(struct inode * inode, struc
 	}
 }
 
+static int random_fasync(int fd, struct file *filp, int on)
+{
+	return fasync_helper(fd, filp, on, &fasync);
+}
+
+static int random_release(struct inode *inode, struct file *filp)
+{
+	return fasync_helper(-1, filp, 0, &fasync);
+}
+
 const struct file_operations random_fops = {
-	.read  = random_read,
-	.write = random_write,
-	.poll  = random_poll,
-	.ioctl = random_ioctl,
+	.read    = random_read,
+	.write   = random_write,
+	.poll    = random_poll,
+	.ioctl   = random_ioctl,
+	.fasync  = random_fasync,
+	.release = random_release,
 };
 
 const struct file_operations urandom_fops = {
-	.read  = urandom_read,
-	.write = random_write,
-	.ioctl = random_ioctl,
+	.read    = urandom_read,
+	.write   = random_write,
+	.ioctl   = random_ioctl,
+	.fasync  = random_fasync,
+	.release = random_release,
 };
 
 /***************************************************************
