Return-Path: <linux-kernel-owner+w=401wt.eu-S1756549AbZCFR6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549AbZCFR6n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 12:58:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755876AbZCFR57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 12:57:59 -0500
Received: from kroah.org ([198.145.64.141]:34425 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754717AbZCFR56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 12:57:58 -0500
Date: Fri, 6 Mar 2009 09:57:08 -0800
From: Greg KH <greg@kroah.com>
To: Christopher Brannon <cmbrannon@cox.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] /dev/time for Linux, inspired by Plan 9
Message-ID: <20090306175708.GD3099@kroah.com>
References: <20090304031238.WCEC18213.eastrmmtao106.cox.net@eastrmimpo03.cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090304031238.WCEC18213.eastrmmtao106.cox.net@eastrmimpo03.cox.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 03, 2009 at 09:06:46PM -0600, Christopher Brannon wrote:
> Under Plan 9 from Bell Labs, one queries or sets the system clock by
> reading or writing text strings to a special file named /dev/time.
> I implemented such a facility for Linux.  A read of /dev/time produces
> four decimal numbers: epoch seconds, nanoseconds since start of epoch,
> jiffies since boot, and jiffies per second.  Writing a decimal number to
> /dev/time sets the system clock to the given number of epoch seconds.
> Anyone who is permitted to write to /dev/time may set the clock.
> Granting this privilege becomes as easy as modifying groups and file
> permissions.
> 
> Signed-off-by: Christopher Brannon <cmbrannon@cox.net>

I'm starting to see a few plan9 specific devices being proposed
recently, with one making it into the staging tree recently (the p9auth
interface).  Should we just start lumping them all together so to keep
them in one place?  drivers/plan9/ ?


