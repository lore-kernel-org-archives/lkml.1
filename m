Return-Path: <linux-kernel-owner+w=401wt.eu-S1757220AbYG0DEN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757220AbYG0DEN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 23:04:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754363AbYG0DD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 23:03:58 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:20475 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517AbYG0DD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 23:03:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=AVZPp+CpVLHVKjZ4aBXGSDr6M7weKVjBh5mdKRe1PQLFnfQdDUtZwc2qrDAgTLMRvN
         CgNLEljZiad4wfiPF+9v6wWamYVXa9/cB15VOReTKL9yOaIIL39XMI7i9gm0c9rlwjAw
         3VrXAk7JFoZiHZ38IsT9C4c3oBOJPuNOZRpmw=
Message-ID: <8bd0f97a0807262003y4000f55eh45d5d1b8c866fd10@mail.gmail.com>
Date: Sat, 26 Jul 2008 23:03:57 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [PATCH] rtc-dev: stop periodic interrupts on device release
Cc: "Tomas Janousek" <tomi@nomi.cz>, linux-kernel@vger.kernel.org,
       "Alessandro Zummo" <alessandro.zummo@towertech.it>
In-Reply-To: <200807261350.55524.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080726154617.GA5613@notes.lisk.in>
	 <200807261350.55524.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 26, 2008 at 4:50 PM, David Brownell wrote:
> On Saturday 26 July 2008, Tomas Janousek wrote:
>> I am aware that some drivers, like rtc-sh, handle userspace PIE sets in their
>> ioctl op, exporting the irq_set_state op at the same time. The logic in
>> rtc_irq_set_state should make sure it doesn't matter and the driver should not
>> need to care stopping periodic interrupts in its release routine any more.
>> I did not look at other drivers though.
>
> A quick grep shows that out of 42 (wow!) current RTC drivers:
>
>  - rtc-{bfin,sa1100,sh,test} support ioctl(PIE_ON/PIE_OFF), at least
>   before some recent patches fixing that glitch (not in my tree) by
>   switching to irq_set_state().

the rtc-bfin.c patches are in some queue somewhere to fix this ;)

>  - Of those:  rtc-{bfin,s3c,sa1100,sh,vr41xx} all have release()
>   methods ... though it looks to me like most of those wrongly
>   disable *all* IRQs, even ones in use by something other than
>   the /dev client closing that FD.

rtc-bfin.c turns off all irqs and frees it in the release() function
(since the irq is requested in the open() function).  i guess that
isnt supposed to happen huh.

> That suggests there's quite a mess yet to be fixed.  This patch
> will ensure that periodic IRQs get properly shut off by close()
> or exit() of a task that started them.  Those release() methods
> shouldn't then be second-guessing things.
>
> And then there are the other two types of IRQ.  Update IRQs can
> only be enabled through ioctl(UIE_ON), so they're fair game to
> turn off when closing /dev files.  Alarms seem to be a special
> case -- best not touched when closing files.

specific drivers shouldnt worry about this then right ?  handle it in rtc-dev ?
-mike
