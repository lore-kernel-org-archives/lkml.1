Return-Path: <linux-kernel-owner+w=401wt.eu-S1751771AbXCaWoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771AbXCaWoV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 18:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752661AbXCaWoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 18:44:21 -0400
Received: from styx.suse.cz ([82.119.242.94]:54326 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751771AbXCaWoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 18:44:20 -0400
Date: Sun, 1 Apr 2007 00:49:26 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Dmitry Torokhov <dtor@insightbb.com>
Cc: Li Yu <raise.sail@gmail.com>, yanghong@ccoss.com.cn,
       linux-usb-devel <linux-usb-devel@lists.sourceforge.net>,
       hongzhiyi@ccoss.com.cn, Marcel Holtmann <marcel@holtmann.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] [RFC] HID bus design overview.
In-Reply-To: <200703300033.22059.dtor@insightbb.com>
Message-ID: <Pine.LNX.4.64.0704010002280.6040@jikos.suse.cz>
References: <200703051532096508636@gmail.com>
 <d120d5000703281200wd914f51s18437a6a8e4107f6@mail.gmail.com>
 <460C7EB4.9080009@gmail.com> <200703300033.22059.dtor@insightbb.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Mar 2007, Dmitry Torokhov wrote:

> There should be one device and your driver should simply do:
> static void my_driver_hid_event(struct hid_device *hid, struct hid_field *field,
> 				struct hid_usage *usage, __s32 value)
> {
> 	if (special_processing_needed(usage)) {
> 		do_special_processing(...);
> 		input_event(field->hidinput->input, XXX, YYY, ZZZ);
> 		...
> 
> 	} else
> 		hidinput_hid_event(hid, field, usage, value);
> }

Hi,

in fact I am not entirely sure that the specialized drivers hooked to the 
HID bus should be passed individual fields/usages by the generic HID 
driver. That would imply that generic HID layer would have to parse the 
received report using information retrieved from the report descriptor of 
the device. But this is in some way in contrary to one of the features 
this effort should be heading to, isn't it? We want to provide means how 
to bypass possible errors in HID descriptor of the device (or do any other 
possible quirky handling) - we want to be able to allow for completely 
different interpretation of fields than the generic HID parser would do, 
right?

So I guess the above should rather be

static void my_driver_hid_report(struct hid_device *hid, u8 *data, 
				 int size)
{
      if (special_processing_needed(data)) {
              do_special_processing(...);
              input_event(field->hidinput->input, XXX, YYY, ZZZ);
              ...
      } else
              hid_input_report(hid, data, size);
}


Such driver will register itself onto a HID bus. Both USB and BT 
transports could provide VID and PID which could then be easily matched 
against by the bus code to easily check whether processing by specialized 
driver is needed or handling by (existing) generic HID layer is enough.

As an added value, hooking the hidraw code to this architecture would then 
be rather a trivial task.

Thanks,

-- 
Jiri Kosina
