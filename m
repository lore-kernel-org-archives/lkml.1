Return-Path: <linux-kernel-owner+w=401wt.eu-S933918AbYDWASb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933918AbYDWASb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 20:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755489AbYDWASX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 20:18:23 -0400
Received: from mail-in-09.arcor-online.net ([151.189.21.49]:47305 "EHLO
	mail-in-09.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754994AbYDWASV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 20:18:21 -0400
Message-ID: <480E8069.20502@henry.ne.arcor.de>
Date: Wed, 23 Apr 2008 02:18:49 +0200
From: Henry Nestler <Henry.Ne@Arcor.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: endless page faults in mount_block_root for Linux
 2.6
References: <480E6BB4.5080902@henry.nestler.gmail.com>
In-Reply-To: <480E6BB4.5080902@henry.nestler.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An other fix would be to copy the "fs_names+offset" into a new page and
give a page alignment buffer to do_mount_root. I feel it is better to
fix the fault handler for all failed addresses, not only the mount?

--- linux-2.6.25/init/do_mounts.c
+++ linux-2.6.25/init/do_mounts.c
@@ -204,6 +204,7 @@
 void __init mount_block_root(char *name, int flags)
 {
        char *fs_names = __getname();
+       char *fs_type = __getname();
        char *p;
 #ifdef CONFIG_BLOCK
        char b[BDEVNAME_SIZE];
@@ -214,7 +215,12 @@
        get_fs_names(fs_names);
 retry:
        for (p = fs_names; *p; p += strlen(p)+1) {
-               int err = do_mount_root(name, p, flags, root_mount_data);
+               int err;
+
+               /* fs_type must size >= PAGE_SIZE or in user space */
+               strcpy(fs_type, p);
+
+               err = do_mount_root(name, fs_type, flags, root_mount_data);
                switch (err) {
                        case 0:
                                goto out;
@@ -251,6 +257,7 @@
 #endif
        panic("VFS: Unable to mount root fs on %s", b);
 out:
+       putname(fs_type);
        putname(fs_names);
 }


-- 
Henry N.
