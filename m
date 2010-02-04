Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750979Ab0BDRir (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:38:47 -0500
Received: from kroah.org ([198.145.64.141]:34563 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758437Ab0BDRV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:21:26 -0500
X-Mailbox-Line: From linux@linux.site Thu Feb  4 09:14:48 2010
Message-Id: <20100204171447.772643353@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 04 Feb 2010 09:11:33 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Anatolij Gustschin <agust@denx.de>,
       Kashyap Desai <kashyap.desai@lsi.com>,
       James Bottomley <James.Bottomley@suse.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [02/74] [SCSI] mptsas: Fix issue with chain pools allocation on katmai
In-Reply-To: <20100204171850.GA16539@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Anatolij Gustschin <agust@denx.de>

commit f1053a7ca9ce095d95bcc1cf41684c5e4f3e7751 upstream.

Since commit 9d2e9d66a3f032667934144cd61c396ba49f090d
mptsas driver fails to allocate memory for the MPT chain buffers
for second LSI adapter on PPC440SPe Katmai platform:
...
ioc1: LSISAS1068E B3: Capabilities={Initiator}
mptbase: ioc1: ERROR - Unable to allocate Reply, Request, Chain Buffers!
mptbase: ioc1: ERROR - didn't initialize properly! (-3)
mptsas: probe of 0002:31:00.0 failed with error -3

This commit increased MPT_FC_CAN_QUEUE value but initChainBuffers()
doesn't differentiate between SAS and FC causing increased allocation
for SAS case, too. Later pci_alloc_consistent() fails to allocate
increased chain buffer pool size for SAS case.

Provide a fix by looking at the bus type and using appropriate
MPT_SAS_CAN_QUEUE value while calculation of the number of chain
buffers.

Signed-off-by: Anatolij Gustschin <agust@denx.de>
Acked-by: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/message/fusion/mptbase.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -4330,6 +4330,8 @@ initChainBuffers(MPT_ADAPTER *ioc)
 
 	if (ioc->bus_type == SPI)
 		num_chain *= MPT_SCSI_CAN_QUEUE;
+	else if (ioc->bus_type == SAS)
+		num_chain *= MPT_SAS_CAN_QUEUE;
 	else
 		num_chain *= MPT_FC_CAN_QUEUE;
 


