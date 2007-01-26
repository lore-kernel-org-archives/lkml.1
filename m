Return-Path: <linux-kernel-owner+w=401wt.eu-S1751630AbXAZVjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751630AbXAZVjy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 16:39:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751633AbXAZVjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 16:39:54 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:64376 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbXAZVjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 16:39:53 -0500
Date: Fri, 26 Jan 2007 22:38:32 +0100 (MET)
From: Richard Knutsson <ricknu-0@student.ltu.se>
To: video4linux-list@redhat.com
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
       Richard Knutsson <ricknu-0@student.ltu.se>
Message-Id: <20070126214040.28952.98158.sendpatchset@thinktank.campus.ltu.se>
Subject: [PATCH] drivers/media/video: Convert to generic boolean-values
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---
Compile-tested with "allyes", "allmod" & "allno" on i386.

 saa5246a.c            |   10 +++++-----
 saa5246a.h            |    9 ++-------
 saa5249.c             |   41 ++++++++++++++++++-----------------------
 saa7134/saa7134-i2c.c |   24 ++++++++++++------------
 saa7134/saa7134.h     |    6 ------
 5 files changed, 37 insertions(+), 53 deletions(-)


diff --git a/drivers/media/video/saa5246a.c b/drivers/media/video/saa5246a.c
index 77bb940..28802c3 100644
--- a/drivers/media/video/saa5246a.c
+++ b/drivers/media/video/saa5246a.c
@@ -112,7 +112,7 @@ static int saa5246a_attach(struct i2c_adapter *adap, int addr, int kind)
 	for (pgbuf = 0; pgbuf < NUM_DAUS; pgbuf++)
 	{
 		memset(t->pgbuf[pgbuf], ' ', sizeof(t->pgbuf[0]));
-		t->is_searching[pgbuf] = FALSE;
+		t->is_searching[pgbuf] = false;
 	}
 	vd->priv=t;
 
@@ -199,7 +199,7 @@ static int i2c_senddata(struct saa5246a_device *t, ...)
 
 /* Get count number of bytes from I²C-device at address adr, store them in buf.
  * Start & stop handshaking is done by this routine, ack will be sent after the
- * last byte to inhibit further sending of data. If uaccess is TRUE, data is
+ * last byte to inhibit further sending of data. If uaccess is 'true', data is
  * written to user-space with put_user. Returns -1 if I²C-device didn't send
  * acknowledge, 0 otherwise
  */
@@ -339,7 +339,7 @@ static int saa5246a_request_page(struct saa5246a_device *t,
 		return -EIO;
 	}
 
-	t->is_searching[req->pgbuf] = TRUE;
+	t->is_searching[req->pgbuf] = true;
 	return 0;
 }
 
@@ -453,7 +453,7 @@ static inline int saa5246a_get_status(struct saa5246a_device *t,
 		}
 	}
 	if (!info->hamming && !info->notfound)
-		t->is_searching[dau_no] = FALSE;
+		t->is_searching[dau_no] = false;
 	return 0;
 }
 
@@ -565,7 +565,7 @@ static inline int saa5246a_stop_dau(struct saa5246a_device *t,
 	{
 		return -EIO;
 	}
-	t->is_searching[dau_no] = FALSE;
+	t->is_searching[dau_no] = false;
 	return 0;
 }
 
diff --git a/drivers/media/video/saa5246a.h b/drivers/media/video/saa5246a.h
index 7b91112..64394c0 100644
--- a/drivers/media/video/saa5246a.h
+++ b/drivers/media/video/saa5246a.h
@@ -41,23 +41,18 @@
 #define POS_HEADER_START 7
 #define POS_HEADER_END 31
 
-/* Returns TRUE if the part of the videotext page described with req contains
+/* Returns 'true' if the part of the videotext page described with req contains
    (at least parts of) the time field */
 #define REQ_CONTAINS_TIME(p_req) \
 	((p_req)->start <= POS_TIME_END && \
 	 (p_req)->end   >= POS_TIME_START)
 
-/* Returns TRUE if the part of the videotext page described with req contains
+/* Returns 'true' if the part of the videotext page described with req contains
    (at least parts of) the page header */
 #define REQ_CONTAINS_HEADER(p_req) \
 	((p_req)->start <= POS_HEADER_END && \
 	 (p_req)->end   >= POS_HEADER_START)
 
-#ifndef FALSE
-#define FALSE 0
-#define TRUE 1
-#endif
-
 /*****************************************************************************/
 /* Mode register numbers of the SAA5246A				     */
 /*****************************************************************************/
