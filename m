Return-Path: <linux-kernel-owner+w=401wt.eu-S1753476AbYHWIsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476AbYHWIsV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 04:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752088AbYHWIsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 04:48:11 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:61686 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbYHWIsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 04:48:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=WL9T+kyrcVvStps8uACK9NmemXpPb2uL9CZ1NGVC3sVISWQ/ZYMJa4ONAbp9+2cF1m
         HfomavOE4lzL0wN2HU7ftepMMDYV+wvmTC0LTcI1uQdWBBCU2B0xw+zM63y9z+jzkGZU
         AjfgPQR0TA3M7bku0qQm0R5eDBmibwksi32fU=
Message-ID: <ef1cd66f0808230148u317eb063xac80a319414c9f33@mail.gmail.com>
Date: Sat, 23 Aug 2008 09:48:08 +0100
From: "=?ISO-8859-1?Q?Jochen_Vo=DF?=" <jochen.voss@googlemail.com>
To: "Dominik Brodowski" <linux@dominikbrodowski.net>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Andreas Mohr" <andi@lisas.de>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, johnstul@us.ibm.com,
       hirofumi@mail.parknet.co.jp, alan@lxorguk.ukuu.org.uk,
       arjan@infradead.org
Subject: Re: [PATCH v2 2/2] acpi_pm.c: check for monotonicity
In-Reply-To: <20080822222604.GA704@isilmar.linta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080810190759.GA1879@rhlx01.hs-esslingen.de>
	 <20080818121924.6b61f7af.akpm@linux-foundation.org>
	 <20080818193517.GA22097@isilmar.linta.de>
	 <20080818124755.162f24d1.akpm@linux-foundation.org>
	 <20080818200916.GA18209@comet.dominikbrodowski.net>
	 <20080818201033.GB18209@comet.dominikbrodowski.net>
	 <20080819024334.2f3e69fa.akpm@linux-foundation.org>
	 <20080819094938.GA21126@isilmar.linta.de>
	 <20080819025915.c34951b6.akpm@linux-foundation.org>
	 <20080822222604.GA704@isilmar.linta.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

some minor comments:

2008/8/22 Dominik Brodowski <linux@dominikbrodowski.net>:
> +       for (j = 0; j < ACPI_PM_MONOTONICITY_CHECKS; j++) {
> +               value1 = clocksource_acpi_pm.read();
> +               for (i = 0; i < 10000; i++) {
> +                       value2 = clocksource_acpi_pm.read();
> +                       if (value2 == value1)
> +                               continue;
> +                       if (value2 > value1)
> +                               good++;
> +                               break;
> +                       if ((value2 < value1) && ((value2) < 0xFFF))
The brackets arout value2 are not needed and look strange.

> +                               good++;
> +                               break;
> +                       printk(KERN_INFO "PM-Timer had inconsistent results:"
> +                              " 0x%#llx, 0x%#llx - aborting.\n",
> +                              value1, value2);
> +                       return -EINVAL;
> +               }
> +               udelay(300 * i);
300*10000 microseconds seems like a long time to me.  Is this the
intended maximal delay?

> +       }
> +
> +       if (good != ACPI_PM_MONOTONICITY_CHECKS) {
> +               printk(KERN_INFO "PM-Timer failed consistency check "
> +                      " (0x%#llx) - aborting.\n", value1);
> +               return -ENODEV;
If the inner loop runs out once, you alreay know that you will later
abort here.  Maybe move the check directly after the inner loop to
avoid the additional delay (10*10000*300 microseconds = 30 seconds) in
case of failure?

I hope this helps,
Jochen
-- 
http://seehuhn.de/
