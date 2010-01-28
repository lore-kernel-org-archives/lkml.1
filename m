Return-Path: <linux-kernel-owner+w=401wt.eu-S1756557Ab0A1XjK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557Ab0A1XjK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 18:39:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756527Ab0A1XjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 18:39:05 -0500
Received: from kroah.org ([198.145.64.141]:46844 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756471Ab0A1Xh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 18:37:59 -0500
Date: Thu, 28 Jan 2010 15:36:58 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
Subject: Re: Linux 2.6.27.45
Message-ID: <20100128233658.GD18110@kroah.com>
References: <20100128233645.GC18110@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100128233645.GC18110@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index 78f4d74..e94783d 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 27
-EXTRAVERSION = .44
+EXTRAVERSION = .45
 NAME = Trembling Tortoise
 
 # *DOCUMENTATION*
diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
index 6123610..060ede7 100644
--- a/arch/s390/kvm/intercept.c
+++ b/arch/s390/kvm/intercept.c
@@ -199,7 +199,7 @@ static int handle_instruction_and_prog(struct kvm_vcpu *vcpu)
 	return rc2;
 }
 
-static const intercept_handler_t intercept_funcs[0x48 >> 2] = {
+static const intercept_handler_t intercept_funcs[] = {
 	[0x00 >> 2] = handle_noop,
 	[0x04 >> 2] = handle_instruction,
 	[0x08 >> 2] = handle_prog,
@@ -216,7 +216,7 @@ int kvm_handle_sie_intercept(struct kvm_vcpu *vcpu)
 	intercept_handler_t func;
 	u8 code = vcpu->arch.sie_block->icptcode;
 
-	if (code & 3 || code > 0x48)
+	if (code & 3 || (code >> 2) >= ARRAY_SIZE(intercept_funcs))
 		return -ENOTSUPP;
 	func = intercept_funcs[code >> 2];
 	if (func)
diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 0232485..c4b82c7 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -2437,8 +2437,8 @@ static int tty_fasync(int fd, struct file *filp, int on)
 			pid = task_pid(current);
 			type = PIDTYPE_PID;
 		}
-		spin_unlock_irqrestore(&tty->ctrl_lock, flags);
 		retval = __f_setown(filp, pid, type, 0);
+		spin_unlock_irqrestore(&tty->ctrl_lock, flags);
 		if (retval)
 			goto out;
 	} else {
diff --git a/drivers/edac/i5000_edac.c b/drivers/edac/i5000_edac.c
index 4a16b5b..d4297dc 100644
--- a/drivers/edac/i5000_edac.c
+++ b/drivers/edac/i5000_edac.c
@@ -566,7 +566,13 @@ static void i5000_process_nonfatal_error_info(struct mem_ctl_info *mci,
 		debugf0("\tUncorrected bits= 0x%x\n", ue_errors);
 
 		branch = EXTRACT_FBDCHAN_INDX(info->ferr_nf_fbd);
-		channel = branch;
+
+		/*
+		 * According with i5000 datasheet, bit 28 has no significance
+		 * for errors M4Err-M12Err and M17Err-M21Err, on FERR_NF_FBD
+		 */
+		channel = branch & 2;
+
 		bank = NREC_BANK(info->nrecmema);
 		rank = NREC_RANK(info->nrecmema);
 		rdwr = NREC_RDWR(info->nrecmema);
diff --git a/drivers/scsi/megaraid/megaraid_sas.c b/drivers/scsi/megaraid/megaraid_sas.c
index 97b7633..4c3f124 100644
--- a/drivers/scsi/megaraid/megaraid_sas.c
+++ b/drivers/scsi/megaraid/megaraid_sas.c
@@ -3462,7 +3462,7 @@ out:
 	return retval;
 }
 
-static DRIVER_ATTR(poll_mode_io, S_IRUGO|S_IWUGO,
+static DRIVER_ATTR(poll_mode_io, S_IRUGO|S_IWUSR,
 		megasas_sysfs_show_poll_mode_io,
 		megasas_sysfs_set_poll_mode_io);
 
diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 769f80f..3240519 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -3015,6 +3015,9 @@ static void hub_events(void)
 					USB_PORT_FEAT_C_SUSPEND);
 				udev = hdev->children[i-1];
 				if (udev) {
+					/* TRSMRCY = 10 msec */
+					msleep(10);
+
 					usb_lock_device(udev);
 					ret = remote_wakeup(hdev->
 							children[i-1]);
diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index df7b605..6ef2a89 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -723,9 +723,10 @@ static irqreturn_t ehci_irq (struct usb_hcd *hcd)
 
 			/* start 20 msec resume signaling from this port,
 			 * and make khubd collect PORT_STAT_C_SUSPEND to
-			 * stop that signaling.
+			 * stop that signaling.  Use 5 ms extra for safety,
+			 * like usb_port_resume() does.
 			 */
-			ehci->reset_done [i] = jiffies + msecs_to_jiffies (20);
+			ehci->reset_done[i] = jiffies + msecs_to_jiffies(25);
 			ehci_dbg (ehci, "port %d remote wakeup\n", i + 1);
 			mod_timer(&hcd->rh_timer, ehci->reset_done[i]);
 		}
diff --git a/drivers/usb/host/ehci-hub.c b/drivers/usb/host/ehci-hub.c
index 740835b..ef9b038 100644
--- a/drivers/usb/host/ehci-hub.c
+++ b/drivers/usb/host/ehci-hub.c
@@ -119,9 +119,26 @@ static int ehci_bus_suspend (struct usb_hcd *hcd)
 	del_timer_sync(&ehci->watchdog);
 	del_timer_sync(&ehci->iaa_watchdog);
 
-	port = HCS_N_PORTS (ehci->hcs_params);
 	spin_lock_irq (&ehci->lock);
 
+	/* Once the controller is stopped, port resumes that are already
+	 * in progress won't complete.  Hence if remote wakeup is enabled
+	 * for the root hub and any ports are in the middle of a resume or
+	 * remote wakeup, we must fail the suspend.
+	 */
+	if (hcd->self.root_hub->do_remote_wakeup) {
+		port = HCS_N_PORTS(ehci->hcs_params);
+		while (port--) {
+			if (ehci->reset_done[port] != 0) {
+				spin_unlock_irq(&ehci->lock);
+				ehci_dbg(ehci, "suspend failed because "
+						"port %d is resuming\n",
+						port + 1);
+				return -EBUSY;
+			}
+		}
+	}
+
 	/* stop schedules, clean any completed work */
 	if (HC_IS_RUNNING(hcd->state)) {
 		ehci_quiesce (ehci);
@@ -137,6 +154,7 @@ static int ehci_bus_suspend (struct usb_hcd *hcd)
 	 */
 	ehci->bus_suspended = 0;
 	ehci->owned_ports = 0;
+	port = HCS_N_PORTS(ehci->hcs_params);
 	while (port--) {
 		u32 __iomem	*reg = &ehci->regs->port_status [port];
 		u32		t1 = ehci_readl(ehci, reg) & ~PORT_RWC_BITS;
diff --git a/drivers/usb/host/ehci-q.c b/drivers/usb/host/ehci-q.c
index 01132ac..097dd55 100644
--- a/drivers/usb/host/ehci-q.c
+++ b/drivers/usb/host/ehci-q.c
@@ -748,9 +748,10 @@ qh_make (
 				 * But interval 1 scheduling is simpler, and
 				 * includes high bandwidth.
 				 */
-				dbg ("intr period %d uframes, NYET!",
-						urb->interval);
-				goto done;
+				urb->interval = 1;
+			} else if (qh->period > ehci->periodic_size) {
+				qh->period = ehci->periodic_size;
+				urb->interval = qh->period << 3;
 			}
 		} else {
 			int		think_time;
@@ -773,6 +774,10 @@ qh_make (
 					usb_calc_bus_time (urb->dev->speed,
 					is_input, 0, max_packet (maxp)));
 			qh->period = urb->interval;
+			if (qh->period > ehci->periodic_size) {
+				qh->period = ehci->periodic_size;
+				urb->interval = qh->period;
+			}
 		}
 	}
 
diff --git a/drivers/usb/host/uhci-hcd.c b/drivers/usb/host/uhci-hcd.c
index 59bed3c..dc25f4e 100644
--- a/drivers/usb/host/uhci-hcd.c
+++ b/drivers/usb/host/uhci-hcd.c
@@ -750,7 +750,20 @@ static int uhci_rh_suspend(struct usb_hcd *hcd)
 	spin_lock_irq(&uhci->lock);
 	if (!test_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags))
 		rc = -ESHUTDOWN;
