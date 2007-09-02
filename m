Return-Path: <linux-kernel-owner+w=401wt.eu-S1760303AbXIBUcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760303AbXIBUcX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 16:32:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750993AbXIBUcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 16:32:14 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:39349 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715AbXIBUcM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 16:32:12 -0400
Message-ID: <46DB1DCA.3050509@garzik.org>
Date: Sun, 02 Sep 2007 16:32:10 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Satyam Sharma <satyam@infradead.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       James Bottomley <james.bottomley@steeleye.com>, aacraid@adaptec.com,
       linux-scsi@vger.kernel.org
Subject: Re: [PATCH -mm] IPS SCSI driver: Check return of scsi_add_host()
References: <alpine.LFD.0.999.0709022344550.27844@enigma.security.iitk.ac.i n> <alpine.LFD.0.999.0709030142490.29617@enigma.security.iitk.ac.in>
In-Reply-To: <alpine.LFD.0.999.0709030142490.29617@enigma.security.iitk.ac.in>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
> drivers/scsi/ips.c: In function ‘ips_register_scsi’:
> drivers/scsi/ips.c:6869:
> warning: ignoring return value of ‘scsi_add_host’, declared with attribute warn_unused_result
> 
> scsi_add_host() is __must_check, so let's check it's return and cleanup
> appropriately on errors.
> 
> Signed-off-by: Satyam Sharma <satyam@infradead.org>
> 
> ---
> 
>  drivers/scsi/ips.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> --- linux-2.6.23-rc4-mm1/drivers/scsi/ips.c~fix	2007-09-02 20:21:27.000000000 +0530
> +++ linux-2.6.23-rc4-mm1/drivers/scsi/ips.c	2007-09-02 20:25:58.000000000 +0530
> @@ -6866,7 +6866,12 @@ ips_register_scsi(int index)
>  	sh->max_channel = ha->nbus - 1;
>  	sh->can_queue = ha->max_cmds - 1;
>  
> -	scsi_add_host(sh, NULL);
> +	if (scsi_add_host(sh, NULL)) {
> +		IPS_PRINTK(KERN_WARNING, ha->pcidev, "Unable to add SCSI host\n");
> +		free_irq(ha->irq, ha);
> +		scsi_host_put(sh);
> +		return -1;

ACK, as long as you add a comment to this code and the request_irq() 
failure code:  the oldha/old irq is not restored upon failure, in this 
function.

That is a pre-existing bug, and not your fault, but your patch 
"continues in the same buggy tradition" :)  We should at least note the 
FIXME at each error handling code branch.

Ideally you or somebody should do a detailed analysis to
a) (preferably) get rid of the silly oldha/ double-irq-request weirdness 
and make it look like other drivers,
	or,
b) analyze the code and see what it takes to _really_ unwind the error.

Also, I would recommend moving the error handling code to the end of the 
function and using the standard 'goto' approach for function error 
handling.  This eliminates the duplicate scsi_host_put() calls upon error.

	Jeff





