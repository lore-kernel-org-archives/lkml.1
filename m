Return-Path: <linux-kernel-owner+w=401wt.eu-S1423043AbXDXTVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423043AbXDXTVQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 15:21:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423049AbXDXTVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 15:21:15 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:41694 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423043AbXDXTVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 15:21:14 -0400
X-Greylist: delayed 1837 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Apr 2007 15:21:13 EDT
Date: Tue, 24 Apr 2007 20:50:17 +0200 (CEST)
From: Eberhard Moenkeberg <emoenke@gwdg.de>
To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] use mutex instead of semaphore in SBPCD driver
In-Reply-To: <20070424184617.GF6798@traven>
Message-ID: <Pine.LNX.4.64.0704242046410.7943@gwdu05.gwdg.de>
References: <20070424184617.GF6798@traven>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1283851528-2129825481-1177440617=:7943"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1283851528-2129825481-1177440617=:7943
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hi,

OK for me.

Viele Gr=FC=DFe
Eberhard M=F6nkeberg (emoenke@gwdg.de, em@kki.org)
=20

On Tue, 24 Apr 2007, Matthias Kaehlcke wrote:

> the SBPCD driver uses a semaphore as mutex. use the mutex API
> instead of the (binary) semaphore
>=20
> Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
>=20
> --
>=20
> diff --git a/drivers/cdrom/sbpcd.c b/drivers/cdrom/sbpcd.c
> index a1283b1..5c6a8d3 100644
> --- a/drivers/cdrom/sbpcd.c
> +++ b/drivers/cdrom/sbpcd.c
> @@ -602,7 +602,7 @@ static u_char xa_tail_buf[CD_XA_TAIL];
>  static volatile u_char busy_data;
>  static volatile u_char busy_audio; /* true semaphores would be safer */
>  #endif /* OLD_BUSY */=20
> -static DECLARE_MUTEX(ioctl_read_sem);
> +static DEFINE_MUTEX(ioctl_read_mtx);
>  static u_long timeout;
>  static volatile u_char timed_out_delay;
>  static volatile u_char timed_out_data;
> @@ -834,7 +834,7 @@ static void sbp_sleep(u_int time)
>  =09sti();
>  }
>  /*=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D*/
> -#define RETURN_UP(rc) {up(&ioctl_read_sem); return(rc);}
> +#define RETURN_UNLOCK(rc) {mutex_unlock(&ioctl_read_mtx); return(rc);}
>  /*=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D*/
>  /*
>   *  convert logical_block_address to m-s-f_number (3 bytes only)
> @@ -4174,7 +4174,7 @@ static int sbpcd_audio_ioctl(struct cdrom_device_in=
fo *cdi, u_int cmd,
>  =09=09msg(DBG_INF, "ioctl: bad device: %s\n", cdi->name);
>  =09=09return (-ENXIO);             /* no such drive */
>  =09}
> -=09down(&ioctl_read_sem);
> +=09mutex_lock(&ioctl_read_mtx);
>  =09if (p !=3D current_drive)
>  =09=09switch_drive(p);
>  =09
> @@ -4193,19 +4193,19 @@ static int sbpcd_audio_ioctl(struct cdrom_device_=
info *cdi, u_int cmd,
>  =09=09case audio_playing:
>  =09=09=09if (famL_drive) i=3Dcc_ReadSubQ();
>  =09=09=09else i=3Dcc_Pause_Resume(1);
> -=09=09=09if (i<0) RETURN_UP(-EIO);
> +=09=09=09if (i<0) RETURN_UNLOCK(-EIO);
>  =09=09=09if (famL_drive) i=3Dcc_Pause_Resume(1);
>  =09=09=09else i=3Dcc_ReadSubQ();
> -=09=09=09if (i<0) RETURN_UP(-EIO);
> +=09=09=09if (i<0) RETURN_UNLOCK(-EIO);
>  =09=09=09current_drive->pos_audio_start=3Dcurrent_drive->SubQ_run_tot;
>  =09=09=09current_drive->audio_state=3Daudio_pausing;
> -=09=09=09RETURN_UP(0);
> +=09=09=09RETURN_UNLOCK(0);
>  =09=09case audio_pausing:
>  =09=09=09i=3Dcc_Seek(current_drive->pos_audio_start,1);
> -=09=09=09if (i<0) RETURN_UP(-EIO);
> -=09=09=09RETURN_UP(0);
> +=09=09=09if (i<0) RETURN_UNLOCK(-EIO);
> +=09=09=09RETURN_UNLOCK(0);
>  =09=09default:
> -=09=09=09RETURN_UP(-EINVAL);
> +=09=09=09RETURN_UNLOCK(-EINVAL);
>  =09=09}
> =20
>  =09case CDROMRESUME: /* resume paused audio play */
> @@ -4213,26 +4213,26 @@ static int sbpcd_audio_ioctl(struct cdrom_device_=
info *cdi, u_int cmd,
>  =09=09/* resume playing audio tracks when a previous PLAY AUDIO call has=
  */
>  =09=09/* been paused with a PAUSE command.                              =
  */
>  =09=09/* It will resume playing from the location saved in SubQ_run_tot.=
  */
> -=09=09if (current_drive->audio_state!=3Daudio_pausing) RETURN_UP(-EINVAL=
);
> +=09=09if (current_drive->audio_state!=3Daudio_pausing) RETURN_UNLOCK(-EI=
NVAL);
>  =09=09if (famL_drive)
>  =09=09=09i=3Dcc_PlayAudio(current_drive->pos_audio_start,
>  =09=09=09=09       current_drive->pos_audio_end);
>  =09=09else i=3Dcc_Pause_Resume(3);
> -=09=09if (i<0) RETURN_UP(-EIO);
> +=09=09if (i<0) RETURN_UNLOCK(-EIO);
>  =09=09current_drive->audio_state=3Daudio_playing;
> -=09=09RETURN_UP(0);
> +=09=09RETURN_UNLOCK(0);
> =20
>  =09case CDROMPLAYMSF:
>  =09=09msg(DBG_IOC,"ioctl: CDROMPLAYMSF entered.\n");
>  #ifdef SAFE_MIXED
> -=09=09if (current_drive->has_data>1) RETURN_UP(-EBUSY);
> +=09=09if (current_drive->has_data>1) RETURN_UNLOCK(-EBUSY);
>  #endif /* SAFE_MIXED */
>  =09=09if (current_drive->audio_state=3D=3Daudio_playing)
>  =09=09{
>  =09=09=09i=3Dcc_Pause_Resume(1);
> -=09=09=09if (i<0) RETURN_UP(-EIO);
> +=09=09=09if (i<0) RETURN_UNLOCK(-EIO);
>  =09=09=09i=3Dcc_ReadSubQ();
> -=09=09=09if (i<0) RETURN_UP(-EIO);
> +=09=09=09if (i<0) RETURN_UNLOCK(-EIO);
>  =09=09=09current_drive->pos_audio_start=3Dcurrent_drive->SubQ_run_tot;
>  =09=09=09i=3Dcc_Seek(current_drive->pos_audio_start,1);
>  =09=09}
> @@ -4252,30 +4252,30 @@ static int sbpcd_audio_ioctl(struct cdrom_device_=
info *cdi, u_int cmd,
>  =09=09=09msg(DBG_INF,"ioctl: cc_PlayAudio returns %d\n",i);
>  =09=09=09DriveReset();
>  =09=09=09current_drive->audio_state=3D0;
> -=09=09=09RETURN_UP(-EIO);
> +=09=09=09RETURN_UNLOCK(-EIO);
>  =09=09}
>  =09=09current_drive->audio_state=3Daudio_playing;
> -=09=09RETURN_UP(0);
> +=09=09RETURN_UNLOCK(0);
>  =09=09
>  =09case CDROMPLAYTRKIND: /* Play a track.  This currently ignores index.=
 */
>  =09=09msg(DBG_IOC,"ioctl: CDROMPLAYTRKIND entered.\n");
>  #ifdef SAFE_MIXED
> -=09=09if (current_drive->has_data>1) RETURN_UP(-EBUSY);
> +=09=09if (current_drive->has_data>1) RETURN_UNLOCK(-EBUSY);
>  #endif /* SAFE_MIXED */
>  =09=09if (current_drive->audio_state=3D=3Daudio_playing)
>  =09=09{
>  =09=09=09msg(DBG_IOX,"CDROMPLAYTRKIND: already audio_playing.\n");
>  #if 1
> -=09=09=09RETURN_UP(0); /* just let us play on */
> +=09=09=09RETURN_UNLOCK(0); /* just let us play on */
>  #else
> -=09=09=09RETURN_UP(-EINVAL); /* play on, but say "error" */
> +=09=09=09RETURN_UNLOCK(-EINVAL); /* play on, but say "error" */
>  #endif
>  =09=09}
>  =09=09memcpy(&ti,(void *) arg,sizeof(struct cdrom_ti));
>  =09=09msg(DBG_IOX,"ioctl: trk0: %d, ind0: %d, trk1:%d, ind1:%d\n",
>  =09=09    ti.cdti_trk0,ti.cdti_ind0,ti.cdti_trk1,ti.cdti_ind1);
> -=09=09if (ti.cdti_trk0<current_drive->n_first_track) RETURN_UP(-EINVAL);
> -=09=09if (ti.cdti_trk0>current_drive->n_last_track) RETURN_UP(-EINVAL);
> +=09=09if (ti.cdti_trk0<current_drive->n_first_track) RETURN_UNLOCK(-EINV=
AL);
> +=09=09if (ti.cdti_trk0>current_drive->n_last_track) RETURN_UNLOCK(-EINVA=
L);
>  =09=09if (ti.cdti_trk1<ti.cdti_trk0) ti.cdti_trk1=3Dti.cdti_trk0;
>  =09=09if (ti.cdti_trk1>current_drive->n_last_track) ti.cdti_trk1=3Dcurre=
nt_drive->n_last_track;
>  =09=09current_drive->pos_audio_start=3Dcurrent_drive->TocBuffer[ti.cdti_=
trk0].address;
> @@ -4286,17 +4286,17 @@ static int sbpcd_audio_ioctl(struct cdrom_device_=
info *cdi, u_int cmd,
>  =09=09=09msg(DBG_INF,"ioctl: cc_PlayAudio returns %d\n",i);
>  =09=09=09DriveReset();
>  =09=09=09current_drive->audio_state=3D0;
> -=09=09=09RETURN_UP(-EIO);
> +=09=09=09RETURN_UNLOCK(-EIO);
>  =09=09}
>  =09=09current_drive->audio_state=3Daudio_playing;
> -=09=09RETURN_UP(0);
> +=09=09RETURN_UNLOCK(0);
>  =09=09
>  =09case CDROMREADTOCHDR:        /* Read the table of contents header */
>  =09=09msg(DBG_IOC,"ioctl: CDROMREADTOCHDR entered.\n");
>  =09=09tochdr.cdth_trk0=3Dcurrent_drive->n_first_track;
>  =09=09tochdr.cdth_trk1=3Dcurrent_drive->n_last_track;
>  =09=09memcpy((void *) arg, &tochdr, sizeof(struct cdrom_tochdr));
> -=09=09RETURN_UP(0);
> +=09=09RETURN_UNLOCK(0);
>  =09=09
>  =09case CDROMREADTOCENTRY:      /* Read an entry in the table of content=
s */
>  =09=09msg(DBG_IOC,"ioctl: CDROMREADTOCENTRY entered.\n");
> @@ -4304,7 +4304,7 @@ static int sbpcd_audio_ioctl(struct cdrom_device_in=
fo *cdi, u_int cmd,
>  =09=09i=3Dtocentry.cdte_track;
>  =09=09if (i=3D=3DCDROM_LEADOUT) i=3Dcurrent_drive->n_last_track+1;
>  =09=09else if (i<current_drive->n_first_track||i>current_drive->n_last_t=
rack)
> -                  RETURN_UP(-EINVAL);
> +                  RETURN_UNLOCK(-EINVAL);
>  =09=09tocentry.cdte_adr=3Dcurrent_drive->TocBuffer[i].ctl_adr&0x0F;
>  =09=09tocentry.cdte_ctrl=3D(current_drive->TocBuffer[i].ctl_adr>>4)&0x0F=
;
>  =09=09tocentry.cdte_datamode=3Dcurrent_drive->TocBuffer[i].format;
> @@ -4316,27 +4316,27 @@ static int sbpcd_audio_ioctl(struct cdrom_device_=
info *cdi, u_int cmd,
>  =09=09}
>  =09=09else if (tocentry.cdte_format=3D=3DCDROM_LBA) /* blk required */
>  =09=09=09tocentry.cdte_addr.lba=3Dmsf2blk(current_drive->TocBuffer[i].ad=
dress);
> -=09=09else RETURN_UP(-EINVAL);
> +=09=09else RETURN_UNLOCK(-EINVAL);
>  =09=09memcpy((void *) arg, &tocentry, sizeof(struct cdrom_tocentry));
> -=09=09RETURN_UP(0);
> +=09=09RETURN_UNLOCK(0);
>  =09=09
>  =09case CDROMSTOP:      /* Spin down the drive */
>  =09=09msg(DBG_IOC,"ioctl: CDROMSTOP entered.\n");
>  #ifdef SAFE_MIXED
> -=09=09if (current_drive->has_data>1) RETURN_UP(-EBUSY);
> +=09=09if (current_drive->has_data>1) RETURN_UNLOCK(-EBUSY);
>  #endif /* SAFE_MIXED */=20
>  =09=09i=3Dcc_Pause_Resume(1);
>  =09=09current_drive->audio_state=3D0;
>  #if 0
>  =09=09cc_DriveReset();
>  #endif
> -=09=09RETURN_UP(i);
> +=09=09RETURN_UNLOCK(i);
> =20
>  =09case CDROMSTART:  /* Spin up the drive */
>  =09=09msg(DBG_IOC,"ioctl: CDROMSTART entered.\n");
>  =09=09cc_SpinUp();
>  =09=09current_drive->audio_state=3D0;
> -=09=09RETURN_UP(0);
> +=09=09RETURN_UNLOCK(0);
> =20
>  =09case CDROMVOLCTRL:   /* Volume control */
>  =09=09msg(DBG_IOC,"ioctl: CDROMVOLCTRL entered.\n");
> @@ -4346,25 +4346,25 @@ static int sbpcd_audio_ioctl(struct cdrom_device_=
info *cdi, u_int cmd,
>  =09=09current_drive->vol_chan1=3D1;
>  =09=09current_drive->vol_ctrl1=3Dvolctrl.channel1;
>  =09=09i=3Dcc_SetVolume();
> -=09=09RETURN_UP(0);
> +=09=09RETURN_UNLOCK(0);
> =20
>  =09case CDROMVOLREAD:   /* read Volume settings from drive */
>  =09=09msg(DBG_IOC,"ioctl: CDROMVOLREAD entered.\n");
>  =09=09st=3Dcc_GetVolume();
> -=09=09if (st<0) RETURN_UP(st);
> +=09=09if (st<0) RETURN_UNLOCK(st);
>  =09=09volctrl.channel0=3Dcurrent_drive->vol_ctrl0;
>  =09=09volctrl.channel1=3Dcurrent_drive->vol_ctrl1;
>  =09=09volctrl.channel2=3D0;
>  =09=09volctrl.channel2=3D0;
>  =09=09memcpy((void *)arg,&volctrl,sizeof(volctrl));
> -=09=09RETURN_UP(0);
> +=09=09RETURN_UNLOCK(0);
> =20
>  =09case CDROMSUBCHNL:   /* Get subchannel info */
>  =09=09msg(DBG_IOS,"ioctl: CDROMSUBCHNL entered.\n");
>  =09=09/* Bogus, I can do better than this! --AJK
>  =09=09if ((st_spinning)||(!subq_valid)) {
>  =09=09=09i=3Dcc_ReadSubQ();
> -=09=09=09if (i<0) RETURN_UP(-EIO);
> +=09=09=09if (i<0) RETURN_UNLOCK(-EIO);
>  =09=09}
>  =09=09*/
>  =09=09i=3Dcc_ReadSubQ();
> @@ -4378,7 +4378,7 @@ static int sbpcd_audio_ioctl(struct cdrom_device_in=
fo *cdi, u_int cmd,
>  =09=09=09=09msg(DBG_000,"Disk changed detect\n");
>  =09=09=09=09current_drive->diskstate_flags &=3D ~cd_size_bit;
>  =09=09=09}
> -=09=09=09RETURN_UP(-EIO);
> +=09=09=09RETURN_UNLOCK(-EIO);
>  =09=09}
>  =09=09if (current_drive->CD_changed=3D=3D0xFF) {
>  =09=09=09/* reread the TOC because the disk has changed! --AJK */
> @@ -4386,9 +4386,9 @@ static int sbpcd_audio_ioctl(struct cdrom_device_in=
fo *cdi, u_int cmd,
>  =09=09=09i=3DDiskInfo();
>  =09=09=09if(i=3D=3D0) {
>  =09=09=09=09current_drive->CD_changed=3D0x00; /* cd has changed, procede=
, */
> -=09=09=09=09RETURN_UP(-EIO); /* and get TOC, etc on next try! --AJK */
> +=09=09=09=09RETURN_UNLOCK(-EIO); /* and get TOC, etc on next try! --AJK =
*/
>  =09=09=09} else {
> -=09=09=09=09RETURN_UP(-EIO); /* we weren't ready yet! --AJK */
> +=09=09=09=09RETURN_UNLOCK(-EIO); /* we weren't ready yet! --AJK */
>  =09=09=09}
>  =09=09}
>  =09=09memcpy(&SC, (void *) arg, sizeof(struct cdrom_subchnl));
> @@ -4451,11 +4451,11 @@ static int sbpcd_audio_ioctl(struct cdrom_device_=
info *cdi, u_int cmd,
>  =09=09    SC.cdsc_adr,SC.cdsc_ctrl,
>  =09=09    SC.cdsc_trk,SC.cdsc_ind,
>  =09=09    SC.cdsc_absaddr,SC.cdsc_reladdr);
> -=09=09RETURN_UP(0);
> +=09=09RETURN_UNLOCK(0);
> =20
>  =09default:
>  =09=09msg(DBG_IOC,"ioctl: unknown function request %04X\n", cmd);
> -=09=09RETURN_UP(-EINVAL);
> +=09=09RETURN_UNLOCK(-EINVAL);
>  =09} /* end switch(cmd) */
>  }
>  /*=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D*/
> @@ -4549,7 +4549,7 @@ static void do_sbpcd_request(request_queue_t * q)
>  =09=09end_request(req, 0);
>  =09spin_unlock_irq(q->queue_lock);
> =20
> -=09down(&ioctl_read_sem);
> +=09mutex_lock(&ioctl_read_mtx);
>  =09if (rq_data_dir(elv_next_request(q)) !=3D READ)
>  =09{
>  =09=09msg(DBG_INF, "bad cmd %d\n", req->cmd[0]);
> @@ -4581,7 +4581,7 @@ static void do_sbpcd_request(request_queue_t * q)
>  =09=09printk(" do_sbpcd_request[%do](%p:%ld+%ld) end 2, Time:%li\n",
>  =09=09=09xnr, req, req->sector, req->nr_sectors, jiffies);
>  #endif
> -=09=09up(&ioctl_read_sem);
> +=09=09mutex_unlock(&ioctl_read_mtx);
>  =09=09spin_lock_irq(q->queue_lock);
>  =09=09end_request(req, 1);
>  =09=09goto request_loop;
> @@ -4622,7 +4622,7 @@ static void do_sbpcd_request(request_queue_t * q)
>  =09=09=09printk(" do_sbpcd_request[%do](%p:%ld+%ld) end 3, Time:%li\n",
>  =09=09=09=09xnr, req, req->sector, req->nr_sectors, jiffies);
>  #endif
> -=09=09=09up(&ioctl_read_sem);
> +=09=09=09mutex_unlock(&ioctl_read_mtx);
>  =09=09=09spin_lock_irq(q->queue_lock);
>  =09=09=09end_request(req, 1);
>  =09=09=09goto request_loop;
> @@ -4637,7 +4637,7 @@ static void do_sbpcd_request(request_queue_t * q)
>  =09printk(" do_sbpcd_request[%do](%p:%ld+%ld) end 4 (error), Time:%li\n"=
,
>  =09=09xnr, req, req->sector, req->nr_sectors, jiffies);
>  #endif
> -=09up(&ioctl_read_sem);
> +=09mutex_unlock(&ioctl_read_mtx);
>  =09sbp_sleep(0);    /* wait a bit, try again */
>  =09spin_lock_irq(q->queue_lock);
>  =09end_request(req, 0);
> @@ -5059,7 +5059,7 @@ static int sbpcd_block_ioctl(struct inode *inode, s=
truct file *file,
>  =09=09msg(DBG_INF, "ioctl: bad device: %s\n", cdi->name);
>  =09=09return (-ENXIO);             /* no such drive */
>  =09}
> -=09down(&ioctl_read_sem);
> +=09mutex_lock(&ioctl_read_mtx);
>  =09if (p !=3D current_drive)
>  =09=09switch_drive(p);
>  =09
> @@ -5067,34 +5067,34 @@ static int sbpcd_block_ioctl(struct inode *inode,=
 struct file *file,
>  =09switch (cmd) =09=09/* Sun-compatible */
>  =09{
>  =09case DDIOCSDBG:=09=09/* DDI Debug */
> -=09=09if (!capable(CAP_SYS_ADMIN)) RETURN_UP(-EPERM);
> +=09=09if (!capable(CAP_SYS_ADMIN)) RETURN_UNLOCK(-EPERM);
>  =09=09i=3Dsbpcd_dbg_ioctl(arg,1);
> -=09=09RETURN_UP(i);
> +=09=09RETURN_UNLOCK(i);
>  =09case CDROMRESET:      /* hard reset the drive */
>  =09=09msg(DBG_IOC,"ioctl: CDROMRESET entered.\n");
>  =09=09i=3DDriveReset();
>  =09=09current_drive->audio_state=3D0;
> -=09=09RETURN_UP(i);
> +=09=09RETURN_UNLOCK(i);
> =20
>  =09case CDROMREADMODE1:
>  =09=09msg(DBG_IOC,"ioctl: CDROMREADMODE1 requested.\n");
>  #ifdef SAFE_MIXED
> -=09=09if (current_drive->has_data>1) RETURN_UP(-EBUSY);
> +=09=09if (current_drive->has_data>1) RETURN_UNLOCK(-EBUSY);
>  #endif /* SAFE_MIXED */
>  =09=09cc_ModeSelect(CD_FRAMESIZE);
>  =09=09cc_ModeSense();
>  =09=09current_drive->mode=3DREAD_M1;
> -=09=09RETURN_UP(0);
> +=09=09RETURN_UNLOCK(0);
> =20
>  =09case CDROMREADMODE2: /* not usable at the moment */
>  =09=09msg(DBG_IOC,"ioctl: CDROMREADMODE2 requested.\n");
>  #ifdef SAFE_MIXED
> -=09=09if (current_drive->has_data>1) RETURN_UP(-EBUSY);
> +=09=09if (current_drive->has_data>1) RETURN_UNLOCK(-EBUSY);
>  #endif /* SAFE_MIXED */
>  =09=09cc_ModeSelect(CD_FRAMESIZE_RAW1);
>  =09=09cc_ModeSense();
>  =09=09current_drive->mode=3DREAD_M2;
> -=09=09RETURN_UP(0);
> +=09=09RETURN_UNLOCK(0);
> =20
>  =09case CDROMAUDIOBUFSIZ: /* configure the audio buffer size */
>  =09=09msg(DBG_IOC,"ioctl: CDROMAUDIOBUFSIZ entered.\n");
> @@ -5106,7 +5106,7 @@ static int sbpcd_block_ioctl(struct inode *inode, s=
truct file *file,
>  =09=09if (current_drive->sbp_audsiz>16)
>  =09=09{
>  =09=09=09current_drive->sbp_audsiz =3D 0;
> -=09=09=09RETURN_UP(current_drive->sbp_audsiz);
> +=09=09=09RETURN_UNLOCK(current_drive->sbp_audsiz);
>  =09=09}
>  =09
>  =09=09if (current_drive->sbp_audsiz>0)
> @@ -5119,7 +5119,7 @@ static int sbpcd_block_ioctl(struct inode *inode, s=
truct file *file,
>  =09=09=09}
>  =09=09=09else msg(DBG_INF,"audio buffer size: %d frames.\n",current_driv=
e->sbp_audsiz);
>  =09=09}
> -=09=09RETURN_UP(current_drive->sbp_audsiz);
> +=09=09RETURN_UNLOCK(current_drive->sbp_audsiz);
> =20
>  =09case CDROMREADAUDIO:
>  =09{ /* start of CDROMREADAUDIO */
> @@ -5134,27 +5134,27 @@ static int sbpcd_block_ioctl(struct inode *inode,=
 struct file *file,
>  =09=09int error_flag;
> =20
>  =09=09msg(DBG_IOC,"ioctl: CDROMREADAUDIO entered.\n");
> -=09=09if (fam0_drive) RETURN_UP(-EINVAL);
> -=09=09if (famL_drive) RETURN_UP(-EINVAL);
> -=09=09if (famV_drive) RETURN_UP(-EINVAL);
> -=09=09if (famT_drive) RETURN_UP(-EINVAL);
> +=09=09if (fam0_drive) RETURN_UNLOCK(-EINVAL);
> +=09=09if (famL_drive) RETURN_UNLOCK(-EINVAL);
> +=09=09if (famV_drive) RETURN_UNLOCK(-EINVAL);
> +=09=09if (famT_drive) RETURN_UNLOCK(-EINVAL);
>  #ifdef SAFE_MIXED
> -=09=09if (current_drive->has_data>1) RETURN_UP(-EBUSY);
> +=09=09if (current_drive->has_data>1) RETURN_UNLOCK(-EBUSY);
>  #endif /* SAFE_MIXED */
> -=09=09if (current_drive->aud_buf=3D=3DNULL) RETURN_UP(-EINVAL);
> +=09=09if (current_drive->aud_buf=3D=3DNULL) RETURN_UNLOCK(-EINVAL);
>  =09=09if (copy_from_user(&read_audio, (void __user *)arg,
>  =09=09=09=09   sizeof(struct cdrom_read_audio)))
> -=09=09=09RETURN_UP(-EFAULT);
> -=09=09if (read_audio.nframes < 0 || read_audio.nframes>current_drive->sb=
p_audsiz) RETURN_UP(-EINVAL);
> +=09=09=09RETURN_UNLOCK(-EFAULT);
> +=09=09if (read_audio.nframes < 0 || read_audio.nframes>current_drive->sb=
p_audsiz) RETURN_UNLOCK(-EINVAL);
>  =09=09if (!access_ok(VERIFY_WRITE, read_audio.buf,
>  =09=09=09      read_audio.nframes*CD_FRAMESIZE_RAW))
> -                =09RETURN_UP(-EFAULT);
> +                =09RETURN_UNLOCK(-EFAULT);
> =20
>  =09=09if (read_audio.addr_format=3D=3DCDROM_MSF) /* MSF-bin specificatio=
n of where to start */
>  =09=09=09block=3Dmsf2lba(&read_audio.addr.msf.minute);
>  =09=09else if (read_audio.addr_format=3D=3DCDROM_LBA) /* lba specificati=
on of where to start */
>  =09=09=09block=3Dread_audio.addr.lba;
> -=09=09else RETURN_UP(-EINVAL);
> +=09=09else RETURN_UNLOCK(-EINVAL);
>  #if 000
>  =09=09i=3Dcc_SetSpeed(speed_150,0,0);
>  =09=09if (i) msg(DBG_AUD,"read_audio: SetSpeed error %d\n", i);
> @@ -5344,7 +5344,7 @@ static int sbpcd_block_ioctl(struct inode *inode, s=
truct file *file,
>  =09=09=09if (copy_to_user(read_audio.buf,
>  =09=09=09=09=09 current_drive->aud_buf,
>  =09=09=09=09=09 read_audio.nframes * CD_FRAMESIZE_RAW))
> -=09=09=09=09RETURN_UP(-EFAULT);
> +=09=09=09=09RETURN_UNLOCK(-EFAULT);
>  =09=09=09msg(DBG_AUD,"read_audio: copy_to_user done.\n");
>  =09=09=09break;
>  =09=09}
> @@ -5357,15 +5357,15 @@ static int sbpcd_block_ioctl(struct inode *inode,=
 struct file *file,
>  =09=09if (data_tries =3D=3D 0)
>  =09=09{
>  =09=09=09msg(DBG_AUD,"read_audio: failed after 5 tries in line %d.\n", _=
_LINE__);
> -=09=09=09RETURN_UP(-EIO);
> +=09=09=09RETURN_UNLOCK(-EIO);
>  =09=09}
>  =09=09msg(DBG_AUD,"read_audio: successful return.\n");
> -=09=09RETURN_UP(0);
> +=09=09RETURN_UNLOCK(0);
>  =09} /* end of CDROMREADAUDIO */
> =20
>  =09default:
>  =09=09msg(DBG_IOC,"ioctl: unknown function request %04X\n", cmd);
> -=09=09RETURN_UP(-EINVAL);
> +=09=09RETURN_UNLOCK(-EINVAL);
>  =09} /* end switch(cmd) */
>  }
> =20
> @@ -5391,7 +5391,7 @@ static int sbpcd_open(struct cdrom_device_info *cdi=
, int purpose)
>  {
>  =09struct sbpcd_drive *p =3D cdi->handle;
> =20
> -=09down(&ioctl_read_sem);
> +=09mutex_lock(&ioctl_read_mtx);
>  =09switch_drive(p);
> =20
>  =09/*
> @@ -5419,7 +5419,7 @@ static int sbpcd_open(struct cdrom_device_info *cdi=
, int purpose)
>  #endif /* SAFE_MIXED */=20
>  =09}
>  =09if (!st_spinning) cc_SpinUp();
> -=09RETURN_UP(0);
> +=09RETURN_UNLOCK(0);
>  }
>  /*=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D*/
>  /*
> @@ -5433,7 +5433,7 @@ static void sbpcd_release(struct cdrom_device_info =
* cdi)
>  =09=09msg(DBG_INF, "release: bad device: %s\n", cdi->name);
>  =09=09return;
>  =09}
> -=09down(&ioctl_read_sem);
> +=09mutex_lock(&ioctl_read_mtx);
>  =09switch_drive(p);
>  =09/*
>  =09 * try to keep an "open" counter here and unlock the door if 1->0.
> @@ -5454,7 +5454,7 @@ static void sbpcd_release(struct cdrom_device_info =
* cdi)
>  #endif /* SAFE_MIXED */=20
>  =09=09}
>  =09}
> -=09up(&ioctl_read_sem);
> +=09mutex_unlock(&ioctl_read_mtx);
>  =09return ;
>  }
>  /*=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D*/
>=20
> --=20
> Matthias Kaehlcke
> Linux Application Developer
> Barcelona
>=20
>      The assumption that what currently exists must necessarily
>       exist is the acid that corrodes all visionary thinking
>                                                                  .''`.
>     using free software / Debian GNU/Linux | http://debian.org  : :'  :
>                                                                 `. `'`
> gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
>=20

--1283851528-2129825481-1177440617=:7943--
