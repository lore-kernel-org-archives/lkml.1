Return-Path: <linux-kernel-owner+w=401wt.eu-S1759168AbXI0T2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759168AbXI0T2m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 15:28:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757237AbXI0T2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 15:28:35 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:45835 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757127AbXI0T2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 15:28:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VhlsA9HCXABCxznO6Y/4H4XmTyoS7cUWpfrX7XGZKkq1dc4iw+Vf+ZRPXBf6zWYX8srjsNyGB+RmYZVLErz0giqmY3TYm+JHdx2fFRn6wChAGfwl4SQ+Z375lzdjEsZz8HiNQ3JEdvzMrIrO+Wlc9riv5dDpxz/qauABz+12ddg=
Message-ID: <a372714f0709271228r7de8a4a0p4c5d75e939513f08@mail.gmail.com>
Date: Thu, 27 Sep 2007 12:28:31 -0700
From: "Brett Warden" <brett.warden@gmail.com>
To: "Ray Lee" <ray-lk@madrabbit.org>, "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: [PATCH] bw-qcam: use data_reverse instead of manually poking the control register
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
In-Reply-To: <a372714f0709261443p25e99e4at39f4a09c850fb621@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a372714f0709261212hec0c61ofc5dd6d127352402@mail.gmail.com>
	 <2c0942db0709261243h1267140br70796c7fcfb165e3@mail.gmail.com>
	 <a372714f0709261306q714100e3t643b31d8f194de2e@mail.gmail.com>
	 <2c0942db0709261400l10ef6c3ft2d73d8b2ada4a04@mail.gmail.com>
	 <a372714f0709261443p25e99e4at39f4a09c850fb621@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes use of parport_write_control() to match the newer interface that
requires explicit parport_data_reverse() and parport_data_forward()
calls. This eliminates the following error message and restores the
original intended behavior:

parport0 (bw-qcam): use data_reverse for this!

Also increases threshold in qc_detect() from 300 to 400, as my camera
often results in a count of approx 330. Added a kernel error message
to indicate detection failure.

Signed-off-by: Brett T. Warden <brett.warden@gmail.com>

---

Thanks Ray and Randy for your comments, and for pointing out that I
needed to reset the port to forward mode!

diff --git a/drivers/media/video/bw-qcam.c b/drivers/media/video/bw-qcam.c
index 7d47cbe..961e377 100644
--- a/drivers/media/video/bw-qcam.c
+++ b/drivers/media/video/bw-qcam.c
@@ -104,6 +104,17 @@ static inline void write_lpdata(struct
qcam_device *q, int d)

 static inline void write_lpcontrol(struct qcam_device *q, int d)
 {
+       if(0x20 & d) {
+               /* Set bidirectional mode to reverse (data in) */
+               parport_data_reverse(q->pport);
+       } else {
+               /* Set bidirectional mode to forward (data out) */
+               parport_data_forward(q->pport);
+       }
+
+       /* Now issue the regular port command, but strip out the
+        * direction flag */
+       d &= ~0x20;
        parport_write_control(q->pport, d);
 }

@@ -344,10 +355,13 @@ static int qc_detect(struct qcam_device *q)
        /* Be (even more) liberal in what you accept...  */

 /*     if (count > 30 && count < 200) */
-       if (count > 20 && count < 300)
+       if (count > 20 && count < 400)
+       {
                return 1;       /* found */
-       else
+       } else {
+               printk(KERN_ERR "No Quickcam found on port %s\n",
q->pport->name);
                return 0;       /* not found */
+       }
 }





-- 
Brett Warden
