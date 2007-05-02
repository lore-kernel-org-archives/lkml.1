Return-Path: <linux-kernel-owner+w=401wt.eu-S1766810AbXEBToR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766810AbXEBToR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 15:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766791AbXEBToQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 15:44:16 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37194 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766810AbXEBToK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 15:44:10 -0400
Date: Wed, 2 May 2007 20:44:08 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-kernel@vger.kernel.org, Kristian H??gsberg <krh@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux1394-devel <linux1394-devel@lists.sourceforge.net>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/6] firewire: SBP-2 highlevel driver
Message-ID: <20070502194408.GD1248@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	linux-kernel@vger.kernel.org, Kristian H??gsberg <krh@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux1394-devel <linux1394-devel@lists.sourceforge.net>
References: <4637A29F.6070302@redhat.com> <20070502090007.GA28174@infradead.org> <tkrat.087ee29add656926@s5r6.in-berlin.de> <tkrat.350cb4dfe522266e@s5r6.in-berlin.de> <tkrat.65aea95f1451c211@s5r6.in-berlin.de> <tkrat.2aa3f3ac11a3d60d@s5r6.in-berlin.de> <tkrat.a41f7f10d21d3cc4@s5r6.in-berlin.de> <tkrat.c82a1d775d989371@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tkrat.c82a1d775d989371@s5r6.in-berlin.de>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> +	sg = (struct scatterlist *)orb->cmd->request_buffer;
> +	count = dma_map_sg(device->card->device, sg, orb->cmd->use_sg,
> +			   orb->cmd->sc_data_direction);

you need to handle the error case (count == 0)

> +	/* Convert the scatterlist to an sbp2 page table.  If any
> +	 * scatterlist entries are too big for sbp2 we split the as we go. */

Please set the max_sectors value in your host template so that the
block layer doesn't build sg entries too big for you.

> +	orb->page_table_bus =
> +		dma_map_single(device->card->device, orb->page_table,
> +			       size, DMA_TO_DEVICE);

This needs handling of mapping errors (dma_mapping_error())

> +	orb = kzalloc(sizeof *orb, GFP_ATOMIC);

Normal kernel style is sizeof(*orb)

> +	if (cmd->use_sg) {
> +		sbp2_command_orb_map_scatterlist(orb);
> +	} else if (cmd->request_bufflen > SBP2_MAX_SG_ELEMENT_LENGTH) {
> +		/* FIXME: Need to split this into a sg list... but
> +		 * could we get the scsi or blk layer to do that by
> +		 * reporting our max supported block size? */
> +		fw_error("command > 64k\n");
> +		goto fail_bufflen;
> +	} else if (cmd->request_bufflen > 0) {
> +		sbp2_command_orb_map_buffer(orb);
> +	}

The use_sg == 0, request_bufflen != 0 case can't happen anymore.

> + fail_mapping:
> +	kfree(orb);
> + fail_alloc:
> +	cmd->result = DID_ERROR << 16;
> +	done(cmd);

Failure due to ressource shortage should not complete the command
but return SCSI_MLQUEUE_HOST_BUSY/SCSI_MLQUEUE_DEVICE_BUSY.

> +	return 0;
> +}

> +static struct scsi_host_template scsi_driver_template = {
> +	.module			= THIS_MODULE,
> +	.name			= "SBP-2 IEEE-1394",
> +	.proc_name		= (char *)sbp2_driver_name,

Please don't use casrs here.  Either fix up the definition so it
accepts const strings or pass a non-const one.

> +static int add_scsi_devices(struct fw_unit *unit)
> +{
> +	struct sbp2_device *sd = unit->device.driver_data;
> +	int retval, lun;
> +
> +	if (sd->scsi_host != NULL)
> +		return 0;
> +
> +	sd->scsi_host = scsi_host_alloc(&scsi_driver_template,
> +					sizeof(unsigned long));
> +	if (sd->scsi_host == NULL) {
> +		fw_error("failed to register scsi host\n");
> +		return -1;
> +	}
> +
> +	sd->scsi_host->hostdata[0] = (unsigned long)unit;

Please take a look ar ther other scsi drivers how this is supposed
to be used.

> +	retval = scsi_add_host(sd->scsi_host, &unit->device);
> +	if (retval < 0) {
> +		fw_error("failed to add scsi host\n");
> +		scsi_host_put(sd->scsi_host);
> +		sd->scsi_host = NULL;
> +		return retval;
> +	}
> +
> +	/* FIXME: Loop over luns here. */
> +	lun = 0;
> +	retval = scsi_add_device(sd->scsi_host, 0, 0, lun);
> +	if (retval < 0) {
> +		fw_error("failed to add scsi device\n");
> +		scsi_remove_host(sd->scsi_host);
> +		scsi_host_put(sd->scsi_host);
> +		sd->scsi_host = NULL;
> +		return retval;
> +	}
> +
> +	return 0;
> +}

Do we really need another scanning algorithm?  Can't you use
scsi_scan_target instead and let the core scsi code handle the
scanning?

> +
> +static void remove_scsi_devices(struct fw_unit *unit)
> +{
> +	struct sbp2_device *sd = unit->device.driver_data;
> +
> +	if (sd->scsi_host != NULL) {
> +		scsi_remove_host(sd->scsi_host);
> +		scsi_host_put(sd->scsi_host);
> +	}
> +	sd->scsi_host = NULL;
> +}

This function seems rather oddly named.  And the checking and
setting of scsi_host looks like you have some lifetime rule
problems.

