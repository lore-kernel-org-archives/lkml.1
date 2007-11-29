Return-Path: <linux-kernel-owner+w=401wt.eu-S1759338AbXK2EAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759338AbXK2EAq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 23:00:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756401AbXK2EAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 23:00:38 -0500
Received: from rtr.ca ([76.10.145.34]:1711 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756321AbXK2EAi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 23:00:38 -0500
Message-ID: <474E3964.7040200@rtr.ca>
Date: Wed, 28 Nov 2007 23:00:36 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] base/class.c: prevent ooops due to insert/remove race
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

While doing insert/remove (quickly) tests on USB, I managed to trigger
an Oops on 2.6.23.1 on the call to strlen() in make_class_name().

This patch prevents this oops.

There is still the larger problem of the overall race
that caused this in the first place, but much of the rest
of the code in class.c appears to also do NULL checks to
avoid Oops'ing, so this continues the tradition.

Signed-off-by:  Mark Lord <mlord@pobox.com>
---

Patch applies to both 2.6.24 and 2.6.23.

--- old/drivers/base/class.c	2007-11-28 22:54:59.000000000 -0500
+++ linux/drivers/base/class.c	2007-11-28 22:54:48.000000000 -0500
@@ -354,6 +354,8 @@
 	char *class_name;
 	int size;
 
+	if (!name)
+		return NULL;
 	size = strlen(name) + strlen(kobject_name(kobj)) + 2;
 
 	class_name = kmalloc(size, GFP_KERNEL);
