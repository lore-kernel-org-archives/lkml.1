Return-Path: <linux-kernel-owner+w=401wt.eu-S1754945AbXFNT0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945AbXFNT0M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 15:26:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752440AbXFNTZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 15:25:57 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:4583 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752523AbXFNTZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 15:25:56 -0400
Date: Thu, 14 Jun 2007 15:25:23 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Cc: linux-kernel@vger.kernel.org, ISS StorageDev <iss_storagedev@hp.com>,
       akpm@linux-foundation.org
Subject: Re: [PATCH] cciss: force ignore of responses to unsent scsi commands after kexec reboot
Message-ID: <20070614192523.GB1110@hmsreliant.homelinux.net>
References: <20070614153119.GC32137@hmsreliant.homelinux.net> <226E1C65E4F6164E8EA5FD3CC913AE8C0156B740@G3W0639.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <226E1C65E4F6164E8EA5FD3CC913AE8C0156B740@G3W0639.americas.hpqcorp.net>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2007 at 06:16:03PM -0000, Miller, Mike (OS Dev) wrote:
>  
> 
> > -----Original Message-----
> > From: Neil Horman [mailto:nhorman@tuxdriver.com] 
> > Sent: Thursday, June 14, 2007 10:31 AM
> > To: linux-kernel@vger.kernel.org
> > Cc: Miller, Mike (OS Dev); ISS StorageDev; 
> > akpm@linux-foundation.org; nhorman@tuxdriver.com
> > Subject: [PATCH] cciss: force ignore of responses to unsent 
> > scsi commands after kexec reboot
> > 
> > Hey -
> > 	cciss hardware currently can continue to send responses 
> > to scsi commands after the host system has undergone a kexec 
> > reboot.  The way the drier is currently written, reception of 
> > these commands results in a BUG halt, since it can't match 
> > the response to any issued command since the boot.  This 
> > patch corrects that by using the kexec reset_devices command 
> > line paramter to force ignore any commands that it cant correlate.
> > 
> > Regards
> > Neil
> > 
> > Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> > 
> > 
> >  cciss.c |    8 ++++++++
> >  1 file changed, 8 insertions(+)
> > 
> > 
> > diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c 
> > index 5acc6c4..ec1c1d2 100644
> > --- a/drivers/block/cciss.c
> > +++ b/drivers/block/cciss.c
> > @@ -2131,6 +2131,14 @@ static int add_sendcmd_reject(__u8 
> > cmd, int ctlr, unsigned long complete)
> >  		       ctlr, complete);
> >  		/* not much we can do. */
> >  #ifdef CONFIG_CISS_SCSI_TAPE
> > +		/* We might get notification of completion of commands
> > +		 * which we never issued in this kernel if this boot is
> > +		 * taking place after previous kernel's crash. Simply
> > +		 * ignore the commands in this case.
> > +		 */
> > +		if (reset_devices)
> > +			return 0;
> > +
> >  		return 1;
> >  	}
> >  
> I don't understand how this will help. We need to reset the controller
> which reset_devices cannot do alone. I just haven't have the time to
> implement the fix yet.
> 
> mikem 

I definately agree.  Actually resetting the hardware so that odd responses would
never be received would be a much better solution.  However, when this problem
(and the above corresponding workaround to fix it) was first proposed almost a
year ago:
http://www.ussg.iu.edu/hypermail/linux/kernel/0606.2/3055.html

It was met with no action.  I understand that actually doing a reset of the
hardware is a much better solution, but I'm certainly not knoweldgeable enough,
nor do I have the documentation needed to implement that solution.  Until it is,
this patch lets kexec work properly on this hardware, which I think is a good
trade until such time as the proper fix is implemented.

Thanks & Regards
Neil

-- 
/***************************************************
 *Neil Horman
 *Software Engineer
 *Red Hat, Inc.
 *nhorman@tuxdriver.com
 *gpg keyid: 1024D / 0x92A74FA1
 *http://pgp.mit.edu
 ***************************************************/
