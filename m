Return-Path: <linux-kernel-owner+w=401wt.eu-S933069AbXDFQV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933069AbXDFQV0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 12:21:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933068AbXDFQV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 12:21:26 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:51097 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932569AbXDFQVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 12:21:25 -0400
Subject: Re: Oops in scsi_send_eh_cmnd 2.6.21-rc5-git6,7,10,13
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Andrew Burgess <aab@cichlid.com>
Cc: cebbert@redhat.com, davem@davemloft.net, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, aradford@gmail.com
In-Reply-To: <200704061551.l36FpWoV015751@cichlid.com>
References: <200704061551.l36FpWoV015751@cichlid.com>
Content-Type: text/plain
Date: Fri, 06 Apr 2007 11:14:56 -0500
Message-Id: <1175876096.3677.24.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-04-06 at 08:51 -0700, Andrew Burgess wrote:
> James Bottomley wrote:
> 
> >It's actually a long standing bug in the 3w-xxxx driver.  Apparently it
> >assumes request sense is always the use_sg == 0 case.  This is what it
> >does on a request sense:
> 
> >static int tw_scsiop_request_sense(TW_Device_Extension *tw_dev, int request_id)
> >{
> >        dprintk(KERN_NOTICE "3w-xxxx: tw_scsiop_request_sense()\n");
> 
> >        /* For now we just zero the request buffer */
> >        memset(tw_dev->srb[request_id]->request_buffer, 0, tw_dev->srb[request_id]->request_bufflen);
> >        tw_dev->state[request_id] = TW_S_COMPLETED;
> >        tw_state_request_finish(tw_dev, request_id);
> >....
> 
> >Note that it's clearing the request buffer, which is actually zeroing the scatterlist, hence the problem.
> 
> OK. Is there a quick workaround or should I just wait for
> Adam & Company to make a patch?

Try this ... I think it's roughly the correct fix.

> You said your earlier patch would hide it, and then said you
> had a length wrong in it and I'm not sure what length you
> mean.

It's the length specifier in the error handler request sense command ...
I'll fix it up and redo my patch through scsi-misc, since it's not going
to fix the root cause of the problem.

James

diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index bf5d63e..6b303ba 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -1864,10 +1864,17 @@ static int tw_scsiop_read_write(TW_Device_Extension *tw_dev, int request_id)
 /* This function will handle the request sense scsi command */
 static int tw_scsiop_request_sense(TW_Device_Extension *tw_dev, int request_id)
 {
+	char request_buffer[18];
+
 	dprintk(KERN_NOTICE "3w-xxxx: tw_scsiop_request_sense()\n");
 
-	/* For now we just zero the request buffer */
-	memset(tw_dev->srb[request_id]->request_buffer, 0, tw_dev->srb[request_id]->request_bufflen);
+	memset(request_buffer, 0, sizeof(request_buffer));
+	request_buffer[0] = 0x70; /* Immediate fixed format */
+	request_buffer[7] = 11;	/* minimum size per SPC: 18 bytes */
+	/* leave all other fields zero, giving effectively NO_SENSE return */
+	tw_transfer_internal(tw_dev, request_id, request_buffer,
+			     sizeof(request_buffer));
+	
 	tw_dev->state[request_id] = TW_S_COMPLETED;
 	tw_state_request_finish(tw_dev, request_id);
 


