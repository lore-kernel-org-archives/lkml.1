Return-Path: <linux-kernel-owner+w=401wt.eu-S1752599AbYFCJDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599AbYFCJDc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 05:03:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753274AbYFCJDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 05:03:22 -0400
Received: from styx.suse.cz ([82.119.242.94]:56148 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751996AbYFCJDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 05:03:21 -0400
Date: Tue, 3 Jun 2008 11:03:17 +0200
From: Jan Kara <jack@suse.cz>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] quota: Remove use of info_any_dirty()
Message-ID: <20080603090317.GC17936@duck.suse.cz>
References: <12124266712214-git-send-email-jack@suse.cz> <12124266711334-git-send-email-jack@suse.cz> <12124266712838-git-send-email-jack@suse.cz> <19f34abd0806021041m20858599x8d35c9684efe8977@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0806021041m20858599x8d35c9684efe8977@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

  Thanks for reading the patches.

> On Mon, Jun 2, 2008 at 7:11 PM, Jan Kara <jack@suse.cz> wrote:
> > Since there is only a single place which uses info_any_dirty() and that
> > is a trivial macro, just remove the use of this macro completely.
> >
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/quota.c            |    7 +++++--
> >  include/linux/quota.h |    2 --
> >  2 files changed, 5 insertions(+), 4 deletions(-)
> >
> > diff --git a/fs/quota.c b/fs/quota.c
> > index db1cc9f..f0702f4 100644
> > --- a/fs/quota.c
> > +++ b/fs/quota.c
> > @@ -199,8 +199,11 @@ restart:
> >        list_for_each_entry(sb, &super_blocks, s_list) {
> >                /* This test just improves performance so it needn't be reliable... */
> >                for (cnt = 0, dirty = 0; cnt < MAXQUOTAS; cnt++)
> > -                       if ((type == cnt || type == -1) && sb_has_quota_enabled(sb, cnt)
> > -                           && info_any_dirty(&sb_dqopt(sb)->info[cnt]))
> > +                       if ((type == cnt || type == -1)
> > +                           && sb_has_quota_enabled(sb, cnt)
> > +                           && (info_dirty(&sb_dqopt(sb)->info[cnt])
> > +                               || !list_empty(&sb_dqopt(sb)->
> > +                                       info[cnt].dqi_dirty_list)))
> >                                dirty = 1;
> 
> This is really too hideous in my opinion and looks like a candidate
> for its own static inline function.
> 
> Or you can try to rewrite the boolean expression on multiple lines
> using continue, something like:
> 
> -               for (cnt = 0, dirty = 0; cnt < MAXQUOTAS; cnt++)
> -                       if ((type == cnt || type == -1) && sb_has_quota_enabled(
> -                           && info_any_dirty(&sb_dqopt(sb)->info[cnt]))
> -                               dirty = 1;
> +               for (cnt = 0, dirty = 0; cnt < MAXQUOTAS; cnt++) {
> +                       if (type != cnt && type != -1)
> +                               continue;
> +                       if (!sb_has_quota_enabled(sb, cnt))
> +                               continue;
> +                       if (!info_any_dirty(&sb_dqopt(sb)->info[cnt]))
> +                               continue;
> +                       dirty = 1;
> +               }
> 
> (This uses the original macro, I know. How about moving that from the
> header to a new inline function just above this function?)
  I like this one better. I've rewritten it and you don't even need the
'dirty' variable. The resulting patch is below.

> PS: This is a really good clean-up effort. Good work!
  Thanks. I'm just cleaning up my own mess... ;)

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
---

>From 7509c2a0cf5d64687b1b68bde5ec2f7cb625688e Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Mon, 2 Jun 2008 18:27:15 +0200
Subject: [PATCH] quota: Cleanup loop in sync_dquots()

Make loop in sync_dquots() checking whether there's something to write
more readable, remove useless variable and macro info_any_dirty()
which is used only in this place.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/quota.c            |   18 ++++++++++++------
 include/linux/quota.h |    2 --
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/fs/quota.c b/fs/quota.c
index db1cc9f..7f4386e 100644
--- a/fs/quota.c
+++ b/fs/quota.c
@@ -186,7 +186,7 @@ static void quota_sync_sb(struct super_block *sb, int type)
 
 void sync_dquots(struct super_block *sb, int type)
 {
-	int cnt, dirty;
+	int cnt;
 
 	if (sb) {
 		if (sb->s_qcop->quota_sync)
@@ -198,11 +198,17 @@ void sync_dquots(struct super_block *sb, int type)
 restart:
 	list_for_each_entry(sb, &super_blocks, s_list) {
 		/* This test just improves performance so it needn't be reliable... */
-		for (cnt = 0, dirty = 0; cnt < MAXQUOTAS; cnt++)
-			if ((type == cnt || type == -1) && sb_has_quota_enabled(sb, cnt)
-			    && info_any_dirty(&sb_dqopt(sb)->info[cnt]))
-				dirty = 1;
-		if (!dirty)
+		for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
+			if (type != -1 && type != cnt)
+				continue;
+			if (!sb_has_quota_enabled(sb, cnt))
+				continue;
+			if (!info_dirty(&sb_dqopt(sb)->info[cnt]) &&
+			    list_empty(&sb_dqopt(sb)->info[cnt].dqi_dirty_list))
+				continue;
+			break;
+		}
+		if (cnt == MAXQUOTAS)
 			continue;
 		sb->s_count++;
 		spin_unlock(&sb_lock);
diff --git a/include/linux/quota.h b/include/linux/quota.h
index dcddfb2..6f1d97d 100644
--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -224,8 +224,6 @@ struct super_block;
 
 extern void mark_info_dirty(struct super_block *sb, int type);
 #define info_dirty(info) test_bit(DQF_INFO_DIRTY_B, &(info)->dqi_flags)
-#define info_any_dquot_dirty(info) (!list_empty(&(info)->dqi_dirty_list))
-#define info_any_dirty(info) (info_dirty(info) || info_any_dquot_dirty(info))
 
 #define sb_dqopt(sb) (&(sb)->s_dquot)
 #define sb_dqinfo(sb, type) (sb_dqopt(sb)->info+(type))
-- 
1.5.2.4

