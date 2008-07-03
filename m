Return-Path: <linux-kernel-owner+w=401wt.eu-S1753737AbYGCATF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737AbYGCATF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 20:19:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751948AbYGCASy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 20:18:54 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:20235 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbYGCASx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 20:18:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Zh1X8UFh9Ha5Ul54qHM7dYOS9n88anAzVqjEvdoHeX0SCRSPVS04A0jrcKLFcRV70M
         5jtWsHPVkRghWrU698iaIC5k/J2q/aqZDLVkxwm97q4PC6M5BgIHZFyuBTuKEftaAFGW
         KNumKgzIgcFrih/mAsOUtBoKxhf/HfQCR5uO0=
Date: Thu, 3 Jul 2008 04:18:42 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, linux390@de.ibm.com,
       Kay Sievers <kay.sievers@vrfy.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-s390@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/04] s390: bus_id -> dev_set_name() changes
Message-ID: <20080703001842.GA12886@zarina>
Reply-To: cbouatmailru@gmail.com
References: <20080702154811.GB31083@kroah.com> <20080702221401.GA15142@zarina> <20080702230742.GA708@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20080702230742.GA708@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2008 at 04:07:42PM -0700, Greg KH wrote:
> On Thu, Jul 03, 2008 at 02:14:01AM +0400, Anton Vorontsov wrote:
> > On Wed, Jul 02, 2008 at 08:48:11AM -0700, Greg KH wrote:
> > > From: Cornelia Huck <cornelia.huck@de.ibm.com>
> > > 
> > > Convert most s390 users setting bus_id to dev_set_name().
> > > css and ccw busses are deferred since they need some special
> > > treatment.
> > > 
> > > Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
> > > Cc: Kay Sievers <kay.sievers@vrfy.org>
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > > 
> > > ---
> > >  drivers/s390/block/dcssblk.c |    2 +-
> > >  drivers/s390/char/vmlogrdr.c |    3 +--
> > >  drivers/s390/cio/ccwgroup.c  |    3 +--
> > >  drivers/s390/cio/chp.c       |    3 +--
> > >  drivers/s390/cio/css.c       |    4 ++--
> > >  drivers/s390/crypto/ap_bus.c |    4 ++--
> > >  drivers/s390/net/netiucv.c   |    2 +-
> > >  drivers/s390/s390_rdev.c     |    2 +-
> > >  drivers/s390/scsi/zfcp_aux.c |   23 ++++++++---------------
> > >  9 files changed, 18 insertions(+), 28 deletions(-)
> > > 
> > > --- a/drivers/s390/block/dcssblk.c
> > > +++ b/drivers/s390/block/dcssblk.c
> > > @@ -349,7 +349,7 @@ dcssblk_add_store(struct device *dev, st
> > >  	}
> > >  
> > >  	strcpy(dev_info->segment_name, local_buf);
> > > -	strlcpy(dev_info->dev.bus_id, local_buf, BUS_ID_SIZE);
> > > +	dev_set_name(&dev_info->dev, local_buf);
> > 
> > As I see it, dev_set_name accepts printf like string, so this
> > dev_set_name is quite dangerous (since local_buf is formed
> > by the module param), no?
> 
> So you would rather see:
> 	dev_set_name(&dev_info->dev, "%s", local_buf);
> 
> instead?

Yep.

There is another occurrence of "feels dangerous" construction in this
patch, namely

> --- a/drivers/s390/char/vmlogrdr.c
> +++ b/drivers/s390/char/vmlogrdr.c
> @@ -738,8 +738,7 @@ static int vmlogrdr_register_device(stru
> 
> 	dev = kzalloc(sizeof(struct device), GFP_KERNEL);
> 	if (dev) {
> -		snprintf(dev->bus_id, BUS_ID_SIZE, "%s",
> -			 priv->internal_name);
> +		dev_set_name(dev, priv->internal_name);

But in fact here it is safe, since the driver defines internal_name
to be either "logrec", "account" or "symptom". No % symbols.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
