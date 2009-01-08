Return-Path: <linux-kernel-owner+w=401wt.eu-S1759652AbZAHOi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759652AbZAHOi2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 09:38:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752690AbZAHOiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 09:38:14 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:41710 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752491AbZAHOiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 09:38:12 -0500
Subject: Re: "BUG: scheduling while atomic: pdflush/30/0x00000002" in
 latest git
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Grissiom <chaos.proton@gmail.com>
Cc: linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
In-Reply-To: <a0adeea50901080007q5a3ed5c8y5a744ce37e677325@mail.gmail.com>
References: <a0adeea50901080007q5a3ed5c8y5a744ce37e677325@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 08 Jan 2009 08:37:52 -0600
Message-Id: <1231425472.21528.13.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding cc:lix-fsdevel

On Thu, 2009-01-08 at 16:07 +0800, Grissiom wrote:
> When I using the latest git version, I occasionally got this in dmesg:
> 
> [ 2008.237234] BUG: scheduling while atomic: pdflush/30/0x00000002
> [ 2008.237240] 2 locks held by pdflush/30:
> [ 2008.237244]  #0:  (mutex){--..}, at: [<c01a57a1>] sync_filesystems+0x11/0x120
> [ 2008.237258]  #1:  (sb_lock){--..}, at: [<c01a57ab>]
> sync_filesystems+0x1b/0x120
> [ 2008.237277] Modules linked in: fuse ricoh_mmc b43
> [ 2008.237288] Pid: 30, comm: pdflush Not tainted
> 2.6.28-g14-rfkill-nophy-ledon-07485-g9e42d0c #62
> [ 2008.237294] Call Trace:
> [ 2008.237303]  [<c04d7576>] schedule+0x326/0x8e0
> [ 2008.237311]  [<c01500d3>] __lock_acquire+0x293/0xa20
> [ 2008.237321]  [<c014e307>] mark_held_locks+0x67/0x80
> [ 2008.237330]  [<c04da58c>] _spin_unlock_irqrestore+0x4c/0x60
> [ 2008.237339]  [<c014e519>] trace_hardirqs_on_caller+0x149/0x1a0
> [ 2008.237351]  [<c0143d55>] async_synchronize_cookie_special+0xb5/0x140
> [ 2008.237362]  [<c013e1a0>] autoremove_wake_function+0x0/0x40
> [ 2008.237372]  [<c01a57fc>] sync_filesystems+0x6c/0x120
> [ 2008.237381]  [<c017ee90>] pdflush+0x0/0x1e0
> [ 2008.237392]  [<c01c0b90>] do_sync+0x20/0x60
> [ 2008.237402]  [<c01c0bda>] sys_sync+0xa/0x10
> [ 2008.237412]  [<c017ef9e>] pdflush+0x10e/0x1e0
> [ 2008.237420]  [<c014e519>] trace_hardirqs_on_caller+0x149/0x1a0
> [ 2008.237429]  [<c017de80>] laptop_flush+0x0/0x10
> [ 2008.237437]  [<c013dea2>] kthread+0x42/0x70
> [ 2008.237444]  [<c013de60>] kthread+0x0/0x70
> [ 2008.237452]  [<c0103c03>] kernel_thread_helper+0x7/0x14
> (repeat some times)
> 

The offender is
http://git.kernel.org/gitweb.cgi?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=efaee192

async_synchronize_full_special() shouldn't be called while holding a
spinlock, sb_lock.

I think this patch should fix it.  Arjan, would this work?

Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

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

