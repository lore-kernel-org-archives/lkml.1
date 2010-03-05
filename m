Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757Ab0CEBQU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 20:16:20 -0500
Received: from us-mx4.synaptics.com ([12.178.49.178]:52982 "EHLO
	us-mx4.synaptics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270Ab0CEBQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 20:16:18 -0500
X-PGP-Universal: processed;
	by securemail.synaptics.com on Thu, 04 Mar 2010 16:14:57 -0800
Message-ID: <4B905B59.8020209@synaptics.com>
Date: Thu, 4 Mar 2010 17:16:09 -0800
From: Christopher Heiny <cheiny@synaptics.com>
Organization: Synaptics, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Allie Xiong <axiong@synaptics.com>,
       William Manson <WManson@synaptics.com>
Subject: Re: [RFC PATCH 1/1] input/touchscreen: Synaptics Touchscreen Driver
References: <1266446258-16209-1-git-send-email-cheiny@synaptics.com> <1266446258-16209-3-git-send-email-cheiny@synaptics.com> <20100302091246.GA21014@core.coreip.homeip.net>
In-Reply-To: <20100302091246.GA21014@core.coreip.homeip.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/2010 01:12 AM, Dmitry Torokhov wrote:
> Hi Christofer,

Hi Dmitry!

Thanks for reviewing our patch.  We plan to address all the issues you 
brought up, and submit an updated patch around the middle of this month 
correcting the majority of them (anything not corrected will be TODOed 
so they don't get lost).

I've included replies to your comments (mostly of the "Noted, will act" 
sort) below.  For brevity, some chunks of the quoted text are snipped 
out, presumably folks needing more context can obtain that from the 
original patch.

				Cheers,
					Chris


> On Wed, Feb 17, 2010 at 02:37:38PM -0800, Christopher Heiny wrote:
>> Initial driver for Synaptics touchscreens using RMI4 protocol.
>>
>
> I assume that since you sent it with git-send-email it was your
> corporate mail server that murdered all identation and whitespace.
> Please try sending next version using alternative server, like gmail or
> maybe your personal account. On the off chance that the formatting used
> in the driver was preserved intact - please remember that kernel uses
> hard tabs for identation (8 chars, no expanding). Camel-casing is also
> frowned upon.

Actually, the strange indenting/whitespace is due to a day-long struggle
with checkpatch.pl to get it to accept something - anything - without
complaining.  Personally I thought the formatting that checkpatch 
finally accepted was kind of strange, but went with it.

We'll update to 8-space hard tabs only, and ignore any future checkpatch 
complaints in that department.

We'll address the camel-case issue.

>
>> Signed-off-by: William Manson<WManson@synaptics.com>
>> Signed-off-by: Allie Xiong<axiong@synaptics.com>
>> Signed-off-by: Christopher Heiny<cheiny@synaptics.com>
>> ---
>>
>>   drivers/input/touchscreen/Kconfig            |   13 +
>>   drivers/input/touchscreen/Makefile           |    1 +
>>   drivers/input/touchscreen/rmi.h              |  214 +++++++++
>>   drivers/input/touchscreen/rmi_app_touchpad.c |  490 +++++++++++++++++++++
>>   drivers/input/touchscreen/rmi_core.c         |  602 ++++++++++++++++++++++++++
>>   drivers/input/touchscreen/rmi_core.h         |   59 +++
>>   drivers/input/touchscreen/rmi_function_11.c  |  333 ++++++++++++++
>>   drivers/input/touchscreen/rmi_function_11.h  |   41 ++
>>   drivers/input/touchscreen/rmi_functions.h    |  107 +++++
>>   drivers/input/touchscreen/rmi_i2c.h          |   57 +++
>>   drivers/input/touchscreen/rmi_i2c_gta01.c    |  125 ++++++
>>   drivers/input/touchscreen/rmi_phys_i2c.c     |  555 ++++++++++++++++++++++++
>>   12 files changed, 2597 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
>> index dfafc76..319cb45 100644
>> --- a/drivers/input/touchscreen/Kconfig
>> +++ b/drivers/input/touchscreen/Kconfig
>> @@ -295,6 +295,19 @@ config TOUCHSCREEN_MIGOR
>>          To compile this driver as a module, choose M here: the
>>          module will be called migor_ts.
>>
>> +config TOUCHSCREEN_SYNAPTICS_RMI4_I2C
>> +     tristate "Synaptics RMI4 I2C touchscreens"
>> +     depends on I2C
>> +     help
>> +       Say Y here if you have a Synaptics RMI4 I2C touchscreen connected to
>> +       your system. This enables support for Synaptics RMI4 over I2C based
>
> Spaces followed by tabs.

See above re: checkpatch.

>
>> +          touchscreens.
>
> Wierd identation.

See above re: checkpatch.

>> +
>> +       If unsure, say N.
>> +
>> +       To compile this driver as a set of modules, choose M here: the
>> +       modules will be called rmi, rmi_app_touchpad, rmi_phys_i2c.
>> +
>>   config TOUCHSCREEN_TOUCHRIGHT
>>        tristate "Touchright serial touchscreen"
>>        select SERIO
>> diff --git a/drivers/input/touchscreen/Makefile b/drivers/input/touchscreen/Makefile
>> index d61a3b4..8e7b708 100644
>> --- a/drivers/input/touchscreen/Makefile
>> +++ b/drivers/input/touchscreen/Makefile
>> @@ -30,6 +30,7 @@ obj-$(CONFIG_TOUCHSCREEN_USB_COMPOSITE)     += usbtouchscreen.o
>>   obj-$(CONFIG_TOUCHSCREEN_PCAP)               += pcap_ts.o
>>   obj-$(CONFIG_TOUCHSCREEN_PENMOUNT)   += penmount.o
>>   obj-$(CONFIG_TOUCHSCREEN_S3C2410)    += s3c2410_ts.o
>> +obj-$(CONFIG_TOUCHSCREEN_SYNAPTICS_RMI4_I2C) += rmi_core.o rmi_app_touchpad.o rmi_function_11.o rmi_phys_i2c.o rmi_i2c_gta01.o
>
> You have separated RMI core from touchpad. It would be prudent to build
> these as separate modules as well (have touchpad "select" RMI).

We've been thinking along those lines recently, since it would really 
increase the flexibility of the driver.  We will either include that 
refactoring in the next patch or plan to do it immediately after.

>
>>   obj-$(CONFIG_TOUCHSCREEN_TOUCHIT213) += touchit213.o
>>   obj-$(CONFIG_TOUCHSCREEN_TOUCHRIGHT) += touchright.o
>>   obj-$(CONFIG_TOUCHSCREEN_TOUCHWIN)   += touchwin.o
>> diff --git a/drivers/input/touchscreen/rmi.h b/drivers/input/touchscreen/rmi.h
>> new file mode 100755
>> index 0000000..aa45578
>> --- /dev/null
>> +++ b/drivers/input/touchscreen/rmi.h
>> @@ -0,0 +1,214 @@
>> +/**
>> + * \file
>> + * Synaptics Register Mapped Interface (RMI4) Header File.
>> + * Copyright (c) 2007-2009 Synaptics Incorporated
>> + *
>> + *
>> + */
>> +/*
>> + * This file is licensed under the GPL2 license.
>> + *
>> + *#############################################################################
>> + * GPL
>> + *
>> + * This program is free software; you can redistribute it and/or modify it
>> + * under the terms of the GNU General Public License version 2 as published
>> + * by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful, but
>> + * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
>> + * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
>> + * for more details.
>> + *
>> + *#############################################################################
>> + */
>> +
>> +#ifndef _RMI_H
>> +#define _RMI_H
>> +
>> +/** RMI4 Protocol Support
>> + */
>> +
>> +/** For each function present on the RMI device, we need to get the RMI4 Function
>> + *  Descriptor info from the Page Descriptor Table. This will give us the
>> + *  addresses for Query, Command, Control, Data and the Source Count (number
>> + *  of sources for this function) and the function id.
>> + */
>> +struct rmi_function_descriptor {
>> +  unsigned char queryBaseAddr;
>> +  unsigned char commandBaseAddr;
>> +  unsigned char controlBaseAddr;
>> +  unsigned char dataBaseAddr;
>> +  unsigned char interruptSrcCnt;
>> +  unsigned char functionNum;
>> +};
>> +
>> +/** For each function present on the RMI device, there will be a corresponding
>> + * entry in the functions list of the rmi_module_info structure.  This entry
>> + * gives information about the number of data sources and the number of data
>> + * registers associated with the function.
>> + * \see rmi_module_info
>> + */
>
> If you want to use markups for functions/data structures please forllow
> kerneldoc format:
>
>          Documentation/kernel-doc-nano-HOWTO.txt
>
> Nothing in kernel understands \xxx (\node, \see, etc) tags.

That's a leftover from a previous incarnation of the driver, which used
doxygen to generate user API documentation.  We'll remove doxygen style 
markups or switch to the kernel-doc standard.  Thanks for catching it.

>
>> +struct rmi_function_info {
>> +  unsigned char functionNum;
>> +
>> +  /** This is the number of data sources associated with the function.
>> +   * \note This is not the total number of data registers associated with
>> +   * this function!
>> +   * \see data_regs
>> +   */
>> +  unsigned char numSources;
>> +
>> +  /** This is the number of data points supported - for example, for
>> +   *  function $11 (2D sensor) the number of data points is equal to the number
>> +   *  of fingers - for function $19 (buttons)it is the number of buttons.
>> +   */
>> +  unsigned char numDataPoints;
>> +  /** This is the number of data registers to read.
>> +   */
>> +  unsigned char dataRegBlockSize;
>> +
>> +  /** This is the interrupt register and mask - needed for enabling the interrupts
>> +   *  and for checking what source had caused the attention line interrupt.
>> +   */
>> +  unsigned char interruptRegister;
>> +  unsigned char interruptMask;
>> +
>> +  /** This is the RMI function descriptor associated with this function.
>> +   *  It contains the Base addresses for the functions query, command,
>> +   *  control, and data registers.
>> +   */
>> +  struct rmi_function_descriptor funcDescriptor;
>> +
>> +  /** Standard kernel linked list implementation.
>> +   * Documentation on how to use it can be found at
>> +   * http://isis.poly.edu/kulesh/stuff/src/klist/.
>> +   */
>
> Yep, we know ;)

Heh.  Our expectation is that this driver is going to be picked up by
embedded device manufacturers and handed to engineers who are utterly
inexperienced with the kernel.  So in several places there are comments
that say things that are obvious to experienced kernel programmers (or
even newbies such as ourselves), for the benefit of the poor guy who has
been given a CD of code and the instructions "make it work".

>
>> +  struct list_head link;
>> +};
>> +
>> +/** This encapsulates the information found using the RMI4 Function $01
>> + *  query registers. There is only one Function $01 per device.
>> + *
>> + *  Assuming appropriate endian-ness, you can populate most of this
>> + *  structure by reading query registers starting at the query base address
>> + *  that was obtained from RMI4 function 0x01 function descriptor info read
>> + *  from the Page Descriptor Table.
>> + *
>> + *  Specific register information is provided in the comments for each field.
>> + *  For further reference, please see the<i>Synaptics RMI4 Interfacing
>> + *  Guide</i>  document.
>
> Is it publicly available?

Yes - from here:
       http://www.synaptics.com/developers/manuals
We'll add the URL to the comment.

[snip]

>> diff --git a/drivers/input/touchscreen/rmi_app_touchpad.c b/drivers/input/touchscreen/rmi_app_touchpad.c
>> new file mode 100755
>> index 0000000..b3d0b99
>> --- /dev/null
>> +++ b/drivers/input/touchscreen/rmi_app_touchpad.c
>> @@ -0,0 +1,490 @@
>> +/**
>> + * \file
>> + * Synaptics Register Mapped Interface (RMI4) TouchPad Application Layer Driver.
>> + * Copyright (c) 2007-2009 Synaptics Incorporated
>> + *
>> + *
>> + * This code implements a polling mechanism with backoff as well as
>> + * interrupt-driven sampling.  For polling, the module has two parameters:
>> + * polljif (Poll Jiffies) and hspolljif (High Speed Poll Jiffies).  The driver
>> + * polls at polljif until it sees a press, and then it polls at hspolljif.
>> + * When there is no longer a touch, it reverts to the polljif period.
>> + *
>> + * The polljif parameter can be changed during run time like this:\code
>> + *   echo 100>  /sys/module/rmi_app_touchpad/parameters/polljif
>> + * \endcode
>> + *
>> + * That will change the pollrate to 1 per second (assuming HZ == 100).  The
>> + * same is true for hspolljif.
>> + *
>> + * The parameters have no effect for the interrupt-driven case.
>> + *
>> + * Note that it is the lower-level drivers that determine whether this driver
>> + * has to do polling or interrupt-driven.  Polling can always be done, but if
>> + * we have an interrupt connected to the attention (ATTN) line, then it is
>> + * better to be interrupt driven.
>> + *
>> + */
>> +/*
>> + * This file is licensed under the GPL2 license.
>> + *
>> + *#############################################################################
>> + * GPL
>> + *
>> + * This program is free software; you can redistribute it and/or modify it
>> + * under the terms of the GNU General Public License version 2 as published
>> + * by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful, but
>> + * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
>> + * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
>> + * for more details.
>> + *
>> + *#############################################################################
>> + */
>> +
>> +#include<linux/kernel.h>
>> +#include<linux/device.h>
>> +#include<linux/delay.h>
>> +#include<linux/kthread.h>
>> +#include<linux/freezer.h>
>> +#include<linux/input.h>
>> +
>> +#include "rmi.h"
>> +#include "rmi_core.h"
>> +#include "rmi_functions.h"
>> +
>> +#if RMI_ALLOC_STATS
>> +  static int pollallocsrmi;
>> +#endif
>> +
>> +#define RMI_REPORT_RATE_40 (1<<  6)
>> +
>> +/** The number of jiffies between polls without touches */
>> +static int polljif = HZ/20;
>> +/** The number of jiffies between polls with touches */
>> +static int hspolljif = HZ/40;
>> +module_param(polljif, int, 0644);
>> +module_param(hspolljif, int, 0644);
>> +MODULE_PARM_DESC(polljif,   "How many jiffies between low speed polls.");
>> +MODULE_PARM_DESC(hspolljif, "How many jiffies between high speed polls.");
>
> Jiffies is not the best units of measurement. You need to use fractions
> of seconds - something that does not depent on processor speed and
> current value of HZ.

