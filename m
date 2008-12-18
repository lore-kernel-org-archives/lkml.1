Return-Path: <linux-kernel-owner+w=401wt.eu-S1754234AbYLRW0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234AbYLRW0Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 17:26:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753962AbYLRW0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 17:26:04 -0500
Received: from kroah.org ([198.145.64.141]:59527 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753806AbYLRW0D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 17:26:03 -0500
Date: Thu, 18 Dec 2008 14:23:29 -0800
From: Greg KH <greg@kroah.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, gregkh@suse.de
Subject: Re: mmotm 2008-12-17-16-41 uploaded
Message-ID: <20081218222329.GA1398@kroah.com>
References: <200812180057.mBI0vpPt013574@imap1.linux-foundation.org> <20081218131015.735da05e.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081218131015.735da05e.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2008 at 01:10:15PM +0900, KAMEZAWA Hiroyuki wrote:
> On Wed, 17 Dec 2008 16:41:54 -0800
> akpm@linux-foundation.org wrote:
> 
> > The mm-of-the-moment snapshot 2008-12-17-16-41 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > and will soon be available at
> > 
> >    git://git.zen-sources.org/zen/mmotm.git
> > 
> 
> This was necessary. I'm not sure my patch description is corrcect...
> but this helps me ;)
> This change kfree(dev->p) comes from linux-next.
> 
> ==
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> dev->release() may free struct dev itself. To free dev->p
> in safe way, remember dev->p.
> 
> Signed-off-by:KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  drivers/base/core.c |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> Index: mmotm-2.6.28-Dec17/drivers/base/core.c
> ===================================================================
> --- mmotm-2.6.28-Dec17.orig/drivers/base/core.c
> +++ mmotm-2.6.28-Dec17/drivers/base/core.c
> @@ -109,6 +109,7 @@ static struct sysfs_ops dev_sysfs_ops = 
>  static void device_release(struct kobject *kobj)
>  {
>  	struct device *dev = to_dev(kobj);
> +	struct device_private *p = dev->p;
>  
>  	if (dev->release)
>  		dev->release(dev);
> @@ -116,11 +117,13 @@ static void device_release(struct kobjec
>  		dev->type->release(dev);
>  	else if (dev->class && dev->class->dev_release)
>  		dev->class->dev_release(dev);
> -	else
> +	else {
>  		WARN(1, KERN_ERR "Device '%s' does not have a release() "
>  			"function, it is broken and must be fixed.\n",
>  			dev_name(dev));
> -	kfree(dev->p);
> +		return;
> +	}
> +	kfree(p);

You have a memory leak for when there is no release function for a
device, don't return if that happens.

I've now fixed this up in my tree, thanks for pointing it out.

greg k-h
