Return-Path: <linux-kernel-owner+w=401wt.eu-S1752789AbYKYQZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789AbYKYQZQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 11:25:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751480AbYKYQZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 11:25:04 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:23465 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbYKYQZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 11:25:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=uEsxN+tV4bs+rtWeR8ymDRMq9ZoXuCDOZrIv+8y9uFtl9DteuhTynB3yje3kJUUgKN
         Hfps3t7+zcysuRzqKX7Hc0T+KwqdfRpVKAOx6tXll3W6NBnG/08tlrxxVQHmdBh64RZV
         kTtHJHlv03VE8l5LotSk0gdcm1lU5tEYi/UOg=
Message-ID: <517f3f820811250824ubb4ca0bn5a8be62a180581e4@mail.gmail.com>
Date: Tue, 25 Nov 2008 11:24:57 -0500
From: "Michael Kerrisk" <mtk.manpages@gmail.com>
To: "Rodolfo Giometti" <giometti@linux.it>
Subject: Re: [PATCH 1/9] LinuxPPS core support.
Cc: linux-kernel@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>,
       "David Woodhouse" <dwmw2@infradead.org>,
       "Dave Jones" <davej@redhat.com>, "Sam Ravnborg" <sam@ravnborg.org>,
       "Greg KH" <greg@kroah.com>, "Michael Kerrisk" <mtk.manpages@gmail.com>,
       "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Kay Sievers" <kay.sievers@vrfy.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <1227542451-31969-2-git-send-email-giometti@linux.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1227542451-31969-1-git-send-email-giometti@linux.it>
	 <1227542451-31969-2-git-send-email-giometti@linux.it>
X-Google-Sender-Auth: 88f521f710214d36
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rodolfo,

Some fixes and comments below.

On Mon, Nov 24, 2008 at 11:00 AM, Rodolfo Giometti <giometti@linux.it> wrote:
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
>
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
>  Documentation/ioctl-number.txt      |    2 +
>  Documentation/pps/pps.txt           |  172 ++++++++++++++++++
>  MAINTAINERS                         |    7 +
>  drivers/Kconfig                     |    2 +
>  drivers/Makefile                    |    1 +
>  drivers/pps/Kconfig                 |   33 ++++
>  drivers/pps/Makefile                |    8 +
>  drivers/pps/kapi.c                  |  322 +++++++++++++++++++++++++++++++++
>  drivers/pps/pps.c                   |  335 +++++++++++++++++++++++++++++++++++
>  drivers/pps/sysfs.c                 |  104 +++++++++++
>  include/linux/Kbuild                |    1 +
>  include/linux/pps.h                 |  202 +++++++++++++++++++++
>  13 files changed, 1262 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-pps
>  create mode 100644 Documentation/pps/pps.txt
>  create mode 100644 drivers/pps/Kconfig
>  create mode 100644 drivers/pps/Makefile
>  create mode 100644 drivers/pps/kapi.c
>  create mode 100644 drivers/pps/pps.c
>  create mode 100644 drivers/pps/sysfs.c
>  create mode 100644 include/linux/pps.h
>
> diff --git a/Documentation/ABI/testing/sysfs-pps b/Documentation/ABI/testing/sysfs-pps
> new file mode 100644
> index 0000000..8cba1d9
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-pps
> @@ -0,0 +1,73 @@
> +What:          /sys/class/pps/
> +Date:          February 2008
> +Contact:       Rodolfo Giometti <giometti@linux.it>
> +Description:
> +               The /sys/class/pps/ directory will contain files and
> +               directories that will provide a unified interface to
> +               the PPS sources.
> +
> +What:          /sys/class/pps/ppsX/
> +Date:          February 2008
> +Contact:       Rodolfo Giometti <giometti@linux.it>
> +Description:
> +               The /sys/class/pps/ppsX/ directory is related to X-th
> +               PPS source into the system. Each directory will
> +               contain files to manage and control its PPS source.
> +
> +What:          /sys/class/pps/ppsX/assert
> +Date:          February 2008
> +Contact:       Rodolfo Giometti <giometti@linux.it>
> +Description:
> +               The /sys/class/pps/ppsX/assert file reports the assert events
> +               and the assert sequence number of the X-th source in the form:
> +
> +                       <secs>.<nsec>#<sequence>
> +
> +               If the source has no assert events the content of this file
> +               is void.

