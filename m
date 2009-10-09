Return-Path: <linux-kernel-owner+w=401wt.eu-S1761338AbZJISb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761338AbZJISb5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 14:31:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761328AbZJISb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 14:31:56 -0400
Received: from kroah.org ([198.145.64.141]:35337 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761327AbZJISby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 14:31:54 -0400
Subject: patch staging-p9auth-a-few-fixes.patch added to gregkh-2.6 tree
To: serue@us.ibm.com, ashwin.ganti@gmail.com, gregkh@suse.de,
       linux-kernel@vger.kernel.org
From: <gregkh@suse.de>
Date: Fri, 09 Oct 2009 11:28:15 -0700
In-Reply-To: <20090916212741.GA19295@us.ibm.com>
Message-ID: <12551128953175@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Subject: Staging: p9auth: a few fixes

to my gregkh-2.6 tree.  Its filename is

    staging-p9auth-a-few-fixes.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From serue@us.ibm.com  Fri Oct  9 10:37:17 2009
From: "Serge E. Hallyn" <serue@us.ibm.com>
Date: Wed, 16 Sep 2009 16:27:41 -0500
Subject: Staging: p9auth: a few fixes
To: Ashwin Ganti <ashwin.ganti@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: lkml <linux-kernel@vger.kernel.org>
Message-ID: <20090916212741.GA19295@us.ibm.com>
Content-Disposition: inline


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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/p9auth/p9auth.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/drivers/staging/p9auth/p9auth.c
+++ b/drivers/staging/p9auth/p9auth.c
@@ -183,7 +183,7 @@ static ssize_t cap_write(struct file *fi
 	user_buf_running = NULL;
 	hash_str = NULL;
 	node_ptr = kmalloc(sizeof(struct cap_node), GFP_KERNEL);
-	user_buf = kzalloc(count, GFP_KERNEL);
+	user_buf = kzalloc(count+1, GFP_KERNEL);
 	if (!node_ptr || !user_buf)
 		goto out;
 
@@ -207,6 +207,7 @@ static ssize_t cap_write(struct file *fi
 		list_add(&(node_ptr->list), &(dev->head->list));
 		node_ptr = NULL;
 	} else {
+		char *tmpu;
 		if (!cap_devices[0].head ||
 				list_empty(&(cap_devices[0].head->list))) {
 			retval = -EINVAL;
@@ -218,10 +219,10 @@ static ssize_t cap_write(struct file *fi
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
@@ -229,7 +230,8 @@ static ssize_t cap_write(struct file *fi
 
 		/* hash the string user1@user2 with rand_str as the key */
 		len = strlen(source_user) + strlen(target_user) + 1;
-		hash_str = kzalloc(len, GFP_KERNEL);
+		/* src, @, len, \0 */
+		hash_str = kzalloc(len+1, GFP_KERNEL);
 		strcat(hash_str, source_user);
 		strcat(hash_str, "@");
 		strcat(hash_str, target_user);

