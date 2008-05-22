Return-Path: <linux-kernel-owner+w=401wt.eu-S1762534AbYEVVFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762534AbYEVVFH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 17:05:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760305AbYEVVEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 17:04:50 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40484 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760795AbYEVVEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 17:04:47 -0400
Date: Thu, 22 May 2008 21:52:16 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org, kkeil@suse.de
Subject: [PATCH] isdn: Switch to unlocked_ioctl
Message-ID: <20080522215216.36dd95e7@core>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Push the BKL down into the ISDN drivers ready for eliminating the old
ioctl method calls. Would benefit from careful review as the needed changes
were quite hairy.

Signed-off-by: Alan Cox <alan@redhat.com>

diff --git a/drivers/isdn/capi/capi.c b/drivers/isdn/capi/capi.c
index 6ca0bb9..f2a2e8a 100644
--- a/drivers/isdn/capi/capi.c
+++ b/drivers/isdn/capi/capi.c
@@ -35,6 +35,7 @@
 #include <linux/poll.h>
 #include <linux/capi.h>
 #include <linux/kernelcapi.h>
+#include <linux/smp_lock.h>
 #include <linux/init.h>
 #include <linux/device.h>
 #include <linux/moduleparam.h>
@@ -782,73 +783,86 @@ capi_poll(struct file *file, poll_table * wait)
 	return mask;
 }
 
-static int
-capi_ioctl(struct inode *inode, struct file *file,
-	   unsigned int cmd, unsigned long arg)
+static long capi_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct capidev *cdev = file->private_data;
 	struct capi20_appl *ap = &cdev->ap;
 	capi_ioctl_struct data;
-	int retval = -EINVAL;
+	int retval = 0;
 	void __user *argp = (void __user *)arg;
 
+	lock_kernel();
 	switch (cmd) {
 	case CAPI_REGISTER:
 		{
-			if (ap->applid)
-				return -EEXIST;
+			if (ap->applid) {
+				retval = -EEXIST;
+				break;
+			}
 
 			if (copy_from_user(&cdev->ap.rparam, argp,
-					   sizeof(struct capi_register_params)))
-				return -EFAULT;
+					   sizeof(struct capi_register_params))) {
+				retval = -EFAULT;
+				break;
+			}
 			
 			cdev->ap.private = cdev;
 			cdev->ap.recv_message = capi_recv_message;
 			cdev->errcode = capi20_register(ap);
 			if (cdev->errcode) {
 				ap->applid = 0;
-				return -EIO;
+				retval = -EIO;
+				break;
 			}
 		}
-		return (int)ap->applid;
+		retval = (int)ap->applid;
+		break;
 
 	case CAPI_GET_VERSION:
 		{
 			if (copy_from_user(&data.contr, argp,
-						sizeof(data.contr)))
-				return -EFAULT;
+						sizeof(data.contr))) {
+				retval = -EFAULT;
+				break;
+			}
 		        cdev->errcode = capi20_get_version(data.contr, &data.version);
 			if (cdev->errcode)
-				return -EIO;
-			if (copy_to_user(argp, &data.version,
+				retval = -EIO;
+			else if (copy_to_user(argp, &data.version,
 					 sizeof(data.version)))
-				return -EFAULT;
+				retval = -EFAULT;
 		}
-		return 0;
+		break;
 
 	case CAPI_GET_SERIAL:
 		{
 			if (copy_from_user(&data.contr, argp,
-					   sizeof(data.contr)))
-				return -EFAULT;
+					   sizeof(data.contr))) {
+				retval = -EFAULT;
+				break;
+			}
 			cdev->errcode = capi20_get_serial (data.contr, data.serial);
 			if (cdev->errcode)
-				return -EIO;
-			if (copy_to_user(argp, data.serial,
+				retval = -EIO;
+			else if (copy_to_user(argp, data.serial,
 					 sizeof(data.serial)))
-				return -EFAULT;
+				retval = -EFAULT;
 		}
-		return 0;
+		break;
 	case CAPI_GET_PROFILE:
 		{
 			if (copy_from_user(&data.contr, argp,
-					   sizeof(data.contr)))
-				return -EFAULT;
+					   sizeof(data.contr))) {
+				retval = -EFAULT;
+				break;
+			}
 
 			if (data.contr == 0) {
 				cdev->errcode = capi20_get_profile(data.contr, &data.profile);
-				if (cdev->errcode)
-					return -EIO;
+				if (cdev->errcode) {
+					retval = -EIO;
+					break;
+				}
 
 				retval = copy_to_user(argp,
 				      &data.profile.ncontroller,
@@ -863,70 +877,77 @@ capi_ioctl(struct inode *inode, struct file *file,
 						   sizeof(data.profile));
 			}
 			if (retval)
-				return -EFAULT;
+				retval = -EFAULT;
 		}
