Return-Path: <linux-kernel-owner+w=401wt.eu-S1762869AbYD2R2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762869AbYD2R2o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 13:28:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756535AbYD2RVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 13:21:20 -0400
Received: from ns.suse.de ([195.135.220.2]:52156 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754683AbYD2RVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 13:21:18 -0400
Date: Tue, 29 Apr 2008 10:18:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, selinux@tycho.nsa.gov
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, sds@tycho.nsa.gov,
       jmorris@namei.org, Eric Paris <eparis@redhat.com>
Subject: [20/37] SELinux: no BUG_ON(!ss_initialized) in
	selinux_clone_mnt_opts
Message-ID: <20080429171843.GU14724@suse.de>
References: <20080429171222.073929148@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="selinux-no-bug_on-in-selinux_clone_mnt_opts.patch"
In-Reply-To: <20080429171730.GA14724@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Eric Paris <eparis@redhat.com>

commit 0f5e64200f20fc8f5b759c4010082f577ab0af3f upstream

The Fedora installer actually makes multiple NFS mounts before it loads
selinux policy.  The code in selinux_clone_mnt_opts() assumed that the
init process would always be loading policy before NFS was up and
running.  It might be possible to hit this in a diskless environment as
well, I'm not sure.  There is no need to BUG_ON() in this situation
since we can safely continue given the circumstances.

Signed-off-by: Eric Paris <eparis@redhat.com>
Signed-off-by: James Morris <jmorris@namei.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 security/selinux/hooks.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -756,9 +756,18 @@ static void selinux_sb_clone_mnt_opts(co
 	int set_context =	(oldsbsec->flags & CONTEXT_MNT);
 	int set_rootcontext =	(oldsbsec->flags & ROOTCONTEXT_MNT);
 
-	/* we can't error, we can't save the info, this shouldn't get called
-	 * this early in the boot process. */
-	BUG_ON(!ss_initialized);
+	/*
+	 * if the parent was able to be mounted it clearly had no special lsm
+	 * mount options.  thus we can safely put this sb on the list and deal
+	 * with it later
+	 */
+	if (!ss_initialized) {
+		spin_lock(&sb_security_lock);
+		if (list_empty(&newsbsec->list))
+			list_add(&newsbsec->list, &superblock_security_head);
+		spin_unlock(&sb_security_lock);
+		return;
+	}
 
 	/* how can we clone if the old one wasn't set up?? */
 	BUG_ON(!oldsbsec->initialized);

-- 
