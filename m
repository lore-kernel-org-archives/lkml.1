Return-Path: <linux-kernel-owner+w=401wt.eu-S1753295AbXFOIk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295AbXFOIk6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 04:40:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752035AbXFOIkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 04:40:51 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:47362 "EHLO
	mail.enneenne.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752225AbXFOIkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 04:40:49 -0400
Date: Fri, 15 Jun 2007 10:42:10 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linuxpps@ml.enneenne.com
Message-ID: <20070615084210.GB14814@enneenne.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="7ZAtKRhVyVSsbBD2"
Content-Disposition: inline
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: [RFC] LinuxPPS & syscalls support
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--7ZAtKRhVyVSsbBD2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

here my first proposal for LinuxPPS implemented with new specific
syscalls.

I'd like some comments before sending a "definitive" patch. :)

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127

--7ZAtKRhVyVSsbBD2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=proposed_patch

diff --git a/arch/i386/kernel/syscall_table.S b/arch/i386/kernel/syscall_table.S
index 0772678..63c5fc1 100644
--- a/arch/i386/kernel/syscall_table.S
+++ b/arch/i386/kernel/syscall_table.S
@@ -320,3 +320,8 @@ ENTRY(sys_call_table)
 	.long sys_getcpu
 	.long sys_epoll_pwait
 	.long sys_utimensat		/* 320 */
+	.long sys_time_pps_find
+	.long sys_time_pps_getparams
+	.long sys_time_pps_setparams
+	.long sys_time_pps_getcap
+	.long sys_time_pps_fetch	/* 325 */
diff --git a/drivers/pps/Kconfig b/drivers/pps/Kconfig
index 54297e8..0f5c784 100644
--- a/drivers/pps/Kconfig
+++ b/drivers/pps/Kconfig
@@ -5,7 +5,7 @@
 menu "PPS support"
 
 config PPS
-	tristate "PPS support"
+	bool "PPS support"
 	depends on EXPERIMENTAL
 	---help---
 	  PPS (Pulse Per Second) is a special pulse provided by some GPS
diff --git a/drivers/pps/clients/Kconfig b/drivers/pps/clients/Kconfig
index a87cd37..867df3a 100644
--- a/drivers/pps/clients/Kconfig
+++ b/drivers/pps/clients/Kconfig
@@ -15,22 +15,14 @@ config PPS_CLIENT_KTIMER
 	  This driver can also be built as a module.  If so, the module
 	  will be called ktimer.o.
 
-comment "UART serial support (forced off)"
-	depends on ! (SERIAL_CORE != n && !(PPS = m && SERIAL_CORE = y))
-
 config PPS_CLIENT_UART
 	bool "UART serial support"
-	depends on SERIAL_CORE != n && !(PPS = m && SERIAL_CORE = y)
 	help
 	  If you say yes here you get support for a PPS source connected
 	  with the CD (Carrier Detect) pin of your serial port.
 
-comment "Parallel printer support (forced off)"
-	depends on !( PRINTER != n && !(PPS = m && PRINTER = y))
-
 config PPS_CLIENT_LP
 	bool "Parallel printer support"
-	depends on PRINTER != n && !(PPS = m && PRINTER = y)
 	help
 	  If you say yes here you get support for a PPS source connected
 	  with the interrupt pin of your parallel port.
diff --git a/drivers/pps/kapi.c b/drivers/pps/kapi.c
index 098f329..dd24c31 100644
--- a/drivers/pps/kapi.c
+++ b/drivers/pps/kapi.c
@@ -23,6 +23,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/sched.h>
 #include <linux/time.h>
 #include <linux/pps.h>
 
@@ -146,7 +147,7 @@ void pps_unregister_source(struct pps_source_info_s *info)
 	pps_sysfs_remove_source_entry(info);
 
 	if (mutex_lock_interruptible(&pps_mutex))
-		return -EINTR;
+		return;
 	__pps_unregister_source(info);
 	mutex_unlock(&pps_mutex);
 }
