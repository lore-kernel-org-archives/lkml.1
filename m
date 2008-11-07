Return-Path: <linux-kernel-owner+w=401wt.eu-S1754183AbYKGXZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183AbYKGXZd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 18:25:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753616AbYKGXW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 18:22:58 -0500
Received: from kroah.org ([198.145.64.141]:59217 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753572AbYKGXW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 18:22:58 -0500
Date: Fri, 7 Nov 2008 15:15:27 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Serge Hallyn <serue@us.ibm.com>,
       David Howells <dhowells@redhat.com>,
       "Andrew G. Morgan" <morgan@kernel.org>
Subject: [patch 07/23] file caps: always start with clear bprm->caps_*
Message-ID: <20081107231527.GH1108@kroah.com>
References: <20081107224818.593212310@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="file-caps-always-start-with-clear-bprm-caps_.patch"
In-Reply-To: <20081107231457.GA1108@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Serge Hallyn <serue@us.ibm.com>

commit 3318a386e4ca68c76e0294363d29bdc46fcad670 upstream

While Linux doesn't honor setuid on scripts.  However, it mistakenly
behaves differently for file capabilities.

This patch fixes that behavior by making sure that get_file_caps()
begins with empty bprm->caps_*.  That way when a script is loaded,
its bprm->caps_* may be filled when binfmt_misc calls prepare_binprm(),
but they will be cleared again when binfmt_elf calls prepare_binprm()
next to read the interpreter's file capabilities.

Signed-off-by: Serge Hallyn <serue@us.ibm.com>
Acked-by: David Howells <dhowells@redhat.com>
Acked-by: Andrew G. Morgan <morgan@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 security/commoncap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -247,10 +247,10 @@ static int get_file_caps(struct linux_bi
 	struct vfs_cap_data vcaps;
 	struct inode *inode;
 
-	if (bprm->file->f_vfsmnt->mnt_flags & MNT_NOSUID) {
-		bprm_clear_caps(bprm);
+	bprm_clear_caps(bprm);
+
+	if (bprm->file->f_vfsmnt->mnt_flags & MNT_NOSUID)
 		return 0;
-	}
 
 	dentry = dget(bprm->file->f_dentry);
 	inode = dentry->d_inode;

-- 
