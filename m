Return-Path: <linux-kernel-owner+w=401wt.eu-S1760762AbYD2STP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760762AbYD2STP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 14:19:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758405AbYD2SS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 14:18:57 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:39704 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758327AbYD2SS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 14:18:56 -0400
Date: Tue, 29 Apr 2008 11:15:30 -0700 (PDT)
From: Trent Piepho <tpiepho@freescale.com>
X-X-Sender: xyzzy@t2.domain.actdsltmp
To: Ben Nizette <bn@niasdigital.com>
cc: David Brownell <david-b@pacbell.net>, lkml <linux-kernel@vger.kernel.org>,
       hartleys <hartleys@visionengravers.com>,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
Subject: Re: [patch/rfc 2.6.25-git] gpio: sysfs interface
In-Reply-To: <1209472526.311.50.camel@moss.renham>
Message-ID: <Pine.LNX.4.64.0804291022190.15041@t2.domain.actdsltmp>
References: <200804281239.51729.david-b@pacbell.net> 
 <Pine.LNX.4.64.0804281507160.6832@t2.domain.actdsltmp> 
 <200804281745.59442.david-b@pacbell.net>  <Pine.LNX.4.64.0804282202340.8286@t2.domain.actdsltmp>
 <1209472526.311.50.camel@moss.renham>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2008, Ben Nizette wrote:
> On Mon, 2008-04-28 at 22:48 -0700, Trent Piepho wrote:
>> On Mon, 28 Apr 2008, David Brownell wrote:
>>> On Monday 28 April 2008, Trent Piepho wrote:
>>>> I liked it better they way I had it, "label:N".
>>>
>>> Those labels may not be available though; or valid in pathnames.
>>
>> So just fall back to "gpio" if there is no label?  The only character that's
>> not valid in a pathname is '/', so that's trivial to check for.
>>
>> const char *label = chip->label && !strchr(chip->label, '/') ?
>>  	chip->label : "gpio"; /* or "generic" or "unknown", or ...*/
>>
>> This means you don't need a file with number to device assignents.  It makes
>> shell scripting a lot easier too.  Say I want the first gpio on a pca9557 gpio
>> expander?  It's will be something like:  /sys/class/gpio/pca9557-0:0
>>
>> You don't have to worry about dynamic assigments.  You don't have to resort to
>> convoluted shell script code to extract the proper range from a mapping file
>> and then construct the name.
>
> Sorry if I'm being dense; how do you want this bit to work?  As I see
> it, there are a few options:
>
> 1) Have the files named as you suggest and all of them always present,
> albeit read-only until export.  Very easy to use, easy to discover which
> file is which, a decent bit of memory usage having them all listed.

Well, is it really that much?  There are 579 files under /sys/class/tty.  But
suppose it is too much (why isn't tty too much then?), then we can do 3.

> 3) Have the files named as you suggest, explicit export/request but
> better parsing behind the control file so something like
> echo "export pca9557-0:5" > control
> works.  Very very nice for the user, big heavy back end.

The back end doesn't seem that big to me.  Here's code for it.  If anything,
the parsing code is simpler than what David has.  It's certainly not huge. 
David's code for parsing the control file plus code for generating a mapping
range file would certainly be larger.


/* Format:  -?(chiplabel:)?number
  * The optional leading - unexports the gpio, without it the gpio is exported.
  * The optional chip label followed by a : gives you the Nth gpio of that
  * chip.  With no label you get gpio "number".
  */

static ssize_t control_store(struct class *class, const char *buf, size_t len)
{
 	const char *numstr;
 	unsigned long num;
 	int mode = 0;

 	if (buf[0] == '-') { /* un-export? */
 		mode = 1;
 		buf++;
 	}

 	numstr = strrchr(buf, ':');

 	/* Get GPIO number */
 	if (strict_strtoul(numstr ? numstr + 1 : buf, 0, &num))
 		return -EINVAL;

 	/* Match chip label, if one was specified */
 	if (numstr) {
 		/* No + 1 in len to not include the ':' at the end */
 		int i, len = numstr - buf;
 		const struct gpio_chip *chip = NULL;

 		for (i = 0; gpio_is_valid(i); i++) {
 			if (chip == gpio_desc[i].chip)
 				continue;
 			chip = gpio_desc[i].chip;
 			if (!chip)
 				continue;

 			if (!strncmp(buf, chip->label, len) &&
 			    chip->label[len] == '\0')
 				goto found_chip;
 		}
 		return -EINVAL;
found_chip:
 		if (num >= chip->ngpio)
 			return -EINVAL;
 		num += chip->base;
 	}

 	if (mode) {
 		/* Unexport */
 		if (!gpio_is_valid(num))
 			return -EINVAL;
 		if (!test_and_clear_bit(FLAG_SYSFS, &gpio_desc[num].flags))
 			return -EINVAL;

 		gpio_free(num);
 	} else {
 		/* Export */
 		int status = gpio_request(num, "sysfs");

 		if (status < 0)
 			return status;

 		status = gpio_export(num);
 		if (status < 0) {
 			gpio_free(num);
 			return status;
 		}

 		set_bit(FLAG_SYSFS, &gpio_desc[num].flags);
 	}

 	return len;
}
