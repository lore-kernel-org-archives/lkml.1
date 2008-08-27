Return-Path: <linux-kernel-owner+w=401wt.eu-S1754676AbYH0IyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676AbYH0IyZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 04:54:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753202AbYH0IyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 04:54:16 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:37598 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741AbYH0IyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 04:54:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=DwKuo2H+PrsbiqsfEkyt7eRI/WwpEeMbR6jE5CHQ/fq/vAvKRlqsSrcHKbpLHk55kh
         7CRlDLdFFs7FYGoAhJPfnyaXeu5Kow4ZFi9C+7p39077v9IDW+FZbaTm3SlWWg0zK8f/
         46VFovAWjL44B0O+SbNefF+6oKMESGfd9cCts=
Message-ID: <48B51631.5020309@tuffmail.co.uk>
Date: Wed, 27 Aug 2008 09:54:09 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Vegard Nossum <vegard.nossum@gmail.com>,
       Mikael Pettersson <mikpe@it.uu.se>, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] get_rtc_time() triggers NMI watchdog in hpet_rtc_interrupt()
References: <200808230948.m7N9mUc1016360@harpo.it.uu.se> <19f34abd0808240214o22748804s45e8487d62b34cb8@mail.gmail.com> <18609.14516.873317.52292@harpo.it.uu.se> <19f34abd0808240448w5facaee2gec77662c14b9364f@mail.gmail.com> <48B3DA02.9080002@tuffmail.co.uk> <20080826103921.GB10144@elte.hu>
In-Reply-To: <20080826103921.GB10144@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Alan Jenkins <alan-jenkins@tuffmail.co.uk> wrote:
>
>   
>> I beat you :-).  I noticed the problem myself.  It does trigger if I 
>> run hwclock in a loop.
>>
>> while true; do hwclock; done
>>
>> However it is fine in latest git.  Looks like Ingo's patch has been 
>> merged, and has fixed it.
>>     
>
> ah, good - thanks for testing it. I havent seen a lockup on the T60 
> either - but it was very sporadic to begin with. (and now we understand 
> why: hwclock is running only once per reboot.)
>
> Plus, the real bug has to be found as well: who in the rtc ioctl path 
> calls this code with irqs disabled - it's not nice.
>   

Isn't the problem that it gets called from a timer IRQ?  So irqs are
enabled globally, but the timer IRQ is masked.

 [<c0139cc0>] hrtimer_run_pending+0x20/0x90
 [<c01478a8>] handle_IRQ_event+0x28/0x50
 [<c0148f71>] handle_edge_irq+0xa1/0x120
 [<c010615b>] do_IRQ+0x3b/0x70
 [<c0113225>] smp_apic_timer_interrupt+0x55/0x80
 [<c0103c4f>] common_interrupt+0x23/0x28

Which in turn is probably because the userspace "RTC interrupt"
interface is emulated using RTC reads within the main timer interrupt
handler.

Alan
