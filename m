Return-Path: <linux-kernel-owner+w=401wt.eu-S1756905AbZKUWKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905AbZKUWKb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 17:10:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756883AbZKUWKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 17:10:30 -0500
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:56287 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756842AbZKUWKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 17:10:07 -0500
Message-ID: <4B08653F.1010405@freemail.hu>
Date: Sat, 21 Nov 2009 23:10:07 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
CC: cocci@diku.dk, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/4] binfmt_elf: remove redundant zero fill
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail01d.mail.t-online.hu 32711; Body=4 Fuz1=4
	Fuz2=4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

The buffer is first zeroed out by memset(). Then strncpy() is used to
fill the content. The strncpy() function also pads the string till the
end of the specified length, which is redundant. The strncpy() does not
ensures that the string will be properly closed with 0. Use strlcpy()
instead.

The semantic match that finds this kind of pattern is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression buffer;
expression size;
expression str;
@@
	memset(buffer, 0, size);
	...
-	strncpy(
+	strlcpy(
	buffer, str, sizeof(buffer)
	);
@@
expression buffer;
expression size;
expression str;
@@
	memset(&buffer, 0, size);
	...
-	strncpy(
+	strlcpy(
	&buffer, str, sizeof(buffer));
@@
expression buffer;
identifier field;
expression size;
expression str;
@@
	memset(buffer, 0, size);
	...
-	strncpy(
+	strlcpy(
	buffer->field, str, sizeof(buffer->field)
	);
@@
expression buffer;
identifier field;
expression size;
expression str;
@@
	memset(&buffer, 0, size);
	...
-	strncpy(
+	strlcpy(
	buffer.field, str, sizeof(buffer.field));
// </smpl>

On strncpy() vs strlcpy() see http://www.gratisoft.us/todd/papers/strlcpy.html .

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -u -p a/fs/binfmt_elf.c b/fs/binfmt_elf.c
--- a/fs/binfmt_elf.c 2009-11-14 07:06:49.000000000 +0100
+++ b/fs/binfmt_elf.c 2009-11-21 22:12:15.000000000 +0100
@@ -1399,7 +1399,7 @@ static int fill_psinfo(struct elf_prpsin
 	SET_UID(psinfo->pr_uid, cred->uid);
 	SET_GID(psinfo->pr_gid, cred->gid);
 	rcu_read_unlock();
-	strncpy(psinfo->pr_fname, p->comm, sizeof(psinfo->pr_fname));
+	strlcpy(psinfo->pr_fname, p->comm, sizeof(psinfo->pr_fname));
 	
 	return 0;
 }
diff -u -p a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
--- a/fs/binfmt_elf_fdpic.c 2009-11-14 07:06:49.000000000 +0100
+++ b/fs/binfmt_elf_fdpic.c 2009-11-21 22:14:43.000000000 +0100
@@ -1452,7 +1452,7 @@ static int fill_psinfo(struct elf_prpsin
 	SET_UID(psinfo->pr_uid, cred->uid);
 	SET_GID(psinfo->pr_gid, cred->gid);
 	rcu_read_unlock();
-	strncpy(psinfo->pr_fname, p->comm, sizeof(psinfo->pr_fname));
+	strlcpy(psinfo->pr_fname, p->comm, sizeof(psinfo->pr_fname));

 	return 0;
 }
