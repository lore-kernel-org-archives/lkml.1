Return-Path: <linux-kernel-owner+w=401wt.eu-S932087AbZHNCCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932087AbZHNCCx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 22:02:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754330AbZHNCCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 22:02:53 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39649 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751645AbZHNCCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 22:02:52 -0400
From: Xiaotian Feng <dfeng@redhat.com>
To: jmorris@namei.org, eparis@parisplace.org, sds@tycho.nsa.gov,
       paul.moore@hp.com, serue@us.ibm.com,
       linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Xiaotian Feng <dfeng@redhat.com>
Subject: [PATCH V2] selinux: fix memory leak in sel_make_bools
Date: Fri, 14 Aug 2009 10:02:40 +0800
Message-Id: <1250215360-20871-1-git-send-email-dfeng@redhat.com>
In-Reply-To: <1250151976-19399-1-git-send-email-dfeng@redhat.com>
References: <1250151976-19399-1-git-send-email-dfeng@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In sel_make_bools, kernel allocates memory for bool_pending_names[i]
with security_get_bools. So if we just free bool_pending_names, those
memories for bool_pending_names[i] will be leaked.

This patch resolves dozens of following kmemleak report after resuming
from suspend:
unreferenced object 0xffff88022e4c7380 (size 32):
  comm "init", pid 1, jiffies 4294677173
  backtrace:
    [<ffffffff810f76b5>] create_object+0x1a2/0x2a9
    [<ffffffff810f78bb>] kmemleak_alloc+0x26/0x4b
    [<ffffffff810ef3eb>] __kmalloc+0x18f/0x1b8
    [<ffffffff811cd511>] security_get_bools+0xd7/0x16f
    [<ffffffff811c48c0>] sel_write_load+0x12e/0x62b
    [<ffffffff810f9a39>] vfs_write+0xae/0x10b
    [<ffffffff810f9b56>] sys_write+0x4a/0x6e
    [<ffffffff81011b82>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
---
 security/selinux/selinuxfs.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index b4fc506..1a8a1c2 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -979,6 +979,8 @@ static int sel_make_bools(void)
 	u32 sid;
 
 	/* remove any existing files */
+	for (i = 0; i < bool_num; i++)
+		kfree(bool_pending_names[i]);
 	kfree(bool_pending_names);
 	kfree(bool_pending_values);
 	bool_pending_names = NULL;
-- 
1.6.2.5

