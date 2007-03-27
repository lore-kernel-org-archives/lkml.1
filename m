Return-Path: <linux-kernel-owner+w=401wt.eu-S1753293AbXC0IgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293AbXC0IgP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 04:36:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbXC0IgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 04:36:15 -0400
Received: from nz-out-0506.google.com ([64.233.162.231]:6224 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293AbXC0IgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 04:36:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:x-priority:message-id:to:cc:subject:mime-version:content-type:content-transfer-encoding;
        b=WmR8QIESEKPd503MJyxsklJ3vIstce4Ho4gEs76YmhJvqPujW6HU2A3KBiot8VIDcNHTTPQrwfrleVgRm0fhCHShZh5o8UT8mJ+H/6iDXtSSwX+kBXfyNQ/AdHOCXrrfbN373BEXdr4ja+jt7krJgVjbtVPOO1GMQMlqqAZfVmM=
Date: Tue, 27 Mar 2007 11:36:10 +0300
From: Paul Sokolovsky <pmiscml@gmail.com>
X-Priority: 3 (Normal)
Message-ID: <881020209.20070327113610@gmail.com>
To: linux-kernel@vger.kernel.org
CC: kernel-discuss@handhelds.org, Anton Vorontsov <cbou@mail.ru>
Subject: [RFC] Virtual methods for devices and generalized GPIO support using it
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello LKML,

We, HandHelds.org, for quite some time are working on generilized support
for consumer handheld devices (with primary focus on ARM-based PocketPC's
ans smartphones). While we made big progress in many areas, we still
were no able to put all the part of riddle together, producing clean and
manageable for dozens of project machines (we have ~30 ports in our kernel,
with ~20 well, or sufficiuently, developed, and a hundred in queue).

One of the pressing problem we had is code duplication even to support 
simple features, like USB connection support, RS232 port support, BT
support, etc. To the large part drivers for such features consist of
the inititialization of common architecture-provided code/drivers, and
activating machine-specific support hardware like transceivers, etc.
This activation most of the time is handled by turning on some GPIO 
lines, but the problem that our target machine set has wild varying
GPIO architecture. Besides CPU-builtin GPIOs, almost every model has
GPIOs on some SoC-type peripheral controller or GPIO extender 
(in turn ranging from latches on CPU bus to connected to I2C, etc.).
What we get is dozens of shim drivers, which for 30 template lines
have 2-3 lines of real content. Submitting them for inclusion would 
treated like spamming kernel tree, right? ;-)

