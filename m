Return-Path: <linux-kernel-owner+w=401wt.eu-S1760153AbZIPV1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760153AbZIPV1o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 17:27:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754919AbZIPV1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 17:27:42 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:56634 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754921AbZIPV1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 17:27:41 -0400
Date: Wed, 16 Sep 2009 16:27:41 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Ashwin Ganti <ashwin.ganti@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH staging] p9auth: a few fixes
Message-ID: <20090916212741.GA19295@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. The memory into which we copy 'u1@u2' needs space for u1, @,
	u2, and a final \0 which strcat copies in.
2. Strsep changes the value of its first argument.  So use a
	temporary variable to pass to it, so we pass the original
	value to kfree!
3. Allocate an extra char to user_buf, because we need a trailing \0
	since we later kstrdup it.

I am about to send out an LTP testcase for this driver, but
in addition the correctness of the hashing can be verified as
follows:

 #include <stdio.h>
 #include <stdlib.h>
 #include <unistd.h>

int main(int argc, char *argv[])
{
        char in[41], out[20];
        unsigned int v;
        int i, ret;

        ret = read(STDIN_FILENO, in, 40);
        if (ret != 40)
                exit(1);
        in[40] = '\0';
        for (i = 0; i < 20; i++) {
                sscanf(&in[2*i], "%02x", &v);
                out[i] = v;
        }
        write(STDOUT_FILENO, out, 20);
}

as root, to test userid 501 switching to uid 0, choosing
'random' string 'ab':

echo -n "501@0" > plain
openssl sha1  -hmac 'ab' plain |awk '{ print $2 '} > dgst
./unhex < dgst > dgst.u
mknod /dev/caphash 504 0
mknod /dev/capuse 504 1
chmod ugo+w /dev/capuse
cat dgst.u > /dev/caphash

as uid 501,
echo "501@0@ab" > /dev/capuse
id -u  # should now show 0.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
---
 drivers/staging/p9auth/p9auth.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/p9auth/p9auth.c b/drivers/staging/p9auth/p9auth.c
index 9111dcb..8ccfff7 100644
--- a/drivers/staging/p9auth/p9auth.c
+++ b/drivers/staging/p9auth/p9auth.c
@@ -183,7 +183,7 @@ static ssize_t cap_write(struct file *filp, const char __user *buf,
 	user_buf_running = NULL;
 	hash_str = NULL;
 	node_ptr = kmalloc(sizeof(struct cap_node), GFP_KERNEL);
-	user_buf = kzalloc(count, GFP_KERNEL);
+	user_buf = kzalloc(count+1, GFP_KERNEL);
 	if (!node_ptr || !user_buf)
 		goto out;
 
@@ -207,6 +207,7 @@ static ssize_t cap_write(struct file *filp, const char __user *buf,
 		list_add(&(node_ptr->list), &(dev->head->list));
 		node_ptr = NULL;
 	} else {
+		char *tmpu;
 		if (!cap_devices[0].head ||
 				list_empty(&(cap_devices[0].head->list))) {
 			retval = -EINVAL;
@@ -218,10 +219,10 @@ static ssize_t cap_write(struct file *filp, const char __user *buf,
 		 * need to split it and hash 'user1@user2' using 'randomstring'
 		 * as the key.
 		 */
-		user_buf_running = kstrdup(user_buf, GFP_KERNEL);
-		source_user = strsep(&user_buf_running, "@");
-		target_user = strsep(&user_buf_running, "@");
-		rand_str = strsep(&user_buf_running, "@");
+		tmpu = user_buf_running = kstrdup(user_buf, GFP_KERNEL);
+		source_user = strsep(&tmpu, "@");
+		target_user = strsep(&tmpu, "@");
+		rand_str = tmpu;
 		if (!source_user || !target_user || !rand_str) {
 			retval = -EINVAL;
 			goto out;
@@ -229,7 +230,8 @@ static ssize_t cap_write(struct file *filp, const char __user *buf,
 
 		/* hash the string user1@user2 with rand_str as the key */
 		len = strlen(source_user) + strlen(target_user) + 1;
-		hash_str = kzalloc(len, GFP_KERNEL);
+		/* src, @, len, \0 */
+		hash_str = kzalloc(len+1, GFP_KERNEL);
 		strcat(hash_str, source_user);
 		strcat(hash_str, "@");
 		strcat(hash_str, target_user);
-- 
1.6.1

