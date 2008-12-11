Return-Path: <linux-kernel-owner+w=401wt.eu-S932539AbYLKTqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932539AbYLKTqZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:46:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757528AbYLKTTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:19:34 -0500
Received: from kroah.org ([198.145.64.141]:56815 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757666AbYLKTTc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:19:32 -0500
Date: Thu, 11 Dec 2008 11:16:44 -0800
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
       alan@lxorguk.ukuu.org.uk, "Kirill A. Shutemov" <kirill@shutemov.name>,
       Pavel Emelyanov <xemul@openvz.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [patch 78/83] Allow recursion in binfmt_script and binfmt_misc
Message-ID: <20081211191644.GZ5894@kroah.com>
References: <20081211190201.612240183@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="allow-recursion-in-binfmt_script-and-binfmt_misc.patch"
In-Reply-To: <20081211191014.GA5759@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Kirill A. Shutemov <kirill@shutemov.name>

commit bf2a9a39639b8b51377905397a5005f444e9a892 upstream.

binfmt_script and binfmt_misc disallow recursion to avoid stack overflow
using sh_bang and misc_bang.  It causes problem in some cases:

$ echo '#!/bin/ls' > /tmp/t0
$ echo '#!/tmp/t0' > /tmp/t1
$ echo '#!/tmp/t1' > /tmp/t2
$ chmod +x /tmp/t*
$ /tmp/t2
zsh: exec format error: /tmp/t2

Similar problem with binfmt_misc.

This patch introduces field 'recursion_depth' into struct linux_binprm to
track recursion level in binfmt_misc and binfmt_script.  If recursion
level more then BINPRM_MAX_RECURSION it generates -ENOEXEC.

[akpm@linux-foundation.org: make linux_binprm.recursion_depth a uint]
Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/binfmt_em86.c        |    2 +-
 fs/binfmt_misc.c        |    4 ++--
 fs/binfmt_script.c      |    5 +++--
 include/linux/binfmts.h |    2 ++
 4 files changed, 8 insertions(+), 5 deletions(-)

--- a/fs/binfmt_em86.c
+++ b/fs/binfmt_em86.c
@@ -43,7 +43,7 @@ static int load_em86(struct linux_binprm
 			return -ENOEXEC;
 	}
 
-	bprm->sh_bang = 1;	/* Well, the bang-shell is implicit... */
+	bprm->recursion_depth++; /* Well, the bang-shell is implicit... */
 	allow_write_access(bprm->file);
 	fput(bprm->file);
 	bprm->file = NULL;
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -117,7 +117,7 @@ static int load_misc_binary(struct linux
 		goto _ret;
 
 	retval = -ENOEXEC;
-	if (bprm->misc_bang)
+	if (bprm->recursion_depth > BINPRM_MAX_RECURSION)
 		goto _ret;
 
 	/* to keep locking time low, we copy the interpreter string */
@@ -197,7 +197,7 @@ static int load_misc_binary(struct linux
 	if (retval < 0)
 		goto _error;
 
-	bprm->misc_bang = 1;
+	bprm->recursion_depth++;
 
 	retval = search_binary_handler (bprm, regs);
 	if (retval < 0)
--- a/fs/binfmt_script.c
+++ b/fs/binfmt_script.c
@@ -22,14 +22,15 @@ static int load_script(struct linux_binp
 	char interp[BINPRM_BUF_SIZE];
 	int retval;
 
-	if ((bprm->buf[0] != '#') || (bprm->buf[1] != '!') || (bprm->sh_bang)) 
+	if ((bprm->buf[0] != '#') || (bprm->buf[1] != '!') ||
+	    (bprm->recursion_depth > BINPRM_MAX_RECURSION))
 		return -ENOEXEC;
 	/*
 	 * This section does the #! interpretation.
 	 * Sorta complicated, but hopefully it will work.  -TYT
 	 */
 
-	bprm->sh_bang = 1;
+	bprm->recursion_depth++;
 	allow_write_access(bprm->file);
 	fput(bprm->file);
 	bprm->file = NULL;
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -36,6 +36,7 @@ struct linux_binprm{
 	unsigned long p; /* current top of mem */
 	unsigned int sh_bang:1,
 		     misc_bang:1;
+	unsigned int recursion_depth;
 	struct file * file;
 	int e_uid, e_gid;
 	kernel_cap_t cap_post_exec_permitted;
@@ -58,6 +59,7 @@ struct linux_binprm{
 #define BINPRM_FLAGS_EXECFD_BIT 1
 #define BINPRM_FLAGS_EXECFD (1 << BINPRM_FLAGS_EXECFD_BIT)
 
+#define BINPRM_MAX_RECURSION 4
 
 /*
  * This structure defines the functions that are used to load the binary formats that

