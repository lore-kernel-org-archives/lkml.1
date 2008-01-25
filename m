Return-Path: <linux-kernel-owner+w=401wt.eu-S1757545AbYAYWM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545AbYAYWM3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 17:12:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755409AbYAYWMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 17:12:05 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:28208 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754672AbYAYWMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 17:12:03 -0500
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org,
       "Bryan O'Sullivan" <bryan.osullivan@qlogic.com>,
       Arthur Jones <arthur.jones@qlogic.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: [PATCH 148/196] Infiniband: make ipath driver use default driver groups.
X-Message-Flag: Warning: May contain useful information
References: <20080125071127.GA4860@kroah.com>
	<1201246425-5058-69-git-send-email-gregkh@suse.de>
	<adabq79lgkb.fsf@cisco.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 25 Jan 2008 14:11:14 -0800
In-Reply-To: <adabq79lgkb.fsf@cisco.com> (Roland Dreier's message of "Fri, 25 Jan 2008 13:51:32 -0800")
Message-ID: <ada7ihxlfnh.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 25 Jan 2008 22:11:16.0984 (UTC) FILETIME=[34C53F80:01C85F9F]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So I think it is coming from the following code in ipath_sysfs.c:

	int ipath_device_create_group(struct device *dev, struct ipath_devdata *dd)
	{
		int ret;
	
		ret = sysfs_create_group(&dev->kobj, &dev_attr_group);
		if (ret)
			goto bail;
	
		ret = sysfs_create_group(&dev->kobj, &dev_counter_attr_group);
		if (ret)
			goto bail_attrs;
	
		sysfs_remove_group(&dev->kobj, &dev_counter_attr_group);
	bail_attrs:
		sysfs_remove_group(&dev->kobj, &dev_attr_group);
	bail:
		return ret;
	}

note that the success path falls through into the error path and
removes the groups it just created, which means that on initialization
the groups are already removed, so we hit the BUG on the second try to
remove the groups on module exit.

And I think this chunk of your patch:

	-	snprintf(unit, sizeof(unit), "%02d", dd->ipath_unit);
	-	ret = sysfs_create_link(&dev->driver->kobj, &dev->kobj, unit);
	-	if (ret == 0)
	-		goto bail;
	-

was what broke it.  (Note the "if (ret == 0) then skip error
unwinding" code that got deleted by mistake -- not surprising given
how hard to read that construction is)

My bad for not testing -mm better.  I'll queue this up to fix it:

diff --git a/drivers/infiniband/hw/ipath/ipath_sysfs.c b/drivers/infiniband/hw/ipath/ipath_sysfs.c
index aa27ca9..e2a6534 100644
--- a/drivers/infiniband/hw/ipath/ipath_sysfs.c
+++ b/drivers/infiniband/hw/ipath/ipath_sysfs.c
@@ -770,7 +770,8 @@ int ipath_device_create_group(struct device *dev, struct ipath_devdata *dd)
 	if (ret)
 		goto bail_attrs;
 
-	sysfs_remove_group(&dev->kobj, &dev_counter_attr_group);
+	return 0;
+
 bail_attrs:
 	sysfs_remove_group(&dev->kobj, &dev_attr_group);
 bail:
