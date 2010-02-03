Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932961Ab0BCVHl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 16:07:41 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:40333 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932852Ab0BCVHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 16:07:14 -0500
X-Spam-ASN: 
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: linux-kernel@vger.kernel.org
Cc: linuxpps@ml.enneenne.com, "Nikita V\. Youshchenko" <yoush@cs.msu.su>,
       stas@lvk.cs.msu.su, Alexander Gordeev <lasaine@lvk.cs.msu.su>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
       Rodolfo Giometti <giometti@linux.it>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rodolfo Giometti <giometti@enneenne.com>,
       "William S\. Brasher" <billb958@door.net>,
       Reg Clemens <clemens@dwf.com>, Joonwoo Park <joonwpark81@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, Dave Jones <davej@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-doc@vger.kernel.org
Subject: [PATCH 3/5] pps: add kernel consumer support
Date: Wed,  3 Feb 2010 23:56:49 +0300
Message-Id: <76c9e32fb3f9ed3012de53a3690e11a09bef8e4f.1265228858.git.lasaine@lvk.cs.msu.su>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <cover.1265228858.git.lasaine@lvk.cs.msu.su>
References: <cover.1265228858.git.lasaine@lvk.cs.msu.su>
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an optional feature of PPSAPI, kernel consumer support, which uses
the added hardpps() function.

Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
---
 Documentation/ioctl/ioctl-number.txt |    2 +-
 drivers/pps/kapi.c                   |   28 ++++++++++++++
 drivers/pps/pps.c                    |   67 +++++++++++++++++++++++++++++++++-
 include/linux/pps.h                  |    7 ++++
 include/linux/pps_kernel.h           |    6 +++
 5 files changed, 108 insertions(+), 2 deletions(-)

diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
index 9473749..d68718b 100644
--- a/Documentation/ioctl/ioctl-number.txt
+++ b/Documentation/ioctl/ioctl-number.txt
@@ -152,7 +152,7 @@ Code	Seq#	Include File		Comments
 'p'	40-7F	linux/nvram.h
 'p'	80-9F				user-space parport
 					<mailto:tim@cyberelk.net>
-'p'	a1-a4	linux/pps.h		LinuxPPS
+'p'	a1-a5	linux/pps.h		LinuxPPS
 					<mailto:giometti@linux.it>
 'q'	00-1F	linux/serio.h
 'q'	80-FF				Internet PhoneJACK, Internet LineJACK
diff --git a/drivers/pps/kapi.c b/drivers/pps/kapi.c
index 8a77102..59ac4f5 100644
--- a/drivers/pps/kapi.c
+++ b/drivers/pps/kapi.c
@@ -25,6 +25,7 @@
 #include <linux/init.h>
 #include <linux/sched.h>
 #include <linux/time.h>
+#include <linux/timex.h>
 #include <linux/spinlock.h>
 #include <linux/idr.h>
 #include <linux/fs.h>
@@ -37,6 +38,12 @@
 DEFINE_SPINLOCK(pps_idr_lock);
 DEFINE_IDR(pps_idr);
 
+/* state variables to bind kernel consumer */
+/* PPS API (RFC 2783): current source and mode for ``kernel consumer'' */
+DEFINE_SPINLOCK(pps_kc_hardpps_lock);
+void	*pps_kc_hardpps_dev;	/* some unique pointer to device */
+int	pps_kc_hardpps_mode;	/* mode bits for kernel consumer */
+
 /*
  * Local functions
  */
@@ -272,6 +279,7 @@ void pps_event(int source, struct pps_event_time *ts, int event, void *data)
 	struct pps_device *pps;
 	unsigned long flags;
 	int captured = 0;
