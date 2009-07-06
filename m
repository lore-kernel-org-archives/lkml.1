Return-Path: <linux-kernel-owner+w=401wt.eu-S1752962AbZGFP1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962AbZGFP1O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 11:27:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751118AbZGFP1D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 11:27:03 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:47475 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbZGFP1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 11:27:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=AdWqJ1voRP8UrxLcgdmv0eLQIgX++/Umw7zujc5GmnDZDY1e17JkGOlyF3n9J/26zh
         ebXGMUkfnqVt7Ni0pqkSQx+D1/a1mtJU9rzTOJfKIrla+DigtbLZhSDezZXMgphVOhgb
         bK+uzf9xdWw/1NcfcUSXk6UdZsGQbeg/cgmN8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Forest Bond <forest@alittletooquiet.net>
Subject: Re: Staging: vt6656 ?
Date: Mon, 6 Jul 2009 17:33:00 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc2-next-20090706-03300-ga0c36f0; KDE/4.2.4; i686; ; )
Cc: Greg KH <gregkh@suse.de>, Alexander Beregalov <a.beregalov@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <a4423d670906090331o6363fe56g34374967f21552e8@mail.gmail.com> <200907021945.49926.bzolnier@gmail.com> <20090702182208.GD9422@alittletooquiet.net>
In-Reply-To: <20090702182208.GD9422@alittletooquiet.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200907061733.01136.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 July 2009 20:22:08 Forest Bond wrote:
> Hi,
> 
> On Thu, Jul 02, 2009 at 07:45:49PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > On Sunday 28 June 2009 18:47:16 Forest Bond wrote:
> > > On Sun, Jun 28, 2009 at 05:59:45PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > > > [ I'll later setup vt665x branch of my misc.git tree, merge your patches,
> > > >   merge all outstanding vt6655 patches from Alexander and investigate a bit
> > > >   more whether merge of vt665x drivers is feasible and what needs to be
> > > >   done if so.. ]
> > > 
> > > Good.
> > 
> > The temporary tree is here:
> > 
> > git://git.kernel.org:/pub/scm/linux/kernel/git/bart/misc.git vt665x
> > 
> > and I'll happily apply patches to it till Greg digs out from under the
> > overdue patch queues.. :)
> 
> Thanks for doing this, Bartlomiej.
> 
> > > FYI, there is a known issue with the drivers as I've submitted them that causes
> > > lock-ups.  Please see the attached message for a suggested fix.
> > 
> > I think that all netdev_priv() changes should be reverted for now:
> 
> I'm happy to defer to you on this.  I don't really understand the code, to be
> frank.  However, if those changes are simply reverted, the driver will not
> compile.  I assume that you mean those areas should be removed?

Uh, you're right.. we need to use netdev_priv().

> > --- a/drivers/staging/vt6655/wpactl.c
> > +++ b/drivers/staging/vt6655/wpactl.c
> > @@ -112,14 +112,17 @@ static void wpadev_setup(struct net_device *dev)
> >  
> >  static int wpa_init_wpadev(PSDevice pDevice)
> >  {
> > +    PSDevice wpadev_priv;
> >  	struct net_device *dev = pDevice->dev;
> >           int ret=0;
> >  
> > -	pDevice->wpadev = alloc_netdev(0, "vntwpa", wpadev_setup);
> > +	pDevice->wpadev = alloc_netdev(sizeof(PSDevice), "vntwpa", wpadev_setup);
> >  	if (pDevice->wpadev == NULL)
> >  		return -ENOMEM;
> >  
> > -	pDevice->wpadev->priv = pDevice;
> > +    wpadev_priv = netdev_priv(pDevice->wpadev);
> > +    *wpadev_priv = *pDevice;
> > +
> >  	memcpy(pDevice->wpadev->dev_addr, dev->dev_addr, U_ETHER_ADDR_LEN);
> >           pDevice->wpadev->base_addr = dev->base_addr;
> >  	pDevice->wpadev->irq = dev->irq;
> > 
> > This will copy the current state of pDevice to newly allocated private part
> > of ->apdev but later modifications to the original pDevice won't be seen if
> > we access it through netdev_priv(pDevice->apdev) instead of apdev->priv.

[ it should be wpadev not apdev in the above description ]

> > [ I don't know whether this is a problem currently but it looks suspicious. ]
> 
> Agreed.  I gave this a best effort, but was not very confident about the result.

The code is puzzling (at best) -- I still don't know why do we need separate
netdev structure for hostap or wpactl functionality..

> Feel free to aggressively rework my changes if it seems appropriate.

I don't think there is a need for it and I would like to avoid that
since I'm also involved in other drivers/staging/ drivers (besides you
and Alexander are doing just fine :).

Seems like all we need to do to fix the problem is:

* fix code in hostap to also use alloc_netdev()

* bring back "manual" allocation of PSDevice structure
 
* use private netdev areas only to store the pointer to the single PSDevice
  structure that we allocate "manually" (requires converting all netdev_priv()
  instances to *netdev_priv() etc but the change should be straightforward).
