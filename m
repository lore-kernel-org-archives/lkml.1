Return-Path: <linux-kernel-owner+w=401wt.eu-S1162232AbXECSci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162232AbXECSci (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 14:32:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1162233AbXECSci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 14:32:38 -0400
Received: from ms-smtp-01.southeast.rr.com ([24.25.9.100]:63757 "EHLO
	ms-smtp-01.southeast.rr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1162232AbXECSch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 14:32:37 -0400
Date: Thu, 3 May 2007 14:32:33 -0400
From: Jeff Layton <jlayton@redhat.com>
To: linux-cifs-client@lists.samba.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] CIFS: make sec=none force an anonymous mount
Message-ID: <20070503183231.GA1706@salusa.poochiereds.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We had a customer report that attempting to make CIFS mount with a null
username (i.e. doing an anonymous mount) doesn't work. Looking through the
code, it looks like CIFS expects a NULL username from userspace in order
to trigger an anonymous mount. The mount.cifs code doesn't seem to ever
pass a null username to the kernel, however.

It looks also like the kernel can take a sec=none option, but it only seems
to look at it if the username is already NULL. This seems redundant and
effectively makes sec=none useless.

The following patch makes sec=none force an anonymous mount. I've briefly
tested it and it seems to work. I suppose we could alternately do some
stuff in userspace to make mount.cifs force a null username instead, but this
seems more straightforward to me.

Signed-off-by: Jeff Layton <jlayton@redhat.com>

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index cf40e24..330e290 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1721,12 +1721,13 @@ cifs_mount(struct super_block *sb, struct cifs_sb_info *cifs_sb,
 		return -EINVAL;
 	}
 
-	if (volume_info.username) {
+	if (volume_info.nullauth) {
+		cFYI(1,("null user"));
+		volume_info.username = NULL;
+	} else if (volume_info.username) {
 		/* BB fixme parse for domain name here */
 		cFYI(1, ("Username: %s ", volume_info.username));
 
-	} else if (volume_info.nullauth) {
-		cFYI(1,("null user"));
 	} else {
 		cifserror("No username specified");
         /* In userspace mount helper we can get user name from alternate
