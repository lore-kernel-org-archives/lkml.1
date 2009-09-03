Return-Path: <linux-kernel-owner+w=401wt.eu-S1755038AbZICLar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038AbZICLar (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 07:30:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755012AbZICLar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 07:30:47 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:20789 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754958AbZICLaq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 07:30:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XrHABknVX7/17CSM5APT133ZFLb4n1gHP9sf8PdAXHnCMjY3hC078Jepsmt/NuqR87
         Nnl+PWCzniMsfMYGvsf4mF5gVMr1vFrMGe4bn8ZCu3ge6jF4B9dhI0folml9eRt6nV6w
         DuEe6jFWhXSuc/MSW0eYgwiVe3u3WW3i1Tgp4=
MIME-Version: 1.0
In-Reply-To: <4A9F9F64.5080305@aimvalley.nl>
References: <4A9F9F64.5080305@aimvalley.nl>
Date: Thu, 3 Sep 2009 13:22:57 +0200
Message-ID: <4e5e476b0909030422m745af2e6mb8dd0148c2341e9d@mail.gmail.com>
Subject: Re: PROBLEM: CONFIG_NO_HZ could cause software timeouts
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Norbert van Bolhuis <nvbolhuis@aimvalley.nl>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is XIP enabled? It seems that the xip_udelay is not very accurate, and
may be the cause of what you are seeing.

On Thu, Sep 3, 2009 at 12:50 PM, Norbert van
Bolhuis<nvbolhuis@aimvalley.nl> wrote:
>
> The problem occurs when e.g. drivers use time_after(jiffes, timeout).
>
> CONFIG_NO_HZ could make jiffies advance by more than 1.
> This is done by:
> tick_nohz_update_jiffies->tick_do_update_jiffies64->do_timer
>
> If drivers use a timeout value of jiffies+1,
> "time_after(jiffies, timeout)" will be true after 1 interrupt
> (given that it advances jiffies by at least 2).
>
> This is exactly what happens in cfi_cmdset_0002.c:do_write_buffer
> for our case (Powerpc MPC8313, linux-2.6.28, CONFIG_HZ=250, CONFIG_NO_HZ=y).
>
> do_write_buffer does the following:
>  unsigned long uWriteTimeout = ( HZ / 1000 ) + 1;
>  ...
>  timeo = jiffies + uWriteTimeout;
>  ...
>  for (;;) {
>  ...
>  if (time_after(jiffies, timeo) && !chip_ready(map, adr))
>   break;
>  if (chip_ready(map, adr)) {
>   xip_enable(map, chip, adr);
>   goto op_done;
>  }
>  UDELAY(map, chip, adr, 1);
>  }
>  /* software timeout */
>  ret = -EIO;
> opdone:
>  ...
>
> I've seen a few software timeouts after the for-loop
> looped only 13 times (= 13 us delay, i.s.o. the expected 1 ms). Typically
> our NOR flash (S29GL01GP) may need upto ~ 200 us to be ready.
>
> disabling CONFIG_NO_HZ fixes the problem.
> replacing time_after by a for-loop counter to loop max 1000 times
> also fixes the problem.
>
> the latest kernel seems to have the same problem.
>
> do I miss something here or is this a known problem of CONFIG_NO_HZ ?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
The self-confidence of a warrior is not the self-confidence of the average
man. The average man seeks certainty in the eyes of the onlooker and calls
that self-confidence. The warrior seeks impeccability in his own eyes and
calls that humbleness.
                               Tales of Power - C. Castaneda
