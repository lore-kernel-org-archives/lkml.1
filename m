Return-Path: <linux-kernel-owner+w=401wt.eu-S1754638Ab0ANSYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638Ab0ANSYi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 13:24:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754218Ab0ANSYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 13:24:37 -0500
Received: from mail.cs.nmsu.edu ([128.123.64.3]:57175 "EHLO mail.cs.nmsu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751338Ab0ANSYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 13:24:36 -0500
Message-ID: <cf0603d7c734f836f0b4a64815d649ae.squirrel@intranet.cs.nmsu.edu>
In-Reply-To: <alpine.LNX.2.00.1001091441180.7275@pobox.suse.cz>
References: <201001071623.o07GNOB4022157@mustang.cs.nmsu.edu>
    <45a44e481001071832q40d6f913w2ccf89c4c45a692a@mail.gmail.com>
    <5370b38ca0c149470c0e364627c56ee4.squirrel@intranet.cs.nmsu.edu>
    <alpine.LNX.2.00.1001091441180.7275@pobox.suse.cz>
Date: Thu, 14 Jan 2010 11:24:17 -0700
Subject: Re: [PATCH] hid: Logitech G13 driver 0.0.3
From: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
To: "Jiri Kosina" <jkosina@suse.cz>
Cc: "Jaya Kumar" <jayakumar.lkml@gmail.com>, linux-kernel@vger.kernel.org,
       felipe.balbi@nokia.com, "Pavel Machek" <pavel@ucw.cz>,
       linux-fbdev@vger.kernel.org, krzysztof.h1@wp.pl,
       "Andrew Morton" <akpm@linux-foundation.org>, linux-usb@vger.kernel.org,
       "Oliver Neukum" <oliver@neukum.org>, linux-input@vger.kernel.org,
       "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
User-Agent: SquirrelMail/1.4.19
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> On Thu, 7 Jan 2010, Rick L. Vinyard, Jr. wrote:
>
>> >> +static ssize_t g13_mled_store(struct device *dev,
>> >> +                             struct device_attribute *attr,
>> >> +        const char *buf, size_t count)
>> >> +{
>> >> +       struct hid_device *hdev;
>> >> +       int i;
>> >> +       unsigned m[4];
>> >> +       unsigned mled;
>> >> +       ssize_t set_result;
>> >> +
>> >> +       /* Get the hid associated with the device */
>> >> +       hdev = container_of(dev, struct hid_device, dev);
>> >> +
>> >> +       /* If we have an invalid pointer we'll return ENODATA */
>> >> +       if (hdev == NULL || &(hdev->dev) != dev)
>> >> +               return -ENODATA;
>> >> +
>> >> +       i = sscanf(buf, "%u %u %u %u", m, m+1, m+2, m+3);
>> >> +       if (!(i == 4 || i == 1)) {
>> >> +               printk(KERN_ERR "unrecognized input: %s", buf);
>> >> +               return -1;
>> >> +       }
>> >> +
>> >> +       if (i == 1)
>> >> +               mled = m[0];
>> >> +       else
>> >> +               mled = (m[0] ? 1 : 0) | (m[1] ? 2 : 0) |
>> >> +                               (m[2] ? 4 : 0) | (m[3] ? 8 : 0);
>> >> +
>> >> +       set_result = g13_set_mled(hdev, mled);
>> >> +
>> >> +       if (set_result < 0)
>> >> +               return set_result;
>> >> +
>> >> +       return count;
>> >> +}
>> >> +
>> >> +static DEVICE_ATTR(mled, 0666, g13_mled_show, g13_mled_store);
>> >
>> > Have you considered the use of the LED class driver as an alternative
>> > to introducing these sysfs led controls for the device?
>> >
>>
>> I did, but this seemed a simpler approach to let user space (such as a
>> daemon) manage the leds. In particular this could be used by a user
>> space
>> program to map the keys. The MR led could be used to indicate an active
>> record mode, etc.
>
> I finally had some time to go through the driver as well (thanks Dmitry
> for beating me with proper review).
>
> Could you be more specific about reasons why you are hesitating to use LED
> subsystem instead of the whole mled stuff in the driver?
>
> I don't see anything that couldn't be achieved using LED class.
>

It seems to overly complicate the driver, especially as these are LEDS
inside the buttons. I don't think they will leverage the bulk of the LED
structure such as triggers, brightness, et. al.

It also seems to complicate the userspace access. A single
sysfs_get_device_attr() is replaced with looking up a unique device
identifier, creating a unique led device path, an additional
sysfs_open_device_path() and then the sysfs_get_device_attr().

But, I've added the LED class support.

However, the question I have now is that each device as it's registered
will have to be assigned a unique identifier so that each led can be
uniquely named for each device, otherwise there will be conflicts in
/sys/class/leds/.

Since the led naming scheme is "device:color:function" I was thinking of
using the minor number of the hid device and name the leds
"g13_minor#:red:m1" et. al.

But, I'd really prefer to use something that userspace can access from
sysfs to build the led device path. That way, given a udev device and a
numeric led value you could do something like:

  struct sysfs_device* leddev;
  struct sysfs_attribute* bright_attr;
  char* ledsyspath;
  char ledvalstr[4] = {0};
  ledsyspath = malloc(strlen(udev_device_get_syspath(udev_device)+22);

  *** Here you need to get the minor hid # ***

  sprintf(ledsyspath, "%s/leds/g13_%d:red:m1",
          udev_device_get_syspath(udev_device), minor);
  leddev = sysfs_open_device_path(ledsyspath);
  bright_attr = sysfs_get_device_attr(leddev, "brightness");
  sprintf(ledvalstr,"%d",ledval);
  sysfs_write_attribute(sysfsattr, ledvalstr, 4);

Any suggestions other than the minor number?

Thanks,

---

Rick


