Return-Path: <linux-kernel-owner+w=401wt.eu-S1754214AbZKZGAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214AbZKZGAj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 01:00:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753983AbZKZGAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 01:00:36 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:53858 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950AbZKZGAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 01:00:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=t2XtGQrXhQjykf+S3FqiffVSjgfz3Foz1qJyTltGYDGUx8HUpVo79ENuKJSmHJWGfW
         c8PPTZ+6C9ACE9OWjzOnb9C7MVCeWg5P9+cUEfPKKBxCXnipI7BYyGF6Qhyoljakrail
         d0d9+FR0jlotLjD42bBcJnphUYiGjaTLD9tgk=
Subject: Re: [PATCH v2] [loongson] yeeloong2f: add platform specific support
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       Richard Purdie <rpurdie@rpsys.net>, lm-sensors@lm-sensors.org,
       linux-input@vger.kernel.org, linux-laptop@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>, sfr@linuxcare.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20091126041047.GC23244@core.coreip.homeip.net>
References: <9ef5a0038ec5e9b584be8c960693c434a323620a.1258803311.git.wuzhangjin@gmail.com>
	 <9ef5a0038ec5e9b584be8c960693c434a323620a.1258803311.git.wuzhangjin@gmail.com>
	 <20091126041047.GC23244@core.coreip.homeip.net>
Content-Type: text/plain; charset="UTF-8"
Organization: DSLab, Lanzhou University, China
Date: Thu, 26 Nov 2009 14:00:15 +0800
Message-ID: <1259215215.4989.38.camel@falcon.domain.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-25 at 20:10 -0800, Dmitry Torokhov wrote:
> Hi Wu,
> 
> Overall impression - several drivers crammed into one module, I wonder
> if it could be split somewhat. 

Yeah, I have put several drivers into one file, just like the folks did
in drivers/platform/x86/ for their platforms. I hated it too, will split
it later(as least, for review is necessary).

> Some input-related concerns below.

Thanks very much for your feedback.

> 
> On Sat, Nov 21, 2009 at 08:08:40PM +0800, Wu Zhangjin wrote:
> > +
> > +/* hotkey input subdriver */
> > +
> > +static struct input_dev *yeeloong_hotkey_dev;
> > +static int event, status;
> > +
> > +struct key_entry {
> > +	char type;		/* See KE_* below */
> > +	int event;		/* event from SCI */
> > +	u16 keycode;		/* KEY_* or SW_* */
> > +};
> > +
> > +enum { KE_KEY, KE_SW, KE_END };
> 
> I am going to post the sparse keymap library shortly, this driver could
> use it too...
> 

when you posting your keymap library, could you please put me in the CC
list? thanks ;)

> > +
> > +static struct key_entry yeeloong_keymap[] = {
> > +	{KE_SW, EVENT_LID, SW_LID},
> > +	/* SW_VIDEOOUT_INSERT? not included in hald-addon-input! */
> > +	{KE_KEY, EVENT_CRT_DETECT, KEY_PROG1},

any available event for reporting the inserted CRT in hald-addon-input?

> > +	/* Seems battery subdriver should report it */
> > +	{KE_KEY, EVENT_OVERTEMP, KEY_PROG2},
> 
> Does not seem to be an input event?
> 

It is not an input event, Will remove it from the keymap table.
 
BTW: how can we handle this stuff(overtemp...)? lm-sensors? Perhaps
temp1_max_alarm or temp1_crit_alarm?

> > +	/*{KE_KEY, EVENT_AC_BAT, KEY_BATTERY},*/
> > +	{KE_KEY, EVENT_CAMERA, KEY_CAMERA},	/* Fn + ESC */
> > +	{KE_KEY, EVENT_SLEEP, KEY_SLEEP},	/* Fn + F1 */
> > +	/* Seems not clear? not included in hald-addon-input! */
> > +	{KE_KEY, EVENT_BLACK_SCREEN, KEY_PROG3},	/* Fn + F2 */
> 
> Do you mean "lock screen"?

not lock, close the backlight of the display, any available event here?

> 
> > +	{KE_KEY, EVENT_DISPLAY_TOGGLE, KEY_SWITCHVIDEOMODE},	/* Fn + F3 */
> > +	{KE_KEY, EVENT_AUDIO_MUTE, KEY_MUTE},	/* Fn + F4 */
> > +	{KE_KEY, EVENT_WLAN, KEY_WLAN},	/* Fn + F5 */
> > +	{KE_KEY, EVENT_DISPLAY_BRIGHTNESS, KEY_BRIGHTNESSUP},	/* Fn + up */
> > +	{KE_KEY, EVENT_DISPLAY_BRIGHTNESS, KEY_BRIGHTNESSDOWN},	/* Fn + down */
> > +	{KE_KEY, EVENT_AUDIO_VOLUME, KEY_VOLUMEUP},	/* Fn + right */
> > +	{KE_KEY, EVENT_AUDIO_VOLUME, KEY_VOLUMEDOWN},	/* Fn + left */
> > +	{KE_END, 0}
> > +};
> > +
> 
> ...
> 
> > +
> > +static ssize_t
> > +ignore_store(struct device *dev,
> > +	     struct device_attribute *attr, const char *buf, size_t count)
> > +{
> > +	return count;
> > +}
> > +
> > +static ssize_t
> > +show_hotkeystate(struct device *dev, struct device_attribute *attr, char *buf)
> > +{
> > +	return sprintf(buf, "%d %d\n", event, status);
> > +}
> > +
> > +static DEVICE_ATTR(state, 0444, show_hotkeystate, ignore_store);
> 
> Why do you need "ignore_store" and not just use NULL? Also why do you
> need to export the state at all?
> 

