Return-Path: <linux-kernel-owner+w=401wt.eu-S1756865AbYAZKVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865AbYAZKVS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 05:21:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755031AbYAZKUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 05:20:53 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:43953 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754861AbYAZKUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 05:20:52 -0500
Date: Sat, 26 Jan 2008 11:21:02 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [Patch] Shut up warnings from files under drivers/
Message-ID: <20080126102102.GA22518@uranus.ravnborg.org>
References: <20080126093007.GB20935@hacking> <20080126095723.GA22285@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080126095723.GA22285@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > index 905d1f5..2009dc9 100644
> > --- a/drivers/char/synclink.c
> > +++ b/drivers/char/synclink.c
> > @@ -897,7 +897,9 @@ static char *driver_version = "$Revision: 4.38 $";
> >  
> >  static int synclink_init_one (struct pci_dev *dev,
> >  				     const struct pci_device_id *ent);
> > +#if defined(MODULE) || defined(CONFIG_HOTPLUG)
> >  static void synclink_remove_one (struct pci_dev *dev);
> > +#endif
> >  
> >  static struct pci_device_id synclink_pci_tbl[] = {
> >  	{ PCI_VENDOR_ID_MICROGATE, PCI_DEVICE_ID_MICROGATE_USC, PCI_ANY_ID, PCI_ANY_ID, },
> > @@ -8166,7 +8168,8 @@ static int __devinit synclink_init_one (struct pci_dev *dev,
> >  	return 0;
> >  }
> >  
> > +#if defined(MODULE) || defined(CONFIG_HOTPLUG)
> >  static void __devexit synclink_remove_one (struct pci_dev *dev)
> >  {
> >  }
> > -
> > +#endif
> 
> This function is properly annotated and __devexit_p() is used
> so it should not generate a warning.
> 
> The root casue is that __devexit is defined to nothing in the
> #ifdef CONFIG_HOTPLUG case - it should have been defined as
> #define __devexit __used
> if MODULE was not defined.
> 
> This is the better fix for these kind of warnings.
> For the latter I have fixed this in kbuild.git.
> So we are only left with the DEVICE_MOD_TABLE issue.

Looking a bit closer the above is rubbish.
We have:
#if defined(MODULE) || defined(CONFIG_HOTPLUG)
#define __devexit_p(x) x
#else
#define __devexit_p(x) NULL

so the pointer to the function is used in
both cases.

Could you drop me the config that produces the warning
and the warning message.

Thanks,
	Sam
