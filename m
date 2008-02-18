Return-Path: <linux-kernel-owner+w=401wt.eu-S1754460AbYBROvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460AbYBROvi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 09:51:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752198AbYBROva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 09:51:30 -0500
Received: from 87-194-8-8.bethere.co.uk ([87.194.8.8]:54941 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752176AbYBROva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 09:51:30 -0500
Date: Mon, 18 Feb 2008 14:51:24 +0000
From: Ben Dooks <ben@fluff.org>
To: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: sysdev: detecting multiple driver registrations
Message-ID: <20080218145124.GA17980@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've just found how easy it is to accidentally register
a sysdev_driver for two different classes. When this
happens, bad things happen as the sysdev_driver structure
keeps has the list entry for the driver registration.

The following patch makes a WARN_ON() if this happens,
although I think BUG_ON or returning -EAGAIN could also be valid
responses to this.

Index: linux-2.6.24-quilt5/drivers/base/sys.c
===================================================================
--- linux-2.6.24-quilt5.orig/drivers/base/sys.c
+++ linux-2.6.24-quilt5/drivers/base/sys.c
@@ -169,6 +169,11 @@ int sysdev_driver_register(struct sysdev
 {
 	int err = 0;
 
+	/* Check whether this driver has already been added to a class. */
+
+	WARN_ON(drv->entry.next != drv->entry.prev);
+	WARN_ON(drv->entry.next != NULL);
+
 	mutex_lock(&sysdev_drivers_lock);
 	if (cls && kset_get(&cls->kset)) {
 		list_add_tail(&drv->entry, &cls->drivers);


My first question is, whether people think that this check
is a sane and worthwhile thing to do.

The second question is, should this be BUG_ON, WARN_ON or
return an error (with optional print)?

And my third question is that a number of drivers are
assuming an NULL initialised 'struct list_head' is a
valid setup for an include/linux/list.h list. Is
there a case of using LIST_HEAD_INIT() on all sysdev
driver structures? If not, should we be using
INIT_LIST_HEAD() in sysdev_driver_register(). The header
is not clear on what should be done.

-- 
Ben
