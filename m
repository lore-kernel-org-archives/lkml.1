Return-Path: <linux-kernel-owner+w=401wt.eu-S1755892AbZFVKB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892AbZFVKB3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 06:01:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751371AbZFVKBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 06:01:22 -0400
Received: from mailout07.t-online.de ([194.25.134.83]:42716 "EHLO
	mailout07.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbZFVKBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 06:01:22 -0400
X-Greylist: delayed 1446 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Jun 2009 06:01:21 EDT
Message-ID: <4A3F5EAE.7020402@t-online.de>
Date: Mon, 22 Jun 2009 11:36:30 +0100
From: Bernd Schmidt <bernds_cb1@t-online.de>
User-Agent: Thunderbird 2.0.0.21 (X11/20090430)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Blackfin Architecture Team 
	<uclinux-dist-devel@blackfin.uclinux.org>,
       David Howells <dhowells@redhat.com>, stable@kernel.org
Subject: Fix for shared flat binary format in 2.6.30
Content-Type: multipart/mixed;
 boundary="------------020206060806020404020307"
X-ID: S9WgWEZcZhcE7NHFA0b5mX+861SjCIpbb9Gv-VR60SrBOVMXYVImNV4oheSZSdHgVB
X-TOI-MSGID: 37b5da8d-3255-49cf-943c-5dd61f24bd1d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020206060806020404020307
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This fixes a crash in 2.6.30 with shared flat binaries.  prepare_binfmt 
now requires a cred pointer to be set up, which isn't done in binfmt_flat.c.

Signed-off-by: Bernd Schmidt <bernds_cb1@t-online.de>
Acked-by: David Howells <dhowells@redhat.com>
-- 
This footer brought to you by insane German lawmakers.
Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft Muenchen, Registergericht Muenchen HRB 40368
Geschaeftsfuehrer Thomas Wessel, William A. Martin, Margaret Seif

--------------020206060806020404020307
Content-Type: text/plain;
 name="cred-flat.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="cred-flat.diff"

Index: fs/binfmt_flat.c
===================================================================
--- fs/binfmt_flat.c	(revision 6766)
+++ fs/binfmt_flat.c	(working copy)
@@ -853,14 +853,23 @@ static int load_flat_shared_library(int 
 	/* Open the file up */
 	bprm.filename = buf;
 	bprm.file = open_exec(bprm.filename);
+	bprm.cred = NULL;
 	res = PTR_ERR(bprm.file);
 	if (IS_ERR(bprm.file))
 		return res;
 
+	bprm.cred = prepare_exec_creds();
+	if (!bprm.cred)
+		goto out;
+
 	res = prepare_binprm(&bprm);
 
 	if (res <= (unsigned long)-4096)
 		res = load_flat_file(&bprm, libs, id, NULL, NULL);
+out:
+	if (bprm.cred)
+		abort_creds (bprm.cred);
+
 	if (bprm.file) {
 		allow_write_access(bprm.file);
 		fput(bprm.file);

--------------020206060806020404020307--
