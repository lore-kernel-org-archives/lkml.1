Return-Path: <linux-kernel-owner+w=401wt.eu-S1760097AbYBSAFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760097AbYBSAFA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 19:05:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753693AbYBSAEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 19:04:53 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:11168 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565AbYBSAEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 19:04:52 -0500
Date: Mon, 18 Feb 2008 16:03:14 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Rodolfo Giometti <giometti@linux.it>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] LinuxPPS core support.
Message-Id: <20080218160314.f6202023.randy.dunlap@oracle.com>
In-Reply-To: <1203377319560-git-send-email-giometti@linux.it>
References: <1203377319975-git-send-email-giometti@linux.it>
	<1203377319560-git-send-email-giometti@linux.it>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Feb 2008 00:28:33 +0100 Rodolfo Giometti wrote:

> This patch adds the kernel side of the PPS support currently named
> "LinuxPPS".
> 
> PPS means "pulse per second" and a PPS source is just a device which
> provides a high precision signal each second so that an application
> can use it to adjust system clock time.
> 
> Common use is the combination of the NTPD as userland program with a
> GPS receiver as PPS source to obtain a wallclock-time with
> sub-millisecond synchronisation to UTC.

Hi,
I'm mostly reading documentation and Kconfig/Makefiles...

> To obtain this goal the userland programs shoud use the PPS API
> specification (RFC 2783 - Pulse-Per-Second API for UNIX-like Operating
> Systems, Version 1.0) which in part is implemented by this patch. It
> provides a set of chars devices, one per PPS source, which can be used
> to get the time signal. The RFC's functions can be implemented by
> accessing to these char devices.
> 
> Signed-off-by: Rodolfo Giometti <giometti@linux.it>
> ---
>  Documentation/ABI/testing/sysfs-pps |   73 ++++++++
>  Documentation/pps/pps.txt           |  170 +++++++++++++++++
>  MAINTAINERS                         |    7 +
>  drivers/Kconfig                     |    2 +
>  drivers/Makefile                    |    1 +
>  drivers/pps/Kconfig                 |   32 ++++
>  drivers/pps/Makefile                |    8 +
>  drivers/pps/kapi.c                  |  272 ++++++++++++++++++++++++++++
>  drivers/pps/pps.c                   |  342 +++++++++++++++++++++++++++++++++++
>  drivers/pps/sysfs.c                 |  130 +++++++++++++
>  include/linux/Kbuild                |    1 +
>  include/linux/pps.h                 |  204 +++++++++++++++++++++
>  12 files changed, 1242 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-pps
>  create mode 100644 Documentation/pps/pps.txt
>  create mode 100644 drivers/pps/Kconfig
>  create mode 100644 drivers/pps/Makefile
>  create mode 100644 drivers/pps/kapi.c
>  create mode 100644 drivers/pps/pps.c
>  create mode 100644 drivers/pps/sysfs.c
>  create mode 100644 include/linux/pps.h
> 
> diff --git a/Documentation/pps/pps.txt b/Documentation/pps/pps.txt
> new file mode 100644
> index 0000000..2af58bd
> --- /dev/null
> +++ b/Documentation/pps/pps.txt
> @@ -0,0 +1,170 @@
> +
> +			PPS - Pulse Per Second
> +			----------------------
> +

...

> +
> +
> +Coding example
> +--------------
> +
> +To register a PPS source into the kernel you should define a struct
> +pps_source_info_s as follow:
> +
> +    static struct pps_source_info_s pps_ktimer_info = {
> +            .name         = "ktimer",
> +            .path         = "",
> +            .mode         = PPS_CAPTUREASSERT | PPS_OFFSETASSERT | \
> +			    PPS_ECHOASSERT | \
> +                            PPS_CANWAIT | PPS_TSFMT_TSPEC,
> +            .echo         = pps_ktimer_echo,
> +            .owner        = THIS_MODULE,
> +    };

Oops, bad struct name "pps_source_info_s".  What's that trailing _s
doing there?  We already know that it's a struct, so it must be
something else.  :)
We don't add such trailing (or leading) type/struct indicators in Linux.

