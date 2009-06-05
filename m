Return-Path: <linux-kernel-owner+w=401wt.eu-S1755383AbZFEIZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383AbZFEIZz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 04:25:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755913AbZFEIHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 04:07:14 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37514 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755728AbZFEIGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 04:06:12 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Roel Kluin <roel.kluin@gmail.com>
Subject: [PATCH 59/62] Blackfin: fix length checking in kgdb_ebin2mem
Date: Fri,  5 Jun 2009 04:05:08 -0400
Message-Id: <1244189111-19639-60-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
References: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roel Kluin <roel.kluin@gmail.com>

The kgdb_ebin2mem() was decrementing the count variable to do parsing, but
then later still tries to use it based on its original meaning.  So leave
it untouched and use a different variable to walk the memory.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/kgdb.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/blackfin/kernel/kgdb.c b/arch/blackfin/kernel/kgdb.c
index c5362b2..da28f79 100644
--- a/arch/blackfin/kernel/kgdb.c
+++ b/arch/blackfin/kernel/kgdb.c
@@ -587,19 +587,18 @@ int kgdb_ebin2mem(char *buf, char *mem, int count)
 	unsigned short *mmr16;
 	unsigned long *mmr32;
 	int err;
-	int size = 0;
+	int size;
 	int cpu = raw_smp_processor_id();
 
 	tmp_old = tmp_new = buf;
 
-	while (count-- > 0) {
+	for (size = 0; size < count; ++size) {
 		if (*tmp_old == 0x7d)
 			*tmp_new = *(++tmp_old) ^ 0x20;
 		else
 			*tmp_new = *tmp_old;
 		tmp_new++;
 		tmp_old++;
-		size++;
 	}
 
 	err = validate_memory_access_address((unsigned long)mem, size);
-- 
1.6.3.1

