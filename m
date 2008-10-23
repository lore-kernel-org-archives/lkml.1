Return-Path: <linux-kernel-owner+w=401wt.eu-S1758301AbYJWSSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758301AbYJWSSW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 14:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757086AbYJWSSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 14:18:04 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:26110 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755990AbYJWSSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 14:18:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=XtXyBqKGT4DcQ2nPAVOAQPJa5YJE84VUcy0gfkuQKlgF23RW02mQr9lwkUNpj/9PlF
         DRhv+DxfpwWZErMaqPdjPIykTIXVhAL6Hnv4B6qaHrNQ8RlZ0QzLvpcniUncrSp7kTxq
         7PkE2yzs02+DW4KpTK3H/+IPhVYEIvzPHohKw=
Message-ID: <4900BFCF.2030707@gmail.com>
Date: Thu, 23 Oct 2008 20:17:51 +0200
From: M Lammertink <michellammertink@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] netlink: fix append of whole original message on negative
 ack.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michel Lammertink <mlammertink <at> ti-wmc.nl>
Signed-off-by: Michel Lammertink <mlammertink <at> ti-wmc.nl>

Netlink can return an negative acknowledgement, which AFAICT should include an error code and the whole original message. This patch fixes the size argument given to the __nlmsg_put call. Without this patch only the original header was attached.
---

Can anyone explain to me why struct nlmsgerr contains an int error and the nlmsghdr struct. The comment in netlink_ack states that the whole message should be appended. Why not only include an int error in struct nlmsgerr and just append the original message?

Comments appreciated.

diff -uprN linux-2.6.27.3.orig/net/netlink/af_netlink.c linux-2.6.27.3/net/netlink/af_netlink.c
--- linux-2.6.27.3.orig/net/netlink/af_netlink.c	2008-10-23 18:01:54.000000000 +0200
+++ linux-2.6.27.3/net/netlink/af_netlink.c	2008-10-23 18:04:22.000000000 +0200
@@ -1656,7 +1656,7 @@ void netlink_ack(struct sk_buff *in_skb,
 	}
 
 	rep = __nlmsg_put(skb, NETLINK_CB(in_skb).pid, nlh->nlmsg_seq,
-			  NLMSG_ERROR, sizeof(struct nlmsgerr), 0);
+			  NLMSG_ERROR, payload, 0);
 	errmsg = nlmsg_data(rep);
 	errmsg->error = err;
 	memcpy(&errmsg->msg, nlh, err ? nlh->nlmsg_len : sizeof(*nlh));
