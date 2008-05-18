Return-Path: <linux-kernel-owner+w=401wt.eu-S1761760AbYERS4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761760AbYERS4K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 14:56:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760059AbYERSsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 14:48:23 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:43594 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760572AbYERSsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 14:48:14 -0400
X-Sasl-enc: NeW6NuPGtBKguLeNnnlLeSWNeRl/FmHfKhJTsavd4/J4 1211136492
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-kernel@vger.kernel.org
Cc: Ivo van Doorn <IvDoorn@gmail.com>, Thomas Renninger <trenn@suse.de>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: [PATCH 07/15] rfkill: add parameter to disable radios by default
Date: Sun, 18 May 2008 15:47:57 -0300
Message-Id: <1211136485-19878-8-git-send-email-hmh@hmh.eng.br>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1211136485-19878-1-git-send-email-hmh@hmh.eng.br>
References: <1211136485-19878-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, radios are always enabled when their rfkill interface is
registered.  This is not optimal, the safest state for a radio is to be
offline unless the user turns it on.

Add a module parameter that causes all radios to be disabled when their
rfkill interface is registered.  The module default is not changed so
unless the parameter is used, radios will still be forced to their enabled
state when they are registered.

The new rfkill module parameter is called "default_state".

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 net/rfkill/rfkill.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
index f95081a..3edc585 100644
--- a/net/rfkill/rfkill.c
+++ b/net/rfkill/rfkill.c
@@ -39,6 +39,11 @@ MODULE_LICENSE("GPL");
 static LIST_HEAD(rfkill_list);	/* list of registered rf switches */
 static DEFINE_MUTEX(rfkill_mutex);
 
+static unsigned int rfkill_default_state = RFKILL_STATE_ON;
+module_param_named(default_state, rfkill_default_state, uint, 0444);
+MODULE_PARM_DESC(default_state,
+		 "Default initial state for all radio types, 0 = radio off");
+
 static enum rfkill_state rfkill_states[RFKILL_TYPE_MAX];
 
 
@@ -436,8 +441,12 @@ static int __init rfkill_init(void)
 	int error;
 	int i;
 
+	if (rfkill_default_state != RFKILL_STATE_OFF &&
+	    rfkill_default_state != RFKILL_STATE_ON)
+		return -EINVAL;
+
 	for (i = 0; i < ARRAY_SIZE(rfkill_states); i++)
-		rfkill_states[i] = RFKILL_STATE_ON;
+		rfkill_states[i] = rfkill_default_state;
 
 	error = class_register(&rfkill_class);
 	if (error) {
-- 
1.5.5.1

