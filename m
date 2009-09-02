Return-Path: <linux-kernel-owner+w=401wt.eu-S1751941AbZIBVhB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941AbZIBVhB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 17:37:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751266AbZIBVhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 17:37:00 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:59101 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbZIBVg7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 17:36:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ruBTGPn2pJvZJX+eXgOaqc7a0LMAh1EkxHMpLla8r3rYaXsjQxcJwwEAieuReZAjlY
         nUj7efi6O5ncBvpJtcObnLQWHtr934iFt6xNLBVl2/5JWx+HEmq5bSNpbOPXYk5ColZQ
         1lMcRqDMWJ3RJ6bhI7LaA7eGLfRCV5GsS1hVQ=
MIME-Version: 1.0
In-Reply-To: <20090902172438.GA1190@rakim.wolfsonmicro.main>
References: <1251756258-23917-1-git-send-email-linus.walleij@stericsson.com>
	 <20090902172438.GA1190@rakim.wolfsonmicro.main>
Date: Wed, 2 Sep 2009 23:37:00 +0200
Message-ID: <63386a3d0909021437pe94b5a5m20a63fbad396cd13@mail.gmail.com>
Subject: Re: [PATCH 1/2] AB3100 regulator support v3
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Samuel Ortiz <sameo@linux.intel.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/9/2 Mark Brown <broonie@opensource.wolfsonmicro.com>:

> This looks basically good - my only concern is if the initialisation
> data supplied for the regulators is just setting up the things that can
> be set up via the API or if there's other stuff going on (this was my
> reason for the question I asked the other day).  If there's other stuff
> being configured then I'm happy with the patch modulo the static thing.

OK so this array:

+       /* Set up regulators */
+       for (i = 0; i < ARRAY_SIZE(ab3100_reg_init_order); i++) {
+               err = ab3100_set_register_interruptible(ab3100,
+                                       ab3100_reg_init_order[i],
+                                       plfdata->reg_initvals[i]);

The initvals are one-byte registers for each regulator plus 2 bytes
of sleep settings for LDO E and BUCK respectively.

The sleep settings are driven by two HW lines, so a regulator
can react by suspending the regulator on line A or B disjunct
either (logical ||) or both (logical &&). (You don't alter that in
runtime so no API has been developed here.)

Apart from that it's just default-zero undefined bits and default
voltage and default on/off setting. It is mainly written here so
that we have a known state, eventhough the boot loader should
have set them up (thus boot_on for some of them). But I like
to be on the safe side. If you for example download the kernel
through something like JTAG you may not have executed the
boot loader, and the reset power-on defaults can be bad,
for example have regulators enabled that should not be.

Currently the framework will enable the .boot_on regulators
effectively setting this one bit right for all regulators.

For *some* of the boot_on regulators I could also use .apply_uV
to set the voltage bits of course, but only if min_uV
and max_uV is the same which is not the case for all
regulators that are default on here.

And I don't see any way for the core (set_machine_constraints)
to set regulators to *off* by default if they happen to be on at
boot.

So my conclusion is that the array of initial settings is really
needed to:

- Set sleep config bits (you don't want to alter this runtime BTW)
- Set some default voltage levels on variable regulators
- Set some regulators default off
- Thus establish a known initial state

OK?

Yours,
Linus Walleij