Does "the content of this file is void" mean "the file is empty".  If
so, the latter is clearer, IMO.

> +What:          /sys/class/pps/ppsX/clear
> +Date:          February 2008
> +Contact:       Rodolfo Giometti <giometti@linux.it>
> +Description:
> +               The /sys/class/pps/ppsX/clear file reports the clear events
> +               and the clear sequence number of the X-th source in the form:
> +
> +                       <secs>.<nsec>#<sequence>
> +
> +               If the source has no clear events the content of this file
> +               is void.

See comment above.

> +What:          /sys/class/pps/ppsX/mode
> +Date:          February 2008
> +Contact:       Rodolfo Giometti <giometti@linux.it>
> +Description:
> +               The /sys/class/pps/ppsX/mode file reports the functioning
> +               mode of the X-th source in hexadecimal encoding.
> +
> +               Please, refer to linux/include/linux/pps.h for further
> +               info.
> +
> +What:          /sys/class/pps/ppsX/echo
> +Date:          February 2008
> +Contact:       Rodolfo Giometti <giometti@linux.it>
> +Description:
> +               The /sys/class/pps/ppsX/echo file reports if the X-th source
> +               supports or not an "echo" function.

Better: "does or does not support an "echo" function"

> +
> +What:          /sys/class/pps/ppsX/name
> +Date:          February 2008
> +Contact:       Rodolfo Giometti <giometti@linux.it>
> +Description:
> +               The /sys/class/pps/ppsX/name file reports the name of the
> +               X-th source.
> +
> +What:          /sys/class/pps/ppsX/path
> +Date:          February 2008
> +Contact:       Rodolfo Giometti <giometti@linux.it>
> +Description:
> +               The /sys/class/pps/ppsX/path file reports the path name of
> +               the device connected with the X-th source.
> +
> +               If the source is not connected with any device the content
> +               of this file is void.

See my comment above.

> diff --git a/Documentation/ioctl-number.txt b/Documentation/ioctl-number.txt
> index b880ce5..be021b5 100644
> --- a/Documentation/ioctl-number.txt
> +++ b/Documentation/ioctl-number.txt
> @@ -147,6 +147,8 @@ Code        Seq#    Include File            Comments
>  'p'    40-7F   linux/nvram.h
>  'p'    80-9F                           user-space parport
>                                        <mailto:tim@cyberelk.net>
> +'p'    a0-a4   linux/pps.h             LinuxPPS
> +                                       <mailto:giometti@linux.it>
>  'q'    00-1F   linux/serio.h
>  'q'    80-FF                           Internet PhoneJACK, Internet LineJACK
>                                        <http://www.quicknet.net>
> diff --git a/Documentation/pps/pps.txt b/Documentation/pps/pps.txt
> new file mode 100644
> index 0000000..c558ec3
> --- /dev/null
> +++ b/Documentation/pps/pps.txt
> @@ -0,0 +1,172 @@
> +
> +                       PPS - Pulse Per Second
> +                       ----------------------
> +
> +(C) Copyright 2007 Rodolfo Giometti <giometti@enneenne.com>
> +
> +This program is free software; you can redistribute it and/or modify
> +it under the terms of the GNU General Public License as published by
> +the Free Software Foundation; either version 2 of the License, or
> +(at your option) any later version.
> +
> +This program is distributed in the hope that it will be useful,
> +but WITHOUT ANY WARRANTY; without even the implied warranty of
> +MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +GNU General Public License for more details.
> +
> +
> +
> +Overview
> +--------
> +
> +LinuxPPS provides a programming interface (API) to define into the
> +system several PPS sources.

"define into" is not correct English.  But I'm not sure what you do
mean to say here.

> +PPS means "pulse per second" and a PPS source is just a device which
> +provides a high precision signal each second so that an application
> +can use it to adjust system clock time.
> +
> +A PPS source can be connected to a serial port (usually to the Data
> +Carrier Detect pin) or to a parallel port (ACK-pin) or to a special
> +CPU's GPIOs (this is the common case in embedded systems) but in each
> +case when a new pulse comes the system must apply to it a timestamp

s/comes/arrives/
or
s/comes/occurs/

> +and record it for the userland.

"for userland"

> +
> +Common use is the combination of the NTPD as userland program with a
> +GPS receiver as PPS source to obtain a wallclock-time with
> +sub-millisecond synchronisation to UTC.

