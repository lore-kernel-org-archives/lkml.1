Return-Path: <linux-kernel-owner+w=401wt.eu-S966004AbYD1WWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966004AbYD1WWQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 18:22:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932830AbYD1WV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 18:21:57 -0400
Received: from mail-in-17.arcor-online.net ([151.189.21.57]:50155 "EHLO
	mail-in-17.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932621AbYD1WV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 18:21:57 -0400
Message-ID: <48164E29.4080409@henry.ne.arcor.de>
Date: Tue, 29 Apr 2008 00:22:33 +0200
From: Henry Nestler <Henry.Ne@Arcor.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] x86: endless page faults in mount_block_root for Linux
 2.6
References: <480E6BB4.5080902@henry.nestler.gmail.com> <480E8069.20502@henry.ne.arcor.de> <20080428164634.GC18210@elte.hu>
In-Reply-To: <20080428164634.GC18210@elte.hu>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prevents side effects from non vmalloc and non userspace page faults for
sys_mount of root filesystem with automatic fs_type detection.

do_mount_root should call with page alignment buffer. The underlaying
sys_mount does copy 4096 bytes from given parameter with function
exact_copy_from_user, and the page after "fs_names+4096" can be mapped
or not. The fault handler can never map it, address is not from vmalloc.

Signed-off-by: Henry Nestler <henry.ne@arcor.de>
---

Ingo Molnar wrote:
> * Henry Nestler <Henry.Ne@Arcor.de> wrote:
> 
>> An other fix would be to copy the "fs_names+offset" into a new page 
>> and give a page alignment buffer to do_mount_root. I feel it is better 
>> to fix the fault handler for all failed addresses, not only the mount?
> 
> agreed - but this would be a VFS fix, Al Cc:-ed. I ran into that 
> property of the mount string copy myself in the past.

The patch is a nice to have, if the fault handler works properly.

I'm not shure with the VFS fix. The change only has effect for x86 and
x86_64. I'm afraid. Mostly other architectures no need to change. I
would only public the base of the problem. Perhaps no need to change here.

> (note, your patches were whitespace damaged - i fixed up the x86 fix by 
> hand - you might want to resend the VFS one via 
> Documentation/email-clients.txt.)

Sorry, was wrong copy&paste.

===================================
diff --git a/init/do_mounts.c b/init/do_mounts.c
index 3885e70..c730511 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -204,6 +204,7 @@ static int __init do_mount_root(char *name, char
*fs, int flags, void *data)
 void __init mount_block_root(char *name, int flags)
 {
 	char *fs_names = __getname();
+	char *fs_type = __getname();
 	char *p;
 #ifdef CONFIG_BLOCK
 	char b[BDEVNAME_SIZE];
@@ -214,7 +215,12 @@ void __init mount_block_root(char *name, int flags)
 	get_fs_names(fs_names);
 retry:
 	for (p = fs_names; *p; p += strlen(p)+1) {
-		int err = do_mount_root(name, p, flags, root_mount_data);
+		int err;
+
+		/* fs_type must size >= PAGE_SIZE or in user space */
+		strcpy(fs_type, p);
+
+		err = do_mount_root(name, fs_type, flags, root_mount_data);
 		switch (err) {
 			case 0:
 				goto out;
@@ -251,6 +257,7 @@ retry:
 #endif
 	panic("VFS: Unable to mount root fs on %s", b);
 out:
+	putname(fs_type);
 	putname(fs_names);
 }

