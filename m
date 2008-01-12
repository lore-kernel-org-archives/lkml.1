Return-Path: <linux-kernel-owner+w=401wt.eu-S1762039AbYALUMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762039AbYALUMq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 15:12:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756905AbYALUMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 15:12:39 -0500
Received: from mail.queued.net ([207.210.101.209]:3720 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755277AbYALUMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 15:12:39 -0500
Date: Sat, 12 Jan 2008 15:12:52 -0500
From: Andres Salomon <dilinger@queued.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: dtor@mail.ru, linux-input@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] input: psmouse: fix input_dev leak in lifebook driver
Message-ID: <20080112151252.193d6b52@ephemeral>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The lifebook driver may register a second input device, but it never
unregisters it.  This fixes that.

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 drivers/input/mouse/lifebook.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/input/mouse/lifebook.c b/drivers/input/mouse/lifebook.c
index 9ec57d8..df81b0a 100644
--- a/drivers/input/mouse/lifebook.c
+++ b/drivers/input/mouse/lifebook.c
@@ -225,8 +225,13 @@ static void lifebook_set_resolution(struct psmouse *psmouse, unsigned int resolu
 
 static void lifebook_disconnect(struct psmouse *psmouse)
 {
+	struct lifebook_data *priv = psmouse->private;
+
 	psmouse_reset(psmouse);
-	kfree(psmouse->private);
+	if (priv) {
+		input_unregister_device(priv->dev2);
+		kfree(priv);
+	}
 	psmouse->private = NULL;
 }
 
-- 
1.5.3.5

