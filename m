Return-Path: <linux-kernel-owner+w=401wt.eu-S1752417AbXE3J7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417AbXE3J7J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 05:59:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751396AbXE3J65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 05:58:57 -0400
Received: from verein.lst.de ([213.95.11.210]:54726 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888AbXE3J65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 05:58:57 -0400
Date: Wed, 30 May 2007 11:58:22 +0200
From: Christoph Hellwig <hch@lst.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: cbe-oss-dev@ozlabs.org, gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [Cbe-oss-dev] [RFC] Cell: shutdown method for spu_sysdev_class
Message-ID: <20070530095821.GA24373@lst.de>
References: <463D1A2F.10708@am.sony.com> <200705292023.49968.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705292023.49968.arnd@arndb.de>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2007 at 08:23:49PM +0200, Arnd Bergmann wrote:
> On Sunday 06 May 2007, Geoff Levand wrote:
> > --- ps3-linux-dev.orig/arch/powerpc/platforms/cell/spu_base.c
> > +++ ps3-linux-dev/arch/powerpc/platforms/cell/spu_base.c
> > @@ -463,8 +463,21 @@ void spu_free(struct spu *spu)
> >  }
> >  EXPORT_SYMBOL_GPL(spu_free);
> >
> > +static int spu_shutdown(struct sys_device *sysdev)
> > +{
> > +       struct spu *spu = container_of(sysdev, struct spu, sysdev);
> > +
> > +       // what else here???
> > +
> > +       spu_free_irqs(spu);
> > +       spu_destroy_spu(spu);
> > +       kfree(spu);
> > +       return 0;
> > +}
> > +
> >  struct sysdev_class spu_sysdev_class = {
> > -       set_kset_name("spu")
> > +       set_kset_name("spu"),
> > +       .shutdown = spu_shutdown,
> >  };
> >
> >  int spu_add_sysdev_attr(struct sysdev_attribute *attr)
> 
> After some debugging, I found that this patch creates an oops when slab
> debugging is enabled, the reason for that being that sysdev_shutdown()
> iterates over all system devices using list_for_each_entry(), not
> list_for_each_entry_safe().
> 
> There are two ways of fixing this:
> 
> - use list_for_each_entry_safe() to go over all devices so they
>   can be freed in their ->shutdown method.
> - not free the device, because we know the system is going down
>   anyway.
> 
> Is it documented or implied somewhere that ->shutdown must not free
> the device? If not, the first option is probably the safer choice.

It's not documented anywhere, but implicitly assumed.  I don't know
of any shutdown implementation that frees the device.
