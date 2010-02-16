Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933103Ab0BPQse (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 11:48:34 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:33620 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932265Ab0BPQsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 11:48:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=OAe/s8C/qhLPmwQ1i5qS8Mwv/c2vKFp2XuMJPbd8LVFJylNEDatgCFaSo2DQW8tkJ0
         K/lxVvZ0+0SKJ6xzRXJXOpUPk6Yfzf2+JN9VgifPn+IZGEumj3jsIOE1FHPspm7RZDfm
         UNIq5Z+rWNUSMWJ/btGEGDXfUcPZUC/UR9MHo=
MIME-Version: 1.0
In-Reply-To: <4B6A9FD7.5040207@tuffmail.co.uk>
References: <4B69C7AA.7000904@tuffmail.co.uk>
	 <20100203191112.GC30600@core.coreip.homeip.net>
	 <4B6A9FD7.5040207@tuffmail.co.uk>
Date: Tue, 16 Feb 2010 16:48:30 +0000
Message-ID: <9b2b86521002160848q3e75d02aqe432376de2a5b732@mail.gmail.com>
Subject: Re: [PATCH] Input: serio - re-add thaw (and add freeze)
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/4/10, Alan Jenkins <alan-jenkins@tuffmail.co.uk> wrote:
> Dmitry Torokhov wrote:
>> On Wed, Feb 03, 2010 at 06:59:54PM +0000, Alan Jenkins wrote:
>>
>>> 633aae2 "Input: i8042 - switch to using dev_pm_ops"
>>> removed handling for PMSG_THAW, causing obscure breakage.
>>>
>>> It can break if you press keys during hibernation,
>>> which causes subsequent keypresses to be lost -
>>> so you can't cancel s2disk by pressing backspace -
>>> and then just before system poweroff you get
>>> "psmouse.c: Failed to deactivate mouse".
>>>
>>> So let's add the thaw handler back.
>>>
>>> Also set the freeze handler.  It looks like PMSG_FREEZE
>>> didn't do anything in the past, but I think that must
>>> have been an oversight.
>>>
>>
>> We do not need to do anything special at freeze time that is why there
>> wasn't freeze handler. And so thaw should be pretty much noop as well.

Ok, so I did some more mindless fiddling.  It seems that all it needs
is to call the interrupt handler at thaw time.

Regards
Alan

diff --git a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
index d84a36e..b54aee7 100644
--- a/drivers/input/serio/i8042.c
+++ b/drivers/input/serio/i8042.c
@@ -1161,9 +1161,17 @@ static int i8042_pm_restore(struct device *dev)
 	return 0;
 }

+static int i8042_pm_thaw(struct device *dev)
+{
+	i8042_interrupt(0, NULL);
+
+	return 0;
+}
+
 static const struct dev_pm_ops i8042_pm_ops = {
 	.suspend	= i8042_pm_reset,
 	.resume		= i8042_pm_restore,
+	.thaw		= i8042_pm_thaw,
 	.poweroff	= i8042_pm_reset,
 	.restore	= i8042_pm_restore,
 };
