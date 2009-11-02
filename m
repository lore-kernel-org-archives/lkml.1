Return-Path: <linux-kernel-owner+w=401wt.eu-S1754163AbZKBJW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163AbZKBJW3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 04:22:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753934AbZKBJW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 04:22:28 -0500
Received: from mail-iw0-f180.google.com ([209.85.223.180]:48323 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117AbZKBJW0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 04:22:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wYdILRpkVAiMbM8fGX2eXxuPZsnQph1Usn21S52ZP1l1ztiAKWcu2iZkMQSzg9hOBj
         +uz5+sMcYKQtmWcuLfXsYdNtPlodJMt/Jp8K33KciB5+FLWE+PEpcnbku85sxYKQiCt+
         5q/z5XHKqI2z8Mw9V5KDOe5pR+f3gV73i/Uyw=
MIME-Version: 1.0
In-Reply-To: <20091101220341.GA16698@elf.ucw.cz>
References: <20091031013427.GL14091@buzzloop.caiaq.de>
	 <20091101205449.GT14091@buzzloop.caiaq.de>
	 <20091101213343.GA31345@elf.ucw.cz>
	 <20091101220341.GA16698@elf.ucw.cz>
Date: Mon, 2 Nov 2009 05:22:30 -0400
Message-ID: <771cded00911020122o3bb5cc96q957c8be1ce7cae46@mail.gmail.com>
Subject: Re: Possible suspend/resume regression in .32-rc?
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Pavel Machek <pavel@ucw.cz>, dsaxena@laptop.org, alan@linux.intel.com,
       gregkh@suse.de
Cc: Daniel Mack <daniel@caiaq.de>, linux-arm-kernel@lists.infradead.org,
       Eric <eric.y.miao@gmail.com>,
       Haojian Zhuang <haojian.zhuang@marvell.com>, rpurdie@rpsys.net,
       lenz@cs.wisc.edu, kernel list <linux-kernel@vger.kernel.org>,
       Dirk@opfer-online.de, arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>,
       thommycheck@gmail.com, dbaryshkov@gmail.com, omegamoon@gmail.com,
       utx@penguin.cz, "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 1, 2009 at 6:03 PM, Pavel Machek <pavel@ucw.cz> wrote:
>> Hi!
>>
>> > > Is anyone using suspend/resume with a recent git mainline kernel on PXA
>> > > or other ARM embedded boards? My platform used to suspend and resume
>> > > just fine on 2.6.31 but now as I rebased it, it fails the resume part.
>> > >
>> > > Unfortunately, I can't bisect it as the platform is not mainline yet and
>> > > so I always have mandatory patches (without my platform won't do
>> > > anything) on top of the git repository. Which breaks the bisect logic.
>> > >
>> > > What puzzles me is that I see the current raising at wakeup time, so at
>> > > least the processor seems to resume, but I can't see any serial console
>> > > output, just like if the kernel crashed very early after wakeup.
>> > > 'no_console_suspend' didn't help either.
>> >
>> > Ok, got it. The culprit is commit d2c37068 ("[ARM] pxa: initialize
>> > default interrupt priority and use ICHP for IRQ handling"). Reverting it
>> > make suspend/resume work again on my board.
>> >
>> > Haojian, Eric, could you have a look at this?
>>
>> Okay, patch is this one: I'll test reverting it shortly.
>>
>> commit d2c37068429b29d6549cf3486fc84b836689e122
>> Author: Haojian Zhuang <haojian.zhuang@marvell.com>
>> Date:   Wed Aug 19 19:49:31 2009 +0800
>>
>>     [ARM] pxa: initialize default interrupt priority and use ICHP for IRQ handling
>>
>>     Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>
>>     Signed-off-by: Eric Miao <eric.y.miao@gmail.com>
>
> And yes, reverting it _does_ fix suspend on spitz.
>
>                                                                        Pavel

Em, it's not caused by the IRQ patch.

The kernel is blocked in resume path. When console is resumed, IRQ is
already disabled and system is blocked. Actually, IRQ shouldn't be
disabled at here. Up to now, I only find which patch will cause this
issue. But I can't find the best solution on it. The patch with issue
is pasted in below.

So this issue is only occused when console suspend is enabled. If you
enable no_console_suspend in command, you won't meet this issue. It
seems that it's caused by removing termios setting in
uart_resume_port() in the below patch. If I add these code back, the
issue doesn't occur any more.

Deepak,
Could you help to investigate this issue also?

By the way, the suggested quick test command is in below. If we tried
these commands for 20 times, the issue would occur. I only test it in
PXA silicon. I don't know the symptom on other silicons.
$ echo devices > /sys/power/pm_test
$ echo mem > /sys/power/state

Thanks
Haojian

>From ba15ab0e8de0d4439a91342ad52d55ca9e313f3d Mon Sep 17 00:00:00 2001
From: Deepak Saxena <dsaxena@laptop.org>
Date: Sat, 19 Sep 2009 13:13:33 -0700
Subject: [PATCH] Set proper console speed on resume if console suspend
is disabled

Commit b5b82df6, from May 2007, breaks no_console_suspend on the OLPC
XO laptop. Basically what happens is that upon returning from resume,
serial8250_resume_port() will reconfigure the port for high speed
mode and all console output will be garbled, making debug of the
resume path painful. This patch modifies uart_resume_port() to
reset the port to the state it was in before we suspended.

Original patch by Marcelo Tosatti

Second patch by Deepak then reworked by Alan to fit with the tty changes
before it got submitted. Also fixed the console path to set c_i/ospeed as
some drivers require the termios fields are valid

Signed-off-by: Deepak Saxena <dsaxena@laptop.org>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/serial_core.c |   32 ++++++++++++++++++--------------
 1 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index 3fd0134..2514d00 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -2068,11 +2068,29 @@ int uart_resume_port(struct uart_driver *drv,
struct uart_port *uport)
 	struct tty_port *port = &state->port;
 	struct device *tty_dev;
 	struct uart_match match = {uport, drv};
+	struct ktermios termios;

 	mutex_lock(&port->mutex);

 	if (!console_suspend_enabled && uart_console(uport)) {
 		/* no need to resume serial console, it wasn't suspended */
+		/*
+		 * First try to use the console cflag setting.
+		 */
+		memset(&termios, 0, sizeof(struct ktermios));
+		termios.c_cflag = uport->cons->cflag;
+		/*
+		 * If that's unset, use the tty termios setting.
+		 */
+		if (termios.c_cflag == 0)
+			termios = *state->port.tty->termios;
+		else {
+			termios.c_ispeed = termios.c_ospeed =
+				tty_termios_input_baud_rate(&termios);
+			termios.c_ispeed = termios.c_ospeed =
+				tty_termios_baud_rate(&termios);
+		}
+		uport->ops->set_termios(uport, &termios, NULL);
 		mutex_unlock(&port->mutex);
 		return 0;
 	}
@@ -2089,20 +2107,6 @@ int uart_resume_port(struct uart_driver *drv,
struct uart_port *uport)
 	 * Re-enable the console device after suspending.
 	 */
 	if (uart_console(uport)) {
-		struct ktermios termios;
-
-		/*
-		 * First try to use the console cflag setting.
-		 */
-		memset(&termios, 0, sizeof(struct ktermios));
-		termios.c_cflag = uport->cons->cflag;
-
-		/*
-		 * If that's unset, use the tty termios setting.
-		 */
-		if (port->tty && termios.c_cflag == 0)
-			termios = *port->tty->termios;
-
 		uart_change_pm(state, 0);
 		uport->ops->set_termios(uport, &termios, NULL);
 		console_start(uport->cons);
-- 
1.5.6.5
