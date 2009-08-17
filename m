Return-Path: <linux-kernel-owner+w=401wt.eu-S1757533AbZHQJJD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533AbZHQJJD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 05:09:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757508AbZHQJJC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 05:09:02 -0400
Received: from mail-px0-f196.google.com ([209.85.216.196]:44081 "EHLO
	mail-px0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757498AbZHQJJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 05:09:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=aRw4YjfyEDyF/ImgGT6AuGOP5aG/K6ROeiSRwKaxJkFQoWqgkonWF9j4Gt4BP7Vr0T
         fkAH0z5eeRWsHlWd6Pn0rNd9tuNnVuGEgT4+xGvkKJSLFbJYsH72CLey9V6HVqjQeSMg
         Gb1R3hi05AVNIqyKI45o4VTvmqV9FfTG/zuoQ=
Date: Mon, 17 Aug 2009 17:11:16 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Guillaume Knispel <gknispel@proformatique.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] poll/select: avoid arithmetic overflow in
	__estimate_accuracy()
Message-ID: <20090817091116.GD5868@cr0.nay.redhat.com>
References: <20090816222921.26c92ccd@xilun.lan.proformatique.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090816222921.26c92ccd@xilun.lan.proformatique.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 16, 2009 at 10:29:21PM +0200, Guillaume Knispel wrote:
>__estimate_accuracy() was prone to integer overflow, for example
>if *tv == {2147, 483648000} on a 32 bit computer (or even for delays
>as small as {429, 500000000} if the task is niced).
>
>Because the result was already forced between 0 and 100ms, the effect
>of the overflow was not too problematic, but the use of the hrtimer
>range feature was not optimal in overflow cases.
>
>This patch ensures that there can not be an integer overflow in this
>function.
>
>Signed-off-by: Guillaume Knispel <gknispel@proformatique.com>
>---
> fs/select.c |   14 ++++++++++----
> 1 files changed, 10 insertions(+), 4 deletions(-)
>
>diff --git a/fs/select.c b/fs/select.c
>index 8084834..a201fc3 100644
>--- a/fs/select.c
>+++ b/fs/select.c
>@@ -41,22 +41,28 @@
>  * better solutions..
>  */
> 
>+#define MAX_SLACK	(100 * NSEC_PER_MSEC)
>+
> static long __estimate_accuracy(struct timespec *tv)
> {
> 	long slack;
> 	int divfactor = 1000;
> 
>+	if (tv->tv_sec < 0)
>+		return 0;
>+
> 	if (task_nice(current) > 0)
> 		divfactor = divfactor / 5;
> 
>+	if (tv->tv_sec > MAX_SLACK / (NSEC_PER_SEC/divfactor))
>+		return MAX_SLACK;
>+


Yes? Isn't MAX_SLACK also too big for 'long' on 32bit machine?

Try:

% printf "%d\n" "100*1000000000 > 0x7fffffff"
1

Am I missing something here?


Thanks.


> 	slack = tv->tv_nsec / divfactor;
> 	slack += tv->tv_sec * (NSEC_PER_SEC/divfactor);
> 
>-	if (slack > 100 * NSEC_PER_MSEC)
>-		slack =  100 * NSEC_PER_MSEC;
>+	if (slack > MAX_SLACK)
>+		return MAX_SLACK;
> 
>-	if (slack < 0)
>-		slack = 0;
> 	return slack;
> }
> 
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
