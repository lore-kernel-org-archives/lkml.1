Return-Path: <linux-kernel-owner+w=401wt.eu-S1753598AbYFAQxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598AbYFAQxe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 12:53:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751119AbYFAQx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 12:53:27 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:48868 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101AbYFAQx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 12:53:27 -0400
Date: Sun, 1 Jun 2008 20:55:06 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] coredump: binfmt_elf{,_fdpic}.c: don't abuse GFP_ATOMIC
Message-ID: <20080601165506.GA8880@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kmalloc(GFP_ATOMIC) was needed because it was called under tasklist_lock.
The code was changed to use rcu_read_lock(), we can use GFP_KERNEL.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

 binfmt_elf.c       |    4 ++--
 binfmt_elf_fdpic.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- 26-rc2/fs/binfmt_elf.c~NO_ATOMIC	2008-05-18 15:43:59.000000000 +0400
+++ 26-rc2/fs/binfmt_elf.c	2008-06-01 20:47:08.000000000 +0400
@@ -1524,7 +1524,7 @@ static int fill_note_info(struct elfhdr 
 		if (p->mm == dump_task->mm) {
 			t = kzalloc(offsetof(struct elf_thread_core_info,
 					     notes[info->thread_notes]),
-				    GFP_ATOMIC);
+				    GFP_KERNEL);
 			if (unlikely(!t)) {
 				rcu_read_unlock();
 				return 0;
@@ -1726,7 +1726,7 @@ static int fill_note_info(struct elfhdr 
 		rcu_read_lock();
 		do_each_thread(g, p)
 			if (current->mm == p->mm && current != p) {
-				ets = kzalloc(sizeof(*ets), GFP_ATOMIC);
+				ets = kzalloc(sizeof(*ets), GFP_KERNEL);
 				if (!ets) {
 					rcu_read_unlock();
 					return 0;
--- 26-rc2/fs/binfmt_elf_fdpic.c~NO_ATOMIC	2008-05-18 15:43:59.000000000 +0400
+++ 26-rc2/fs/binfmt_elf_fdpic.c	2008-06-01 20:47:20.000000000 +0400
@@ -1626,7 +1626,7 @@ static int elf_fdpic_core_dump(long sign
 		rcu_read_lock();
 		do_each_thread(g,p)
 			if (current->mm == p->mm && current != p) {
-				tmp = kzalloc(sizeof(*tmp), GFP_ATOMIC);
+				tmp = kzalloc(sizeof(*tmp), GFP_KERNEL);
 				if (!tmp) {
 					rcu_read_unlock();
 					goto cleanup;

