Return-Path: <linux-kernel-owner+w=401wt.eu-S1753288Ab0AHCcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288Ab0AHCcc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 21:32:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753155Ab0AHCca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 21:32:30 -0500
Received: from mail-iw0-f194.google.com ([209.85.223.194]:41312 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136Ab0AHCc3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 21:32:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=eh04Y8JomB7OlDAuGl5wPQlG3W/YUaNkmdUlWDbaUGYps0Uj2l4IAQPpDV4iXrzPPB
         fE3OLi9ndvrKWub9Av5kZ0eyHIv1OQII30R9PTtTx8gAohF52/yj8+XNWQcBOE6q5Qxq
         DrWIBlqww5a74GCryO39S4GQdT5SX8tDrneeU=
MIME-Version: 1.0
In-Reply-To: <201001071623.o07GNOB4022157@mustang.cs.nmsu.edu>
References: <201001071623.o07GNOB4022157@mustang.cs.nmsu.edu>
Date: Fri, 8 Jan 2010 10:32:28 +0800
Message-ID: <45a44e481001071832q40d6f913w2ccf89c4c45a692a@mail.gmail.com>
Subject: Re: [PATCH] hid: Logitech G13 driver 0.0.3
From: Jaya Kumar <jayakumar.lkml@gmail.com>
To: "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>
Cc: linux-kernel@vger.kernel.org, felipe.balbi@nokia.com, pavel@ucw.cz,
       linux-fbdev@vger.kernel.org, krzysztof.h1@wp.pl,
       akpm@linux-foundation.org, linux-usb@vger.kernel.org, oliver@neukum.org,
       linux-input@vger.kernel.org, jkosina@suse.cz
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 8, 2010 at 12:23 AM, Rick L. Vinyard Jr.
<rvinyard@cs.nmsu.edu> wrote:
> +       /*
> +        * Translate the XBM format screen_base into the format needed by the
> +        * G13. This format places the pixels in a vertical rather than
> +        * horizontal format. Assuming a grid with 0,0 in the upper left corner
> +        * and 159,42 in the lower right corner, the first byte contains the
> +        * pixels 0,0 through 0,7 and the second byte contains the pixels 1,0
> +        * through 1,7. Within the byte, bit 0 represents 0,0; bit 1 0,1; etc.
> +        *
> +        * This loop operates in reverse to shift the lower bits into their
> +        * respective positions, shifting the lower rows into the higher bits.
> +        *
> +        * The offset is calculated for every 8 rows and is adjusted by 32 since
> +        * that is what the G13 image message expects.
> +        */
> +       for (row = G13FB_HEIGHT-1; row >= 0; row--) {
> +               offset = 32 + row/8 * G13FB_WIDTH;
> +               u = data->fb_vbitmap + offset;
> +               /*
> +                * Iterate across the screen_base columns to get the
> +                * individual bits
> +                */
> +               for (col = 0; col < G13FB_LINE_LENGTH; col++) {
> +                       /*
> +                        * We will work with a temporary value since we don't
> +                        * want to modify screen_base as we shift each bit
> +                        * downward.
> +                        */
> +                       temp = data->fb_bitmap[row * G13FB_LINE_LENGTH + col];
> +
> +                       /*
> +                        * For each bit in the pixel row we will shift it onto
> +                        * the appropriate by by shift the g13 byte up by 1 and
> +                        * simply doing a bitwise or of the low byte
> +                        */
> +                       for (bit = 0; bit < 8; bit++) {
> +                               /*Shift the g13 byte up by 1 for this new row*/
> +                               u[bit] <<= 1;
> +                               /* Bring in the new pixel of temp */
> +                               u[bit] |= (temp & 0x01);
> +                               /*
> +                                * Shift temp down so the low pixel is ready
> +                                * for the next byte
> +                                */
> +                               temp >>= 1;
> +                       }
> +
> +                       /*
> +                        * The last byte represented 8 vertical pixels so we'll
> +                        * jump ahead 8
> +                        */
> +                       u += 8;
> +               }
> +       }

I didn't read this portion carefully. I assume everything above is
being accessed bytewise and that there is no chance of any unaligned
access. I didn't see any endian code so can we also assume above is
also endian safe. Is there a way that you could use the standard fbmem
logo infrastructure in fbdev? If it is lacking in some way, maybe the
right thing to do is to improve that so that other devices like this
one could use it in future.


> +/*
> + * The "fb_node" attribute
> + */
> +static ssize_t g13_fb_node_show(struct device *dev,
> +                               struct device_attribute *attr,
> +                               char *buf)
> +{
> +       unsigned fb_node;
> +       struct g13_data *data = dev_get_drvdata(dev);
> +
> +       if (data == NULL)
> +               return -ENODATA;
> +
> +       fb_node = data->fb_info->node;
> +
> +       return sprintf(buf, "%u\n", fb_node);
> +}
> +
> +static DEVICE_ATTR(fb_node, 0444, g13_fb_node_show, NULL);

I didn't quite understand the purpose of above and how it would be
used to the benefit of userspace.

> +
> +
> +/*
> + * The "fb_update_rate" attribute
> + */
> +static ssize_t g13_fb_update_rate_show(struct device *dev,
> +                                      struct device_attribute *attr,
> +                                      char *buf)
> +{
> +       unsigned fb_update_rate;
> +       struct g13_data *data = dev_get_drvdata(dev);
> +
> +       if (data == NULL)
> +               return -ENODATA;
> +
> +       fb_update_rate = data->fb_update_rate;
> +
> +       return sprintf(buf, "%u\n", fb_update_rate);
> +}
> +
> +static ssize_t g13_set_fb_update_rate(struct hid_device *hdev,
> +                                     unsigned fb_update_rate)
> +{
> +       struct g13_data *data = hid_get_g13data(hdev);
> +
> +       if (data == NULL)
> +               return -ENODATA;
> +
> +       if (fb_update_rate > G13FB_UPDATE_RATE_LIMIT)
> +               data->fb_update_rate = G13FB_UPDATE_RATE_LIMIT;
> +       else if (fb_update_rate == 0)
> +               data->fb_update_rate = 1;
> +       else
> +               data->fb_update_rate = fb_update_rate;
> +
> +       data->fb_defio.delay = HZ / data->fb_update_rate;
> +
> +       return 0;
> +}
> +
> +static ssize_t g13_fb_update_rate_store(struct device *dev,
> +                                       struct device_attribute *attr,
> +                                       const char *buf, size_t count)
> +{
> +       struct hid_device *hdev;
> +       int i;
> +       unsigned u;
> +       ssize_t set_result;
> +
> +       /* Get the hid associated with the device */
> +       hdev = container_of(dev, struct hid_device, dev);
> +
> +       /* If we have an invalid pointer we'll return ENODATA */
> +       if (hdev == NULL || &(hdev->dev) != dev)
> +               return -ENODATA;
> +
> +       i = sscanf(buf, "%u", &u);
> +       if (i != 1) {
> +               printk(KERN_ERR "unrecognized input: %s", buf);
> +               return -1;
> +       }
> +
> +       set_result = g13_set_fb_update_rate(hdev, u);
> +
> +       if (set_result < 0)
> +               return set_result;
> +
> +       return count;
> +}
> +
> +static DEVICE_ATTR(fb_update_rate, 0666,
> +                  g13_fb_update_rate_show,
> +                  g13_fb_update_rate_store);
> +
> +

Okay, this update rate stuff and rate limit is interesting. I assume
you are using this fbdev interface with some kind of custom fbdev
client. Or are you using X or dfb with it? Thinking about it, I didn't
quite understand why there's a rate limit since if you set your defio
delay, then isn't that automatically limiting the rate? You might want
to document what these sysfs attrs do exactly and how you want it to
be used since it is exposed to userspace.

> +/*
> + * The "mled" attribute
> + * on or off for each of the four M led's (M1 M2 M3 MR)
> + */
> +static ssize_t g13_mled_show(struct device *dev,
> +                            struct device_attribute *attr,
> +       char *buf)
> +{
> +       unsigned mled;
> +       struct g13_data *data = dev_get_drvdata(dev);
> +
> +       if (data == NULL)
> +               return -ENODATA;
> +
> +       mled = data->mled;
> +
> +       return sprintf(buf, "%u\n", mled);
> +}
> +
> +static ssize_t g13_set_mled(struct hid_device *hdev, unsigned mled)
> +{
> +       struct g13_data *data = hid_get_g13data(hdev);
> +
> +       if (data == NULL || data->mled_report == NULL)
> +               return -ENODATA;
> +
> +       data->mled_report->field[0]->value[0] = mled&0x0F;
> +       data->mled_report->field[0]->value[1] = 0x00;
> +       data->mled_report->field[0]->value[2] = 0x00;
> +       data->mled_report->field[0]->value[3] = 0x00;
> +
> +       usbhid_submit_report(hdev, data->mled_report, USB_DIR_OUT);
> +
> +       data->mled = mled;
> +
> +       return 0;
> +}
> +
> +static ssize_t g13_mled_store(struct device *dev,
> +                             struct device_attribute *attr,
> +        const char *buf, size_t count)
> +{
> +       struct hid_device *hdev;
> +       int i;
> +       unsigned m[4];
> +       unsigned mled;
> +       ssize_t set_result;
> +
> +       /* Get the hid associated with the device */
> +       hdev = container_of(dev, struct hid_device, dev);
> +
> +       /* If we have an invalid pointer we'll return ENODATA */
> +       if (hdev == NULL || &(hdev->dev) != dev)
> +               return -ENODATA;
> +
> +       i = sscanf(buf, "%u %u %u %u", m, m+1, m+2, m+3);
> +       if (!(i == 4 || i == 1)) {
> +               printk(KERN_ERR "unrecognized input: %s", buf);
> +               return -1;
> +       }
> +
> +       if (i == 1)
> +               mled = m[0];
> +       else
> +               mled = (m[0] ? 1 : 0) | (m[1] ? 2 : 0) |
> +                               (m[2] ? 4 : 0) | (m[3] ? 8 : 0);
> +
> +       set_result = g13_set_mled(hdev, mled);
> +
> +       if (set_result < 0)
> +               return set_result;
> +
> +       return count;
> +}
> +
> +static DEVICE_ATTR(mled, 0666, g13_mled_show, g13_mled_store);

Have you considered the use of the LED class driver as an alternative
to introducing these sysfs led controls for the device?


> +
> +static int g13_input_setkeycode(struct input_dev *dev,
> +                               int scancode,
> +                               int keycode)
> +{
> +       int old_keycode;
> +       int i;
> +       struct g13_data *data = input_get_g13data(dev);
> +
> +       if (data == NULL)
> +               return -EINVAL;
> +
> +       if (scancode >= dev->keycodemax)
> +               return -EINVAL;
> +
> +       if (!dev->keycodesize)
> +               return -EINVAL;
> +
> +       if (dev->keycodesize < sizeof(keycode) &&
> +           (keycode >> (dev->keycodesize * 8)))
> +               return -EINVAL;
> +
> +       write_lock(&data->lock);
> +
> +       old_keycode = data->keycode[scancode];
> +       data->keycode[scancode] = keycode;
> +
> +       clear_bit(old_keycode, dev->keybit);
> +       set_bit(keycode, dev->keybit);
> +
> +       for (i = 0; i < dev->keycodemax; i++) {
> +               if (data->keycode[i] == old_keycode) {
> +                       set_bit(old_keycode, dev->keybit);
> +                       break; /* Setting the bit twice is useless, so break */
> +               }
> +       }
> +
> +       write_unlock(&data->lock);
> +
> +       return 0;
> +}
> +
> +static int g13_input_getkeycode(struct input_dev *dev,
> +                               int scancode,
> +                               int *keycode)
> +{
> +       struct g13_data *data = input_get_g13data(dev);
> +
> +       if (!dev->keycodesize)
> +               return -EINVAL;
> +
> +       if (scancode >= dev->keycodemax)
> +               return -EINVAL;
> +
> +       read_lock(&data->lock);
> +
> +       *keycode = data->keycode[scancode];
> +
> +       read_unlock(&data->lock);
> +
> +       return 0;
> +}
> +
> +
> +/*
> + * The "keymap" attribute
> + */
> +static ssize_t g13_keymap_index_show(struct device *dev,
> +                                    struct device_attribute *attr,
> +                                    char *buf)
> +{
> +       struct g13_data *data = dev_get_drvdata(dev);
> +
> +       if (data == NULL)
> +               return -ENODATA;
> +
> +       return sprintf(buf, "%u\n", data->curkeymap);
> +}
> +
> +static ssize_t g13_set_keymap_index(struct hid_device *hdev, unsigned k)
> +{
> +       struct g13_data *data = hid_get_g13data(hdev);
> +
> +       if (data == NULL)
> +               return -ENODATA;
> +
> +       if (k > 2)
> +               return -EINVAL;
> +
> +       data->curkeymap = k;
> +
> +       if (data->keymap_switching)
> +               g13_set_mled(hdev, 1<<k);
> +
> +       return 0;
> +}
> +
> +static ssize_t g13_keymap_index_store(struct device *dev,
> +                                     struct device_attribute *attr,
> +                                     const char *buf, size_t count)
> +{
> +       struct hid_device *hdev;
> +       int i;
> +       unsigned k;
> +       ssize_t set_result;
> +
> +       /* Get the hid associated with the device */
> +       hdev = container_of(dev, struct hid_device, dev);
> +
> +       /* If we have an invalid pointer we'll return ENODATA */
> +       if (hdev == NULL || &(hdev->dev) != dev)
> +               return -ENODATA;
> +
> +       i = sscanf(buf, "%u", &k);
> +       if (i != 1) {
> +               printk(KERN_ERR "unrecognized input: %s", buf);
> +               return -1;
> +       }
> +
> +       set_result = g13_set_keymap_index(hdev, k);
> +
> +       if (set_result < 0)
> +               return set_result;
> +
> +       return count;
> +}
> +
> +static DEVICE_ATTR(keymap_index, 0666,
> +                  g13_keymap_index_show,
> +                  g13_keymap_index_store);
> +
> +/*
> + * The "keycode" attribute
> + */
> +static ssize_t g13_keymap_show(struct device *dev,
> +                              struct device_attribute *attr,
> +                              char *buf)
> +{
> +       int i;
> +       int offset = 0;
> +       int result;
> +
> +       struct g13_data *data = dev_get_drvdata(dev);
> +
> +       if (data == NULL)
> +               return -ENODATA;
> +
> +       for (i = 0; i < G13_KEYMAP_SIZE; i++) {
> +               result = sprintf(buf+offset,
> +                                "0x%03x 0x%04x\n",
> +                                i, data->keycode[i]);
> +               if (result < 0)
> +                       return -EINVAL;
> +               offset += result;
> +       }
> +
> +       return offset+1;
> +}
> +
> +static ssize_t g13_keymap_store(struct device *dev,
> +                               struct device_attribute *attr,
> +                               const char *buf, size_t count)
> +{
> +       struct hid_device *hdev;
> +       int scanned;
> +       int consumed;
> +       int scancd;
> +       int keycd;
> +       int set_result;
> +       int set = 0;
> +       int gkey;
> +       int index;
> +       int good;
> +       struct g13_data *data;
> +
> +       /* Get the hid associated with the device */
> +       hdev = container_of(dev, struct hid_device, dev);
> +
> +       /* If we have an invalid pointer we'll return ENODATA */
> +       if (hdev == NULL || &(hdev->dev) != dev)
> +               return -ENODATA;
> +
> +       /* Now, let's get the data structure */
> +       data = hid_get_g13data(hdev);
> +       if (data == NULL)
> +               return -ENODATA;
> +
> +       do {
> +               good = 0;
> +
> +               /* Look for scancode keycode pair in hex */
> +               scanned = sscanf(buf, "%x %x%n", &scancd, &keycd, &consumed);
> +               if (scanned == 2) {
> +                       buf += consumed;
> +                       set_result = g13_input_setkeycode(data->input_dev, scancd, keycd);
> +                       if (set_result < 0)
> +                               return set_result;
> +                       set++;
> +                       good = 1;
> +               } else {
> +                       /*
> +                        * Look for Gkey keycode pair and assign to current
> +                        * keymap
> +                        */
> +                       scanned = sscanf(buf, "G%d %x%n", &gkey, &keycd, &consumed);
> +                       if (scanned == 2 && gkey > 0 && gkey <= G13_KEYS) {
> +                               buf += consumed;
> +                               scancd = data->curkeymap * G13_KEYS + gkey - 1;
> +                               set_result = g13_input_setkeycode(data->input_dev, scancd, keycd);
> +                               if (set_result < 0)
> +                                       return set_result;
> +                               set++;
> +                               good = 1;
> +                       } else {
> +                               /*
> +                                * Look for Gkey-index keycode pair and assign
> +                                * to indexed keymap
> +                                */
> +                               scanned = sscanf(buf, "G%d-%d %x%n", &gkey, &index, &keycd, &consumed);
> +                               if (scanned == 3 &&
> +                                   gkey > 0 && gkey <= G13_KEYS &&
> +                                   index >= 0 && index <= 2) {
> +                                       buf += consumed;
> +                                       scancd = index * G13_KEYS + gkey - 1;
> +                                       set_result = g13_input_setkeycode(data->input_dev, scancd, keycd);
> +                                       if (set_result < 0)
> +                                               return set_result;
> +                                       set++;
> +                                       good = 1;
> +                               }
> +                       }
> +               }
> +
> +       } while (good);
> +
> +       if (set == 0) {
> +               printk(KERN_ERR "unrecognized keycode input: %s", buf);
> +               return -1;
> +       }
> +
> +       return count;
> +}
> +
> +static DEVICE_ATTR(keymap, 0666, g13_keymap_show, g13_keymap_store);
> +
> +/*
> + * The "emit_msc_raw" attribute
> + */
> +static ssize_t g13_emit_msc_raw_show(struct device *dev,
> +                                    struct device_attribute *attr,
> +                                    char *buf)
> +{
> +       struct g13_data *data = dev_get_drvdata(dev);
> +
> +       if (data == NULL)
> +               return -ENODATA;
> +
> +       return sprintf(buf, "%u\n", data->emit_msc_raw);
> +}
> +
> +static ssize_t g13_set_emit_msc_raw(struct hid_device *hdev, unsigned k)
> +{
> +       struct g13_data *data = hid_get_g13data(hdev);
> +
> +       if (data == NULL)
> +               return -ENODATA;
> +
> +       data->emit_msc_raw = k;
> +
> +       return 0;
> +}
> +
> +static ssize_t g13_emit_msc_raw_store(struct device *dev,
> +                                     struct device_attribute *attr,
> +                                     const char *buf, size_t count)
> +{
> +       struct hid_device *hdev;
> +       int i;
> +       unsigned k;
> +       ssize_t set_result;
> +
> +       /* Get the hid associated with the device */
> +       hdev = container_of(dev, struct hid_device, dev);
> +
> +       /* If we have an invalid pointer we'll return ENODATA */
> +       if (hdev == NULL || &(hdev->dev) != dev)
> +               return -ENODATA;
> +
> +       i = sscanf(buf, "%u", &k);
> +       if (i != 1) {
> +               printk(KERN_ERR "unrecognized input: %s", buf);
> +               return -1;
> +       }
> +
> +       set_result = g13_set_emit_msc_raw(hdev, k);
> +
> +       if (set_result < 0)
> +               return set_result;
> +
> +       return count;
> +}
> +
> +static DEVICE_ATTR(emit_msc_raw, 0666,
> +                  g13_emit_msc_raw_show,
> +                  g13_emit_msc_raw_store);
> +
> +
> +/*
> + * The "keymap_switching" attribute
> + */
> +static ssize_t g13_keymap_switching_show(struct device *dev,
> +                                        struct device_attribute *attr,
> +                                        char *buf)
> +{
> +       struct g13_data *data = dev_get_drvdata(dev);
> +
> +       if (data == NULL)
> +               return -ENODATA;
> +
> +       return sprintf(buf, "%u\n", data->keymap_switching);
> +}
> +
> +static ssize_t g13_set_keymap_switching(struct hid_device *hdev, unsigned k)
> +{
> +       struct g13_data *data = hid_get_g13data(hdev);
> +
> +       if (data == NULL)
> +               return -ENODATA;
> +
> +       data->keymap_switching = k;
> +
> +       if (data->keymap_switching)
> +               g13_set_mled(hdev, 1<<(data->curkeymap));
> +
> +       return 0;
> +}
> +
> +static ssize_t g13_keymap_switching_store(struct device *dev,
> +                                         struct device_attribute *attr,
> +                                         const char *buf, size_t count)
> +{
> +       struct hid_device *hdev;
> +       int i;
> +       unsigned k;
> +       ssize_t set_result;
> +
> +       /* Get the hid associated with the device */
> +       hdev = container_of(dev, struct hid_device, dev);
> +
> +       /* If we have an invalid pointer we'll return ENODATA */
> +       if (hdev == NULL || &(hdev->dev) != dev)
> +               return -ENODATA;
> +
> +       i = sscanf(buf, "%u", &k);
> +       if (i != 1) {
> +               printk(KERN_ERR "unrecognized input: %s", buf);
> +               return -1;
> +       }
> +
> +       set_result = g13_set_keymap_switching(hdev, k);
> +
> +       if (set_result < 0)
> +               return set_result;
> +
> +       return count;
> +}
> +
> +static DEVICE_ATTR(keymap_switching, 0666,
> +                  g13_keymap_switching_show,
> +                  g13_keymap_switching_store);
> +
> +
> +static ssize_t g13_name_show(struct device *dev,
> +                            struct device_attribute *attr,
> +                            char *buf)
> +{
> +       struct g13_data *data = dev_get_drvdata(dev);
> +       int result;
> +
> +       if (data == NULL)
> +               return -ENODATA;
> +
> +       if (data->name == NULL) {
> +               buf[0] = 0x00;
> +               return 1;
> +       }
> +
> +       read_lock(&data->lock);
> +       result = sprintf(buf, "%s", data->name);
> +       read_unlock(&data->lock);
> +
> +       return result;
> +}
> +
> +static ssize_t g13_name_store(struct device *dev,
> +                             struct device_attribute *attr,
> +                             const char *buf, size_t count)
> +{
> +       struct g13_data *data = dev_get_drvdata(dev);
> +       size_t limit = count;
> +       char *end;
> +
> +       if (data == NULL)
> +               return -ENODATA;
> +
> +       write_lock(&data->lock);
> +
> +       if (data->name != NULL) {
> +               kfree(data->name);
> +               data->name = NULL;
> +       }
> +
> +       end = strpbrk(buf, "\n\r");
> +       if (end != NULL)
> +               limit = end - buf;
> +
> +       if (end != buf) {
> +
> +               if (limit > 100)
> +                       limit = 100;
> +
> +               data->name = kzalloc(limit+1, GFP_KERNEL);
> +
> +               strncpy(data->name, buf, limit);
> +       }
> +
> +       write_unlock(&data->lock);
> +
> +       return count;
> +}
> +
> +static DEVICE_ATTR(name, 0666, g13_name_show, g13_name_store);
> +
> +/*
> + * The "rgb" attribute
> + * red green blue
> + * each with values 0 - 255 (black - full intensity)
> + */
> +static ssize_t g13_rgb_show(struct device *dev,
> +                           struct device_attribute *attr,
> +                           char *buf)
> +{
> +       unsigned r, g, b;
> +       struct g13_data *data = dev_get_drvdata(dev);
> +
> +       if (data == NULL)
> +               return -ENODATA;
> +
> +       r = data->rgb[0];
> +       g = data->rgb[1];
> +       b = data->rgb[2];
> +
> +       return sprintf(buf, "%u %u %u\n", r, g, b);
> +}
> +
> +static ssize_t g13_set_rgb(struct hid_device *hdev,
> +                          unsigned r, unsigned g, unsigned b)
> +{
> +       struct g13_data *data = hid_get_g13data(hdev);
> +
> +       if (data == NULL || data->backlight_report == NULL)
> +               return -ENODATA;
> +
> +       data->backlight_report->field[0]->value[0] = r;
> +       data->backlight_report->field[0]->value[1] = g;
> +       data->backlight_report->field[0]->value[2] = b;
> +       data->backlight_report->field[0]->value[3] = 0x00;
> +
> +       usbhid_submit_report(hdev, data->backlight_report, USB_DIR_OUT);
> +
> +       data->rgb[0] = r;
> +       data->rgb[1] = g;
> +       data->rgb[2] = b;
> +
> +       return 0;
> +}
> +
> +static ssize_t g13_rgb_store(struct device *dev,
> +                            struct device_attribute *attr,
> +                            const char *buf, size_t count)
> +{
> +       struct hid_device *hdev;
> +       int i;
> +       unsigned r;
> +       unsigned g;
> +       unsigned b;
> +       ssize_t set_result;
> +
> +       /* Get the hid associated with the device */
> +       hdev = container_of(dev, struct hid_device, dev);
> +
> +       /* If we have an invalid pointer we'll return ENODATA */
> +       if (hdev == NULL || &(hdev->dev) != dev)
> +               return -ENODATA;
> +
> +       i = sscanf(buf, "%u %u %u", &r, &g, &b);
> +       if (i != 3) {
> +               printk(KERN_ERR "unrecognized input: %s", buf);
> +               return -1;
> +       }
> +
> +       set_result = g13_set_rgb(hdev, r, g, b);
> +
> +       if (set_result < 0)
> +               return set_result;
> +
> +       return count;
> +}
> +
> +static DEVICE_ATTR(rgb, 0666, g13_rgb_show, g13_rgb_store);
> +
> +/*
> + * Create a group of attributes so that we can create and destroy them all
> + * at once.
> + */
> +static struct attribute *g13_attrs[] = {
> +       &dev_attr_name.attr,
> +       &dev_attr_rgb.attr,
> +       &dev_attr_mled.attr,
> +       &dev_attr_keymap_index.attr,
> +       &dev_attr_emit_msc_raw.attr,
> +       &dev_attr_keymap_switching.attr,
> +       &dev_attr_keymap.attr,
> +       &dev_attr_fb_update_rate.attr,
> +       &dev_attr_fb_node.attr,
> +       NULL,    /* need to NULL terminate the list of attributes */
> +};

Hmm, that's a lot of stuff that you're exposing to userspace. I didn't
read through the code carefully so I don't have a good understanding
of why all that is necessary, some of them (led at least), seem to me
like duplicates of existing userspace interfaces. I have to head out
now, sorry for the incremental feedback, but I hope it is useful.

Thanks,
jaya
