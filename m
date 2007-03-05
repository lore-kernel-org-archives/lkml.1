Return-Path: <linux-kernel-owner+w=401wt.eu-S1752059AbXCEHch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059AbXCEHch (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 02:32:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752714AbXCEHch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 02:32:37 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:62847 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059AbXCEHcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 02:32:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=uo78rfP2gEgoGFmvKFjKUmTDaqevxvy8vgeYFXU7k3juPdrhqPJC5nGlw7XuGBwLInfX3mRWcZ1MUC8C7yLpuYKH8BYQuNI4WUq7tfeNgl5MXgZZd/dPs52gPiQuUvC9/bRFy6Do0yBBDz4uWfAp3rYLojl4577LSu/psny3D54=
Date: Mon, 5 Mar 2007 15:32:15 +0800
From: "Li Yu" <raise.sail@gmail.com>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
       "Greg Kroah Hartman" <greg@kroah.com>,
       "linux-usb-devel" <linux-usb-devel@lists.sourceforge.net>,
       "LKML" <linux-kernel@vger.kernel.org>,
       "Vincent Legoll" <vincentlegoll@gmail.com>,
       "Zephaniah E. Hull" <warp@aehallh.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Harold Sargeant" <harold-sargeant@ntlworld.com>
Cc: "liyu" <liyu@ccoss.com.cn>
Subject: [DOC] The documentation for HID Simple Driver Interface 0.5.0
Message-ID: <200703051532096508636@gmail.com>
X-mailer: Foxmail 6, 5, 104, 21 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

==================================
HID device simple driver interface
==================================

------------------------
Note
------------------------

 If you just begin to study from writing input device driver, please see the
input-programming.txt, I am afraid this is not you want, do not confuse with the
"simple" in this name.

------------------------
Version
------------------------

 This is used for the version 0.5.0

--------------------------
Overview
--------------------------

 Under standard HID device driver development means, we need to write
one interrupt handler for each new HID device to report event to
input subsystem. However, although the most of they can not merge into
mainstream kernel tree, they have only some extended keys, e.g. many
remote controllers. I think it seem break a fly on the wheel, which
write one new interrupt handler for this reason.

 The basic idea is reuse the interrupt handler in hid-core.c. so writing
driver for new simple HID device will be more easier, quickly, and do not
need touch hid core.

 In essence, this interface just is some hooks in HID core.

 The hid-simple.h include this API. But, defore use this interface, you must
include hid.h first.

------------------------
What's you will get from this interface.
------------------------

 Use me, you can:

 1. Write the driver of USB input device without write code take care of
 details of setup and clear usage.
 2. A driver use this interface can be as a HID device input filter.

 This interface can not support the more drivers handle one device at same time
yet. I can not sure if we really need this feature.

-------------------------
Prepare
-------------------------

 Before use this interface, you must turn on these kernel configuration
items:

 CONFIG_HID_SIMPLE : HID simple driver interface

--------------------------
Register and unregister
--------------------------

1. Register a simple driver.

 int hidinput_register_simple_driver(struct hidinput_simple_driver *simple)

 Like any driver register function, it register your driver to kernel,
when the chance that match device come, your driver can probe it. At least, you
must fill the member of parameter simple : name.
 Return 0 mean register successfully. elsewise mean there have some
failures in register process.
 So far, this function only can return 0 and -EINVAL.
 When you driver matched one device, it will reregister it into input
subsystem (see the function hidinput_reconnect_core(), if you want).
 This function generally is used in HID sublayer.

2. Unregister a simple driver.

 void hidinput_unregister_simple_driver(struct hidinput_simple_driver *simple)

 Like any driver register function, it clean your driver from kernel, and
in this process, your driver will disconnect any device which it matched. However,
it do not free your memory of driver structure, that's your task.
 This may reregister the device into input subsystem (see the function
hidinput_reconnect_core(), if you want).
 This function generally is used in HID sublayer.

3. USB device driver.
 
 You should use follow functions for USB device. the usage of these functions is 
same with aboves.

int hidinput_register_simple_usb_driver(struct hidinput_simple_driver *simple)
void hidinput_unregister_simple_usb_driver(struct hidinput_simple_driver *simple)

 Both functions is used in driver. 

----------------------------------
Usage
----------------------------------

 Each simple driver have one data structure hidinput_simple_driver:

struct hidinput_simple_driver {
 /*
 * The members for implement only are ignored here,
 * please do not depend on them
 */
 /* public for HID sublayer. */
 int (*match_device)(struct hidinput_simple_driver *drv,
                               struct matched_device *dev);

 /* public for drivers */
 struct module *owner;
 char *name;
 int (*connect)(struct hid_device *, struct hid_input *);
 void (*disconnect)(struct hid_device *, struct hid_input *);
 void (*setup_usage)(struct hid_field *, struct hid_usage *);
 void (*clear_usage)(struct hid_field *, struct hid_usage *);
 int (*pre_event)(const struct hid_device *, const struct hid_field *,
				 const struct hid_usage *, const __s32);
 int (*post_event)(const struct hid_device *, const struct hid_field *,
				 const struct hid_usage *, const __s32);
 int (*open)(struct input_dev *dev);
 void (*close)(struct input_dev *dev);

 void *private;
 struct usb_device_id *id_table;
 struct usage_page_block *usage_page_table;
};

The data member description:

 struct module *owner;

 In most cases, set this member to THIS_MODULE is your want to.

 char *name;

 The name of your driver. you must fill this member before register it.

 void *private;

 You can save the data that your driver use only here. HID simple driver
core do not take care of this.

 struct usb_device_id *id_table;

 As same with other USB device driver, this is used by matching device,
if so, then call probe()/connect() methods of your driver.
 In general, you always want to fill this member with something.

 struct usage_page_block *usage_page_table;

 Totally, there are three means you can complete setup and clean HID usage work,
which use this member is one of them. Moreover, this means is the most simplest one.
By fill this member, kernel will complete setup and clean usage work automatically.
 It will spend many words to explain details, I think the best documentation
of this is the example, you can find them in usbnek4k.c and btp2118.c. I believe
you have enough intelligence to understand them, but if you had familiar
with HID first.  :)  When you read these examples, you also will find out some other
related data structures ,however, don't worry, they are too simple to not discuss
them.

