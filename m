Return-Path: <linux-kernel-owner+w=401wt.eu-S935760AbZAOWk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935760AbZAOWk0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 17:40:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933513AbZAOWDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 17:03:50 -0500
Received: from kroah.org ([198.145.64.141]:38948 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933992AbZAOWDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 17:03:41 -0500
Date: Thu, 15 Jan 2009 14:01:32 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Tyler Hicks <tyhicks@linux.vnet.ibm.com>,
       Dustin Kirkland <kirkland@canonical.com>,
       ecryptfs-devel@lists.launchpad.net, Duane Griffin <duaneg@dghda.com>,
       Michael Halcrow <mhalcrow@us.ibm.com>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: [patch 66/85] eCryptfs: check readlink result was not an error
	before using it
Message-ID: <20090115220132.GO17227@kroah.com>
References: <20090115215237.906089480@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ecryptfs-check-readlink-result-was-not-an-error-before-using-it.patch"
In-Reply-To: <20090115215812.GA17227@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Duane Griffin <duaneg@dghda.com>

commit a17d5232de7b53d34229de79ec22f4bb04adb7e4 upstream.

The result from readlink is being used to index into the link name
buffer without checking whether it is a valid length. If readlink
returns an error this will fault or cause memory corruption.

Cc: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Cc: Dustin Kirkland <kirkland@canonical.com>
Cc: ecryptfs-devel@lists.launchpad.net
Signed-off-by: Duane Griffin <duaneg@dghda.com>
Acked-by: Michael Halcrow <mhalcrow@us.ibm.com>
Acked-by: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ecryptfs/inode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -673,10 +673,11 @@ static void *ecryptfs_follow_link(struct
 	ecryptfs_printk(KERN_DEBUG, "Calling readlink w/ "
 			"dentry->d_name.name = [%s]\n", dentry->d_name.name);
 	rc = dentry->d_inode->i_op->readlink(dentry, (char __user *)buf, len);
-	buf[rc] = '\0';
 	set_fs(old_fs);
 	if (rc < 0)
 		goto out_free;
+	else
+		buf[rc] = '\0';
 	rc = 0;
 	nd_set_link(nd, buf);
 	goto out;

