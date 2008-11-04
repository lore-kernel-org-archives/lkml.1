Return-Path: <linux-kernel-owner+w=401wt.eu-S1759622AbYKDX6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759622AbYKDX6p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 18:58:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757781AbYKDXl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 18:41:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52384 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757473AbYKDXlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 18:41:25 -0500
Date: Tue, 4 Nov 2008 15:33:40 -0800
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
Subject: [patch 57/57] file caps: always start with clear bprm->caps_*
Message-ID: <20081104233340.GF659@suse.de>
References: <20081104232144.186593464@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="file-caps-always-start-with-clear-bprm-caps_.patch"
In-Reply-To: <20081104233028.GA659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

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
@@ -279,10 +279,10 @@ static int get_file_caps(struct linux_bi
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