> ---
>  Documentation/time-device.txt |   49 ++++++++++++++++++
>  arch/um/Kconfig.char          |   11 ++++
>  drivers/char/Kconfig          |   11 ++++
>  drivers/char/Makefile         |    2 +
>  drivers/char/devtime.c        |  112 +++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 185 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/time-device.txt
>  create mode 100644 drivers/char/devtime.c
> 
> diff --git a/Documentation/time-device.txt b/Documentation/time-device.txt
> new file mode 100644
> index 0000000..6294732
> --- /dev/null
> +++ b/Documentation/time-device.txt
> @@ -0,0 +1,49 @@
> +/dev/time for Linux
> +===================
> +
> +Christopher M. Brannon <cmbrannon@cox.net>
> +
> +Inspiration
> +-----------
> +This document describes an implementation for the Linux kernel of a facility
> +that is provided by the Plan 9 operating system from Bell Laboratories [1].
> +
> +Functionality
> +-------------
> +/dev/time provides a file-based interface to the system clock.
> +Using this interface, one can query or set the system clock by reading or
> +writing text strings.  A read of /dev/time yields four decimal integers:
> +seconds since start of epoch, nanoseconds since start of epoch,
> +jiffies since boot, and jiffies per second.
> +Writing a decimal number n to /dev/time sets the system clock to the
> +date and time which is n seconds greater than January 1, 1970, 00:00:00 GMT.
> +
> +Examples
> +--------
> +cat /dev/time
> +# Produces: 1236121128 123612012877063000 495497 300,
> +# at time of writing on a test machine.
> +echo 287604960 > /dev/time
> +# sets the clock to the approximate time of my birth.
> +
> +Use Case
> +--------
> +Traditionally, super-user privileges were required in order to set the
> +system clock under Linux.
> +Since the advent of capabilities, any process having the CAP_SYS_TIME
> +capability may perform this operation.
> +The /dev/time device ties privileges to file permissions.  If a user
> +can write to /dev/time, then he can set the system clock.
> +
> +Difference from Plan 9
> +-----------------------
> +This implementation differs from Plan 9 in one respect.  the Plan 9
> +Programmer's Manual exactly specifies the format of data read from the
> +device, including the widths of the four numeric fields [1].  This Linux
> +implementation does not pad values with whitespace, so the four fields
> +are of variable width.
> +
> +References
> +----------
> +[1] Plan 9 Programmers Manual, section 3.
> +http://plan9.bell-labs.com/magic/man2html/3/cons
> diff --git a/arch/um/Kconfig.char b/arch/um/Kconfig.char
> index 70dabd1..7d0da78 100644
> --- a/arch/um/Kconfig.char
> +++ b/arch/um/Kconfig.char
> @@ -236,4 +236,15 @@ config MMAPPER
>  	  This driver allows a host file to be used as emulated IO memory inside
>  	  UML.
>  
> +config DEVTIME
> +	tristate "/dev/time virtual device support."
> +	depends on EXPERIMENTAL
> +	help
> +	  This device provides a file-based interface to the system clock.
> +	  The interface is based on the /dev/time device used in the
> +	  Plan 9 operating system from Bell Labs.
> +	  See <file:Documentation/time-device.txt> for a full description.
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called devtime.
> +
>  endmenu
> diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
> index 735bbe2..5bad918 100644
> --- a/drivers/char/Kconfig
> +++ b/drivers/char/Kconfig
> @@ -97,6 +97,17 @@ config DEVKMEM
>  	  kind of kernel debugging operations.
>  	  When in doubt, say "N".
>  
> +config DEVTIME
> +	tristate "/dev/time virtual device support."
> +	depends on EXPERIMENTAL
> +	help
> +	  This device provides a file-based interface to the system clock.
> +	  The interface is based on the /dev/time device used in the
> +	  Plan 9 operating system from Bell Labs.
> +	  See <file:Documentation/time-device.txt> for a full description.
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called devtime.
> +
>  config SERIAL_NONSTANDARD
>  	bool "Non-standard serial port support"
>  	depends on HAS_IOMEM
> diff --git a/drivers/char/Makefile b/drivers/char/Makefile
> index 9caf5b5..aba7403 100644
> --- a/drivers/char/Makefile
> +++ b/drivers/char/Makefile
> @@ -111,6 +111,8 @@ obj-$(CONFIG_PS3_FLASH)		+= ps3flash.o
>  obj-$(CONFIG_JS_RTC)		+= js-rtc.o
>  js-rtc-y = rtc.o
>  
> +obj-$(CONFIG_DEVTIME)		+= devtime.o
> +
>  # Files generated that shall be removed upon make clean
>  clean-files := consolemap_deftbl.c defkeymap.c
>  
> diff --git a/drivers/char/devtime.c b/drivers/char/devtime.c
> new file mode 100644
> index 0000000..5e4ca66
> --- /dev/null
> +++ b/drivers/char/devtime.c
> @@ -0,0 +1,112 @@
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/fs.h>
> +#include <linux/miscdevice.h>
> +#include <linux/time.h>
> +#include <linux/jiffies.h>
> +#include <linux/uaccess.h>
> +
> +MODULE_AUTHOR("Christopher Brannon <cmbrannon79@gmail.com>");
> +MODULE_LICENSE("GPL");
> +
> +const long long NS_PER_SEC = 1000000000;
> +const long long NS_PER_USEC = 1000;
> +const size_t time_bufsize = 256;
> +
> +static ssize_t time_read(struct file *, char __user *, size_t, loff_t *);
> +static ssize_t time_write(struct file *, const char __user *, size_t, loff_t *);
> +
> +static const struct file_operations time_fops = {
> +	.owner = THIS_MODULE,
> +	.read = time_read,
> +	.write = time_write,
> +};
> +
> +static struct miscdevice timedev = {
> +	.minor = MISC_DYNAMIC_MINOR,
> +	.name = "time",
> +	.fops = &time_fops
> +};
> +
> +static int time2text(char *buffer, size_t bufsize)
> +{
> +	int count = 0;
> +	struct timeval tv;
> +	long long nanos;
> +
> +/* jiffies isn't 0 at boot time; its value is INITIAL_JIFFIES. */
> +	u64 ticks = get_jiffies_64() - INITIAL_JIFFIES;

Are you sure this will handle the roll-over properly?

> +	do_gettimeofday(&tv);
> +	nanos = tv.tv_sec * NS_PER_SEC + tv.tv_usec * NS_PER_USEC;
> +	count =
> +	    scnprintf(buffer, bufsize, "%ld %lld %llu %d\n", tv.tv_sec, nanos,
> +		      ticks, HZ);
> +	return count;
> +}
> +
> +static int text2time(char *buffer)
> +{
> +	struct timespec tv;
> +	int result = strict_strtol(buffer, 10, &tv.tv_sec);
> +	if ((result == 0) && (tv.tv_sec > 0)) {
> +		tv.tv_nsec = 0;
> +		do_settimeofday(&tv);
> +	} else
> +		result = -EINVAL;	/* only positive longs are valid. */
> +	return result;
> +}
> +
> +static ssize_t
> +time_read(struct file *f, char __user *buffer, size_t count, loff_t * offset)
> +{
> +	int result = 0;
> +	if (*offset != 0)
> +		result = 0;
> +	else {
> +		char tmpbuf[time_bufsize];

Not good to put 256 bytes on the stack.  Dynamically allocate it?

> +		int timetextlen = time2text(tmpbuf, time_bufsize);
> +		unsigned long readcount = min(count, (size_t) timetextlen);

As was recently pointed out to me, we have min_t() for when you need to
cast like this.

> +		if (timetextlen <= 0)
> +			return -EAGAIN;

If it equals 0, shouldn't you return 0?  And how could it be negative?

thanks,

greg k-h
