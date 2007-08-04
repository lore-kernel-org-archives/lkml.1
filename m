Return-Path: <linux-kernel-owner+w=401wt.eu-S1765708AbXHDSgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765708AbXHDSgl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 14:36:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932751AbXHDSdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 14:33:36 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:45415 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932670AbXHDSde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 14:33:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:content-disposition:from:to:subject:user-agent:cc:mime-version:date:content-type:content-transfer-encoding:message-id;
        b=OXppkm11gNPiT5nCYu9Et5lzYdvC3wtzwEPvam37sLXAQ8/R0HryEFGaidhLYBsucqz4c5Qg2y6z1ALGGg83mODmKTbYUFy0Fo6xX8X6apUyY9UDM4H5G/0wC8HOpiE8gvpIB06vXtfOHd0BJxwl+0osjQicnCEnqFypbEusB5g=
Content-Disposition: inline
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH][RESEND][ISDN] fix possible NULL deref on low memory condition in capidrv.c::send_message()
User-Agent: KMail/1.9.7
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       isdn4linux@listserv.isdn4linux.de, Carsten Paeth <calle@calle.de>,
       Karsten Keil <kkeil@suse.de>,
       Kai Germaschewski <kai.germaschewski@gmx.de>,
       Kai Germaschewski <kai@germaschewski.name>,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Date: Sat, 4 Aug 2007 20:31:37 +0200
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200708042031.38203.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(first send: Monday 25 June 2007, resending due to no response)
(resending again since there has still been no response)


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


