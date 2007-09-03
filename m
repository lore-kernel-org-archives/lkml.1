Return-Path: <linux-kernel-owner+w=401wt.eu-S1755360AbXICOYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360AbXICOYS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 10:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752094AbXICOYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 10:24:08 -0400
Received: from styx.suse.cz ([82.119.242.94]:56954 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752377AbXICOYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 10:24:06 -0400
Date: Mon, 3 Sep 2007 16:43:36 +0200
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Send quota messages via netlink
Message-ID: <20070903144336.GH7524@duck.suse.cz>
References: <20070828141318.GC5869@duck.suse.cz> <20070828215128.d8147a43.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="dDRMvlgZJXvWKvBx"
Content-Disposition: inline
In-Reply-To: <20070828215128.d8147a43.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue 28-08-07 21:51:28, Andrew Morton wrote:
> On Tue, 28 Aug 2007 16:13:18 +0200 Jan Kara <jack@suse.cz> wrote:
> 
> > +static void send_warning(const struct dquot *dquot, const char warntype)
> > +{
> > +	static unsigned long seq;
> > +	struct sk_buff *skb;
> > +	void *msg_head;
> > +	int ret;
> > +
> > +	skb = genlmsg_new(QUOTA_NL_MSG_SIZE, GFP_NOFS);
> > +	if (!skb) {
> > +		printk(KERN_ERR
> > +		  "VFS: Not enough memory to send quota warning.\n");
> > +		return;
> > +	}
> > +	msg_head = genlmsg_put(skb, 0, seq++, &quota_genl_family, 0, QUOTA_NL_C_WARNING);
> 
> The access to seq is racy, isn't it?
> 
> If so, that can be solved with a lock, or with atomic_add_return().
  Attached is an incremental patch solving the issues you've spotted.
Thanks for review.  The result of the discussion with namespace guys is
that the id used as an identify for filesystem operations should be fine.
If it will ever be something different than a number, we can change the
protocol which should be no problem...
  Also after some more reading, I've found out that we can even easily find
out, which attributes have been sent in the netlink message. So I don't see
a real reason for some versioning of the protocol - either the message has
all the attributes we are interested and then we report it, or it does not
and then we complain that tools are too old and don't understand the
protocol...

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs

--dDRMvlgZJXvWKvBx
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="quota-2.6.23-rc4-1-quota_messages_update.diff"

Add documentation of quota netlink interface, fix possible race in handling of
packet numbers, add a comment about GFP_NOFS allocation.

Signed-off-by: Jan Kara <jack@suse.cz>

diff -NrupX /home/jack/.kerndiffexclude linux-2.6.23-rc4-1-quota_messages_old/Documentation/filesystems/quota.txt linux-2.6.23-rc4-1-quota_messages/Documentation/filesystems/quota.txt
--- linux-2.6.23-rc4-1-quota_messages_old/Documentation/filesystems/quota.txt	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.23-rc4-1-quota_messages/Documentation/filesystems/quota.txt	2007-08-30 16:23:55.000000000 +0200
@@ -0,0 +1,59 @@
+
+Quota subsystem
+===============
+
+Quota subsystem allows system administrator to set limits on used space and
+number of used inodes (inode is a filesystem structure which is associated
+with each file or directory) for users and/or groups. For both used space and
+number of used inodes there are actually two limits. The first one is called
+softlimit and the second one hardlimit.  An user can never exceed a hardlimit
+for any resource. User is allowed to exceed softlimit but only for limited
+period of time. This period is called "grace period" or "grace time". When
+grace time is over, user is not able to allocate more space/inodes until he
+frees enough of them to get below softlimit.
+
+Quota limits (and amount of grace time) are set independently for each
+filesystem.
+
+For more details about quota design, see the documentation in quota-tools package
+(http://sourceforge.net/projects/linuxquota).
+
+Quota netlink interface
+=======================
+When user exceeds a softlimit, runs out of grace time or reaches hardlimit,
+quota subsystem traditionally printed a message to the controlling terminal of
+the process which caused the excess. This method has the disadvantage that
+when user is using a graphical desktop he usually cannot see the message.
+Thus quota netlink interface has been designed to pass information about
+the above events to userspace. There they can be captured by an application
+and processed accordingly.
+
+The interface uses generic netlink framework (see
+http://lwn.net/Articles/208755/ and http://people.suug.ch/~tgr/libnl/ for more
+details about this layer). The name of the quota generic netlink interface
+is "VFS_DQUOT". Definitions of constants below are in <linux/quota.h>.
+  Currently, the interface supports only one message type QUOTA_NL_C_WARNING.
+This command is used to send a notification about any of the above mentioned
+events. Each message has six attributes. These are (type of the argument is
+in braces):
+        QUOTA_NL_A_QTYPE (u32)
+	  - type of quota beging exceeded (one of USRQUOTA, GRPQUOTA)
+        QUOTA_NL_A_EXCESS_ID (u64)
+	  - UID/GID (depends on quota type) of user / group whose limit
+	    is being exceeded.
+        QUOTA_NL_A_CAUSED_ID (u64)
+	  - UID of a user who caused the event
+        QUOTA_NL_A_WARNING (u32)
+	  - what kind of limit is exceeded:
+		QUOTA_NL_IHARDWARN - inode hardlimit
+		QUOTA_NL_ISOFTLONGWARN - inode softlimit is exceeded longer
+		  than given grace period
+		QUOTA_NL_ISOFTWARN - inode softlimit
+		QUOTA_NL_BHARDWARN - space (block) hardlimit
+		QUOTA_NL_BSOFTLONGWARN - space (block) softlimit is exceeded
+		  longer than given grace period.
+		QUOTA_NL_BSOFTWARN - space (block) softlimit
+        QUOTA_NL_A_DEV_MAJOR (u32)
+	  - major number of a device with the affected filesystem
+        QUOTA_NL_A_DEV_MINOR (u32)
+	  - minor number of a device with the affected filesystem
diff -NrupX /home/jack/.kerndiffexclude linux-2.6.23-rc4-1-quota_messages_old/fs/dquot.c linux-2.6.23-rc4-1-quota_messages/fs/dquot.c
--- linux-2.6.23-rc4-1-quota_messages_old/fs/dquot.c	2007-09-03 16:25:21.000000000 +0200
+++ linux-2.6.23-rc4-1-quota_messages/fs/dquot.c	2007-08-29 19:42:23.000000000 +0200
@@ -910,18 +910,22 @@ static struct genl_family quota_genl_fam
 /* Send warning to userspace about user which exceeded quota */
 static void send_warning(const struct dquot *dquot, const char warntype)
 {
-	static unsigned long seq;
+	static atomic_t seq;
 	struct sk_buff *skb;
 	void *msg_head;
 	int ret;
 
+	/* We have to allocate using GFP_NOFS as we are called from a
+	 * filesystem performing write and thus further recursion into
+	 * the fs to free some data could cause deadlocks. */
 	skb = genlmsg_new(QUOTA_NL_MSG_SIZE, GFP_NOFS);
 	if (!skb) {
 		printk(KERN_ERR
 		  "VFS: Not enough memory to send quota warning.\n");
 		return;
 	}
-	msg_head = genlmsg_put(skb, 0, seq++, &quota_genl_family, 0, QUOTA_NL_C_WARNING);
+	msg_head = genlmsg_put(skb, 0, atomic_add_return(1, &seq),
+			&quota_genl_family, 0, QUOTA_NL_C_WARNING);
 	if (!msg_head) {
 		printk(KERN_ERR
 		  "VFS: Cannot store netlink header in quota warning.\n");

--dDRMvlgZJXvWKvBx--
