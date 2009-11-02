Return-Path: <linux-kernel-owner+w=401wt.eu-S1754811AbZKBLSB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811AbZKBLSB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 06:18:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754721AbZKBLSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 06:18:00 -0500
Received: from mail-iw0-f180.google.com ([209.85.223.180]:56168 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754623AbZKBLSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 06:18:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=MiVTbfwkYqeQ5yYOnmUO6RarcfNVNASQhdcOL42CKNcbum95xwfYnvBqxBfyaI6bXi
         UUOR0oqQnNjoWFsrAcS4HbKTdDsguUW4w+Cw+7u2VfcKWazNkTcE+XfmRRVCYAj+99OL
         jdnwezyZHCjkvLK1zF7XjZxXDrGH3JwYYpet8=
MIME-Version: 1.0
In-Reply-To: <20091102105141.GB11426@elf.ucw.cz>
References: <20091031013427.GL14091@buzzloop.caiaq.de>
	 <20091101205449.GT14091@buzzloop.caiaq.de>
	 <20091101213343.GA31345@elf.ucw.cz>
	 <20091101220341.GA16698@elf.ucw.cz>
	 <771cded00911020122o3bb5cc96q957c8be1ce7cae46@mail.gmail.com>
	 <20091102093840.GA11426@elf.ucw.cz>
	 <771cded00911020248s2b2b6577o5ec2f3772a09e7b9@mail.gmail.com>
	 <20091102105141.GB11426@elf.ucw.cz>
Date: Mon, 2 Nov 2009 07:18:02 -0400
Message-ID: <771cded00911020318u3939a06dq75cd3504d6c0eb50@mail.gmail.com>
Subject: Re: Possible suspend/resume regression in .32-rc?
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: dsaxena@laptop.org, alan@linux.intel.com, gregkh@suse.de,
       Daniel Mack <daniel@caiaq.de>, linux-arm-kernel@lists.infradead.org,
       Eric <eric.y.miao@gmail.com>,
       Haojian Zhuang <haojian.zhuang@marvell.com>, rpurdie@rpsys.net,
       lenz@cs.wisc.edu, kernel list <linux-kernel@vger.kernel.org>,
       Dirk@opfer-online.de, arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>,
       thommycheck@gmail.com, dbaryshkov@gmail.com, omegamoon@gmail.com,
       utx@penguin.cz, "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 2, 2009 at 6:51 AM, Pavel Machek <pavel@ucw.cz> wrote:
> On Mon 2009-11-02 06:48:28, Haojian Zhuang wrote:
>> On Mon, Nov 2, 2009 at 5:38 AM, Pavel Machek <pavel@ucw.cz> wrote:
>> > On Mon 2009-11-02 05:22:30, Haojian Zhuang wrote:
>> >> On Sun, Nov 1, 2009 at 6:03 PM, Pavel Machek <pavel@ucw.cz> wrote:
>> >>
>> >> Em, it's not caused by the IRQ patch.
>> >>
>> >> The kernel is blocked in resume path. When console is resumed, IRQ is
>> >> already disabled and system is blocked. Actually, IRQ shouldn't be
>> >> disabled at here. Up to now, I only find which patch will cause this
>> >> issue. But I can't find the best solution on it. The patch with issue
>> >> is pasted in below.
>> >>
>> >> So this issue is only occused when console suspend is enabled. If you
>> >> enable no_console_suspend in command, you won't meet this issue. It
>> >> seems that it's caused by removing termios setting in
>> >> uart_resume_port() in the below patch. If I add these code back, the
>> >> issue doesn't occur any more.
>> >
>> > Given that it hangs very early, in arch_suspend_enable_irqs() (see my
>> > other mail), I don't trust your analysis.
>> >
>> > I'm not using serial console on spitz, and I have never had successful
>> > resume with the patch applied.
>>
>> It seems that we're talking on different issue with similar symptom.
>> Please check my test method. While I'm testing suspend with devices
>> level, kernel is blocked in console resume. In this level, it won't
>> call arch_suspend_enable_irqs(). This function call is only invoked in
>> processor level or below.
>
> For me, everything but real suspend works. I do _not_ have serial
> console for spitz.
>
>> Up to now, I can't reproduce the issue you're talking on my platform
>> yet. I'll check this issue continuously. I also want to know your
>> hardware information.
>
> Spitz, aka Sharp Zaurus c3000.
>

I see. You can chech my patch in below. I need to save IPRs in suspend
resume routine.

Thanks
Haojian

>From 1764e836424d42a0654b8b73c402a2dddb118dc4 Mon Sep 17 00:00:00 2001
From: Haojian Zhuang <haojian.zhuang@marvell.com>
Date: Mon, 2 Nov 2009 14:02:21 -0500
Subject: [PATCH] pxa: fix system resume issue on pxa27x and pxa3xx

Since interrupt handler is changed to use interrupt priority, we also need to
save and restore these interrupt controller registers in suspend/resume
routine.

Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>
---
 arch/arm/mach-pxa/irq.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-pxa/irq.c b/arch/arm/mach-pxa/irq.c
index d694ce2..cdc272b 100644
--- a/arch/arm/mach-pxa/irq.c
+++ b/arch/arm/mach-pxa/irq.c
@@ -150,6 +150,7 @@ void __init pxa_init_irq(int irq_nr, set_wake_t fn)

 #ifdef CONFIG_PM
 static unsigned long saved_icmr[2];
+static unsigned long saved_ipr[128];

 static int pxa_irq_suspend(struct sys_device *dev, pm_message_t state)
 {
@@ -159,6 +160,10 @@ static int pxa_irq_suspend(struct sys_device
*dev, pm_message_t state)
 		saved_icmr[i] = _ICMR(irq);
 		_ICMR(irq) = 0;
 	}
+	if (pxa_internal_irq_nr > 128)
+		BUG();
+	for (i = 0; i < pxa_internal_irq_nr; i++)
+		saved_ipr[i] = IPR(i);

 	return 0;
 }
@@ -171,6 +176,8 @@ static int pxa_irq_resume(struct sys_device *dev)
 		_ICMR(irq) = saved_icmr[i];
 		_ICLR(irq) = 0;
 	}
+	for (i = 0; i < pxa_internal_irq_nr; i++)
+		IPR(i) = saved_ipr[i];

 	ICCR = 1;
 	return 0;
-- 
1.5.6.5