diff --git a/drivers/pps/pps.c b/drivers/pps/pps.c
index 71adf0c..2dd45ed 100644
--- a/drivers/pps/pps.c
+++ b/drivers/pps/pps.c
@@ -24,9 +24,10 @@
 #include <linux/version.h>
 #include <linux/module.h>
 #include <linux/init.h>
-#include <linux/skbuff.h>
-
+#include <linux/linkage.h>
+#include <linux/sched.h>
 #include <linux/pps.h>
+#include <asm/uaccess.h>
 
 /*
  * Global variables
@@ -40,12 +41,6 @@ struct pps_source_info_s dummy_info;	/* Dummy PPS info for unallocated
 					   PPS sources */
 
 /*
- * Local variables
- */
-
-static struct sock *nl_sk = NULL;
-
-/*
  * Misc functions
  */
 
@@ -94,236 +89,285 @@ static int pps_find_path(char *path)
 }
 
 /*
- * Input function
+ * PPS System Calls
  */
 
-static void pps_nl_data_ready(struct sock *sk, int len)
+static long __sys_time_pps_find(int cmd, int __user *source,
+	char __user *name, int namelen, char __user *path, int pathlen)
 {
-	struct sk_buff *skb;
-	struct nlmsghdr *nlh;
-	struct pps_netlink_msg *nlpps;
-	int cmd, source, id;
-	unsigned long timeout;
-	int ret;
+	switch (cmd) {
+	case PPS_FIND_SRC :
+		/* Sanity checks */
+		if (!source)
+			return -EINVAL;
 
-	while ((skb = skb_dequeue(&sk->sk_receive_queue)) != NULL) {
-		nlh = (struct nlmsghdr *) skb->data;
-		pps_dbg("New message from PID %d (flags %x)",
-			nlh->nlmsg_pid, nlh->nlmsg_flags);
-
-		/* Decode the userland command */
-		nlpps = (struct pps_netlink_msg*) NLMSG_DATA(nlh);
-		cmd = nlpps->cmd;
-		source = nlpps->source;
-
-		switch (cmd) {
-		case PPS_CREATE:
-			pps_dbg("PPS_CREATE: source %d", source);
-
-			/* Check if the requested source is allocated */
-			ret = pps_find_source(source);
-			if (ret < 0) {
-				nlpps->ret = ret;
-				break;
-			}
+		pps_dbg("PPS_FIND_SRC: source %d", *source);
 
-			nlpps->source = ret;
-			nlpps->ret = 0;
+		*source = pps_find_source(*source);
+		if (*source < 0) {
+			pps_dbg("no PPS devices found");
+			return -ENODEV;
 			break;
+	 	}
+
+		break;
 
-		case PPS_DESTROY:
-			pps_dbg("PPS_DESTROY: source %d", source);
+	case PPS_FIND_PATH :
+		pps_dbg("PPS_FIND_PATH: path %s", path);
+
+		/* Sanity checks */
+		if (!path)
+			return -EINVAL;
 
-			/* Nothing to do here! Just answer ok... */
-			nlpps->ret = 0;
+		*source = pps_find_path(path);
+		if (*source < 0) {
+			pps_dbg("no PPS devices found");
+			return -ENODEV;
 			break;
+	 	}
 
-		case PPS_SETPARMS:
-			pps_dbg("PPS_SETPARMS: source %d", source);
+		break;
 
-			/* Check the capabilities */
-			if (!capable(CAP_SYS_TIME)) {
-				nlpps->ret = -EPERM;
-				break;
-		 	}
+	default :
+		pps_err("invalid sys_pps_cmd %d", cmd);
+		return -EOPNOTSUPP;
+	}
 
-			/* Sanity checks */
-			ret = pps_check_source(source);
-			if (ret < 0) {
-				nlpps->ret = ret;
-				break;
-			}
-			if ((nlpps->params.mode & ~pps_source[source].info->mode) != 0) {
-				pps_dbg("unsupported capabilities");
-				nlpps->ret = -EINVAL;
-				break;
-		 	}
-			if ((nlpps->params.mode & (PPS_CAPTUREASSERT|PPS_CAPTURECLEAR)) == 0) {
-				pps_dbg("capture mode unspecified");
-				nlpps->ret = -EINVAL;
-				break;
-			}
-			if ((nlpps->params.mode & (PPS_TSFMT_TSPEC|PPS_TSFMT_NTPFP)) == 0) {
-				/* section 3.3 of RFC 2783 interpreted */
-				pps_dbg("time format unspecified");
-				nlpps->params.mode |= PPS_TSFMT_TSPEC;
-			}
+	/* Found! So copy the info */
+	if (name)
+		strncpy(name, pps_source[*source].info->name,
+				min(PPS_MAX_NAME_LEN, namelen));
+	if (path)
+		strncpy(path, pps_source[*source].info->path,
+				min(PPS_MAX_NAME_LEN, pathlen));
 
-			/* Save the new parameters */
-			pps_source[source].params = nlpps->params;
+	return 0;
+}
 
-			/* Restore the read only parameters */
-			if (pps_source[source].info->mode&PPS_CANWAIT)
-				pps_source[source].params.mode |= PPS_CANWAIT;
-			pps_source[source].params.api_version = PPS_API_VERS;
+asmlinkage long sys_time_pps_find(int cmd, int __user *source,
+	char __user *name, int namelen, char __user *path, int pathlen)
+{
+	int ret;
 
-			nlpps->ret = 0;
-			break;
+	pps_dbg("%s: cmd %d", __FUNCTION__, cmd);
 
-		case PPS_GETPARMS:
-			pps_dbg("PPS_GETPARMS: source %d", source);
+	/* Sanity checks */
+	if (!access_ok(VERIFY_READ | VERIFY_WRITE, source, sizeof(int)))
+		return -EFAULT;
+	if (!access_ok(VERIFY_READ | VERIFY_WRITE, name, namelen))
+		return -EFAULT;
+	if (!access_ok(VERIFY_READ | VERIFY_WRITE, path, pathlen))
+		return -EFAULT;
 
-			/* Sanity checks */
-			ret = pps_check_source(source);
-			if (ret < 0) {
-				nlpps->ret = ret;
-				break;
-			}
+	if (mutex_lock_interruptible(&pps_mutex))
+		return -EINTR;
+	ret = __sys_time_pps_find(cmd, source, name, namelen, path, pathlen);
+	mutex_unlock(&pps_mutex);
 
-			nlpps->params = pps_source[source].params;
-			nlpps->ret = 0;
-			break;
+	return ret;
+}
 
-	 	case PPS_GETCAP:
-			pps_dbg("PPS_GETCAP: source %d", source);
+static long __sys_time_pps_getparams(int source,
+					struct pps_params __user *params)
+{
+	int ret;
 
-			/* Sanity checks */
-			ret = pps_check_source(source);
-			if (ret < 0) {
-				nlpps->ret = ret;
-				break;
-			}
+	ret = pps_check_source(source);
+	if (ret < 0)
+		return -ENODEV;
 
-			nlpps->mode = pps_source[source].info->mode;
-			nlpps->ret = 0;
-			break;
+	*params = pps_source[source].params;
 
-	 	case PPS_FETCH:
-			pps_dbg("PPS_FETCH: source %d", source);
+	return 0;
+}
 
-			/* Sanity checks */
-			ret = pps_check_source(source);
-			if (ret < 0) {
-				nlpps->ret = ret;
-				break;
-			}
-			if (nlpps->tsformat != PPS_TSFMT_TSPEC) {
-				pps_dbg("unsupported time format");
-				nlpps->ret = -EINVAL;
-				break;
-		 	}
-
-			pps_source[source].go = 0;
-
-		 	/* Manage the timeout */
-			if (nlpps->timeout.tv_sec != -1) {
-				timeout = nlpps->timeout.tv_sec * HZ;
-				timeout += nlpps->timeout.tv_nsec/
-						(NSEC_PER_SEC/HZ);
-				pps_dbg("timeout %ld.%09ld",
-					nlpps->timeout.tv_sec,
-					nlpps->timeout.tv_nsec);
-
-				if (timeout != 0) {
-					ret = wait_event_interruptible_timeout(
-						pps_source[source].queue,
-						pps_source[source].go, timeout);
-		  			if (ret == 0) {
-						pps_dbg("timeout expired");
-						nlpps->ret = -ETIMEDOUT;
-						break;
-					}
-				}
-		 	} else
-				ret = wait_event_interruptible(
-						pps_source[source].queue,
-						pps_source[source].go);
-
-			/* Check for pending signals */
-			if (ret == -ERESTARTSYS) {
-				pps_dbg("pending signal caught");
-				nlpps->ret = -EINTR;
-				break;
-			}
+asmlinkage long sys_time_pps_getparams(int source,
+					struct pps_params __user *params)
+{
+	int ret;
 
-			/* Return the fetched timestamp */
-			nlpps->info.assert_sequence = pps_source[source].assert_sequence;
-			nlpps->info.clear_sequence = pps_source[source].clear_sequence;
-			nlpps->info.assert_tu = pps_source[source].assert_tu;
-			nlpps->info.clear_tu = pps_source[source].clear_tu;
-			nlpps->info.current_mode = pps_source[source].current_mode;
+	pps_dbg("%s: source %d", __FUNCTION__, source);
 
-			nlpps->ret = 0;
-			break;
+	/* Sanity checks */
+	if (!params)
+		return -EINVAL;
+	if (!access_ok(VERIFY_WRITE, params, sizeof(struct pps_params)))
+		return -EFAULT;
 
-	 	case PPS_KC_BIND:
-			pps_dbg("PPS_KC_BIND: source %d", source);
-			/* Feature currently not supported */
-			nlpps->ret = -EOPNOTSUPP;
-			break;
+	if (mutex_lock_interruptible(&pps_mutex))
+		return -EINTR;
+	ret = __sys_time_pps_getparams(source, params);
+	mutex_unlock(&pps_mutex);
 
-		case PPS_FIND_SRC:
-			pps_dbg("PPS_FIND_SRC: source %d", source);
-			source = pps_find_source(source);
-			if (source < 0) {
-				pps_dbg("no PPS devices found");
-				nlpps->ret = -ENODEV;
-				break;
-		 	}
-
-			/* Found! So copy the info */
-			nlpps->source = source;
-			strncpy(nlpps->name, pps_source[source].info->name,
-				PPS_MAX_NAME_LEN);
-			strncpy(nlpps->path, pps_source[source].info->path,
-				PPS_MAX_NAME_LEN);
-			nlpps->ret = 0;
-			break;
+	return ret;
+}
 
-		case PPS_FIND_PATH:
-			pps_dbg("PPS_FIND_PATH: source %s", nlpps->path);
-			source = pps_find_path(nlpps->path);
-			if (source < 0) {
-				pps_dbg("no PPS devices found");
-				nlpps->ret = -ENODEV;
-				break;
-		 	}
-
-			/* Found! So copy the info */
-			nlpps->source = source;
-			strncpy(nlpps->name, pps_source[source].info->name,
-				PPS_MAX_NAME_LEN);
-			strncpy(nlpps->path, pps_source[source].info->path,
-				PPS_MAX_NAME_LEN);
-			nlpps->ret = 0;
-			break;
+static long __sys_time_pps_setparams(int source,
+					const struct pps_params __user *params)
+{
+	int ret;
 
-		default:
-			/* Unknow command */
-			pps_dbg("unknow command %d", nlpps->cmd);
+	ret = pps_check_source(source);
+	if (ret < 0)
+		return -ENODEV;
 
-			nlpps->ret = -EINVAL;
-		}
+	/* Save the new parameters */
+	pps_source[source].params = *params;
 
-		/* Send an answer to the userland */
-		id = NETLINK_CB(skb).pid;
-		pps_dbg("start sending reply to ID %d...", id);
-		NETLINK_CB(skb).pid = 0;	/* from the kernel */
-		NETLINK_CB(skb).dst_group = 0;	/* not in mcast groups */
+	/* Restore the read only parameters */
+	if ((params->mode & (PPS_TSFMT_TSPEC | PPS_TSFMT_NTPFP)) == 0) {
+		/* section 3.3 of RFC 2783 interpreted */
+		pps_dbg("time format unspecified");
+		pps_source[source].params.mode |= PPS_TSFMT_TSPEC;
+	}
+	if (pps_source[source].info->mode & PPS_CANWAIT)
+		pps_source[source].params.mode |= PPS_CANWAIT;
+	pps_source[source].params.api_version = PPS_API_VERS;
 
-		ret = netlink_unicast(nl_sk, skb, id, MSG_DONTWAIT);
-		pps_dbg("... reply sent (%d)", ret);
+	return 0;
+}
+
+asmlinkage long sys_time_pps_setparams(int source,
+					const struct pps_params __user *params)
+{
+	int ret;
+
+	pps_dbg("%s: source %d", __FUNCTION__, source);
+
+	/* Check the capabilities */
+	if (!capable(CAP_SYS_TIME))
+		return -EPERM;
+
+	/* Sanity checks */
+	if (!params)
+		return -EINVAL;
+	if (!access_ok(VERIFY_READ, params, sizeof(struct pps_params)))
+		return -EFAULT;
+	if ((params->mode & ~pps_source[source].info->mode) != 0) {
+		pps_dbg("unsupported capabilities");
+		return -EINVAL;
+ 	}
+	if ((params->mode & (PPS_CAPTUREASSERT | PPS_CAPTURECLEAR)) == 0) {
+		pps_dbg("capture mode unspecified");
+		return -EINVAL;
+	}
+
+	if (mutex_lock_interruptible(&pps_mutex))
+		return -EINTR;
+	ret = __sys_time_pps_setparams(source, params);
+	mutex_unlock(&pps_mutex);
+
+	return ret;
+}
+
+static long __sys_time_pps_getcap(int source, int __user *mode)
+{
+	int ret;
+
+	ret = pps_check_source(source);
+	if (ret < 0)
+		return -ENODEV;
+
+	*mode = pps_source[source].info->mode;
+
+	return 0;
+}
+
+asmlinkage long sys_time_pps_getcap(int source, int __user *mode)
+{
+	int ret;
+
+	pps_dbg("%s: source %d", __FUNCTION__, source);
+
+	/* Sanity checks */
+	if (!mode)
+		return -EINVAL;
+	if (!access_ok(VERIFY_WRITE, mode, sizeof(int)))
+		return -EFAULT;
+
+	if (mutex_lock_interruptible(&pps_mutex))
+		return -EINTR;
+	ret = __sys_time_pps_getcap(source, mode);
+	mutex_unlock(&pps_mutex);
+
+	return ret;
+}
+
+static long __sys_time_pps_fetch(int source, const int tsformat,
+					struct pps_info __user *info, 
+					const struct timespec __user *timeout)
+{
+	unsigned long ticks;
+	int ret;
+
+	ret = pps_check_source(source);
+	if (ret < 0)
+		return -ENODEV;
+
+	pps_source[source].go = 0;
+
+ 	/* Manage the timeout */
+	if (timeout || timeout->tv_sec != -1) {
+		if (!access_ok(VERIFY_READ, timeout, sizeof(struct timespec)))
+			return -EFAULT;
+
+		pps_dbg("timeout %ld.%09ld", timeout->tv_sec, timeout->tv_nsec);
+		ticks = timeout->tv_sec * HZ;
+		ticks += timeout->tv_nsec/ (NSEC_PER_SEC / HZ);
+
+		if (ticks != 0) {
+			ret = wait_event_interruptible_timeout(
+				pps_source[source].queue,
+				pps_source[source].go, ticks);
+  			if (ret == 0) {
+				pps_dbg("timeout expired");
+				return -ETIMEDOUT;
+			}
+		}
+ 	} else
+		ret = wait_event_interruptible( pps_source[source].queue,
+				pps_source[source].go);
+
+	/* Check for pending signals */
+	if (ret == -ERESTARTSYS) {
+		pps_dbg("pending signal caught");
+		return -EINTR;
 	}
+
+	/* Return the fetched timestamp */
+	info->assert_sequence = pps_source[source].assert_sequence;
+	info->clear_sequence = pps_source[source].clear_sequence;
+	info->assert_tu = pps_source[source].assert_tu;
+	info->clear_tu = pps_source[source].clear_tu;
+	info->current_mode = pps_source[source].current_mode;
+
+	return 0;
+}
+
+asmlinkage long sys_time_pps_fetch(int source, const int tsformat,
+					struct pps_info __user *info, 
+					const struct timespec __user *timeout)
+{
+	int ret;
+
+	pps_dbg("%s: source %d", __FUNCTION__, source);
+
+	/* Sanity checks */
+	if (tsformat != PPS_TSFMT_TSPEC) {
+		pps_dbg("unsupported time format");
+		return -EINVAL;
+ 	}
+	if (!info)
+		return -EINVAL;
+	if (!access_ok(VERIFY_WRITE, info, sizeof(struct pps_info)))
+		return -EFAULT;
+
+	if (mutex_lock_interruptible(&pps_mutex))
+		return -EINTR;
+	ret = __sys_time_pps_fetch(source, tsformat, info, timeout);
+	mutex_unlock(&pps_mutex);
+
+	return ret;
 }
 
 /*
@@ -333,7 +377,6 @@ static void pps_nl_data_ready(struct sock *sk, int len)
 static void __exit pps_exit(void)
 {
 	pps_sysfs_unregister();
-	sock_release(nl_sk->sk_socket);
 
 	pps_info("LinuxPPS API ver. %d removed", PPS_API_VERS);
 }
@@ -342,14 +385,6 @@ static int __init pps_init(void)
 {
 	int i, ret;
 
-	nl_sk = netlink_kernel_create(NETLINK_PPSAPI, 0,
-					pps_nl_data_ready, NULL, THIS_MODULE);
-	if (nl_sk == NULL) {
-		pps_err("unable to create netlink kernel socket");
-		return -EBUSY;
-	}
-	pps_dbg("netlink protocol %d created", NETLINK_PPSAPI);
-
 	/* Init pps_source info */
 	dummy_info.echo = dummy_echo;
 	for (i = 0; i < PPS_MAX_SOURCES; i++) {
@@ -361,7 +396,7 @@ static int __init pps_init(void)
 	ret = pps_sysfs_register();
 	if (ret < 0) {
 		pps_err("unable to register sysfs");
-		goto pps_sysfs_register_error;
+		return ret;
 	}
 
 	pps_info("LinuxPPS API ver. %d registered", PPS_API_VERS);
@@ -369,12 +404,6 @@ static int __init pps_init(void)
 		"<giometti@linux.it>", PPS_VERSION);
 
 	return 0;
-
-pps_sysfs_register_error:
-
-	sock_release(nl_sk->sk_socket);
-
-	return ret;
 }
 
 subsys_initcall(pps_init);
