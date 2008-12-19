Return-Path: <linux-kernel-owner+w=401wt.eu-S1753446AbYLSAkI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446AbYLSAkI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 19:40:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751644AbYLSAj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 19:39:56 -0500
Received: from mx2.suse.de ([195.135.220.15]:55605 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753AbYLSAjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 19:39:55 -0500
Date: Thu, 18 Dec 2008 16:32:59 -0800
From: Greg KH <gregkh@suse.de>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: mmotm 2008-12-17-16-41 uploaded
Message-ID: <20081219003259.GA12353@suse.de>
References: <200812180057.mBI0vpPt013574@imap1.linux-foundation.org> <20081218131015.735da05e.kamezawa.hiroyu@jp.fujitsu.com> <20081218222329.GA1398@kroah.com> <20081219091114.8b85ee7b.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081219091114.8b85ee7b.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2008 at 09:11:14AM +0900, KAMEZAWA Hiroyuki wrote:
> On Thu, 18 Dec 2008 14:23:29 -0800
> Greg KH <greg@kroah.com> wrote:
> 
> > On Thu, Dec 18, 2008 at 01:10:15PM +0900, KAMEZAWA Hiroyuki wrote:
> > > On Wed, 17 Dec 2008 16:41:54 -0800
> > > akpm@linux-foundation.org wrote:
> > > 
> > > > The mm-of-the-moment snapshot 2008-12-17-16-41 has been uploaded to
> > > > 
> > > >    http://userweb.kernel.org/~akpm/mmotm/
> > > > 
> > > > and will soon be available at
> > > > 
> > > >    git://git.zen-sources.org/zen/mmotm.git
> > > > 
> > > 
> > > This was necessary. I'm not sure my patch description is corrcect...
> > > but this helps me ;)
> > > This change kfree(dev->p) comes from linux-next.
> > > 
> > > ==
> > > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > > 
> > > dev->release() may free struct dev itself. To free dev->p
> > > in safe way, remember dev->p.
> > > 
> > > Signed-off-by:KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > > ---
> > >  drivers/base/core.c |    7 +++++--
> > >  1 file changed, 5 insertions(+), 2 deletions(-)
> > > 
> > > Index: mmotm-2.6.28-Dec17/drivers/base/core.c
> > > ===================================================================
> > > --- mmotm-2.6.28-Dec17.orig/drivers/base/core.c
> > > +++ mmotm-2.6.28-Dec17/drivers/base/core.c
> > > @@ -109,6 +109,7 @@ static struct sysfs_ops dev_sysfs_ops = 
> > >  static void device_release(struct kobject *kobj)
> > >  {
> > >  	struct device *dev = to_dev(kobj);
> > > +	struct device_private *p = dev->p;
> > >  
> > >  	if (dev->release)
> > >  		dev->release(dev);
> > > @@ -116,11 +117,13 @@ static void device_release(struct kobjec
> > >  		dev->type->release(dev);
> > >  	else if (dev->class && dev->class->dev_release)
> > >  		dev->class->dev_release(dev);
> > > -	else
> > > +	else {
> > >  		WARN(1, KERN_ERR "Device '%s' does not have a release() "
> > >  			"function, it is broken and must be fixed.\n",
> > >  			dev_name(dev));
> > > -	kfree(dev->p);
> > > +		return;
> > > +	}
> > > +	kfree(p);
> > 
> > You have a memory leak for when there is no release function for a
> > device, don't return if that happens.
> > 
> I thought "not released" dev may touch dev->p later..

Nope, it's a bug in the caller code.  They better not be touching dev->p
later, or bad things would be happening to their code :)

thanks,

greg k-h
