Return-Path: <linux-kernel-owner+w=401wt.eu-S1753504AbXFNQpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504AbXFNQpf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 12:45:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751383AbXFNQp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 12:45:29 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:3643 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751079AbXFNQp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 12:45:28 -0400
Date: Thu, 14 Jun 2007 12:44:47 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, mike.miller@hp.com, iss_storagedev@hp.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH] cciss: force ignore of responses to unsent scsi commands after kexec reboot
Message-ID: <20070614164447.GA1110@hmsreliant.homelinux.net>
References: <20070614153119.GC32137@hmsreliant.homelinux.net> <20070614085924.258f9426.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070614085924.258f9426.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2007 at 08:59:24AM -0700, Randy Dunlap wrote:
> On Thu, 14 Jun 2007 11:31:19 -0400 Neil Horman wrote:
> 
> > Hey -
> > 	cciss hardware currently can continue to send responses to scsi commands
> > after the host system has undergone a kexec reboot.  The way the drier is
> > currently written, reception of these commands results in a BUG halt, since it
> > can't match the response to any issued command since the boot.  This patch
> > corrects that by using the kexec reset_devices command line paramter to force
> > ignore any commands that it cant correlate.
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
> > @@ -2131,6 +2131,14 @@ static int add_sendcmd_reject(__u8 cmd, int ctlr, unsigned long complete)
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
> 
> But this patch applies only to SCSI tape devices, not to
> disk devices?
> 
No it only applies if CONFIG_CISS_SCSI_TAPE is defined (which is different than
only being applicable to scsi tape devices.  I'm not sure why the cciss driver
ifdefs the relevant code to only support TAPE devices, but I figured that wasn't
as relevant to this problem.  Sufice it to say, that all scsi commands to all
cciss devices pass through this code if CONFIG_CISS_SCSI_TAPE is defined, and if
its not defined, add_sendcmd_reject always returns 0

Thanks & Regards
Neil

> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***

-- 
/***************************************************
 *Neil Horman
 *Software Engineer
 *Red Hat, Inc.
 *nhorman@tuxdriver.com
 *gpg keyid: 1024D / 0x92A74FA1
 *http://pgp.mit.edu
 ***************************************************/
