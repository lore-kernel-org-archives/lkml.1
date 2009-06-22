Return-Path: <linux-kernel-owner+w=401wt.eu-S1752886AbZFVHTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886AbZFVHTy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 03:19:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751416AbZFVHTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 03:19:47 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:43655 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbZFVHTq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 03:19:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YbsJWe/TDilWDj+/NxCr331mg+08GT0jwJ1H2VSwD0PZ9Q5g7X1CkmR74b9M/FEqHn
         dD10Vd3Yzw/2LbvYsmXLod/0MuGHPzUITkXDQ6u2WEj1mo+0kTbeeUYM4wsEXx5d4ect
         HIzCEYr3lVjb2e5PlJvlRs94ECgzjNTiUV780=
MIME-Version: 1.0
In-Reply-To: <4A3EE668.5090400@jp.fujitsu.com>
References: <8db1092f0906211002y2b391212ve2902fc3a6517586@mail.gmail.com>
	 <4A3E7F38.7030300@linux.intel.com>
	 <8db1092f0906211313x73ac9340n9af5775b56cfd189@mail.gmail.com>
	 <4A3EE668.5090400@jp.fujitsu.com>
Date: Mon, 22 Jun 2009 09:19:47 +0200
Message-ID: <8db1092f0906220019x1560c26dsd5a6daa3ea612ec@mail.gmail.com>
Subject: Re: 2.6.30-git(16 and 17) system hangs after resume from suspend to 
	disk, mce related?
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Andi Kleen <ak@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/22 Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>:
>
> I see.  At least this warning will be cleared by following patch.
>  WARN_ON(smp_processor_id() != data);
>
> But I'm not sure whether this can cause system hangs or not.
>
> Thanks,
> H.Seto
>
> ===
>
> [PATCH] x86, mce: percpu mcheck_timer should be pinned
>

>
> If CONFIG_NO_HZ + CONFIG_SMP, timer added via add_timer() might
> be migrated on other cpu.  Use add_timer_on() instead.
>
> Reported-by: Maciej Rutecki <maciej.rutecki@gmail.com>
> Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> CC: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/mcheck/mce.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index 7da8fec..8e1794a 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -1117,7 +1117,7 @@ static void mcheck_timer(unsigned long data)
>                *n = min(*n*2, (int)round_jiffies_relative(check_interval*HZ));
>
>        t->expires = jiffies + *n;
> -       add_timer(t);
> +       add_timer_on(t, smp_processor_id());
>  }
>
>  static void mce_do_trigger(struct work_struct *work)
> @@ -1321,7 +1321,7 @@ static void mce_init_timer(void)
>                return;
>        setup_timer(t, mcheck_timer, smp_processor_id());
>        t->expires = round_jiffies(jiffies + *n);
> -       add_timer(t);
> +       add_timer_on(t, smp_processor_id());
>  }
>
>  /*
> --
> 1.6.3
>

Patch remove warning.

Tested-by Maciej Rutecki <maciej.rutecki@gmail.com>

_But_ still system hangs after resume and during s2disk (while use
echo 0 > /sys/devices...)

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