-		return 0;
+		break;
 
 	case CAPI_GET_MANUFACTURER:
 		{
 			if (copy_from_user(&data.contr, argp,
-					   sizeof(data.contr)))
-				return -EFAULT;
+					   sizeof(data.contr))) {
+				retval = -EFAULT;
+				break;
+			}
 			cdev->errcode = capi20_get_manufacturer(data.contr, data.manufacturer);
 			if (cdev->errcode)
-				return -EIO;
-
-			if (copy_to_user(argp, data.manufacturer,
+				retval = -EIO;
+			else if (copy_to_user(argp, data.manufacturer,
 					 sizeof(data.manufacturer)))
-				return -EFAULT;
+				retval = -EFAULT;
 
 		}
-		return 0;
+		break;
 	case CAPI_GET_ERRCODE:
 		data.errcode = cdev->errcode;
 		cdev->errcode = CAPI_NOERROR;
 		if (arg) {
 			if (copy_to_user(argp, &data.errcode,
-					 sizeof(data.errcode)))
-				return -EFAULT;
+					 sizeof(data.errcode))) {
+				retval = -EFAULT;
+				break;
+			}
 		}
-		return data.errcode;
+		retval = data.errcode;
+		break;
 
 	case CAPI_INSTALLED:
-		if (capi20_isinstalled() == CAPI_NOERROR)
-			return 0;
-		return -ENXIO;
+		if (capi20_isinstalled() != CAPI_NOERROR)
+			retval = -ENXIO;
+		break;
 
 	case CAPI_MANUFACTURER_CMD:
 		{
 			struct capi_manufacturer_cmd mcmd;
 			if (!capable(CAP_SYS_ADMIN))
-				return -EPERM;
-			if (copy_from_user(&mcmd, argp, sizeof(mcmd)))
-				return -EFAULT;
-			return capi20_manufacturer(mcmd.cmd, mcmd.data);
+				retval = -EPERM;
+			else if (copy_from_user(&mcmd, argp, sizeof(mcmd)))
+				retval = -EFAULT;
+			else
+				retval = capi20_manufacturer(mcmd.cmd, mcmd.data);
 		}
-		return 0;
+		break;
 
 	case CAPI_SET_FLAGS:
 	case CAPI_CLR_FLAGS:
 		{
 			unsigned userflags;
 			if (copy_from_user(&userflags, argp,
-					   sizeof(userflags)))
-				return -EFAULT;
+					   sizeof(userflags))) {
+				retval = -EFAULT;
+				break;
+			}
 			if (cmd == CAPI_SET_FLAGS)
 				cdev->userflags |= userflags;
 			else
 				cdev->userflags &= ~userflags;
 		}
-		return 0;
+		break;
 
 	case CAPI_GET_FLAGS:
 		if (copy_to_user(argp, &cdev->userflags,
 				 sizeof(cdev->userflags)))
-			return -EFAULT;
-		return 0;
+			retval = -EFAULT;
+		break;
 
 	case CAPI_NCCI_OPENCOUNT:
 		{
@@ -936,13 +957,16 @@ capi_ioctl(struct inode *inode, struct file *file,
 #endif /* CONFIG_ISDN_CAPI_MIDDLEWARE */
 			unsigned ncci;
 			int count = 0;
-			if (copy_from_user(&ncci, argp, sizeof(ncci)))
-				return -EFAULT;
+			if (copy_from_user(&ncci, argp, sizeof(ncci))) {
+				retval = -EFAULT;
+				break;
+			}
 
 			mutex_lock(&cdev->ncci_list_mtx);
 			if ((nccip = capincci_find(cdev, (u32) ncci)) == NULL) {
 				mutex_unlock(&cdev->ncci_list_mtx);
-				return 0;
+				retval = 0;
+				break;
 			}
 #ifdef CONFIG_ISDN_CAPI_MIDDLEWARE
 			if ((mp = nccip->minorp) != NULL) {
@@ -950,9 +974,9 @@ capi_ioctl(struct inode *inode, struct file *file,
 			}
 #endif /* CONFIG_ISDN_CAPI_MIDDLEWARE */
 			mutex_unlock(&cdev->ncci_list_mtx);
-			return count;
+			retval = count;
 		}
-		return 0;
+		break;
 
 #ifdef CONFIG_ISDN_CAPI_MIDDLEWARE
 	case CAPI_NCCI_GETUNIT:
@@ -960,24 +984,28 @@ capi_ioctl(struct inode *inode, struct file *file,
 			struct capincci *nccip;
 			struct capiminor *mp;
 			unsigned ncci;
-			int unit = 0;
 			if (copy_from_user(&ncci, argp,
-					   sizeof(ncci)))
-				return -EFAULT;
+					   sizeof(ncci))) {
+				retval = -EFAULT;
+				break;
+			}
 			mutex_lock(&cdev->ncci_list_mtx);
 			nccip = capincci_find(cdev, (u32) ncci);
 			if (!nccip || (mp = nccip->minorp) == NULL) {
 				mutex_unlock(&cdev->ncci_list_mtx);
-				return -ESRCH;
+				retval = -ESRCH;
+				break;
 			}
-			unit = mp->minor;
+			retval = mp->minor;
 			mutex_unlock(&cdev->ncci_list_mtx);
-			return unit;
 		}
