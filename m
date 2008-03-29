Return-Path: <linux-kernel-owner+w=401wt.eu-S1757030AbYC2VFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757030AbYC2VFN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 17:05:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754627AbYC2VFB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 17:05:01 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:19049 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754588AbYC2VFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 17:05:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=fJEwA4Wli4nFTReL5Tq5vmBBRR1YIh0Eq+2YqkzkHI3oE25LNzKsg8FU88FSjDK0rWXq5MgU7qvsS+rwS6/JqayvGXLo7nH5DcJe0TkZiVIq5nSA2wLBJeNXUOk/LutZDiMaLfOrfMQh2AwvsQevRVlFThCGsYaBLEhNP7kTiUE=
Date: Sun, 30 Mar 2008 00:01:31 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, den@openvz.org
Subject: [PATCH -mm 2/3] proc: less special case in xlate code
Message-ID: <20080329210131.GB16275@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If valid "parent" is passed to proc_create/remove_proc_entry(), then
name of PDE should consist of only one path component, otherwise creation or
or removal will fail. However, if NULL is passed as parent then create/remove
accept full path as a argument. This is arbitrary restriction -- all
infrastructure is in place.

So, patch allows the following to succeed:

	create_proc_entry("foo/bar", 0, pde_baz);
	remove_proc_entry("baz/foo/bar", &proc_root);

Also makes the following to behave identically:

	create_proc_entry("foo/bar", 0, NULL);
	create_proc_entry("foo/bar", 0, &proc_root);

Discrepancy noticed by Den Lunev (IIRC).

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/proc/generic.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -277,8 +277,11 @@ static int xlate_proc_name(const char *name,
 	int			len;
 	int 			rtn = 0;
 
+	de = *ret;
+	if (!de)
+		de = &proc_root;
+
 	spin_lock(&proc_subdir_lock);
-	de = &proc_root;
 	while (1) {
 		next = strchr(cp, '/');
 		if (!next)
@@ -582,7 +585,7 @@ static struct proc_dir_entry *__proc_create(struct proc_dir_entry **parent,
 	/* make sure name is valid */
 	if (!name || !strlen(name)) goto out;
 
-	if (!(*parent) && xlate_proc_name(name, parent, &fn) != 0)
+	if (xlate_proc_name(name, parent, &fn) != 0)
 		goto out;
 
 	/* At this point there must not be any '/' characters beyond *fn */
@@ -738,7 +741,7 @@ void remove_proc_entry(const char *name, struct proc_dir_entry *parent)
 	const char *fn = name;
 	int len;
 
-	if (!parent && xlate_proc_name(name, &parent, &fn) != 0)
+	if (xlate_proc_name(name, &parent, &fn) != 0)
 		return;
 	len = strlen(fn);
 