diff --git a/include/asm-i386/unistd.h b/include/asm-i386/unistd.h
index bd21e79..d84b679 100644
--- a/include/asm-i386/unistd.h
+++ b/include/asm-i386/unistd.h
@@ -326,10 +326,15 @@
 #define __NR_getcpu		318
 #define __NR_epoll_pwait	319
 #define __NR_utimensat		320
+#define __NR_time_pps_find	321
+#define __NR_time_pps_getparams	322
+#define __NR_time_pps_setparams	323
+#define __NR_time_pps_getcap	324
+#define __NR_time_pps_fetch	325
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 321
+#define NR_syscalls 326
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
diff --git a/include/linux/pps.h b/include/linux/pps.h
index 7b66881..c3b5209 100644
--- a/include/linux/pps.h
+++ b/include/linux/pps.h
@@ -33,10 +33,8 @@
 
 #ifndef __KERNEL__
 #include <asm/types.h>
-#include <sys/socket.h>
 #include <sys/time.h>
 #endif
-#include <linux/netlink.h>
 
 #define PPS_API_VERS_2          2       /* LinuxPPS proposal, dated 2006-05 */
 #define PPS_API_VERS            PPS_API_VERS_2
@@ -107,35 +105,12 @@ struct pps_params {
  * Here begins the implementation-specific part!
  */
 
-struct pps_netlink_msg {
-	int cmd;			/* the command to execute */
-	int source;
-	char name[PPS_MAX_NAME_LEN];	/* symbolic name */
-	char path[PPS_MAX_NAME_LEN];	/* path of the connected device */
-	int consumer;			/* selected kernel consumer */
-	struct pps_params params;
-	int mode;			/* edge */
-	int tsformat;			/* format of time stamps */
-	struct pps_info info;
-	struct timespec timeout;
-	int ret;
-};
-#define PPSAPI_MAX_PAYLOAD	sizeof(struct pps_netlink_msg)
-
-#define PPS_CREATE		1
-#define PPS_DESTROY		2
-#define PPS_SETPARMS		3
-#define PPS_GETPARMS		4
-#define PPS_GETCAP		5
-#define PPS_FETCH		6
-#define PPS_KC_BIND		7
-#define PPS_FIND_SRC		8
-#define PPS_FIND_PATH		9
+#define PPS_FIND_SRC		1
+#define PPS_FIND_PATH		2
 
 #ifdef __KERNEL__
 
-#include <linux/socket.h>
-#include <net/sock.h>
+#include <linux/device.h>
 
 /*
  * Misc macros
@@ -225,4 +200,12 @@ extern void pps_sysfs_unregister(void);
 
 #endif /* __KERNEL__ */
 
+struct pps_findsource_s {
+	int *source;
+	char *name;
+	int namelen;
+	char *path;
+	int pathlen;
+}
+
 #endif /* _PPS_H_ */
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 3139f44..e894540 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -65,6 +65,7 @@ struct getcpu_cache;
 #include <asm/signal.h>
 #include <linux/quota.h>
 #include <linux/key.h>
+#include <linux/pps.h>
 
 asmlinkage long sys_time(time_t __user *tloc);
 asmlinkage long sys_stime(time_t __user *tptr);
@@ -605,6 +606,18 @@ asmlinkage long sys_set_robust_list(struct robust_list_head __user *head,
 				    size_t len);
 asmlinkage long sys_getcpu(unsigned __user *cpu, unsigned __user *node, struct getcpu_cache __user *cache);
 
+asmlinkage long sys_time_pps_find(int cmd, int __user *source,
+					char __user *name, int namelen,
+					char __user *path, int pathlen);
+asmlinkage long sys_time_pps_getparams(int source,
+					struct pps_params __user *params);
+asmlinkage long sys_time_pps_setparams(int source,
+					const struct pps_params __user *params);
+asmlinkage long sys_time_pps_getcap(int source, int __user *mode);
+asmlinkage long sys_time_pps_fetch(int source, const int tsformat,
+					struct pps_info __user *info,
+					const struct timespec __user *timeout);
+
 int kernel_execve(const char *filename, char *const argv[], char *const envp[]);
 
 #endif
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index d7306d0..2bbd244 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -141,3 +141,10 @@ cond_syscall(compat_sys_migrate_pages);
 cond_syscall(sys_bdflush);
 cond_syscall(sys_ioprio_set);
 cond_syscall(sys_ioprio_get);
+
+/* PPS dependent */
+cond_syscall(sys_time_pps_find);
+cond_syscall(sys_time_pps_getparams);
+cond_syscall(sys_time_pps_setparams);
+cond_syscall(sys_time_pps_getcap);
+cond_syscall(sys_time_pps_fetch);

--7ZAtKRhVyVSsbBD2--