+	s64 nsec = 0;
 
 	if ((event & (PPS_CAPTUREASSERT | PPS_CAPTURECLEAR)) == 0) {
 		printk(KERN_ERR "pps: unknown event (%x) for source %d\n",
@@ -304,6 +312,11 @@ void pps_event(int source, struct pps_event_time *ts, int event, void *data)
 
 		/* Save the time stamp */
 		pps->assert_tu = ts->ts_real;
+		if (likely(pps->assert_tu_raw.tv_sec != 0)) {
+			struct timespec d =
+				timespec_sub(ts->ts_raw, pps->assert_tu_raw);
+			nsec = timespec_to_ns(&d);
+		}
 		pps->assert_tu_raw = ts->ts_raw;
 		pps->assert_sequence++;
 		pr_debug("capture assert seq #%u for source %d\n",
@@ -320,6 +333,11 @@ void pps_event(int source, struct pps_event_time *ts, int event, void *data)
 
 		/* Save the time stamp */
 		pps->clear_tu = ts->ts_real;
+		if (likely(pps->clear_tu_raw.tv_sec != 0)) {
+			struct timespec d =
+				timespec_sub(ts->ts_raw, pps->clear_tu_raw);
+			nsec = timespec_to_ns(&d);
+		}
 		pps->clear_tu_raw = ts->ts_raw;
 		pps->clear_sequence++;
 		pr_debug("capture clear seq #%u for source %d\n",
@@ -327,6 +345,16 @@ void pps_event(int source, struct pps_event_time *ts, int event, void *data)
 
 		captured = ~0;
 	}
+	spin_lock(&pps_kc_hardpps_lock);
+	if (pps == pps_kc_hardpps_dev && event & pps_kc_hardpps_mode) {
+		struct timespec p_ts = {
+			.tv_sec = ts->ts_real.sec,
+			.tv_nsec = ts->ts_real.nsec
+		};
+
+		hardpps(&p_ts, nsec);
+	}
+	spin_unlock(&pps_kc_hardpps_lock);
 
 	/* Wake up iif captured somthing */
 	if (captured) {
diff --git a/drivers/pps/pps.c b/drivers/pps/pps.c
index ca5183b..22fdcfe 100644
--- a/drivers/pps/pps.c
+++ b/drivers/pps/pps.c
@@ -62,6 +62,8 @@ static long pps_cdev_ioctl(struct file *file,
 	struct pps_device *pps = file->private_data;
 	struct pps_kparams params;
 	struct pps_fdata fdata;
+	struct pps_bind_args bind_args;
+	unsigned long irq_flags;
 	unsigned long ticks;
 	void __user *uarg = (void __user *) arg;
 	int __user *iuarg = (int __user *) arg;
@@ -186,9 +188,72 @@ static long pps_cdev_ioctl(struct file *file,
 
 		break;
 
+	case PPS_KC_BIND:
+		pr_info("PPS_KC_BIND: source %d\n", pps->id);
+
+		/* Check the capabilities */
+		if (!capable(CAP_SYS_TIME))
+			return -EPERM;
+
+		if (copy_from_user(&bind_args, uarg,
+					sizeof(struct pps_bind_args)))
+			return -EFAULT;
+
+		/* Check for supported capabilities */
+		if ((bind_args.edge & ~pps->info.mode) != 0) {
+			pr_err("PPS_KC_BIND: "
+					"unsupported capabilities (%x)\n",
+					bind_args.edge);
+			return -EINVAL;
+		}
+
+		/* Validate parameters roughly */
+		if (bind_args.tsformat != PPS_TSFMT_TSPEC ||
+				(bind_args.edge & ~PPS_CAPTUREBOTH) != 0 ||
+				bind_args.consumer != PPS_KC_HARDPPS) {
+			pr_err("PPS_KC_BIND: "
+					"invalid kcbind parameters (%x)\n",
+					bind_args.edge);
+			return -EINVAL;
+		}
+
+		/* Check if another consumer is already bound */
+		spin_lock_irqsave(&pps_kc_hardpps_lock, irq_flags);
+
+		if (bind_args.edge == 0)
+			if (pps_kc_hardpps_dev == pps) {
+				pps_kc_hardpps_mode = 0;
+				pps_kc_hardpps_dev = NULL;
+				spin_unlock_irqrestore(&pps_kc_hardpps_lock,
+						irq_flags);
+				pr_info("unbound kernel consumer\n");
+			} else {
+				spin_unlock_irqrestore(&pps_kc_hardpps_lock,
+						irq_flags);
+				pr_err("selected kernel consumer"
+						" is not bound\n");
+				return -EINVAL;
+			}
+		else
+			if (pps_kc_hardpps_dev == NULL ||
+					pps_kc_hardpps_dev == pps) {
+				pps_kc_hardpps_mode = bind_args.edge;
+				pps_kc_hardpps_dev = pps;
+				spin_unlock_irqrestore(&pps_kc_hardpps_lock,
+						irq_flags);
+				pr_info("bound kernel consumer: dev=%p, "
+					"edge=0x%x\n", pps, bind_args.edge);
+			} else {
+				spin_unlock_irqrestore(&pps_kc_hardpps_lock,
+						irq_flags);
+				pr_err("another kernel consumer"
+						" is already bound\n");
+				return -EINVAL;
+			}
+		break;
+
 	default:
 		return -ENOTTY;
-		break;
 	}
 
 	return 0;
diff --git a/include/linux/pps.h b/include/linux/pps.h
index 0194ab0..a9bb1d9 100644
--- a/include/linux/pps.h
+++ b/include/linux/pps.h
@@ -114,11 +114,18 @@ struct pps_fdata {
 	struct pps_ktime timeout;
 };
 
+struct pps_bind_args {
+	int tsformat;	/* format of time stamps */
+	int edge;	/* selected event type */
+	int consumer;	/* selected kernel consumer */
+};
+
 #include <linux/ioctl.h>
 
 #define PPS_GETPARAMS		_IOR('p', 0xa1, struct pps_kparams *)
 #define PPS_SETPARAMS		_IOW('p', 0xa2, struct pps_kparams *)
 #define PPS_GETCAP		_IOR('p', 0xa3, int *)
 #define PPS_FETCH		_IOWR('p', 0xa4, struct pps_fdata *)
+#define PPS_KC_BIND		_IOW('p', 0xa5, struct pps_bind_args *)
 
 #endif /* _PPS_H_ */
diff --git a/include/linux/pps_kernel.h b/include/linux/pps_kernel.h
index 0d36a6f..1251138 100644
--- a/include/linux/pps_kernel.h
+++ b/include/linux/pps_kernel.h
@@ -85,6 +85,12 @@ extern struct idr pps_idr;
 
 extern struct device_attribute pps_attrs[];
 
+/* state variables to bind kernel consumer */
+/* PPS API (RFC 2783): current source and mode for ``kernel consumer'' */
+extern spinlock_t pps_kc_hardpps_lock;
+extern void *pps_kc_hardpps_dev;	/* some unique pointer to device */
+extern int pps_kc_hardpps_mode;		/* mode bits for kernel consumer */
+
 /*
  * Exported functions
  */
-- 
1.6.5

