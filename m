Return-Path: <linux-kernel-owner+w=401wt.eu-S1754386AbYIJRJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386AbYIJRJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 13:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751585AbYIJRJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 13:09:09 -0400
Received: from vena.lwn.net ([206.168.112.25]:39277 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751286AbYIJRJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 13:09:07 -0400
Date: Wed, 10 Sep 2008 11:09:04 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Jarod Wilson <jwilson@redhat.com>
Cc: linux-kernel@vger.kernel.org, Janne Grunau <j@jannau.net>,
       Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [PATCH 07/18] lirc driver for the CommandIR USB Transceiver
Message-ID: <20080910110904.54de7268@bike.lwn.net>
In-Reply-To: <1220933164-10160-8-git-send-email-jwilson@redhat.com>
References: <1220933164-10160-1-git-send-email-jwilson@redhat.com>
	<1220933164-10160-2-git-send-email-jwilson@redhat.com>
	<1220933164-10160-3-git-send-email-jwilson@redhat.com>
	<1220933164-10160-4-git-send-email-jwilson@redhat.com>
	<1220933164-10160-5-git-send-email-jwilson@redhat.com>
	<1220933164-10160-6-git-send-email-jwilson@redhat.com>
	<1220933164-10160-7-git-send-email-jwilson@redhat.com>
	<1220933164-10160-8-git-send-email-jwilson@redhat.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver has real locking problems.  Parts of it depend on the BKL, but
I would have a hard time arguing for the addition of new BKL users in this
century.  The assumption that ->open() is called under the BKL no longer
holds.  It's really time to put a proper lock here.

This driver also needs a lot of "static" keywords thrown in.

> +/* circular packet queue */
> +unsigned char ourbuffers[QUEUELENGTH][64];
> +int waitusecs[QUEUELENGTH];
> +int ourbufferlengths[QUEUELENGTH];
> +int nexttosend;
> +int nexttofill;

So this driver only handles a single device?

> +/* Structure to hold all of our device specific stuff */
> +struct usb_skel {
> +	struct usb_device *udev; /* the usb device for this device */
> +	struct usb_interface *interface; /* the interface for this device */
> +	unsigned char *bulk_in_buffer; /* the buffer to receive data */
> +	size_t bulk_in_size; /* the size of the receive buffer */
> +	__u8 bulk_in_endpointAddr; /* the address of the bulk in endpoint */
> +	__u8 bulk_out_endpointAddr; /* the address of the bulk out endpoint */
> +	struct kref kref;
> +};

As with a previous driver, a more descriptive name than "usb_skel" would be
nice.

As far as I can tell, the kref here is just extra overhead.  Why not just
free the structure in cmdir_release()?

> +#define CMDIR_VAR_LEN 68
> +static char cmdir_var[] =
> +"COMMANDIRx:\n TX Enabled: 1, 2, 3, 4\n RX: commandirx\n LCD: commandirx";

This struck me as a little weird, so I went and looked at where it is used:

> +static void update_cmdir_string(int device_num)
> +{
> +	int next_comma = 0;
> +	int next_pos = 25;
> +	unsigned int multiplier;
> +	int i;
> +
> +	/* cmdir_var[] = "COMMANDIRx:\n"
> +	 * 		 " TX Enabled: 1, 2, 3, 4\n"
> +	 * 		 " RX: commandirx\n"
> +	 * 		 " LCD: commandirx\n" */
> +
> +	cmdir_var[9] = ASCII0+device_num;
> +	cmdir_var[50] = ASCII0+rx_device;
> +	cmdir_var[67] = ASCII0+lcd_device;
> +
> +	for (i = 25; i < 35; i++)
> +		cmdir_var[i] = ' ';

[...]

I don't get it.  Something is wrong with sprintf()?

> +static int cmdir_probe(struct usb_interface *interface,
> +		       const struct usb_device_id *id)
> +{

[...] 

> +	/* check whether minor already includes base */
> +	minor = interface->minor;
> +	if (minor >= USB_CMDIR_MINOR_BASE)
> +		minor = minor-USB_CMDIR_MINOR_BASE;

This kind of stuff looks like a recipe for confusion.  Why not just deal
with the minor number as it is?

> +static void cmdir_disconnect(struct usb_interface *interface)
> +{
> +	struct usb_skel *dev;
> +	int minor = interface->minor;
> +
> +	/* prevent cmdir_open() from racing cmdir_disconnect() */
> +	lock_kernel();

As noted before, that won't work.

> +static int cmdir_check(int device_num)
> +{
> +	struct usb_interface *interface;
> +
> +	interface = usb_find_interface(&cmdir_driver,
> +				       USB_CMDIR_MINOR_BASE+device_num);
> +	if (!interface) {
> +		/* also check without adding base, for devfs */
> +		interface = usb_find_interface(&cmdir_driver, rx_device);
> +		if (!interface)
> +			return -ENODEV;
> +	}
> +	return 0;
> +}

For devfs??  Again, this messing around with the minor number looks like
trouble.

> +static void init_cmdir_var(int device_num)
> +{
> +	int i;
> +	unsigned int multiplier = 1;
> +
> +	for (i = 0; i < device_num; i++)
> +		multiplier = multiplier*0x10;

I bet that could be implemented without a loop.

> +	transmitters |= multiplier * 0x0F;
> +	next_transmitters = transmitters;
> +	info("commandir%d reset", device_num);
> +	return;
> +}

> +static ssize_t cmdir_file_read(struct file *file, char *buffer,
> +			       size_t count, loff_t *ppos)
> +{
> +	int retval = 0;
> +	int minor = 0;
> +	struct usb_skel *dev;
> +
> +	dev = (struct usb_skel *)file->private_data;
> +	minor = dev->interface->minor;
> +	if (minor >= USB_CMDIR_MINOR_BASE)
> +		minor = minor - USB_CMDIR_MINOR_BASE;
> +
> +	if (((int)*ppos) == 0) {
> +		update_cmdir_string(minor);
> +		if (copy_to_user(buffer, cmdir_var, CMDIR_VAR_LEN))

So it ignores the count the user asked for and stuffs the full length down
there anyway?

> +			retval = -EFAULT;
> +		else
> +			retval = CMDIR_VAR_LEN;
> +		return retval;
> +	} else
> +		return 0;
> +}
> +
> +/*  Read data from CommandIR  */
> +ssize_t cmdir_read(unsigned char *buffer, size_t count)
> +{
> +	struct usb_skel *dev;
> +	int length, retval = 0;
> +
> +	struct usb_interface *interface;
> +	interface = usb_find_interface(&cmdir_driver,
> +			USB_CMDIR_MINOR_BASE+rx_device);
> +	if (!interface) {
> +		/* also check without adding base, for devfs */
> +		interface = usb_find_interface(&cmdir_driver, rx_device);
> +		if (!interface)
> +			return -ENODEV;
> +	}

Again, devfs compatibility is probably not needed anymore.

> +	dev = usb_get_intfdata(interface);
> +	if (!dev)
> +		return -ENODEV;
> +	retval = usb_bulk_msg(dev->udev, usb_rcvbulkpipe(dev->udev,
> +						dev->bulk_in_endpointAddr),
> +		 dev->bulk_in_buffer, min(dev->bulk_in_size, count),
> +		 &length, HZ*10);
> +	if (!retval) {
> +		if (!memcpy(buffer, dev->bulk_in_buffer, length))
> +			retval = -EFAULT;
> +		else {
> +			/* current status of the TX buffer */
> +			curTXFill = buffer[2];
> +			retval = length;
> +		}
> +	}
> +	/* suppress errors */
> +	/*
> +	else {
> +		err("Read from device failed, error %d",retval);
> +	}
> +	*/
> +	/* printk(KERN_INFO "CommandIR Reporting TX buffer at %d bytes. \n",
> +	 * 	  curTXFill); */
> +	return retval;
> +}
> +EXPORT_SYMBOL(cmdir_read);

Who is the consumer of these exports?  (OK, I found it later).

> +static ssize_t cmdir_file_write(struct file *file, const char *buffer,
> +				size_t count, loff_t *ppos)
> +{
> +	int retval;
> +	int i;
> +	int equalsign = 0;
> +	int changeType = 0;
> +	unsigned char ctrl_buffer[MCU_CTRL_SIZE];
> +	char *local_buffer;
> +	int minor;
> +
> +	/* set as default - if non-specific error,
> +	 * won't keep calling this function */
> +	retval = count;
> +	local_buffer = kmalloc(count, GFP_KERNEL);
> +
> +	/* verify that we actually have some data to write */
> +	if (count == 0) {
> +		err("Write request of 0 bytes");
> +		goto exit;
> +	}
> +	if (count > 64) {
> +		err("Input too long");
> +		goto exit;
> +	}
> +
> +	/* copy the data from userspace into our local buffer */
> +	if (copy_from_user(local_buffer, buffer, count)) {
> +		retval = -EFAULT;
> +		goto exit;
> +	}
> +
> +	/* parse code */
> +	changeType = cNothing;
> +	equalsign = 0;
> +	for (i = 0; i < MCU_CTRL_SIZE; i++)
> +		ctrl_buffer[i] = 'j';
> +
> +	for (i = 0; i < count; i++) {
> +		switch (local_buffer[i]) {
> +		case 'X':
> +		case 'x':
> +			if ((i > 0) && ((local_buffer[i - 1] == 'R')
> +			    || (local_buffer[i - 1] == 'r')))
> +				changeType = cRX;
> +			break;

So we have a command parser built into this driver.  It looks like somebody
wanted to avoid ioctl() at all costs.  But ioctl() exists for a reason, and
this looks like a good use for it to me.  Of course, now this is a
user-space API which will be hard to change, but I think consideration
should be given to doing just that.

> +		case 'S':
> +		case 's':
> +			if ((i > 1) && ((local_buffer[i - 1] == 'E')
> +			    || (local_buffer[i - 1] == 'e'))) {
> +				if ((local_buffer[i-2] == 'R')
> +				    || (local_buffer[i-2] == 'r'))
> +					changeType = cRESET;
> +			}
> +			break;
> +		case 'L':
> +		case 'l':
> +			if ((i > 0) && ((local_buffer[i - 1] == 'F')
> +			    || (local_buffer[i - 1] == 'f')))
> +				changeType = cFLASH;
> +			break;
> +		case 'C':
> +		case 'c':
> +			if ((i > 0) && ((local_buffer[i - 1] == 'L')
> +			    || (local_buffer[i - 1] == 'l')))
> +				changeType = cLCD;
> +			break;
> +		case '=':
> +			if (changeType != cNothing)
> +				equalsign = i;
> +			break;
> +		case '0':
> +		case '1':
> +		case '2':
> +		case '3':
> +		case '4':
> +		case '5':
> +		case '6':
> +		case '7':
> +			if (equalsign > 0) {
> +				minor = local_buffer[i] - ASCII0;

This code never checks minor for validity, it just assumes that the device
exists - and that the current process has the right to mess with it.

[...]

> +		default:
> +			if ((equalsign > 0) && (local_buffer[i] > 32)) {
> +				err("Non-numerical argument");
> +				goto exit;
> +			}
> +			break;

And here it ignores junk if an "=" has not been seen yet.

> +int cmdir_write(unsigned char *buffer, int count,
> +		void *callback_fct, int usecdelay)
> +{
> +	/* Always add to queue, then send queue number
> +	 * no locks
> +	 * mbodkin, Sept 8, 2005 */

Why no locks?  This code is messing with a global buffer.

> +int wait_to_tx(int usecs)
> +{
> +	/* don't return until last_time + usecs has been reached
> +	 * for non-zero last_tx's. */

I will confess that I have no clue what this function is really trying to
do.  I also note, though, that the only call to it is commented out.  So it
should maybe just go away?

> +int write_core(unsigned char *buffer, int count,
> +	       void *callback_fct, int device_num)
> +{
> +	struct usb_skel *dev;
> +	int retval = count;
> +
> +	struct usb_interface *interface;
> +	struct urb *urb = NULL;
> +	char *buf = NULL;
> +	interface = usb_find_interface(&cmdir_driver,
> +			USB_CMDIR_MINOR_BASE + device_num);
> +	if (!interface) {
> +		/* also check without adding base, for devfs */
> +		interface = usb_find_interface(&cmdir_driver, device_num);
> +		if (!interface)
> +			return -ENODEV;
> +	}
> +	dev = usb_get_intfdata(interface);
> +	if (!dev)
> +		return -ENODEV;
> +	/* create a urb, and a buffer for it, and copy the data to the urb */
> +	urb = usb_alloc_urb(0, GFP_ATOMIC);	/* Now -=Atomic=- */

Why GFP_ATOMIC?  Somehow the comment fails to shed much light.


> diff --git a/drivers/input/lirc/commandir.h b/drivers/input/lirc/commandir.h
> new file mode 100644
> index 0000000..bed703d
> --- /dev/null
> +++ b/drivers/input/lirc/commandir.h
> @@ -0,0 +1,68 @@
> +/*
> + *  commandir.h
> + */
> +
> +#define ASCII0      48

'0' was too clear?


> diff --git a/drivers/input/lirc/lirc_cmdir.c b/drivers/input/lirc/lirc_cmdir.c
> new file mode 100644
> index 0000000..1faa8e3
> --- /dev/null
> +++ b/drivers/input/lirc/lirc_cmdir.c
> @@ -0,0 +1,596 @@

> +#ifndef MAX_UDELAY_MS
> +#define MAX_UDELAY_US 5000
> +#else
> +#define MAX_UDELAY_US (MAX_UDELAY_MS*1000)
> +#endif
> +
> +static inline void safe_udelay(unsigned long usecs)
> +{
> +	while (usecs > MAX_UDELAY_US) {
> +		udelay(MAX_UDELAY_US);
> +		usecs -= MAX_UDELAY_US;
> +	}
> +	udelay(usecs);
> +}

This looks like mdelay() in disguise?  Perhaps something that sleeps would
be even better (haven't looked at the calling context yet)?

> +static int write_to_usb(unsigned char *buffer, int count, int time_elapsed)
> +{
> +	int write_return;
> +
> +	write_return = cmdir_write(buffer, count, NULL, time_elapsed);

Ah, this is why those functions are exported?  Is there any reason not to
just link the whole mess together into a single module?

> +static int cmdir_convert_RX(unsigned char *orig_rxbuffer)
> +{
> +	unsigned char tmp_char_buffer[80];
> +	unsigned int tmp_int_buffer[20];
> +	unsigned int final_data_buffer[20];
> +	unsigned int num_data_values = 0;
> +	unsigned char num_data_bytes = 0;
> +	unsigned int orig_index = 0;
> +	int i;
> +
> +	for (i = 0; i < 80; i++)
> +		tmp_char_buffer[i] = 0;
> +	for (i = 0; i < 20; i++)
> +		tmp_int_buffer[i] = 0;

Looks like memset() to me.

> +	/*
> +	 * get number of data bytes that follow the control bytes
> +	 * (NOT including them)
> +	 */
> +	num_data_bytes = orig_rxbuffer[1];
> +
> +	/* check if num_bytes is multiple of 3; if not, error */
> +	if (num_data_bytes % 3 > 0)
> +		return -1;
> +	if (num_data_bytes > 60)
> +		return -3;
> +	if (num_data_bytes < 3)
> +		return -2;
> +
> +	/*
> +	 * get number of ints to be returned; num_data_bytes does
> +	 * NOT include control bytes
> +	 */
> +	num_data_values = num_data_bytes/3;
> +
> +	for (i = 0; i < num_data_values; i++) {
> +		tmp_char_buffer[i*4] = orig_rxbuffer[(i+1)*3];
> +		tmp_char_buffer[i*4+1] = orig_rxbuffer[(i+1)*3+1];
> +		tmp_char_buffer[i*4+2] = 0;
> +		tmp_char_buffer[i*4+3] = 0;
> +	}

Hmm...  num_data_bytes can be 60, so num_data values can be 20, so i*4+3
can be 83, you've just overflowed the buffer.

> +	/* convert to int array */
> +	memcpy((unsigned char *)tmp_int_buffer, tmp_char_buffer,
> +						(num_data_values*4));

Hmm...I think there ought to be a better way.  Even before considering
endian problems.

> +static ssize_t lirc_write(struct file *file, const char *buf,
> +			 size_t n, loff_t *ppos)
> +{
> +	int i, count;
> +	unsigned int mod_signal_length = 0;
> +	unsigned int time_elapse = 0;
> +	unsigned int total_time_elapsed = 0;
> +	unsigned int num_bytes_already_sent = 0;
> +	unsigned int hibyte = 0;
> +	unsigned int lobyte = 0;
> +	int cmdir_cnt = 0;
> +	unsigned int wait_this = 0;
> +	struct timeval start_time;
> +	struct timeval end_time;
> +	unsigned int real_time_elapsed = 0;
> +
> +	/* save the time we started the write: */
> +	do_gettimeofday(&start_time);
> +
> +	if (n % sizeof(int))
> +		return -EINVAL;
> +
> +	count = n / sizeof(int);
> +	if (count > WBUF_LEN || count % 2 == 0)
> +		return -EINVAL;
> +	if (copy_from_user(wbuf, buf, n))
> +		return -EFAULT;

That's a global buffer - what's protecting it from concurrent access?

[...]

> +	 * we need to _manually delay ourselves_ to remain backwards
> +	 * compatible with LIRC and prevent our queue buffer from overflowing.
> +	 * Queuing in this driver is about instant, and send_start for example
> +	 * will fill it up quickly and prevent send_stop from taking immediate
> +	 * effect.
> +	 */
> +	dprintk("Total elapsed time is: %d. \n", total_time_elapsed);
> +	do_gettimeofday(&end_time);
> +	/*
> +	 * udelay for the difference between endtime and
> +	 * start + total_time_elapsed
> +	 */
> +	if (start_time.tv_usec < end_time.tv_usec)
> +		real_time_elapsed = (end_time.tv_usec - start_time.tv_usec);
> +	else
> +		real_time_elapsed = ((end_time.tv_usec +  1000000) -
> +							start_time.tv_usec);
> +	dprintk("Real time elapsed was %u.\n", real_time_elapsed);
> +	if (real_time_elapsed < (total_time_elapsed - 1000))
> +		wait_this = total_time_elapsed - real_time_elapsed - 1000;
> +
> +#if 0 /* enable this for backwards compatibility */
> +	safe_udelay(wait_this);
> +#endif

I assume that compatibility is not needed now?  In that case, this code
(and safe_udelay()) can go away.

jon
