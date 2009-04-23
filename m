Return-Path: <linux-kernel-owner+w=401wt.eu-S1758533AbZDWOv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758533AbZDWOv5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 10:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756867AbZDWOvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 10:51:46 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:62962 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755913AbZDWOvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 10:51:45 -0400
Date: Thu, 23 Apr 2009 23:51:41 +0900 (JST)
Message-Id: <20090423.235141.61509229.anemo@mba.ocn.ne.jp>
To: alessandro.zummo@towertech.it
Cc: akpm@linux-foundation.org, rtc-linux@googlegroups.com,
       linux-kernel@vger.kernel.org, hcegtvedt@atmel.com, vapier@gentoo.org,
       rongkai.zhan@windriver.com, balajirrao@openmoko.org,
       david-b@pacbell.net, broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH] rtc: Make rtc_update_irq callable with irqs enabled
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20090410005820.4fcfcc1f@i1501.lan.towertech.it>
References: <1239036633-10032-1-git-send-email-anemo@mba.ocn.ne.jp>
	<20090409153921.04b6384c.akpm@linux-foundation.org>
	<20090410005820.4fcfcc1f@i1501.lan.towertech.it>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Add CCs to authers or original committers of each mentioned driver]

On Fri, 10 Apr 2009 00:58:20 +0200, Alessandro Zummo <alessandro.zummo@towertech.it> wrote:
> On Thu, 9 Apr 2009 15:39:21 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > > The rtc_update_irq() might be called with irqs enabled, if a interrupt
> > > handler was registered without IRQF_DISABLED.  
> > 
> > Why?  What are the consequences of not merging the patch?  Is it a
> > bugfix?  If so, what are the user-visible effects of the bug?
> 
>  rtc_update_irq() is called by a driver, and a driver
>  is supposed to know when it's doing the call.
> 
>  The driver can either use IRQF_DISABLED or disable the
>  interrupts in some other ways. 
> 
>  I also suspect this is some legacy we are carrying on, 
>  so it's better to leave the decision on the interrupt
>  handling to the driver itself.
> 
>  Unless I'm missing something.

Then here is list of (potentialy) broken rtc drivers:

rtc-at32ap700x.c
rtc-bfin.c
rtc-m48t59.c
rtc-pcf50633.c
rtc-twl4030.c
rtc-wm8350.c

I'm not sure there are any real problem on these drivers.  It seems
IRQF_DISABLED would be suitable for at32ap700x, bfin and m48t59, and
local_irq_disable would be suitable for others.

The IRQF_DISABLED fixes would be better regardless of the
rtc_update_irq() API change.  And local_irq_disable fixes are not
needed (and should be reverted) if the API change was acked, but no
harm for short term fix.

Note that just adding IRQF_DISABLED will cause "IRQF_DISABLED is not
guaranteed on shared IRQs" warning.  So you should consider of
removing IRQF_SHARED, or finding other way.

---
Atsushi Nemoto
