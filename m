Return-Path: <linux-kernel-owner+w=401wt.eu-S932504AbYDUN04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932504AbYDUN04 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 09:26:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760127AbYDUNTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 09:19:20 -0400
Received: from el-out-1112.google.com ([209.85.162.183]:25531 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759550AbYDUNTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 09:19:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:in-reply-to:references:date:subject:cc:from;
        b=o+kjLOm/LGQbF6dzYJpcAwnejMWKOsdYNRJDORcrcbYkP9H1tR7s9hGvQmkCsJJjQVA+zwjF0TtoL5qPzh2fQwuCXm07YHYSwOqvomY57hVG2oPYqMuZd6zvCVUkMynkLyP+IhzX46RRSDlQ4EqhHxxw6u/vyJZvGCfd9jveZp8=
Message-Id: <9e7ddf905834f7b2969464a49e95eb59f4b7b03c.1208783694.git.dmitry.torokhov@gmail.com>
In-Reply-To: <cover.1208783694.git.dmitry.torokhov@gmail.com>
References: <cover.1208783694.git.dmitry.torokhov@gmail.com>
Date: Fri, 18 Apr 2008 00:25:38 -0400
Subject: [PATCH 37/37] Input: mac_hid - add lockdep annotation to emumousebtn
Cc: linux-kernel@vger.kernel.org, jkosina@suse.cz, akpm@linux-foundation.org
From: Peter Zijlstra <dmitry.torokhov@gmail.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mouse button emulation calls input device methods from an input
device. This causes funny lock nesting which is harmless as each
device has its own locks.

Give the nesting device its own lock classes so that lockdep will not
consider them the same.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---
 drivers/macintosh/mac_hid.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/macintosh/mac_hid.c b/drivers/macintosh/mac_hid.c
index 8930230..f972ff3 100644
--- a/drivers/macintosh/mac_hid.c
+++ b/drivers/macintosh/mac_hid.c
@@ -103,6 +103,9 @@ int mac_hid_mouse_emulate_buttons(int caller, unsigned int keycode, int down)
 	return 0;
 }
 
+static struct lock_class_key emumousebtn_event_class;
+static struct lock_class_key emumousebtn_mutex_class;
+
 static int emumousebtn_input_register(void)
 {
 	int ret;
@@ -111,6 +114,9 @@ static int emumousebtn_input_register(void)
 	if (!emumousebtn)
 		return -ENOMEM;
 
+	lockdep_set_class(emumousebtn->event_lock, &emumousebtn_event_class);
+	lockdep_set_class(emumousebtn->mutex, &emumousebtn_mutex_class);
+
 	emumousebtn->name = "Macintosh mouse button emulation";
 	emumousebtn->id.bustype = BUS_ADB;
 	emumousebtn->id.vendor = 0x0001;
-- 
1.5.5.rc2.6.gf58d

