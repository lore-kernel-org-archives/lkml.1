Return-Path: <linux-kernel-owner+w=401wt.eu-S936205AbYD1X2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936205AbYD1X2j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 19:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934488AbYD1X2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 19:28:20 -0400
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:40446 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933118AbYD1X2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 19:28:17 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=q9RGcW2z/+euvmq8bMAmhuAEJG2w+KgX0NaNIAxuvDo+GjTyvNqoZo7YZI4CJgDwiNDcO7WSIc6XY1Xl0EqKruTrg9IWKaNw979LEhdPZVOxoo5Q6x1TycaLyz9kSKtSuET8wndgNpLkwUJyke1ydlzR87SxtjTYS/qoKcIAPr8=  ;
X-YMail-OSG: Q_YIfNQVM1nX6FkQiik04yb0deK1ZZojb7lfdtmsIjFN4FN.8y21JuxjsFaGnXyuMqbdZVQtgORfPdYfEKCQBJpxLFsXAGoEFSHSDhfmx_TAqserW3bdIdQUjWSe_lx0JSM-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch/rfc 2.6.25-git] gpio: sysfs interface
Date: Mon, 28 Apr 2008 16:28:13 -0700
User-Agent: KMail/1.9.6
Cc: lkml <linux-kernel@vger.kernel.org>, Trent Piepho <tpiepho@freescale.com>,
       hartleys <hartleys@visionengravers.com>,
       Ben Nizette <bn@niasdigital.com>, Mike Frysinger <vapier.adi@gmail.com>,
       Bryan Wu <cooloney@kernel.org>, Greg KH <greg@kroah.com>
References: <200804281239.51729.david-b@pacbell.net> <20080428134649.44cf239c.akpm@linux-foundation.org>
In-Reply-To: <20080428134649.44cf239c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804281628.14004.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 April 2008, Andrew Morton wrote:
> On Mon, 28 Apr 2008 12:39:51 -0700 David Brownell <david-b@pacbell.net> wrote:
> 
> > Simple sysfs interface for GPIOs.
> > 
> >     /sys/class/gpio
> >         /gpio-N ... for each exported GPIO #N
> > 	    /value ... always readable, writes fail except for output GPIOs
> > 	    /direction ... writable as: in, out (default low), high, low
> >     	/control ... to request a GPIO be exported or unexported
> > 
> > GPIOs may be exported by kernel code using gpio_export(), which should
> > be most useful for driver debugging.  Userspace may also ask that they
> > be exported by writing to the sysfs control file, helping to cope with
> > incomplete board support:
> > 
> >   echo "export 23" > /sys/class/gpio/control
> > 	... will gpio_request(23, "sysfs") and gpio_export(23); use
> > 	/sys/class/gpio/gpio-23/direction to configure it.
> >   echo "unexport 23" > /sys/class/gpio/control
> > 	... will gpio_free(23)
> 
> hm, does ths sysfs one-value-per-file rule apply to writes?

That *is* one value:  a single command, to execute atomically!  :)

ISTR seeing that done elsewhere, and have seen various proposals
that rely on that working.  In any case, the one-per-file rationale
was to make things easier for userspace.


> > The D-space footprint is negligible, except for the sysfs resources
> > associated with each exported GPIO.  The additional I-space footprint
> > is about half of the current size of gpiolib.  No /dev node creation
> > involved, and no "udev" support is needed.
> > 
> > 		...
> > 		
> 
> Documentation for the interface?

Next version.  If the "is this interface OK" part of the RFC flies,
then additional effort on docs would not be wasted.


> > +#include <linux/device.h>
> > +#include <linux/err.h>
> 
> Putting includes inside ifdefs tends to increase the risk of compilation
> errors.

Good point, I'll move such stuff out of #ifdefs.  I almost
did that this time, but this way made for a simpler patch.  ;)


> > +static ssize_t gpio_direction_show(struct device *dev,
> > +		struct device_attribute *attr, char *buf)
> > +{
> > +	const struct gpio_desc	*desc = dev_get_drvdata(dev);
> > +
> > +	/* handle GPIOs being removed from underneath us... */
> > +	if (!test_bit(FLAG_EXPORT, &desc->flags))
> > +		return -EIO;
> > +
> > +	return sprintf(buf, "%s\n",
> > +		test_bit(FLAG_IS_OUT, &desc->flags) ? "out" : "in");
> > +}
> 
> What prevents FLAG_EXPORT from getting cleared just after we tested it?
> 
> iow: this looks racy.

Yeah, the isue there is that the attribute files may
still be open after the GPIO has been unexported.  For
this specific method the existing spinlock can solve
that problem ... but not in general.

Seems like a general fix for that should involve a mutex
covering all those sysfs actions:  read, write, export,
and unexport.  The unexport logic would need reworking,
but the rest could work pretty much as they do now (but
while holding that lock, which would protect that flag).

