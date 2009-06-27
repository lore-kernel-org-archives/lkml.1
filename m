Return-Path: <linux-kernel-owner+w=401wt.eu-S1754902AbZF0JEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902AbZF0JEb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 05:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752859AbZF0JEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 05:04:22 -0400
Received: from smtp1.tech.numericable.fr ([82.216.111.37]:46035 "EHLO
	smtp1.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724AbZF0JEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 05:04:21 -0400
Message-ID: <4A45E095.5070608@numericable.fr>
Date: Sat, 27 Jun 2009 11:04:21 +0200
From: Etienne Basset <etienne.basset@numericable.fr>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: davem@davemloft.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [REGRESSION] 2.6.29=>2.6.30 suspend to ram regression (IDE related)
References: <4A44EBEE.9070503@numericable.fr> <200906262139.23367.bzolnier@gmail.com>
In-Reply-To: <200906262139.23367.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Bartlomiej Zolnierkiewicz wrote:
> Hi,
> 
> On Friday 26 June 2009 17:40:30 Etienne Basset wrote:
>> hello,
>>
>> kernel v2.6.29 suspends to RAM reliably on my computer; v2.6.30 doesn't resume after STR 
>> I tried also 2.6.31-rc1 doesn't work either
>> I bisected it to :
>>
>> etienne@etienne-desktop:~/linux-2.6$ git bisect bad
>> 2f0d0fd2a605666d38e290c5c0d2907484352dc4 is first bad commit
> 
> Does the following patch fix it?
> 
Yes, it works now
thanks!
Etienne



> ---
>  drivers/ide/ide-acpi.c |   37 +++++++------------------------------
>  drivers/ide/ide-pm.c   |   30 ++++++++++++++++++------------
>  include/linux/ide.h    |    2 ++
>  3 files changed, 27 insertions(+), 42 deletions(-)
> 
> Index: b/drivers/ide/ide-acpi.c
> ===================================================================
> --- a/drivers/ide/ide-acpi.c
> +++ b/drivers/ide/ide-acpi.c
> @@ -92,6 +92,11 @@ int ide_acpi_init(void)
>  	return 0;
>  }
>  
> +bool ide_port_acpi(ide_hwif_t *hwif)
> +{
> +	return ide_noacpi == 0 && hwif->acpidata;
> +}
> +
>  /**
>   * ide_get_dev_handle - finds acpi_handle and PCI device.function
>   * @dev: device to locate
> @@ -352,9 +357,6 @@ int ide_acpi_exec_tfs(ide_drive_t *drive
>  	unsigned long	gtf_address;
>  	unsigned long	obj_loc;
>  
> -	if (ide_noacpi)
> -		return 0;
> -
>  	DEBPRINT("call get_GTF, drive=%s port=%d\n", drive->name, drive->dn);
>  
>  	ret = do_drive_get_GTF(drive, &gtf_length, &gtf_address, &obj_loc);
> @@ -389,16 +391,6 @@ void ide_acpi_get_timing(ide_hwif_t *hwi
>  	struct acpi_buffer	output;
>  	union acpi_object 	*out_obj;
>  
> -	if (ide_noacpi)
> -		return;
> -
> -	DEBPRINT("ENTER:\n");
> -
> -	if (!hwif->acpidata) {
> -		DEBPRINT("no ACPI data for %s\n", hwif->name);
> -		return;
> -	}
> -
>  	/* Setting up output buffer for _GTM */
>  	output.length = ACPI_ALLOCATE_BUFFER;
>  	output.pointer = NULL;	/* ACPI-CA sets this; save/free it later */
> @@ -479,16 +471,6 @@ void ide_acpi_push_timing(ide_hwif_t *hw
>  	struct ide_acpi_drive_link	*master = &hwif->acpidata->master;
>  	struct ide_acpi_drive_link	*slave = &hwif->acpidata->slave;
>  
> -	if (ide_noacpi)
> -		return;
> -
> -	DEBPRINT("ENTER:\n");
> -
> -	if (!hwif->acpidata) {
> -		DEBPRINT("no ACPI data for %s\n", hwif->name);
> -		return;
> -	}
> -
>  	/* Give the GTM buffer + drive Identify data to the channel via the
>  	 * _STM method: */
>  	/* setup input parameters buffer for _STM */
> @@ -527,16 +509,11 @@ void ide_acpi_set_state(ide_hwif_t *hwif
>  	ide_drive_t *drive;
>  	int i;
>  
> -	if (ide_noacpi || ide_noacpi_psx)
> +	if (ide_noacpi_psx)
>  		return;
>  
>  	DEBPRINT("ENTER:\n");
>  
> -	if (!hwif->acpidata) {
> -		DEBPRINT("no ACPI data for %s\n", hwif->name);
> -		return;
> -	}
> -
>  	/* channel first and then drives for power on and verse versa for power off */
>  	if (on)
>  		acpi_bus_set_power(hwif->acpidata->obj_handle, ACPI_STATE_D0);
> @@ -616,7 +593,7 @@ void ide_acpi_port_init_devices(ide_hwif
>  				 drive->name, err);
>  	}
>  
> -	if (!ide_acpionboot) {
> +	if (ide_noacpi || ide_acpionboot == 0) {
>  		DEBPRINT("ACPI methods disabled on boot\n");
>  		return;
>  	}
> Index: b/drivers/ide/ide-pm.c
> ===================================================================
> --- a/drivers/ide/ide-pm.c
> +++ b/drivers/ide/ide-pm.c
> @@ -10,9 +10,11 @@ int generic_ide_suspend(struct device *d
>  	struct request_pm_state rqpm;
>  	int ret;
>  
> -	/* call ACPI _GTM only once */
> -	if ((drive->dn & 1) == 0 || pair == NULL)
> -		ide_acpi_get_timing(hwif);
> +	if (ide_port_acpi(hwif)) {
> +		/* call ACPI _GTM only once */
> +		if ((drive->dn & 1) == 0 || pair == NULL)
> +			ide_acpi_get_timing(hwif);
> +	}
>  
>  	memset(&rqpm, 0, sizeof(rqpm));
>  	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
> @@ -26,9 +28,11 @@ int generic_ide_suspend(struct device *d
>  	ret = blk_execute_rq(drive->queue, NULL, rq, 0);
>  	blk_put_request(rq);
>  
> -	/* call ACPI _PS3 only after both devices are suspended */
> -	if (ret == 0 && ((drive->dn & 1) || pair == NULL))
> -		ide_acpi_set_state(hwif, 0);
> +	if (ret == 0 && ide_port_acpi(hwif)) {
> +		/* call ACPI _PS3 only after both devices are suspended */
> +		if ((drive->dn & 1) || pair == NULL)
> +			ide_acpi_set_state(hwif, 0);
> +	}
>  
>  	return ret;
>  }
> @@ -42,13 +46,15 @@ int generic_ide_resume(struct device *de
>  	struct request_pm_state rqpm;
>  	int err;
>  
> -	/* call ACPI _PS0 / _STM only once */
> -	if ((drive->dn & 1) == 0 || pair == NULL) {
> -		ide_acpi_set_state(hwif, 1);
> -		ide_acpi_push_timing(hwif);
> -	}
> +	if (ide_port_acpi(hwif)) {
> +		/* call ACPI _PS0 / _STM only once */
> +		if ((drive->dn & 1) == 0 || pair == NULL) {
> +			ide_acpi_set_state(hwif, 1);
> +			ide_acpi_push_timing(hwif);
> +		}
>  
> -	ide_acpi_exec_tfs(drive);
> +		ide_acpi_exec_tfs(drive);
> +	}
>  
>  	memset(&rqpm, 0, sizeof(rqpm));
>  	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
> Index: b/include/linux/ide.h
> ===================================================================
> --- a/include/linux/ide.h
> +++ b/include/linux/ide.h
> @@ -1420,6 +1420,7 @@ static inline void ide_dma_unmap_sg(ide_
>  
>  #ifdef CONFIG_BLK_DEV_IDEACPI
>  int ide_acpi_init(void);
> +bool ide_port_acpi(ide_hwif_t *hwif);
>  extern int ide_acpi_exec_tfs(ide_drive_t *drive);
>  extern void ide_acpi_get_timing(ide_hwif_t *hwif);
>  extern void ide_acpi_push_timing(ide_hwif_t *hwif);
> @@ -1428,6 +1429,7 @@ void ide_acpi_port_init_devices(ide_hwif
>  extern void ide_acpi_set_state(ide_hwif_t *hwif, int on);
>  #else
>  static inline int ide_acpi_init(void) { return 0; }
> +static inline bool ide_port_acpi(ide_hwif_t *hwif) { return 0; }
>  static inline int ide_acpi_exec_tfs(ide_drive_t *drive) { return 0; }
>  static inline void ide_acpi_get_timing(ide_hwif_t *hwif) { ; }
>  static inline void ide_acpi_push_timing(ide_hwif_t *hwif) { ; }
> 

