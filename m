Return-Path: <linux-kernel-owner+w=401wt.eu-S1759197AbXEIVIP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759197AbXEIVIP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 17:08:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755074AbXEIVID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 17:08:03 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39189 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754478AbXEIVIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 17:08:00 -0400
Message-ID: <464237A9.6060301@redhat.com>
Date: Wed, 09 May 2007 17:05:45 -0400
From: =?UTF-8?B?S3Jpc3RpYW4gSMO4Z3NiZXJn?= <krh@redhat.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux-kernel@vger.kernel.org, Kristian H??gsberg <krh@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux1394-devel <linux1394-devel@lists.sourceforge.net>
Subject: Re: [PATCH 5/6] firewire: SBP-2 highlevel driver
References: <4637A29F.6070302@redhat.com> <20070502090007.GA28174@infradead.org> <tkrat.087ee29add656926@s5r6.in-berlin.de> <tkrat.350cb4dfe522266e@s5r6.in-berlin.de> <tkrat.65aea95f1451c211@s5r6.in-berlin.de> <tkrat.2aa3f3ac11a3d60d@s5r6.in-berlin.de> <tkrat.a41f7f10d21d3cc4@s5r6.in-berlin.de> <tkrat.c82a1d775d989371@s5r6.in-berlin.de> <20070502194408.GD1248@infradead.org>
In-Reply-To: <20070502194408.GD1248@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
>> +	sg = (struct scatterlist *)orb->cmd->request_buffer;
>> +	count = dma_map_sg(device->card->device, sg, orb->cmd->use_sg,
>> +			   orb->cmd->sc_data_direction);
> 
> you need to handle the error case (count == 0)

Yup, done.

>> +	/* Convert the scatterlist to an sbp2 page table.  If any
>> +	 * scatterlist entries are too big for sbp2 we split the as we go. */
> 
> Please set the max_sectors value in your host template so that the
> block layer doesn't build sg entries too big for you.

As Stefan, said, dma_map_sg() breaks the limit guarantee, so we have to split 
things manually if sg entries got merged.  I've added a comment explaining this.

Isn't max_sectors the overall size limit of the request, though?  The SBP-2 
protocol imposes a maximum size of 65535 bytes per sg entry, but the total 
size of a request can be larger.  I guess, setting dma_boundary to 2^15 could 
work.

>> +	orb->page_table_bus =
>> +		dma_map_single(device->card->device, orb->page_table,
>> +			       size, DMA_TO_DEVICE);
> 
> This needs handling of mapping errors (dma_mapping_error())

Done.

>> +	orb = kzalloc(sizeof *orb, GFP_ATOMIC);
> 
> Normal kernel style is sizeof(*orb)

Oh, hmm... I though the kernel style typically was to avoid excess parens :) 
But, sure, I see the comment about preferring parens with sizeof in CodingStyle.

>> +	if (cmd->use_sg) {
>> +		sbp2_command_orb_map_scatterlist(orb);
>> +	} else if (cmd->request_bufflen > SBP2_MAX_SG_ELEMENT_LENGTH) {
>> +		/* FIXME: Need to split this into a sg list... but
>> +		 * could we get the scsi or blk layer to do that by
>> +		 * reporting our max supported block size? */
>> +		fw_error("command > 64k\n");
>> +		goto fail_bufflen;
>> +	} else if (cmd->request_bufflen > 0) {
>> +		sbp2_command_orb_map_buffer(orb);
>> +	}
> 
> The use_sg == 0, request_bufflen != 0 case can't happen anymore.

That should simplify the code a bit.  How long has that been the case?

>> + fail_mapping:
>> +	kfree(orb);
>> + fail_alloc:
>> +	cmd->result = DID_ERROR << 16;
>> +	done(cmd);
> 
> Failure due to ressource shortage should not complete the command
> but return SCSI_MLQUEUE_HOST_BUSY/SCSI_MLQUEUE_DEVICE_BUSY.

Ok, I've changed that.

>> +	return 0;
>> +}
> 
>> +static struct scsi_host_template scsi_driver_template = {
>> +	.module			= THIS_MODULE,
>> +	.name			= "SBP-2 IEEE-1394",
>> +	.proc_name		= (char *)sbp2_driver_name,
> 
> Please don't use casrs here.  Either fix up the definition so it
> accepts const strings or pass a non-const one.

Ok, I'll patch the scsi host template definition.

>> +static int add_scsi_devices(struct fw_unit *unit)
>> +{
>> +	struct sbp2_device *sd = unit->device.driver_data;
>> +	int retval, lun;
>> +
>> +	if (sd->scsi_host != NULL)
>> +		return 0;
>> +
>> +	sd->scsi_host = scsi_host_alloc(&scsi_driver_template,
>> +					sizeof(unsigned long));
>> +	if (sd->scsi_host == NULL) {
>> +		fw_error("failed to register scsi host\n");
>> +		return -1;
>> +	}
>> +
>> +	sd->scsi_host->hostdata[0] = (unsigned long)unit;
> 
> Please take a look ar ther other scsi drivers how this is supposed
> to be used.

I was trying to be clever and only allocate the host once the device had been 
discovered and initialized.  I have now changed the code to just allocate the 
host up front and use the hostdata mechanism for the sbp2_device struct, which 
also addresses the host life cycle comments below.

>> +	retval = scsi_add_host(sd->scsi_host, &unit->device);
>> +	if (retval < 0) {
>> +		fw_error("failed to add scsi host\n");
>> +		scsi_host_put(sd->scsi_host);
>> +		sd->scsi_host = NULL;
>> +		return retval;
>> +	}
>> +
>> +	/* FIXME: Loop over luns here. */
>> +	lun = 0;
>> +	retval = scsi_add_device(sd->scsi_host, 0, 0, lun);
>> +	if (retval < 0) {
>> +		fw_error("failed to add scsi device\n");
>> +		scsi_remove_host(sd->scsi_host);
>> +		scsi_host_put(sd->scsi_host);
>> +		sd->scsi_host = NULL;
>> +		return retval;
>> +	}
>> +
>> +	return 0;
>> +}
> 
> Do we really need another scanning algorithm?  Can't you use
> scsi_scan_target instead and let the core scsi code handle the
> scanning?

Stefan addressed this one.

>> +
>> +static void remove_scsi_devices(struct fw_unit *unit)
>> +{
>> +	struct sbp2_device *sd = unit->device.driver_data;
>> +
>> +	if (sd->scsi_host != NULL) {
>> +		scsi_remove_host(sd->scsi_host);
>> +		scsi_host_put(sd->scsi_host);
>> +	}
>> +	sd->scsi_host = NULL;
>> +}
> 
> This function seems rather oddly named.  And the checking and
> setting of scsi_host looks like you have some lifetime rule
> problems.

Now fixed as described above.

Thanks for the review, will send out new patches.
Kristian


