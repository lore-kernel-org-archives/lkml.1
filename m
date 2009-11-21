Return-Path: <linux-kernel-owner+w=401wt.eu-S1754945AbZKVMSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945AbZKVMSg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 07:18:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754866AbZKVMSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 07:18:35 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:57514 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980AbZKVMSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 07:18:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=INwnaQZvI9QQwpEd3iUkQ7/6eGhFMoYbJVpATnQB5JINvFcTPFVSKRmDg1jEgJgaKa
         PvKYzzcl42sCIimc1+fxsqiBlqrhwmw3qlh4TKM072SzOyjIp76SwNUwjHkmv9g2HwPo
         w5fUVWtIzMV6m/8m1sS5ucVWv52KBciVd0fQ0=
From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
Subject: [PATCH 2/2] pid: reduce code size by using a pointer to iterate over array
Date: Sat, 21 Nov 2009 10:16:20 -0200
Message-Id: <5aa52119c3a7c541e2d488478d6d7da920e7cdb6.1258805412.git.andre.goddard@gmail.com>
X-Mailer: git-send-email 1.6.5.3.298.g39add
In-Reply-To: <cover.1258805412.git.andre.goddard@gmail.com>
References: <cover.1258805412.git.andre.goddard@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It decreases code size by 16 bytes on my gcc 4.4.1 on Core 2:
  text    data     bss     dec     hex filename
  4314    2216       8    6538    198a kernel/pid.o-BEFORE
  4298    2216       8    6522    197a kernel/pid.o-AFTER

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>
---
 kernel/pid.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index 55fd590..2e17c9c 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -269,12 +269,11 @@ struct pid *alloc_pid(struct pid_namespace *ns)
 	for (type = 0; type < PIDTYPE_MAX; ++type)
 		INIT_HLIST_HEAD(&pid->tasks[type]);
 
+	upid = pid->numbers + ns->level;
 	spin_lock_irq(&pidmap_lock);
-	for (i = ns->level; i >= 0; i--) {
-		upid = &pid->numbers[i];
+	for ( ; upid >= pid->numbers; --upid)
 		hlist_add_head_rcu(&upid->pid_chain,
 				&pid_hash[pid_hashfn(upid->nr, upid->ns)]);
-	}
 	spin_unlock_irq(&pidmap_lock);
 
 out:
-- 
1.6.5.3.298.g39add

