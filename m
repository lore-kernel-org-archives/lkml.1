Return-Path: <linux-kernel-owner+w=401wt.eu-S1757168AbXETTrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757168AbXETTrt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 15:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755613AbXETTrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 15:47:39 -0400
Received: from neon.samage.net ([85.17.153.66]:56943 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755451AbXETTrh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 15:47:37 -0400
Message-ID: <3378.81.207.0.53.1179690453.squirrel@secure.samage.net>
In-Reply-To: <465082BF.2070306@gmail.com>
References: <20070510072005.GA27316@linux-sh.org>
    <464301D3.5060306@gmail.com> <464307CC.40701@gmail.com>
    <20070510124645.GA18534@linux-sh.org> <4643196B.7070806@gmail.com>
    <20070511005217.GA23186@li <464B3505.20004@gmail.com>
    <2229.81.207.0.53.1179592754.squirrel@secure.samage.net>
    <464F4548.6020101@gmail.com> <464F4A58.2050607@gmail.com>
    <4764.81.207.0.53.1179613997.squirrel@secure.samage.net>
    <46501ACF.6020702@gmail.com>
    <1345.81.207.0.53.1179671262.squirrel@secure.samage.net>
    <465082BF.2070306@gmail.com>
Date: Sun, 20 May 2007 21:47:33 +0200 (CEST)
Subject: Re: sd_resume redundant?  [was: [PATCH] libata: implement          
      ata_wait_after_reset()]
From: "Indan Zupancic" <indan@nul.nu>
To: "Tejun Heo" <htejun@gmail.com>
Cc: "Paul Mundt" <lethal@linux-sh.org>, jeff@garzik.org,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       garyhade@us.ibm.com
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: -0.7
X-Scan-Signature: 729ef2e9e2cd27dd49f9ca04774c95e6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 20, 2007 19:17, Tejun Heo wrote:
> Indan Zupancic wrote:
>> So over all it takes half a second longer to detect the disk, but
>> because everything waits on it, it takes more than three seconds
>> longer to resume.
>
> Eeeek.  Extra three secs doesn't sound too hot.  :-(

Hey, without your reset fix it was 11 seconds slower. ;-)

Well, it used to be around 1.7 seconds to resume, and now (after the fixes)
it's 2.8 (according to the dmesg timestamps). But the first timestamp printed
was 0.7, and now it's 2.1, so I don't know if it's a real slowdown or that the timer
is set correctly earlier. That was with 2.19 btw, I don't know what happened in
the meantime. I suspect the timer changes. To know for sure I'd need to boot
an older kernel and measure resume time with a stopwatch.


>> Setting manage_start_stop to 0 fixes it and is good enough for me, I
>> didn't notice anything bad yet because of the unmanaged
>> stop. Implementing background spin up will fix it too.
>
> Just commenting out sd_resume() would be a better solution for your
> case tho.

I like your idea below more. ;-)


>>>> Everything seems to work fine without sd_resume(), so why is it needed?
>>> Because not all disks spin up without being told to do so and like it or
>>> not spinning disks up on resume is the default behavior.  As I wrote in
>>> the other reply, it would be worthwhile to make it configurable.
>>
>> Not even after they receive a read command? Ugh.
>
> After receiving a command which requires media access, they do.  What
> I was saying is that the current default behavior is to spin up all
> devices on resume and part of that is achieved by sd_resume().
>
> Hmmm... skipping START_STOP during sd_resume() actually is a pretty
> good solution for ATA devices.  I'll think about it.

I can't speak for others, but for me this would fix all regressions and even
disk spin up seems half a second faster without the START_STOP.
It would also solve the laptopmode thing, not unnecessarily spinning up
disks that don't need to be (if the hardware doesn't do it).

Greetings,

Indan


