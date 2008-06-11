Return-Path: <linux-kernel-owner+w=401wt.eu-S1758376AbYFKUD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758376AbYFKUD4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 16:03:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751323AbYFKUDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 16:03:48 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:2750 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbYFKUDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 16:03:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:user-agent:from;
        b=AJr7Equg632kyhWatXtRDF6tRReGIYHxww3CMvqxxD+xH3nNxhy/dRFtXaXP1fnJWH
         X7DI0N8it96VN6CCKY26MTFN3eA9gAcm+jqc11XgJqloeC/DNDrSJWk/w40NLA/zdx1u
         YI+iQ2RRJKQugwgXFpzb3brfMFrolsEHFJGI4=
Date: Wed, 11 Jun 2008 22:03:42 +0200
To: arjenpool@gmail.com, Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: Cant compile 2.6.26-rc5-mm2 kernel
Message-ID: <20080611200342.GA24766@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806112008.56478.arjenpool@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks for the report.

On Wed, Jun 11, 2008 at 8:08 PM,  <arjenpool@gmail.com> wrote:
> Today i`ve tried to compile a linux-2.6.26-rc5-mm2 kernel obtained with the
> Ketchup tool.
>
> It got halfway interupted with the following error messages:
>
> CC [M] fs/xfs/support/debug.o
>  CC [M] fs/xfs/support/uuid.o
>  LD [M] fs/xfs/xfs.o
>  CC fs/quota.o
> fs/quota.c: In function 'quota_sync_sb':
> fs/quota.c:174: error: implicit declaration of function 'sb_dqopt'

It seems that this definition is needed regardless of CONFIG_QUOTA.

I'm attaching a patch that fixes it for me. I'm not 100% it's the right
thing.


Vegard


>From 5fc276129d8a3e2a70980104cc374bdc0d61afa3 Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Wed, 11 Jun 2008 21:58:32 +0200
Subject: [PATCH] fs: fix build breakage

The patch

| commit 9651a656c9fbf3e8183b5eb21740edc1eb9ca16b
| Author: Jan Kara <jack@suse.cz>
| Date:   Thu Jun 5 19:53:42 2008 +0000
|
|     quota-move-function-macros-from-quotah-to-quotaopsh
|

causes the build to break for CONFIG_QUOTA=n.

Reported-by: Arjen Pool <arjenpool@gmail.com>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 include/linux/quotaops.h |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
index 5644280..eb575d1 100644
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -14,6 +14,11 @@
 
 #include <linux/fs.h>
 
+static inline struct quota_info *sb_dqopt(struct super_block *sb)
+{
+	return &sb->s_dquot;
+}
+
 #if defined(CONFIG_QUOTA)
 
 /*
@@ -52,11 +57,6 @@ void vfs_dq_drop(struct inode *inode);
 int vfs_dq_transfer(struct inode *inode, struct iattr *iattr);
 int vfs_dq_quota_on_remount(struct super_block *sb);
 
-static inline struct quota_info *sb_dqopt(struct super_block *sb)
-{
-	return &sb->s_dquot;
-}
-
 static inline struct mem_dqinfo *sb_dqinfo(struct super_block *sb, int type)
 {
 	return sb_dqopt(sb)->info + type;
-- 
1.5.4.1

