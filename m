Return-Path: <linux-kernel-owner+w=401wt.eu-S1763903AbXKPRiB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763903AbXKPRiB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 12:38:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756781AbXKPRhB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 12:37:01 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:54603 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762677AbXKPRg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 12:36:59 -0500
Message-Id: <20071116173439.796600895@I-love.SAKURA.ne.jp>
User-Agent: quilt/0.46-1
Date: Sat, 17 Nov 2007 02:34:39 +0900
From: penguin-kernel@I-love.SAKURA.ne.jp
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [TOMOYO #5 00/18] TOMOYO Linux - MAC based on process invocation history.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"TOMOYO Linux" is our work in the field of security enhancement for Linux.
You can try TOMOYO Linux 1.5.1 on Ubuntu 7.10's Live CD
http://tomoyo.sourceforge.jp/wiki-e/?TomoyoLive

Changes from previous posting.

 * Made patches against latest -mm tree.

   This time, we made patches for -mm tree.
   Documents about installing and experiencing TOMOYO Linux
   are available at http://tomoyo.sourceforge.jp/en/lkml-5/ .

 * Avoid namespace_sem deadlock.

   To avoid the possibility of AB-BA deadlock
   (see http://lkml.org/lkml/2007/11/5/388 for detail),
   we made patches not to access namespace_sem from LSM.
   Instead, we made some wrapper functions to pass "struct vfsmount"
   to LSM functions in a way of associating "struct vfsmount"
   with "struct task_struct" suggested at
   http://www.mail-archive.com/linux-security-module@vger.kernel.org/msg01712.html .

   We would like to merge either AppArmor's "Pass struct vfsmount to ..." patches or
   our patches marked as [01/18], [02/18], [03/18] into mainline kernel
   so that AppArmor and TOMOYO Linux can safely access "struct vfsmount" from LSM.

 * Avoid rcu_read_lock() by inserting mb() when appending to list.

   I heard from an embedded system developer that holding RCU's read lock
   for long time affects response time since it disables preemption.
   Since list elements are append-only and nobody needs to refer ->prev element,
   we made patches not to call rcu_read_lock() by replacing smp_wmb() with mb().

 * Don't send access logs to auditing system.

   TOMOYO Linux generates two types of logs.
   One is access logs in the form of policy file.
   The other is other messages like warning/info.
   We were sending both logs to auditing system.
   But some users complain about the flooding of access logs on the console.
   Thus, we decided to stop sending access logs to auditing system
   and removed AUDIT_TMY_GRANTED and AUDIT_TMY_REJECTED from include/linux/audit.h .
   Now, we are sending access logs to /sys/kernel/security/tomoyo/ interface.
   Logs other than access logs are sent to auditing system or printk() depending on kernel config.

 * Added capabilities support.

   TOMOYO Linux 2.1 now supports capabilities supported by TOMOYO Linux 1.5.1 .
   But some of them doesn't work due to LSM limitation (i.e. missing hooks).

Patches consist of four types.

 * [TOMOYO 01-03/18]: Essential modifications against -mm kernel.
 * [TOMOYO 04-16/18]: LSM implementation of TOMOYO Linux.
 * [TOMOYO 17/18]:    Makefile and Kconfig.
 * [TOMOYO 18/18]:    Optional modifications against -mm kernel.

--
  Tetsuo Handa
 