Add a couple of commas here.

Common use is the combination of the NTPD as userland program, with a
GPS receiver as PPS source, to obtain a wallclock-time with
sub-millisecond synchronisation to UTC.

> +
> +
> +RFC considerations
> +------------------
> +
> +While implementing a PPS API as RFC 2783 defines and using an embedded
> +CPU GPIO-Pin as physical link to the signal, I encountered a deeper
> +problem:
> +
> +   At startup it needs a file descriptor as argument for the function
> +   time_pps_create().
> +
> +This implies that the source has a /dev/... entry. This assumption is
> +ok for the serial and parallel port, where you can do something
> +useful besides(!) the gathering of timestamps as it is the central
> +task for a PPS-API. But this assumption does not work for a single
> +purpose GPIO line. In this case even basic file-related functionality
> +(like read() and write()) makes no sense at all and should not be a
> +precondition for the use of a PPS-API.
> +
> +The problem can be simply solved if you consider that a PPS source is
> +not always connected with a GPS data source.
> +
> +So your programs should check if the GPS data source (the serial port
> +for instance) is a PPS source too, otherwise they should provide the

s/otherwise/and if not/

> +possibility to open another device as PPS source.
> +
> +In LinuxPPS the PPS sources are simply char devices usually mapped
> +into files /dev/pps0, /dev/pps1, etc..
> +
> +
> +Coding example
> +--------------
> +
> +To register a PPS source into the kernel you should define a struct
> +pps_source_info_s as follow:

s/follow/follows/

> +
> +    static struct pps_source_info pps_ktimer_info = {
> +           .name         = "ktimer",
> +           .path         = "",
> +           .mode         = PPS_CAPTUREASSERT | PPS_OFFSETASSERT | \
> +                           PPS_ECHOASSERT | \
> +                           PPS_CANWAIT | PPS_TSFMT_TSPEC,
> +           .echo         = pps_ktimer_echo,
> +           .owner        = THIS_MODULE,
> +    };
> +
> +and then calling the function pps_register_source() in your
> +intialization routine as follow:

s/follow/follows/

> +    source = pps_register_source(&pps_ktimer_info,
> +                       PPS_CAPTUREASSERT | PPS_OFFSETASSERT);
> +
> +The pps_register_source() prototype is:
> +
> +  int pps_register_source(struct pps_source_info_s *info, int default_params)
> +
> +where "info" is a pointer to a structure that describes a particular
> +PPS source, "default_params" tells the system what the initial default
> +parameters for the device should be (is obvious that these parameters

s/is/it is/

> +must be a subset of ones defined into the struct

"defined into" is not English -- do you mean "defined in"

> +pps_source_info_s which describe the capabilities of the driver).
> +
> +Once you have registered a new PPS source into the system you can
> +signal an assert event (for example in the interrupt handler routine)
> +just using:
> +
> +    pps_event(source, &ts, PPS_CAPTUREASSERT, ptr)
> +
> +where "ts" is the event's timestamp.
> +
> +The same function may also run the defined echo function
> +(pps_ktimer_echo(), passing to it the "ptr" pointer) if the user
> +asked for that... etc..
> +
> +Please see the file drivers/pps/clients/ktimer.c for example code.
> +
> +
> +SYSFS support
> +-------------
> +
> +If the SYSFS filesystem is enabled in the kernel it provides a new class:
> +
> +   $ ls /sys/class/pps/
> +   pps0/  pps1/  pps2/
> +
> +Every directory is the ID of a PPS sources defined into the system and
> +inside you find several files:
> +
> +   $ ls /sys/class/pps/pps0/
> +   assert      clear  echo  mode  name  path  subsystem@  uevent
> +
> +Inside each "assert" and "clear" file you can find the timestamp and a
> +sequence number:
> +
> +   $ cat /sys/class/pps/pps0/assert
> +   1170026870.983207967#8
> +
> +Where before the "#" is the timestamp in seconds and after it is the

Before the "#" is the timestamp in seconds; after it is the

