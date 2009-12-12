Return-Path: <linux-kernel-owner+w=401wt.eu-S1757312AbZLMCRL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312AbZLMCRL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 21:17:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756865AbZLMCRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 21:17:10 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:48617 "HELO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751738AbZLMCRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 21:17:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=FNuRapslPtO+tKdnqgP7fKFkmKhSya2W6uzH3Q9cARzvj/pTeBjBSvBoNSdY3kAamz
         OUOu2z/6HLFuH2ga4Dv2vz8Li4MWGOAVj/atnUWjLrKgP7JLG2qHuUUcH5WeQAwncXDe
         Ey1ZofTO0GrDE7EsoGRBzyyHN0/Vxvj2eidOU=
MIME-Version: 1.0
In-Reply-To: <a4423d670912111406g5967eb1fw93e49de242fbf54@mail.gmail.com>
References: <a4423d670912111406g5967eb1fw93e49de242fbf54@mail.gmail.com>
Date: Sat, 12 Dec 2009 23:51:29 +0300
Message-ID: <a4423d670912121251l50f52791lc776a5c88434e39b@mail.gmail.com>
Subject: Re: 2.6.33-rc0: reiserfs: inconsistent lock state
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One more warning.
This is No space left situation.

[ INFO: possible circular locking dependency detected ]
2.6.32-06486-g053fe57 #2
-------------------------------------------------------
vi/23454 is trying to acquire lock:
 (&journal->j_mutex){+.+...}, at: [<c110dac4>] do_journal_begin_r+0x64/0x2f0

but task is already holding lock:
 (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c11106a8>] reiserfs_write_lock+0x28/0x40

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&REISERFS_SB(s)->lock){+.+.+.}:
       [<c104f8f3>] validate_chain+0xa23/0xf70
       [<c1050325>] __lock_acquire+0x4e5/0xa70
       [<c105092a>] lock_acquire+0x7a/0xa0
       [<c134c78f>] mutex_lock_nested+0x5f/0x2b0
       [<c11106a8>] reiserfs_write_lock+0x28/0x40
       [<c110dacb>] do_journal_begin_r+0x6b/0x2f0
       [<c110ddcf>] journal_begin+0x7f/0x120
       [<c10f76c2>] reiserfs_remount+0x212/0x4d0
       [<c1093997>] do_remount_sb+0x67/0x140
       [<c10a9ca6>] do_mount+0x436/0x6b0
       [<c10a9f86>] sys_mount+0x66/0xa0
       [<c1002c50>] sysenter_do_call+0x12/0x36

-> #0 (&journal->j_mutex){+.+...}:
       [<c104fe38>] validate_chain+0xf68/0xf70
       [<c1050325>] __lock_acquire+0x4e5/0xa70
       [<c105092a>] lock_acquire+0x7a/0xa0
       [<c134c78f>] mutex_lock_nested+0x5f/0x2b0
       [<c110dac4>] do_journal_begin_r+0x64/0x2f0
       [<c110ddcf>] journal_begin+0x7f/0x120
       [<c10ef52f>] reiserfs_delete_inode+0x9f/0x140
       [<c10a55fc>] generic_delete_inode+0x9c/0x150
       [<c10a56ed>] generic_drop_inode+0x3d/0x60
       [<c10a4607>] iput+0x47/0x50
       [<c10e915c>] reiserfs_create+0x16c/0x1c0
       [<c109a9c1>] vfs_create+0xc1/0x130
       [<c109dbec>] do_filp_open+0x81c/0x920
       [<c109004f>] do_sys_open+0x4f/0x110
       [<c1090179>] sys_open+0x29/0x40
       [<c1002c50>] sysenter_do_call+0x12/0x36

other info that might help us debug this:

2 locks held by vi/23454:
 #0:  (&sb->s_type->i_mutex_key#5){+.+.+.}, at: [<c109d64e>]
do_filp_open+0x27e/0x920
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c11106a8>]
reiserfs_write_lock+0x28/0x40

stack backtrace:
Pid: 23454, comm: vi Not tainted 2.6.32-06486-g053fe57 #2
Call Trace:
 [<c134b202>] ? printk+0x18/0x1e
 [<c104e960>] print_circular_bug+0xc0/0xd0
 [<c104fe38>] validate_chain+0xf68/0xf70
 [<c104ca9b>] ? trace_hardirqs_off+0xb/0x10
 [<c1050325>] __lock_acquire+0x4e5/0xa70
 [<c105092a>] lock_acquire+0x7a/0xa0
 [<c110dac4>] ? do_journal_begin_r+0x64/0x2f0
 [<c134c78f>] mutex_lock_nested+0x5f/0x2b0
 [<c110dac4>] ? do_journal_begin_r+0x64/0x2f0
 [<c110dac4>] ? do_journal_begin_r+0x64/0x2f0
 [<c110ff80>] ? delete_one_xattr+0x0/0x1c0
 [<c110dac4>] do_journal_begin_r+0x64/0x2f0
 [<c110ddcf>] journal_begin+0x7f/0x120
 [<c11105b5>] ? reiserfs_delete_xattrs+0x15/0x50
 [<c10ef52f>] reiserfs_delete_inode+0x9f/0x140
 [<c10a55bf>] ? generic_delete_inode+0x5f/0x150
 [<c10ef490>] ? reiserfs_delete_inode+0x0/0x140
 [<c10a55fc>] generic_delete_inode+0x9c/0x150
 [<c10a56ed>] generic_drop_inode+0x3d/0x60
 [<c10a4607>] iput+0x47/0x50
 [<c10e915c>] reiserfs_create+0x16c/0x1c0
 [<c1099a5d>] ? inode_permission+0x7d/0xa0
 [<c109a9c1>] vfs_create+0xc1/0x130
 [<c10e8ff0>] ? reiserfs_create+0x0/0x1c0
 [<c109dbec>] do_filp_open+0x81c/0x920
 [<c104ca9b>] ? trace_hardirqs_off+0xb/0x10
 [<c134dc0d>] ? _spin_unlock+0x1d/0x20
 [<c10a6eea>] ? alloc_fd+0xba/0xf0
 [<c109004f>] do_sys_open+0x4f/0x110
 [<c1090179>] sys_open+0x29/0x40
 [<c1002c50>] sysenter_do_call+0x12/0x36