diff --git a/drivers/media/video/saa5249.c b/drivers/media/video/saa5249.c
index bb3fb43..19f4503 100644
--- a/drivers/media/video/saa5249.c
+++ b/drivers/media/video/saa5249.c
@@ -124,11 +124,6 @@ struct saa5249_device
 
 /* General defines and debugging support */
 
-#ifndef FALSE
-#define FALSE 0
-#define TRUE 1
-#endif
-
 #define RESCHED do { cond_resched(); } while(0)
 
 static struct video_device saa_template;	/* Declared near bottom */
@@ -183,9 +178,9 @@ static int saa5249_attach(struct i2c_adapter *adap, int addr, int kind)
 		memset(t->vdau[pgbuf].sregs, 0, sizeof(t->vdau[0].sregs));
 		memset(t->vdau[pgbuf].laststat, 0, sizeof(t->vdau[0].laststat));
 		t->vdau[pgbuf].expire = 0;
-		t->vdau[pgbuf].clrfound = TRUE;
-		t->vdau[pgbuf].stopped = TRUE;
-		t->is_searching[pgbuf] = FALSE;
+		t->vdau[pgbuf].clrfound = true;
+		t->vdau[pgbuf].stopped = true;
+		t->is_searching[pgbuf] = false;
 	}
 	vd->priv=t;
 
@@ -298,7 +293,7 @@ static int i2c_senddata(struct saa5249_device *t, ...)
 
 /* Get count number of bytes from I²C-device at address adr, store them in buf. Start & stop
  * handshaking is done by this routine, ack will be sent after the last byte to inhibit further
- * sending of data. If uaccess is TRUE, data is written to user-space with put_user.
+ * sending of data. If uaccess is 'true', data is written to user-space with put_user.
  * Returns -1 if I²C-device didn't send acknowledge, 0 otherwise
  */
 
@@ -317,7 +312,7 @@ static int i2c_getdata(struct saa5249_device *t, int count, u8 *buf)
 static int do_saa5249_ioctl(struct inode *inode, struct file *file,
 			    unsigned int cmd, void *arg)
 {
-	static int virtual_mode = FALSE;
+	static int virtual_mode = false;
 	struct video_device *vd = video_devdata(file);
 	struct saa5249_device *t=vd->priv;
 
@@ -340,7 +335,7 @@ static int do_saa5249_ioctl(struct inode *inode, struct file *file,
 			if (req->pgbuf < 0 || req->pgbuf >= NUM_DAUS)
 				return -EINVAL;
 			memset(t->vdau[req->pgbuf].pgbuf, ' ', sizeof(t->vdau[0].pgbuf));
-			t->vdau[req->pgbuf].clrfound = TRUE;
+			t->vdau[req->pgbuf].clrfound = true;
 			return 0;
 		}
 
@@ -350,7 +345,7 @@ static int do_saa5249_ioctl(struct inode *inode, struct file *file,
 
 			if (req->pgbuf < 0 || req->pgbuf >= NUM_DAUS)
 				return -EINVAL;
-			t->vdau[req->pgbuf].clrfound = TRUE;
+			t->vdau[req->pgbuf].clrfound = true;
 			return 0;
 		}
 
@@ -376,9 +371,9 @@ static int do_saa5249_ioctl(struct inode *inode, struct file *file,
 			t->vdau[req->pgbuf].sregs[4] = (req->pagemask & HR_UNIT ? 0x10 : 0) | (req->hour & 0xf);
 			t->vdau[req->pgbuf].sregs[5] = (req->pagemask & MIN_TEN ? 0x10 : 0) | (req->minute / 0x10);
 			t->vdau[req->pgbuf].sregs[6] = (req->pagemask & MIN_UNIT ? 0x10 : 0) | (req->minute & 0xf);
-			t->vdau[req->pgbuf].stopped = FALSE;
-			t->vdau[req->pgbuf].clrfound = TRUE;
-			t->is_searching[req->pgbuf] = TRUE;
+			t->vdau[req->pgbuf].stopped = false;
+			t->vdau[req->pgbuf].clrfound = true;
+			t->is_searching[req->pgbuf] = true;
 			return 0;
 		}
 
@@ -430,7 +425,7 @@ static int do_saa5249_ioctl(struct inode *inode, struct file *file,
 							i2c_getdata(t, 40, t->vdau[req->pgbuf].pgbuf + VTX_PAGESIZE + 23 * 40))
 							return -EIO;
 					}
-					t->vdau[req->pgbuf].clrfound = FALSE;
+					t->vdau[req->pgbuf].clrfound = false;
 					memcpy(t->vdau[req->pgbuf].laststat, infobits, sizeof(infobits));
 				}
 				else