> +
> +and then calling the function pps_register_source() in your
> +intialization routine as follow:
> +
> +    source = pps_register_source(&pps_ktimer_info,
> +			PPS_CAPTUREASSERT | PPS_OFFSETASSERT);
> +
> +The pps_register_source() prototype is:
> +
> +  int pps_register_source(struct pps_source_info_s *info, int default_params)
> +
> +where "info" is a pointer to a structure that describes a particular
> +PPS source, "default_params" tells the system what the initial default
> +parameters for the device should be (is obvious that these parameters
> +must be a subset of ones defined into the struct
> +pps_source_info_s which describe the capabilities of the driver).
> +
> +Once you have registered a new PPS source into the system you can
> +signal an assert event (for example in the interrupt handler routine)
> +just using:
> +
> +    pps_event(source, PPS_CAPTUREASSERT, ptr);
> +
> +The same function may also run the defined echo function
> +(pps_ktimer_echo(), passing to it the "ptr" pointer) if the user
> +asked for that... etc..
> +
> +Please see the file drivers/pps/clients/ktimer.c for an example code.

Drop "an".


> diff --git a/drivers/pps/Kconfig b/drivers/pps/Kconfig
> new file mode 100644
> index 0000000..dce4a1f
> --- /dev/null
> +++ b/drivers/pps/Kconfig
> @@ -0,0 +1,32 @@
> +#
> +# PPS support configuration
> +#
> +
> +menu "PPS support"
> +
> +config PPS
> +	tristate "PPS support"
> +	depends on EXPERIMENTAL
> +	---help---
> +	  PPS (Pulse Per Second) is a special pulse provided by some GPS
> +	  antennae. Userland can use it to get an high time reference.

s/an/a/

"high time reference":  maybe a "high-resolution time reference"?
or "high-precision time reference"?
Just having "high time reference" is missing something...

> +
> +	  Some antennae's PPS signals are connected with the CD (Carrier
> +	  Detect) pin of the serial line they use to communicate with the
> +	  host. In this case use the SERIAL_LINE client support.
> +
> +	  Some antennae's PPS signals are connected with some special host
> +	  inputs so you have to enable the corresponding client support.
> +
> +	  To compile this driver as a module, choose M here: the module
> +	  will be called pps_core.ko.
> +
> +config PPS_DEBUG
> +	bool "PPS debugging messages"
> +	depends on PPS
> +	help
> +	  Say Y here if you want the PPS support to produce a bunch of debug
> +	  messages to the system log.  Select this if you are having a
> +	  problem with PPS support and want to see more of what is going on.
> +
> +endmenu

> diff --git a/drivers/pps/pps.c b/drivers/pps/pps.c
> new file mode 100644
> index 0000000..b3b9af8
> --- /dev/null
> +++ b/drivers/pps/pps.c
> @@ -0,0 +1,342 @@
> +/*
> + * pps.c -- Main PPS support file
> + *

...

> +/*
> + * Module staff

             stuff

> + */

> diff --git a/include/linux/pps.h b/include/linux/pps.h
> new file mode 100644
> index 0000000..5a86109
> --- /dev/null
> +++ b/include/linux/pps.h
> @@ -0,0 +1,204 @@

> +#define PPS_CHECK		_IO('P', 0)
> +#define PPS_GETPARAMS		_IOR('P', 1, struct pps_kparams *)
> +#define PPS_SETPARAMS		_IOW('P', 2, struct pps_kparams *)
> +#define PPS_GETCAP		_IOR('P', 3, int *)
> +#define PPS_FETCH		_IOWR('P', 4, struct pps_fdata *)

Did you add any line(s) to Documentation/ioctl-number.txt ?
If not, please do so.

> +#ifdef __KERNEL__
> +
> +#include <linux/cdev.h>
> +#include <linux/device.h>
> +
> +#define PPS_VERSION		"5.0.0"
> +#define PPS_MAX_SOURCES		16		/* should be enought... */

s/enought/enough/

---
~Randy
