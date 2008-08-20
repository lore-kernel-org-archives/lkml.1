Return-Path: <linux-kernel-owner+w=401wt.eu-S1759561AbYHTPSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759561AbYHTPSr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 11:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753752AbYHTPSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 11:18:38 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:32516 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452AbYHTPSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 11:18:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=uLVwR1UKIgTyOW7oc6GXzNiiDOZ/pJDtE6bxJYF4QzqeqB4IS0BpdsoTaYBT63PaR2
         i7ZLcFPJzSaKlnGnpMq9z/lGePcQHnFXp9rg4d4Qg6OnBjFNOmpv5L2xWw/V8d076DEo
         5RHaUOFg8SH63ZGr+pCi/DeVX0KYoj/PVs3Fk=
Message-ID: <a4423d670808200818i46c4d582r9aac4060903c2d53@mail.gmail.com>
Date: Wed, 20 Aug 2008 19:18:36 +0400
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: alan@redhat.com
Subject: Re: linux-next: Tree for August 20: tty: possible recursive locking detected
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
I got this on sparc64 system.

[   91.266507] [ INFO: possible recursive locking detected ]
[   91.266862] 2.6.27-rc3-next-20080820-dirty #3
[   91.267170] ---------------------------------------------
[   91.267522] sshd/1455 is trying to acquire lock:
[   91.267840]  (&tty->termios_mutex){--..}, at: [<00000000005b8ca0>]
tty_do_resize+0x44/0x128
[   91.268405]
[   91.268411] but task is already holding lock:
[   91.268885]  (&tty->termios_mutex){--..}, at: [<00000000005b8c74>]
tty_do_resize+0x18/0x128
[   91.269436]
[   91.269442] other info that might help us debug this:
[   91.269944] 1 lock held by sshd/1455:
[   91.270219]  #0:  (&tty->termios_mutex){--..}, at:
[<00000000005b8c74>] tty_do_resize+0x18/0x128
[   91.270812]
[   91.270818] stack backtrace:
[   91.271229] Call Trace:
[   91.271474]  [000000000047757c] __lock_acquire+0xfcc/0x1900
[   91.271839]  [0000000000477f0c] lock_acquire+0x5c/0x74
[   91.272198]  [00000000006af2a8] mutex_lock_nested+0xf0/0x310
[   91.272565]  [00000000005b8ca0] tty_do_resize+0x44/0x128
[   91.272916]  [00000000005ba3cc] tty_ioctl+0x360/0x99c
[   91.273266]  [00000000004c0050] vfs_ioctl+0x2c/0x94
[   91.273600]  [00000000004c03b4] do_vfs_ioctl+0x2fc/0x31c
[   91.273953]  [00000000004c0408] sys_ioctl+0x34/0x5c
[   91.274296]  [00000000004e98f0] do_ioctl32_pointer+0x18/0x2c
[   91.274666]  [00000000004ebb04] compat_sys_ioctl+0x3b8/0x40c
[   91.275043]  [0000000000406154] linux_sparc_syscall32+0x34/0x40


It was dirtied by the following patch from David Howells
[PATCH] CRED: Further fix execve error handling

diff --git a/fs/compat.c b/fs/compat.c
index af24b8a..918f0f2 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1373,7 +1373,7 @@ int compat_do_execve(char * filename,
        file = open_exec(filename);
        retval = PTR_ERR(file);
        if (IS_ERR(file))
-               goto out_unlock;
+               goto out_free;

        sched_exec();

@@ -1427,6 +1427,7 @@ out_file:
                allow_write_access(bprm->file);
                fput(bprm->file);
        }
+       goto out_free;

 out_unlock:
        mutex_unlock(&current->cred_exec_mutex);
diff --git a/fs/exec.c b/fs/exec.c
index 4b31a72..7b71679 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1319,7 +1319,7 @@ int do_execve(char * filename,
        file = open_exec(filename);
        retval = PTR_ERR(file);
        if (IS_ERR(file))
-               goto out_unlock;
+               goto out_free;

        sched_exec();

@@ -1376,6 +1376,7 @@ out_file:
                allow_write_access(bprm->file);
                fput(bprm->file);
        }
+       goto out_free;

 out_unlock:
        mutex_unlock(&current->cred_exec_mutex);
