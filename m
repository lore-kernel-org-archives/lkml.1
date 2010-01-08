Return-Path: <linux-kernel-owner+w=401wt.eu-S1754273Ab0AHW1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273Ab0AHW1Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 17:27:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754168Ab0AHW1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 17:27:23 -0500
Received: from mail.cs.nmsu.edu ([128.123.64.3]:52253 "EHLO mail.cs.nmsu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754063Ab0AHW1W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 17:27:22 -0500
Message-ID: <00a07c3325a5a8a7f746ecc118cc0a66.squirrel@intranet.cs.nmsu.edu>
In-Reply-To: <20100108204946.GA22950@core.coreip.homeip.net>
References: <201001071623.o07GNOB4022157@mustang.cs.nmsu.edu>
    <20100108083020.GB3696@core.coreip.homeip.net>
    <174828e8a25d1e607eb91ab963396b2a.squirrel@intranet.cs.nmsu.edu>
    <20100108204946.GA22950@core.coreip.homeip.net>
Date: Fri, 8 Jan 2010 15:27:04 -0700
Subject: Re: [PATCH] hid: Logitech G13 driver 0.0.3
From: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, felipe.balbi@nokia.com, pavel@ucw.cz,
       jayakumar.lkml@gmail.com, linux-fbdev@vger.kernel.org,
       krzysztof.h1@wp.pl, akpm@linux-foundation.org,
       linux-usb@vger.kernel.org, oliver@neukum.org,
       linux-input@vger.kernel.org, jkosina@suse.cz
User-Agent: SquirrelMail/1.4.19
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
> On Fri, Jan 08, 2010 at 11:32:29AM -0700, Rick L. Vinyard, Jr. wrote:
>> Dmitry Torokhov wrote:
>> > Hi Rick,
>> >
>> > On Thu, Jan 07, 2010 at 09:23:24AM -0700, Rick L. Vinyard Jr. wrote:
>> >> +
>> >> +static int g13_input_setkeycode(struct input_dev *dev,
>> >> +				int scancode,
>> >> +				int keycode)
>> >> +{
>> >> +	int old_keycode;
>> >> +	int i;
>> >> +	struct g13_data *data = input_get_g13data(dev);
>> >> +
>> >> +	if (data == NULL)
>> >> +		return -EINVAL;
>> >> +
>> >> +	if (scancode >= dev->keycodemax)
>> >> +		return -EINVAL;
>> >> +
>> >> +	if (!dev->keycodesize)
>> >> +		return -EINVAL;
>> >> +
>> >> +	if (dev->keycodesize < sizeof(keycode) &&
>> >> +	    (keycode >> (dev->keycodesize * 8)))
>> >> +		return -EINVAL;
>> >> +
>> >> +	write_lock(&data->lock);
>> >> +
>> >> +	old_keycode = data->keycode[scancode];
>> >> +	data->keycode[scancode] = keycode;
>> >> +
>> >> +	clear_bit(old_keycode, dev->keybit);
>> >> +	set_bit(keycode, dev->keybit);
>> >> +
>> >> +	for (i = 0; i < dev->keycodemax; i++) {
>> >> +		if (data->keycode[i] == old_keycode) {
>> >> +			set_bit(old_keycode, dev->keybit);
>> >> +			break; /* Setting the bit twice is useless, so break */
>> >> +		}
>> >> +	}
>> >> +
>> >> +	write_unlock(&data->lock);
>> >> +
>> >> +	return 0;
>> >> +}
>> >> +
>> >> +static int g13_input_getkeycode(struct input_dev *dev,
>> >> +				int scancode,
>> >> +				int *keycode)
>> >> +{
>> >> +	struct g13_data *data = input_get_g13data(dev);
>> >> +
>> >> +	if (!dev->keycodesize)
>> >> +		return -EINVAL;
>> >> +
>> >> +	if (scancode >= dev->keycodemax)
>> >> +		return -EINVAL;
>> >> +
>> >> +	read_lock(&data->lock);
>> >> +
>> >> +	*keycode = data->keycode[scancode];
>> >> +
>> >> +	read_unlock(&data->lock);
>> >> +
>> >> +	return 0;
>> >> +}
>> >
>> > Default input core methods should cover this, no?
>> >
>>
>> I couldn't find this exposed from input core through sysfs anywhere.
>> From
>> userspace I could access it from an ioctl, but I'd prefer to allow
>> userspace to do everything from libsysfs rather than a mixture of
>> libsysfs
>> and ioctls.
>>
>> I did make sure the ioctls are still supported by providing functions to
>> input_dev->setkeycode and input_dev->getkeycode.
>>
>
> Unfortunately the input core does more stuff after driver-specific
> routines
> get called. And I am planning to add device rebinding upong keymap
> change and more stuff.
>

What if I use input_set_keycode()? That way I bypass the ioctl but stay
within the input core standard interface.

>> >> +
>> >> +
>> >> +static ssize_t g13_name_show(struct device *dev,
>> >> +			     struct device_attribute *attr,
>> >> +			     char *buf)
>> >> +{
>> >> +	struct g13_data *data = dev_get_drvdata(dev);
>> >> +	int result;
>> >> +
>> >> +	if (data == NULL)
>> >> +		return -ENODATA;
>> >> +
>> >> +	if (data->name == NULL) {
>> >> +		buf[0] = 0x00;
>> >> +		return 1;
>> >> +	}
>> >> +
>> >> +	read_lock(&data->lock);
>> >> +	result = sprintf(buf, "%s", data->name);
>> >> +	read_unlock(&data->lock);
>> >> +
>> >> +	return result;
>> >> +}
>> >> +
>> >> +static ssize_t g13_name_store(struct device *dev,
>> >> +			      struct device_attribute *attr,
>> >> +			      const char *buf, size_t count)
>> >> +{
>> >> +	struct g13_data *data = dev_get_drvdata(dev);
>> >> +	size_t limit = count;
>> >> +	char *end;
>> >> +
>> >> +	if (data == NULL)
>> >> +		return -ENODATA;
>> >> +
>> >> +	write_lock(&data->lock);
>> >> +
>> >> +	if (data->name != NULL) {
>> >> +		kfree(data->name);
>> >> +		data->name = NULL;
>> >> +	}
>> >> +
>> >> +	end = strpbrk(buf, "\n\r");
>> >> +	if (end != NULL)
>> >> +		limit = end - buf;
>> >> +
>> >> +	if (end != buf) {
>> >> +
>> >> +		if (limit > 100)
>> >> +			limit = 100;
>> >> +
>> >> +		data->name = kzalloc(limit+1, GFP_KERNEL);
>> >> +
>> >> +		strncpy(data->name, buf, limit);
>> >> +	}
>> >> +
>> >> +	write_unlock(&data->lock);
>> >> +
>> >> +	return count;
>> >> +}
>> >> +
>> >> +static DEVICE_ATTR(name, 0666, g13_name_show, g13_name_store);
>> >
>> > What this attribute is for?
>> >
>>
>> To provide a mnemonic identifier for the device that can be shared
>> across
>> applications. It also allows a userspace application to lookup a device
>> by
>> name through sysfs.
>
> To set it you need to identify sysfs path fisrt. Once you've identified
> sysfs path you can simply use it in other apps. So I do not see the need
> for the name.
>

>From an app I use it like this (g13_device is a typedef of struct
udev_device):

g13_device* g13_device_new_from_name( const char * find ) {
  g13_list_entry* devices;
  g13_list_entry *list_entry;
  g13_device* device;
  char* name;

  devices = g13_enumerate_scan_devices_get_list_entry( NULL );

  g13_list_entry_foreach( list_entry, devices ) {
    device = g13_device_new_from_list_entry( list_entry );
    if ( device == NULL ) continue;
    name = g13_device_get_name( device );
    if ( name==NULL || find==NULL || strcmp( name,find )==0 ) {
      g13_device_free_name( name );
      return device;
    }
    g13_device_free_name( name );
    g13_device_unref( device );
  }

  return NULL;
}

Then, an app can be executed by the user with something like:

[ ~]$ g13-set-backlight --name left 255 0 0
[ ~]$ g13-set-backlight --name right 0 255 0

After popt arg processing g13-set-backlight is as simple as:

  device = g13_device_new_from_name(name);
  if ( device != NULL )
  {
    g13_device_set_rgb( device, r, g, b );
    g13_device_unref(device);
  }


>>
>> >> +
>> >> +/*
>> >> + * The "rgb" attribute
>> >> + * red green blue
>> >> + * each with values 0 - 255 (black - full intensity)
>> >> + */
>> >> +static ssize_t g13_rgb_show(struct device *dev,
>> >> +			    struct device_attribute *attr,
>> >> +			    char *buf)
>> >> +{
>> >> +	unsigned r, g, b;
>> >> +	struct g13_data *data = dev_get_drvdata(dev);
>> >> +
>> >> +	if (data == NULL)
>> >> +		return -ENODATA;
>> >> +
>> >> +	r = data->rgb[0];
>> >> +	g = data->rgb[1];
>> >> +	b = data->rgb[2];
>> >> +
>> >> +	return sprintf(buf, "%u %u %u\n", r, g, b);
>> >> +}
>> >> +
>> >> +static ssize_t g13_set_rgb(struct hid_device *hdev,
>> >> +			   unsigned r, unsigned g, unsigned b)
>> >> +{
>> >> +	struct g13_data *data = hid_get_g13data(hdev);
>> >> +
>> >> +	if (data == NULL || data->backlight_report == NULL)
>> >> +		return -ENODATA;
>> >> +
>> >> +	data->backlight_report->field[0]->value[0] = r;
>> >> +	data->backlight_report->field[0]->value[1] = g;
>> >> +	data->backlight_report->field[0]->value[2] = b;
>> >> +	data->backlight_report->field[0]->value[3] = 0x00;
>> >> +
>> >> +	usbhid_submit_report(hdev, data->backlight_report, USB_DIR_OUT);
>> >> +
>> >> +	data->rgb[0] = r;
>> >> +	data->rgb[1] = g;
>> >> +	data->rgb[2] = b;
>> >> +
>> >> +	return 0;
>> >> +}
>> >> +
>> >> +static ssize_t g13_rgb_store(struct device *dev,
>> >> +			     struct device_attribute *attr,
>> >> +			     const char *buf, size_t count)
>> >> +{
>> >> +	struct hid_device *hdev;
>> >> +	int i;
>> >> +	unsigned r;
>> >> +	unsigned g;
>> >> +	unsigned b;
>> >> +	ssize_t set_result;
>> >> +
>> >> +	/* Get the hid associated with the device */
>> >> +	hdev = container_of(dev, struct hid_device, dev);
>> >> +
>> >> +	/* If we have an invalid pointer we'll return ENODATA */
>> >> +	if (hdev == NULL || &(hdev->dev) != dev)
>> >> +		return -ENODATA;
>> >> +
>> >> +	i = sscanf(buf, "%u %u %u", &r, &g, &b);
>> >> +	if (i != 3) {
>> >> +		printk(KERN_ERR "unrecognized input: %s", buf);
>> >> +		return -1;
>> >> +	}
>> >> +
>> >> +	set_result = g13_set_rgb(hdev, r, g, b);
>> >> +
>> >> +	if (set_result < 0)
>> >> +		return set_result;
>> >> +
>> >> +	return count;
>> >> +}
>> >> +
>> >> +static DEVICE_ATTR(rgb, 0666, g13_rgb_show, g13_rgb_store);
>> >> +
>> >> +/*
>> >> + * Create a group of attributes so that we can create and destroy
>> them
>> >> all
>> >> + * at once.
>> >> + */
>> >> +static struct attribute *g13_attrs[] = {
>> >> +	&dev_attr_name.attr,
>> >> +	&dev_attr_rgb.attr,
>> >> +	&dev_attr_mled.attr,
>> >> +	&dev_attr_keymap_index.attr,
>> >> +	&dev_attr_emit_msc_raw.attr,
>> >> +	&dev_attr_keymap_switching.attr,
>> >> +	&dev_attr_keymap.attr,
>> >> +	&dev_attr_fb_update_rate.attr,
>> >> +	&dev_attr_fb_node.attr,
>> >> +	NULL,	 /* need to NULL terminate the list of attributes */
>> >> +};
>> >> +
>> >> +/*
>> >> + * An unnamed attribute group will put all of the attributes
>> directly
>> >> in
>> >> + * the kobject directory.  If we specify a name, a subdirectory will
>> be
>> >> + * created for the attributes with the directory being the name of
>> the
>> >> + * attribute group.
>> >> + */
>> >> +static struct attribute_group g13_attr_group = {
>> >> +	.attrs = g13_attrs,
>> >> +};
>> >> +
>> >> +static struct fb_deferred_io g13_fb_defio = {
>> >> +	.delay = HZ / G13FB_UPDATE_RATE_DEFAULT,
>> >> +	.deferred_io = g13_fb_deferred_io,
>> >> +};
>> >> +
>> >> +static void g13_raw_event_process_input(struct hid_device *hdev,
>> >> +					struct g13_data *g13data,
>> >> +     u8 *raw_data)
>> >> +{
>> >> +	struct input_dev *idev = g13data->input_dev;
>> >> +	unsigned int code;
>> >> +	int value;
>> >> +	int i;
>> >> +	int mask;
>> >> +	int offset;
>> >> +	u8 val;
>> >> +
>> >> +	g13data->ready2 = 1;
>> >> +
>> >> +	if (idev == NULL)
>> >> +		return;
>> >> +
>> >> +	if (g13data->curkeymap < 3)
>> >> +		offset = G13_KEYS * g13data->curkeymap;
>> >> +	else
>> >> +		offset = 0;
>> >> +
>> >> +	for (i = 0, mask = 0x01; i < 8; i++, mask <<= 1) {
>> >> +		/* Keys G1 through G8 */
>> >> +		code = g13data->keycode[i+offset];
>> >> +		value = raw_data[3] & mask;
>> >> +		if (g13data->keycode[i] != KEY_RESERVED)
>> >> +			input_report_key(idev, code, value);
>> >> +		input_event(idev, EV_MSC, MSC_SCAN, i);
>> >
>> > That means these MSC_SCAN events are emitted _always_. Not sure if
>> that
>> > is too useful. If you were to detect the state change and emit
>> MSC_SCAN
>> > for changed keys, that would be better.
>> >
>>
>> I couldn't find anything that really explained the purpose of MSC_SCAN.
>> Can I use it just to report scancodes?
>
> Yes, it purpose if to report scancode or it's equivalent of pressed key.
>
>>
>> In particular can I selectively emit MSC_SCAN when I only want to report
>> specific events such as an unmapped key or a special key such as the
>> backlight or one of the M* keys?
>
> You could, but then users would not really know what scancode to use to
> remap already mapped key. The problem with your approach that userspace
> will get 10 MSC_SCAN before getting KEY_* event. Not terribly useful.
>
> ...
>

I'll change it to only emit MSC_SCAN when a key with no mapping or when an
M* key has a state change.

That will allow me to simplify the MSC_RAW as well.

>> >> +
>> >> +	dbg_hid("Found all reports\n");
>> >> +
>> >> +	for (i = 0; i < 20; i++) {
>> >> +		if (data->ready && data->ready2)
>> >> +			break;
>> >> +		mdelay(10);
>> >> +	}
>> >
>> > Consider using completion?
>> >
>>
>> I'm not sure what you mean.
>
> Look at wait_for_completion() and wait_completion_timeout() functions.
> These are proper APIs to wait for completion of a certain task instead
> of busily (or sleepily) spinning.
>

That sounds much better. That will allow me to extend the initialization
time a bit as well... probably 500ms or so.

>>
>> >> +
>> >> +	if (!(data->ready && data->ready2))
>> >> +		printk(KERN_ERR "G13 hasn't responded yet, forging ahead with
>> >> initialization\n");
>> >> +	else
>> >> +		dbg_hid("G13 initialized\n");
>> >> +
>> >> +	/*
>> >> +	 * Set the initial color and load the linux logo
>> >> +	 * We're going to ignore the error values. If there is an error at
>> >> this
>> >> +	 * point we'll forge ahead.
>> >> +	 */
>> >> +
>> >> +	dbg_hid("Set default color\n");
>> >> +
>> >> +	error = g13_set_rgb(hdev, G13_DEFAULT_RED, G13_DEFAULT_GREEN,
>> >> G13_DEFAULT_BLUE);
>> >
>> > And...?
>> >
>>
>> I had an error message before, but took it out. Missed taking out the
>> "error =" since at this point we'll just forge ahead.
>>
>> Although failing to set the backlight color at this point could indicate
>> some I/O issue it's not critical enough to fail driver initialization.
>>
>
> Then dev_warn() is your friend.
>

Excellent.

Thanks again,

---

Rick


