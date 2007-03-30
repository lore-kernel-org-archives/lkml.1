Return-Path: <linux-kernel-owner+w=401wt.eu-S1752679AbXC3SOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679AbXC3SOX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 14:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752311AbXC3SOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 14:14:23 -0400
Received: from wr-out-0506.google.com ([64.233.184.228]:53277 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578AbXC3SOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 14:14:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=L2F5WncmZZkhvjJ7SHe7S3TX8sZh9MPaav6U4v2xl+vkCQh7L/yY6dJpcNZRUthSEKcaAIS3wvQu5txqpn91STsVU6l3VR4Ywb5lTxUvytd0b806w1XtH9zP20EGTA/lGq9xYuVmsQXKzPs1nYGyZ2pd/TSByOZt5V7nksOInTI=
Message-ID: <d120d5000703301114r420a9604i34b6a015e6bad285@mail.gmail.com>
Date: Fri, 30 Mar 2007 14:14:20 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Pete Zaitcev" <zaitcev@redhat.com>
Subject: Re: usb hid: reset NumLock
Cc: "Jiri Kosina" <jkosina@suse.cz>, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, stuard_hayes@dell.com
In-Reply-To: <20070330105924.01a16dd6.zaitcev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070330105924.01a16dd6.zaitcev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pete,

On 3/30/07, Pete Zaitcev <zaitcev@redhat.com> wrote:
>
> I didn't like a) layering violation, and b) that they defeat filtering
> unconditionally. Why have any filtering then?
>
> Instead, I propose for USB HID driver to reset NumLock on probe. Like this:
>
> --- a/drivers/usb/input/hid-core.c
> +++ b/drivers/usb/input/hid-core.c
> @@ -458,6 +458,18 @@ static int usb_hidinput_input_event(struct input_dev *dev, unsigned int type, un
>        return 0;
>  }
>
> +static void usbhid_set_leds(struct hid_device *hid, unsigned int code, int val)
> +{
> +       struct hid_field *field;
> +       int offset;
> +
> +       /* This is often called for the mouse half. */
> +       if ((offset = hidinput_find_field(hid, EV_LED, code, &field)) != -1) {
> +               hid_set_field(field, offset, val);
> +               usbhid_submit_report(hid, field->report, USB_DIR_OUT);
> +       }
> +}
> +

This is fine and that's what we do in atkbd probe but maybe we should
move that in input core and reset leds as part of
input_register_device()?

-- 
Dmitry
