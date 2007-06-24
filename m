Return-Path: <linux-kernel-owner+w=401wt.eu-S1754723AbXFXXHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723AbXFXXHr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 19:07:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751004AbXFXXHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 19:07:39 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:30454 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbXFXXHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 19:07:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=E3oVMJ3CD8v9Fngk8NCEfyua63cpQLfiZPf6gZFE0ZewwkG9jVSLLnYExNf5hACU+eKRvvJrOIu5ZM50jUFNB7zhagKOImkLkx1V/4WIFJPwexSnErwzsTabX87XEVO8H8FzM+AyDMlllxSYJATnml/Jznxjwj389ceuD5XAD2I=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: isdn4linux@listserv.isdn4linux.de
Subject: [PATCH][ISDN] fix possible NULL deref on low memory condition in capidrv.c::send_message()
Date: Mon, 25 Jun 2007 01:07:37 +0200
User-Agent: KMail/1.9.7
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Carsten Paeth <calle@calle.de>, Karsten Keil <kkeil@suse.de>,
       Kai Germaschewski <kai.germaschewski@gmx.de>,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706250107.37968.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


If we fail to allocate an skb in 
drivers/isdn/capi/capidrv.c::send_message(), then we'll end up 
dereferencing a NULL pointer.
Since out of memory conditions are not unheard of, I believe it 
is better to print a error message and just return rather than 
bring down the whole kernel. 
Sure, doing this may upset some application, but that's still 
better than crashing the whole system.

(ps. please Cc me on replies from the isdn4linux list since I'm not subscribed 
 there)


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 drivers/isdn/capi/capidrv.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/isdn/capi/capidrv.c b/drivers/isdn/capi/capidrv.c
index 23b6f7b..476012b 100644
--- a/drivers/isdn/capi/capidrv.c
+++ b/drivers/isdn/capi/capidrv.c
@@ -506,9 +506,14 @@ static void send_message(capidrv_contr * card, _cmsg * cmsg)
 {
 	struct sk_buff *skb;
 	size_t len;
+
 	capi_cmsg2message(cmsg, cmsg->buf);
 	len = CAPIMSG_LEN(cmsg->buf);
 	skb = alloc_skb(len, GFP_ATOMIC);
+	if (!skb) {
+		printk(KERN_ERR "capidrv::send_message: can't allocate mem\n");
+		return;
+	}
 	memcpy(skb_put(skb, len), cmsg->buf, len);
 	if (capi20_put_message(&global.ap, skb) != CAPI_NOERROR)
 		kfree_skb(skb);
