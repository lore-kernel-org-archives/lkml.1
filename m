Return-Path: <linux-kernel-owner+w=401wt.eu-S1754143AbZJUPpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143AbZJUPpn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 11:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754096AbZJUPpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 11:45:42 -0400
Received: from ozlabs.org ([203.10.76.45]:39371 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754090AbZJUPpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 11:45:42 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 2/2] param: initialize flags when processing array.
Date: Thu, 22 Oct 2009 02:15:42 +1030
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <s5haazv1sw5.wl%tiwai@suse.de> <200910220158.05014.rusty@rustcorp.com.au>
In-Reply-To: <200910220158.05014.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910220215.42981.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We create a dummy struct kernel_param on the stack for parsing each
array element, but we didn't initialize the flags word.

This means that it might appear to be kmalloced, and hence be freed,
and also an array of bool which were actually bool (rather than the
historically-allowed int) would not be parsed correctly.

Note that if it *is* kmalloced, the KPARAM_KMALLOCED flag is set in
the dummy flags and thrown away, so we leak memory.  Only one place
has a writable charp array though, and this is no worse than current
behavior.

Reported-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/kernel/params.c b/kernel/params.c
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -304,6 +304,7 @@ static int param_array(const char *name,
 		       unsigned int min, unsigned int max,
 		       void *elem, int elemsize,
 		       int (*set)(const char *, struct kernel_param *kp),
+		       u16 flags,
 		       unsigned int *num)
 {
 	int ret;
@@ -313,6 +314,8 @@ static int param_array(const char *name,
 	/* Get the name right for errors. */
 	kp.name = name;
 	kp.arg = elem;
+	/* FIXME: this causes a leak for writing arrays of charp! */
+	kp.flags = flags;
 
 	/* No equals sign? */
 	if (!val) {
@@ -358,7 +361,8 @@ int param_array_set(const char *val, str
 	unsigned int temp_num;
 
 	return param_array(kp->name, val, 1, arr->max, arr->elem,
-			   arr->elemsize, arr->set, arr->num ?: &temp_num);
+			   arr->elemsize, arr->set, kp->flags,
+			   arr->num ?: &temp_num);
 }
 
 int param_array_get(char *buffer, struct kernel_param *kp)
