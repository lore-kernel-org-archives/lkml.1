Return-Path: <linux-kernel-owner+w=401wt.eu-S1762689AbXGJC2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762689AbXGJC2n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 22:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762665AbXGJC1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 22:27:48 -0400
Received: from ns.suse.de ([195.135.220.2]:38225 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762657AbXGJC1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 22:27:47 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 10 Jul 2007 12:27:43 +1000
Message-Id: <1070710022743.13524@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: "J. Bruce Fields" <bfields@citi.umich.edu>
Cc: J "." Bruce Fields <bfields@citi.umich.edu>
Cc: Neil Brown <neilb@suse.de>
Subject: [PATCH 014 of 20] knfsd: nfsd: display export secinfo information
References: <20070710121949.12548.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: J. Bruce Fields <bfields@citi.umich.edu>

Add secinfo information to the display in proc/net/sunrpc/nfsd.export/content.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./fs/nfsd/export.c |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff .prev/fs/nfsd/export.c ./fs/nfsd/export.c
--- .prev/fs/nfsd/export.c	2007-07-10 11:46:05.000000000 +1000
+++ ./fs/nfsd/export.c	2007-07-10 11:48:23.000000000 +1000
@@ -641,6 +641,7 @@ static int svc_export_parse(struct cache
 
 static void exp_flags(struct seq_file *m, int flag, int fsid,
 		uid_t anonu, uid_t anong, struct nfsd4_fs_locations *fslocs);
+static void show_secinfo(struct seq_file *m, struct svc_export *exp);
 
 static int svc_export_show(struct seq_file *m,
 			   struct cache_detail *cd,
@@ -670,6 +671,7 @@ static int svc_export_show(struct seq_fi
 				seq_printf(m, "%02x", exp->ex_uuid[i]);
 			}
 		}
+		show_secinfo(m, exp);
 	}
 	seq_puts(m, ")\n");
 	return 0;
@@ -1467,6 +1469,33 @@ static void show_expflags(struct seq_fil
 	}
 }
 
+static void show_secinfo_flags(struct seq_file *m, int flags)
+{
+	seq_printf(m, ",");
+	show_expflags(m, flags, NFSEXP_SECINFO_FLAGS);
+}
+
+static void show_secinfo(struct seq_file *m, struct svc_export *exp)
+{
+	struct exp_flavor_info *f;
+	struct exp_flavor_info *end = exp->ex_flavors + exp->ex_nflavors;
+	int lastflags = 0, first = 0;
+
+	if (exp->ex_nflavors == 0)
+		return;
+	for (f = exp->ex_flavors; f < end; f++) {
+		if (first || f->flags != lastflags) {
+			if (!first)
+				show_secinfo_flags(m, lastflags);
+			seq_printf(m, ",sec=%d", f->pseudoflavor);
+			lastflags = f->flags;
+		} else {
+			seq_printf(m, ":%d", f->pseudoflavor);
+		}
+	}
+	show_secinfo_flags(m, lastflags);
+}
+
 static void exp_flags(struct seq_file *m, int flag, int fsid,
 		uid_t anonu, uid_t anong, struct nfsd4_fs_locations *fsloc)
 {