-	else if (!uhci->dead)
+	else if (uhci->dead)
+		;		/* Dead controllers tell no tales */
+
+	/* Once the controller is stopped, port resumes that are already
+	 * in progress won't complete.  Hence if remote wakeup is enabled
+	 * for the root hub and any ports are in the middle of a resume or
+	 * remote wakeup, we must fail the suspend.
+	 */
+	else if (hcd->self.root_hub->do_remote_wakeup &&
+			uhci->resuming_ports) {
+		dev_dbg(uhci_dev(uhci), "suspend failed because a port "
+				"is resuming\n");
+		rc = -EBUSY;
+	} else
 		suspend_rh(uhci, UHCI_RH_SUSPENDED);
 	spin_unlock_irq(&uhci->lock);
 	return rc;
diff --git a/drivers/usb/host/uhci-hub.c b/drivers/usb/host/uhci-hub.c
index 885b585..8270055 100644
--- a/drivers/usb/host/uhci-hub.c
+++ b/drivers/usb/host/uhci-hub.c
@@ -167,7 +167,7 @@ static void uhci_check_ports(struct uhci_hcd *uhci)
 				/* Port received a wakeup request */
 				set_bit(port, &uhci->resuming_ports);
 				uhci->ports_timeout = jiffies +
-						msecs_to_jiffies(20);
+						msecs_to_jiffies(25);
 
 				/* Make sure we see the port again
 				 * after the resuming period is over. */
diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index 06db79d..8c9ec6e 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -1733,7 +1733,7 @@ ecryptfs_process_key_cipher(struct crypto_blkcipher **key_tfm,
 			    char *cipher_name, size_t *key_size)
 {
 	char dummy_key[ECRYPTFS_MAX_KEY_BYTES];
-	char *full_alg_name;
+	char *full_alg_name = NULL;
 	int rc;
 
 	*key_tfm = NULL;
@@ -1748,7 +1748,6 @@ ecryptfs_process_key_cipher(struct crypto_blkcipher **key_tfm,
 	if (rc)
 		goto out;
 	*key_tfm = crypto_alloc_blkcipher(full_alg_name, 0, CRYPTO_ALG_ASYNC);
-	kfree(full_alg_name);
 	if (IS_ERR(*key_tfm)) {
 		rc = PTR_ERR(*key_tfm);
 		printk(KERN_ERR "Unable to allocate crypto cipher with name "
@@ -1770,6 +1769,7 @@ ecryptfs_process_key_cipher(struct crypto_blkcipher **key_tfm,
 		goto out;
 	}
 out:
+	kfree(full_alg_name);
 	return rc;
 }
 
diff --git a/fs/ecryptfs/file.c b/fs/ecryptfs/file.c
index 9244d65..bbc723a 100644
--- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -192,13 +192,6 @@ static int ecryptfs_open(struct inode *inode, struct file *file)
 				      | ECRYPTFS_ENCRYPTED);
 	}
 	mutex_unlock(&crypt_stat->cs_mutex);
-	if ((ecryptfs_inode_to_private(inode)->lower_file->f_flags & O_RDONLY)
-	    && !(file->f_flags & O_RDONLY)) {
-		rc = -EPERM;
-		printk(KERN_WARNING "%s: Lower persistent file is RO; eCryptfs "
-		       "file must hence be opened RO\n", __func__);
-		goto out;
-	}
 	if (!ecryptfs_inode_to_private(inode)->lower_file) {
 		rc = ecryptfs_init_persistent_file(ecryptfs_dentry);
 		if (rc) {
@@ -209,6 +202,13 @@ static int ecryptfs_open(struct inode *inode, struct file *file)
 			goto out;
 		}
 	}
+	if ((ecryptfs_inode_to_private(inode)->lower_file->f_flags & O_RDONLY)
+	    && !(file->f_flags & O_RDONLY)) {
+		rc = -EPERM;
+		printk(KERN_WARNING "%s: Lower persistent file is RO; eCryptfs "
+		       "file must hence be opened RO\n", __func__);
+		goto out;
+	}
 	ecryptfs_set_file_lower(
 		file, ecryptfs_inode_to_private(inode)->lower_file);
 	if (S_ISDIR(ecryptfs_dentry->d_inode->i_mode)) {
diff --git a/fs/fcntl.c b/fs/fcntl.c
index ac79b7e..4eed4d6 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -200,7 +200,9 @@ static int setfl(int fd, struct file * filp, unsigned long arg)
 static void f_modown(struct file *filp, struct pid *pid, enum pid_type type,
                      uid_t uid, uid_t euid, int force)
 {
-	write_lock_irq(&filp->f_owner.lock);
+	unsigned long flags;
+
+	write_lock_irqsave(&filp->f_owner.lock, flags);
 	if (force || !filp->f_owner.pid) {
 		put_pid(filp->f_owner.pid);
 		filp->f_owner.pid = get_pid(pid);
@@ -208,7 +210,7 @@ static void f_modown(struct file *filp, struct pid *pid, enum pid_type type,
 		filp->f_owner.uid = uid;
 		filp->f_owner.euid = euid;
 	}
-	write_unlock_irq(&filp->f_owner.lock);
+	write_unlock_irqrestore(&filp->f_owner.lock, flags);
 }
 
 int __f_setown(struct file *filp, struct pid *pid, enum pid_type type,
diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index 8c2615e..59973bc 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -2545,6 +2545,12 @@ static int reiserfs_writepage(struct page *page, struct writeback_control *wbc)
 	return reiserfs_write_full_page(page, wbc);
 }
 
+static void reiserfs_truncate_failed_write(struct inode *inode)
+{
+	truncate_inode_pages(inode->i_mapping, inode->i_size);
+	reiserfs_truncate_file(inode, 0);
+}
+
 static int reiserfs_write_begin(struct file *file,
 				struct address_space *mapping,
 				loff_t pos, unsigned len, unsigned flags,
@@ -2611,6 +2617,8 @@ static int reiserfs_write_begin(struct file *file,
 	if (ret) {
 		unlock_page(page);
 		page_cache_release(page);
+		/* Truncate allocated blocks */
+		reiserfs_truncate_failed_write(inode);
 	}
 	return ret;
 }
@@ -2703,8 +2711,7 @@ static int reiserfs_write_end(struct file *file, struct address_space *mapping,
 	 ** transaction tracking stuff when the size changes.  So, we have
 	 ** to do the i_size updates here.
 	 */
-	pos += copied;
-	if (pos > inode->i_size) {
+	if (pos + copied > inode->i_size) {
 		struct reiserfs_transaction_handle myth;
 		reiserfs_write_lock(inode->i_sb);
 		/* If the file have grown beyond the border where it
@@ -2722,7 +2729,7 @@ static int reiserfs_write_end(struct file *file, struct address_space *mapping,
 			goto journal_error;
 		}
 		reiserfs_update_inode_transaction(inode);
-		inode->i_size = pos;
+		inode->i_size = pos + copied;
 		/*
 		 * this will just nest into our transaction.  It's important
 		 * to use mark_inode_dirty so the inode gets pushed around on the
@@ -2749,6 +2756,10 @@ static int reiserfs_write_end(struct file *file, struct address_space *mapping,
       out:
 	unlock_page(page);
 	page_cache_release(page);
+
+	if (pos + len > inode->i_size)
+		reiserfs_truncate_failed_write(inode);
+
 	return ret == 0 ? copied : ret;
 
       journal_error:
diff --git a/ipc/msg.c b/ipc/msg.c
index 2ceab7f..779f762 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -125,6 +125,7 @@ void msg_init_ns(struct ipc_namespace *ns)
 void msg_exit_ns(struct ipc_namespace *ns)
 {
 	free_ipcs(ns, &msg_ids(ns), freeque);
+	idr_destroy(&ns->ids[IPC_MSG_IDS].ipcs_idr);
 }
 #endif
 
diff --git a/ipc/sem.c b/ipc/sem.c
index 9eb9d31..0c0b28e 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -129,6 +129,7 @@ void sem_init_ns(struct ipc_namespace *ns)
 void sem_exit_ns(struct ipc_namespace *ns)
 {
 	free_ipcs(ns, &sem_ids(ns), freeary);
+	idr_destroy(&ns->ids[IPC_SEM_IDS].ipcs_idr);
 }
 #endif
 
diff --git a/ipc/shm.c b/ipc/shm.c
index 35a65be..37caa44 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -100,6 +100,7 @@ static void do_shm_rmid(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
 void shm_exit_ns(struct ipc_namespace *ns)
 {
 	free_ipcs(ns, &shm_ids(ns), do_shm_rmid);
+	idr_destroy(&ns->ids[IPC_SHM_IDS].ipcs_idr);
 }
 #endif
 