-		return 0;
+		break;
 #endif /* CONFIG_ISDN_CAPI_MIDDLEWARE */
+	default:
+		retval = -ENOTTY;
 	}
-	return -EINVAL;
+	unlock_kernel();
+	return retval;
 }
 
 static int
@@ -1010,7 +1038,7 @@ static const struct file_operations capi_fops =
 	.read		= capi_read,
 	.write		= capi_write,
 	.poll		= capi_poll,
-	.ioctl		= capi_ioctl,
+	.unlocked_ioctl	= capi_ioctl,
 	.open		= capi_open,
 	.release	= capi_release,
 };
diff --git a/drivers/isdn/divert/divert_procfs.c b/drivers/isdn/divert/divert_procfs.c
index 8b256a6..5537fec 100644
--- a/drivers/isdn/divert/divert_procfs.c
+++ b/drivers/isdn/divert/divert_procfs.c
@@ -17,6 +17,7 @@
 #include <linux/fs.h>
 #endif
 #include <linux/isdnif.h>
+#include <linux/smp_lock.h>
 #include <net/net_namespace.h>
 #include "isdn_divert.h"
 
@@ -175,15 +176,15 @@ isdn_divert_close(struct inode *ino, struct file *filep)
 /*********/
 /* IOCTL */
 /*********/
