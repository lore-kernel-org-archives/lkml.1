Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000Ab0CCKaH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 05:30:07 -0500
Received: from cantor.suse.de ([195.135.220.2]:57685 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506Ab0CCKaF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 05:30:05 -0500
Subject: Re: [PATCH] Don't change direction flags in struct request.
From: James Bottomley <James.Bottomley@suse.de>
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Hugh Daschbach <hdasch@broadcom.com>,
       Chandra Seetharaman <sekharan@us.ibm.com>,
       Eddie Williams <Eddie.Williams@steeleye.com>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Hannes Reinecke <hare@suse.de>
In-Reply-To: <4B8CC43D.9000108@cs.wisc.edu>
References: <1268976690-3386-1-git-send-email-hdasch@broadcom.com>
	 <1268976690-3386-2-git-send-email-hdasch@broadcom.com>
	 <1267507618.7936.11.camel@mulgrave.site>  <4B8CC43D.9000108@cs.wisc.edu>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Mar 2010 15:59:50 +0530
Message-ID: <1267612190.15025.60.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-02 at 01:54 -0600, Mike Christie wrote:
> On 03/01/2010 11:26 PM, James Bottomley wrote:
> > On Thu, 2010-03-18 at 22:31 -0700, Hugh Daschbach wrote:
> >> The EMC multipath device handler should not change the I/O direction
> >> flags of its trespass command request.
> >>
> >> The CFQ elevator may BUG if the direction flags on an I/O request are
> >> changed after allocation.  cfq_set_request() and cfq_put_request()
> >> count READ and WRITE requests separately.  Changing the I/O request
> >> direction after blk_get_request() allocates the request throws off
> >> this CFQ accounting.
> >
> > This description doesn't really match what the problem seems to be
> > below:
> >
> >> Signed-off-by: Hugh Daschbach<hdasch@broadcom.com>
> >> ---
> >>   drivers/scsi/device_handler/scsi_dh_emc.c |    8 ++++----
> >>   1 files changed, 4 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/drivers/scsi/device_handler/scsi_dh_emc.c b/drivers/scsi/device_handler/scsi_dh_emc.c
> >> index 6196675..3709342 100644
> >> --- a/drivers/scsi/device_handler/scsi_dh_emc.c
> >> +++ b/drivers/scsi/device_handler/scsi_dh_emc.c
> >> @@ -269,10 +269,12 @@ static struct request *get_req(struct scsi_device *sdev, int cmd,
> >>   				unsigned char *buffer)
> >>   {
> >>   	struct request *rq;
> >> +	int mode = READ;
> >>   	int len = 0;
> >>
> >> -	rq = blk_get_request(sdev->request_queue,
> >> -			(cmd == MODE_SELECT) ? WRITE : READ, GFP_NOIO);
> >> +	if (cmd == MODE_SELECT || cmd == MODE_SELECT_10)
> >> +		mode = WRITE;
> >> +	rq = blk_get_request(sdev->request_queue, mode, GFP_NOIO);
> >
> > So the actual bug is failure to set WRITE for MODE_SELECT_10.
> >
> 
> I think we have a fix for this and some len issues in that module that 
> was sent here:
> http://marc.info/?l=linux-scsi&m=125978574800618&w=2

Yes, you did ... the need to change the From: field caused me to mark it
in a different way and ultimately lose it ... I'll add it this time ...

James


