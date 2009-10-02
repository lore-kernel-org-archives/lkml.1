Return-Path: <linux-kernel-owner+w=401wt.eu-S1755712AbZJBBdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712AbZJBBdR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755805AbZJBBdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:33:13 -0400
Received: from kroah.org ([198.145.64.141]:33110 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755774AbZJBBdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:33:07 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:13 2009
Message-Id: <20091002012413.303435392@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:16:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Kevin Cernekee <cernekee@gmail.com>, Oliver Neukum <oliver@neukum.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: [048/136] kaweth: Fix memory leak in kaweth_control()
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=kaweth-fix-memory-leak-in-kaweth_control.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Kevin Cernekee <cernekee@gmail.com>

commit 051b982bcc620695de629d29c333c95b66e9b95e upstream.

kaweth_control() never frees the buffer that it allocates for the USB
control message.  Test case:

while :; do ifconfig eth2 down ; ifconfig eth2 up ; done

This is a tiny buffer so it is a slow leak.  If you want to speed up the
process, you can change the allocation size to e.g. 16384 bytes, and it
will consume several megabytes within a few minutes.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
Acked-by: Oliver Neukum <oliver@neukum.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/usb/kaweth.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

--- a/drivers/net/usb/kaweth.c
+++ b/drivers/net/usb/kaweth.c
@@ -263,6 +263,7 @@ static int kaweth_control(struct kaweth_
 			  int timeout)
 {
 	struct usb_ctrlrequest *dr;
+	int retval;
 
 	dbg("kaweth_control()");
 
@@ -278,18 +279,21 @@ static int kaweth_control(struct kaweth_
 		return -ENOMEM;
 	}
 
-	dr->bRequestType= requesttype;
+	dr->bRequestType = requesttype;
 	dr->bRequest = request;
 	dr->wValue = cpu_to_le16(value);
 	dr->wIndex = cpu_to_le16(index);
 	dr->wLength = cpu_to_le16(size);
 
-	return kaweth_internal_control_msg(kaweth->dev,
-					pipe,
-					dr,
-					data,
-					size,
-					timeout);
+	retval = kaweth_internal_control_msg(kaweth->dev,
+					     pipe,
+					     dr,
+					     data,
+					     size,
+					     timeout);
+
+	kfree(dr);
+	return retval;
 }
 
 /****************************************************************


