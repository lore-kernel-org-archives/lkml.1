Return-Path: <linux-kernel-owner+w=401wt.eu-S1767108AbXEBVx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767108AbXEBVx5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 17:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767112AbXEBVx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 17:53:57 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:44088 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767108AbXEBVxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 17:53:55 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4639085A.8010504@s5r6.in-berlin.de>
Date: Wed, 02 May 2007 23:53:30 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
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
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
>> +	/* Convert the scatterlist to an sbp2 page table.  If any
>> +	 * scatterlist entries are too big for sbp2 we split the as we go. */
> 
> Please set the max_sectors value in your host template so that the
> block layer doesn't build sg entries too big for you.

Hmm, what about this:

James Bottomley wrote on 2007-01-15:
| Actually, there's one unfortunate case where Linux won't respect this:
| an IOMMU that can do virtual merging.  This parameter is a block queue
| parameter, so block will happily make sure the request segments obey it.
| However, when you get to dma_map_rq() it doesn't see the segment limits,
| so, if the iommu merges, you can end up with SG elements the other side
| that violate this.  I've been meaning to do something about this for
| ages (IDE is the other subsystem that has an absolute requirement for a
| fixed maximum segment size) but never found an excuse to fix it.

http://marc.info/?l=linux-scsi&m=116889641203397


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

Do you mean the one Scsi_Host per LU?  If it is that, then it was just
taken over from drivers/ieee1394/sbp2.c.  Sbp2 is doing this still today
mostly for historical reasons; I just didn't find the time yet to try to
get to a leaner scheme.

Or do you mean something else?


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
> Do we really need another scanning algorithm?

Yes.

> Can't you use scsi_scan_target instead and let the core scsi code
> handle the scanning?

No.  The discovery of LUs of SBP-2 targets happens on the IEEE 1212
level of things.  The initiator has to parse the configuration ROM of
the target FireWire node; the ROM has entries for each LU.  (After that,
SBP-2 login protocol commences for each LU, and only after that can SCSI
requests be issued.  There is nothing SCSIish going on before that.)

What's missing as a /* FIXME */ here is actually implemented in the
mainline sbp2.c and needs to be brought over here; converted to the new
FireWire core APIs.


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
> 

The NULL probably has to do with the ability to call remove_scsi_devices
in different paths.  (These paths are not concurrent.)
-- 
Stefan Richter
-=====-=-=== -=-= ---=-
http://arcgraph.de/sr/
