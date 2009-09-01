Return-Path: <linux-kernel-owner+w=401wt.eu-S1755245AbZIAWFL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245AbZIAWFL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 18:05:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755229AbZIAWFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 18:05:11 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:36605 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755227AbZIAWFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 18:05:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=edMG/jgPjaERjVb8DETVnCgKVot8/2Ad+vt0cjAyP87bDvHPA9q3WW1Xs7LxgjNs5R
         plhdRj9l1+7DssdyhAzK54+sVRRPbLga93QBLiLGMOE9qLu8tsh7lZJkhwmWe7Uglb2c
         nM34+auYx0uanlcfxIF4SYmTTm41ZYcxMWXlw=
MIME-Version: 1.0
In-Reply-To: <20090901135123.GS19719@n2100.arm.linux.org.uk>
References: <1251667749-31276-1-git-send-email-linus.walleij@stericsson.com>
	 <1251722641.4254.46.camel@finisterre.sirena.org.uk>
	 <63386a3d0908310716x1a33a8fdpddedbaf24648216f@mail.gmail.com>
	 <20090901135123.GS19719@n2100.arm.linux.org.uk>
Date: Wed, 2 Sep 2009 00:05:10 +0200
Message-ID: <63386a3d0909011505oed88151i95df1e97cf131c36@mail.gmail.com>
Subject: Re: [PATCH 1/2] AB3100 regulator support v2
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Linus Walleij <linus.walleij@stericsson.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/9/1 Russell King - ARM Linux <linux@arm.linux.org.uk>:
> On Mon, Aug 31, 2009 at 04:16:15PM +0200, Linus Walleij wrote:
>> That said, I think the regulator paths are entirely in-kernel and
>> under such circumstances that signals from userspace are blocked
>> anyway.
>
> Only if you explicitly block signals will pending signals be ignored
> by the foo_interruptible() functions.

Yep and we have some code like that currently. I'm currently
contemplating refactoring it the chain down through ab3100-core
and the i2c driver here to make sure no _interruptible suffixed
operations are used anywhere.

On U300 that is, since we have our own I2C driver we can
rid it there.

But generally speaking the AB3100 can be used on top of any
i2c adapter and a bunch of them actually use
wait_for_completion_interruptible_timeout();
and wait_event_interruptible_timeout(); for example.

One of them being i2c/buses/i2c-imx.c actually, Mark does
this mean you actually have the risk of being kill -9:ed in the
middle of a regulator operation for the WM drivers, for
example

In the general sense perhaps this doesn't happen so much,
what we've seen is system shut down, here some code get
interrupted by signals, so atleast the shut down path should be
protected I guess, I will do that in the U300 board setup
pm_poweroff() hook then, which calls down the
regulator/ab3100/i2c chain so all that is secured.

Yours,
Linus Walleij