-static int
-isdn_divert_ioctl(struct inode *inode, struct file *file,
-		  uint cmd, ulong arg)
+static long
+isdn_divert_ioctl(struct file *file, uint cmd, ulong arg)
 {
 	divert_ioctl dioctl;
 	int i;
 	unsigned long flags;
 	divert_rule *rulep;
 	char *cp;
+	long ret = 0;
 
 	if (copy_from_user(&dioctl, (void __user *) arg, sizeof(dioctl)))
 		return -EFAULT;
@@ -194,59 +195,85 @@ isdn_divert_ioctl(struct inode *inode, struct file *file,
 			break;
 
 		case IIOCGETDRV:
-			if ((dioctl.getid.drvid = divert_if.name_to_drv(dioctl.getid.drvnam)) < 0)
-				return (-EINVAL);
+			lock_kernel();
+			dioctl.getid.drvid = divert_if.name_to_drv(dioctl.getid.drvnam);
+			unlock_kernel();
+			if (dioctl.getid.drvid < 0)
+				return -EINVAL;
 			break;
 
 		case IIOCGETNAM:
+			lock_kernel();
 			cp = divert_if.drv_to_name(dioctl.getid.drvid);
 			if (!cp)
-				return (-EINVAL);
-			if (!*cp)
-				return (-EINVAL);
-			strcpy(dioctl.getid.drvnam, cp);
-			break;
+				ret = -EINVAL;
+			else if (!*cp)
+				ret = -EINVAL;
+			else
+				strcpy(dioctl.getid.drvnam, cp);
+			unlock_kernel();
+			return ret;
 
 		case IIOCGETRULE:
-			if (!(rulep = getruleptr(dioctl.getsetrule.ruleidx)))
-				return (-EINVAL);
-			dioctl.getsetrule.rule = *rulep;	/* copy data */
-			break;
+			lock_kernel();
+			rulep = getruleptr(dioctl.getsetrule.ruleidx);
+			if (rulep == NULL)
+				ret = -EINVAL;
+			else
+				dioctl.getsetrule.rule = *rulep;	/* copy data */
+			unlock_kernel();
+			return ret;
 
 		case IIOCMODRULE:
-			if (!(rulep = getruleptr(dioctl.getsetrule.ruleidx)))
-				return (-EINVAL);
-            spin_lock_irqsave(&divert_lock, flags);
+			lock_kernel();
+			rulep = getruleptr(dioctl.getsetrule.ruleidx);
+			if (rulep == NULL) {
+				unlock_kernel();
+				return -EINVAL;
+			}
+			spin_lock_irqsave(&divert_lock, flags);
 			*rulep = dioctl.getsetrule.rule;	/* copy data */
 			spin_unlock_irqrestore(&divert_lock, flags);
-			return (0);	/* no copy required */
-			break;
+			unlock_kernel();
+			return 0;
 
 		case IIOCINSRULE:
-			return (insertrule(dioctl.getsetrule.ruleidx, &dioctl.getsetrule.rule));
-			break;
+			lock_kernel();
+			ret = insertrule(dioctl.getsetrule.ruleidx, &dioctl.getsetrule.rule);
+			unlock_kernel();
+			return ret;
 
 		case IIOCDELRULE:
-			return (deleterule(dioctl.getsetrule.ruleidx));
-			break;
+			lock_kernel();
+			ret = deleterule(dioctl.getsetrule.ruleidx);
+			unlock_kernel();
+			return ret;
 
 		case IIOCDODFACT:
-			return (deflect_extern_action(dioctl.fwd_ctrl.subcmd,
+			lock_kernel();
+			ret = deflect_extern_action(dioctl.fwd_ctrl.subcmd,
 						  dioctl.fwd_ctrl.callid,
-						 dioctl.fwd_ctrl.to_nr));
+						 dioctl.fwd_ctrl.to_nr);
+			unlock_kernel();
+			return ret;
 
 		case IIOCDOCFACT:
 		case IIOCDOCFDIS:
 		case IIOCDOCFINT:
-			if (!divert_if.drv_to_name(dioctl.cf_ctrl.drvid))
-				return (-EINVAL);	/* invalid driver */
-			if ((i = cf_command(dioctl.cf_ctrl.drvid,
+			lock_kernel();
+			if (!divert_if.drv_to_name(dioctl.cf_ctrl.drvid)) {
+				unlock_kernel();
+				return -EINVAL;	/* invalid driver */
+			}
+			i = cf_command(dioctl.cf_ctrl.drvid,
 					    (cmd == IIOCDOCFACT) ? 1 : (cmd == IIOCDOCFDIS) ? 0 : 2,
 					    dioctl.cf_ctrl.cfproc,
 					    dioctl.cf_ctrl.msn,
 					    dioctl.cf_ctrl.service,
 					    dioctl.cf_ctrl.fwd_nr,
-					    &dioctl.cf_ctrl.procid)))
+					    &dioctl.cf_ctrl.procid);
+			unlock_kernel();
+			if (i)
 				return (i);
 			break;
 
@@ -263,7 +290,7 @@ static const struct file_operations isdn_fops =
 	.read           = isdn_divert_read,
 	.write          = isdn_divert_write,
 	.poll           = isdn_divert_poll,
-	.ioctl          = isdn_divert_ioctl,
+	.unlocked_ioctl = isdn_divert_ioctl,
 	.open           = isdn_divert_open,
 	.release        = isdn_divert_close,                                      
 };
diff --git a/drivers/isdn/i4l/isdn_common.c b/drivers/isdn/i4l/isdn_common.c
index 0f3c66d..264581e 100644
--- a/drivers/isdn/i4l/isdn_common.c
+++ b/drivers/isdn/i4l/isdn_common.c
@@ -1270,14 +1270,14 @@ isdn_poll(struct file *file, poll_table * wait)
 }
 
 
-static int
-isdn_ioctl(struct inode *inode, struct file *file, uint cmd, ulong arg)
+static long isdn_ioctl(struct file *file, uint cmd, ulong arg)
 {
+	struct inode *inode = file->f_path.dentry->d_inode;
 	uint minor = iminor(inode);
 	isdn_ctrl c;
 	int drvidx;
 	int chidx;
-	int ret;
+	long ret = 0;
 	int i;
 	char __user *p;
 	char *s;
@@ -1309,10 +1309,12 @@ isdn_ioctl(struct inode *inode, struct file *file, uint cmd, ulong arg)
 					if (!access_ok(VERIFY_WRITE, p,
 							sizeof(ulong) * ISDN_MAX_CHANNELS * 2))
 						return -EFAULT;
+					lock_kernel();
 					for (i = 0; i < ISDN_MAX_CHANNELS; i++) {
 						put_user(dev->ibytes[i], p++);
 						put_user(dev->obytes[i], p++);
 					}
+					unlock_kernel();
 					return 0;
 				} else
 					return -EINVAL;
