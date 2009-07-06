Return-Path: <linux-kernel-owner+w=401wt.eu-S1754163AbZGFWas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163AbZGFWas (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 18:30:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753606AbZGFWal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 18:30:41 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:37312 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213AbZGFWak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 18:30:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type:content-transfer-encoding;
        b=wbYfw0bKqAxB7nQUSBh5BmD4OD/P6E9WGMB6rMwbPE/HfvvNRf/Y9FnIPOOKXXaGQY
         x5Gzzx0X049zFPgAQ2oqHf6wkt8YoTmiZZT5NDIdgrZgXubUtvsidgWySyZZz8aYIX3z
         405rhb3gPXPe3x90kj6c8ZjvQBonz9uVj4Gak=
MIME-Version: 1.0
Date: Mon, 6 Jul 2009 23:30:41 +0100
X-Google-Sender-Auth: f4f4bb58e874b1d8
Message-ID: <b0943d9e0907061530u2d375fe5x91f92cfee3166c91@mail.gmail.com>
Subject: Possible memory leak in fs/sysfs/bin.c
From: Catalin Marinas <catalin.marinas@arm.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I get about 28 (after 1 hour uptime) kmemleak reports like the one below:

unreferenced object 0xc24ab090 (size 4096):
  comm "cat", pid 2930, jiffies 4294902918
  backtrace:
    [<c01e0c3a>] create_object+0xfa/0x250
    [<c01e1e7d>] kmemleak_alloc+0x5d/0x70
    [<c01dbc2d>] __kmalloc_track_caller+0x10d/0x1e0
    [<c01bf5e4>] memdup_user+0x24/0x70
    [<c02394d9>] write+0xb9/0x1b0
    [<c01e480c>] vfs_write+0x9c/0x190
    [<c01e49bd>] sys_write+0x3d/0x70
    [<c010300c>] sysenter_do_call+0x12/0x38
    [<ffffffff>] 0xffffffff

This is the write() function in the file mention in subject. It looks
to me like commit 1c8542c7bb replaced kmalloc() with memdup_user() but
also dropped the kfree(temp). The memdup_user() function allocates
memory but that's never freed in write().

Maybe something like this:

diff --git a/fs/sysfs/bin.c b/fs/sysfs/bin.c
index 9345806..bde6602 100644
--- a/fs/sysfs/bin.c
+++ b/fs/sysfs/bin.c
@@ -164,6 +164,7 @@ static ssize_t write(struct file *file, const char
__user *userbuf,
 	mutex_lock(&bb->mutex);

 	memcpy(bb->buffer, temp, count);
+	kfree(temp);

 	count = flush_write(dentry, bb->buffer, offs, count);
 	mutex_unlock(&bb->mutex);

-- 
Catalin
