Return-Path: <linux-kernel-owner+w=401wt.eu-S1755019AbYITAT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019AbYITAT4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 20:19:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752455AbYITATs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 20:19:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57753 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752138AbYITATr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 20:19:47 -0400
Date: Fri, 19 Sep 2008 17:19:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: scameron@beardog.cca.cpqcorp.net
Cc: linux-kernel@vger.kernel.org, mike.miller@hp.com, axboe@kernel.dk,
       scameron@beardog.cca.cpqcorp.net
Subject: Re: [patch] cciss: Fix cciss SCSI rescan code to better notice
 device changes.
Message-Id: <20080919171931.e7e7b731.akpm@linux-foundation.org>
In-Reply-To: <20080918200744.GA24032@beardog.cca.cpqcorp.net>
References: <20080918200744.GA24032@beardog.cca.cpqcorp.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Sep 2008 15:07:44 -0500
scameron@beardog.cca.cpqcorp.net wrote:

> 
> Fix cciss SCSI rescan code to better notice device changes.
> If you hot-unplug a tape drive, then hot-plug a different
> tape drive into the same slot in a storage enclosure,
> the cciss driver wouldn't notice anything had changed, as
> it was only looking at the LUN address and device type.
> Now it looks at the inquiry page 0x83 device identifier,
> and vendor and model strings as well.
> 
> ...
>
> diff -puN drivers/block/cciss_scsi.c~cciss_fix_hotplug_tape_bug drivers/block/cciss_scsi.c
> --- linux-2.6.27-rc6/drivers/block/cciss_scsi.c~cciss_fix_hotplug_tape_bug	2008-09-18 07:34:58.000000000 -0500
> +++ linux-2.6.27-rc6-scameron/drivers/block/cciss_scsi.c	2008-09-18 07:35:13.000000000 -0500
> @@ -365,7 +365,7 @@ struct scsi2map {
>  
>  static int 
>  cciss_scsi_add_entry(int ctlr, int hostno, 
> -		unsigned char *scsi3addr, int devtype,
> +		struct cciss_scsi_dev_t *device,
>  		struct scsi2map *added, int *nadded)
>  {
>  	/* assumes hba[ctlr]->scsi_ctlr->lock is held */ 
> @@ -384,12 +384,12 @@ cciss_scsi_add_entry(int ctlr, int hostn
>  	lun = 0;
>  	/* Is this device a non-zero lun of a multi-lun device */
>  	/* byte 4 of the 8-byte LUN addr will contain the logical unit no. */
> -	if (scsi3addr[4] != 0) {
> +	if (device->scsi3addr[4] != 0) {
>  		/* Search through our list and find the device which */
>  		/* has the same 8 byte LUN address, excepting byte 4. */
>  		/* Assign the same bus and target for this new LUN. */
>  		/* Use the logical unit number from the firmware. */
> -		memcpy(addr1, scsi3addr, 8);
> +		memcpy(addr1, device->scsi3addr, 8);
>  		addr1[4] = 0;
>  		for (i = 0; i < n; i++) {
>  			sd = &ccissscsi[ctlr].dev[i];
> @@ -399,7 +399,7 @@ cciss_scsi_add_entry(int ctlr, int hostn
>  			if (memcmp(addr1, addr2, 8) == 0) {
>  				bus = sd->bus;
>  				target = sd->target;
> -				lun = scsi3addr[4];
> +				lun = device->scsi3addr[4];
>  				break;
>  			}
>  		}
> @@ -420,8 +420,12 @@ cciss_scsi_add_entry(int ctlr, int hostn
>  	added[*nadded].lun = sd->lun;
>  	(*nadded)++;
>  
> -	memcpy(&sd->scsi3addr[0], scsi3addr, 8);
> -	sd->devtype = devtype;
> +	memcpy(sd->scsi3addr, device->scsi3addr, 8);
> +	memcpy(sd->vendor, device->vendor, sizeof(sd->vendor));
> +	memcpy(sd->revision, device->revision, sizeof(sd->revision));
> +	memcpy(sd->device_id, device->device_id, sizeof(sd->device_id));
> +	sd->devtype = device->devtype;

y'know, it would be a lot simpler to just do

	*sd = *device;

a few lines up, before assigning sd->bus/target/lun.

Putting these:

@@ -66,6 +66,10 @@ struct cciss_scsi_dev_t {
 	int devtype;
 	int bus, target, lun;		/* as presented to the OS */
 	unsigned char scsi3addr[8];	/* as presented to the HW */
+	unsigned char device_id[16];	/* from inquiry pg. 0x83 */
+	unsigned char vendor[8];	/* bytes 8-15 of inquiry data */
+	unsigned char model[16];	/* bytes 16-31 of inquiry data */
+	unsigned char revision[4];	/* bytes 32-35 of inquiry data */
 };

into a separate nested structure might make that neater still.

>  	ccissscsi[ctlr].ndevices++;
>  
>  	/* initially, (before registering with scsi layer) we don't 
> @@ -487,6 +491,22 @@ static void fixup_botched_add(int ctlr, 
>  	CPQ_TAPE_UNLOCK(ctlr, flags);
>  }
>  
> +static int device_is_the_same(struct cciss_scsi_dev_t *dev1,
> +	struct cciss_scsi_dev_t *dev2)

`struct cciss_scsi_dev_t' should have been named `struct cciss_scsi_dev',
but I guess I'm a bit late to that party.

> +{
> +	return dev1->devtype == dev2->devtype &&
> +		memcmp(dev1->scsi3addr, dev2->scsi3addr,
> +			sizeof(dev1->scsi3addr)) == 0 &&
> +		memcmp(dev1->device_id, dev2->device_id,
> +			sizeof(dev1->device_id)) == 0 &&
> +		memcmp(dev1->vendor, dev2->vendor,
> +			sizeof(dev1->vendor)) == 0 &&
> +		memcmp(dev1->model, dev2->model,
> +			sizeof(dev1->model)) == 0 &&
> +		memcmp(dev1->revision, dev2->revision,
> +			sizeof(dev1->revision)) == 0;
> +}
> +
> 
> ...
>
> +		} else if (found == 1) { /* device is different in some way */
>  			changes++;
> -			printk("cciss%d: device c%db%dt%dl%d type changed "
> -				"(device type now %s).\n",
> -				ctlr, hostno, csd->bus, csd->target, csd->lun,
> -					scsi_device_type(csd->devtype));
> +			printk("cciss%d: device c%db%dt%dl%d has changed.\n",
> +				ctlr, hostno, csd->bus, csd->target, csd->lun);
>  			cciss_scsi_remove_entry(ctlr, hostno, i,
>  				removed, &nremoved);
>  			/* remove ^^^, hence i not incremented */
> -			if (cciss_scsi_add_entry(ctlr, hostno,
> -				&sd[j].scsi3addr[0], sd[j].devtype,
> +			if (cciss_scsi_add_entry(ctlr, hostno, &sd[j],
>  				added, &nadded) != 0)
>  				/* we just removed one, so add can't fail. */
>  					BUG();
>  			csd->devtype = sd[j].devtype;
> +			memcpy(csd->device_id, sd[j].device_id,
> +				sizeof(csd->device_id));
> +			memcpy(csd->vendor, sd[j].vendor,
> +				sizeof(csd->vendor));
> +			memcpy(csd->model, sd[j].model,
> +				sizeof(csd->model));
> +			memcpy(csd->revision, sd[j].revision,
> +				sizeof(csd->revision));

didn't cciss_scsi_add_entry() just do that?  I didn't look too closely,
so maybe it didn't, and we're taking two copies for some reason. 
Please double-check?


>  		} else 		/* device is same as it ever was, */
>  			i++;	/* so just move along. */
>  	}
> 
> ...
>
> +/* Get the device id from inquiry page 0x83 */
> +static int cciss_scsi_get_device_id(ctlr_info_t *c, unsigned char *scsi3addr,
> +	unsigned char *device_id, int buflen)
> +{
> +	int rc;
> +	unsigned char *buf;
> +
> +	if (buflen > 16)
> +		buflen = 16;
> +	buf = kzalloc(64, GFP_KERNEL);
> +	if (!buf)
> +		return -1;
> +	rc = cciss_scsi_do_inquiry(c, scsi3addr, 0x83, buf, 64);
> +	if (rc == 0)
> +		memcpy(device_id, &buf[8], buflen);
> +	kfree(buf);
> +	return rc != 0;
> +}

The caller ignores the error return from this function.  I guess that's
reasonable, and kzalloc() will have spewed a bit warning anyway..


>  static int
>  cciss_scsi_do_report_phys_luns(ctlr_info_t *c, 
>  		ReportLunData_struct *buf, int bufsize)
> @@ -1142,25 +1184,21 @@ cciss_update_non_disk_devices(int cntl_n
>  	ctlr_info_t *c;
>  	__u32 num_luns=0;
>  	unsigned char *ch;
> -	/* unsigned char found[CCISS_MAX_SCSI_DEVS_PER_HBA]; */
> -	struct cciss_scsi_dev_t currentsd[CCISS_MAX_SCSI_DEVS_PER_HBA];
> +	struct cciss_scsi_dev_t *currentsd, *this_device;
>  	int ncurrent=0;
>  	int reportlunsize = sizeof(*ld_buff) + CISS_MAX_PHYS_LUN * 8;
>  	int i;
>  
>  	c = (ctlr_info_t *) hba[cntl_num];	
>  	ld_buff = kzalloc(reportlunsize, GFP_KERNEL);
> -	if (ld_buff == NULL) {
> -		printk(KERN_ERR "cciss: out of memory\n");
> -		return;
> -	}
>  	inq_buff = kmalloc(OBDR_TAPE_INQ_SIZE, GFP_KERNEL);
> -        if (inq_buff == NULL) {
> -                printk(KERN_ERR "cciss: out of memory\n");
> -                kfree(ld_buff);
> -                return;
> +	currentsd = kzalloc(sizeof(*currentsd) *
> +			(CCISS_MAX_SCSI_DEVS_PER_HBA+1), GFP_KERNEL);

That's kcalloc().

> +	if (ld_buff == NULL || inq_buff == NULL || currentsd == NULL) {
> +		printk(KERN_ERR "cciss: out of memory\n");
> +		goto out;
>  	}
> -
> +	this_device = &currentsd[CCISS_MAX_SCSI_DEVS_PER_HBA];
>  	if (cciss_scsi_do_report_phys_luns(c, ld_buff, reportlunsize) == 0) {
>  		ch = &ld_buff->LUNListLength[0];
>  		num_luns = ((ch[0]<<24) | (ch[1]<<16) | (ch[2]<<8) | ch[3]) / 8;
> @@ -1179,23 +1217,34 @@ cciss_update_non_disk_devices(int cntl_n
> 
> ...
>
> +	for (i = 0; i < num_luns; i++) {
>  		/* for each physical lun, do an inquiry */
>  		if (ld_buff->LUN[i][3] & 0xC0) continue;
>  		memset(inq_buff, 0, OBDR_TAPE_INQ_SIZE);
>  		memcpy(&scsi3addr[0], &ld_buff->LUN[i][0], 8);
>  
> -		if (cciss_scsi_do_inquiry(hba[cntl_num], scsi3addr, inq_buff,
> -			(unsigned char) OBDR_TAPE_INQ_SIZE) != 0) {
> +		if (cciss_scsi_do_inquiry(hba[cntl_num], scsi3addr, 0, inq_buff,
> +			(unsigned char) OBDR_TAPE_INQ_SIZE) != 0)
>  			/* Inquiry failed (msg printed already) */
> -			devtype = 0; /* so we will skip this device. */
> -		} else /* what kind of device is this? */
> -			devtype = (inq_buff[0] & 0x1f);
> +			continue; /* so we will skip this device. */
> +
> +		this_device->devtype = (inq_buff[0] & 0x1f);
> +		this_device->bus = -1;
> +		this_device->target = -1;
> +		this_device->lun = -1;
> +		memcpy(this_device->scsi3addr, scsi3addr, 8);
> +		memcpy(this_device->vendor, &inq_buff[8],
> +			sizeof(this_device->vendor));
> +		memcpy(this_device->model, &inq_buff[16],
> +			sizeof(this_device->model));
> +		memcpy(this_device->revision, &inq_buff[32],
> +			sizeof(this_device->revision));
> +		memset(this_device->device_id, 0,
> +			sizeof(this_device->device_id));
> +		cciss_scsi_get_device_id(hba[cntl_num], scsi3addr,
> +			this_device->device_id, sizeof(this_device->device_id));

Quite a bit of duplication.  Perhaps a helper function is needed somewhere.

>  
> -		switch (devtype)
> +		switch (this_device->devtype)
>  		{
>  		  case 0x05: /* CD-ROM */ {
>  
> 
> ...
>

