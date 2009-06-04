Return-Path: <linux-kernel-owner+w=401wt.eu-S1757420AbZFDIDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420AbZFDIDc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 04:03:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755034AbZFDIDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 04:03:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39117 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757737AbZFDIDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 04:03:00 -0400
Date: Thu, 4 Jun 2009 01:02:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Feuerer <peter@piie.net>
Cc: Borislav Petkov <petkovbb@googlemail.com>, Len Brown <len.brown@intel.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Request driver inclusion - acer aspire one fan control
Message-Id: <20090604010250.a168f07f.akpm@linux-foundation.org>
In-Reply-To: <20090603232401.f1897968.peter@piie.net>
References: <cone.1244020249.943312.16292.1000@arca>
	<9ea470500906030514q1f52be64x2ff73a3d27ac62fa@mail.gmail.com>
	<20090603232401.f1897968.peter@piie.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Jun 2009 23:24:01 +0200 Peter Feuerer <peter@piie.net> wrote:

> Acerhdf is a driver for Acer Aspire One netbooks. It allows to access
> the temperature sensor and to control the fan.
> 
> Signed-off-by: Peter Feuerer <peter@piie.net>
> Reviewed-by: Borislav Petkov <petkovbb@gmail.com>
> Tested-by: Borislav Petkov <petkovbb@gmail.com>
> 
>
> ...
>
> +/*
> + * if you want the module to be started in kernel mode,
> + * define the following:
> + */
> +#undef START_IN_KERNEL_MODE

What does this mean?

afacit this functionality is already there at runtime via the
module/boot parameter, so we don't need the compile-time knob?

> +#define VERSION "0.5.5"

That must be a record version number for an initial submission :)

> +/*
> + * According to the Atom N270 datasheet,
> + * (http://download.intel.com/design/processor/datashts/320032.pdf) the
> + * CPU's optimal operating limits denoted in junction temperature as
> + * measured by the on-die thermal monitor are within 0 <= Tj <= 90. So,
> + * assume 89__C is critical temperature.
> + */
> +#define ACERHDF_TEMP_CRIT 89
> +#define ACERHDF_FAN_AUTO 1
> +#define ACERHDF_FAN_OFF 0
> +
> +/*
> + * No matter what value the user puts into the fanon variable, turn on the fan
> + * at 80 degree Celsius to prevent hardware damage
> + */
> +#define ACERHDF_MAX_FANON 80
> +
> +/*
> + * Maximal interval between to temperature checks is 20 seconds, as the die
> + * can get hot really fast under heavy load
> + */
> +#define ACERHDF_MAX_INTERVAL 20
> +
> +#define ACERHDF_ERROR -0xffff

Gad.  I had to write a C program to check that.  0xffff0001.  I wonder
if the compiler treats this as a signed or unsigned thing.

Can this be simplified?

> +
> +
> +#ifdef START_IN_KERNEL_MODE
> +static int kernelmode = 1;
> +#else
> +static int kernelmode;
> +#endif
> +
> +static unsigned int interval = 10;
> +static unsigned int fanon = 63;
> +static unsigned int fanoff = 58;
> +static unsigned int verbose;
> +static unsigned int fanstate = ACERHDF_FAN_AUTO;
> +static int disable_kernelmode;
> +static int bios_version = -1;
> +static char force_bios[16];
> +static unsigned int prev_interval;
> +struct thermal_zone_device *acerhdf_thz_dev;
> +struct thermal_cooling_device *acerhdf_cool_dev;
> +struct platform_device *acerhdf_device;
> +
> +module_param(kernelmode, uint, 0);
> +MODULE_PARM_DESC(kernelmode, "Kernel mode on / off");

What's kernel mode?  This should be explained in the code somewhere so
I'm the last to ask.

>
> ...
>
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Peter Feuerer");
> +MODULE_DESCRIPTION("Aspire One temperature and fan driver");
> +MODULE_ALIAS("dmi:*:*Acer*:*:");
> +MODULE_ALIAS("dmi:*:*Gateway*:*:");
> +MODULE_ALIAS("dmi:*:*Packard Bell*:*:");

It's a nice-looking driver.
