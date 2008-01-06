Return-Path: <linux-kernel-owner+w=401wt.eu-S1757863AbYAFSX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757863AbYAFSX1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 13:23:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755327AbYAFSXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 13:23:13 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:45977 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757319AbYAFSXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 13:23:10 -0500
Date: Sun, 6 Jan 2008 19:23:05 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Al Boldi <a1426z@gawab.com>, Adrian Bunk <bunk@kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/5] USB Kconfig: Select SCSI for USB Mass Storage support
Message-ID: <20080106182305.GA4729@uranus.ravnborg.org>
References: <200801051546.SAA08947@raad.intranet> <200801060803.27101.a1426z@gawab.com> <4780E814.4050405@s5r6.in-berlin.de> <200801062007.31516.a1426z@gawab.com> <478114F3.6020804@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <478114F3.6020804@s5r6.in-berlin.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 06, 2008 at 06:50:43PM +0100, Stefan Richter wrote:
> Al Boldi wrote:
> > Stefan Richter wrote:
> >> Al Boldi wrote:
> >>>   	menuconfig USB_STORAGE
> >>>   	tristate "USB Mass Storage support"
> >>> -	depends on USB && SCSI
> >>> +	depends on USB && BLOCK
> >>> +	select SCSI
> >> Still wrong. SCSI also needs HAS_DMA and SCSI_DMA.
> > 
> > I don't think so.  SCSI selects SCSI_DMA, it doesn't depend on it.
> 
> "A selects B" == "A depends on B, but please don't hide A when B is off
> and silently switch B on when A is switched on".
> 
> config SCSI
> 	tristate "SCSI device support"
> 	depends on BLOCK
> 	select SCSI_DMA if HAS_DMA
> 
> So, SCSI doesn't actually need SCSI_DMA per se, but it apparently needs
> it whenever HAS_DMA != n.
> 
> > So it's safe to select SCSI here, as libata does it the same way.
> 
> Sam, does kconfig recursively follow select statements and switch on
> options which are select'ed by select'ed options?  I suppose it doesn't.

Let's try...
menu "Level 1"

config FOO1
        bool "Want to have FOO1?"
        select FOO2

config FOO2
        bool "Want to have FOO2?"
        select FOO3

config FOO3
        bool "Want to have FOO3?"

endmenu

With the above example it is obvious when running mconf
that it does so.
If you choose FOO1 in mconf and then save the configuration
you will see all symbols saved.


> 
> Maybe this would be better:
> 
>  config SCSI
>  	tristate "SCSI device support"
>  	depends on BLOCK
> -	select SCSI_DMA if HAS_DMA
> 
>  config SCSI_DMA
>  	bool
> -	default n
> +	default y if SCSI && HAS_DMA

This should be semantic equivalent and much easier to understand.

	Sam
