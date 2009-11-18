Return-Path: <linux-kernel-owner+w=401wt.eu-S1752948AbZKRFya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948AbZKRFya (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 00:54:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752283AbZKRFy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 00:54:29 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:59483 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbZKRFy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 00:54:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=Z4aePftZww3XiPwjIYFELNAW5SKLassHt+I3lqWK4obUhaBXz1VRjLjKRFdFlRGdnm
         E0okUVN4vs2hXMYvnI0f+z6Dpe6dE89Fk1F0bgvzT4uoGNN35Fhm4Xz7kHuZ/2lkVwmW
         GEXgibl7j7SO8kl+wGBQI+DwWiLlwD0nZiT8I=
MIME-Version: 1.0
Date: Wed, 18 Nov 2009 13:54:34 +0800
Message-ID: <b741c2440911172154g62d7f3bcu7bafc65ad2eb4b21@mail.gmail.com>
Subject: [PATCH] vfs: does call expand_files when needed
From: Liu Aleaxander <aleaxander@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Aleaxander <Aleaxander@gmail.com>
Date: Wed, 18 Nov 2009 10:59:09 +0800
Subject: [PATCH] vfs: does call expand_files when needed

I don't think we should call expand_files every time we open a
file for a new unused fd, so does the expand when necessary.

Signed-off-by: Liu Aleaxander <Aleaxander@gmail.com>
---
 fs/file.c |   27 ++++++++++++++-------------
 1 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index 87e1290..3f3d0fc 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -452,22 +452,22 @@ repeat:
 	if (fd < files->next_fd)
 		fd = files->next_fd;

-	if (fd < fdt->max_fds)
+	if (likely(fd < fdt->max_fds)) {
 		fd = find_next_zero_bit(fdt->open_fds->fds_bits,
 					   fdt->max_fds, fd);
-
-	error = expand_files(files, fd);
-	if (error < 0)
-		goto out;
-
-	/*
-	 * If we needed to expand the fs array we
-	 * might have blocked - try again.
-	 */
-	if (error)
-		goto repeat;
-
+	} else {
+		error = expand_files(files, fd);
+		if (error < 0)
+			goto out;
+		
+		/*
+		 * If we needed to expand the fs array we
+		 * might have blocked - try again.
+		 */
+		if (error)
+			goto repeat;
+	}
+		
 	if (start <= files->next_fd)
 		files->next_fd = fd + 1;

-- 
1.6.2.5

--
regards
Liu Aleaxander
