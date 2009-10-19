Return-Path: <linux-kernel-owner+w=401wt.eu-S1756542AbZJSR4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542AbZJSR4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 13:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753787AbZJSR4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 13:56:19 -0400
Received: from mail-pz0-f187.google.com ([209.85.222.187]:46640 "EHLO
	mail-pz0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbZJSR4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 13:56:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uG1vrnpMaMpqF4hgt6E7lam80hXF6IwtB3MCyFaoyEuHSEgRYNWdgldSA/k/lLd7wq
         9/Bfuill9sx0jlTU/XcANGzBKZAIZNRgHjX+FYCGLghtQMdH/jEYVDbb4RZ5rBk1kSd8
         Dk0yC1u0AC5vF/Ozy4HXyKoE2LjJi7Gyj0c4o=
Date: Mon, 19 Oct 2009 10:56:17 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Alex Chiang <achiang@hp.com>
Cc: lenb@kernel.org, shaohua.li@intel.com, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH v3 1/6] ACPI: dock: convert sysfs attributes to an
	attribute_group
Message-ID: <20091019175616.GA20992@core.coreip.homeip.net>
References: <20091016211323.12126.58457.stgit@bob.kio> <20091016211459.12126.60739.stgit@bob.kio> <20091018071630.GC3935@core.coreip.homeip.net> <20091019172138.GB23948@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091019172138.GB23948@ldl.fc.hp.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 19, 2009 at 11:21:38AM -0600, Alex Chiang wrote:
> Hi Dmitry,
> 
> * Dmitry Torokhov <dmitry.torokhov@gmail.com>:
> > On Fri, Oct 16, 2009 at 03:14:59PM -0600, Alex Chiang wrote:
> > > As suggested by Dmitry Torokhov, convert the individual sysfs
> > > attributes into an attribute group.
> > > 
> > > This change eliminates quite a bit of copy/paste code in the
> > > error handling paths.
> > > 
> > 
> > Looks much better, one more suggestion though:
> > 
> > > +err_unregister:
> > > +	printk(KERN_ERR "%s encountered error %d\n", __func__, ret);
> > 
> > If you want to print error this it should probably go down, right before
> > "return ret".
> 
> This is true for this patch, 1/6... but by the end of the series,
> the problem has resolved itself.
> 
> I agree that it's sloppy to have this bit of inconsistency in the
> middle of the patch series, but I'm reluctant to spin the entire
> series again, for sake of a printk.
> 
> > > +	sysfs_remove_group(&dock_device->dev.kobj, &dock_attribute_group);
> > 
> > It begs another label right here. There are cases when yo0u already
> > registered the platform device but haven't added the sysfs group, right?
> 
> This isn't quite true. In this patch, 1/6, our sequence goes:
> 
> 	platform_device_register_simple()
> 	platform_device_add_data()
> 	/* twiddle some state in the platform device, no error paths though */
> 	sysfs_create_group()
> 
> Arguably, the platform_device_add_data() call could fail with
> -ENOMEM, but the code today doesn't deal with that error
> condition, and I didn't touch the platform_device_add_data()
> line.
> 
> So really, there are no other exit paths between registering the
> platform device and adding the sysfs group.
>

If sysfs_create_group() fails you will go to err_unregister: which will
try to remove the non-existing group. While the current sysfs code is
relsilient against such errors it may not be so in the future. It is
better to have a separate label and bypass sysfs_remove_group() if
sysfs_create_group() returned error.

> By the end of the patch series, I combine the _register_simple()
> call with the _add_data() call and the final sequence looks like
> this:
> 
> 	if (platform_device_register_data() == error)
> 		return error;
> 
> 	/* twiddle local state in platform device */
> 
> 	if (sysfs_create_group())
> 		goto err_unregister;
> 
> 	/* other stuff */
> 
> 	err_unregister:
> 		printk(KERN_ERR "%s encountered error %d\n", __func__, ret);
> 		sysfs_remove_group(&dd->dev.kobj, &dock_attribute_group);
> 		platform_device_unregister(dd);
> 		return ret;
> 

-- 
Dmitry
