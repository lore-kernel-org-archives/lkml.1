Return-Path: <linux-kernel-owner+w=401wt.eu-S1756038AbXFREaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038AbXFREaz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 00:30:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752896AbXFREas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 00:30:48 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:58876 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752870AbXFREar (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 00:30:47 -0400
Date: Mon, 18 Jun 2007 10:00:37 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>, linux-kernel@vger.kernel.org,
       ISS StorageDev <iss_storagedev@hp.com>, akpm@linux-foundation.org
Subject: Re: [PATCH] cciss: force ignore of responses to unsent scsi commands after kexec reboot
Message-ID: <20070618043037.GA14758@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <20070614153119.GC32137@hmsreliant.homelinux.net> <226E1C65E4F6164E8EA5FD3CC913AE8C0156B740@G3W0639.americas.hpqcorp.net> <20070614192523.GB1110@hmsreliant.homelinux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070614192523.GB1110@hmsreliant.homelinux.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2007 at 03:25:23PM -0400, Neil Horman wrote:
> On Thu, Jun 14, 2007 at 06:16:03PM -0000, Miller, Mike (OS Dev) wrote:
> >  
> > 
> > > -----Original Message-----
> > > From: Neil Horman [mailto:nhorman@tuxdriver.com] 
> > > Sent: Thursday, June 14, 2007 10:31 AM
> > > To: linux-kernel@vger.kernel.org
> > > Cc: Miller, Mike (OS Dev); ISS StorageDev; 
> > > akpm@linux-foundation.org; nhorman@tuxdriver.com
> > > Subject: [PATCH] cciss: force ignore of responses to unsent 
> > > scsi commands after kexec reboot
> > > 
> > > Hey -
> > > 	cciss hardware currently can continue to send responses 
> > > to scsi commands after the host system has undergone a kexec 
> > > reboot.  The way the drier is currently written, reception of 
> > > these commands results in a BUG halt, since it can't match 
> > > the response to any issued command since the boot.  This 
> > > patch corrects that by using the kexec reset_devices command 
> > > line paramter to force ignore any commands that it cant correlate.
> > > 
> > > Regards
> > > Neil
> > > 
> > > Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> > > 
> > > 
> > >  cciss.c |    8 ++++++++
> > >  1 file changed, 8 insertions(+)
> > > 
> > > 
> > > diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c 
> > > index 5acc6c4..ec1c1d2 100644
> > > --- a/drivers/block/cciss.c
> > > +++ b/drivers/block/cciss.c
> > > @@ -2131,6 +2131,14 @@ static int add_sendcmd_reject(__u8 
> > > cmd, int ctlr, unsigned long complete)
> > >  		       ctlr, complete);
> > >  		/* not much we can do. */
> > >  #ifdef CONFIG_CISS_SCSI_TAPE
> > > +		/* We might get notification of completion of commands
> > > +		 * which we never issued in this kernel if this boot is
> > > +		 * taking place after previous kernel's crash. Simply
> > > +		 * ignore the commands in this case.
> > > +		 */
> > > +		if (reset_devices)
> > > +			return 0;
> > > +
> > >  		return 1;
> > >  	}

I think this is not the right usage of reset_devices parameter. This
parameter instructs the driver to reset the device before going ahead
with rest of the initialization before as underlying device might not
be in a sane state. kexec/kdump is one of the usages and this can also
be useful in the case of BIOS not doing its job.

When I had proposed crash_boot parameter for kexec/kdump purposes, that time
andrew had suggested that he is afraid that driver authors will use this
parameter to solve all kind of problems. 

I think we should stick to the theme of the parameter and implement the
reset routine for cciss driver instead of simply returning back. Consider
the case of hypothetical scenario where somebody booted the kernel with
reset_device parameter (because of unreliable bios) and if there is a problem
on kernel side that after it issues the command it lost track of that
(because of kernel bug) then driver will never catch that bug as upon receiving
the response it will simply ignore that.

Mike, you know most about this device. Can you please help out with 
implementing a reset routing for it?

Thanks
Vivek
