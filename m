Return-Path: <linux-kernel-owner+w=401wt.eu-S1755166AbYKGTTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166AbYKGTTZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 14:19:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751414AbYKGTTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 14:19:16 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49890 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751474AbYKGTTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 14:19:15 -0500
Date: Fri, 7 Nov 2008 11:18:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: djwong@us.ibm.com, khali@linux-fr.org, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: [PATCH 1/5] adt7462: New hwmon driver
Message-Id: <20081107111808.851dad3b.akpm@linux-foundation.org>
In-Reply-To: <20081107185626.13022.59407.stgit@elm3a70.beaverton.ibm.com>
References: <20081107185621.13022.61885.stgit@elm3a70.beaverton.ibm.com>
	<20081107185626.13022.59407.stgit@elm3a70.beaverton.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Nov 2008 10:56:26 -0800
"Darrick J. Wong" <djwong@us.ibm.com> wrote:

> 
> New driver to play with.  As Jean mentioned a couple of years ago, this
> chip is a beast with odd combinations of 8 fans, 4 temperatures, and 
> 13 voltage sensors.  This driver has been tested on an IntelliStation
> Z30.
> 
> ...
>
> + * 9. Vbatt/FSB_Vtt (pin 26)
> + * A. +3.3V/+1.2V1 (pin 25)
> + * B. Vccp2/+2.5V/+1.8V/+1.5V (pin 24)
> + * C. +1.5V ICH (only if BOTH pin 28/29 are set to +1.5V)
> + * D. +1.5V 3GPIO (only if BOTH pin 28/29 are set to +1.5V)
> + *
> + * Each of these 13 has a factor to convert raw to voltage.  Even better,
> + * the pins can be connected to other sensors (tach/gpio/hot/etc), which
> + * makes the bookkeeping tricky.
> + *
> + * Some, but not all, of these voltages have low/high limits.
> + */
> +#define ADT7462_VOLT_COUNT	12
> +
> +#define ADT7462_VENDOR		0x41
> +#define ADT7462_DEVICE		0x62
> +/* datasheet only mentions a revision 4 */
> +#define ADT7462_REVISION	0x04
> +
> +/* How often do we reread sensors values? (In jiffies) */
> +#define SENSOR_REFRESH_INTERVAL	(2 * HZ)
> +
> +/* How often do we reread sensor limit values? (In jiffies) */
> +#define LIMIT_REFRESH_INTERVAL	(60 * HZ)
> +
> +/* datasheet says to divide this number by the fan reading to get fan rpm */
> +#define FAN_PERIOD_TO_RPM(x)	((90000 * 60) / (x))
> +#define FAN_RPM_TO_PERIOD	FAN_PERIOD_TO_RPM
> +#define FAN_PERIOD_INVALID	65535
> +#define FAN_DATA_VALID(x)	((x) && (x) != FAN_PERIOD_INVALID)

A macro which evaluates its args more than once is a bit naughty.

> +#define MASK_AND_SHIFT(value, prefix)	\
> +	(((value) & prefix##_MASK) >> prefix##_SHIFT)
> +
> +#define ROUND_DIV(x, divisor)  (((x) + ((divisor) / 2)) / (divisor))

hm, ok.

That evaluates `divisor' twice, too.

argh.  ALIGN() has the same problem.  Something like this...

--- a/include/linux/kernel.h~a
+++ a/include/linux/kernel.h
@@ -39,7 +39,12 @@ extern const char linux_proc_banner[];
 #define STACK_MAGIC	0xdeadbeef
 
 #define ALIGN(x,a)		__ALIGN_MASK(x,(typeof(x))(a)-1)
-#define __ALIGN_MASK(x,mask)	(((x)+(mask))&~(mask))
+
+#define __ALIGN_MASK(x,mask)	({		\
+	typeof(mask) __mask = mask;		\
+	(((x) + __mask) & ~__mask);		\
+})
+
 #define PTR_ALIGN(p, a)		((typeof(p))ALIGN((unsigned long)(p), (a)))
 #define IS_ALIGNED(x, a)		(((x) & ((typeof(x))(a) - 1)) == 0)
 
_

Looks good to my untrained eye.  Quite a large driver.
