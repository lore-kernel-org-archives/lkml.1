Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753Ab0BMNtE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 08:49:04 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:17159 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754798Ab0BMNtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 08:49:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=kZY3Ooqy8mVo71OOQQv8WP7spzcJbEau+IRA0rIDJJA+Ie/VhhzbknzuIIxMFqFPO1
         i4+H3JO9VBnAU6xKTv1jxzDcMbDrawtOt6KUk3cELroD0dd7MIgvWqbAzgzvwu4nY8/E
         3gOmVmLLV7sS/pncab0xmf+/oNqCn6hbLT9KA=
MIME-Version: 1.0
In-Reply-To: <10B19BD9-34B8-4E0E-9737-09141A37BD00@opensource.wolfsonmicro.com>
References: <1265918499-9583-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	 <1265969888-16946-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	 <6ed0b2681002121501m32995aaekd3ce2f4fabd91050@mail.gmail.com>
	 <10B19BD9-34B8-4E0E-9737-09141A37BD00@opensource.wolfsonmicro.com>
Date: Sat, 13 Feb 2010 15:48:59 +0200
Message-ID: <6ed0b2681002130548y3258db78o168697eb2512ba94@mail.gmail.com>
Subject: Re: [PATCH] regulator: Provide optional dummy regulator for consumers
From: Grazvydas Ignotas <notasas@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, Mike Rapoport <mike@compulab.co.il>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 13, 2010 at 1:26 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On 12 Feb 2010, at 23:01, Grazvydas Ignotas <notasas@gmail.com> wrote:
>
>> On Fri, Feb 12, 2010 at 12:18 PM, Mark Brown
>> <broonie@opensource.wolfsonmicro.com> wrote:
>>>
>>> In order to ease transitions with drivers are boards start using
>>> regulators
>>> provide an option to cause all regulator_get() calls to succeed, with a
>>> dummy always on regulator being supplied where one has not been
>>> configured.
>>> A warning is printed whenever the dummy regulator is used to aid system
>>> development.
>>>
>>> This regulator does not implement any regulator operations but will allow
>>> simple consumers which only do enable() and disable() calls to run. It
>>> is kept separate from the fixed voltage regulator to avoid Kconfig
>>> confusion on the part of users when it is extended to allow boards to
>>> explicitly use the dummy regulator to simplify cases where the majority
>>> of supplies are from fixed regulators without software control.
>>>
>>> This option is currently only effective for systems which do not specify
>>> full constriants. If required an override could also be provided to allow
>>> these systems to use the dummy regulator, though it is likely that
>>> unconfigured supplies on such systems will lead to error due to
>>> regulators being powered down more aggressively when not in use.
>>>
>>> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
>>> ---
>>>
>>
>> hm, tried intentionally nuking regulator setup on my board to test
>> dummy and drivers started failing on regulator_enable() with -1
>> (EPERM?). Looks like dummy doesn't have constraints defined, so not
>> much use of this if _enable() is failing anyway.
>
> Hrmpf. That was working for me - are you running the latest regulator code?
> There was a bug where it was requiring CHANGE_STATUS even if the regulator
> is always on, which isn't sensible since there is no possibility of actually
> changing the status. It should now only be checking for permission to change
> status if it would actually do so. There was also a patch yesterday to make
> regulators that don't define an is_enabled() report as enabled.

Oh, it appears I was missing those patches (they were not in last
linux-lest yet), now everything works as expected, thanks.

>
>> BTW, drivers/mmc/host/omap_hsmmc.c has quite a lot of logic related to
>> vcc_aux being available or not (vcc_aux is typically used to power
>> some MMC pins and is unused on devices with SD cards, like pandora). I
>> wonder if it may cause some functionality change there.
>
> Yeah, quite possibly. This sort of stuff is one of the reasons it's much
> nicer to specify full constraints where possible; it allows drivers that can
> have missing supplies to handle that.
