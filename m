Return-Path: <linux-kernel-owner+w=401wt.eu-S1753061AbZEKGQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061AbZEKGQp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 02:16:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751409AbZEKGQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 02:16:36 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:8771 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbZEKGQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 02:16:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=fDkbgX+tjAtk+oS+lxF8fU4LDSHP+tPYaJfnDrnKIkL5RsL8Cadm2Hr5kQVQ4N/jjc
         J+CUYRRRLlAD4MQ0bzCyc4IW165C8SIyVBYghZGwORpi3yPZRWugd1fZInCFBk7FeuGB
         XFBPzuvSh/wKoOBCblvh+OeM6Yc4lRDK6EYNM=
MIME-Version: 1.0
Date: Mon, 11 May 2009 14:16:36 +0800
Message-ID: <a8e1da0905102316v1037c89cs48cb052924c250a9@mail.gmail.com>
Subject: [PATCH 1/3] kobject : kobject_set_name_vargs leak fix
From: Dave Young <hidave.darkstar@gmail.com>
To: Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kobject_set_name_vargs will leak the old_name when return -ENOMEM,
move the kfree(old_name) before the return path.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
lib/kobject.c |    2 +-
1 file changed, 1 insertion(+), 1 deletion(-)

diff -uprN linux.old/lib/kobject.c linux.new/lib/kobject.c
--- linux.old/lib/kobject.c	2009-05-11 13:59:01.000000000 +0800
+++ linux.new/lib/kobject.c	2009-05-11 13:59:34.000000000 +0800
@@ -221,6 +221,7 @@ int kobject_set_name_vargs(struct kobjec
 	if (kobj->name && !fmt)
 		return 0;

+	kfree(old_name);
 	kobj->name = kvasprintf(GFP_KERNEL, fmt, vargs);
 	if (!kobj->name)
 		return -ENOMEM;
@@ -229,7 +230,6 @@ int kobject_set_name_vargs(struct kobjec
 	while ((s = strchr(kobj->name, '/')))
 		s[0] = '!';

-	kfree(old_name);
 	return 0;
 }
