Return-Path: <linux-kernel-owner+w=401wt.eu-S1764414AbXHWPZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764414AbXHWPZf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 11:25:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763336AbXHWPZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 11:25:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49141 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763311AbXHWPZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 11:25:24 -0400
Message-ID: <46CDA6DE.6010102@redhat.com>
Date: Thu, 23 Aug 2007 11:25:18 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: christian.mandery@sap.com, amy.griffis@hp.com
Subject: Race in the inotify debug code
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=248355

Description of problem:
Warnings in the kernel log (dmesg):
BUG: warning at fs/inotify.c:172/set_dentry_child_flags() (Not tainted)
 [<c0497a37>] set_dentry_child_flags+0x67/0x13d
 [<c0497c27>] remove_watch_no_event+0x2f/0x3b
 [<c0497d15>] inotify_remove_watch_locked+0x12/0x3e
 [<c0600c17>] mutex_lock+0x1a/0x29
 [<c0497fdd>] inotify_rm_wd+0x6d/0x8a
 [<c04983b1>] sys_inotify_rm_watch+0x38/0x4f
 [<c0404f70>] syscall_call+0x7/0xb

Appears randomly, about every second/third day.

Still happening in kernel 2.6.22.


static void set_dentry_child_flags(struct inode *inode, int watched)
...
        spin_lock(&dcache_lock);
        list_for_each_entry(alias, &inode->i_dentry, d_alias) {
                struct dentry *child;

                list_for_each_entry(child, &alias->d_subdirs, d_u.d_child) {
                        if (!child->d_inode) {
                                WARN_ON(child->d_flags & DCACHE_INOTIFY_PARENT_WATCHED);
                                continue;
                        }

But in dcache.c, the locks are dropped before this flag is cleared, leaving
a race window:

void d_delete(struct dentry * dentry)
...
        spin_lock(&dcache_lock);
        spin_lock(&dentry->d_lock);
        isdir = S_ISDIR(dentry->d_inode->i_mode);
        if (atomic_read(&dentry->d_count) == 1) {
                dentry_iput(dentry);  <================ drops dcache_lock and dentry->d_lock
                fsnotify_nameremove(dentry, isdir);

                /* remove this and other inotify debug checks after 2.6.18 */
                dentry->d_flags &= ~DCACHE_INOTIFY_PARENT_WATCHED;
                return;
        }

(The comment is nice, it says the debug code should have been removed long ago.)
