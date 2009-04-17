Return-Path: <linux-kernel-owner+w=401wt.eu-S1760671AbZDQLZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760671AbZDQLZT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 07:25:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932078AbZDQLYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 07:24:48 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55878 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760813AbZDQLYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 07:24:47 -0400
Message-ID: <49E866E7.7070507@jp.fujitsu.com>
Date: Fri, 17 Apr 2009 20:24:23 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Subject: Re: [PATCH] [28/28] x86: MCE: Implement new status bits
References: <20090407507.636692542@firstfloor.org> <20090407150811.DD6DA1D046E@basil.firstfloor.org>
In-Reply-To: <20090407150811.DD6DA1D046E@basil.firstfloor.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>  static struct severity {
>  	u64 mask;
>  	u64 result;
>  	unsigned char sev;
>  	unsigned char mcgmask;
>  	unsigned char mcgres;
> +	unsigned char ser;
> +	unsigned char context;
>  	char *msg;
>  } severities[] = {
> +#define KERNEL .context = IN_KERNEL
> +#define USER .context = IN_USER
> +#define SER .ser = 1
> +#define NOSER .ser = -1

ser is unsigned or signed?

>  int mce_severity(struct mce *a, int tolerant, char **msg)
>  {
>  	struct severity *s;
> @@ -51,11 +101,14 @@
>  			continue;
>  		if ((a->mcgstatus & s->mcgmask) != s->mcgres)
>  			continue;
> -		if (s->sev > MCE_NO_SEVERITY && (a->status & MCI_STATUS_UC) &&
> -			tolerant < 1)
> -			return MCE_PANIC_SEVERITY;
> +		if ((s->ser == 1 && !mce_ser) || (s->ser == -1 && mce_ser))
> +			continue;
> +		if (s->context && error_context(a) != s->context)
> +			continue;
>  		if (msg)
>  			*msg = s->msg;
> +		if (s->context == IN_KERNEL && panic_on_oops)
> +			return MCE_PANIC_SEVERITY;
>  		return s->sev;
>  	}
>  }

Where did you throw away the statements for "tolerant < 1"?


Thanks,
H.Seto

