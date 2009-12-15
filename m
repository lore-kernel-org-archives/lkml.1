Return-Path: <linux-kernel-owner+w=401wt.eu-S933721AbZLOV0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933721AbZLOV0V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 16:26:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933706AbZLOV0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 16:26:18 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:36805 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933713AbZLOV0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 16:26:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=NLzgFgJP0llZ4z+NTc9Yf+32clJSI1C/0kHA1qw/iSSk9ingqjuQgTuC0YXiFVcuES
         J7JSBGUUKTckcjH2KmfSXzmelsG+uFhtJE2huQnK/ka9V8sY2IVG1FqspqUIECkJegmU
         o9/JEGw7jkFevoTyY1IDz43/eJiP4S5ydNbag=
Message-ID: <4B27FF64.6070602@gmail.com>
Date: Tue, 15 Dec 2009 22:28:04 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Tom Zanussi <tzanussi@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] relay: Fix signedness issues in relay_page_release() and
 relay_file_splice_read()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In subbuf_splice_actor() `ret' is unsigned, so the `ret < 0'
test does not work and splice_to_pipe() errors are not acted upon.
It appears the cause is confusion between the signedness of the
return values `ret' and `nonpad_ret'.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Found using coccinelle: http://coccinelle.lip6.fr/

I tried to solve this in the patch below, A remaining problem may be
that `spliced' wraps, any comments?

The rationale for the patch below:

padding (size_t) is only added to `ret' and not to `*nonpad_ret', so
I think that ret should be unsigned, or even size_t, whereas `*nonpad_ret'
should be int and carry the error.

the caller relay_file_splice_read() should therefore check the error in
`nonpad_ret', which should be int, rather than in `ret' - unsigned.

checkpatch likes it and it appears to build, but maybe there are
comments?

diff --git a/kernel/relay.c b/kernel/relay.c
index 760c262..632fca2 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -1215,7 +1215,7 @@ static void relay_page_release(struct splice_pipe_desc *spd, unsigned int i)
 /*
  *	subbuf_splice_actor - splice up to one subbuf's worth of data
  */
-static int subbuf_splice_actor(struct file *in,
+static unsigned int subbuf_splice_actor(struct file *in,
 			       loff_t *ppos,
 			       struct pipe_inode_info *pipe,
 			       size_t len,
@@ -1292,7 +1292,7 @@ static int subbuf_splice_actor(struct file *in,
 		return 0;
 
 	ret = *nonpad_ret = splice_to_pipe(pipe, &spd);
-	if (ret < 0 || ret < total_len)
+	if (*nonpad_ret < 0 || ret < total_len)
 		return ret;
 
         if (read_start + ret == nonpad_end)
@@ -1308,7 +1308,7 @@ static ssize_t relay_file_splice_read(struct file *in,
 				      unsigned int flags)
 {
 	ssize_t spliced;
-	int ret;
+	unsigned ret;
 	int nonpad_ret = 0;
 
 	ret = 0;
@@ -1316,11 +1316,11 @@ static ssize_t relay_file_splice_read(struct file *in,
 
 	while (len && !spliced) {
 		ret = subbuf_splice_actor(in, ppos, pipe, len, flags, &nonpad_ret);
-		if (ret < 0)
+		if (nonpad_ret < 0)
 			break;
 		else if (!ret) {
 			if (flags & SPLICE_F_NONBLOCK)
-				ret = -EAGAIN;
+				nonpad_ret = -EAGAIN;
 			break;
 		}
 
@@ -1336,7 +1336,7 @@ static ssize_t relay_file_splice_read(struct file *in,
 	if (spliced)
 		return spliced;
 
-	return ret;
+	return nonpad_ret;
 }
 
 const struct file_operations relay_file_operations = {
