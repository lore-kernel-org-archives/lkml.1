Return-Path: <linux-kernel-owner+w=401wt.eu-S1753995Ab0AHUuJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab0AHUuJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 15:50:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752783Ab0AHUuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 15:50:07 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:55464 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab0AHUuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 15:50:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sJQrSGt9yTCpkrRYGhtqPrNprYF8xWU459VWv2GU9f9rC9nUE8u/6bt0C4aM8rB7kp
         QGPbP8b27bW848xJRkmVf0wC2YNglYiKFFRx8Q0Jr9SziLeRiTxtvN9vGdMghZsWkYvI
         0pPdVUixzExNDCJandNnAK+Z/bPAyi6gSTY6A=
Date: Fri, 8 Jan 2010 12:49:46 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
Cc: linux-kernel@vger.kernel.org, felipe.balbi@nokia.com, pavel@ucw.cz,
       jayakumar.lkml@gmail.com, linux-fbdev@vger.kernel.org,
       krzysztof.h1@wp.pl, akpm@linux-foundation.org,
       linux-usb@vger.kernel.org, oliver@neukum.org,
       linux-input@vger.kernel.org, jkosina@suse.cz
Subject: Re: [PATCH] hid: Logitech G13 driver 0.0.3
Message-ID: <20100108204946.GA22950@core.coreip.homeip.net>
References: <201001071623.o07GNOB4022157@mustang.cs.nmsu.edu>
 <20100108083020.GB3696@core.coreip.homeip.net>
 <174828e8a25d1e607eb91ab963396b2a.squirrel@intranet.cs.nmsu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <174828e8a25d1e607eb91ab963396b2a.squirrel@intranet.cs.nmsu.edu>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 08, 2010 at 11:32:29AM -0700, Rick L. Vinyard, Jr. wrote:
