Return-Path: <linux-kernel-owner+w=401wt.eu-S1759877AbZC3VMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759877AbZC3VMh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 17:12:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757979AbZC3VMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 17:12:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41437 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756914AbZC3VML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 17:12:11 -0400
Date: Mon, 30 Mar 2009 14:06:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: paul.gortmaker@windriver.com, clemens@ladisch.de,
       linux-kernel@vger.kernel.org, robert.picco@hp.com,
       venkatesh.pallipadi@intel.com, vojtech@suse.cz, mingo@redhat.com
Subject: Re: [Patch] Fix the possibility of insane return value of
 hpet_calibrate() against SMI. (take 2)
Message-Id: <20090330140659.66ccbfe9.akpm@linux-foundation.org>
In-Reply-To: <20090318113948.7BAD.E1E9C6FF@jp.fujitsu.com>
References: <49BFA1D7.8020302@windriver.com>
	<20090318094346.7BA9.E1E9C6FF@jp.fujitsu.com>
	<20090318113948.7BAD.E1E9C6FF@jp.fujitsu.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Mar 2009 11:47:04 +0900
Yasunori Goto <y-goto@jp.fujitsu.com> wrote:

> hpet_calibrate() has a possibility of miss-calibration due to SMI.
> If SMI interrupts in the while loop of calibration, then return value
> will be big. This change calibrates until stabilizing by the return
> value with a small value.
> 
> 
> Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
> 
> 
> ---
>  drivers/char/hpet.c |   21 ++++++++++++++++++++-
>  1 file changed, 20 insertions(+), 1 deletion(-)
> 
> Index: hpet_test/drivers/char/hpet.c
> ===================================================================
> --- hpet_test.orig/drivers/char/hpet.c	2009-03-12 15:47:45.000000000 +0900
> +++ hpet_test/drivers/char/hpet.c	2009-03-18 11:12:42.000000000 +0900
> @@ -713,7 +713,7 @@
>   */
>  #define	TICK_CALIBRATE	(1000UL)
>  
> -static unsigned long hpet_calibrate(struct hpets *hpetp)
> +static unsigned long __hpet_calibrate(struct hpets *hpetp)
>  {
>  	struct hpet_timer __iomem *timer = NULL;
>  	unsigned long t, m, count, i, flags, start;
> @@ -750,6 +750,25 @@
>  	return (m - start) / i;
>  }
>  
> +static unsigned long hpet_calibrate(struct hpets *hpetp)
> +{
> +	unsigned long ret = ~0UL, tmp;
> +
> +	/*
> +	 * Try to calibrate until return value becomes stable small value.
> +	 * If SMI interruption occurs in calibration loop, the return value
> +	 * will be big. This avoids its impact.
> +	 */
> +	do {
> +		tmp = __hpet_calibrate(hpetp);
> +		if (ret <= tmp)
> +			break;
> +		ret = tmp;
> +	} while (1);
> +
> +	return ret;
> +}

Call me paranoid, but I'd like to see a maximum retry count here and an
error message-and-continue if it is exceeded.  To prevent mysterious
boot-time lockups from misbehaving hpets, perhaps?

Also, style nit - I find

	for ( ; ; ) {
		...
	}

to be more readable than

	do {
		...
	} while (1);

and I believe the former is more common.


And

	unsigned long ret = -1;

has the same effect as

	unsigned long ret = ~0UL;

but is more maintainable - it doesn't subtly break if someone changes
the type of `ret'.  (This is a bit of an ugly C trick).