@@ -1324,7 +1326,10 @@ isdn_ioctl(struct inode *inode, struct file *file, uint cmd, ulong arg)
 				if (arg) {
 					if (copy_from_user(&phone, argp, sizeof(phone)))
 						return -EFAULT;
-					return isdn_net_getpeer(&phone, argp);
+					lock_kernel();
+					ret = isdn_net_getpeer(&phone, argp);
+					unlock_kernel();
+					return ret;
 				} else
 					return -EINVAL;
 #endif
@@ -1335,13 +1340,17 @@ isdn_ioctl(struct inode *inode, struct file *file, uint cmd, ulong arg)
 	if (!dev->drivers)
 		return -ENODEV;
 	if (minor <= ISDN_MINOR_BMAX) {
+		lock_kernel();
 		drvidx = isdn_minor2drv(minor);
 		if (drvidx < 0)
-			return -ENODEV;
-		chidx = isdn_minor2chan(minor);
-		if (!(dev->drv[drvidx]->flags & DRV_FLAG_RUNNING))
-			return -ENODEV;
-		return 0;
+			ret = -ENODEV;
+		else {
+			chidx = isdn_minor2chan(minor);
+			if (!(dev->drv[drvidx]->flags & DRV_FLAG_RUNNING))
+				ret = -ENODEV;
+		}
+		unlock_kernel();
+		return ret;
 	}
 	if (minor <= ISDN_MINOR_CTRLMAX) {
 /*
@@ -1368,8 +1377,13 @@ isdn_ioctl(struct inode *inode, struct file *file, uint cmd, ulong arg)
 				} else {
 					s = NULL;
 				}
+
+				lock_kernel();
 				ret = mutex_lock_interruptible(&dev->mtx);
-				if( ret ) return ret;
+				if( ret ) {
+					unlock_kernel();
+					return ret;
+				}
 				if ((s = isdn_net_new(s, NULL))) {
 					if (copy_to_user(argp, s, strlen(s) + 1)){
 						ret = -EFAULT;
@@ -1379,6 +1393,7 @@ isdn_ioctl(struct inode *inode, struct file *file, uint cmd, ulong arg)
 				} else
 					ret = -ENODEV;
 				mutex_unlock(&dev->mtx);
+				unlock_kernel();
 				return ret;
 			case IIOCNETASL:
 				/* Add a slave to a network-interface */
@@ -1387,8 +1402,12 @@ isdn_ioctl(struct inode *inode, struct file *file, uint cmd, ulong arg)
 						return -EFAULT;
 				} else
 					return -EINVAL;
+				lock_kernel();
 				ret = mutex_lock_interruptible(&dev->mtx);
