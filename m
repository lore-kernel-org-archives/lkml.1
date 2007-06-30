Return-Path: <linux-kernel-owner+w=401wt.eu-S1755438AbXF3XSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438AbXF3XSe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 19:18:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754905AbXF3XR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 19:17:59 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:61012 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846AbXF3XR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 19:17:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:content-disposition:from:to:subject:date:user-agent:cc:mime-version:message-id:content-type:content-transfer-encoding;
        b=UzAhOSIG6RR6YYYFoUoj3GAd8WsYtrBdKvbjqifBXY8YF+F9p3z6/ExXq9IzGxZFMqsZQuST6cNg7Le65notZyef2UmPA82LMM978vFqKv/iZli8puJpDwu+TeP1S7ycaJDxvFqBGqY4IxblfC+AYbDP+9vWYl9ztr2b7gLiFKc=
Content-Disposition: inline
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH][ISDN][resend] fix possible NULL deref on low memory condition in capidrv.c::send_message()
Date: Sun, 1 Jul 2007 01:01:12 +0200
User-Agent: KMail/1.9.7
Cc: isdn4linux@listserv.isdn4linux.de, Carsten Paeth <calle@calle.de>,
       Karsten Keil <kkeil@suse.de>,
       Kai Germaschewski <kai.germaschewski@gmx.de>,
       Kai Germaschewski <kai@germaschewski.name>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Message-Id: <200707010101.12527.jesper.juhl@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(first send: Monday 25 June 2007, resending due to no response)


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
@@ -506,9 +506,14 @@ static void send_message(capidrv_contr * card, _cmsg * 
cmsg)
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

