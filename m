Return-Path: <linux-kernel-owner+w=401wt.eu-S1752739AbZFDKiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739AbZFDKiu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 06:38:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753781AbZFDKim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 06:38:42 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:53885 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450AbZFDKil convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 06:38:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EiekkumncZt2ZyARoOD2QjF1S2oftNTn8Hzb8QydeFkkWGFKO2i/HgsmV4m0pW58+H
         myucvPncubyknUxu+UaF9txQR78jW0sJqyiUdrtShyz94S8lxZY87omis74YpO4bQ1fA
         6z0Gs4onPlTHsFHKd0ajotO9S328p6agy10do=
MIME-Version: 1.0
In-Reply-To: <20090604010250.a168f07f.akpm@linux-foundation.org>
References: <cone.1244020249.943312.16292.1000@arca>
	 <9ea470500906030514q1f52be64x2ff73a3d27ac62fa@mail.gmail.com>
	 <20090603232401.f1897968.peter@piie.net>
	 <20090604010250.a168f07f.akpm@linux-foundation.org>
Date: Thu, 4 Jun 2009 12:38:42 +0200
Message-ID: <9ea470500906040338w1dfc191dhb53477b6327c714d@mail.gmail.com>
Subject: Re: [PATCH] Request driver inclusion - acer aspire one fan control
From: Borislav Petkov <petkovbb@googlemail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Feuerer <peter@piie.net>, Len Brown <len.brown@intel.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jun 4, 2009 at 10:02 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Wed, 3 Jun 2009 23:24:01 +0200 Peter Feuerer <peter@piie.net> wrote:
>
>> Acerhdf is a driver for Acer Aspire One netbooks. It allows to access
>> the temperature sensor and to control the fan.
>>
>> Signed-off-by: Peter Feuerer <peter@piie.net>
>> Reviewed-by: Borislav Petkov <petkovbb@gmail.com>
>> Tested-by: Borislav Petkov <petkovbb@gmail.com>
>>
>>
>> ...
>>
>> +/*
>> + * if you want the module to be started in kernel mode,
>> + * define the following:
>> + */
>> +#undef START_IN_KERNEL_MODE
>
> What does this mean?

when you boot the machine, the BIOS controlls the fan and it, noisy as
it is, gets turned on at temperatures around 35-40°C. However, you can
push that triggering point a bit higher when the machine is idle so that
you don't get annoyed by the noisy fan. Actually, this is what this
driver does.

The current design is that the driver gets loaded but still doesn't
control the fan, as a precaution measure - we trust the BIOS (We didn't
want to kill any user's machine through overheating.) If you turn on the
START_IN_KERNEL_MODE, you circumvent that and the driver takes over the
fan upon module load (I guess this is what you meant). Alternatively,
you can do that over sysfs.

> afacit this functionality is already there at runtime via the
> module/boot parameter, so we don't need the compile-time knob?
>
>> +#define VERSION "0.5.5"
>
> That must be a record version number for an initial submission :)

:)

>> +/*
>> + * According to the Atom N270 datasheet,
>> + * (http://download.intel.com/design/processor/datashts/320032.pdf) the
>> + * CPU's optimal operating limits denoted in junction temperature as
>> + * measured by the on-die thermal monitor are within 0 <= Tj <= 90. So,
>> + * assume 89__C is critical temperature.
>> + */
>> +#define ACERHDF_TEMP_CRIT 89
>> +#define ACERHDF_FAN_AUTO 1
>> +#define ACERHDF_FAN_OFF 0
>> +
>> +/*
>> + * No matter what value the user puts into the fanon variable, turn on the fan
>> + * at 80 degree Celsius to prevent hardware damage
>> + */
>> +#define ACERHDF_MAX_FANON 80
>> +
>> +/*
>> + * Maximal interval between to temperature checks is 20 seconds, as the die
>> + * can get hot really fast under heavy load
>> + */
>> +#define ACERHDF_MAX_INTERVAL 20
>> +
>> +#define ACERHDF_ERROR -0xffff
>
> Gad.  I had to write a C program to check that.  0xffff0001.  I wonder
> if the compiler treats this as a signed or unsigned thing.

it should be signed int.

> Can this be simplified?

This was supposed to be a random invalid value, I guess something like

#define ACERHDF_ERROR ~0

@Peter: Also, acerhdf_set_cur_state() needs a fix around

+       if (state == 0) {
+               /* turn fan off only if below fanoff temperature */
+               if ((cur_state == ACERHDF_FAN_AUTO) &&
+                               (acerhdf_get_temp() < fanoff))

since acerhdf_get_temp() returns the temp _or_ and error. The cleaner
thing should be if acerhdf_get_temp() returned the temp over a pointer
arg just like the thermal callbacks do (e.g. acerhdf_get_ec_temp()) and
you check the return value first and then interpret the temperature as
valid.

>> +
>> +
>> +#ifdef START_IN_KERNEL_MODE
>> +static int kernelmode = 1;
>> +#else
>> +static int kernelmode;
>> +#endif
>> +
>> +static unsigned int interval = 10;
>> +static unsigned int fanon = 63;
>> +static unsigned int fanoff = 58;
>> +static unsigned int verbose;
>> +static unsigned int fanstate = ACERHDF_FAN_AUTO;
>> +static int disable_kernelmode;
>> +static int bios_version = -1;
>> +static char force_bios[16];
>> +static unsigned int prev_interval;
>> +struct thermal_zone_device *acerhdf_thz_dev;
>> +struct thermal_cooling_device *acerhdf_cool_dev;
>> +struct platform_device *acerhdf_device;
>> +
>> +module_param(kernelmode, uint, 0);
>> +MODULE_PARM_DESC(kernelmode, "Kernel mode on / off");
>
> What's kernel mode?  This should be explained in the code somewhere so
> I'm the last to ask.

see above.

>>
>> ...
>>
>> +MODULE_LICENSE("GPL");
>> +MODULE_AUTHOR("Peter Feuerer");
>> +MODULE_DESCRIPTION("Aspire One temperature and fan driver");
>> +MODULE_ALIAS("dmi:*:*Acer*:*:");
>> +MODULE_ALIAS("dmi:*:*Gateway*:*:");
>> +MODULE_ALIAS("dmi:*:*Packard Bell*:*:");
>
> It's a nice-looking driver.

hope this is not irony :).

-- 
Regards/Gruss,
Boris
