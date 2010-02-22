Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360Ab0BVQkf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 11:40:35 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:59316 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746Ab0BVQkd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 11:40:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=k3GzGAdBVbtlw5AHkrxiS+v0/vOjtdAt59r2fg18FP/2EYPZrOQWng785dV1yf6sth
         iJ/UCoKhjpUuX2D5/+ztarsucZGFejfuamrMQjXQUZeD+pisgDvjL+CPtvdYXwyO4UN0
         LD6dOBlVM1I9XPGeiOAjS2yCuQawFIgbjZzok=
MIME-Version: 1.0
In-Reply-To: <a9e22dff1002220826p63209a33n27e84ea10e191a19@mail.gmail.com>
References: <a9e22dff1002220826p63209a33n27e84ea10e191a19@mail.gmail.com>
From: niam <niam.niam@gmail.com>
Date: Mon, 22 Feb 2010 18:40:11 +0200
Message-ID: <a9e22dff1002220840x7e86a1a0i3d44cefc1c6a79c0@mail.gmail.com>
Subject: [PATCH] jffs2: fix memory leak if the sector was successfully erased
To: David Woodhouse <dwmw2@infradead.org>, Joe Perches <joe@perches.com>,
       Joakim Tjernlund <Joakim.Tjernlund@transmode.se>,
       linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resending patch to proper people/mailing list.

Memory allocated for erase instruction is not freed if the sector was
successfully erased.

Signed-off-by: Dmytro Milinevskyy <niam.niam@gmail.com>
---
 fs/jffs2/erase.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/jffs2/erase.c b/fs/jffs2/erase.c
index b47679b..c0a5604 100644
--- a/fs/jffs2/erase.c
+++ b/fs/jffs2/erase.c
@@ -74,8 +74,10 @@ static void jffs2_erase_block(struct jffs2_sb_info *c,
       ((struct erase_priv_struct *)instr->priv)->c = c;

       ret = c->mtd->erase(c->mtd, instr);
-       if (!ret)
+       if (!ret) {
+        kfree(instr);
               return;
+    }

       bad_offset = instr->fail_addr;
       kfree(instr);
