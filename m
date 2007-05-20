Return-Path: <linux-kernel-owner+w=401wt.eu-S1760481AbXETGEI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760481AbXETGEI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 02:04:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758878AbXETGD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 02:03:57 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:34474 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758679AbXETGD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 02:03:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mail-followup-to:mime-version:content-type:content-disposition:user-agent;
        b=Z0HfAumRQh/zo/eZfpV4qvulqJ1RXEwpSR4Rs+BcxvW6m+BhKWPyiIPyzaqHJZyHRH0mGUKQUx9WAItmUNMmloaAHlAeEkYdT0bNCPQWm2otBuo+ujtIZI4eP2yjCMjYYfRkXYTxQAIz5/Io9LGKr8t2P2uyYSrCLMxlwHMdkPk=
Date: Sun, 20 May 2007 14:56:39 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: stable@kernel.org
Subject: [PATCH] check d_path() error in print-fatal-signals
Message-ID: <20070520055639.GA4485@APFDCB5C>
Mail-Followup-To: Akinobu Mita <akinobu.mita@gmail.com>,
	linux-kernel@vger.kernel.org, stable@kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

d_path() returns -ENAMETOOLONG if buffer length is not enough.
But there is no error handling for it in print_vma() which calls
d_path() with not enough buffer (We can easily make segfault program
which has longer path than 128bytes).

This patch allocates enough buffer for d_path() dynamically.
audit_log_d_path() is doing sililar thing. So I just stole from it.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

---
 kernel/signal.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

Index: 2.6-mm/kernel/signal.c
===================================================================
--- 2.6-mm.orig/kernel/signal.c
+++ 2.6-mm/kernel/signal.c
@@ -740,15 +740,23 @@ static int print_vma(struct vm_area_stru
 	 * special [heap] marker for the heap:
 	 */
 	if (file) {
-#define SIZE 128
-		char tmp[SIZE], *str;
-
-		str = d_path(file->f_dentry, file->f_vfsmnt, tmp, SIZE);
-		while (str[0] && (str[0] == ' '))
-			str++;
+		char *p, *path;
 
+		/* We will allow 11 spaces for ' (deleted)' to be appended */
+		path = kmalloc(PATH_MAX + 11, GFP_KERNEL);
+		if (!path)
+			p = "<no memory>";
+		else {
+			p = d_path(file->f_dentry, file->f_vfsmnt, path,
+				   PATH_MAX + 11);
+			if (IS_ERR(p))
+				p = "<too long>";
+			else
+				p = strstrip(p);
+		}
 		pad_len_spaces(len);
-		printk("%s", str);
+		printk("%s", p);
+		kfree(path);
 	} else {
 		const char *name = arch_vma_name(vma);
 		if (!name) {
