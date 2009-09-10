Return-Path: <linux-kernel-owner+w=401wt.eu-S1755468AbZIJK3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468AbZIJK3p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 06:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755451AbZIJK3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 06:29:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24147 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755437AbZIJK3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 06:29:41 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 02/15] GFS2: Add some more info to uevents
Date: Thu, 10 Sep 2009 12:27:54 +0100
Message-Id: <1252582087-10007-3-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1252582087-10007-2-git-send-email-swhiteho@redhat.com>
References: <1252582087-10007-1-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-2-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With each uevent, we now always include the journal ID. We
can't call it JID since that is already in use by some of
the individual events relating to recovery, so we use
JOURNALID instead. We don't send the JOURNALID for spectator
mounts, since there isn't one.

Also the ADD event now has both RDONLY and SPECTATOR information
to match that of the ONLINE event.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/sys.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index a7cbfbd..dda4bf1 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -519,7 +519,14 @@ static struct attribute_group lock_module_group = {
 
 int gfs2_sys_fs_add(struct gfs2_sbd *sdp)
 {
+	struct super_block *sb = sdp->sd_vfs;
 	int error;
+	char ro[20];
+	char spectator[20];
+	char *envp[] = { ro, spectator, NULL };
+
+	sprintf(ro, "RDONLY=%d", (sb->s_flags & MS_RDONLY) ? 1 : 0);
+	sprintf(spectator, "SPECTATOR=%d", sdp->sd_args.ar_spectator ? 1 : 0);
 
 	sdp->sd_kobj.kset = gfs2_kset;
 	error = kobject_init_and_add(&sdp->sd_kobj, &gfs2_ktype, NULL,
@@ -535,7 +542,7 @@ int gfs2_sys_fs_add(struct gfs2_sbd *sdp)
 	if (error)
 		goto fail_tune;
 
-	kobject_uevent(&sdp->sd_kobj, KOBJ_ADD);
+	kobject_uevent_env(&sdp->sd_kobj, KOBJ_ADD, envp);
 	return 0;
 
 fail_tune:
@@ -554,7 +561,6 @@ void gfs2_sys_fs_del(struct gfs2_sbd *sdp)
 	kobject_put(&sdp->sd_kobj);
 }
 
-
 static int gfs2_uevent(struct kset *kset, struct kobject *kobj,
 		       struct kobj_uevent_env *env)
 {
@@ -563,6 +569,8 @@ static int gfs2_uevent(struct kset *kset, struct kobject *kobj,
 
 	add_uevent_var(env, "LOCKTABLE=%s", sdp->sd_table_name);
 	add_uevent_var(env, "LOCKPROTO=%s", sdp->sd_proto_name);
+	if (!sdp->sd_args.ar_spectator)
+		add_uevent_var(env, "JOURNALID=%u", sdp->sd_lockstruct.ls_jid);
 	if (gfs2_uuid_valid(uuid)) {
 		add_uevent_var(env, "UUID=%02X%02X%02X%02X-%02X%02X-%02X%02X-"
 			       "%02X%02X-%02X%02X%02X%02X%02X%02X",
@@ -578,7 +586,6 @@ static struct kset_uevent_ops gfs2_uevent_ops = {
 	.uevent = gfs2_uevent,
 };
 
-
 int gfs2_sys_init(void)
 {
 	gfs2_kset = kset_create_and_add("gfs2", &gfs2_uevent_ops, fs_kobj);
-- 
1.6.2.5

