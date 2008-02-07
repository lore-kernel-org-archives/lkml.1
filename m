Return-Path: <linux-kernel-owner+w=401wt.eu-S934833AbYBGVLL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934833AbYBGVLL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 16:11:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759895AbYBGUxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:53:54 -0500
Received: from mx2.suse.de ([195.135.220.15]:38811 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933193AbYBGUxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:53:51 -0500
Date: Thu, 7 Feb 2008 12:48:09 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>
Subject: [patch 38/45] selinux: fix labeling of /proc/net inodes
Message-ID: <20080207204809.GM16389@suse.de>
References: <20080207204118.202098927@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="selinux-fix-labeling-of-proc-net-inodes.patch"
In-Reply-To: <20080207204549.GA16389@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.24-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Stephen Smalley <sds@tycho.nsa.gov>

patch b1aa5301b9f88a4891061650c591fb8fe1c1d1da in mainline.

The proc net rewrite had a side effect on selinux, leading it to mislabel
the /proc/net inodes, thereby leading to incorrect denials.  Fix
security_genfs_sid to ignore extra leading / characters in the path supplied
by selinux_proc_get_sid since we now get "//net/..." rather than "/net/...".

Signed-off-by: Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: James Morris <jmorris@namei.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 security/selinux/ss/services.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -1744,6 +1744,9 @@ int security_genfs_sid(const char *fstyp
 	struct ocontext *c;
 	int rc = 0, cmp = 0;
 
+	while (path[0] == '/' && path[1] == '/')
+		path++;
+
 	POLICY_RDLOCK;
 
 	for (genfs = policydb.genfs; genfs; genfs = genfs->next) {

-- 
