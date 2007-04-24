Return-Path: <linux-kernel-owner+w=401wt.eu-S1754639AbXDXP5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639AbXDXP5A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 11:57:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754637AbXDXP5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 11:57:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:41573 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754634AbXDXP46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 11:56:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,448,1170662400"; 
   d="scan'208"; a="233106864:sNHT38787931"
Date: Tue, 24 Apr 2007 08:54:16 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: Tejun Heo <htejun@gmail.com>
Cc: jeff@garzik.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [patch 1/7] libata: check for AN support
Message-Id: <20070424085416.ecf2326c.kristen.c.accardi@intel.com>
In-Reply-To: <462DB9D1.2070106@gmail.com>
References: <20070424074856.005152262@intel.com>
	<20070423165943.0cc67bc5.kristen.c.accardi@intel.com>
	<462DB9D1.2070106@gmail.com>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2007 17:03:29 +0900
Tejun Heo <htejun@gmail.com> wrote:

> Hello,
> 
> Kristen Carlson Accardi wrote:
> >  static unsigned int ata_print_id = 1;
> > @@ -1744,6 +1745,23 @@ int ata_dev_configure(struct ata_device 
> >  		}
> >  		dev->cdb_len = (unsigned int) rc;
> >  
> > +		/*
> > +		 * check to see if this ATAPI device supports
> > +		 * Asynchronous Notification
> > +		 */
> > +		if ((ap->flags & ATA_FLAG_AN) && ata_id_has_AN(id))
> > +		{
> > +			/* issue SET feature command to turn this on */
> > +			rc = ata_dev_set_AN(dev);
> 
> Please don't store err_mask into int rc.  Please store it to a separate
> err_mask variable and report it when printing error message.
> 
> > +			if (rc) {
> > +				ata_dev_printk(dev, KERN_ERR,
> > +						"unable to set AN\n");
> > +				rc = -EINVAL;
> 
> Wouldn't -EIO be more appropriate?

I think Alan is right - and being unable to turn on AN should not be fatal.
I'll just change all this code to just print the err and keep going.

> 
> > +				goto err_out_nosup;
> > +			}
> > +			dev->flags |= ATA_DFLAG_AN;
> > +		}
> > +
> 
> Not NACKing.  Just notes for future improvements.  We need to be more
> careful here.  ATA/ATAPI world is filled with braindamaged devices and I
> bet there are devices which advertises it can do AN but chokes when AN
> is enabled.
> 
> This should be handled similarly to ACPI failure.  Currently ACPI does
> the following.
> 
> 1. try once, if fail, record that ACPI failed.  return error to trigger
> retry.
> 2. try again, if fail again, ignore error if possible (!FROZEN) and turn
> off ACPI.
> 
> This fallback mechanism for optional features can probably be
> generalized and used for both ACPI and AN.

Ok - meanwhile I think it's appropriate here to just do try-once-fail-give-up.
