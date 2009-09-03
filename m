Return-Path: <linux-kernel-owner+w=401wt.eu-S1755973AbZICQeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973AbZICQeY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 12:34:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755868AbZICQeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 12:34:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25394 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755732AbZICQeX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 12:34:23 -0400
Date: Thu, 3 Sep 2009 18:29:39 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, James Morris <jmorris@namei.org>,
       Roland McGrath <roland@redhat.com>, Tom Horsley <tom.horsley@att.net>,
       linux-kernel@vger.kernel.org
Subject: binfmt_flat.c && bprm->cred (Was: [PATCH 0/1] exec: do not sleep
	in TASK_TRACED under ->cred_guard_mutex)
Message-ID: <20090903162939.GA24528@redhat.com>
References: <20090903160510.GA23638@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090903160510.GA23638@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03, Oleg Nesterov wrote:
>
> load_flat_shared_library() does something strange (but hopefully this
> patch doesn't break it). I do not understand why does it create the
> new bprm. Afaics, it could reuse bprm pointer which comes as an argument
> of ->load_binary(), all we need is to temporary change/restore bprm->file
> for load_flat_file().

IOW, afaics the patch below makes sense. Imho it is a bit ugly binfmt_flat.c
plays with prepare_exec_creds().

But again, I don't understand this code, and I didn't even try to compile
this patch.

Oleg.

--- a/fs/binfmt_flat.c
+++ b/fs/binfmt_flat.c
@@ -83,7 +83,7 @@ struct lib_info {
 };
 
 #ifdef CONFIG_BINFMT_SHARED_FLAT
-static int load_flat_shared_library(int id, struct lib_info *p);
+static int load_flat_shared_library(struct linux_binprm*, int, struct lib_info*);
 #endif
 
 static int load_flat_binary(struct linux_binprm *, struct pt_regs * regs);
@@ -308,7 +308,8 @@ out_free:
 /****************************************************************************/
 
 static unsigned long
-calc_reloc(unsigned long r, struct lib_info *p, int curid, int internalp)
+calc_reloc(struct linux_binprm *bprm, unnsigned long r, struct lib_info *p,
+		int curid, int internalp)
 {
 	unsigned long addr;
 	int id;
@@ -335,7 +336,7 @@ calc_reloc(unsigned long r, struct lib_i
 					"(%d != %d)", (unsigned) r, curid, id);
 			goto failed;
 		} else if ( ! p->lib_list[id].loaded &&
-				load_flat_shared_library(id, p) > (unsigned long) -4096) {
+				load_flat_shared_library(bprm, id, p) > (unsigned long) -4096) {
 			printk("BINFMT_FLAT: failed to load library %d", id);
 			goto failed;
 		}
@@ -726,7 +727,7 @@ static int load_flat_file(struct linux_b
 		for (rp = (unsigned long *)datapos; *rp != 0xffffffff; rp++) {
 			unsigned long addr;
 			if (*rp) {
-				addr = calc_reloc(*rp, libinfo, id, 0);
+				addr = calc_reloc(bprm, *rp, libinfo, id, 0);
 				if (addr == RELOC_FAILED) {
 					ret = -ENOEXEC;
 					goto err;
@@ -759,7 +760,7 @@ static int load_flat_file(struct linux_b
 			if (flat_set_persistent (relval, &persistent))
 				continue;
 			addr = flat_get_relocate_addr(relval);
-			rp = (unsigned long *) calc_reloc(addr, libinfo, id, 1);
+			rp = (unsigned long *) calc_reloc(bprm, addr, libinfo, id, 1);
 			if (rp == (unsigned long *)RELOC_FAILED) {
 				ret = -ENOEXEC;
 				goto err;
@@ -775,7 +776,7 @@ static int load_flat_file(struct linux_b
 				 */
 				if ((flags & FLAT_FLAG_GOTPIC) == 0)
 					addr = ntohl(addr);
-				addr = calc_reloc(addr, libinfo, id, 0);
+				addr = calc_reloc(bprm, addr, libinfo, id, 0);
 				if (addr == RELOC_FAILED) {
 					ret = -ENOEXEC;
 					goto err;
@@ -812,37 +813,29 @@ err:
  * segment (including bss) but not argv/argc/environ.
  */
 
-static int load_flat_shared_library(int id, struct lib_info *libs)
+static int load_flat_shared_library(struct linux_binprm *bprm, int id,
+						struct lib_info *libs)
 {
-	struct linux_binprm bprm;
-	int res;
+	char *save_name = bprm->filename;
+	struct file *save_file = bprm->file;
 	char buf[16];
-
-	/* Create the file name */
-	sprintf(buf, "/lib/lib%d.so", id);
+	int res;
 
 	/* Open the file up */
-	bprm.filename = buf;
-	bprm.file = open_exec(bprm.filename);
-	res = PTR_ERR(bprm.file);
-	if (IS_ERR(bprm.file))
-		return res;
-
-	bprm.cred = prepare_exec_creds();
-	res = -ENOMEM;
-	if (!bprm.cred)
-		goto out;
-
-	res = prepare_binprm(&bprm);
-
-	if (res <= (unsigned long)-4096)
-		res = load_flat_file(&bprm, libs, id, NULL);
-
-	abort_creds(bprm.cred);
-
-out:
-	allow_write_access(bprm.file);
-	fput(bprm.file);
+	sprintf(buf, "/lib/lib%d.so", id);
+	bprm->filename = buf;
+	bprm->file = open_exec(bprm->filename);
+	res = PTR_ERR(bprm->file);
+	if (IS_ERR(bprm->file))
+		goto ret;
+
+	res = load_flat_file(bprm, libs, id, NULL);
+
+	allow_write_access(bprm->file);
+	fput(bprm->file);
+ret:
+	bprm->filename = save_name;
+	bprm->file = save_file;
 
 	return(res);
 }

