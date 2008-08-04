Return-Path: <linux-kernel-owner+w=401wt.eu-S1753115AbYHDFl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115AbYHDFl6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 01:41:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759277AbYHDFlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 01:41:46 -0400
Received: from gate.crashing.org ([63.228.1.57]:42482 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759257AbYHDFlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 01:41:45 -0400
Subject: Re: [PATCH] ide: fix regression caused by ide_device_{get,put}()
	addition (take 2)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Borislav Petkov <petkovbb@gmail.com>
In-Reply-To: <200808031648.57513.bzolnier@gmail.com>
References: <200808031648.57513.bzolnier@gmail.com>
Content-Type: text/plain
Date: Mon, 04 Aug 2008 15:41:30 +1000
Message-Id: <1217828490.24157.57.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-08-03 at 16:48 +0200, Bartlomiej Zolnierkiewicz wrote:
> Ben, please use this version instead
> (together with ide_host_alloc_all() fix)
> for media-bay testing.
> 
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] ide: fix regression caused by ide_device_{get,put}() addition (take 2)

What is the ide_host_alloc_all() fix ? 

Ben.

> On Monday 28 July 2008, Benjamin Herrenschmidt wrote:
> 
> [...]
> 
> > Vector: 300 (Data Access) at [c58b7b80]
> >     pc: c014f264: elv_may_queue+0x10/0x44
> >     lr: c0152750: get_request+0x2c/0x2c0
> >     sp: c58b7c30
> >    msr: 1032
> >    dar: c
> >  dsisr: 40000000
> >   current = 0xc58aaae0
> >     pid   = 854, comm = media-bay
> > enter ? for help
> > mon> t
> > [c58b7c40] c0152750 get_request+0x2c/0x2c0
> > [c58b7c70] c0152a08 get_request_wait+0x24/0xec
> > [c58b7cc0] c0225674 ide_cd_queue_pc+0x58/0x1a0
> > [c58b7d40] c022672c ide_cdrom_packet+0x9c/0xdc
> > [c58b7d70] c0261810 cdrom_get_disc_info+0x60/0xd0
> > [c58b7dc0] c026208c cdrom_mrw_exit+0x1c/0x11c
> > [c58b7e30] c0260f7c unregister_cdrom+0x84/0xe8
> > [c58b7e50] c022395c ide_cd_release+0x80/0x84
> > [c58b7e70] c0163650 kref_put+0x54/0x6c
> > [c58b7e80] c0223884 ide_cd_put+0x40/0x5c
> > [c58b7ea0] c0211100 generic_ide_remove+0x28/0x3c
> > [c58b7eb0] c01e9d34 __device_release_driver+0x78/0xb4
> > [c58b7ec0] c01e9e44 device_release_driver+0x28/0x44
> > [c58b7ee0] c01e8f7c bus_remove_device+0xac/0xd8
> > [c58b7f00] c01e7424 device_del+0x104/0x198
> > [c58b7f20] c01e74d0 device_unregister+0x18/0x30
> > [c58b7f40] c02121c4 __ide_port_unregister_devices+0x6c/0x88
> > [c58b7f60] c0212398 ide_port_unregister_devices+0x38/0x80
> > [c58b7f80] c0208ca4 media_bay_step+0x1cc/0x5c0
> > [c58b7fb0] c0209124 media_bay_task+0x8c/0xcc
> > [c58b7fd0] c00485c0 kthread+0x48/0x84
> > [c58b7ff0] c0011b20 kernel_thread+0x44/0x60
> 
> The guilty commit turned out to be 08da591e14cf87247ec09b17c350235157a92fc3
> ("ide: add ide_device_{get,put}() helpers").  ide_device_put() is called
> before kref_put() in ide_cd_put() so IDE device is already gone by the time
> ide_cd_release() is reached.
> 
> Fix it by calling ide_device_get() before kref_get() and ide_device_put()
> after kref_put() in all affected device drivers.
> 
> v2:
> Brown paper bag time.  In v1 cd->drive was referenced after dropping last
> reference on cd object (which could result in OOPS in ide_device_put() as
> reported/debugged by Mariusz Kozlowski).  Fix it by caching cd->drive in
> the local variable (fix other device drivers too).
> 
> Reported-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Reported-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
> Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: Borislav Petkov <petkovbb@gmail.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
> replacement patch
> 
>  drivers/ide/ide-cd.c     |   12 +++++++-----
>  drivers/ide/ide-disk.c   |   11 ++++++-----
>  drivers/ide/ide-floppy.c |   11 ++++++-----
>  drivers/ide/ide-tape.c   |   11 ++++++-----
>  drivers/scsi/ide-scsi.c  |   11 ++++++-----
>  5 files changed, 31 insertions(+), 25 deletions(-)
> 
> Index: b/drivers/ide/ide-cd.c
> ===================================================================
> --- a/drivers/ide/ide-cd.c
> +++ b/drivers/ide/ide-cd.c
> @@ -66,11 +66,11 @@ static struct cdrom_info *ide_cd_get(str
>  	mutex_lock(&idecd_ref_mutex);
>  	cd = ide_cd_g(disk);
>  	if (cd) {
> -		kref_get(&cd->kref);
> -		if (ide_device_get(cd->drive)) {
> -			kref_put(&cd->kref, ide_cd_release);
> +		if (ide_device_get(cd->drive))
>  			cd = NULL;
> -		}
> +		else
> +			kref_get(&cd->kref);
> +
>  	}
>  	mutex_unlock(&idecd_ref_mutex);
>  	return cd;
> @@ -78,9 +78,11 @@ static struct cdrom_info *ide_cd_get(str
>  
>  static void ide_cd_put(struct cdrom_info *cd)
>  {
> +	ide_drive_t *drive = cd->drive;
> +
>  	mutex_lock(&idecd_ref_mutex);
> -	ide_device_put(cd->drive);
>  	kref_put(&cd->kref, ide_cd_release);
> +	ide_device_put(drive);
>  	mutex_unlock(&idecd_ref_mutex);
>  }
>  
> Index: b/drivers/ide/ide-disk.c
> ===================================================================
> --- a/drivers/ide/ide-disk.c
> +++ b/drivers/ide/ide-disk.c
> @@ -63,11 +63,10 @@ static struct ide_disk_obj *ide_disk_get
>  	mutex_lock(&idedisk_ref_mutex);
>  	idkp = ide_disk_g(disk);
>  	if (idkp) {
> -		kref_get(&idkp->kref);
> -		if (ide_device_get(idkp->drive)) {
> -			kref_put(&idkp->kref, ide_disk_release);
> +		if (ide_device_get(idkp->drive))
>  			idkp = NULL;
> -		}
> +		else
> +			kref_get(&idkp->kref);
>  	}
>  	mutex_unlock(&idedisk_ref_mutex);
>  	return idkp;
> @@ -75,9 +74,11 @@ static struct ide_disk_obj *ide_disk_get
>  
>  static void ide_disk_put(struct ide_disk_obj *idkp)
>  {
> +	ide_drive_t *drive = idkp->drive;
> +
>  	mutex_lock(&idedisk_ref_mutex);
> -	ide_device_put(idkp->drive);
>  	kref_put(&idkp->kref, ide_disk_release);
> +	ide_device_put(drive);
>  	mutex_unlock(&idedisk_ref_mutex);
>  }
>  
> Index: b/drivers/ide/ide-floppy.c
> ===================================================================
> --- a/drivers/ide/ide-floppy.c
> +++ b/drivers/ide/ide-floppy.c
> @@ -168,11 +168,10 @@ static struct ide_floppy_obj *ide_floppy
>  	mutex_lock(&idefloppy_ref_mutex);
>  	floppy = ide_floppy_g(disk);
>  	if (floppy) {
> -		kref_get(&floppy->kref);
> -		if (ide_device_get(floppy->drive)) {
> -			kref_put(&floppy->kref, idefloppy_cleanup_obj);
> +		if (ide_device_get(floppy->drive))
>  			floppy = NULL;
> -		}
> +		else
> +			kref_get(&floppy->kref);
>  	}
>  	mutex_unlock(&idefloppy_ref_mutex);
>  	return floppy;
> @@ -180,9 +179,11 @@ static struct ide_floppy_obj *ide_floppy
>  
>  static void ide_floppy_put(struct ide_floppy_obj *floppy)
>  {
> +	ide_drive_t *drive = floppy->drive;
> +
>  	mutex_lock(&idefloppy_ref_mutex);
> -	ide_device_put(floppy->drive);
>  	kref_put(&floppy->kref, idefloppy_cleanup_obj);
> +	ide_device_put(drive);
>  	mutex_unlock(&idefloppy_ref_mutex);
>  }
>  
> Index: b/drivers/ide/ide-tape.c
> ===================================================================
> --- a/drivers/ide/ide-tape.c
> +++ b/drivers/ide/ide-tape.c
> @@ -331,11 +331,10 @@ static struct ide_tape_obj *ide_tape_get
>  	mutex_lock(&idetape_ref_mutex);
>  	tape = ide_tape_g(disk);
>  	if (tape) {
> -		kref_get(&tape->kref);
> -		if (ide_device_get(tape->drive)) {
> -			kref_put(&tape->kref, ide_tape_release);
> +		if (ide_device_get(tape->drive))
>  			tape = NULL;
> -		}
> +		else
> +			kref_get(&tape->kref);
>  	}
>  	mutex_unlock(&idetape_ref_mutex);
>  	return tape;
> @@ -343,9 +342,11 @@ static struct ide_tape_obj *ide_tape_get
>  
>  static void ide_tape_put(struct ide_tape_obj *tape)
>  {
> +	ide_drive_t *drive = tape->drive;
> +
>  	mutex_lock(&idetape_ref_mutex);
> -	ide_device_put(tape->drive);
>  	kref_put(&tape->kref, ide_tape_release);
> +	ide_device_put(drive);
>  	mutex_unlock(&idetape_ref_mutex);
>  }
>  
> Index: b/drivers/scsi/ide-scsi.c
> ===================================================================
> --- a/drivers/scsi/ide-scsi.c
> +++ b/drivers/scsi/ide-scsi.c
> @@ -101,11 +101,10 @@ static struct ide_scsi_obj *ide_scsi_get
>  	mutex_lock(&idescsi_ref_mutex);
>  	scsi = ide_scsi_g(disk);
>  	if (scsi) {
> -		scsi_host_get(scsi->host);
> -		if (ide_device_get(scsi->drive)) {
> -			scsi_host_put(scsi->host);
> +		if (ide_device_get(scsi->drive))
>  			scsi = NULL;
> -		}
> +		else
> +			scsi_host_get(scsi->host);
>  	}
>  	mutex_unlock(&idescsi_ref_mutex);
>  	return scsi;
> @@ -113,9 +112,11 @@ static struct ide_scsi_obj *ide_scsi_get
>  
>  static void ide_scsi_put(struct ide_scsi_obj *scsi)
>  {
> +	ide_drive_t *drive = scsi->drive;
> +
>  	mutex_lock(&idescsi_ref_mutex);
> -	ide_device_put(scsi->drive);
>  	scsi_host_put(scsi->host);
> +	ide_device_put(drive);
>  	mutex_unlock(&idescsi_ref_mutex);
>  }
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ide" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

