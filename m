Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757536Ab0BXS2R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 13:28:17 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:48610 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757471Ab0BXS2P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 13:28:15 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Bruno =?utf-8?q?Pr=C3=A9mont?= <bonbons@linux-vserver.org>
Subject: Re: [PATCH 1/3] picolcd: driver for PicoLCD HID device
Date: Wed, 24 Feb 2010 19:27:53 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc8-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
       linux-usb@vger.kernel.org, linux-fbdev@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>,
       Nicu Pavel <npavel@ituner.com>
References: <20100221002001.0a7e05a7@neptune.home> <20100224170049.0d04af3c@neptune.home>
In-Reply-To: <20100224170049.0d04af3c@neptune.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201002241927.53532.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 24. Februar 2010 17:00:49 schrieb Bruno Prémont:
> +static int picolcd_raw_event(struct hid_device *hdev,
> +               struct hid_report *report, u8 *raw_data, int size)
> +{
> +       struct picolcd_data *data = hid_get_drvdata(hdev);
> +       char hexdata[25];
> +       int i;
> +
> +       if (data == NULL)
> +               return 1;
> +
> +       for (i = 0; i < sizeof(hexdata) / 2; i++)
> +               sprintf(hexdata+2*i, "%02hhx", raw_data[i]);
> +       if (size >= sizeof(hexdata)/2) {
> +               hexdata[sizeof(hexdata)-4] = '.';
> +               hexdata[sizeof(hexdata)-3] = '.';
> +               hexdata[sizeof(hexdata)-2] = '.';
> +               hexdata[sizeof(hexdata)-1] = '\0';
> +       } else
> +               hexdata[size*2] = '\0';
> +
> +       switch (report->id) {
> +       case REPORT_KEYPAD:
> +               if (size == 3 && raw_data[0] == 0x11 && data->input_keys) {
> +                       return picolcd_raw_keypad(hdev, report, raw_data+1, size-1);
> +               } else {
> +                       dbg_hid(PICOLCD_NAME " unsupported key event (%d bytes): 0x%s\n", size, hexdata);
> +                       break;
> +               }
> +               break;
> +       case REPORT_VERSION:
> +               if (size == 3)
> +                       dev_info(&hdev->dev, "Firmware version is %hd.%hd\n", raw_data[1], raw_data[2]);
> +
> +               spin_lock(&data->lock);

If I recall correctly raw_event is called in interrupt. As you take a spinlock here,
the lock in code not called in interrupt must disable interrupts, or you may
deadlock.

	Regards
		Oliver
