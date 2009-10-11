Return-Path: <linux-kernel-owner+w=401wt.eu-S1752696AbZJKWlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbZJKWlR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 18:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751882AbZJKWlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 18:41:17 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:43144 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbZJKWlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 18:41:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZVz2DxupRSpqYdnC1/inh5QrwSh4X+nak5ldQtPmAEr1RA+tNktkKzPc+xIH/tuqHn
         9FhrT1s8JCBvOvUU+fVadztDi1e9n/vDxizVV/lLDmAfkXDCFTzm9DFDpJNq3xh7UB+Z
         y6z6pHVq/hUVLxSnNA1ibSErapkYjQtysI3RM=
Date: Mon, 12 Oct 2009 00:40:36 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnd Bergmann <arndbergmann@googlemail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, John Kacur <jkacur@redhat.com>,
       Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       Jonathan Corbet <corbet@lwn.net>,
       Alessio Igor Bogani <abogani@texware.it>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] generic_nvram: Turn nvram_ioctl into an unlocked ioctl
Message-ID: <20091011224035.GB8146@nowhere>
References: <200910112131.40608.arnd@arndb.de> <1255299165-8618-1-git-send-email-fweisbec@gmail.com> <200910120025.05208.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910120025.05208.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12, 2009 at 12:25:05AM +0200, Arnd Bergmann wrote:
> On Monday 12 October 2009, Frederic Weisbecker wrote:
> > nvram_ioctl is a bkl locked ioctl, but it can be an unlocked ioctl.
> > 
> > - part is provided by the user
> > - offset is provided by pmac_get_partition() which is safe as it only
> >   touches nvram_partitions, an array inistialized on __init time and
> >   read-only the rest of the time.
> > - nvram_sync() only relies on core99_nvram_sync() which checks
> >   is_core_99, nvram_data, nvram_image. Those are variables initialized
> >   on __init time only and their direct values are not touched further.
> >   The rest modifies the nvram image header, protected by nv_lock
> >   already.
> > 
> > So it's safe to call nvram_ioctl without the big kernel lock held.
> > 
> > Reported-by: Arnd Bergmann <arndbergmann@googlemail.com>
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: John Kacur <jkacur@redhat.com>
> > Cc: Sven-Thorsten Dietrich <sven@thebigcorporation.com>
> > Cc: Jonathan Corbet <corbet@lwn.net>
> > Cc: Alessio Igor Bogani <abogani@texware.it>
> > Cc: Arnd Bergmann <arndbergmann@googlemail.com>
> > Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> 
> Hmm, I wish I had not started using the gmail MTA for sending out
> mail, not that address is public forever.


Sorry, didn't know about that. I'm then taking Arnd Bergmann <arnd@arndb.de>
found in the MAINTAINER file for the v2 patch.


 
> >  drivers/char/generic_nvram.c |   10 +++++-----
> >  1 files changed, 5 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/char/generic_nvram.c b/drivers/char/generic_nvram.c
> > index c49200e..fd448aa 100644
> > --- a/drivers/char/generic_nvram.c
> > +++ b/drivers/char/generic_nvram.c
> > @@ -118,11 +118,11 @@ static int nvram_ioctl(struct inode *inode, struct file *file,
> >  }
> >  
> >  const struct file_operations nvram_fops = {
> > -	.owner		= THIS_MODULE,
> > -	.llseek		= nvram_llseek,
> > -	.read		= read_nvram,
> > -	.write		= write_nvram,
> > -	.ioctl		= nvram_ioctl,
> > +	.owner			= THIS_MODULE,
> > +	.llseek			= nvram_llseek,
> > +	.read			= read_nvram,
> > +	.write			= write_nvram,
> > +	.unlocked_ioctl		= nvram_ioctl,
> >  };
> >  
> >  static struct miscdevice nvram_dev = {
> 
> The ioctl and unlocked_ioctl functions have a different signature, so you
> need to adapt that, not just rename it.


Hmm, that's the problem with this file I can't event build test. I really
should grab a cross compiler for powerpc targets.


> 
> Not sure if we should do it in the same patch, but this driver should also 
> have a compat_ioctl method pointing to the same function. The ioctl numbers
> in this driver are all 32/64 bit clean, but are not listed in fs/compat_ioctl.c,
> so adding a .compat_ioctl pointer is the easiest way to fix 32 bit userland
> accessing the device.
> 
> 	Arnd <><


Added in my todolist then, for a saperate patch because it fixes another
issue.

Thanks!

