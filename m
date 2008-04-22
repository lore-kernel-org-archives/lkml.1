Return-Path: <linux-kernel-owner+w=401wt.eu-S1761516AbYDVVMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761516AbYDVVMi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 17:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756175AbYDVVMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 17:12:30 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:36452 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755917AbYDVVM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 17:12:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:user-agent:mime-version:content-type:from;
        b=HArmZ/rXUyXCMz+/d1AfP/eL5/ngCS8ijdEC/evd9r2W4ue2slBlqD5XAjaOJKUKQ4O6IO9Uag9HPhkYZpam/BG9kF7Zf/RPMPGtdyz3mS1zhjAgHxhF9oSX4Cmxv21GS+5nNiMVjkNFWuAjCGHtPJGSPHuuVIA/hd0/M0v1Yl8=
Date: Tue, 22 Apr 2008 23:12:27 +0200 (CEST)
To: Roman Zippel <zippel@linux-m68k.org>
cc: linux-kernel@vger.kernel.org, Jesper Juhl <jesper.juhl@gmail.com>
Subject: [PATCH] hfs: if match_strdup() fails to allocate memory in
 parse_options(), don't blow up the kernel.
Message-ID: <alpine.LNX.1.00.0804222309250.14359@dragon.funnycrock.com>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
From: Jesper Juhl <jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Juhl <jesper.juhl@gmail.com>

The Coverity checker spotted that we don't check the return value of 
match_strdup() in fs/hfs/super.c::parse_options().
This is bad since match_strdup() does a memory allocation internally 
which can fail. If it does fail it'll return NULL and in that case 
we'll pass the NULL pointer on to load_nls() which will eventually 
dereference it - Boom!
Much better to check the return value, fail gracefully and log an 
error message if this happens.
This happens in two different spots. I've made the error logged in 
each location unique so that it'll be obvious in bug reports later 
exactely which one of the two spots got hit (always nice to have 
grep'able error messages that point to a unique location in the 
source).


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 super.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/hfs/super.c b/fs/hfs/super.c
index 32de44e..221e314 100644
--- a/fs/hfs/super.c
+++ b/fs/hfs/super.c
@@ -297,6 +297,10 @@ static int parse_options(char *options, struct hfs_sb_info *hsb)
 				return 0;
 			}
 			p = match_strdup(&args[0]);
+			if (!p) {
+				printk(KERN_ERR "hfs: mem alloc failed in match_strdup()\n");
+				return 0;
+			}
 			hsb->nls_disk = load_nls(p);
 			if (!hsb->nls_disk) {
 				printk(KERN_ERR "hfs: unable to load codepage \"%s\"\n", p);
@@ -311,6 +315,10 @@ static int parse_options(char *options, struct hfs_sb_info *hsb)
 				return 0;
 			}
 			p = match_strdup(&args[0]);
+			if (!p) {
+				printk(KERN_ERR "hfs: memory allocation failed in match_strdup()\n");
+				return 0;
+			}
 			hsb->nls_io = load_nls(p);
 			if (!hsb->nls_io) {
 				printk(KERN_ERR "hfs: unable to load iocharset \"%s\"\n", p);


