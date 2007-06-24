Return-Path: <linux-kernel-owner+w=401wt.eu-S1752781AbXFXWe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781AbXFXWe3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 18:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751226AbXFXWeW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 18:34:22 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:3818 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbXFXWeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 18:34:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=kRBRxI9Y++Yfx3BZRvxoN398ey4XnD/C+yVsxfifsQsxdH3CkKyCUhtqLl6BKuF8zl4pWSvie0krn2j3qz9OY/UHT93oA7ONwrEOQEY/RHp67hyS6oxNOTldgTSuINCrOzpeWJLBCtxx8mT/j21tRZhBZ7LpEXhp+IUW7SCW+BY=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: isdn4linux@listserv.isdn4linux.de
Subject: [PATCH] Guard against a potential NULL pointer dereference in old_capi_manufacturer()
Date: Mon, 25 Jun 2007 00:34:21 +0200
User-Agent: KMail/1.9.7
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Carsten Paeth <calle@calle.de>,
       Kai Germaschewski <kai@germaschewski.name>,
       Karsten Keil <kkeil@suse.de>,
       Kai Germaschewski <kai.germaschewski@gmx.de>,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706250034.21389.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In drivers/isdn/capi/kcapi.c::old_capi_manufacturer(), if the call 
to get_capi_ctr_by_nr(ldef.contr); in line 823 returns NULL, then 
we'll be dereferencing a NULL pointer in the very next line.

(Found by Coverity checker as bug #402)


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 drivers/isdn/capi/kcapi.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/isdn/capi/kcapi.c b/drivers/isdn/capi/kcapi.c
index 3ed34f7..3f9e962 100644
--- a/drivers/isdn/capi/kcapi.c
+++ b/drivers/isdn/capi/kcapi.c
@@ -821,6 +821,8 @@ static int old_capi_manufacturer(unsigned int cmd, void 
__user *data)
 				return -EFAULT;
 		}
 		card = get_capi_ctr_by_nr(ldef.contr);
+		if (!card)
+			return -EINVAL;
 		card = capi_ctr_get(card);
 		if (!card)
 			return -ESRCH;
