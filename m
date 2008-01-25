Return-Path: <linux-kernel-owner+w=401wt.eu-S1752469AbYAYWZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469AbYAYWZY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 17:25:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753834AbYAYWZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 17:25:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48563 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752579AbYAYWZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 17:25:11 -0500
Date: Fri, 25 Jan 2008 14:23:41 -0800
From: Greg KH <gregkh@suse.de>
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel@vger.kernel.org,
       "Bryan O'Sullivan" <bryan.osullivan@qlogic.com>,
       Arthur Jones <arthur.jones@qlogic.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: [PATCH 148/196] Infiniband: make ipath driver use default
	driver groups.
Message-ID: <20080125222341.GC15172@suse.de>
References: <20080125071127.GA4860@kroah.com> <1201246425-5058-69-git-send-email-gregkh@suse.de> <adabq79lgkb.fsf@cisco.com> <ada7ihxlfnh.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ada7ihxlfnh.fsf@cisco.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2008 at 02:11:14PM -0800, Roland Dreier wrote:
> So I think it is coming from the following code in ipath_sysfs.c:
> 
> 	int ipath_device_create_group(struct device *dev, struct ipath_devdata *dd)
> 	{
> 		int ret;
> 	
> 		ret = sysfs_create_group(&dev->kobj, &dev_attr_group);
> 		if (ret)
> 			goto bail;
> 	
> 		ret = sysfs_create_group(&dev->kobj, &dev_counter_attr_group);
> 		if (ret)
> 			goto bail_attrs;
> 	
> 		sysfs_remove_group(&dev->kobj, &dev_counter_attr_group);
> 	bail_attrs:
> 		sysfs_remove_group(&dev->kobj, &dev_attr_group);
> 	bail:
> 		return ret;
> 	}
> 
> note that the success path falls through into the error path and
> removes the groups it just created, which means that on initialization
> the groups are already removed, so we hit the BUG on the second try to
> remove the groups on module exit.
> 
> And I think this chunk of your patch:
> 
> 	-	snprintf(unit, sizeof(unit), "%02d", dd->ipath_unit);
> 	-	ret = sysfs_create_link(&dev->driver->kobj, &dev->kobj, unit);
> 	-	if (ret == 0)
> 	-		goto bail;
> 	-
> 
> was what broke it.  (Note the "if (ret == 0) then skip error
> unwinding" code that got deleted by mistake -- not surprising given
> how hard to read that construction is)
> 
> My bad for not testing -mm better.  I'll queue this up to fix it:

Thanks for the fix, and sorry for causing that, it was a complex error
path :)

Although a BUG() for when we try to remove a file that is no longer
there seems pretty harsh, I think I'll change that to a WARN_ON() so
that people just know to fix up their code, not kill the kernel
entirely.

thanks,

greg k-h
