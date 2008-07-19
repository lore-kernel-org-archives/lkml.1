Return-Path: <linux-kernel-owner+w=401wt.eu-S1753293AbYGSHhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293AbYGSHhT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 03:37:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751417AbYGSHhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 03:37:06 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:41772 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751282AbYGSHhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 03:37:05 -0400
Message-ID: <416453059.30160@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: jszhang3@mail.ustc.edu.cn
Date: Sat, 19 Jul 2008 15:35:41 +0800
From: JiSheng Zhang <jszhang3@mail.ustc.edu.cn>
To: stefanr@s5r6.in-berlin.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] firewire:queue the right number of data
Message-Id: <20080719153541.70eb7f17.jszhang3@mail.ustc.edu.cn>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There will be 4 padding bytes in struct fw_cdev_event_response on some platforms
The member:__u32 data will point to these padding bytes. While queue the
response and data in complete_transaction in fw-cdev.c, it will queue like this:
|response(excluding padding bytes)|4 padding bytes|4 padding bytes|data. 
It queue 4 extra bytes. That is to say it use "&response + sizeof(response)"
while other place of kernel and userspace library use "&response + offsetof
(typeof(response), data)". So it will lost the last 4 bytes of data.This patch 
can fix it while not changing the struct definition.

Sorry for open a new ticket.

Signed-off-by: JiSheng Zhang <jszhang3@mail.ustc.edu.cn>

--- old/drivers/firewire/fw-cdev.c
+++ new/drivers/firewire/fw-cdev.c
@@ -382,9 +382,9 @@
 
 	response->response.type   = FW_CDEV_EVENT_RESPONSE;
 	response->response.rcode  = rcode;
-	queue_event(client, &response->event,
-		    &response->response, sizeof(response->response),
-		    response->response.data, response->response.length);
+	queue_event(client, &response->event, &response->response, 
+		    sizeof(response->response) + response->response.length,
+		    NULL, 0);
 }
 
 static int ioctl_send_request(struct client *client, void *buffer)
