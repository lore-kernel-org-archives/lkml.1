Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936115Ab0BZMQp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 07:16:45 -0500
Received: from mail-ew0-f220.google.com ([209.85.219.220]:58543 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936032Ab0BZMQm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 07:16:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CB0tG7MnMXjzNwfTZ7FCnVqTejkD8/YkyMVDQdsZXjhUact5A6fyBqJd4KiBI9UVLt
         mhE4SP9EtixT/UtTBcSAsAUwW7gmXBhvp5P/nrps8UYNwldJFBKjWBqZQ1yp4kdNnUKK
         yUzwPLVmfCno1Yd/8caHrCzt/8a7Py5c2xGA0=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1002261241100.4245@localhost.localdomain>
References: <1266761422-2921-1-git-send-email-zajec5@gmail.com>
	 <b170af451002260238p29c7db97nd50154bf7288ef42@mail.gmail.com>
	 <alpine.LFD.2.00.1002261241100.4245@localhost.localdomain>
Date: Fri, 26 Feb 2010 13:16:39 +0100
Message-ID: <b170af451002260416i474617f5v2cc20e0d1c55def9@mail.gmail.com>
Subject: Re: [PATCH][RFC] time: add wait_interruptible_timeout macro to sleep 
	(w. timeout) until wake_up
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       DRI <dri-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 26 lutego 2010 12:55 użytkownik Thomas Gleixner
<tglx@linutronix.de> napisał:
> On Fri, 26 Feb 2010, Rafał Miłecki wrote:
>
>> Forwarding to ppl I could often notice in git log time.h
>
> And how is this related to time.h ?

Ouch, time.h vs. wait.h. I'm sorry.


>> ---------- Wiadomość przekazana dalej ----------
>> From: Rafał Miłecki <zajec5@gmail.com>
>> Date: 21 lutego 2010 15:10
>> Subject: [PATCH][RFC] time: add wait_interruptible_timeout macro to
>> sleep (w. timeout) until wake_up
>> To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
>> dri-devel@lists.sourceforge.net
>> CC: Rafał Miłecki <zajec5@gmail.com>
>>
>>
>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>> ---
>> We try to implement some PM in radeon KMS and we need to sync with VLBANK for
>> reclocking engine/memory. The easiest and cleanest way seems to be sleeping in
>> timer handler just before reclocking. Then our IRQ handler calls wake_up and we
>
> Sleeping in the timer handler ? In which context runs this timer handler ?

We have our struct delayed_work which we first init and then we use
"queue_delayed_work" to start this "timer". So it's not real-real
timer as struct timer_list.

So this is actually delayed_work handler. Sorry (again) for my bad naming.

Anyway in this handler we just take decision about (down|up)clocking,
we wait for VBLANK (to avoid display corrupted picture) and right
after it happens, we reclock engine (plus memory in future).


>> continue reclocking.
>>
>> As you see our sleeping is condition-less, we just wait for waking up queue.
>
> Your sleep is not condition-less at all. See below.
>
>> We hope this waking will happen from IRQ handler, but for less-happy case we
>> also use some timeout (this will probably cause some single corruption, but
>> we can live with it).
>>
>> Following macro is soemthing that seems to work fine for us, but instead
>> introducing this to radeon KMS only, I'd like to propose adding this to whole
>> wait.h. Do you this it's something we should place there? Can someone take this
>> patch for me? Or maybe you find this rather useless and we should keep this
>> marco locally?
>
> You better delete it right away. It's broken and racy.
>
> If the interrupt happens right before you enqueue to the wake queue,
> then you miss it. The old interruptible_sleep_on_timeout() was
> replaced by the event wait functions which have a condition exaclty to
> avoid that race.

Well, I'm completely fine with that. After taking decision about
reclocking I request hardware to start reporting VBLANK interrupts.
Then (without any hurry) I go into sleep and next VBLANK interrupt
wake me up. Right after waking up I reclock engine/memory and then
(without hurry) I tell hardware to stop reporting VBLANK interrupts.

I guess it can be AMD-GPU specific interrupts mechanism there, but
that's how it works. I can point responsible code in driver if you
wish.


> And you have a condition: Did an interrupt happen?

Yeah, I guess that's kind of condition. I meant that I don't use any
driver's variable as condition to stop sleeping.


Sorry again for my mistakes mentioned above.

-- 
Rafał
