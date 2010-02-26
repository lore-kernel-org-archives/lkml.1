Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935741Ab0BZL4j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 06:56:39 -0500
Received: from www.tglx.de ([62.245.132.106]:54850 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935641Ab0BZL4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 06:56:37 -0500
Date: Fri, 26 Feb 2010 12:55:57 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       DRI <dri-devel@lists.sourceforge.net>
Subject: Re: [PATCH][RFC] time: add wait_interruptible_timeout macro to sleep
 (w. timeout) until wake_up
In-Reply-To: <b170af451002260238p29c7db97nd50154bf7288ef42@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1002261241100.4245@localhost.localdomain>
References: <1266761422-2921-1-git-send-email-zajec5@gmail.com> <b170af451002260238p29c7db97nd50154bf7288ef42@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1751889126-1267185358=:4245"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1751889126-1267185358=:4245
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Fri, 26 Feb 2010, Rafał Miłecki wrote:

> Forwarding to ppl I could often notice in git log time.h

And how is this related to time.h ?
 
> 
> ---------- Wiadomość przekazana dalej ----------
> From: Rafał Miłecki <zajec5@gmail.com>
> Date: 21 lutego 2010 15:10
> Subject: [PATCH][RFC] time: add wait_interruptible_timeout macro to
> sleep (w. timeout) until wake_up
> To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
> dri-devel@lists.sourceforge.net
> CC: Rafał Miłecki <zajec5@gmail.com>
> 
> 
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
> We try to implement some PM in radeon KMS and we need to sync with VLBANK for
> reclocking engine/memory. The easiest and cleanest way seems to be sleeping in
> timer handler just before reclocking. Then our IRQ handler calls wake_up and we

Sleeping in the timer handler ? In which context runs this timer handler ?

> continue reclocking.
> 
> As you see our sleeping is condition-less, we just wait for waking up queue.

Your sleep is not condition-less at all. See below.
 
> We hope this waking will happen from IRQ handler, but for less-happy case we
> also use some timeout (this will probably cause some single corruption, but
> we can live with it).
> 
> Following macro is soemthing that seems to work fine for us, but instead
> introducing this to radeon KMS only, I'd like to propose adding this to whole
> wait.h. Do you this it's something we should place there? Can someone take this
> patch for me? Or maybe you find this rather useless and we should keep this
> marco locally?

You better delete it right away. It's broken and racy. 

If the interrupt happens right before you enqueue to the wake queue,
then you miss it. The old interruptible_sleep_on_timeout() was
replaced by the event wait functions which have a condition exaclty to
avoid that race.

And you have a condition: Did an interrupt happen?

Thanks,

	tglx

--8323328-1751889126-1267185358=:4245--
