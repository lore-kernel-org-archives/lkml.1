Return-Path: <linux-kernel-owner+w=401wt.eu-S933194AbXAaRow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933194AbXAaRow (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 12:44:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933204AbXAaRow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 12:44:52 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:34149 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933194AbXAaRov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 12:44:51 -0500
Date: Wed, 31 Jan 2007 12:38:06 -0500
From: Jeff Dike <jdike@addtoit.com>
Cc: linux-kernel@vger.kernel.org
Subject: mm-search_binary_handler-mem-limit-fix is horribly broken
Message-ID: <20070131173656.GA5789@ccure.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It works on i386 only by accident, and doesn't work at all with UML.

start_thread, which is called from inside the set_fs(USER_DS) -
set_fs(oldfs) does set_fs(USER_DS).  That is then blown away by the
set_fs(oldfs).

A one-line fix might be

Index: linux-2.6.17/fs/exec.c
===================================================================
--- linux-2.6.17.orig/fs/exec.c 2007-01-31 12:10:08.000000000 -0500
+++ linux-2.6.17/fs/exec.c      2007-01-31 12:41:15.000000000 -0500
@@ -1079,6 +1079,7 @@ int search_binary_handler(struct linux_b
                                continue;
                        read_unlock(&binfmt_lock);
                        retval = fn(bprm, regs);
+                       oldfs = get_fs();
                        if (retval >= 0) {
                                put_binfmt(fmt);
                                allow_write_access(bprm->file);

but this seems like it's pasting one kludge on top of another.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
