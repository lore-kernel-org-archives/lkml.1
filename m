Return-Path: <linux-kernel-owner+w=401wt.eu-S1756403AbZBYRsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403AbZBYRsU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 12:48:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752610AbZBYRsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 12:48:07 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:33115 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589AbZBYRsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 12:48:03 -0500
Date: Wed, 25 Feb 2009 11:47:47 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mmotm 2009-02-24-16-23 uploaded (proc_net & namespaces)
Message-ID: <20090225174747.GA19750@us.ibm.com>
References: <200902250041.n1P0fe4A024914@imap1.linux-foundation.org> <49A5778E.1000204@oracle.com> <20090225171748.GC14463@us.ibm.com> <49A57FA7.407@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A57FA7.407@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Randy Dunlap (randy.dunlap@oracle.com):
> Serge E. Hallyn wrote:
> > Quoting Randy Dunlap (randy.dunlap@oracle.com):
> >> akpm@linux-foundation.org wrote:
> >>> The mm-of-the-moment snapshot 2009-02-24-16-23 has been uploaded to
> >>>
> >>>    http://userweb.kernel.org/~akpm/mmotm/
> >>>
> >>> and will soon be available at
> >>>
> >>>    git://git.zen-sources.org/zen/mmotm.git
> >>>
> >>> It contains the following patches against 2.6.29-rc6:
> >> namespaces-move-proc_net_get_sb-to-a-generic-fs-superc-helper.patch,
> >> when CONFIG_NAMESPACES=n:
> >>
> >> proc_net.c:(.text+0x4255c): undefined reference to `get_sb_ns'
> >>
> >>
> >> config attached.
> > 
> > Thanks, Randy.  Does the following fix it?
> > 
> > (Sorry, it's a misleading patch, and maybe it would turn out more
> > readable if I moved get_sb_ns under instead of above the
> > CONFIG_BLOCK ifdef...  But all I'm doing is what the subject says,
> > plus adding an EXPORT_SYMBOL which may be debatable, but is in
> > keeping with other get_sb_*'s.)
> 
> That causes problems in fs/super.c:
> 
> fs/super.c: In function 'get_sb_ns':
> fs/super.c:773: error: 'ns_test_super' undeclared (first use in this function)

(!) I appended the wrong version.


>From 9f5d2c853f4b3e50621591856c11a565a733fb3d Mon Sep 17 00:00:00 2001
From: Serge E. Hallyn <serue@us.ibm.com>
Date: Wed, 25 Feb 2009 09:14:03 -0800
Subject: [PATCH 1/1] namespaces: get_sb_ns does not require CONFIG_BLOCK

So move it outside of the CONFIG_BLOCK ifdef in fs/super.c.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
---
 fs/super.c |   28 +++++++++++++++-------------
 1 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 1a37b58..5182044 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -761,19 +761,6 @@ void kill_litter_super(struct super_block *sb)
 
 EXPORT_SYMBOL(kill_litter_super);
 
-#ifdef CONFIG_BLOCK
-static int set_bdev_super(struct super_block *s, void *data)
-{
-	s->s_bdev = data;
-	s->s_dev = s->s_bdev->bd_dev;
-	return 0;
-}
-
-static int test_bdev_super(struct super_block *s, void *data)
-{
-	return (void *)s->s_bdev == data;
-}
-
 static int ns_test_super(struct super_block *sb, void *data)
 {
 	return sb->s_fs_info == data;
@@ -812,6 +799,21 @@ int get_sb_ns(struct file_system_type *fs_type, int flags, void *data,
 	return 0;
 }
 
+EXPORT_SYMBOL(get_sb_ns);
+
+#ifdef CONFIG_BLOCK
+static int set_bdev_super(struct super_block *s, void *data)
+{
+	s->s_bdev = data;
+	s->s_dev = s->s_bdev->bd_dev;
+	return 0;
+}
+
+static int test_bdev_super(struct super_block *s, void *data)
+{
+	return (void *)s->s_bdev == data;
+}
+
 int get_sb_bdev(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *data,
 	int (*fill_super)(struct super_block *, void *, int),
-- 
1.5.4.3