> Dmitry Torokhov wrote:
> > Hi Rick,
> >
> > On Thu, Jan 07, 2010 at 09:23:24AM -0700, Rick L. Vinyard Jr. wrote:
> >> +
> >> +static int g13_input_setkeycode(struct input_dev *dev,
> >> +				int scancode,
> >> +				int keycode)
> >> +{
> >> +	int old_keycode;
> >> +	int i;
> >> +	struct g13_data *data = input_get_g13data(dev);
> >> +
> >> +	if (data == NULL)
> >> +		return -EINVAL;
> >> +
> >> +	if (scancode >= dev->keycodemax)
> >> +		return -EINVAL;
> >> +
> >> +	if (!dev->keycodesize)
> >> +		return -EINVAL;
> >> +
> >> +	if (dev->keycodesize < sizeof(keycode) &&
> >> +	    (keycode >> (dev->keycodesize * 8)))
> >> +		return -EINVAL;
> >> +
> >> +	write_lock(&data->lock);
> >> +
> >> +	old_keycode = data->keycode[scancode];
> >> +	data->keycode[scancode] = keycode;
> >> +
> >> +	clear_bit(old_keycode, dev->keybit);
> >> +	set_bit(keycode, dev->keybit);
> >> +
> >> +	for (i = 0; i < dev->keycodemax; i++) {
> >> +		if (data->keycode[i] == old_keycode) {
> >> +			set_bit(old_keycode, dev->keybit);
> >> +			break; /* Setting the bit twice is useless, so break */
> >> +		}
> >> +	}
> >> +
> >> +	write_unlock(&data->lock);
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +static int g13_input_getkeycode(struct input_dev *dev,
> >> +				int scancode,
> >> +				int *keycode)
> >> +{
> >> +	struct g13_data *data = input_get_g13data(dev);
> >> +
> >> +	if (!dev->keycodesize)
> >> +		return -EINVAL;
> >> +
> >> +	if (scancode >= dev->keycodemax)
> >> +		return -EINVAL;
> >> +
> >> +	read_lock(&data->lock);
> >> +
> >> +	*keycode = data->keycode[scancode];
> >> +
> >> +	read_unlock(&data->lock);
> >> +
> >> +	return 0;
> >> +}
> >
> > Default input core methods should cover this, no?
> >
> 
> I couldn't find this exposed from input core through sysfs anywhere. From
> userspace I could access it from an ioctl, but I'd prefer to allow
> userspace to do everything from libsysfs rather than a mixture of libsysfs
> and ioctls.
> 
> I did make sure the ioctls are still supported by providing functions to
> input_dev->setkeycode and input_dev->getkeycode.
> 

Unfortunately the input core does more stuff after driver-specific routines
get called. And I am planning to add device rebinding upong keymap
change and more stuff.

> >> +
> >> +static DEVICE_ATTR(keymap, 0666, g13_keymap_show, g13_keymap_store);
> >>
> >
> > No. Just use EVIOCSKEYCODE.
> >
> 
> I'd really prefer to provide a sysfs interface as opposed to ioctls.
> 

I really think we should stick to standard interfaces. For the reason
see above.

> 
> >> +/*
> >> + * The "emit_msc_raw" attribute
> >> + */
> >> +static ssize_t g13_emit_msc_raw_show(struct device *dev,
> >> +				     struct device_attribute *attr,
> >> +				     char *buf)
> >> +{
> >> +	struct g13_data *data = dev_get_drvdata(dev);
> >> +
> >> +	if (data == NULL)
> >> +		return -ENODATA;
> >> +
> >> +	return sprintf(buf, "%u\n", data->emit_msc_raw);
> >> +}
> >> +
> >> +static ssize_t g13_set_emit_msc_raw(struct hid_device *hdev, unsigned
> >> k)
> >> +{
> >> +	struct g13_data *data = hid_get_g13data(hdev);
> >> +
> >> +	if (data == NULL)
> >> +		return -ENODATA;
> >> +
> >> +	data->emit_msc_raw = k;
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +static ssize_t g13_emit_msc_raw_store(struct device *dev,
> >> +				      struct device_attribute *attr,
> >> +				      const char *buf, size_t count)
> >> +{
> >> +	struct hid_device *hdev;
> >> +	int i;
> >> +	unsigned k;
> >> +	ssize_t set_result;
> >> +
> >> +	/* Get the hid associated with the device */
> >> +	hdev = container_of(dev, struct hid_device, dev);
> >> +
> >> +	/* If we have an invalid pointer we'll return ENODATA */
> >> +	if (hdev == NULL || &(hdev->dev) != dev)
> >> +		return -ENODATA;
> >> +
> >> +	i = sscanf(buf, "%u", &k);
> >> +	if (i != 1) {
> >> +		printk(KERN_ERR "unrecognized input: %s", buf);
> >> +		return -1;
> >> +	}
> >> +
> >> +	set_result = g13_set_emit_msc_raw(hdev, k);
> >> +
> >> +	if (set_result < 0)
> >> +		return set_result;
> >> +
> >> +	return count;
> >> +}
> >> +
> >> +static DEVICE_ATTR(emit_msc_raw, 0666,
> >> +		   g13_emit_msc_raw_show,
> >> +		   g13_emit_msc_raw_store);
> >> +
> >
> > I do no see the need for this attribute, simply emit MSC_RAW always.
> >
> 
> Will do.
> 
> >> +
> >> +/*
> >> + * The "keymap_switching" attribute
> >> + */
> >> +static ssize_t g13_keymap_switching_show(struct device *dev,
> >> +					 struct device_attribute *attr,
> >> +					 char *buf)
> >> +{
> >> +	struct g13_data *data = dev_get_drvdata(dev);
> >> +
> >> +	if (data == NULL)
> >> +		return -ENODATA;
> >> +
> >> +	return sprintf(buf, "%u\n", data->keymap_switching);
> >> +}
> >> +
> >> +static ssize_t g13_set_keymap_switching(struct hid_device *hdev,
> >> unsigned k)
> >> +{
> >> +	struct g13_data *data = hid_get_g13data(hdev);
> >> +
> >> +	if (data == NULL)
> >> +		return -ENODATA;
> >> +
> >> +	data->keymap_switching = k;
> >> +
> >> +	if (data->keymap_switching)
> >> +		g13_set_mled(hdev, 1<<(data->curkeymap));
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +static ssize_t g13_keymap_switching_store(struct device *dev,
> >> +					  struct device_attribute *attr,
> >> +					  const char *buf, size_t count)
> >> +{
> >> +	struct hid_device *hdev;
> >> +	int i;
> >> +	unsigned k;
> >> +	ssize_t set_result;
> >> +
> >> +	/* Get the hid associated with the device */
> >> +	hdev = container_of(dev, struct hid_device, dev);
> >> +
> >> +	/* If we have an invalid pointer we'll return ENODATA */
> >> +	if (hdev == NULL || &(hdev->dev) != dev)
> >> +		return -ENODATA;
> >> +
> >> +	i = sscanf(buf, "%u", &k);
> >> +	if (i != 1) {
> >> +		printk(KERN_ERR "unrecognized input: %s", buf);
> >> +		return -1;
> >> +	}
> >> +
> >> +	set_result = g13_set_keymap_switching(hdev, k);
> >> +
> >> +	if (set_result < 0)
> >> +		return set_result;
> >> +
> >> +	return count;
> >> +}
> >> +
> >> +static DEVICE_ATTR(keymap_switching, 0666,
> >> +		   g13_keymap_switching_show,
> >> +		   g13_keymap_switching_store);
> >
> > Hmm, attributes that are changing device state are usually 0644.
> >
> 
> Fixed.
> 
> >> +
> >> +
> >> +static ssize_t g13_name_show(struct device *dev,
> >> +			     struct device_attribute *attr,
> >> +			     char *buf)
> >> +{
> >> +	struct g13_data *data = dev_get_drvdata(dev);
> >> +	int result;
> >> +
> >> +	if (data == NULL)
> >> +		return -ENODATA;
> >> +
> >> +	if (data->name == NULL) {
> >> +		buf[0] = 0x00;
> >> +		return 1;
> >> +	}
> >> +
> >> +	read_lock(&data->lock);
> >> +	result = sprintf(buf, "%s", data->name);
> >> +	read_unlock(&data->lock);
> >> +
> >> +	return result;
> >> +}
> >> +
> >> +static ssize_t g13_name_store(struct device *dev,
> >> +			      struct device_attribute *attr,
> >> +			      const char *buf, size_t count)
> >> +{
> >> +	struct g13_data *data = dev_get_drvdata(dev);
> >> +	size_t limit = count;
> >> +	char *end;
> >> +
> >> +	if (data == NULL)
> >> +		return -ENODATA;
> >> +
> >> +	write_lock(&data->lock);
> >> +
> >> +	if (data->name != NULL) {
> >> +		kfree(data->name);
> >> +		data->name = NULL;
> >> +	}
> >> +
> >> +	end = strpbrk(buf, "\n\r");
> >> +	if (end != NULL)
> >> +		limit = end - buf;
> >> +
> >> +	if (end != buf) {
> >> +
> >> +		if (limit > 100)
> >> +			limit = 100;
> >> +
> >> +		data->name = kzalloc(limit+1, GFP_KERNEL);
> >> +
> >> +		strncpy(data->name, buf, limit);
> >> +	}
> >> +
> >> +	write_unlock(&data->lock);
> >> +
> >> +	return count;
> >> +}
> >> +
> >> +static DEVICE_ATTR(name, 0666, g13_name_show, g13_name_store);
> >
> > What this attribute is for?
> >
> 
> To provide a mnemonic identifier for the device that can be shared across
> applications. It also allows a userspace application to lookup a device by
> name through sysfs.

To set it you need to identify sysfs path fisrt. Once you've identified
sysfs path you can simply use it in other apps. So I do not see the need
for the name.

> 
> >> +
> >> +/*
> >> + * The "rgb" attribute
> >> + * red green blue
> >> + * each with values 0 - 255 (black - full intensity)
> >> + */
> >> +static ssize_t g13_rgb_show(struct device *dev,
> >> +			    struct device_attribute *attr,
> >> +			    char *buf)
> >> +{
> >> +	unsigned r, g, b;
> >> +	struct g13_data *data = dev_get_drvdata(dev);
> >> +
> >> +	if (data == NULL)
> >> +		return -ENODATA;
> >> +
> >> +	r = data->rgb[0];
> >> +	g = data->rgb[1];
> >> +	b = data->rgb[2];
> >> +
> >> +	return sprintf(buf, "%u %u %u\n", r, g, b);
> >> +}
> >> +
> >> +static ssize_t g13_set_rgb(struct hid_device *hdev,
> >> +			   unsigned r, unsigned g, unsigned b)
> >> +{
> >> +	struct g13_data *data = hid_get_g13data(hdev);
> >> +
> >> +	if (data == NULL || data->backlight_report == NULL)
> >> +		return -ENODATA;
> >> +
> >> +	data->backlight_report->field[0]->value[0] = r;
> >> +	data->backlight_report->field[0]->value[1] = g;
> >> +	data->backlight_report->field[0]->value[2] = b;
> >> +	data->backlight_report->field[0]->value[3] = 0x00;
> >> +
> >> +	usbhid_submit_report(hdev, data->backlight_report, USB_DIR_OUT);
> >> +
> >> +	data->rgb[0] = r;
> >> +	data->rgb[1] = g;
> >> +	data->rgb[2] = b;
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +static ssize_t g13_rgb_store(struct device *dev,
> >> +			     struct device_attribute *attr,
> >> +			     const char *buf, size_t count)
> >> +{
> >> +	struct hid_device *hdev;
> >> +	int i;
> >> +	unsigned r;
> >> +	unsigned g;
> >> +	unsigned b;
> >> +	ssize_t set_result;
> >> +
> >> +	/* Get the hid associated with the device */
> >> +	hdev = container_of(dev, struct hid_device, dev);
> >> +
> >> +	/* If we have an invalid pointer we'll return ENODATA */
> >> +	if (hdev == NULL || &(hdev->dev) != dev)
> >> +		return -ENODATA;
> >> +
> >> +	i = sscanf(buf, "%u %u %u", &r, &g, &b);
> >> +	if (i != 3) {
> >> +		printk(KERN_ERR "unrecognized input: %s", buf);
> >> +		return -1;
> >> +	}
> >> +
> >> +	set_result = g13_set_rgb(hdev, r, g, b);
> >> +
> >> +	if (set_result < 0)
> >> +		return set_result;
> >> +
> >> +	return count;
> >> +}
> >> +
> >> +static DEVICE_ATTR(rgb, 0666, g13_rgb_show, g13_rgb_store);
> >> +
> >> +/*
> >> + * Create a group of attributes so that we can create and destroy them
> >> all
> >> + * at once.
> >> + */
> >> +static struct attribute *g13_attrs[] = {
> >> +	&dev_attr_name.attr,
> >> +	&dev_attr_rgb.attr,
> >> +	&dev_attr_mled.attr,
> >> +	&dev_attr_keymap_index.attr,
> >> +	&dev_attr_emit_msc_raw.attr,
> >> +	&dev_attr_keymap_switching.attr,
> >> +	&dev_attr_keymap.attr,
> >> +	&dev_attr_fb_update_rate.attr,
> >> +	&dev_attr_fb_node.attr,
> >> +	NULL,	 /* need to NULL terminate the list of attributes */
> >> +};
> >> +
> >> +/*
> >> + * An unnamed attribute group will put all of the attributes directly
> >> in
> >> + * the kobject directory.  If we specify a name, a subdirectory will be
> >> + * created for the attributes with the directory being the name of the
> >> + * attribute group.
> >> + */
> >> +static struct attribute_group g13_attr_group = {
> >> +	.attrs = g13_attrs,
> >> +};
> >> +
> >> +static struct fb_deferred_io g13_fb_defio = {
> >> +	.delay = HZ / G13FB_UPDATE_RATE_DEFAULT,
> >> +	.deferred_io = g13_fb_deferred_io,
> >> +};
> >> +
> >> +static void g13_raw_event_process_input(struct hid_device *hdev,
> >> +					struct g13_data *g13data,
> >> +     u8 *raw_data)
> >> +{
> >> +	struct input_dev *idev = g13data->input_dev;
> >> +	unsigned int code;
> >> +	int value;
> >> +	int i;
> >> +	int mask;
> >> +	int offset;
> >> +	u8 val;
> >> +
> >> +	g13data->ready2 = 1;
> >> +
> >> +	if (idev == NULL)
> >> +		return;
> >> +
> >> +	if (g13data->curkeymap < 3)
> >> +		offset = G13_KEYS * g13data->curkeymap;
> >> +	else
> >> +		offset = 0;
> >> +
> >> +	for (i = 0, mask = 0x01; i < 8; i++, mask <<= 1) {
> >> +		/* Keys G1 through G8 */
> >> +		code = g13data->keycode[i+offset];
> >> +		value = raw_data[3] & mask;
> >> +		if (g13data->keycode[i] != KEY_RESERVED)
> >> +			input_report_key(idev, code, value);
> >> +		input_event(idev, EV_MSC, MSC_SCAN, i);
> >
> > That means these MSC_SCAN events are emitted _always_. Not sure if that
> > is too useful. If you were to detect the state change and emit MSC_SCAN
> > for changed keys, that would be better.
> >
> 
> I couldn't find anything that really explained the purpose of MSC_SCAN.
> Can I use it just to report scancodes?

Yes, it purpose if to report scancode or it's equivalent of pressed key.

> 
> In particular can I selectively emit MSC_SCAN when I only want to report
> specific events such as an unmapped key or a special key such as the
> backlight or one of the M* keys?

You could, but then users would not really know what scancode to use to
remap already mapped key. The problem with your approach that userspace
will get 10 MSC_SCAN before getting KEY_* event. Not terribly useful.

...

> >> +
> >> +	dbg_hid("Found all reports\n");
> >> +
> >> +	for (i = 0; i < 20; i++) {
> >> +		if (data->ready && data->ready2)
> >> +			break;
> >> +		mdelay(10);
> >> +	}
> >
> > Consider using completion?
> >
> 
> I'm not sure what you mean.

Look at wait_for_completion() and wait_completion_timeout() functions.
These are proper APIs to wait for completion of a certain task instead
of busily (or sleepily) spinning.

> 
> >> +
> >> +	if (!(data->ready && data->ready2))
> >> +		printk(KERN_ERR "G13 hasn't responded yet, forging ahead with
> >> initialization\n");
> >> +	else
> >> +		dbg_hid("G13 initialized\n");
> >> +
> >> +	/*
> >> +	 * Set the initial color and load the linux logo
> >> +	 * We're going to ignore the error values. If there is an error at
> >> this
> >> +	 * point we'll forge ahead.
> >> +	 */
> >> +
> >> +	dbg_hid("Set default color\n");
> >> +
> >> +	error = g13_set_rgb(hdev, G13_DEFAULT_RED, G13_DEFAULT_GREEN,
> >> G13_DEFAULT_BLUE);
> >
> > And...?
> >
> 
> I had an error message before, but took it out. Missed taking out the
> "error =" since at this point we'll just forge ahead.
> 
> Although failing to set the backlight color at this point could indicate
> some I/O issue it's not critical enough to fail driver initialization.
> 

Then dev_warn() is your friend.


Thanks.

-- 
Dmitry
