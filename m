Return-Path: <linux-kernel-owner+w=401wt.eu-S1754132AbZETCrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbZETCrZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 22:47:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752665AbZETCrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 22:47:18 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:33229 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbZETCrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 22:47:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YgafmsqBH52YFPpdGmF/pCspMyCXmumva0VKAxXoK4GrbMTfxGkzAKFeqjqYf7oN6k
         UOQrBncg8X5v/ZaT4j0dX//agY00PWsblJVh9zwLmvfvoahKrNQRxvaXAaAXqGmNxiO4
         fu6U4N/QVwW0BKiNg955MouKoQ2QYvLJm4AOg=
Date: Tue, 19 May 2009 19:47:08 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: linux-kernel@vger.kernel.org,
       Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, mingo@elte.hu
Subject: Re: EeePC 900 trackpad often not detected at boot in 2.6.30-rc4
Message-ID: <20090520024658.GD17649@dtor-d630.eng.vmware.com>
References: <20090511072135.GA4682@sucs.org> <20090513032053.GA29919@dtor-d630.eng.vmware.com> <20090513185356.GA20140@sucs.org> <20090513191953.GA10629@sucs.org> <20090516032754.GC12099@dtor-d630.eng.vmware.com> <20090516032924.GD12099@dtor-d630.eng.vmware.com> <20090518084146.GA25806@sucs.org> <20090518094209.GA21150@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090518094209.GA21150@sucs.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 18, 2009 at 10:42:10AM +0100, Sitsofe Wheeler wrote:
> On Mon, May 18, 2009 at 09:41:46AM +0100, Sitsofe Wheeler wrote:
> > 
> > And of course just as soon as I finish building a new kernel the issue
> > disappears. Even in older kernels that were seemingly showing the
> > problem all the time. Sigh.
> 
> After numerous reboots I finally managed to reproduce the problem the
> original way with your patch installed. I have no idea what the
> necessary triggers are but I suspect it involves suspend to ram...
> 

It is just unfortunate scheduling that messes us up:

> [    4.267050] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [113]
> [    4.270440] drivers/input/serio/i8042.c: d4 -> i8042 (command) [116]
> [    4.271016] drivers/input/serio/i8042.c: f2 -> i8042 (parameter) [116]
> [    4.274883] ALSA device list:
> [    4.274963]   #0: HDA Intel at 0xf7eb8000 irq 16
> [    4.275258] TCP cubic registered
> [    4.276597] NET: Registered protocol family 17
> [    4.276802] Using IPI Shortcut mode
> [    4.279191]   Magic number: 9:810:70
> [    4.279548] rtc_cmos 00:03: setting system clock to 2009-05-18 09:03:27 UTC (1242637407)
> [    4.281412] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [127]
> [    4.283338] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [129]
> [    5.406620] libps2: errorneously fail 754 command

As you can see the device responded to our command and interrupt fired
at 4.28 but for some reason the thread did not get woken up until 5.40,
second and a half later... Crazy if you ask me.

Ingo, do you have any idea why would it not be woken up for so long???

In the meantime, the patch below should fix work around that delay.

-- 
Dmitry


Input: libps2 - better handle bad scheduler decisions

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Sometimes devices send us their responses in time but due to
unfortunate scheduling decisions the receiving thread does not
get scheduled till much later and we erroneously decide that
device timed out. Work around this problem by checking whether we
received the data we needed instead of checking timeout
condition.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/serio/libps2.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/input/serio/libps2.c b/drivers/input/serio/libps2.c
index a0d8968..3a95b50 100644
--- a/drivers/input/serio/libps2.c
+++ b/drivers/input/serio/libps2.c
@@ -208,7 +208,7 @@ int __ps2_command(struct ps2dev *ps2dev, unsigned char *param, int command)
 	timeout = wait_event_timeout(ps2dev->wait,
 				     !(ps2dev->flags & PS2_FLAG_CMD1), timeout);
 
-	if (ps2dev->cmdcnt && timeout > 0) {
+	if (ps2dev->cmdcnt && !(ps2dev->flags & PS2_FLAG_CMD1)) {
 
 		timeout = ps2_adjust_timeout(ps2dev, command, timeout);
 		wait_event_timeout(ps2dev->wait,