Recently, Generic GPIO framework was proposed, and merged into 2.6.21-rc,
which is big step forward. But its scope is still to provide common
GPIO API for different *architectures*, not devices. It makes it possible
to minipulate GPIOs on PXA, OMAP, S3Cxxxx in the same way, but does not
allow other GPIO-providing devices to leverage this framework. 
HandHelds.org developers draw attention to this and asked to extend
scope and solve all GPIO-related problems (see for example
http://lkml.org/lkml/2007/1/1/111), however, it was omitted from the first
round of Generic GPIO API.

So, I would like to propose a solution for GPIO extension problem, and
moreover, a pattern, or paradigm, to solve such kind of problem. This
latter aim is probably not less important than the specific aim of
solving GPIO namespace problem. I have to say from the start that proposed
solution is of course not new - vice versa, it is well known and proved
solution to solve polymorphism problems ("different things do something in
similar ways, or with similar outcome"). That's why I use words pattern and
paradigm - I'd like to propose to leverage this technique for Linux kernel
driver writing, and if that would be accepted, to shape it in such way that
it will be easily recognizable and people will not spend time "reinventing" 
it, or hesitating if it's usable or not.


Well, idea is simple. For any device which provides GPIOs, we can define
standard GPIO operation. We can express them via specifying function 
(method) signatures and describing semantics behind them. Minimal 
operation set for GPIO would be:

int get(int gpio_no)
        Get value of GPIO with number gpio_no, return 0 if it is not set,
        non-zero if it set.
void set(int gpio_no, int val)
        Set value of GPIO with number gpio_no: if val is non-zero, set it 
        high, otherwise, low.

In terms of object-oriented programming, this definition called Interface.
So, we define interface which GPIO-provding devices should implement, and
details of implementation will be different for different devices. As long
as they conform to interface, all we need to perform a GPIO operation is
reference to owning device and its local gpio number, that's all. Device
itself will handle actual operations, and in this respect, it must implement
interface using what in OOP called virtual methods.

That's all for idea. The rest is just peculiarity of implementation within
bounds of existing Linux Kernel infrastructure (LDM model first of all).

Proposed implementation is:

1. Virtual methods are represented by function pointers (which is standard).
2. Virtual methods for some interface are groupped to structure called VTABLE
(common name).
3. Methods are defined for device, so must be accessed using it. LDM uses
struct device to represent a device, so methods must be accessible using a
reference to struct device.
4. Relatively few devices will use virtual methods, so no talk about extending
struct device itself. Instead, existing means of struct device extension will 
be used.
5. Methods are of course public notion of a device, so it is proposed to makes
them accessible via platform_data member (and nor for example, driver_data).
Thus, VTABLE will be just part of platform_data structure for a device, 
together with other data specific for a device.
6. What will fill actual method pointers in VTABLE? It is proposed that - of 
course - a driver both implements virtual methods and initializes VTABLE 
structure. This is of course perfect fit with LDM paradigm - device 
structures define actual device properties, and driver what implements 
handling of device behavior. This holds true for virtual methods approach,
except that it allows to define polymorhic behavior with guaranteed interface
across different drivers. 
7. Note that in p.6 uses opposite data flow for VTABLE to what is currently
mostly used for platform_data. As it is now, it is assumed that platform_data
serves as "input data" for driver. It's pretty common to pass method pointers
via paltform_data - but those methods are still for driver to use. Virtual
methods paradigm works the other way - it's driver exports its methods for
the rest of the world to use via VTABLE, a part for platform_data.

Actual implementation:

Standard VTABLE syntax
==== vtable.h =====
/* Virtual Method Table support - experimental */

/* A way to reference vtable */
#define VTABLE(interface) interface##_methods

/* A way to have vtable definined. This should be put as 
   the first member of enclosing struct */
#define VTABLE_DEFINE(interface) \
        struct interface##_methods interface##_methods

/* A way to reference method. Result is pointer to method, 
   so it can be called, checked for NULL, etc */
#define METHOD(device, interface, method) \
        (((struct interface##_methods*)((device)->platform_data))->method)
==================

Example of interface definition:
===== gpiodev.h =====
// Interface

struct VTABLE(gpio) {
        int (*get)(struct device *this, int gpio_no);
        void (*set)(struct device *this, int gpio_no, int val);
        int (*to_irq)(struct device *this, int gpio_no);
};
=====================


(Note that methods are of course receive "this" pointer to owning device.)


Example of adding interface for some device (ASIC3 is SoC chip):
==== asic3_base.h ====
struct asic3_platform_data
{
        VTABLE_DEFINE(gpio);

        unsigned long bus_shift;
        ...
}
======================

Example of virtual method implementation and VTABLE 
initialization in driver:
==== asic3_base.c =====
static int asic3_get_gpio_bit(struct device *dev, int gpio)
{
        ...
}
...

static int asic3_probe(struct platform_device *pdev)
{

        ...
        pdata->VTABLE(gpio).get = asic3_get_gpio_bit;
        pdata->VTABLE(gpio).set = asic3_set_gpio_bit;
        pdata->VTABLE(gpio).to_irq = asic3_gpio_to_irq;
        ...
}
=======================

Example of usage:
===========
struct platform_device *asic3;

int val = METHOD(&asic3.dev, gpio, get)(&asic3.dev, GPIO_IN_NO);
METHOD(&asic3.dev, gpio, set)(&asic3.dev, GPIO_OUT_NO, val);
===========


Arguably, the syntax is still verbose even with METHOD() macro.
Convenience definitions are proposed:

====== gpiodev.h, continuation ======
// Generalized GPIO structure
struct gpio {
        struct platform_device *gpio_dev;
        int gpio_no;
};

// Convenience wrappers
static inline int gpio_dev_get(struct gpio *gpio)
{
        return METHOD(&gpio->gpio_dev->dev, gpio, get)(&gpio->gpio_dev->dev, gpio->gpio_no);
}
static inline void gpio_dev_set(struct gpio *gpio, int val)
{
        METHOD(&gpio->gpio_dev->dev, gpio, set)(&gpio->gpio_dev->dev, gpio->gpio_no, val);
}
static inline int gpio_dev_to_irq(struct gpio *gpio)
{
        return METHOD(&gpio->gpio_dev->dev, gpio, to_irq)(&gpio->gpio_dev->dev, gpio->gpio_no);
}
=======================================


After seeing this last part, someone may ask - why all these VTABLE, etc. 
then, if in the end it is just conventional API with usual function names?
The asswer is simple, and was alreday given above: I would like to propose
virtual method as useful and reusable pattern. There're more interfaces than
"gpio" to define, and more usecases for its usage than generalizing GPIO
access (for example, we used it for abstracting touchscreen drivers away from
teh underlying ADC chips used).

In this respect, VTABLE(), METHOD() macros serve the same purpose as 
container_of() and list_for_each() - they are besides offering (more) 
convenient syntax, also carry important annotattion and educational
messages, like "it's ok, and encouraged to embed one structure into 
another - use it!" or "list manipulation is a trivial operation for kernel,
and we want you to treat it as such and use in standard, easily 
distinguishable way".


Thank you for your review and suggestions,

-- 
 Paul                          mailto:pmiscml@gmail.com

