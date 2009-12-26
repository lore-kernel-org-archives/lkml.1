Return-Path: <linux-kernel-owner+w=401wt.eu-S1753115AbZLZSsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115AbZLZSsc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 13:48:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752593AbZLZSsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 13:48:31 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:36753 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbZLZSsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 13:48:30 -0500
Date: Sat, 26 Dec 2009 19:47:22 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>, dhowells@redhat.com
Subject: [PATCH] BUG(): CONFIG_BUG=n version of BUG() should be
	unreachable()
Message-ID: <20091226184722.GA25275@merkur.ravnborg.org>
References: <1261531032-15225-1-git-send-email-a.beregalov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261531032-15225-1-git-send-email-a.beregalov@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previouss definition of BUG() as 'do {} while(0)' produced compilation
warnings when BUG() was used in default branch of switch() statement
(control reaches end of non-void function).

Example:
unsigned long function()
{
	switch() {
	case 1:
		return 1;
	case 2:
		return 2;
	default:
		BUG();
}

Using unreachable() fixes the problem.

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
[sam: add "for(;;) ;" so code indeed does not return]
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: David Daney <ddaney@caviumnetworks.com>
---

The patch I had in mind was this.
We introduce an endless loop and just to be sure we tell gcc
that we never get past this.
This also address the concerns rasied by David.

Arnd - this is asm-generic stuff. If you agree (and Alexander can confirm
that it works for him) then I expect you to take it.

	Sam


diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index 18c435d..f540529 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -89,7 +89,12 @@ extern void warn_slowpath_null(const char *file, const int line);
 
 #else /* !CONFIG_BUG */
 #ifndef HAVE_ARCH_BUG
-#define BUG() do {} while(0)
+/* We do not want to return from here */
+#define BUG() do {							\
+		for (;;)						\
+			/* endless loop*/;				\
+		unreachable();						\
+} while(0)
 #endif
 
 #ifndef HAVE_ARCH_BUG_ON