-				if( ret ) return ret;
+				if( ret ) {
+					unlock_kernel();
+					return ret;
+				}
 				if ((s = isdn_net_newslave(bname))) {
 					if (copy_to_user(argp, s, strlen(s) + 1)){
 						ret = -EFAULT;
@@ -1398,16 +1417,22 @@ isdn_ioctl(struct inode *inode, struct file *file, uint cmd, ulong arg)
 				} else
 					ret = -ENODEV;
 				mutex_unlock(&dev->mtx);
+				unlock_kernel();
 				return ret;
 			case IIOCNETDIF:
 				/* Delete a network-interface */
 				if (arg) {
 					if (copy_from_user(name, argp, sizeof(name)))
 						return -EFAULT;
+					lock_kernel();
 					ret = mutex_lock_interruptible(&dev->mtx);
-					if( ret ) return ret;
+					if( ret ) {
+						unlock_kernel();
+						return ret;
+					}
 					ret = isdn_net_rm(name);
 					mutex_unlock(&dev->mtx);
+					unlock_kernel();
 					return ret;
 				} else
 					return -EINVAL;
@@ -1416,7 +1441,9 @@ isdn_ioctl(struct inode *inode, struct file *file, uint cmd, ulong arg)
 				if (arg) {
 					if (copy_from_user(&cfg, argp, sizeof(cfg)))
 						return -EFAULT;
-					return isdn_net_setcfg(&cfg);
+					lock_kernel();
+					ret = isdn_net_setcfg(&cfg);
+					unlock_kernel();
 				} else
 					return -EINVAL;
 			case IIOCNETGCF:
@@ -1424,10 +1451,12 @@ isdn_ioctl(struct inode *inode, struct file *file, uint cmd, ulong arg)
 				if (arg) {
 					if (copy_from_user(&cfg, argp, sizeof(cfg)))
 						return -EFAULT;
+					lock_kernel();
 					if (!(ret = isdn_net_getcfg(&cfg))) {
 						if (copy_to_user(argp, &cfg, sizeof(cfg)))
-							return -EFAULT;
+							ret = -EFAULT;
 					}
+					unlock_kernel();
 					return ret;
 				} else
 					return -EINVAL;
@@ -1436,10 +1465,15 @@ isdn_ioctl(struct inode *inode, struct file *file, uint cmd, ulong arg)
 				if (arg) {
 					if (copy_from_user(&phone, argp, sizeof(phone)))
 						return -EFAULT;
+					lock_kernel();
 					ret = mutex_lock_interruptible(&dev->mtx);
-					if( ret ) return ret;
+					if( ret ) {
+						unlock_kernel();
+						return ret;
+					}
 					ret = isdn_net_addphone(&phone);
 					mutex_unlock(&dev->mtx);
+					unlock_kernel();
 					return ret;
 				} else
 					return -EINVAL;
@@ -1448,10 +1482,15 @@ isdn_ioctl(struct inode *inode, struct file *file, uint cmd, ulong arg)
 				if (arg) {
 					if (copy_from_user(&phone, argp, sizeof(phone)))
 						return -EFAULT;
+					lock_kernel();
 					ret = mutex_lock_interruptible(&dev->mtx);
-					if( ret ) return ret;
+					if( ret ) {
+						unlock_kernel();
+						return ret;
+					}
 					ret = isdn_net_getphones(&phone, argp);
 					mutex_unlock(&dev->mtx);
+					unlock_kernel();
 					return ret;
 				} else
 					return -EINVAL;
@@ -1460,10 +1499,15 @@ isdn_ioctl(struct inode *inode, struct file *file, uint cmd, ulong arg)
 				if (arg) {
 					if (copy_from_user(&phone, argp, sizeof(phone)))
 						return -EFAULT;
+					lock_kernel();
 					ret = mutex_lock_interruptible(&dev->mtx);
-					if( ret ) return ret;
+					if( ret ) {
+						unlock_kernel();
+						return ret;
+					}
 					ret = isdn_net_delphone(&phone);
 					mutex_unlock(&dev->mtx);
+					unlock_kernel();
 					return ret;
 				} else
 					return -EINVAL;
@@ -1472,7 +1516,10 @@ isdn_ioctl(struct inode *inode, struct file *file, uint cmd, ulong arg)
 				if (arg) {
 					if (copy_from_user(name, argp, sizeof(name)))
 						return -EFAULT;
-					return isdn_net_force_dial(name);
+					lock_kernel();
+					ret = isdn_net_force_dial(name);
+					unlock_kernel();
+					return ret;
 				} else
 					return -EINVAL;
 #ifdef CONFIG_ISDN_PPP
@@ -1481,13 +1528,19 @@ isdn_ioctl(struct inode *inode, struct file *file, uint cmd, ulong arg)
 					return -EINVAL;
 				if (copy_from_user(name, argp, sizeof(name)))
 					return -EFAULT;
-				return isdn_ppp_dial_slave(name);
+				lock_kernel();
+				ret = isdn_ppp_dial_slave(name);
+				unlock_kernel();
+				return ret;
 			case IIOCNETDLN:
 				if (!arg)
 					return -EINVAL;
 				if (copy_from_user(name, argp, sizeof(name)))
 					return -EFAULT;
-				return isdn_ppp_hangup_slave(name);
+				lock_kernel();
+				ret = isdn_ppp_hangup_slave(name);
+				unlock_kernel();
+				return ret;
 #endif
 			case IIOCNETHUP:
 				/* Force hangup of a network-interface */
@@ -1495,20 +1548,26 @@ isdn_ioctl(struct inode *inode, struct file *file, uint cmd, ulong arg)
 					return -EINVAL;
 				if (copy_from_user(name, argp, sizeof(name)))
 					return -EFAULT;
-				return isdn_net_force_hangup(name);
-				break;
+				lock_kernel();
+				ret = isdn_net_force_hangup(name);
+				unlock_kernel();
+				return ret;
 #endif                          /* CONFIG_NETDEVICES */
 			case IIOCSETVER:
+				lock_kernel();
 				dev->net_verbose = arg;
+				unlock_kernel();
 				printk(KERN_INFO "isdn: Verbose-Level is %d\n", dev->net_verbose);
 				return 0;
 			case IIOCSETGST:
+				lock_kernel();
 				if (arg)
 					dev->global_flags |= ISDN_GLOBAL_STOPPED;
 				else
 					dev->global_flags &= ~ISDN_GLOBAL_STOPPED;
 				printk(KERN_INFO "isdn: Global Mode %s\n",
 				       (dev->global_flags & ISDN_GLOBAL_STOPPED) ? "stopped" : "running");
+				unlock_kernel();
 				return 0;
 			case IIOCSETBRJ:
 				drvidx = -1;
@@ -1520,6 +1579,7 @@ isdn_ioctl(struct inode *inode, struct file *file, uint cmd, ulong arg)
 						return -EFAULT;
 					iocts.drvid[sizeof(iocts.drvid)-1] = 0;
 					if (strlen(iocts.drvid)) {
+						lock_kernel();
 						if ((p = strchr(iocts.drvid, ',')))
 							*p = 0;
 						drvidx = -1;
@@ -1528,19 +1588,23 @@ isdn_ioctl(struct inode *inode, struct file *file, uint cmd, ulong arg)
 								drvidx = i;
 								break;
 							}
+						unlock_kernel();
 					}
 				}
 				if (drvidx == -1)
 					return -ENODEV;