> +sequence number. Other files are:
> +
> +* echo: reports if the PPS source has an echo function or not;
> +
> +* mode: reports available PPS functioning modes;
> +
> +* name: reports the PPS source's name;
> +
> +* path: reports the PPS source's device path, that is the device the
> +  PPS source is connected to (if it exists).
> +
> +
> +Testing the PPS support
> +-----------------------
> +
> +In order to test the PPS support even without specific hardware you can use
> +the ktimer driver (see the client subsection in the PPS configuration menu)
> +and the userland tools provided into Documentaion/pps/ directory.
> +
> +Once you have enabled the compilation of ktimer just modprobe it (if
> +not statically compiled):
> +
> +   # modprobe ktimer
> +
> +and the run ppstest as follow:
> +
> +   $ ./ppstest /dev/pps0
> +   trying PPS source "/dev/pps1"
> +   found PPS source "/dev/pps1"
> +   ok, found 1 source(s), now start fetching data...
> +   source 0 - assert 1186592699.388832443, sequence: 364 - clear  0.000000000, sequence: 0
> +   source 0 - assert 1186592700.388931295, sequence: 365 - clear  0.000000000, sequence: 0
> +   source 0 - assert 1186592701.389032765, sequence: 366 - clear  0.000000000, sequence: 0
> +
> +Please, note that to compile userland programs you need the file timepps.h
> +(see Documentation/pps/).
> diff --git a/MAINTAINERS b/MAINTAINERS
> index d643e86..7fd676e 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3376,6 +3376,13 @@ P:       James Chapman
>  M:     jchapman@katalix.com
>  S:     Maintained
>
> +PPS SUPPORT
> +P:     Rodolfo Giometti
> +M:     giometti@enneenne.com
> +W:     http://wiki.enneenne.com/index.php/LinuxPPS_support
> +L:     linuxpps@ml.enneenne.com (subscribers-only)
> +S:     Maintained
> +
>  PREEMPTIBLE KERNEL
>  P:     Robert Love
>  M:     rml@tech9.net
> diff --git a/drivers/Kconfig b/drivers/Kconfig
> index 2f557f5..4b679d2 100644
> --- a/drivers/Kconfig
> +++ b/drivers/Kconfig
> @@ -52,6 +52,8 @@ source "drivers/i2c/Kconfig"
>
>  source "drivers/spi/Kconfig"
>
> +source "drivers/pps/Kconfig"
> +
>  source "drivers/gpio/Kconfig"
>
>  source "drivers/w1/Kconfig"
> diff --git a/drivers/Makefile b/drivers/Makefile
> index fceb71a..da6329a 100644
> --- a/drivers/Makefile
> +++ b/drivers/Makefile
> @@ -67,6 +67,7 @@ obj-$(CONFIG_INPUT)           += input/
>  obj-$(CONFIG_I2O)              += message/
>  obj-$(CONFIG_RTC_LIB)          += rtc/
>  obj-y                          += i2c/
> +obj-$(CONFIG_PPS)              += pps/
>  obj-$(CONFIG_W1)               += w1/
>  obj-$(CONFIG_POWER_SUPPLY)     += power/
>  obj-$(CONFIG_HWMON)            += hwmon/
> diff --git a/drivers/pps/Kconfig b/drivers/pps/Kconfig
> new file mode 100644
> index 0000000..cc2eb8e
> --- /dev/null
> +++ b/drivers/pps/Kconfig
> @@ -0,0 +1,33 @@
> +#
> +# PPS support configuration
> +#
> +
> +menu "PPS support"
> +
> +config PPS
> +       tristate "PPS support"
> +       depends on EXPERIMENTAL
> +       ---help---
> +         PPS (Pulse Per Second) is a special pulse provided by some GPS
> +         antennae. Userland can use it to get a high-precision time

Antennas is I believe the more common English plural.

> +         reference.
> +
> +         Some antennae's PPS signals are connected with the CD (Carrier

Antennas'

> +         Detect) pin of the serial line they use to communicate with the
> +         host. In this case use the SERIAL_LINE client support.
> +
> +         Some antennae's PPS signals are connected with some special host

Antennas'

> +         inputs so you have to enable the corresponding client support.
> +
> +         To compile this driver as a module, choose M here: the module
> +         will be called pps_core.ko.
> +
> +config PPS_DEBUG
> +       bool "PPS debugging messages"
> +       depends on PPS
> +       help
> +         Say Y here if you want the PPS support to produce a bunch of debug
> +         messages to the system log.  Select this if you are having a
> +         problem with PPS support and want to see more of what is going on.

Cheers,

Michael

-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/ Found a documentation bug?
http://www.kernel.org/doc/man-pages/reporting_bugs.html