--------------------------------
Generic Methods
--------------------------------

The simple driver methods description:

 Although this simple driver have not direct relation with Linux
device driver architecture, but I still make its API like it on purpose.
The simple driver have follow methods:

1. int (*connect)(struct hid_device *, struct hid_input *);
2. void (*disconnect)(struct hid_device *, struct hid_input *);

 When you simple driver is to bind with one real HID device, we will
call connect() method first. To return 0 flag that it complete its mission
successfully, so we can continue, return any other value is looked as
error, any processing do not come.
 When the device which your simple driver connect with is down, or
this simple driver is unregistered, we will call disconnect() method first.

3. void (*setup_usage)(struct hid_field *, struct hid_usage *);
4. void (*clear_usage)(struct hid_field *, struct hid_usage *);

 The setup_usage() method like hidinput_configure_usage() in
hid_input.c. You also can setup input_dev here. I think
you should be fill the pointer slot for this method, or fill usage_page_table
member of hidinput_simple_driver, elsewise the event() method do not work for
you at all. Please see example in "MS Natural Ergonomic Keyboard 4000" driver.
 The clear_usage() method is used to clear side-effect that came from
setup_usage() method when one driver disconnect one device.
 Of course, you can do same things in connect/disconnect() method, but
these method can make your life more simpler.
 At last, you can use these two methods and usage_page_table member
at same time. These two methods always will be called after kernel process
usage_page_table.

6. int (*pre_event)(const struct hid_device *, const struct hid_field*,
					const struct hid_usage *, const __s32);

 First, you can use this method send event to input subsystem,
moreover, you can use this as one usage code filter: this method is called
before all other event handling. If it return non-zero , any other event
handling do not be processed, even the hid-input itself. If this method
return zero, the normally event handling process will continue.
 See the note [1].

7. void (*post_event)(const struct hid_device *, const struct hid_field *,
					const struct hid_usage *, const __s32);

 This is called after all other event handling. So if the pre_event() method
return non-zero value, this method also do not called at all.
 See the note [1].

8. int (*open)(struct input_dev *dev);
9. void (*close)(struct input_dev *dev);

 They are same with corresponding methods of struct input_dev. I assume
you already familiar with them.

10. int (*match_device)(struct hidinput_simple_driver *drv, struct matched_device *dev);

 Return non-zero mean drv is matched for dev. An example of its implementation can be 
found in drivers/usb/input/hid-core.c

=================================================================================

NOTE:

[1] If you do not configure usage correctly, this method do not work as
 you want.

