Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158Ab0BJUb1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 15:31:27 -0500
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:49360 "HELO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756099Ab0BJUbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 15:31:24 -0500
From: Michael Poole <mdpoole@troilus.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
       Marcel Holtmann <marcel@holtmann.org>, linux-bluetooth@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Add a device driver for the Apple Magic Mouse.
References: <87y6j2eeqv.fsf_-_@troilus.org> <87pr4eeemz.fsf_-_@troilus.org>
	<20100210182024.GA29610@core.coreip.homeip.net>
Date: Wed, 10 Feb 2010 15:31:16 -0500
In-Reply-To: <20100210182024.GA29610@core.coreip.homeip.net> (Dmitry
	Torokhov's message of "Wed, 10 Feb 2010 10:20:24 -0800")
Message-ID: <87d40cestn.fsf@troilus.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'll post a patch for these based on Jiri's for-next tree this evening.

Dmitry Torokhov writes:

> Hi Michael,
>
> On Tue, Feb 09, 2010 at 08:13:08AM -0500, Michael Poole wrote:
>> +
>> +static bool emulate_3button = 1;
>
> If it is a bool then values should be true/false.

Thanks.

>> +module_param(emulate_3button, bool, 0644);
>> +MODULE_PARM_DESC(emulate_3button, "Emulate a middle button");
>> +
>> +static int middle_button_start = -350;
>> +static int middle_button_stop = +350;
>> +
>> +static bool emulate_scroll_wheel = 1;
>> +module_param(emulate_scroll_wheel, bool, 0644);
>> +MODULE_PARM_DESC(emulate_scroll_wheel, "Emulate a scroll wheel");
>> +
>> +static bool report_touches = 1;
>> +module_param(report_touches, bool, 0644);
>> +MODULE_PARM_DESC(report_touches, "Emit touch records (otherwise, only use them for emulation)");
>> +
>> +static bool report_undeciphered = 0;
>
> No need to initialize statics to 0/false.

Okay, I'll remote that.

[snip]
>> +        int last_state = test_bit(BTN_LEFT, msc->input->key) << 0 |
>> +                test_bit(BTN_RIGHT, msc->input->key) << 1 |
>> +                test_bit(BTN_MIDDLE, msc->input->key) << 2;
>
> Indented with spaces, we prefer tabs.

Whoops -- one of my machines must be misconfigured.  I'll fix that.

[snip]
>> +		if (report_undeciphered) {
>> +			input_event(input, EV_MSC, MSC_RAW, tdata[7]);
>> +		}
>
> No need for braces for single statement.

Okay.

[snip]
>> +	if (emulate_scroll_wheel)
>> +		set_bit(REL_WHEEL, input->relbit);
>
> I'd use __set_bit() instead, no need to lock the bus.

Okay.  I wasn't aware of that semantic difference.

>> +
>> +	if (report_touches) {
>> +		set_bit(EV_ABS, input->evbit);
>> +
>> +		set_bit(ABS_MT_TRACKING_ID, input->absbit);
>> +		input->absmin[ABS_MT_TRACKING_ID] = 0;
>> +		input->absmax[ABS_MT_TRACKING_ID] = 15;
>> +		input->absfuzz[ABS_MT_TRACKING_ID] = 0;
>
> input_set_abs_params() is a bit more compact.

Thanks -- more idiomatic is always handy.

[snip]
>> +	ret = hdev->hid_output_raw_report(hdev, feature_1, sizeof(feature_1),
>> +			HID_FEATURE_REPORT);
>
> This will cause transmission of on-stack data through USB which it does
> not like.

Current Magic Mouse devices are Bluetooth-only.  Is this an issue for
that stack as well?  (hid-sony.c and hid-wacom.c also use
hid_output_raw_report() with on-stack buffers for Bluetooth devices --
if they need it too, I can write a patch for those.  I have a PS3
controller that I can test with, but don't have a Wacom tablet.)  Would
making those buffers static put them in an appropriate section, or does
the memory need to be allocated from a heap?

>> +	if (ret != sizeof(feature_1)) {
>> +		dev_err(&hdev->dev, "unable to request touch data (1:%d)\n",
>> +				ret);
>> +		goto err_free;
>> +	}
>> +	ret = hdev->hid_output_raw_report(hdev, feature_2,
>> +			sizeof(feature_2), HID_FEATURE_REPORT);
>
> Same here.
>
>> +	if (ret != sizeof(feature_2)) {
>> +		dev_err(&hdev->dev, "unable to request touch data (2:%d)\n",
>> +				ret);
>> +		goto err_free;
>> +	}
>> +
>> +	input = input_allocate_device();
>> +	if (!input) {
>> +		dev_err(&hdev->dev, "can't alloc input device\n");
>> +		ret = -ENOMEM;
>> +		goto err_free;
>> +	}
>> +	magicmouse_setup_input(input, hdev);
>> +
>> +	ret = input_register_device(input);
>> +	if (ret) {
>> +		dev_err(&hdev->dev, "input device registration failed\n");
>> +		goto err_both;
>> +	}
>> +	msc->input = input;
>> +
>> +	return 0;
>> + err_both:
>> +	input_free_device(input);
>> + err_free:
>> +	kfree(msc);
>> +	return ret;
>
> hid_hw_stop() is missing in error path. Also see question about freeing
> report below.

Thanks, I'll add the hid_hw_stop().

>> +}
>> +
>> +static void magicmouse_remove(struct hid_device *hdev)
>> +{
>
> Do we need to unregister report (I am not that familiar with HID, who is
> responsible for cleaning report lists?)?

hid-core.c's hid_device_release() frees all the reports that registered
with hid_register_report().

Michael Poole
