Return-Path: <linux-kernel-owner+w=401wt.eu-S1762671AbZAOKLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762671AbZAOKLb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 05:11:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754725AbZAOKLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 05:11:22 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:34654 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753615AbZAOKLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 05:11:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Z8i3XA2iP8nPLhgTjj9UnqKjlGiQ6/2yT8/bgIDcADHshmM90fqhyXPFRNkbV3p29O
         iNkbTCTSEZhbulyrCyoFSkMztepfGYdq9B4f+B/Xw1bvs3rwp6OXylRI855ZrXN8j+v/
         FXzwvwTlPRYVbNxJwQs9OGezoy6dNt6o2DuDY=
Message-ID: <aec7e5c30901150211k484257e0sa7656786ad918455@mail.gmail.com>
Date: Thu, 15 Jan 2009 19:11:18 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [RESEND][PATCH] early platform drivers V2
Cc: linux-kernel@vger.kernel.org, lethal@linux-sh.org, johnstul@us.ibm.com,
       gregkh@suse.de, mingo@redhat.com, tglx@linutronix.de
In-Reply-To: <20090114143635.c64a4943.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20090114105436.18974.45429.sendpatchset@rx1.opensource.se>
	 <20090114143635.c64a4943.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2009 at 7:36 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Wed, 14 Jan 2009 19:54:36 +0900
> Magnus Damm <magnus.damm@gmail.com> wrote:
>
>> From: Magnus Damm <damm@igel.co.jp>
>>
>> This patch is V2 of the early platform driver implementation.
>>
> <babe-in-the-woods> Seems that this feature involves adding something to
> the kernel boot command line?  Or does the command line remain the
> same, only the kernel's handling of it changes?

The kernel command line itself is unchanged. The code managing the
kernel command line is reused though, this for registration of early
platform drivers and allowing the user to specify early platform
device for a certain class.

The following kernel command line functions are reused:
- parse_early_options() makes sure all compiled-in early platform
drivers register themselves.
- early_param() lets the user specify device using command line string
"class=driverN"

> Is some documentation update needed/appropriate?

When people add class names then they should go into
Documentation/kernel-parameters.txt. Regarding the early platform
driver code itself, how about me sending a patch adding it to
Documentation/driver-model/platform.txt?

> IOW: how does one use this feature?

It must be difficult to understand the code without patches that
actually make use of it, sorry about that.

So say that your architecture wants to use early platform drivers for
timers and early serial console output. Those two types of drivers
result in two classes: "earlytimer" and "earlyprintk". Any class name
that doesn't collide with existng kernel command line parameters
should be fine. Write your timer and serial drivers as regular
platform drivers, use one platform device instance per hardware device
to allow the user to specify early platform device on the command
line. Let your board/cpu code provide platform device instances for
the platform drivers as usual.

Each platform driver should add a line of "early_platform_init()"
together with the class string it belongs to. So our first timer
driver - the cmt driver - adds "early_platform_init("earlytimer",
&sh_cmt_timer_driver)" where sh_cmt_timer_driver contains the driver
name "cmt". The second timer driver adds a
"early_platform_init("earlytimer", &sh_tmu_timer_driver)" - the same
as the cmt but pointing to a different platform driver which has the
name "tmu". Same thing for serial drivers using the "earlyprintk"
class.

The architecture code then simply adds calls to
early_platform_driver_probe() wherever needed. For timers we do a
early_platform_driver_probe("earlytimer"...) inside time_init() on
SuperH. This call makes sure that all early platform drivers register
themselves and tries to match them against the platform devices
provided as an argument to the function. If a match is found, the
probe() method of the platform driver will be called, and it's up to
the driver to do whatever it needs to do to setup the hardware.

The user may specify which device to use for a certain class on the
kernel command line. For example, passing "earlytimer=cmt0" will make
sure the early platform driver with name "cmt" belonging to the class
"earlytimer" will be registered first within it's class as long as
platform device data with "cmt" and id=0 is present.

Later on the regular platform driver probe() call will happen. This
call converts the early platform device to a regular platform device.

>> +early_param(class_string, early_platform_driver_setup_func)
>
> I guess this macro should have an all-caps name, but this name matches
> previous up-screwings?

Yep, correct.

I'll look into switching to strict_strtoul() to make checkpatch happy.

Thanks for your help!

/ magnus