Check - will correct this.

>
>> +
>> +static struct rmi_application *app;
>> +static struct completion touch_completion;
>> +static struct completion thread_comp;
>> +struct task_struct *kthread;
>> +static int time_to_quit;
>
> bool.

Check - will correct this.

>
>> +static struct input_dev *input;
>
> One device per system? This is a harsh limitation and something that
> I'd rather not have.

Agreed.  We'll plan to remedy this, hopefully in the next version of the 
patch.

>
>> +
>> +extern unsigned short fn01ControlBaseAddr;   /* RMI4 device control == function 0x01 */
>> +extern unsigned int interruptRegisterCount;   /* number of total interrupt registers to read */
>> +
>> +extern struct list_head fns_list;
>> +
>> +/**
>> + * This is the function we pass to the RMI4 subsystem so we can be notified
>> + * when attention is required.  It may be called in interrupt context.
>> + */
>> +static void attention(struct rmi_phys_driver *rpd, int instance)
>> +{
>> +  /* All we have to do is wake up the kernel sampling thread. */
>> +  complete(&touch_completion);
>
> I do not see you re-initializing this completion anywhere so once
> signalled your thread will be spinning with wait_for_completion() being
> a noop.

Whoops!  We'll correct that.

[snip]

>> +
>> +
>> +/**
>> + * This is a kernel thread that processes packets when we receive them.  It is
>> + * only used for the interrupt-driven case.  Polling may also be done in this
>> + * driver and doesn't use this thread (although I suppose it could be modified
>> + * to do polling, too, instead of using timers).
>> + */
>> +int rmitouchd(void *param)
>> +{
>> +  struct rmi_application *app = (struct rmi_application *)param;
>> +
>> +  daemonize("rmitouchd");
>
> No need to daemonize if you use ktherad_run().

Check - will correct this.

>
>> +
>> +  while (!kthread_should_stop()) {
>> +     if (time_to_quit)
>> +       break;
>
> Why do you need separate flag? kthread_should_stop() should be enough.

It was important at one point long ago, but no longer is relevant. 
We'll get rid of it.

>
>> +
>> +     /* wait for interrupt from ATTN line */
>> +     wait_for_completion_interruptible(&touch_completion);
>
> wait_event_freezable().

Check - will correct this.

>
>> +     if (time_to_quit)
>> +       break;
>> +
>> +     try_to_freeze();
>> +     do {
>> +       report_sensor_data(app);
>> +       /* check if time to quit so we don't loop when we are in mod_exit(). */
>> +       if (time_to_quit)
>> +             break;
>> +     } while (rmi_get_attn(app));
>
> You still want to be able to suspend even if someone is keeping finger
> on a touchpad... You need to check freeze state alongside of checking
> attention.

Check - will correct this.

>
>> +  }
>> +
>> +  complete_and_exit(&thread_comp, 0);
>
> No need for this either.

Check - will correct this.

>
>> +}
>> +
>> +/* Head of the list to keep track of who is polling.  This is so we can
>> + * properly shut down the timers on exit. */
>> +static struct list_head pollers;
>> +
>> +/* Simple structure to keep track of things */
>> +struct poll_instance {
>> +  struct delayed_work dw;
>> +  struct rmi_application *app;
>> +  struct list_head link;
>> +};
>> +
>> +/* The main routine for the polling case. */
>> +static void poll_work_callback(struct work_struct *data)
>> +{
>> +  struct delayed_work *dw = container_of(data, struct delayed_work, work);
>> +  struct poll_instance *pi = container_of(dw, struct poll_instance, dw);
>> +  static int calls_with_no_data;
>> +  int touch = 0;
>> +
>> +  if (time_to_quit)
>> +    return;
>> +
>> +  touch = report_sensor_data(pi->app);
>> +
>> +  /* This code implements a backoff.  If we have a call with data being
>> +   * received, we decrease the time between polls to hspolljif.  If
>> +   * there are several calls at that faster rate that do not have data,
>> +   * we go back to slower polling.
>> +   */
>> +  if (touch)
>> +     calls_with_no_data = 0;
>> +  if (!time_to_quit) {       /* Don't schedule if it's time to quit. */
>> +     if (calls_with_no_data>  5) {
>> +       schedule_delayed_work(dw, polljif);
>
> This is wrong. You need
>
>          schedule_delayed_work(dw, jiffies + polljif);
>
> or
>
>          schedule_delayed_work(dw, jiffies + msecs_to_jiffies(poll_time));

Check - will correct this.

>
>> +     } else {
>> +       if (!touch)
>> +             calls_with_no_data++;
>> +       schedule_delayed_work(dw, hspolljif);
>
> Same here but hspoll_time.

Check - will correct this.

>
>> +     }
>> +  }
>> +}
>> +
>> +/**
>> + * This is the probe function passed to the RMI4 subsystem that gives us a
>> + * chance to recognize an RMI4 device.  In this case, we're looking for
>> + * Synaptics devices that have data sources - such as touch screens, buttons, etc.
>> + */
>> +static int probe(struct rmi_application *app, const struct rmi_module_info *rmi)
>> +{
>> +  struct rmi_function_info *rfi;
>> +  int data_sources = 0;
>> +  int retval = 0;
>> +
>> +  if (!rmi) {
>> +     printk(KERN_ERR "rmi_app_touchpad.probe: "
>> +       "Invalid module info: %p\n", rmi);
>> +     return 0;
>> +  }
>> +
>> +  /* Make sure this is a Synaptics device */
>> +  if (rmi->mfgid != 1) { /* Synaptics */
>> +     printk(KERN_ERR "rmi_app_touchpad.probe: "
>> +       "Invalid mfg id: %d\n", rmi->mfgid);
>> +     return 0;
>> +  }
>> +
>> +  /* for each function entry in the list accumulate it's number of data sources */
>> +  list_for_each_entry(rfi,&rmi->functions, link) {
>> +       data_sources += rfi->numSources;
>> +  }
>> +
>> +  if (data_sources) {
>> +     retval = 1;
>> +     /* We have detected one or more data sources such as a 2D Sensors, buttons, etc. */
>> +     printk(KERN_ERR "rmi_app_touchpad.probe: "
>> +       "Found %d data sources for : %p\n", data_sources, rmi);
>> +  } else {
>> +     /* we don't have any data sources for this sensor - oops! - either an un-flashed sensor or bad!! */
>> +     printk(KERN_ERR "rmi_app_touchpad.probe: "
>> +       "No data sources found for : %p\n", rmi);
>> +  }
>> +
>> +  return retval;
>> +}
>> +
>> +static void config(struct rmi_application *app)
>> +{
>> +  /* For each data source we had detected print info and set up interrupts or polling. */
>> +  struct rmi_function_info *rfi;
>> +  struct rmi_phys_driver *rpd;
>> +  struct rmi_module_info *rmi;
>> +
>> +  rpd = app->rpd; /* get ptr to rmi_physical_driver from app */
>> +  rmi =&(rpd->rmi); /* get ptr to rmi_module_info from physical driver */
>> +
>> +  list_for_each_entry(rfi,&rmi->functions, link) {
>> +     if (rfi->numSources) /* if this function has data sources associated with it...*/ {
>> +       /* Get and print some info about the data sources... */
>> +       struct rmi_functions *fn;
>> +       bool found;
>> +
>> +       found = false;
>> +       list_for_each_entry(fn,&fns_list, link) {
>> +             /* check if function number matches - if so call that config function */
>> +             if (fn->functionNum == rfi->functionNum) {
>> +               found = true;
>> +               if (fn->config) {
>> +                     fn->config(app, rfi);
>> +               } else {
>> +                     /* the developer did not add in the pointer to the config
>> +                        function into rmi4_supported_data_src_functions */
>> +                     printk(KERN_ERR "rmi_app_touchpad.config - no config function for function 0x%x\n", rfi->functionNum);
>> +                     break;
>> +               }
>> +             }
>> +       }
>> +       if (!found) {
>> +             /* if no support found for this RMI4 function it means the
>> +                developer did not add the appropriate function pointer list
>> +                into the rmi4_supported_data_src_functions array and/or did
>> +                not bump up the number of supported RMI4 functions in rmi.h as
>> +                required */
>> +             printk(KERN_ERR "rmi_app_touchpad.config - could not find support for function 0x%x\n", rfi->functionNum);
>> +       }
>> +
>> +       /* if we are not doing polling then enable the interrupts for the
>> +              data sources for this function */
>> +       if (!rmi_polling_required(app)) {
>> +             /* Turn on interrupts for this functions data sources. */
>> +             rmi_write(app, fn01ControlBaseAddr + 1 + rfi->interruptRegister, rfi->interruptMask);
>> +             printk(KERN_INFO "rmi_app_touchpad.config -  Interrupt Driven - turning on interrupts for function 0x%x\n", rfi->functionNum);
>> +       }
>> +     }
>> +  }
>> +
>> +  /* if we are not polling we need to set up the interrupt thread - otherwise we need to
>> +      set up the polling callback and worker thread. */
>> +  if (!rmi_polling_required(app)) {
>> +     /* We're interrupt driven, so turn on the thread. */
>> +     kthread = kthread_run(&rmitouchd, app, "rmitouchd");
>> +
>> +     if (HZ<  500) {
>> +       /* The default polling frequency of 80 times per
>> +        * second is too fast (the Linux time slice for
>> +        * sub-GHz processors is only 100 times per second).
>> +        * So program it to 40.
>> +        */
>> +       rmi_write(app, fn01ControlBaseAddr, RMI_REPORT_RATE_40);
>> +     }
>> +  } else {
>> +     /* We're polling driven, so set up the polling callback and worker thread */
>> +     struct poll_instance *pi;
>> +     pi = kmalloc(sizeof(*pi), GFP_KERNEL);
>> +
>> +     if (!pi) {
>> +       printk(KERN_ERR "rmi_app_touchpad.config: "
>> +             "Out of memory claiming %s\n",
>> +             rmi->prod_id);
>> +       return;
>> +     }
>> +     INC_ALLOC_STAT(poll);
>
> Bah, this is too complex for no good reason. Just make dw embedded in
> rmi_application instance.

Agreed.

>
>> +     INIT_DELAYED_WORK(&pi->dw, poll_work_callback);
>> +
>> +     pi->app  = app;
>> +     list_add_tail(&pi->link,&pollers);
>> +     schedule_delayed_work(&pi->dw, polljif);
>
> Why can't we also use workqueue when in interrupt mode or use thread
> when in polling mode. I think these 2 modes should be combined together
> as much as possible.

We concur, and will change to simplified structure using delayed work 
for both polling and interrupt mode.

>
>> +  }
>> +}
>> +
>> +/**
>> + * The module initialization function in which we register as a RMI4
>> + * application driver.  We also register with the input subsystem so we can
>> + * pass coordinates to it.
>> + */
>> +static int __init mod_init(void)
>
> Call it rmi_app_touchpad_init(). It makes so much easier to see crash
> trace.

Check - will correct this.

>
>> +{
>> +  struct rmi_functions *fn;
>> +  int retval;
>> +
>> +  retval = 0;
>> +
>> +  printk(KERN_INFO "rmi_app_touchpad.mod_init: RMI4 TouchPad Driver\n");
>> +
>> +  INIT_LIST_HEAD(&pollers);
>> +
>> +  time_to_quit = 0;
>> +  init_completion(&touch_completion);
>> +  init_completion(&thread_comp);
>> +
>> +  /* NOTE: we are creating only one input dev file for this but theoretically
>> +      you could create a separate one for each data source and store it below.
>> +      This will let you put 2D sensor events into one dev file, button events into
>> +      a separate dev file, other data source event like GPIOs, etc. into yet a
>> +      third dev file. As this is being coded it will dump all events into the
>> +      one dev file.
>> +   */
>> +  input = input_allocate_device();
>> +  if (input == NULL) {
>> +     printk(KERN_ERR "rmi_app_touchpad.mod_init:  Failed to allocate memory for a new input device.\n");
>> +     return -ENOMEM;
>> +  }
>> +
>> +  input->name = "RMI4 Touchpad";
>> +  input->phys = "rmi_app_touchpad";
>> +
>> +  /* Set input device specific params for each data source...*/
>> +  list_for_each_entry(fn,&fns_list, link) {
>> +     if (fn->init) {
>> +       fn->input = input; /* store the input_dev ptr for use later */
>> +       fn->init(fn->input);
>
> Can fn->init fail for any reason?

Yes it can, we'll update to return and check an error code.

>
>> +     } else {
>> +       /* the developer did not add in the pointer to the init function into rmi4_supported_data_src_functions */
>> +       printk(KERN_ERR "rmi_app_touchpad.mod_init: no init function for function 0x%x\n", fn->functionNum);
>
> If this is an error why don't you handle it when building fns_list?

Hmmm.  This just seemed like a handy place to do it.  Checking when 
we're building the list could be more robust, though.

>
>> +     }
>> +  }
>> +
>> +  retval = input_register_device(input);
>> +
>> +  if (retval) {
>> +     printk(KERN_ERR "rmi_app_touchpad.mod_init:  Failed input_register_device.\n");
>
> What about undoing the parts of the setup that were successful?

In systems where there are multiple sensors, we may want to leave the 
ones that were successfully configured enabled.

>
>> +     return retval;
>> +  }
>> +
>> +  app = rmi_register_application("rmi4_touchpad", attention, probe, config);
>> +
>> +  if (!app) {
>> +     printk(KERN_ERR "rmi_app_touchpad.mod_init:  Failed to register app.\n");
>> +     input_unregister_device(input);
>> +     retval = -ENODEV;
>> +  }
>> +
>> +  return retval;
>> +}
>> +
>> +/**
>> + * The module exit function.
>> + */
>> +static void __exit mod_exit(void)
>> +{
>> +  struct poll_instance *pi, *pi_tmp;
>> +
>> +  printk(KERN_INFO "rmi_app_touchpad.mod_exit: RMI4 TouchPad Driver\n");
>> +
>> +  time_to_quit = 1;
>> +
>> +  complete(&touch_completion); /* Kick the thread awake */
>
> kthread_stop() is what you should be calling and it will wait for thread
> to exit. You won't be needing raising touch_completion here nor wait for
> thread_comp below.

Check - will correct this.

>
>> +  list_for_each_entry(pi,&pollers, link) {
>> +     cancel_delayed_work(&pi->dw);   /* Cancel any pending polls */
>
> cancel_delayed_work_sync(), otherwise work may rearm itself.

Check - will correct this.

>
>> +  }
>> +  flush_scheduled_work();    /* Make sure all pollers are stopped */
>
> and then it is not needed.

Check - will correct this.

>
>> +  if (kthread)
>> +     wait_for_completion(&thread_comp);
>> +
>> +  /* Unregister everything */
>> +  printk(KERN_WARNING "rmi_app_touchpad.mod_exit: Unregistering app - %s\n", app->name);
>> +  rmi_unregister_application(app);
>> +  input_unregister_device(input);
>> +
>> +  /* Free up the structures */
>> +  list_for_each_entry_safe(pi, pi_tmp,&pollers, link) {
>> +     list_del(&pi->link);
>> +     kfree(pi);
>> +     DEC_ALLOC_STAT(poll);
>> +  }
>> +
>> +  CHECK_ALLOC_STAT(poll);
>
> Not needed if you embed wq in application.

Right.

>
>> +}
>> +
>> +/** Standard driver module information - the author of the module.
>> + */
>
> Please get rid of comments taht do not add any useful information.

Check - will correct this.

>
>> +MODULE_AUTHOR("Synaptics, Inc.");
>> +/** Standard driver module information - a summary description of this module.
>> + */
>> +MODULE_DESCRIPTION("RMI4 Driver");
>> +/** Standard driver module information - the license under which this module
>> + * is included in the kernel.
>> + */
>> +MODULE_LICENSE("GPL");
>> +
>> +/** Specifies to the kernel that the mod_init() function should be called when
>> + * the module is loaded.
>> + * \see mod_init()
>> + */
>> +module_init(mod_init);
>
>
>> +/** Specifies to the kernel that the mod_exit() function should be called when
>> + * the module is unloaded.
>> + * \see mod_exit()
>> + */
>> +module_exit(mod_exit);
>> +
>> +/* vim600: set noexpandtab sw=8 ts=8 :*/
>> diff --git a/drivers/input/touchscreen/rmi_core.c b/drivers/input/touchscreen/rmi_core.c
>> new file mode 100755
>> index 0000000..fdedd09
>> --- /dev/null
>> +++ b/drivers/input/touchscreen/rmi_core.c
>> @@ -0,0 +1,602 @@
>> +/**
>> + * \file
>> + * Synaptics Register Mapped Interface (RMI4) Data Layer Driver.
>> + * Copyright (C) 2007 - 2009, Synaptics Incorporated
>> + *
>> + *
>> + * This protocol is layered as follows.
>> + *
>> + *<pre>
>> + *  +----------------------------------------+
>> + *  |                                                                                |
>> + *  |                          Application                      |
>> + *  |                                                                                |
>> + *  +----------------------------------------+
>> + *  |                                                                                |
>> + *  |                           RMI4 Driver                    | Data Layer (THIS DRIVER)
>> + *  |                          (this file)                      |
>> + *  +-----+-----+-------+----------+---------+
>> + *  | I2C | SPI | SMBus |            etc.            | Physical Layer
>> + *  +-----+-----+-------+----------+---------+
>> + *</pre>
>> + *  Each of the physical layer drivers is contained in a file called
>> + *  rmi_phys_xxx.c.  Someone compiling the kernel enables CONFIG_RMI and then
>> + *  one or more CONFIG_RMI_xxx options in the .config file.  For example, when
>> + *  CONFIG_RMI_I2C=m is enabled, a rmi.ko and a rmi_phys_i2c.ko will be
>> + *  compiled.  rmi_phys_i2c.ko will depend on rmi.ko, so when rmi_phys_i2c.ko
>> + *  is loaded, rmi.ko will automatically be loaded.  Each of the physical
>> + *  layer drivers is a platform_driver that may handle suspend/resume, etc.,
>> + *  so this driver does not do so.
>> + *
>> + *  The register paradigm of RMI is a "pull" rather than "push" data flow.
>> + *  As such, it is the application driver that needs to implement either
>> + *  polling or interrupt driven, and the physical driver merely handles
>> + *  the register accesses.  For interrupt driven, the application registers
>> + *  an "attention" function that may be called in interrupt context by the
>> + *  physical driver if an attention interrupt is available.  The physical
>> + *  driver notifies the application through the polling_required variable,
>> + *  and the application driver must do one or the other based on this variable.
>> + *
>> + *  At this point in time, there can only be one application driver per
>> + *  physical driver.
>> + *
>> + */
>> +/*
>> + * This file is licensed under the GPL2 license.
>> + *
>> + *#############################################################################
>> + * GPL
>> + *
>> + * This program is free software; you can redistribute it and/or modify it
>> + * under the terms of the GNU General Public License version 2 as published
>> + * by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful, but
>> + * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
>> + * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
>> + * for more details.
>> + *
>> + *#############################################################################
>> + */
>> +
>> +static const char drvname[] = "rmi4";
>> +
>> +#include<linux/kernel.h>
>> +#include<linux/device.h>
>> +#include<linux/miscdevice.h>
>> +#include<linux/fs.h>
>> +#include<linux/delay.h>
>> +#include<asm/uaccess.h>
>> +
>> +#include "rmi.h"
>> +#include "rmi_core.h"
>> +#include "rmi_functions.h"
>> +
>> +/* we need these to control and query interrupts */
>> +unsigned short fn01QueryBaseAddr;     /* RMI4 device control */
>> +EXPORT_SYMBOL(fn01QueryBaseAddr);
>> +unsigned short fn01ControlBaseAddr;
>> +EXPORT_SYMBOL(fn01ControlBaseAddr);
>> +unsigned int interruptRegisterCount;
>> +EXPORT_SYMBOL(interruptRegisterCount);
>> +
>> +#define PDT_START_SCAN_LOCATION 0x00E9
>> +#define PDT_END_SCAN_LOCATION 0x000A
>> +#define PDT_ENTRY_SIZE 0x0006
>> +
>> +static LIST_HEAD(phys_drivers);
>> +static DEFINE_MUTEX(phys_drivers_mutex);
>> +static LIST_HEAD(app_drivers);
>> +static DEFINE_MUTEX(app_drivers_mutex);
>> +static LIST_HEAD(fns_list);
>> +EXPORT_SYMBOL(fns_list);
>
> Exporting lists like this is not pretty. It would be much better if RMI
> core provided proper iterators and accessor functions.

Check - will correct this.

[snip]

>> +static int __init mod_init(void)
>> +{
>> +  int i;
>> +  struct rmi_functions_data *rmi4_fn;
>> +
>> +  printk(KERN_INFO "Register Mapped Interface Data Layer Driver\n");
>
> No need for announcements, kernel boot is noisy enough.

We'll change this and most others to used debugfs instead.

>
>> +
>> +  /* Initialize global list of RMI4 Functions that have data sources.
>> +      We need to add all new functions to this list so that we will have pointers
>> +      to their associated functions for init, config, report and detect. See rmi.h
>> +      for more details. The developer will add a new RMI4 function number in the
>> +      array in rmi.h and then add a new file to the build (called rmi_function_XX.c
>> +      where XX is the hex number for the added RMI4 function). The rest should be
>> +      automatic.
>> +  */
>> +
>> +  /* for each function number defined in rmi.h creat a new rmi_function struct and
>> +      initialize the pointers to the servicing functions and then add it into the
>> +      global list for function support.
>> +  */
>> +  for (i = 0; i<  rmi4_num_supported_data_src_fns; i++) {
>> +     /* Add new rmi4 function struct to list */
>> +     struct rmi_functions *fn = kmalloc(sizeof(*fn), GFP_KERNEL);
>> +     if (!fn) {
>> +       printk(KERN_ERR "%s mod_init: could not allocate memory for rmi_function struct for function 0x%x\n",
>> +     drvname, rmi4_supported_data_src_functions[i].functionNumber);
>> +       return -ENOMEM;
>> +     } else {
>> +
>> +       INC_ALLOC_STAT(fn);
>> +
>> +       rmi4_fn =&rmi4_supported_data_src_functions[i];
>> +       fn->functionNum = rmi4_fn->functionNumber;
>> +       /* Fill in ptrs to functions. The functions are linked in from a file
>> +      called rmi_function_xx.c where xx is the hex number of the RMI4 function
>> +      from the RMI4 spec. Also, the function prototypes need to be added to
>> +      rmi_function_xx.h - also where xx is the hex number of the RMI4 function.
>> +      So that you don't get compile errors and that new header needs to be
>> +      included in the rmi.h header file.
>> +       */
>> +       fn->report = rmi4_fn->reportFn;
>> +       fn->config = rmi4_fn->configFn;
>> +       fn->init =   rmi4_fn->initFn;
>> +       fn->detect = rmi4_fn->detectFn;
>> +
>> +       /* Add the new fn to the global list */
>> +       mutex_lock(&fns_mutex);
>> +       list_add_tail(&fn->link,&fns_list);
>> +       mutex_unlock(&fns_mutex);
>> +     }
>> +  }
>> +
>> +  return 0;
>> +}
>> +
>> +static void __exit mod_exit(void)
>> +{
>> +  struct rmi_application *app, *apptmp;
>> +
>> +  /* These lists should be empty, but just in case . . . */
>> +  mutex_lock(&app_drivers_mutex);
>> +  list_for_each_entry_safe(app, apptmp,&app_drivers, apps) {
>> +     list_del(&app->apps);
>> +     kfree(app);
>> +     DEC_ALLOC_STAT(app);
>> +  }
>> +  mutex_unlock(&app_drivers_mutex);
>> +
>> +  CHECK_ALLOC_STAT(app);
>
> OK, so overall this module seem to be re-implementing the driver model
> already presented in the kernel. Why didn't you simply create "rmi" bus
> and rmi_device and rmi_driver on that bus?

Good point.  Parts of this patch are inherited from some older in-house 
drivers, including this section.  I'm not sure why this section does it 
this way, but it worked so we kept for now.  We'll switch to rely on the 
kernel driver model as you suggest.

[snip]

>> +/* vim600: set noexpandtab sw=8 ts=8 : */
>> diff --git a/drivers/input/touchscreen/rmi_function_11.c b/drivers/input/touchscreen/rmi_function_11.c
>> new file mode 100755
>> index 0000000..d490c21
>> --- /dev/null
>> +++ b/drivers/input/touchscreen/rmi_function_11.c
>> @@ -0,0 +1,333 @@
>> +/**
>> + * \file
>> + * Synaptics Register Mapped Interface (RMI4) Function $11 support for 2D.
>> + * Copyright (c) 2009 Synaptics Incorporated
>> + *
>> + * For every RMI4 function that has a data source - like 2D sensors, buttons, LEDs,
>> + * GPIOs, etc. - the user will create a new rmi_function_xx.c file and add these
>> + * functions to perform the config(), init(), report() and detect() functionality.
>> + * The function pointers are then srored under the RMI function info and these
>> + * functions will automatically be called by the global config(), init(), report()
>> + * and detect() functions that will loop through all data sources and call the
>> + * data sources functions using these functions pointed to by the function ptrs.
>> + */
>> +/*
>> + * This file is licensed under the GPL2 license.
>> + *
>> + *#############################################################################
>> + * GPL
>> + *
>> + * This program is free software; you can redistribute it and/or modify it
>> + * under the terms of the GNU General Public License version 2 as published
>> + * by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful, but
>> + * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
>> + * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
>> + * for more details.
>> + *
>> + *#############################################################################
>> + */
>> +
>> +#include<linux/kernel.h>
>> +#include<linux/device.h>
>> +#include<linux/delay.h>
>> +#include<linux/kthread.h>
>> +#include<linux/freezer.h>
>> +#include<linux/input.h>
>> +
>> +#include "rmi.h"
>> +#include "rmi_core.h"
>> +#include "rmi_functions.h"
>> +
>> +extern unsigned short fn01ControlBaseAddr;  /* RMI4 device contorl == function 0x01 */
>> +
>> +static int sensorMaxX;
>> +static int sensorMaxY;
>> +
>> +/**
>> + * This reads in a sample and reports the function $11 source data to the input subsystem.
>> + * It is used for both polling and interrupt driven operation. This is called a lot
>> + * so don't put in any informational printks since they will slow things way down!
>> + */
>> +int FN_11_report(struct rmi_application *app, struct rmi_function_info *rfi, struct input_dev *input)
>> +{
>> +  unsigned char values[2] = {0, 0};
>> +  unsigned char data[12] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
>> +  int touch; /* number of touch points - fingers in this case */
>> +  int X, Y, Z, W, Wy, Wx;
>> +  int finger;
>> +  int fn11FingersSupported;
>> +  int fn11FingerRegisters;
>> +  unsigned short fn11DataBaseAddr;
>> +  unsigned char fn11DataRegBlockSize;
>> +
>> +  touch = 0;
>> +
>> +  /* get 2D sensor finger data */
>> +  /* First get the finger status field - the size of the finger status field is
>> +     determined by the number of finger supporte - 2 bits per finger, so the number
>> +     of registers to read is : registerCount = ciel(numberOfFingers/4).
>> +     Read the required number of registers and check each 2 bit field to determine
>> +     if a finger is down (00 = finger not present, 01 = finger present and data accurate,
>> +     10 = finger present but data may not be accurate, 11 = reserved for product use).
>> +  */
>> +  fn11FingersSupported = rfi->numDataPoints;
>> +  fn11FingerRegisters = (fn11FingersSupported + 3)/4;
>> +
>> +  fn11DataBaseAddr = rfi->funcDescriptor.dataBaseAddr;
>> +
>> +  if (rmi_read_multiple(app, fn11DataBaseAddr, values, fn11FingerRegisters)) {
>> +    printk(KERN_ERR "RMI4 function $11 report: Could not read finger status registers 0x%x\n", fn11DataBaseAddr);
>> +    return 0;
>> +  }
>> +
>> +  /* For each finger present, read the proper number of registers to get absolute data. */
>> +  fn11DataRegBlockSize = rfi->dataRegBlockSize;
>> +
>> +  for (finger = 0; finger<  fn11FingersSupported; finger++) {
>> +    int reg;
>> +    int fingerShift;
>> +    int fingerStatus;
>> +
>> +    reg = finger/4; /* determine which data byte the finger status is in */
>> +    fingerShift = (finger % 4) * 2; /* determine bit shift to get that fingers status */
>> +    fingerStatus = (values[reg]>>  fingerShift)&  3;
>> +
>> +    /* if finger status indicates a finger is present then read the finger data and report it */
>> +    if (fingerStatus == 1 || fingerStatus == 2) {
>> +      touch++; /* number of active touch points not same as number of supported fingers */
>> +
>> +      /* Read the finger data */
>> +      if (rmi_read_multiple(app, fn11DataBaseAddr +
>> +     ((finger  * fn11DataRegBlockSize) + fn11FingerRegisters), data, fn11DataRegBlockSize)) {
>> +             printk(KERN_ERR "RMI4 function $11 report: Could not read finger data registers 0x%x\n",
>> +             fn11DataBaseAddr + ((finger  * fn11DataRegBlockSize) + fn11FingerRegisters));
>> +             return 0;
>> +      } else {
>> +             X = (data[0]&  0x1f)<<  4;
>> +             X |= data[2]&  0xf;
>> +             Y = (data[1]&  0x1f)<<  4;
>> +             Y |= (data[2]>>  4)&  0xf;
>> +             W = data[3];
>> +
>> +     /* upper 4 bits of W are Wy, lower 4 of W are Wx */
>> +             Wy =  (W>>  4)&  0x0f;
>> +             Wx = W&  0x0f;
>> +
>> +             Z = data[4];
>> +
>> +     /* if this is the first finger report normal ABS_X, ABS_Y, PRESSURE, TOOL_WIDTH events for non-MT apps.
>> +        Apps that support Multi-touch will ignore these events and use the MT events. Apps that don't support
>> +        Multi-touch will still function.
>> +     */
>> +     if (touch == 1) {
>> +       input_report_abs(input, ABS_X, X);
>> +       input_report_abs(input, ABS_Y, Y);
>> +       input_report_abs(input, ABS_PRESSURE, Z);
>> +       input_report_abs(input, ABS_TOOL_WIDTH, max(Wx, Wy));
>
> BTN_TOUCH for applications not using pressure is nice too.

Agreed, will do.

>
>> +     }
>> +
>> +     /* Report Multi-Touch events for each finger */
>> +     input_report_abs(input, ABS_MT_TOUCH_MAJOR, max(Wx, Wy)); /* major axis of touch area ellipse */
>> +     input_report_abs(input, ABS_MT_TOUCH_MINOR, min(Wx, Wy)); /* minor axis of touch area ellipse */
>> +     input_report_abs(input, ABS_MT_ORIENTATION, (Wx>  Wy ? 1 : 0)); /* Currently only 2 supported - 1 or 0 */
>> +     input_report_abs(input, ABS_MT_POSITION_X, X);
>> +     input_report_abs(input, ABS_MT_POSITION_Y, Y);
>> +     input_report_abs(input, ABS_MT_TRACKING_ID, finger+1); /* Tracking ID reported but not used yet */
>> +     input_mt_sync(input); /* MT sync between fingers */
>> +      }
>> +    }
>> +  }
>> +
>> +  if (touch) /* touch will be non-zero if we had any reported events */
>> +    input_sync(input); /* sync after groups of events */
>> +
>> +  /* return the number of touch points - fingers down or buttons pressed */
>> +  return touch;
>> +}
>> +
>> +void FN_11_config(struct rmi_application *app, struct rmi_function_info *rfi)
>> +{
>> +  /* For the data source - print info and do any source specific configuration. */
>> +  unsigned char data[14];
>> +
>> +  printk(KERN_INFO "RMI4 function $11 config\n");
>> +
>> +  /* Get and print some info about the data source... */
>> +
>> +  /*
>> +   * To Query 2D devices we need to read from the address obtained
>> +   * from the function descriptor stored in the RMI function info.
>> +   */
>> +  if (rmi_read_multiple(app, rfi->funcDescriptor.queryBaseAddr, data, 9)) {
>> +    printk(KERN_ERR "RMI4 function $11 config: Could not read function query registers 0x%x\n", rfi->funcDescriptor.queryBaseAddr);
>> +    return;
>> +  } else {
>> +    printk(KERN_INFO "  Number of Fingers:   %d\n", data[1]&  7);
>> +    printk(KERN_INFO "  Is Configurable:     %d\n", data[1]&  (1<<  7) ? 1 : 0);
>> +    printk(KERN_INFO "  Has Gestures:        %d\n", data[1]&  (1<<  5) ? 1 : 0);
>> +    printk(KERN_INFO "  Has Absolute:        %d\n", data[1]&  (1<<  4) ? 1 : 0);
>> +    printk(KERN_INFO "  Has Relative:        %d\n", data[1]&  (1<<  3) ? 1 : 0);
>> +
>> +    printk(KERN_INFO "  Number X Electrodes: %d\n", data[2]&  0x1f);
>> +    printk(KERN_INFO "  Number Y Electrodes: %d\n", data[3]&  0x1f);
>> +    printk(KERN_INFO "  Maximum Electrodes:  %d\n", data[4]&  0x1f);
>> +
>> +    printk(KERN_INFO "  Absolute Data Size:  %d\n", data[5]&  3);
>> +
>> +    printk(KERN_INFO "  Has XY Dist:         %d\n", data[7]&  (1<<  7) ? 1 : 0);
>> +    printk(KERN_INFO "  Has Pinch:           %d\n", data[7]&  (1<<  6) ? 1 : 0);
>> +    printk(KERN_INFO "  Has Press:           %d\n", data[7]&  (1<<  5) ? 1 : 0);
>> +    printk(KERN_INFO "  Has Flick:           %d\n", data[7]&  (1<<  4) ? 1 : 0);
>> +    printk(KERN_INFO "  Has Early Tap:       %d\n", data[7]&  (1<<  3) ? 1 : 0);
>> +    printk(KERN_INFO "  Has Double Tap:      %d\n", data[7]&  (1<<  2) ? 1 : 0);
>> +    printk(KERN_INFO "  Has Tap and Hold:    %d\n", data[7]&  (1<<  1) ? 1 : 0);
>> +    printk(KERN_INFO "  Has Tap:             %d\n", data[7]&  1 ? 1 : 0);
>> +    printk(KERN_INFO "  Has Palm Detect:     %d\n", data[8]&  1 ? 1 : 0);
>> +    printk(KERN_INFO "  Has Rotate:          %d\n", data[8]&  (1<<  1) ? 1 : 0);
>
> Way yoo noisy... if this is important maybe use debugfs.

Agreed, will do.

[snip]

>> diff --git a/drivers/input/touchscreen/rmi_i2c_gta01.c b/drivers/input/touchscreen/rmi_i2c_gta01.c
>> new file mode 100755
>> index 0000000..598851d
>> --- /dev/null
>> +++ b/drivers/input/touchscreen/rmi_i2c_gta01.c
>> @@ -0,0 +1,125 @@
>> +/**
>> + * \file
>> + * Synaptics RMI4 Support for I2C the OpenMoko phone (GTA01) hardware platform.
>> + * Copyright (c) 2007-2009 Synaptics, Inc.
>> + *
>> + * To support a different device - for example if the GPIOs are different or
>> + * different hardware is being used - make a copy of this file and change the
>> + * name to reflect the new hardware platform then modify it to support the new
>> + * platforms hardware (interrupts, IC chip, etc.).
>> + *
>> + */
>> +/*
>> + * This file is licensed under the GPL2 license.
>> + *
>> + *#############################################################################
>> + * GPL
>> + *
>> + * This program is free software; you can redistribute it and/or modify it
>> + * under the terms of the GNU General Public License version 2 as published
>> + * by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful, but
>> + * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
>> + * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
>> + * for more details.
>> + *
>> + *#############################################################################
>> + */
>> +
>> +#include<linux/module.h>
>> +#include<linux/jiffies.h>
>> +#include<linux/platform_device.h>
>> +#include<linux/interrupt.h>
>> +#include<asm/gpio.h>
>> +#include "rmi_i2c.h"
>> +
>> +/* Set this to either 1 or 0 depending on your clearpad hardware. */
>> +#define ATTENTION_ACTIVE_LOW 1
>> +
>> +#if ATTENTION_ACTIVE_LOW
>> +#   define IRQ_TRIGGER IRQF_TRIGGER_FALLING
>> +#else
>> +#   define IRQ_TRIGGER IRQF_TRIGGER_RISING
>> +#endif
>> +
>> +#define GPF3 S3C2410_GPF3
>> +#define GPF3INT3 S3C2410_GPF3_EINT3
>> +#define IRQINT3 IRQ_EINT3
>> +
>> +#define GPIO_CFG s3c2410_gpio_cfgpin(S3C2410_GPF3, S3C2410_GPF3_EINT3)
>> +
>> +static int
>> +get_attention(void)
>> +{
>> +#if ATTENTION_ACTIVE_LOW
>> +     return gpio_get_value_cansleep(GPF3) ? 0 : 1;
>> +#else
>> +     return gpio_get_value_cansleep(GPF3) ? 1 : 0;
>> +#endif
>> +}
>> +
>> +static struct rmi_i2c_clientdata rmi_test_clientdata[] = {
>> +  [0] = {
>> +    .i2c_address   = 0x20,
>> +    .irq           = IRQINT3,
>> +    .irq_type      = IRQ_TRIGGER,
>> +    .get_attention = get_attention,
>> +  },
>> +};
>> +
>> +static struct rmi_i2c_data rmi_client_data = {
>> +  .num_clients = ARRAY_SIZE(rmi_test_clientdata),
>> +  .clientdata  = rmi_test_clientdata,
>> +};
>> +
>> +static void
>> +rmi_i2c_release(struct device *dev)
>> +{
>> +     struct platform_device *pd = container_of(dev, struct platform_device, dev);
>> +
>> +     kfree(pd);
>> +}
>> +
>> +static struct platform_device *gta01_rmi_device;
>> +
>> +/*
>> + * These are the module insert and remove functions.
>> + */
>> +static int __init
>> +mod_init(void)
>> +{
>> +     struct platform_device *pd;
>> +
>> +     printk(KERN_INFO "GTA01 RMI4 Platform Driver Init.\n");
>> +
>> +     gta01_rmi_device = pd = kmalloc(sizeof(*pd), GFP_KERNEL);
>
> kzalloc. Or even better platform_device_alloc().

Agreed, will do.

>
>> +     if (!pd)
>> +             return -ENOMEM;
>> +     memset(pd, 0, sizeof(*pd));
>> +
>> +     /* Set up the GPIO for interrupts */
>> +     GPIO_CFG;
>> +
>> +     pd->name              = "rmi4-i2c";
>> +     pd->id                = -1;
>> +     pd->dev.platform_data =&rmi_client_data;
>> +     pd->dev.release       = rmi_i2c_release;
>> +
>> +     return platform_device_register(pd);
>
> I do not see why this module is needed - there is no corresponding
> platform driver.

Initial driver development was done on the GTA01, so this tags along. 
We're not sentimental about it, though, so it can be removed.

[snip]

>> +/**
>> + * This function detects each device on the i2c bus and sets up the structures
>> + * for it.
>> + */
>> +static int
>> +rmi_i2c_detect(struct i2c_client *client, struct i2c_board_info *board)
>> +{
>> +     struct instance_data *id;
>> +     int retval;
>> +     int i;
>> +
>> +     pr_debug("rmi_i2c: Detect: address = %08x\n", board->addr);
>> +
>> +     id = kmalloc(sizeof(*id) * 2, GFP_KERNEL);
>> +     if (!id) {
>> +             printk(KERN_ERR "rmi_i2c: Out of memory\n");
>> +             return -ENOMEM;
>> +     }
>> +
>> +     memset(id, 0, sizeof(*id));
>
> Kzalloc.

Agreed, will do.

>
>> +
>> +     id->rpd.name           = DRIVER_NAME;
>> +     id->rpd.write          = rmi_i2c_write;
>> +     id->rpd.read           = rmi_i2c_read;
>> +     id->rpd.write_multiple = rmi_i2c_write_multiple;
>> +     id->rpd.read_multiple  = rmi_i2c_read_multiple;
>> +     id->rpd.get_attention  = rmi_i2c_get_attention;
>> +     id->rpd.module         = THIS_MODULE;
>> +     id->page               = 0xffff;    /* So we set the page correctly the first time */
>> +
>> +     /* "Attach" the i2c client to the i2c adapter */
>> +     id->i2cclient.addr    = board->addr;
>> +     id->i2cclient.driver  =&rmi_i2c_driver;
>> +     strlcpy(id->i2cclient.name, "rmi_i2c", I2C_NAME_SIZE);
>> +     i2c_set_clientdata(&id->i2cclient, id);
>> +
>> +     /* Loop through the client data and locate the one that was found. */
>> +     for (i = 0; i<  num_clients; i++) {
>> +             if (board->addr == clientdata[i].i2c_address) {
>> +                     id->instance_no = i;
>> +                     id->get_attention = clientdata[i].get_attention;
>> +                     /*
>> +                      * Determine if we need to poll (inefficient) or use
>> +                      * interrupts.
>> +                      */
>> +                     if (clientdata[i].irq) {
>> +                             int irqtype;
>> +
>> +                             id->irq = clientdata[i].irq;
>> +                             switch (clientdata[i].irq_type) {
>> +                             case IORESOURCE_IRQ_HIGHEDGE:
>> +                                     irqtype = IRQF_TRIGGER_RISING;
>> +                                     break;
>> +                             case IORESOURCE_IRQ_LOWEDGE:
>> +                                     irqtype = IRQF_TRIGGER_FALLING;
>> +                                     break;
>> +                             case IORESOURCE_IRQ_HIGHLEVEL:
>> +                                     irqtype = IRQF_TRIGGER_HIGH;
>> +                                     break;
>> +                             case IORESOURCE_IRQ_LOWLEVEL:
>> +                                     irqtype = IRQF_TRIGGER_LOW;
>> +                                     break;
>> +                             default:
>> +                                     printk(KERN_WARNING "rmi_i2c: Invalid IRQ flags in "
>> +                                             "platform data\n");
>> +                                     kfree(id);
>> +                                     return -ENXIO;
>> +                             }
>> +
>> +                             retval = request_irq(id->irq, i2c_attn_isr,
>> +                                               IRQF_DISABLED | irqtype, "rmi_i2c", id);
>> +                             if (retval) {
>> +                                     printk(KERN_WARNING "rmi_i2c: Unable to get attn "
>> +                                       "irq %d.  Reverting to polling.\n",
>> +                                       id->irq);
>> +                                     goto do_polling;
>> +                             }
>> +                             pr_debug("rmi_i2c: got irq\n");
>> +                             id->rpd.polling_required = 0;
>> +                     } else {
>> +do_polling:
>> +                             id->rpd.polling_required = 1;
>> +                             printk(KERN_INFO "rmi_i2c: No IRQ info given. "
>> +                                     "Polling required.\n");
>> +                     }
>> +
>> +                     /* We found it, so exit the loop */
>> +                     break;
>> +             }
>> +     }
>> +
>
>
> Umm, I really doubt this whole function is correct. Please CC Jean
> Delvare<khali@linux-fr.org>  for further i2c bits review.

OK, we'll do that in a separate email.  We're trying to cut over to the 
newer approach to i2c, and it's possible we don't understand it entirely.

>
>> +     retval = rmi_register_phys_driver(&id->rpd);
>> +     if (retval) {
>> +             printk(KERN_ERR "rmi_i2c : Failed to Register %s phys driver\n", id->rpd.name);
>> +
>> +             if (id->irq) {
>> +                     free_irq(id->irq, id);
>> +             }
>> +             kfree(id);
>> +             return retval;
>> +     }
>> +
>> +     printk(KERN_INFO "rmi_i2c : Successfully Registered %s phys driver\n", id->rpd.name);
>> +
>> +     rmi_set_page(id, 0x04);
>
> Why set page is done here?

We need to initialize it somewhere.  It makes more sense to do it in the 
declaration, though, so that's what we'll do.

>
>> +
>> +     return 0;
>> +}
>> +
>> +
>> +/**
>> + * The Driver probe function.  We just tell the i2c subsystem about
>> + * ourselves in this call.
>> + */
>> +static int
>> +rmi_i2c_probe(struct i2c_client *client, const struct i2c_device_id *dev_id)
>> +{
>> +     pr_debug("Probing i2c RMI device\n");
>> +
>> +     pr_debug("Calling i2c_add_driver\n");
>> +     return i2c_add_driver(&rmi_i2c_driver);
>
> I have no idea what this code tires to do... rmi_i2c_probe is probe()
> methid of rmi_i2c_driver.... which tries to register rmi_i2c_driver
> again????

We'll check this and either correct it or delete it.


>> +}
>> +
>> +/**
>> + * The Driver remove function.  We tear down the instance data and unregister the phys driver
>> + * in this call.
>> + */
>> +static int
>> +rmi_i2c_remove(struct i2c_client *client)
>> +{
>> +     struct instance_data *id =
>> +             container_of(client, struct instance_data, i2cclient);
>
> You normally attach instance data with i2c_{get|set}_clientdata().

Noted, will correct.

>> +
>> +     /* flush_scheduled_work(); */
>> +
>> +     pr_debug("Unregistering phys driver %s\n", id->rpd.name);
>> +
>> +     rmi_unregister_phys_driver(&id->rpd);
>> +
>> +     pr_debug("Unregistered phys driver %s\n", id->rpd.name);
>> +
>> +     if (id->irq) {
>> +             free_irq(id->irq, id);
>> +     }
>> +
>> +     kfree(id);
>> +     pr_debug("remove successful\n");
>> +
>> +     return 0;
>> +}
>> +
>> +/**
>> + * This structure tells the i2c subsystem about us.
>> + */
>> +static struct i2c_driver rmi_i2c_driver = {
>> +     .driver = {
>> +             .name  = DRIVER_NAME,
>> +             .owner = THIS_MODULE,
>> +     },
>> +     .probe = rmi_i2c_probe,
>> +             .detect = rmi_i2c_detect,
>
> Bad indent.

We'll correct this.

>
>> +     .remove = rmi_i2c_remove,
>> +     .id_table = rmi_i2c_id_table,
>> +};
>> +
>> +/** Print an informational message to the kernel
>> + * log and register ourselves with the Platform Driver Subsystem.
>> + * This will be called when the module is inserted.
>> + * \return the result of our call to platform_driver_register()
>
> You do not call platform_driver_register() anywhere.

Good point.  We'll check to see if that's an omission or else remove 
platform_driver_register().

[snip]