@@ -474,7 +469,7 @@ static int do_saa5249_ioctl(struct inode *inode, struct file *file,
 				return -EFAULT;
 			if (!info.hamming && !info.notfound)
 			{
-				t->is_searching[req->pgbuf] = FALSE;
+				t->is_searching[req->pgbuf] = false;
 			}
 			return 0;
 		}
@@ -530,8 +525,8 @@ static int do_saa5249_ioctl(struct inode *inode, struct file *file,
 
 			if (req->pgbuf < 0 || req->pgbuf >= NUM_DAUS)
 				return -EINVAL;
-			t->vdau[req->pgbuf].stopped = TRUE;
-			t->is_searching[req->pgbuf] = FALSE;
+			t->vdau[req->pgbuf].stopped = true;
+			t->is_searching[req->pgbuf] = false;
 			return 0;
 		}
 
@@ -660,11 +655,11 @@ static int saa5249_open(struct inode *inode, struct file *file)
 		memset(t->vdau[pgbuf].sregs, 0, sizeof(t->vdau[0].sregs));
 		memset(t->vdau[pgbuf].laststat, 0, sizeof(t->vdau[0].laststat));
 		t->vdau[pgbuf].expire = 0;
-		t->vdau[pgbuf].clrfound = TRUE;
-		t->vdau[pgbuf].stopped = TRUE;
-		t->is_searching[pgbuf] = FALSE;
+		t->vdau[pgbuf].clrfound = true;
+		t->vdau[pgbuf].stopped = true;
+		t->is_searching[pgbuf] = false;
 	}
-	t->virtual_mode=FALSE;
+	t->virtual_mode = false;
 	return 0;
 
  fail:
diff --git a/drivers/media/video/saa7134/saa7134-i2c.c b/drivers/media/video/saa7134/saa7134-i2c.c
index 6f9fe86..cce8da6 100644
--- a/drivers/media/video/saa7134/saa7134-i2c.c
+++ b/drivers/media/video/saa7134/saa7134-i2c.c
@@ -120,9 +120,9 @@ static inline int i2c_is_error(enum i2c_status status)
 	case ARB_LOST:
 	case SEQ_ERR:
 	case ST_ERR:
-		return TRUE;
+		return true;
 	default:
-		return FALSE;
+		return false;
 	}
 }
 
@@ -131,9 +131,9 @@ static inline int i2c_is_idle(enum i2c_status status)
 	switch (status) {
 	case IDLE:
 	case DONE_STOP:
-		return TRUE;
+		return true;
 	default:
-		return FALSE;
+		return false;
 	}
 }
 
@@ -141,9 +141,9 @@ static inline int i2c_is_busy(enum i2c_status status)
 {
 	switch (status) {
 	case BUSY:
-		return TRUE;
+		return true;
 	default:
-		return FALSE;
+		return false;
 	}
 }
 
@@ -159,8 +159,8 @@ static int i2c_is_busy_wait(struct saa7134_dev *dev)
 		saa_wait(I2C_WAIT_DELAY);
 	}
 	if (I2C_WAIT_RETRY == count)
-		return FALSE;
-	return TRUE;
+		return false;
+	return true;
 }
 
 static int i2c_reset(struct saa7134_dev *dev)
@@ -171,7 +171,7 @@ static int i2c_reset(struct saa7134_dev *dev)
 	d2printk(KERN_DEBUG "%s: i2c reset\n",dev->name);
 	status = i2c_get_status(dev);
 	if (!i2c_is_error(status))
-		return TRUE;
+		return true;
 	i2c_set_status(dev,status);
 
 	for (count = 0; count < I2C_WAIT_RETRY; count++) {
@@ -181,13 +181,13 @@ static int i2c_reset(struct saa7134_dev *dev)
 		udelay(I2C_WAIT_DELAY);
 	}
 	if (I2C_WAIT_RETRY == count)
-		return FALSE;
+		return false;
 
 	if (!i2c_is_idle(status))
-		return FALSE;
+		return false;
 
 	i2c_set_attr(dev,NOP);
-	return TRUE;
+	return true;
 }
 
 static inline int i2c_send_byte(struct saa7134_dev *dev,
diff --git a/drivers/media/video/saa7134/saa7134.h b/drivers/media/video/saa7134/saa7134.h
index e88ad7b..b331310 100644
--- a/drivers/media/video/saa7134/saa7134.h
+++ b/drivers/media/video/saa7134/saa7134.h
@@ -43,12 +43,6 @@
 #include <sound/pcm.h>
 #include <media/video-buf-dvb.h>
 
-#ifndef TRUE
-# define TRUE (1==1)
-#endif
-#ifndef FALSE
-# define FALSE (1==0)
-#endif
 #define UNSET (-1U)
 
 /* ----------------------------------------------------------- */
