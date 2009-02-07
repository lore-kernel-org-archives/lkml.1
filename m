Return-Path: <linux-kernel-owner+w=401wt.eu-S1753501AbZBGUHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501AbZBGUHy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 15:07:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753311AbZBGUHD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 15:07:03 -0500
Received: from vena.lwn.net ([206.168.112.25]:51322 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753203AbZBGUHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 15:07:00 -0500
From: Jonathan Corbet <corbet@lwn.net>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Davide Libenzi <davidel@xmailserver.org>,
       David Miller <davem@davemloft.net>, Christoph Hellwig <hch@lst.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Matt Mackall <mpm@selenic.com>,
       Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 2/4] Use f_lock to protect f_flags
Date: Sat,  7 Feb 2009 13:06:55 -0700
Message-Id: <1234037217-16124-3-git-send-email-corbet@lwn.net>
X-Mailer: git-send-email 1.6.1.2
In-Reply-To: <1234037217-16124-1-git-send-email-corbet@lwn.net>
References: <1234037217-16124-1-git-send-email-corbet@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Traditionally, changes to struct file->f_flags have been done under BKL
protection, or with no protection at all.  This patch causes all f_flags
changes after file open/creation time to be done under protection of
f_lock.  This allows the removal of some BKL usage and fixes a number of
longstanding (if microscopic) races.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 drivers/char/tty_io.c             |    5 ++---
 drivers/usb/gadget/file_storage.c |    7 ++++++-
 fs/fcntl.c                        |    2 ++
 fs/ioctl.c                        |    7 ++++---
 fs/nfsd/vfs.c                     |    5 ++++-
 include/linux/fs.h                |    2 +-
 ipc/mqueue.c                      |    2 ++
 sound/core/oss/pcm_oss.c          |    2 ++
 sound/oss/au1550_ac97.c           |    2 ++
 sound/oss/audio.c                 |    2 ++
 sound/oss/sh_dac_audio.c          |    2 ++
 sound/oss/swarm_cs4297a.c         |    2 ++
 sound/oss/vwsnd.c                 |    2 ++
 13 files changed, 33 insertions(+), 9 deletions(-)

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index bc84e12..224f271 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -2162,13 +2162,12 @@ static int fionbio(struct file *file, int __user *p)
 	if (get_user(nonblock, p))
 		return -EFAULT;
 
-	/* file->f_flags is still BKL protected in the fs layer - vomit */
-	lock_kernel();
+	spin_lock(&file->f_lock);
 	if (nonblock)
 		file->f_flags |= O_NONBLOCK;
 	else
 		file->f_flags &= ~O_NONBLOCK;
-	unlock_kernel();
+	spin_unlock(&file->f_lock);
 	return 0;
 }
 
diff --git a/drivers/usb/gadget/file_storage.c b/drivers/usb/gadget/file_storage.c
index b10fa31..26f5a08 100644
--- a/drivers/usb/gadget/file_storage.c
+++ b/drivers/usb/gadget/file_storage.c
@@ -1711,7 +1711,9 @@ static int do_write(struct fsg_dev *fsg)
 		curlun->sense_data = SS_WRITE_PROTECTED;
 		return -EINVAL;
 	}
+	spin_lock(&curlun->filp->f_lock);
 	curlun->filp->f_flags &= ~O_SYNC;	// Default is not to wait
+	spin_unlock(&curlun->filp->f_lock);
 
 	/* Get the starting Logical Block Address and check that it's
 	 * not too big */
@@ -1728,8 +1730,11 @@ static int do_write(struct fsg_dev *fsg)
 			curlun->sense_data = SS_INVALID_FIELD_IN_CDB;
 			return -EINVAL;
 		}
