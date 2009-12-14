Return-Path: <linux-kernel-owner+w=401wt.eu-S1758596AbZLNWDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758596AbZLNWDn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 17:03:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758563AbZLNWDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 17:03:15 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:35609 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758556AbZLNWDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 17:03:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=NAU+OmlV/jLgEypIerdfk90m2hQvdAvjOqudzUj5x+eC9cNNnRbSStelL13MIDN/1w
         tE+elB9Ix08rUn99sBZutn7bSrGVtn7bdlOhHs4FY00TI9gdXJFJncta/qXvtFQmPlm0
         W+xj1wsmDhY0dB8lI8d7AUPL2RiTqb0GkMkK0=
MIME-Version: 1.0
Date: Tue, 15 Dec 2009 09:03:07 +1100
Message-ID: <d45a3acc0912141403p150fae90m73a4f8e92030c73a@mail.gmail.com>
Subject: [RESEND PATCH 3/3] X25: Fix oops and refcnt problems from x25_dev_get
From: andrew hendry <andrew.hendry@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calls to x25_dev_get check for dev = NULL which was not set.
It allowed x25 to set routes and ioctls on down interfaces.
This caused oopses and refcnt problems on device_unregister.

Signed-off-by: Andrew Hendry <andrew.hendry@gmail.com>

--- a/net/x25/x25_route.c	2009-11-25 09:30:52.003038597 +1100
+++ b/net/x25/x25_route.c	2009-11-25 09:33:37.627093701 +1100
@@ -136,8 +136,10 @@ struct net_device *x25_dev_get(char *dev
 #if defined(CONFIG_LLC) || defined(CONFIG_LLC_MODULE)
 					&& dev->type != ARPHRD_ETHER
 #endif
-					)))
+					))) {
 		dev_put(dev);
+		dev = NULL;
+	}

 	return dev;
 }
