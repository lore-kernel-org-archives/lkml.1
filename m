Return-Path: <linux-kernel-owner+w=401wt.eu-S964933AbZKYNhE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964933AbZKYNhE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 08:37:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964885AbZKYNg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 08:36:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50524 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934745AbZKYNgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 08:36:25 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 28/30] GFS2: Tag all metadata with jid
Date: Wed, 25 Nov 2009 14:31:00 +0000
Message-Id: <1259159462-28622-8-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1259159462-28622-7-git-send-email-swhiteho@redhat.com>
References: <1259158975-28499-20-git-send-email-swhiteho@redhat.com>
 <1259159462-28622-1-git-send-email-swhiteho@redhat.com>
 <1259159462-28622-2-git-send-email-swhiteho@redhat.com>
 <1259159462-28622-3-git-send-email-swhiteho@redhat.com>
 <1259159462-28622-4-git-send-email-swhiteho@redhat.com>
 <1259159462-28622-5-git-send-email-swhiteho@redhat.com>
 <1259159462-28622-6-git-send-email-swhiteho@redhat.com>
 <1259159462-28622-7-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two spare field in the header common to all GFS2
metadata. One is just the right size to fit a journal id
in it, and this patch updates the journal code so that each
time a metadata block is modified, we tag it with the journal
id of the node which is performing the modification.

The reason for this is that it should make it much easier to
debug issues which arise if we can tell which node was the
last to modify a particular metadata block.

Since the field is updated before the block is written into
the journal, each journal should only contain metadata which
is tagged with its own journal id. The one exception to this
is the journal header block, which might have a different node's
id in it, if that journal was recovered by another node in the
cluster.

Thus each journal will contain a record of which nodes recovered
it, via the journal header.

The other field in the metadata header could potentially be
used to hold information about what kind of operation was
performed, but for the time being we just zero it on each
transaction so that if we use it for that in future, we'll
know that the information (where it exists) is reliable.

I did consider using the other field to hold the journal
sequence number, however since in GFS2's journaling we write
the modified data into the journal and not the original
data, this gives no information as to what action caused the
modification, so I think we can probably come up with a better
use for those 64 bits in the future.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/inode.c             |    2 --
 fs/gfs2/log.c               |    2 ++
 fs/gfs2/lops.c              |    4 ++++
 fs/gfs2/recovery.c          |    2 ++
 include/linux/gfs2_ondisk.h |    6 +++++-
 5 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 6380cd9..26ba2a4 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -947,9 +947,7 @@ void gfs2_dinode_out(const struct gfs2_inode *ip, void *buf)
 
 	str->di_header.mh_magic = cpu_to_be32(GFS2_MAGIC);
 	str->di_header.mh_type = cpu_to_be32(GFS2_METATYPE_DI);
-	str->di_header.__pad0 = 0;
 	str->di_header.mh_format = cpu_to_be32(GFS2_FORMAT_DI);
-	str->di_header.__pad1 = 0;
 	str->di_num.no_addr = cpu_to_be64(ip->i_no_addr);
 	str->di_num.no_formal_ino = cpu_to_be64(ip->i_no_formal_ino);
 	str->di_mode = cpu_to_be32(ip->i_inode.i_mode);
diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 13c6237..4511b08 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -596,7 +596,9 @@ static void log_write_header(struct gfs2_sbd *sdp, u32 flags, int pull)
 	memset(lh, 0, sizeof(struct gfs2_log_header));
 	lh->lh_header.mh_magic = cpu_to_be32(GFS2_MAGIC);
 	lh->lh_header.mh_type = cpu_to_be32(GFS2_METATYPE_LH);
+	lh->lh_header.__pad0 = cpu_to_be64(0);
 	lh->lh_header.mh_format = cpu_to_be32(GFS2_FORMAT_LH);
+	lh->lh_header.mh_jid = cpu_to_be32(sdp->sd_jdesc->jd_jid);
 	lh->lh_sequence = cpu_to_be64(sdp->sd_log_sequence++);
 	lh->lh_flags = cpu_to_be32(flags);
 	lh->lh_tail = cpu_to_be32(tail);
diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 9969ff0..de97632 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -132,6 +132,7 @@ static struct buffer_head *gfs2_get_log_desc(struct gfs2_sbd *sdp, u32 ld_type)
 static void buf_lo_add(struct gfs2_sbd *sdp, struct gfs2_log_element *le)
 {
 	struct gfs2_bufdata *bd = container_of(le, struct gfs2_bufdata, bd_le);
+	struct gfs2_meta_header *mh;
 	struct gfs2_trans *tr;
 
 	lock_buffer(bd->bd_bh);
@@ -148,6 +149,9 @@ static void buf_lo_add(struct gfs2_sbd *sdp, struct gfs2_log_element *le)
 	set_bit(GLF_DIRTY, &bd->bd_gl->gl_flags);
 	gfs2_meta_check(sdp, bd->bd_bh);
 	gfs2_pin(sdp, bd->bd_bh);
+	mh = (struct gfs2_meta_header *)bd->bd_bh->b_data;
+	mh->__pad0 = cpu_to_be64(0);
+	mh->mh_jid = cpu_to_be32(sdp->sd_jdesc->jd_jid);
 	sdp->sd_log_num_buf++;
 	list_add(&le->le_list, &sdp->sd_log_le_buf);
 	tr->tr_num_buf_new++;
diff --git a/fs/gfs2/recovery.c b/fs/gfs2/recovery.c
index 59d2695..e594d9e 100644
--- a/fs/gfs2/recovery.c
+++ b/fs/gfs2/recovery.c
@@ -409,7 +409,9 @@ static int clean_journal(struct gfs2_jdesc *jd, struct gfs2_log_header_host *hea
 	memset(lh, 0, sizeof(struct gfs2_log_header));
 	lh->lh_header.mh_magic = cpu_to_be32(GFS2_MAGIC);
 	lh->lh_header.mh_type = cpu_to_be32(GFS2_METATYPE_LH);
+	lh->lh_header.__pad0 = cpu_to_be64(0);
 	lh->lh_header.mh_format = cpu_to_be32(GFS2_FORMAT_LH);
+	lh->lh_header.mh_jid = cpu_to_be32(sdp->sd_jdesc->jd_jid);
 	lh->lh_sequence = cpu_to_be64(head->lh_sequence + 1);
 	lh->lh_flags = cpu_to_be32(GFS2_LOG_HEAD_UNMOUNT);
 	lh->lh_blkno = cpu_to_be32(lblock);
diff --git a/include/linux/gfs2_ondisk.h b/include/linux/gfs2_ondisk.h
index b80c88d..81f90a5 100644
--- a/include/linux/gfs2_ondisk.h
+++ b/include/linux/gfs2_ondisk.h
@@ -81,7 +81,11 @@ struct gfs2_meta_header {
 	__be32 mh_type;
 	__be64 __pad0;		/* Was generation number in gfs1 */
 	__be32 mh_format;
-	__be32 __pad1;		/* Was incarnation number in gfs1 */
+	/* This union is to keep userspace happy */
+	union {
+		__be32 mh_jid;		/* Was incarnation number in gfs1 */
+		__be32 __pad1;
+	};
 };
 
 /*
-- 
1.6.2.5

