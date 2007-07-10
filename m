Return-Path: <linux-kernel-owner+w=401wt.eu-S1762750AbXGJC22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762750AbXGJC22 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 22:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762630AbXGJC1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 22:27:42 -0400
Received: from mx1.suse.de ([195.135.220.2]:38209 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756481AbXGJC1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 22:27:41 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 10 Jul 2007 12:27:37 +1000
Message-Id: <1070710022737.13509@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: "J. Bruce Fields" <bfields@citi.umich.edu>
Cc: J "." Bruce Fields <bfields@citi.umich.edu>
Cc: Neil Brown <neilb@suse.de>
Subject: [PATCH 013 of 20] knfsd: nfsd: factor out code from show_expflags
References: <20070710121949.12548.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: J. Bruce Fields <bfields@citi.umich.edu>

Factor out some code to be shared by secinfo display code.  Remove some
unnecessary conditional printing of commas where we know the condition
is true.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./fs/nfsd/export.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff .prev/fs/nfsd/export.c ./fs/nfsd/export.c
--- .prev/fs/nfsd/export.c	2007-07-10 11:39:34.000000000 +1000
+++ ./fs/nfsd/export.c	2007-07-10 11:46:05.000000000 +1000
@@ -1453,28 +1453,35 @@ static struct flags {
 	{ 0, {"", ""}}
 };
 
-static void exp_flags(struct seq_file *m, int flag, int fsid,
-		uid_t anonu, uid_t anong, struct nfsd4_fs_locations *fsloc)
+static void show_expflags(struct seq_file *m, int flags, int mask)
 {
-	int first = 0;
 	struct flags *flg;
+	int state, first = 0;
 
 	for (flg = expflags; flg->flag; flg++) {
-		int state = (flg->flag & flag)?0:1;
+		if (flg->flag & ~mask)
+			continue;
+		state = (flg->flag & flags) ? 0 : 1;
 		if (*flg->name[state])
 			seq_printf(m, "%s%s", first++?",":"", flg->name[state]);
 	}
+}
+
+static void exp_flags(struct seq_file *m, int flag, int fsid,
+		uid_t anonu, uid_t anong, struct nfsd4_fs_locations *fsloc)
+{
+	show_expflags(m, flag, NFSEXP_ALLFLAGS);
 	if (flag & NFSEXP_FSID)
-		seq_printf(m, "%sfsid=%d", first++?",":"", fsid);
+		seq_printf(m, ",fsid=%d", fsid);
 	if (anonu != (uid_t)-2 && anonu != (0x10000-2))
-		seq_printf(m, "%sanonuid=%d", first++?",":"", anonu);
+		seq_printf(m, ",sanonuid=%d", anonu);
 	if (anong != (gid_t)-2 && anong != (0x10000-2))
-		seq_printf(m, "%sanongid=%d", first++?",":"", anong);
+		seq_printf(m, ",sanongid=%d", anong);
 	if (fsloc && fsloc->locations_count > 0) {
 		char *loctype = (fsloc->migrated) ? "refer" : "replicas";
 		int i;
 
-		seq_printf(m, "%s%s=", first++?",":"", loctype);
+		seq_printf(m, ",%s=", loctype);
 		seq_escape(m, fsloc->locations[0].path, ",;@ \t\n\\");
 		seq_putc(m, '@');
 		seq_escape(m, fsloc->locations[0].hosts, ",;@ \t\n\\");
