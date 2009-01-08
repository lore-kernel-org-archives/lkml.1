Return-Path: <linux-kernel-owner+w=401wt.eu-S1758106AbZAHPqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758106AbZAHPqt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 10:46:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752220AbZAHPqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 10:46:37 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:44941 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752176AbZAHPqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 10:46:36 -0500
Subject: [PATCH] async: Don't call async_synchronize_full_special() while
 holding sb_lock
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Grissiom <chaos.proton@gmail.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
In-Reply-To: <20090108072111.1ebadebd@infradead.org>
References: <a0adeea50901080007q5a3ed5c8y5a744ce37e677325@mail.gmail.com>
	 <1231425472.21528.13.camel@norville.austin.ibm.com>
	 <20090108072111.1ebadebd@infradead.org>
Content-Type: text/plain
Date: Thu, 08 Jan 2009 09:46:31 -0600
Message-Id: <1231429591.27353.14.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sync_filesystems() shouldn't be calling async_synchronize_full_special
while holding a spinlock.  The second while loop in that function is the
right place for this anyway.

Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Reported-by: Grissiom <chaos.proton@gmail.com>

diff --git a/fs/super.c b/fs/super.c
index cb20744..7d67387 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -458,7 +458,6 @@ void sync_filesystems(int wait)
 		if (sb->s_flags & MS_RDONLY)
 			continue;
 		sb->s_need_sync_fs = 1;
-		async_synchronize_full_special(&sb->s_async_list);
 	}
 
 restart:
@@ -471,6 +470,7 @@ restart:
 		sb->s_count++;
 		spin_unlock(&sb_lock);
 		down_read(&sb->s_umount);
+		async_synchronize_full_special(&sb->s_async_list);
 		if (sb->s_root && (wait || sb->s_dirt))
 			sb->s_op->sync_fs(sb, wait);
 		up_read(&sb->s_umount);

-- 
David Kleikamp
IBM Linux Technology Center

