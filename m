Return-Path: <linux-kernel-owner+w=401wt.eu-S1752403AbXDUAGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403AbXDUAGS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 20:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752277AbXDUAGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 20:06:18 -0400
Received: from canuck.infradead.org ([209.217.80.40]:59072 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbXDUAGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 20:06:18 -0400
Date: Fri, 20 Apr 2007 17:03:40 -0700
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Tejun Heo <htejun@gmail.com>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH RFD] alternative kobject release wait mechanism
Message-ID: <20070421000340.GB12155@kroah.com>
References: <46284F2A.4000401@gmail.com> <Pine.LNX.4.44L0.0704201136590.2616-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0704201136590.2616-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2007 at 11:40:39AM -0400, Alan Stern wrote:
> Here's a patch to do what I mentioned earlier.  Not tested -- it may 
> expose some existing bugs.  It may even break something, but I'm not aware 
> of anything that depends on it explicitly.
> 
> Greg, do you know of anything in particular that depends on a kobjects not 
> being released before their children are released?

Yes, the whole driver model :)

When adding a new device, we always grab a reference to the parent
device so it can not go away before we do.

Look at the last kobject_put(parent); in kobject_cleanup() which ensures
this.

> Index: usb-2.6/lib/kobject.c
> ===================================================================
> --- usb-2.6.orig/lib/kobject.c
> +++ usb-2.6/lib/kobject.c
> @@ -192,12 +192,15 @@ void kobject_init(struct kobject * kobj)
>  
>  static void unlink(struct kobject * kobj)
>  {
> +	struct kobject *parent = kobj->parent;
> +
>  	if (kobj->kset) {
>  		spin_lock(&kobj->kset->list_lock);
>  		list_del_init(&kobj->entry);
>  		spin_unlock(&kobj->kset->list_lock);
>  	}
>  	kobject_put(kobj);
> +	kobject_put(parent);
>  }
>  
>  /**
> @@ -241,7 +244,6 @@ int kobject_shadow_add(struct kobject * 
>  	if (error) {
>  		/* unlink does the kobject_put() for us */
>  		unlink(kobj);
> -		kobject_put(parent);
>  
>  		/* be noisy on error issues */
>  		if (error == -EEXIST)
> @@ -489,7 +491,6 @@ void kobject_cleanup(struct kobject * ko
>  {
>  	struct kobj_type * t = get_ktype(kobj);
>  	struct kset * s = kobj->kset;
> -	struct kobject * parent = kobj->parent;
>  
>  	pr_debug("kobject %s: cleaning up\n",kobject_name(kobj));
>  	if (kobj->k_name != kobj->name)
> @@ -505,7 +506,6 @@ void kobject_cleanup(struct kobject * ko
>  
>  	if (s)
>  		kset_put(s);
> -	kobject_put(parent);
>  }

Ick, no, I think this used to be the way things worked, but bad things
would end up happening, so we fixed it up to be the way things are
today.  Read the comments for the changelog for this file for details.

Specifically, look at commit 10921a8f1305b8ec97794941db78b825db5839bc
in the history.git repo which is almost exactly what you are proposing
to be reverted...

thanks,

greg k-h
