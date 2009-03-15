Return-Path: <linux-kernel-owner+w=401wt.eu-S1758065AbZCOT5L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758065AbZCOT5L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 15:57:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756293AbZCOT4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 15:56:55 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:58638 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756133AbZCOT4y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 15:56:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Du1JVoEpAcuRnLUrLfmt3Ox3vm3oshvnw19fJkzEpOXOXGSqcAbGrmHf97+8CLjgtT
         QDcXY1ScoT4voocA/9AtgnJoxp+1rL+ZR3TcfCsuegxukTN+r3OvuU51sWaiyShugx9a
         hz+sRJ+g+LUFyVe8hEFibqQFxCnumNV7pracQ=
MIME-Version: 1.0
In-Reply-To: <20090313134846.24B6.E1E9C6FF@jp.fujitsu.com>
References: <20090313134846.24B6.E1E9C6FF@jp.fujitsu.com>
Date: Sun, 15 Mar 2009 15:56:52 -0400
X-Google-Sender-Auth: 8d9ef862a83c57c6
Message-ID: <7d1d9c250903151256l36586764wfbd5e2578a45663c@mail.gmail.com>
Subject: Re: [Patch] Fix the possibility of insane return value of 
	hpet_calibrate() against SMI.
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: clemens@ladisch.de, Linux Kernel ML <linux-kernel@vger.kernel.org>,
       robert.picco@hp.com, venkatesh.pallipadi@intel.com, vojtech@suse.cz,
       mingo@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 13, 2009 at 1:00 AM, Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
> Hello.
>
> I think there is a possibility that HPET driver will return
> insane value due to a SMI interruption (or switching guests by hypervisor).
> I found it by reviewing, and I would like to fix it.
>
> Current HPET driver calibrates the adjustment value
> by calculation the elapse time in CPU busy loop.
> However this way is too dangerous against SMI interruption.
>
> Here is the calibration code in hpet_calibrate()
>
>  701 static unsigned long hpet_calibrate(struct hpets *hpetp)
>             :
>             :
>  728         do {
>  729                 m = read_counter(&hpet->hpet_mc);
>  730                 write_counter(t + m + hpetp->hp_delta, &timer->hpet_compare);
>  731         } while (i++, (m - start) < count);
>  732
>  733         local_irq_restore(flags);
>  734
>  735         return (m - start) / i;
>
> If SMI interruption occurs between 728 to 731, then return value will be
> bigger value than correct one. (SMI is not able to be controlled by OS.)
>
>
> This patch is a simple solution to fix it.
> hpet_calibrate() is called 5 times, and one of them is expected as
> correct value.

I've no sense of feel for how long each calibration run would take.
Would doing it 5 times show up as a significant increase in the boot
time for those that care about boot time being as quick as possible?

Paul.

>
> Thanks.
>
>
> ---
>
> hpet_calibrate() has a possibility of miss-calibration due to SMI.
> If SMI interrupts in the while loop of calibration, then return value
> will be big. This changes it tries 5 times and get minimum value as
> correct value.
>
> Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
>
> ---
>
> Index: hpet_test/drivers/char/hpet.c
> ===================================================================
> --- hpet_test.orig/drivers/char/hpet.c  2008-12-04 16:24:02.000000000 +0900
> +++ hpet_test/drivers/char/hpet.c       2008-12-04 16:34:59.000000000 +0900
> @@ -713,7 +713,7 @@
>  */
>  #define        TICK_CALIBRATE  (1000UL)
>
> -static unsigned long hpet_calibrate(struct hpets *hpetp)
> +static unsigned long __hpet_calibrate(struct hpets *hpetp)
>  {
>        struct hpet_timer __iomem *timer = NULL;
>        unsigned long t, m, count, i, flags, start;
> @@ -750,6 +750,17 @@
>        return (m - start) / i;
>  }
>
> +static unsigned long hpet_calibrate(struct hpets *hpetp)
> +{
> +       unsigned long ret = ~0UL, i;
> +
> +       /* Try 5 times to remove impact of SMI.*/
> +       for (i = 0; i < 5; i++)
> +               ret = min(ret, __hpet_calibrate(hpetp));
> +
> +       return ret;
> +}
> +
>  int hpet_alloc(struct hpet_data *hdp)
>  {
>        u64 cap, mcfg;
>
> --
> Yasunori Goto
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
