Return-Path: <linux-kernel-owner+w=401wt.eu-S1760172AbZKFWWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760172AbZKFWWz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:22:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932451AbZKFWWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:22:54 -0500
Received: from kroah.org ([198.145.64.141]:56826 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932440AbZKFWWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:22:51 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:43 2009
Message-Id: <20091106221543.777556060@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:14:36 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [38/99] param: fix setting arrays of bool
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=param-fix-setting-arrays-of-bool.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Rusty Russell <rusty@rustcorp.com.au>

commit 3c7d76e371ac1a3802ae1673f5c63554af59325c upstream.

We create a dummy struct kernel_param on the stack for parsing each
array element, but we didn't initialize the flags word.  This matters
for arrays of type "bool", where the flag indicates if it really is
an array of bools or unsigned int (old-style).

Reported-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/params.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/kernel/params.c
+++ b/kernel/params.c
@@ -299,6 +299,7 @@ static int param_array(const char *name,
 		       unsigned int min, unsigned int max,
 		       void *elem, int elemsize,
 		       int (*set)(const char *, struct kernel_param *kp),
+		       u16 flags,
 		       unsigned int *num)
 {
 	int ret;
@@ -308,6 +309,7 @@ static int param_array(const char *name,
 	/* Get the name right for errors. */
 	kp.name = name;
 	kp.arg = elem;
+	kp.flags = flags;
 
 	/* No equals sign? */
 	if (!val) {
@@ -353,7 +355,8 @@ int param_array_set(const char *val, str
 	unsigned int temp_num;
 
 	return param_array(kp->name, val, 1, arr->max, arr->elem,
-			   arr->elemsize, arr->set, arr->num ?: &temp_num);
+			   arr->elemsize, arr->set, kp->flags,
+			   arr->num ?: &temp_num);
 }
 
 int param_array_get(char *buffer, struct kernel_param *kp)


