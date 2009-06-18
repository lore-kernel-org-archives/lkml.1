Return-Path: <linux-kernel-owner+w=401wt.eu-S1757306AbZFRR5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757306AbZFRR5V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 13:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754187AbZFRR4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 13:56:00 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:62273 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858AbZFRRzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 13:55:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Michal Simek <monstr@monstr.eu>
Cc: microblaze-uclinux@itee.uq.edu.au, LKML <linux-kernel@vger.kernel.org>,
       Remis Lima Baima <remis.developer@googlemail.com>,
       Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 11/11] microblaze: remove sys_ipc
Date: Thu, 18 Jun 2009 19:55:35 +0200
Message-Id: <5733df92e4c432461567786f71cc170f7c25bc78.1245347640.git.arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <cover.1245345894.git.arnd@arndb.de>
References: <cover.1245345894.git.arnd@arndb.de>
In-Reply-To: <24d10c58e2739bacec05d641ab2a2c95ce6d69a9.1245347640.git.arnd@arndb.de>
References: <24d10c58e2739bacec05d641ab2a2c95ce6d69a9.1245347640.git.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX183yZ//Dau/lvcwDLe7xyMz5AAvueOetMP7E7Z
 yECMC7tVlIim7zq/cMrrHH298Uf+gv5wuQUAdqUXOpD41SysEn
 icQWvO5I2n9j5ayRH1lVQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ipc system call is now unused in microblaze,
as the system call table points directly to the
indidual system calls for IPC.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/microblaze/kernel/sys_microblaze.c |   99 -------------------------------
 1 files changed, 0 insertions(+), 99 deletions(-)

diff --git a/arch/microblaze/kernel/sys_microblaze.c b/arch/microblaze/kernel/sys_microblaze.c
index 61080a2..5f1e706 100644
--- a/arch/microblaze/kernel/sys_microblaze.c
+++ b/arch/microblaze/kernel/sys_microblaze.c
@@ -34,105 +34,6 @@
 #include <linux/unistd.h>
 
 #include <asm/syscalls.h>
-/*
- * sys_ipc() is the de-multiplexer for the SysV IPC calls..
- *
- * This is really horribly ugly. This will be remove with new toolchain.
- */
-asmlinkage long
-sys_ipc(uint call, int first, int second, int third, void *ptr, long fifth)
-{
-	int version, ret;
-
-	version = call >> 16; /* hack for backward compatibility */
-	call &= 0xffff;
-
-	ret = -EINVAL;
-	switch (call) {
-	case SEMOP:
-		ret = sys_semop(first, (struct sembuf *)ptr, second);
-		break;
-	case SEMGET:
-		ret = sys_semget(first, second, third);
-		break;
-	case SEMCTL:
-	{
-		union semun fourth;
-
-		if (!ptr)
-			break;
-		ret = (access_ok(VERIFY_READ, ptr, sizeof(long)) ? 0 : -EFAULT)
-				|| (get_user(fourth.__pad, (void **)ptr)) ;
-		if (ret)
-			break;
-		ret = sys_semctl(first, second, third, fourth);
-		break;
-	}
-	case MSGSND:
-		ret = sys_msgsnd(first, (struct msgbuf *) ptr, second, third);
-		break;
-	case MSGRCV:
-		switch (version) {
-		case 0: {
-			struct ipc_kludge tmp;
-
-			if (!ptr)
-				break;
-			ret = (access_ok(VERIFY_READ, ptr, sizeof(tmp))
-				? 0 : -EFAULT) || copy_from_user(&tmp,
-				(struct ipc_kludge *) ptr, sizeof(tmp));
-			if (ret)
-				break;
-			ret = sys_msgrcv(first, tmp.msgp, second, tmp.msgtyp,
-					third);
-			break;
-			}
-		default:
-			ret = sys_msgrcv(first, (struct msgbuf *) ptr,
-					second, fifth, third);
-			break;
-		}
-		break;
-	case MSGGET:
-		ret = sys_msgget((key_t) first, second);
-		break;
-	case MSGCTL:
-		ret = sys_msgctl(first, second, (struct msqid_ds *) ptr);
-		break;
-	case SHMAT:
-		switch (version) {
-		default: {
-			ulong raddr;
-			ret = access_ok(VERIFY_WRITE, (ulong *) third,
-					sizeof(ulong)) ? 0 : -EFAULT;
-			if (ret)
-				break;
-			ret = do_shmat(first, (char *) ptr, second, &raddr);
-			if (ret)
-				break;
-			ret = put_user(raddr, (ulong *) third);
-			break;
-			}
-		case 1:	/* iBCS2 emulator entry point */
-			if (!segment_eq(get_fs(), get_ds()))
-				break;
-			ret = do_shmat(first, (char *) ptr, second,
-					(ulong *) third);
-			break;
-		}
-		break;
-	case SHMDT:
-		ret = sys_shmdt((char *)ptr);
-		break;
-	case SHMGET:
-		ret = sys_shmget(first, second, third);
-		break;
-	case SHMCTL:
-		ret = sys_shmctl(first, second, (struct shmid_ds *) ptr);
-		break;
-	}
-	return ret;
-}
 
 asmlinkage long microblaze_vfork(struct pt_regs *regs)
 {
-- 
1.6.3.1