+				lock_kernel();
 				if (iocts.arg)
 					dev->drv[drvidx]->flags |= DRV_FLAG_REJBUS;
 				else
 					dev->drv[drvidx]->flags &= ~DRV_FLAG_REJBUS;
+				unlock_kernel();
 				return 0;
 			case IIOCSIGPRF:
+				lock_kernel();
 				dev->profd = current;
+				unlock_kernel();
 				return 0;
-				break;
 			case IIOCGETPRF:
 				/* Get all Modem-Profiles */
 				if (arg) {
@@ -1552,19 +1616,23 @@ isdn_ioctl(struct inode *inode, struct file *file, uint cmd, ulong arg)
 						   * ISDN_MAX_CHANNELS))
 						return -EFAULT;
 
+					lock_kernel();
 					for (i = 0; i < ISDN_MAX_CHANNELS; i++) {
+						ret = -EFAULT;
 						if (copy_to_user(p, dev->mdm.info[i].emu.profile,
 						      ISDN_MODEM_NUMREG))
-							return -EFAULT;
+						      	break;
 						p += ISDN_MODEM_NUMREG;
 						if (copy_to_user(p, dev->mdm.info[i].emu.pmsn, ISDN_MSNLEN))
-							return -EFAULT;
+							break;
 						p += ISDN_MSNLEN;
 						if (copy_to_user(p, dev->mdm.info[i].emu.plmsn, ISDN_LMSNLEN))
-							return -EFAULT;
+							break;
 						p += ISDN_LMSNLEN;
+						ret = ISDN_MODEM_NUMREG + ISDN_MSNLEN + ISDN_LMSNLEN * ISDN_MAX_CHANNELS;
 					}
-					return (ISDN_MODEM_NUMREG + ISDN_MSNLEN + ISDN_LMSNLEN) * ISDN_MAX_CHANNELS;
+					unlock_kernel();
+					return ret;
 				} else
 					return -EINVAL;
 				break;
@@ -1578,20 +1646,23 @@ isdn_ioctl(struct inode *inode, struct file *file, uint cmd, ulong arg)
 					(ISDN_MODEM_NUMREG + ISDN_MSNLEN + ISDN_LMSNLEN)
 						   * ISDN_MAX_CHANNELS))
 						return -EFAULT;
-
+					lock_kernel();
 					for (i = 0; i < ISDN_MAX_CHANNELS; i++) {
+						ret = -EFAULT;
 						if (copy_from_user(dev->mdm.info[i].emu.profile, p,
 						     ISDN_MODEM_NUMREG))
-							return -EFAULT;
+							break;
 						p += ISDN_MODEM_NUMREG;
 						if (copy_from_user(dev->mdm.info[i].emu.plmsn, p, ISDN_LMSNLEN))
-							return -EFAULT;
+							break;
 						p += ISDN_LMSNLEN;
 						if (copy_from_user(dev->mdm.info[i].emu.pmsn, p, ISDN_MSNLEN))
-							return -EFAULT;
+							break;
 						p += ISDN_MSNLEN;
+						ret = 0;
 					}
-					return 0;
+					unlock_kernel();
+					return ret;
 				} else
 					return -EINVAL;
 				break;
