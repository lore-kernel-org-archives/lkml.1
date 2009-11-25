Return-Path: <linux-kernel-owner+w=401wt.eu-S934080AbZKYBQB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934080AbZKYBQB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 20:16:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933957AbZKYBQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 20:16:00 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:60509 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933665AbZKYBP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 20:15:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=GpFYk+G6gplDyQaEVJkEh6TCUnxi9KyfYhsxfZ1zO8TvEQnd0aCoWAXj9KmdVkO7Oq
         +uYAgjNBCMDTO0PRI9xQMRLQ2Ce0O08WjhPRlijXYHtlWbrYvFiprksbbV0JZMH414YQ
         vYEiQgkELMOg/yAsq+FgD40uiZ389stIgamJk=
MIME-Version: 1.0
Date: Wed, 25 Nov 2009 12:16:05 +1100
Message-ID: <d45a3acc0911241716i7bf218c4y71c75d9841695dfe@mail.gmail.com>
Subject: [PATCH 3/3] X25: Fix oops and refcnt problems from x25_dev_get
From: andrew hendry <andrew.hendry@gmail.com>
To: netdev@vger.kernel.org
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-x25@vger.kernel.org
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
+					))){
 		dev_put(dev);
+		dev = NULL;
+	}

 	return dev;
 }
