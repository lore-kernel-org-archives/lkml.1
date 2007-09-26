Return-Path: <linux-kernel-owner+w=401wt.eu-S1759238AbXIZUHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759238AbXIZUHT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 16:07:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753884AbXIZUHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 16:07:06 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:34075 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734AbXIZUHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 16:07:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=V1kVmT0FmN8jgfFLySlrWTdwPTfvsCfD/iFfw/X4NLP7z5Vsn0N49pb2O0AWshohmaO5tvuu/Mvr6cRqwHSFjqRxL5Xd/gfs5mKZyuuhw0sCvD7oiJkLRCM9CLdBFmMyLaeBCzDcVu0TkaWp7ADm9Lk2WcMMtN1O9gb3/CEvSdM=
Message-ID: <a372714f0709261306q714100e3t643b31d8f194de2e@mail.gmail.com>
Date: Wed, 26 Sep 2007 13:06:59 -0700
From: "Brett Warden" <brett.warden@gmail.com>
To: "Ray Lee" <ray-lk@madrabbit.org>
Subject: Re: [PATCH] bw-qcam: use data_reverse instead of manually poking the control register
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
In-Reply-To: <2c0942db0709261243h1267140br70796c7fcfb165e3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a372714f0709261212hec0c61ofc5dd6d127352402@mail.gmail.com>
	 <2c0942db0709261243h1267140br70796c7fcfb165e3@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/26/07, Ray Lee <ray-lk@madrabbit.org> wrote:

> Just as an aside, if you've tested this and it works, then there's no
> point to keep the write_lpcontrol even as a comment. Kill those four
> lines, and if someone's interested in what happened they'll just look
> at the file history.

Point taken, thanks for the feedback.

---

diff --git a/drivers/media/video/bw-qcam.c b/drivers/media/video/bw-qcam.c
index 7d47cbe..0ba92e3 100644
--- a/drivers/media/video/bw-qcam.c
+++ b/drivers/media/video/bw-qcam.c
@@ -107,6 +107,11 @@ static inline void write_lpcontrol(struct
qcam_device *q, int d)
        parport_write_control(q->pport, d);
 }

+static inline void reverse_port(struct qcam_device *q)
+{
+       parport_data_reverse(q->pport);
+}
+
 static int qc_waithand(struct qcam_device *q, int val);
 static int qc_command(struct qcam_device *q, int command);
 static int qc_readparam(struct qcam_device *q);
@@ -369,7 +374,7 @@ static void qc_reset(struct qcam_device *q)
                        break;

                case QC_ANY:
-                       write_lpcontrol(q, 0x20);
+                       reverse_port(q);
                        write_lpdata(q, 0x75);

                        if (read_lpdata(q) != 0x75) {
@@ -512,10 +517,12 @@ static inline int qc_readbytes(struct
qcam_device *q, char buffer[])
        switch (q->port_mode & QC_MODE_MASK)
        {
                case QC_BIDIR:          /* Bi-directional Port */
-                       write_lpcontrol(q, 0x26);
+                       reverse_port(q);
+                       write_lpcontrol(q, 0x6);
                        lo = (qc_waithand2(q, 1) >> 1);
                        hi = (read_lpstatus(q) >> 3) & 0x1f;
-                       write_lpcontrol(q, 0x2e);
+                       reverse_port(q);
+                       write_lpcontrol(q, 0xe);
                        lo2 = (qc_waithand2(q, 0) >> 1);
                        hi2 = (read_lpstatus(q) >> 3) & 0x1f;
                        switch (q->bpp)
@@ -613,10 +620,13 @@ static long qc_capture(struct qcam_device * q,
char __user *buf, unsigned long l

        if ((q->port_mode & QC_MODE_MASK) == QC_BIDIR)
        {
-               write_lpcontrol(q, 0x2e);       /* turn port around */
-               write_lpcontrol(q, 0x26);
+               reverse_port(q);                        /* turn port around */
+               write_lpcontrol(q, 0xe);
+               reverse_port(q);
+               write_lpcontrol(q, 0x6);
                (void) qc_waithand(q, 1);
-               write_lpcontrol(q, 0x2e);
+               reverse_port(q);
+               write_lpcontrol(q, 0xe);
                (void) qc_waithand(q, 0);
        }




-- 
Brett Warden