@@ -1603,6 +1674,7 @@ isdn_ioctl(struct inode *inode, struct file *file, uint cmd, ulong arg)
 					if (copy_from_user(&iocts, argp,
 					     sizeof(isdn_ioctl_struct)))
 						return -EFAULT;
+					lock_kernel();
 					iocts.drvid[sizeof(iocts.drvid)-1] = 0;
 					if (strlen(iocts.drvid)) {
 						drvidx = -1;
@@ -1613,8 +1685,10 @@ isdn_ioctl(struct inode *inode, struct file *file, uint cmd, ulong arg)
 							}
 					} else
 						drvidx = 0;
-					if (drvidx == -1)
+					if (drvidx == -1) {
+						unlock_kernel();
 						return -ENODEV;
+					}
 					if (cmd == IIOCSETMAP) {
 						int loop = 1;
 
@@ -1624,9 +1698,10 @@ isdn_ioctl(struct inode *inode, struct file *file, uint cmd, ulong arg)
 							int j = 0;
 
 							while (1) {
-								if (!access_ok(VERIFY_READ, p, 1))
+								if (get_user(bname[j], p++)) {
+									unlock_kernel();
 									return -EFAULT;
-								get_user(bname[j], p++);
+								}
 								switch (bname[j]) {
 									case '\0':
 										loop = 0;
@@ -1652,11 +1727,14 @@ isdn_ioctl(struct inode *inode, struct file *file, uint cmd, ulong arg)
 								strlen(dev->drv[drvidx]->msn2eaz[i]) ?
 								dev->drv[drvidx]->msn2eaz[i] : "_",
 								(i < 9) ? "," : "\0");
-							if (copy_to_user(p, bname, strlen(bname) + 1))
+							if (copy_to_user(p, bname, strlen(bname) + 1)) {
+								unlock_kernel();
 								return -EFAULT;
+							}
 							p += strlen(bname);
 						}
 					}
+					unlock_kernel();
 					return 0;
 				} else
 					return -EINVAL;
@@ -1679,6 +1757,7 @@ isdn_ioctl(struct inode *inode, struct file *file, uint cmd, ulong arg)
 					if (copy_from_user(&iocts, argp, sizeof(isdn_ioctl_struct)))
 						return -EFAULT;
 					iocts.drvid[sizeof(iocts.drvid)-1] = 0;
+					lock_kernel();
 					if (strlen(iocts.drvid)) {
 						if ((p = strchr(iocts.drvid, ',')))
 							*p = 0;
@@ -1690,16 +1769,21 @@ isdn_ioctl(struct inode *inode, struct file *file, uint cmd, ulong arg)
 							}
 					} else
 						drvidx = 0;
-					if (drvidx == -1)
+					if (drvidx == -1) {
+						unlock_kernel();
 						return -ENODEV;
+					}
 					if (!access_ok(VERIFY_WRITE, argp,
-					     sizeof(isdn_ioctl_struct)))
+					     sizeof(isdn_ioctl_struct))) {
+						unlock_kernel();
 						return -EFAULT;
+					}
 					c.driver = drvidx;
 					c.command = ISDN_CMD_IOCTL;
 					c.arg = cmd;
 					memcpy(c.parm.num, &iocts.arg, sizeof(ulong));
 					ret = isdn_command(&c);
+					unlock_kernel();
 					memcpy(&iocts.arg, c.parm.num, sizeof(ulong));
 					if (copy_to_user(argp, &iocts, sizeof(isdn_ioctl_struct)))
 						return -EFAULT;
@@ -1709,8 +1793,12 @@ isdn_ioctl(struct inode *inode, struct file *file, uint cmd, ulong arg)
 		}
 	}
 #ifdef CONFIG_ISDN_PPP
-	if (minor <= ISDN_MINOR_PPPMAX)
-		return (isdn_ppp_ioctl(minor - ISDN_MINOR_PPP, file, cmd, arg));
+	if (minor <= ISDN_MINOR_PPPMAX) {
+		lock_kernel();
+		ret = isdn_ppp_ioctl(minor - ISDN_MINOR_PPP, file, cmd, arg);
+		unlock_kernel();
+		return ret;
+	}
 #endif
 	return -ENODEV;
 
@@ -1836,7 +1924,7 @@ static const struct file_operations isdn_fops =
 	.read		= isdn_read,
 	.write		= isdn_write,
 	.poll		= isdn_poll,
-	.ioctl		= isdn_ioctl,
+	.unlocked_ioctl	= isdn_ioctl,
 	.open		= isdn_open,
 	.release	= isdn_close,
 };
