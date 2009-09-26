Return-Path: <linux-kernel-owner+w=401wt.eu-S1753155AbZIZSzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155AbZIZSzA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 14:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752707AbZIZSya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 14:54:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:36400 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbZIZSyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 14:54:20 -0400
Date: Sat, 26 Sep 2009 20:52:55 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, mingo@elte.hu,
       sfrench@samba.org
Subject: [PATCH 6/9] Simplify bound checks in cifs for copy_from_user
Message-ID: <20090926205255.1d9de6c7@infradead.org>
In-Reply-To: <20090926204951.424e567e@infradead.org>
References: <20090926204951.424e567e@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH 6/9] Simplify bound checks in cifs for copy_from_user
CC: Steve French <sfrench@samba.org>

The CIFS code unfortunately hits a missed optimization in gcc
(http://gcc.gnu.org/bugzilla/show_bug.cgi?id=41477)
where gcc can't prove to itself that count will not be larger than 11.

This patch simplifies the expression so that GCC does realize this,
giving slightly better code soon when copy_from_user() grows some checks.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index 42cec2a..94b86da 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -732,11 +732,13 @@ static ssize_t cifs_security_flags_proc_write(struct file *file,
 	char flags_string[12];
 	char c;
 
-	if ((count < 1) || (count > 11))
-		return -EINVAL;
-
 	memset(flags_string, 0, 12);
 
+	if (count < 1)
+		return -EINVAL;
+	if (count > 11)
+		return -EINVAL;
+
 	if (copy_from_user(flags_string, buffer, count))
 		return -EFAULT;
 



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
