Return-Path: <linux-kernel-owner+w=401wt.eu-S1755703AbYKEObt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703AbYKEObt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 09:31:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751637AbYKEObj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 09:31:39 -0500
Received: from mx2.redhat.com ([66.187.237.31]:44036 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751550AbYKEObi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 09:31:38 -0500
Date: Wed, 5 Nov 2008 15:31:40 +0100
From: Jiri Pirko <jpirko@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-input@vger.kernel.org, dmitry.torokhov@gmail.com, oleg@redhat.com
Subject: [PATCH] atkbd: cancel delayed work before freeing its structure
Message-ID: <20081105153140.25132ca1@psychotron.englab.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pointed out by Oleg Nesterov. Since delayed work is used here, use of
flush_scheduled_work() is not sufficient in atkbd_disconnect(). It does
not wait for scheduled delayed work to finish. This patch prevents
delayed work to be processed after freeing atkbd structure (used struct
delayed_work is part of atkbd) by cancelling this delayed work.

Jirka

Signed-off-by: Jiri Pirko <jpirko@redhat.com>
---
 drivers/input/keyboard/atkbd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/input/keyboard/atkbd.c b/drivers/input/keyboard/atkbd.c
index 22016ca..f3bbf49 100644
--- a/drivers/input/keyboard/atkbd.c
+++ b/drivers/input/keyboard/atkbd.c
@@ -824,7 +824,7 @@ static void atkbd_disconnect(struct serio *serio)
 	atkbd_disable(atkbd);
 
 	/* make sure we don't have a command in flight */
-	flush_scheduled_work();
+	cancel_delayed_work_sync(&atkbd->event_work);
 
 	sysfs_remove_group(&serio->dev.kobj, &atkbd_attribute_group);
 	input_unregister_device(atkbd->dev);
-- 
1.5.6.5

