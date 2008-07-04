Return-Path: <linux-kernel-owner+w=401wt.eu-S1757932AbYGDNMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757932AbYGDNMx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 09:12:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753162AbYGDNMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 09:12:46 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:3550 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978AbYGDNMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 09:12:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=YSA3TeX5mA1Ed1gmEOyFsWOZODiI2jYHjjIFDjUYVzV/hHTH86Z272O3KRGma8h8gV
         xrcrpykYtv4fW+UXec6/YgSyxaFf5dn3yb7oXQ6HjQSdFA3n454KyTomZMX3JC4CQkPi
         ucZMRQ4Qz6s1be16U+UBy3fvE+EVRsyWrOuns=
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>
To: Vitaly Mayatskikh <v.mayatskih@gmail.com>
Cc: linux-kernel@vger.kernel.org, Anton Blanchard <anton@au.ibm.com>,
       Paul Mackerras <paulus@au.ibm.com>
Subject: Re: [PATCH] PowerPC: honor O_NONBLOCK flag for rtas error_log
References: <m3iqvlssrw.fsf@gravicappa.englab.brq.redhat.com>
Date: Fri, 04 Jul 2008 15:12:36 +0200
In-Reply-To: <m3iqvlssrw.fsf@gravicappa.englab.brq.redhat.com> (Vitaly
	Mayatskikh's message of "Fri, 04 Jul 2008 15:06:27 +0200")
Message-ID: <m3ej69sshn.fsf@gravicappa.englab.brq.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vitaly Mayatskikh <v.mayatskih@gmail.com> writes:

> rtas_log_read() currently doesn't count O_NONBLOCK flag. This sample
> code will block on read:
>
>   fd = open ("/proc/ppc64/rtas/error_log", O_RDONLY | O_NONBLOCK);
>   while (1) {
>     err =read (fd, buf, 4096);
>     printf("err = %d, errno = %d (%s)\n", err, errno, strerror(errno));
>     sleep(1);
>   }
>
> With patched kernel it produces such (correct) output:
>
> err = 2052, errno = 0 (Success)
> err = -1, errno = 11 (Resource temporarily unavailable)
> err = -1, errno = 11 (Resource temporarily unavailable)
> err = -1, errno = 11 (Resource temporarily unavailable)
> err = -1, errno = 11 (Resource temporarily unavailable)

Sorry, wrong patch :(

Signed-off-by: Vitaly Mayatskikh <v.mayatskih@gmail.com>

diff --git a/arch/powerpc/platforms/pseries/rtasd.c b/arch/powerpc/platforms/pseries/rtasd.c
index 7d3e2b0..3343211 100644
--- a/arch/powerpc/platforms/pseries/rtasd.c
+++ b/arch/powerpc/platforms/pseries/rtasd.c
@@ -291,21 +291,24 @@ static ssize_t rtas_log_read(struct file * file, char __user * buf,
 	if (!access_ok(VERIFY_WRITE, buf, count))
 		return -EFAULT;
 
-	tmp = kmalloc(count, GFP_KERNEL);
-	if (!tmp)
-		return -ENOMEM;
-
-
 	spin_lock_irqsave(&rtasd_log_lock, s);
 	/* if it's 0, then we know we got the last one (the one in NVRAM) */
-	if (rtas_log_size == 0 && logging_enabled)
+	if (rtas_log_size == 0 && logging_enabled) {
 		nvram_clear_error_log();
+		if (file->f_flags & O_NONBLOCK) {
+			spin_unlock_irqrestore(&rtasd_log_lock, s);
+			return -EAGAIN;
+		}
+	}
 	spin_unlock_irqrestore(&rtasd_log_lock, s);
 
-
 	error = wait_event_interruptible(rtas_log_wait, rtas_log_size);
 	if (error)
-		goto out;
+		return error;
+
+	tmp = kmalloc(count, GFP_KERNEL);
+	if (!tmp)
+		return -ENOMEM;
 
 	spin_lock_irqsave(&rtasd_log_lock, s);
 	offset = rtas_error_log_buffer_max * (rtas_log_start & LOG_NUMBER_MASK);

-- 
wbr, Vitaly
