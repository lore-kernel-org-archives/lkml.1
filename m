Return-Path: <linux-kernel-owner+w=401wt.eu-S1755421AbZCKMvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421AbZCKMvd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 08:51:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754911AbZCKMvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 08:51:19 -0400
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:39541 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755225AbZCKMvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 08:51:18 -0400
Date: Wed, 11 Mar 2009 13:51:08 +0100 (CET)
From: yann.poupet@free.fr
To: linux-kernel@vger.kernel.org
Message-ID: <3848726.1723791236775868071.JavaMail.root@spooler2-g27.priv.proxad.net>
Subject: [PROBLEM]: potential unaligned memory access in
 drivers/usb/gadget/rndis.c
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.243.41]
X-Mailer: Zimbra 5.0.11_GA_2627.UBUNTU8 (zclient/5.0.11_GA_2627.UBUNTU8)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

while working on a 2.6.18.2 kernel on ARM9 arch., I noticed RNDIS module might trigger lots of unaligned access exceptions.
Looks like it comes from rndis_add_hdr() function, which uses pointer from skb_pull as if it is aligned on a 4bytes boundary.

void rndis_add_hdr (struct sk_buff *skb)
{
    struct rndis_packet_msg_type    *header;

    if (!skb)
        return;
    header = (void *) skb_push (skb, sizeof *header);
    memset (header, 0, sizeof *header);
    header->MessageType = __constant_cpu_to_le32(REMOTE_NDIS_PACKET_MSG);
    header->MessageLength = cpu_to_le32(skb->len);
    header->DataOffset = __constant_cpu_to_le32 (36);
    header->DataLength = cpu_to_le32(skb->len - sizeof *header);
}


It happened to me that skb_pull() returns a pointer to a location not aligned on a 4 bytes boundary.

As a quick workaround, I modified the code to:

void rndis_add_hdr (struct sk_buff *skb)
{
    struct rndis_packet_msg_type    *header;
    static struct rndis_packet_msg_type new = {
    __constant_cpu_to_le32(REMOTE_NDIS_PACKET_MSG), /*  MessageType         */
    0,                                              /*  MessageLength       */
    __constant_cpu_to_le32 (36),                    /*  DataOffset          */
    0,                                              /*  DataLength          */
    0,                                              /*  OOBDataOffset       */
    0,                                              /*  OOBDataLength       */
    0,                                              /*  NumOOBDataElements  */
    0,                                              /*  PerPacketInfoOffset */
    0,                                              /*  PerPacketInfoLength */
    0,                                              /*  VcHandle            */
    0,                                              /*  Reserved            */
    };

    if (!skb)
        return;
    header = (void *) skb_push (skb, sizeof *header);
    memset (header, 0, sizeof *header); /* probably not necessary */
    new.MessageLength = cpu_to_le32(skb->len);
    new.DataLength = cpu_to_le32(skb->len - sizeof *header);
    memcpy((u8*)header,(u8*)&new,sizeof(new));
}


and did not have the unaligned exceptions anymore.

I had a look at rndis.c in latest kernel version (2.6.28.7), the rndis_add_hdr() function is the same as for 2.6.18.2.


Hope this helps.


Regards,

Yann Poupet.
