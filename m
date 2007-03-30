Return-Path: <linux-kernel-owner+w=401wt.eu-S1945940AbXC3Edq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945940AbXC3Edq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 00:33:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945941AbXC3Edq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 00:33:46 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:5998 "EHLO
	asav15.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945940AbXC3Edp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 00:33:45 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AswMAOMvDEZKhRO4UGdsb2JhbACHQYg9AQEq
From: Dmitry Torokhov <dtor@insightbb.com>
To: Li Yu <raise.sail@gmail.com>
Subject: Re: [linux-usb-devel] [RFC] HID bus design overview.
Date: Fri, 30 Mar 2007 00:33:20 -0400
User-Agent: KMail/1.9.3
Cc: Jiri Kosina <jkosina@suse.cz>, yanghong@ccoss.com.cn,
       linux-usb-devel <linux-usb-devel@lists.sourceforge.net>,
       hongzhiyi@ccoss.com.cn, Marcel Holtmann <marcel@holtmann.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <200703051532096508636@gmail.com> <d120d5000703281200wd914f51s18437a6a8e4107f6@mail.gmail.com> <460C7EB4.9080009@gmail.com>
In-Reply-To: <460C7EB4.9080009@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703300033.22059.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 March 2007 23:06, Li Yu wrote:
> Dmitry Torokhov wrote:
> > On 3/28/07, Jiri Kosina <jkosina@suse.cz> wrote:
> >>
> >> The crucial thing here is that all reports but the ones that the driver
> >> registered to will be processed in a standard way by the generic hid bus
> >> layer, and those reports that the driver registered to will be
> >> ignored by
> >> the layer, and passed for processing to the driver.
> >>
> >
> > I don't think it is a good idea to register driver for specific
> > usages/reports. Quite often you want to adjust processing of a report
> > for a specific device. What if there are 2 devices that need such
> > quirks? How will you do hotplug and module loading? Emit new uevent
> > for every report? Also, what about users and Kconfig? "Driver for
> > usage 0x000012345. Say Y if your hardware does not wotk correctly with
> > defautl handler for this usage and require special processing"???
> >
> > Just register based on VID/PID and provide standard
> > hid_default_input_event() to drivers so they would call it for reports
> > they don't need to do special processing on.
> >
> 
>     I think the shadow driver can not share inputdev with the related
> fundamental driver, so here are two input devices for one hid_device,
> how we should process both? It seem we have three choices:
> 
> 1. Shadow | Fundamental means
> 
>     I think this is Jiri said. Fundamental driver handle all common
> input events, and Shadow driver handle anther specific input events,
> this imply user space process need monitor both input devices at same
> time, I do not think this is good idea.
> 
> 2. Shadow & Fundamental means
> 
>     Let Fundamental driver and Shadow driver work at same time! but
> shadow also handle specific input event. So, the user may get twice
> input events! For example, the keyboard input in console.
> Also, I do not like this.
> 
> 3. Shadow ^ Fundamental means
> 
>     Let Shadow driver handle every thing, and fundamental device silent,
> even unregister it. I think this is best choice between them, this means
> have a bit of complex.
>


There should be one device and your driver should simply do:

static void my_driver_hid_event(struct hid_device *hid, struct hid_field *field,
				struct hid_usage *usage, __s32 value)
{
	if (special_processing_needed(usage)) {
		do_special_processing(...);
		input_event(field->hidinput->input, XXX, YYY, ZZZ);
		...

	} else
		hidinput_hid_event(hid, field, usage, value);
}

That is pretty much it. Your driver is not a shadow driver, it is
regular driver on HID bus that just happens to use generic hander
for standard events.

-- 
Dmitry