-		if (fsg->cmnd[1] & 0x08)	// FUA
+		if (fsg->cmnd[1] & 0x08) {	// FUA
+			spin_lock(&curlun->filp->f_lock);
 			curlun->filp->f_flags |= O_SYNC;
+			spin_unlock(&curlun->filp->f_lock);
+		}
 	}
 	if (lba >= curlun->num_sectors) {
 		curlun->sense_data = SS_LOGICAL_BLOCK_ADDRESS_OUT_OF_RANGE;
diff --git a/fs/fcntl.c b/fs/fcntl.c
index bd215cc..04df857 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -189,7 +189,9 @@ static int setfl(int fd, struct file * filp, unsigned long arg)
 		}
 	}
 
+	spin_lock(&filp->f_lock);
 	filp->f_flags = (arg & SETFL_MASK) | (filp->f_flags & ~SETFL_MASK);
+	spin_unlock(&filp->f_lock);
  out:
 	unlock_kernel();
 	return error;
diff --git a/fs/ioctl.c b/fs/ioctl.c
index 240ec63..421aab4 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -404,10 +404,12 @@ static int ioctl_fionbio(struct file *filp, int __user *argp)
 	if (O_NONBLOCK != O_NDELAY)
 		flag |= O_NDELAY;
 #endif
+	spin_lock(&filp->f_lock);
 	if (on)
 		filp->f_flags |= flag;
 	else
 		filp->f_flags &= ~flag;
+	spin_unlock(&filp->f_lock);
 	return error;
 }
 
@@ -432,10 +434,12 @@ static int ioctl_fioasync(unsigned int fd, struct file *filp,
 	if (error)
 		return error;
 
+	spin_lock(&filp->f_lock);
 	if (on)
 		filp->f_flags |= FASYNC;
 	else
 		filp->f_flags &= ~FASYNC;
+	spin_unlock(&filp->f_lock);
 	return error;
 }
 
@@ -499,10 +503,7 @@ int do_vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
 		break;
 
 	case FIONBIO:
-		/* BKL needed to avoid races tweaking f_flags */
-		lock_kernel();
 		error = ioctl_fionbio(filp, argp);
