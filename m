Return-Path: <linux-kernel-owner+w=401wt.eu-S1754553AbYGGKFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553AbYGGKFm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 06:05:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752535AbYGGKFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 06:05:34 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:59882 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326AbYGGKFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 06:05:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=wqCcuwOH+ayT62l4CExQ48F/mvVxAEUhdMP1hup5PZuCpWAsqKr7oO68GFCggO3VpV
         1eUUBVvzz6KEKEfl8n4CRJEtsxFumhNlqNrWmTzBvcPAdr7eGBuGPMN+a/dzPvBA0jf4
         yuvsdUQaNOMKtzFKT92qHfMjME1MdoDly7qI4=
Subject: [PATCH] drivers/char/pcmcia/ipwireless/hardware.c fix resource leak
From: "Darren Jenkins\\" <darrenrjenkins@gmail.com>
To: kernel Janitors <kernel-janitors@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, jkosina@suse.cz, dsterba@suse.cz
Content-Type: text/plain; charset=UTF-8
Date: Mon, 07 Jul 2008 08:18:10 +1000
Message-Id: <1215382690.11092.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

G'day people,

Coverity CID: 2172 RESOURCE_LEAK

When pool_allocate() tries to enlarge a packet, if it can not allocate
enough memory, it returns NULL without first freeing the old packet.

This patch just frees the packet first.

﻿﻿﻿Signed-off-by: Darren Jenkins <darrenrjenkins@gmailcom>

diff --git a/drivers/char/pcmcia/ipwireless/hardware.c b/drivers/char/pcmcia/ipwireless/hardware.c
index ba6340a..929101e 100644
--- a/drivers/char/pcmcia/ipwireless/hardware.c
+++ b/drivers/char/pcmcia/ipwireless/hardware.c
@@ -590,8 +590,10 @@ static struct ipw_rx_packet *pool_allocate(struct ipw_hardware *hw,
 		packet = kmalloc(sizeof(struct ipw_rx_packet) +
 				old_packet->length + minimum_free_space,
 				GFP_ATOMIC);
-		if (!packet)
+		if (!packet) {
+			kfree(old_packet);
 			return NULL;
+		}
 		memcpy(packet, old_packet,
 				sizeof(struct ipw_rx_packet)
 					+ old_packet->length);
 

