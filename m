Return-Path: <linux-kernel-owner+w=401wt.eu-S1757651AbYHZPTM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757651AbYHZPTM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 11:19:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754024AbYHZPS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 11:18:56 -0400
Received: from qb-out-0506.google.com ([72.14.204.229]:26748 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937AbYHZPS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 11:18:56 -0400
Message-ID: <1b51b6f80808260818x1a2e06ccvcb7ea0c8e273ffc4@mail.gmail.com>
Date: Tue, 26 Aug 2008 17:18:53 +0200
From: "Niels de Vos" <niels.devos@wincor-nixdorf.com>
To: linux-input@vger.kernel.org
Subject: [PATCH] serio_raw: add support for translated (SERIO_I8042XL) ports
Cc: linux-kernel@vger.kernel.org,
       "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 48becfa31f0aa8d4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

serio_raw only binds to non-translated devices. Enable serio_raw to
bind to normal (translated) keyboards which can have non-standard
extensions (like POS Keyboards). With this it is possible to send
commands to the device over /dev/serio_raw<n>.

Signed-off-by: Niels de Vos <niels.devos@wincor-nixdorf.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
In ReplyTo: "[RFC][PATCH] POSKeyboard driver for exclusive keyboard access"

On Fri, Aug 22, 2008 at 8:02 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> Hi Niels,
>
> On Fri, Aug 22, 2008 at 06:17:28PM +0200, Niels de Vos wrote:
>> This new driver makes it possible for middleware like JavaPOS to use
>> a POSKeyboard (connected to PS/2) with exclusive access. This is
>> required by the UnifiedPOS Specification which is available from
>> http://www.nrf-arts.org/UnifiedPOS. Any middleware using this driver
>> should implement the full exception-handling in user-space. Therefor
>> it is possible to use specific POS-extensions of POSKeyboards, without
>> abusing other keyboard-drivers.
>>
>> Opening /dev/poskeyboard will route all scancodes to this device. The
>> scancodes will not be processes by the input-subsystem anymore. Reading
>> /dev/poskeyboard results in receiving the scancodes as raw data for
>> further processing by the reader. Sending commands to the hardware can
>> be done by writing to /dev/poskeyboard.
>>
>> If the driver is loaded and /dev/poskeyboard is not opened, all
>> scancodes are given to the input-subsystem. This allows 'normal' use of
>> the keyboard.
>>
>> Making the driver active involves some commands like the following:
>>    echo -n serio1 > /sys/bus/serio/drivers/atkbd/unbind
>>    echo -n serio1 > /sys/bus/serio/drivers/poskbd/bind
>>
>
> It seems you have just reimplemented serio_raw driver, therefore NAK.
> Right now serio_raw is limited to untranslated ports but adding
> SERIO_I8042XL signature should be easy.
---
diff --git a/drivers/input/serio/serio_raw.c b/drivers/input/serio/serio_raw.c
index c9397c8..470770c 100644
--- a/drivers/input/serio/serio_raw.c
+++ b/drivers/input/serio/serio_raw.c
@@ -373,6 +373,12 @@ static struct serio_device_id serio_raw_serio_ids[] = {
                .id     = SERIO_ANY,
                .extra  = SERIO_ANY,
        },
+       {
+               .type   = SERIO_8042_XL,
+               .proto  = SERIO_ANY,
+               .id     = SERIO_ANY,
+               .extra  = SERIO_ANY,
+       },
        { 0 }
 };