-		unlock_kernel();
 		break;
 
 	case FIOASYNC:
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 6e50aaa..c165a64 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -998,8 +998,11 @@ nfsd_vfs_write(struct svc_rqst *rqstp, struct svc_fh *fhp, struct file *file,
 
 	if (!EX_ISSYNC(exp))
 		stable = 0;
-	if (stable && !EX_WGATHER(exp))
+	if (stable && !EX_WGATHER(exp)) {
+		spin_lock(&file->f_lock);
 		file->f_flags |= O_SYNC;
+		spin_unlock(&file->f_lock);
+	}
 
 	/* Write the data. */
 	oldfs = get_fs(); set_fs(KERNEL_DS);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 0d71633..137a92a 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -842,7 +842,7 @@ struct file {
 #define f_dentry	f_path.dentry
 #define f_vfsmnt	f_path.mnt
 	const struct file_operations	*f_op;
-	spinlock_t		f_lock;  /* f_ep_links */
+	spinlock_t		f_lock;  /* f_ep_links, f_flags */
 	atomic_long_t		f_count;
 	unsigned int 		f_flags;
 	fmode_t			f_mode;
diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 54b4077..a8ddadb 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -1156,10 +1156,12 @@ SYSCALL_DEFINE3(mq_getsetattr, mqd_t, mqdes,
 	omqstat.mq_flags = filp->f_flags & O_NONBLOCK;
 	if (u_mqstat) {
 		audit_mq_getsetattr(mqdes, &mqstat);
+		spin_lock(&filp->f_lock);
 		if (mqstat.mq_flags & O_NONBLOCK)
 			filp->f_flags |= O_NONBLOCK;
 		else
 			filp->f_flags &= ~O_NONBLOCK;
+		spin_unlock(&filp->f_lock);
 
 		inode->i_atime = inode->i_ctime = CURRENT_TIME;
 	}
diff --git a/sound/core/oss/pcm_oss.c b/sound/core/oss/pcm_oss.c
index e178366..3a28acb 100644
--- a/sound/core/oss/pcm_oss.c
+++ b/sound/core/oss/pcm_oss.c
@@ -1895,7 +1895,9 @@ static int snd_pcm_oss_set_fragment(struct snd_pcm_oss_file *pcm_oss_file, unsig
 
 static int snd_pcm_oss_nonblock(struct file * file)
 {
+	spin_lock(&file->f_lock);
 	file->f_flags |= O_NONBLOCK;
+	spin_unlock(&file->f_lock);
 	return 0;
 }
 
diff --git a/sound/oss/au1550_ac97.c b/sound/oss/au1550_ac97.c
index 81e1f44..4191acc 100644
--- a/sound/oss/au1550_ac97.c
+++ b/sound/oss/au1550_ac97.c
@@ -1627,7 +1627,9 @@ au1550_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 				    sizeof(abinfo)) ? -EFAULT : 0;
 
 	case SNDCTL_DSP_NONBLOCK:
+		spin_lock(&file->f_lock);
 		file->f_flags |= O_NONBLOCK;
+		spin_unlock(&file->f_lock);
 		return 0;
 
 	case SNDCTL_DSP_GETODELAY:
diff --git a/sound/oss/audio.c b/sound/oss/audio.c
index 89bd27a..b69c05b 100644
--- a/sound/oss/audio.c
+++ b/sound/oss/audio.c
@@ -433,7 +433,9 @@ int audio_ioctl(int dev, struct file *file, unsigned int cmd, void __user *arg)
 			return dma_ioctl(dev, cmd, arg);
 		
 		case SNDCTL_DSP_NONBLOCK:
+			spin_lock(&file->f_lock);
 			file->f_flags |= O_NONBLOCK;
+			spin_unlock(&file->f_lock);
 			return 0;
 
 		case SNDCTL_DSP_GETCAPS:
diff --git a/sound/oss/sh_dac_audio.c b/sound/oss/sh_dac_audio.c
index e5d4239..78cfb66 100644
--- a/sound/oss/sh_dac_audio.c
+++ b/sound/oss/sh_dac_audio.c
@@ -135,7 +135,9 @@ static int dac_audio_ioctl(struct inode *inode, struct file *file,
 		return put_user(AFMT_U8, (int *)arg);
 
 	case SNDCTL_DSP_NONBLOCK:
+		spin_lock(&file->f_lock);
 		file->f_flags |= O_NONBLOCK;
+		spin_unlock(&file->f_lock);
 		return 0;
 
 	case SNDCTL_DSP_GETCAPS:
diff --git a/sound/oss/swarm_cs4297a.c b/sound/oss/swarm_cs4297a.c
index 41562ec..1edab7b 100644
--- a/sound/oss/swarm_cs4297a.c
+++ b/sound/oss/swarm_cs4297a.c
@@ -2200,7 +2200,9 @@ static int cs4297a_ioctl(struct inode *inode, struct file *file,
 				    sizeof(abinfo)) ? -EFAULT : 0;
 
 	case SNDCTL_DSP_NONBLOCK:
+		spin_lock(&file->f_lock);
 		file->f_flags |= O_NONBLOCK;
+		spin_unlock(&file->f_lock);
 		return 0;
 
 	case SNDCTL_DSP_GETODELAY:
diff --git a/sound/oss/vwsnd.c b/sound/oss/vwsnd.c
index 78b8acc..187f727 100644
--- a/sound/oss/vwsnd.c
+++ b/sound/oss/vwsnd.c
@@ -2673,7 +2673,9 @@ static int vwsnd_audio_do_ioctl(struct inode *inode,
 
 	case SNDCTL_DSP_NONBLOCK:	/* _SIO  ('P',14) */
 		DBGX("SNDCTL_DSP_NONBLOCK\n");
+		spin_lock(&file->f_lock);
 		file->f_flags |= O_NONBLOCK;
+		spin_unlock(&file->f_lock);
 		return 0;
 
 	case SNDCTL_DSP_RESET:		/* _SIO  ('P', 0) */
-- 
1.6.1.2

