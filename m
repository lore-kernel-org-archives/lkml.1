Return-Path: <linux-kernel-owner+w=401wt.eu-S1755794AbZISAmJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794AbZISAmJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 20:42:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751394AbZISAmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 20:42:05 -0400
Received: from exprod6og108.obsmtp.com ([64.18.1.21]:34273 "HELO
	exprod6og108.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750975AbZISAmE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 20:42:04 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] gpiolib: introduce for_each_gpio_in_chip macro
Date: Fri, 18 Sep 2009 20:42:06 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901D41FBD@mi8nycmail19.Mi8.com>
In-Reply-To: <45a44e480909181703l7b1ef8a1lf00fdd53aebfb523@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] gpiolib: introduce for_each_gpio_in_chip macro
Thread-Index: Aco4vJ6lyygUFrMoTESEF/gwacGD2QAAamBQ
References: <200907311027.06370.hartleys@visionengravers.com> <200908041414.26112.david-b@pacbell.net> <BD79186B4FD85F4B8E60E381CAEE190901B7783E@mi8nycmail19.Mi8.com> <1249529480.16688.13.camel@ben-desktop> <45a44e480909181703l7b1ef8a1lf00fdd53aebfb523@mail.gmail.com>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "Jaya Kumar" <jayakumar.lkml@gmail.com>,
       "Ben Nizette" <bn@niasdigital.com>
Cc: "David Brownell" <david-b@pacbell.net>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 19 Sep 2009 00:42:05.0776 (UTC) FILETIME=[02F2D500:01CA38C2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, September 18, 2009 5:03 PM, Jaya Kumar wrote:
> On Thu, Aug 6, 2009 at 11:31 AM, Ben Nizette <bn@niasdigital.com> wrote:
>> On Tue, 2009-08-04 at 20:48 -0400, H Hartley Sweeten wrote:
>>
>>> For the record. The reason I sent this is I'm trying to work out an
>>> extension to gpiolib that adds gpio_port_* access to the API.  Most
>>> of the gpiolib drivers already the necessary logic since the raw I/O
>>> is performed on the entire 'chip'.  The API just needs the extensions
>>> added to request/free the port, set the direction and get/set the value.
>>>
>>> Is this a worthwhile addition?
>>
>> Plenty of people seem to think so.  Personally I haven't seen a great
>> use case except "'coz I can", but if you've got one I'd love to hear.
>
> Yes, you're right that there has been no major demand for it. There
> are (luckily?) only a moderate number of devices that are using gpio
> as their parallel bus interface. I've been supporting the batch-gpio
> patchset below out-of-the-tree because it has come in handy with a few
> e-paper display controllers and LCD 8080-IO that I've been developing
> with.

With the abundant number of GPIO's available on many of the ARM chips it
seemed to me a "port" extension would be worthwhile.  It would allow a
side-band bus from the chip to access low-speed devices like a character
LCD as an example.

>>
>> Have you seen http://lkml.org/lkml/2009/1/25/10 ?  Donno what ended up
>> happening to that patchset..
>>
>
> I didn't pursue it further and have maintained it out-of-tree. I felt
> that David had concerns about the API I implemented so it was unlikely
> to get merged and I didn't have the motivation to implement another.
> :-)

Hmm.. That patchset is a lot different than what I was thinking of.  Your 
patch allows a variable width to the number of gpio's in the "port".  But
it also still gets/sets the "port" by individual bit accesses to the
gpio_chip.  By doing this I don't see how you could get a performance
increase.

The extension I was working on just allowed accessing the native width
of the gpio chip.  Most of the gpiolib drivers read/write the bits in a
native width, the individual gpio pin is masked in/out.  My patch just
allows access to the raw data without masking anything.

Take the .get method in pca953x.c driver as an example.

static int pca953x_gpio_get_value(struct gpio_chip *gc, unsigned off)
{
	struct pca953x_chip *chip;
	uint16_t reg_val;
	int ret;

	chip = container_of(gc, struct pca953x_chip, gpio_chip);

	ret = pca953x_read_reg(chip, PCA953X_INPUT, &reg_val);
	if (ret < 0) {
		/* NOTE:  diagnostic already emitted; that's all we should
		 * do unless gpio_*_value_cansleep() calls become different
		 * from their nonsleeping siblings (and report faults).
		 */
		return 0;
	}

	return (reg_val & (1u << off)) ? 1 : 0;
}

The native width of the device is either 8 or 16 bits.  To get a gpio value
all of the bits are read then the desired gpio is masked out.

My thought was to just add the following methods to struct gpio_chip:

int			(*port_direction_input)(struct gpio_chip *chip);
unsigned int	(*port_get)(struct gpio_chip *chip);
int			(*port_direction_output)(struct gpio_chip *chip, unsigned int value);
void			(*port_set)(struct gpio_chip *chip,	unsigned int value);

I basically stopped working on this after Ben's comment and getting
no other feedback.  If this appears useful I can look at it again.

> Thanks,
> jaya
> 
> ps: I'm in Portland for the festival of linux conferences this week
> and would be happy to work on this/discuss alternate APIs if it is of
> interest.

Regards,
Hartley
