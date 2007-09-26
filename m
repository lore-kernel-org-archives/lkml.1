Return-Path: <linux-kernel-owner+w=401wt.eu-S1762207AbXIZVAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762207AbXIZVAy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 17:00:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760718AbXIZVAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 17:00:44 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:19443 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758552AbXIZVAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 17:00:43 -0400
Date: Wed, 26 Sep 2007 14:00:12 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Brett Warden" <brett.warden@gmail.com>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] bw-qcam: use data_reverse instead of manually poking
 the control register
Message-Id: <20070926140012.ae093b63.randy.dunlap@oracle.com>
In-Reply-To: <a372714f0709261212hec0c61ofc5dd6d127352402@mail.gmail.com>
References: <a372714f0709261212hec0c61ofc5dd6d127352402@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Sep 2007 12:12:50 -0700 Brett Warden wrote:

> Appeases the warning "parport0 (bw-qcam): use data_reverse for this!"
> 
> Signed-off-by: Brett T. Warden <brett.warden@gmail.com>
> 

Where does the warning come from?  (what software produces it?)


> ---
> 
> It seems to work fine with my Quickcam under 2.6.22.
> 
> diff --git a/drivers/media/video/bw-qcam.c b/drivers/media/video/bw-qcam.c
> index 7d47cbe..01e47ed 100644
> --- a/drivers/media/video/bw-qcam.c
> +++ b/drivers/media/video/bw-qcam.c
> @@ -107,6 +107,11 @@ static inline void write_lpcontrol(struct
> qcam_device *q, int d)
>         parport_write_control(q->pport, d);
>  }
> 
> +static inline void reverse_port(struct qcam_device *q)
> +{
> +       parport_data_reverse(q->pport);
> +}
> +
>  static int qc_waithand(struct qcam_device *q, int val);
>  static int qc_command(struct qcam_device *q, int command);
>  static int qc_readparam(struct qcam_device *q);
> @@ -369,7 +374,11 @@ static void qc_reset(struct qcam_device *q)
>                         break;
> 
>                 case QC_ANY:
> -                       write_lpcontrol(q, 0x20);
> +                       /*
> +                        * Replaced with reverse_port
> +                        * write_lpcontrol(q, 0x20);
> +                        */
> +                       reverse_port(q);
>                         write_lpdata(q, 0x75);
> 
>                         if (read_lpdata(q) != 0x75) {
> @@ -512,10 +521,12 @@ static inline int qc_readbytes(struct
> qcam_device *q, char buffer[])
>         switch (q->port_mode & QC_MODE_MASK)
>         {
>                 case QC_BIDIR:          /* Bi-directional Port */
> -                       write_lpcontrol(q, 0x26);
> +                       reverse_port(q);
> +                       write_lpcontrol(q, 0x6);
>                         lo = (qc_waithand2(q, 1) >> 1);
>                         hi = (read_lpstatus(q) >> 3) & 0x1f;
> -                       write_lpcontrol(q, 0x2e);
> +                       reverse_port(q);
> +                       write_lpcontrol(q, 0xe);
>                         lo2 = (qc_waithand2(q, 0) >> 1);
>                         hi2 = (read_lpstatus(q) >> 3) & 0x1f;
>                         switch (q->bpp)
> @@ -613,10 +624,13 @@ static long qc_capture(struct qcam_device * q,
> char __user *buf, unsigned long l
> 
>         if ((q->port_mode & QC_MODE_MASK) == QC_BIDIR)
>         {
> -               write_lpcontrol(q, 0x2e);       /* turn port around */
> -               write_lpcontrol(q, 0x26);
> +               reverse_port(q);                        /* turn port around */
> +               write_lpcontrol(q, 0xe);
> +               reverse_port(q);
> +               write_lpcontrol(q, 0x6);
>                 (void) qc_waithand(q, 1);
> -               write_lpcontrol(q, 0x2e);
> +               reverse_port(q);
> +               write_lpcontrol(q, 0xe);
>                 (void) qc_waithand(q, 0);
>         }
> 
> 
> 
> -- 

---
~Randy
Phaedrus says that Quality is about caring.