But that wouldn't change the user experience; the sysfs
attributes would still look and act the same.


> > +	if (buf[len - 1] == '\n')
> > +		len--;
> > +
> > +	if (len == 4 && strncmp(buf, "high", 4) == 0)
> > +		status = gpio_direction_output(gpio, 1);
> > +
> > +	else if (len == 3 && (strncmp(buf, "out", 3) == 0
> > +			|| strncmp(buf, "low", 3) == 0))
> > +		status = gpio_direction_output(gpio, 0);
> > +
> > +	else if (len == 2 && strncmp(buf, "in", 2) == 0)
> > +		status = gpio_direction_input(gpio);
> 
> urgh.
> 
> If we had a strcmp() variant which treats a \n in the first arg as a \0
> the above would become
> 
> 	if (sysfs_streq(buf, "high"))
> 		status = gpio_direction_output(gpio, 1);
> 	else if (sysfs_streq(buf, "out") || sysfs_streq(buf, "low"))
> 		status = gpio_direction_output(gpio, 0);
> 	else if (sysfs_streq(buf, "in"))
> 		status = gpio_direction_input(gpio);

That would indeed be better.  Maybe I should whip up a sysfs
patch adding that, and have this depend on that patch.  (I've
CC'd Greg in case he has comments on that...)

Alternatively:  strict_streq(), analogy to strict_strto*()?


> > +void gpio_unexport(unsigned gpio)
> > +{
> > +	unsigned long		flags;
> > +	struct gpio_desc	*desc;
> > +	int			status = -EINVAL;
> > +
> > +	if (!gpio_is_valid(gpio))
> > +		return;
> 
> Is that a programming error?

Yes.  But as with quite a lot of "rmmod" type paths, there's
no way to report it to the caller.  I'll add a pr_debug().


> > +/*
> > + * /sys/class/gpio/control ... write-only
> > + *	export N
> > + *	unexport N
> > + */
> > +static ssize_t control_store(struct class *class, const char *buf, size_t len)
> > +{
> > +	char *scratch = (char *)buf;
> > +	char *cmd, *tmp;
> > +	int status;
> > +	unsigned long gpio;
> > +
> > +	/* export/unexport */
> > +	cmd = strsep(&scratch, " \t\n");
> 
> urgh.  We cast away the const and then smash up the caller's const string
> with strsep.

Yeah, kind of ugly.  Not particularly happy with that, but
I wasn't keen on allocating a temporary copy of that string
either...


> > +	if (!cmd)
> > +		goto fail;
> > +
> > +	/* N */
> > +	tmp = strsep(&scratch, " \t\n");
> > +	if (!tmp)
> > +		goto fail;
> > +	status = strict_strtoul(tmp, 0, &gpio);
> > +	if (status < 0)
> > +		goto done;
> > +
> > +	/* reject commands with garbage at end */
> 
> strict_strtoul() already does that?

So it does.  That was leftover from a version with
a more complex control interface.  Easy to remove
the lines'o'code following *that* comment!


> > +	...
> 
> The string handling in here seems way over-engineered.  All we're doing is
> parting "export 42" or "unexport 42".  Surely it can be done better than
> this.
> 
> The more sysfs-friendly way would be to create separate sysfs files for the
> export and unexport operations, I expect.

Or just use negative numbers to mean "unexport";
ugly and hackish, but functional.

I don't want to see the components of one command
split into separate files, where they could be
clobbered by a second userspace activity ...
 

> > ...
> >
> > -#else
> > +#ifdef CONFIG_GPIO_SYSFS
> > +#define HAVE_GPIO_SYSFS
> 
> Can we find a way to make HAVE_GPIO_SYSFS go away?  Just use
> CONFIG_GPIO_SYSFS?

Yes, see below ... there's a minor penalty to be paid.


> > @@ -135,4 +150,15 @@ static inline void gpio_set_value_cansle
> >  
> >  #endif
> >  
> > +#ifndef HAVE_GPIO_SYSFS
> > +static inline int gpio_export(unsigned gpio)
> > +{
> > +	return -ENOSYS;
> > +}
> > +
> > +static inline void gpio_unexport(unsigned gpio)
> > +{
> > +}
> > +#endif	/* HAVE_GPIO_SYSFS */
> > +
> >  #endif /* _ASM_GENERIC_GPIO_H */
> 
> Then this can just be moved into a #else.

I'll just make it #ifndef CONFIG_GPIO_SYSFS ... that will make the
interface impossible to provide without gpiolib, but I'm not much
concerned about that.

Note that putting it *here* covers the case of platforms that provide
standard GPIO interfaces but don't use the newish gpiolib code to do
that ... which is why putting it in an #else (above) didn't suffice.