Okay, Ignore_store() should be NULL here, show_hotkeystate() is only
added for debugging when I write this driver and also, it is helpful to
my own user-space hotkey manager. anyway, it is not needed for upstream,
will remove it later.

> > +
> > +static struct attribute *hotkey_attributes[] = {
> > +	&dev_attr_state.attr,
> > +	NULL
> > +};
> > +
> > +static struct attribute_group hotkey_attribute_group = {
> > +	.attrs = hotkey_attributes
> > +};
> > +
> > +static int camera_set(int status)
> > +{
> > +	int value;
> > +	static int camera_status;
> > +
> > +	if (status == 2)
> > +		/* resume the old camera status */
> > +		camera_set(camera_status);
> > +	else if (status == 3) {
> > +		/* revert the camera status */
> > +		value = ec_read(REG_CAMERA_CONTROL);
> > +		ec_write(REG_CAMERA_CONTROL, value | (1 << 1));
> > +	} else {/* status == 0 or status == 1 */
> > +		status = !!status;
> > +		camera_status = ec_read(REG_CAMERA_STATUS);
> > +		if (status != camera_status)
> > +			camera_set(3);
> > +	}
> > +	return ec_read(REG_CAMERA_STATUS);
> > +}
> > +
> > +#define I8042_STATUS_REG	0x64
> > +#define I8042_DATA_REG		0x60
> > +#define i8042_read_status() inb(I8042_STATUS_REG)
> > +#define i8042_read_data() inb(I8042_DATA_REG)
> > +#define I8042_STR_OBF		0x01
> > +#define I8042_BUFFER_SIZE	16
> > +
> > +static void i8042_flush(void)
> > +{
> > +	int i;
> > +
> > +	while ((i8042_read_status() & I8042_STR_OBF)
> > +		&& (i < I8042_BUFFER_SIZE)) {
> > +		udelay(50);
> > +		i8042_read_data();
> > +		i++;
> > +	}
> > +}
> > +
> > +static int yeeloong_hotkey_init(struct device *dev)
> > +{
> > +	int ret;
> > +	struct key_entry *key;
> > +
> > +	/* flush the buffer of keyboard */
> > +	i8042_flush();
> 
> Why??? Why does this driver tries to touch stuff that does not belong to
> it?
> 

I doubted the keys in the buffer of keyboard will generate weird
problems, so, added the above lines. and another guy just cleared this
part to me that the Fnkey stuff not go to the buffer of keyboard, so,
I'm doing stupid job here, will remove it later too.

> > +
> > +	/* setup the system control interface */
> > +	setup_sci();
> 
> No failures?

Need to check the return value here, and also, the setup_sci() itself.

> 
> > +
> > +	yeeloong_hotkey_dev = input_allocate_device();
> > +
> > +	if (!yeeloong_hotkey_dev)
> > +		return -ENOMEM;
> 
> Error unwinding?

Sorry, not clear what do you mean here?

Thanks & Regards,
	Wu Zhangjin

