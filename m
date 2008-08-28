Return-Path: <linux-kernel-owner+w=401wt.eu-S1755116AbYH1Q2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116AbYH1Q2W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 12:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752126AbYH1Q2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 12:28:10 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50944 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbYH1Q2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 12:28:08 -0400
Date: Thu, 28 Aug 2008 09:17:02 -0700
From: Greg KH <greg@kroah.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       USB list <linux-usb@vger.kernel.org>,
       Stefan Kopp <stefan_kopp@agilent.com>, Marcel Janssen <korgull@home.nl>,
       Felipe Balbi <me@felipebalbi.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB: add USB test and measurement class driver - round
	2
Message-ID: <20080828161702.GB18132@kroah.com>
References: <20080827183615.GA15692@kroah.com> <Pine.LNX.4.44L0.0808271451550.17771-100000@iolanthe.rowland.org> <20080827234720.GC31264@kroah.com> <200808281210.27661.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808281210.27661.oliver@neukum.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2008 at 12:10:26PM +0200, Oliver Neukum wrote:
> Am Donnerstag 28 August 2008 01:47:20 schrieb Greg KH:
> > On Wed, Aug 27, 2008 at 02:58:08PM -0400, Alan Stern wrote:
> > > On Wed, 27 Aug 2008, Greg KH wrote:
> > > 
> > > > On Wed, Aug 27, 2008 at 02:28:22PM -0400, Alan Stern wrote:
> > > > > On Wed, 27 Aug 2008, Greg KH wrote:
> > > > > 
> > > > > > Here's an updated version of the usbtmc driver, with all of the
> > > > > > different issues that have been raised, hopefully addressed.
> > > > > 
> > > > > This is an example of what I was discussing with Oliver.  In all 
> > > > > likelihood you simply don't need usbtmc_mutex, and using it will cause 
> > > > > a lockdep violation.
> > > > > 
> > > > > That's why so many of the other USB class drivers don't have an 
> > > > > analogous static mutex.
> > > > 
> > > > Ok, then it's just safe to drop this static mutex entirely, right?
> > > 
> > > Yes, once you add the call to usb_deregister_dev.
> > 
> > Great, all done now.
> > 
> > Here's the updated version.
> 
> OK, here we go again.
> 
> > +static ssize_t usbtmc_read(struct file *filp, char __user *buf,
> > +			   size_t count, loff_t *f_pos)
> > +{
> 
> [..]
> 
> > +		/* Setup IO buffer for DEV_DEP_MSG_IN message
> > +		 * Refer to class specs for details
> > +		 */
> > +		buffer[0] = 2;
> > +		buffer[1] = data->bTag;
> > +		buffer[2] = ~(data->bTag);
> > +		buffer[3] = 0; /* Reserved */
> > +		buffer[4] = (this_part - 12 - 3) & 255;
> > +		buffer[5] = ((this_part - 12 - 3) >> 8) & 255;
> > +		buffer[6] = ((this_part - 12 - 3) >> 16) & 255;
> > +		buffer[7] = ((this_part - 12 - 3) >> 24) & 255;
> 
> We have excellent endianness conversion macros.

For splitting values up into the individual byte portions?  I think this
is far more obvious as to exactly what is going on, don't you?

> > +		buffer[8] = data->TermCharEnabled * 2;
> > +		/* Use term character? */
> 
> smp_rmb(); /* we must make sure we don't read a stale terminator */

I'm not going to worry about races here, that's not a real issue.

> > +		buffer[9] = data->TermChar;
> > +		buffer[10] = 0; /* Reserved */
> > +		buffer[11] = 0; /* Reserved */
> > +
> > +		/* Send bulk URB */
> > +		retval = usb_bulk_msg(data->usb_dev,
> > +				      usb_sndbulkpipe(data->usb_dev,
> > +						      data->bulk_out),
> > +				      buffer, 12, &actual, USBTMC_TIMEOUT);
> > +
> > +		/* Store bTag (in case we need to abort) */
> > +		data->bTag_last_write = data->bTag;
> 
> even if usb_bulk_msg() failed?

Good point, will fix.

> > +		/* How many characters did the instrument send? */
> > +		n_characters = buffer[4] +
> > +			       (buffer[5] << 8) +
> > +			       (buffer[6] << 16) +
> > +			       (buffer[7] << 24);
> 
> endianness macro

I'll leave it (casting is just a big of a mess, this obviously shows
what is going on here.)

> > +		/* Copy buffer to user space */
> > +		if (copy_to_user(buf + done, &buffer[12], n_characters)) {
> > +			/* There must have been an addressing problem */
> > +			retval = -EFAULT;
> > +			goto exit;
> > +		}
> > +
> > +		done += n_characters;
> > +		if (n_characters < USBTMC_SIZE_IOBUFFER)
> > +			remaining = 0;
> > +	}
> > +
> > +	/* Update file position value */
> > +	*f_pos = *f_pos + done;
> 
> That'll get out of sync if -EFAULT is returned

Hm, I wonder if this is an issue, I'll poke at it.

> > +static ssize_t usbtmc_write(struct file *filp, const char __user *buf,
> > +			    size_t count, loff_t *f_pos)
> > +{
> > +	struct usbtmc_device_data *data;
> > +	u8 *buffer;
> > +	int retval;
> > +	int actual;
> > +	unsigned long int n_bytes;
> > +	int n;
> > +	int remaining;
> > +	int done;
> > +	int this_part;
> > +
> > +	data = filp->private_data;
> > +
> > +	buffer = kmalloc(USBTMC_SIZE_IOBUFFER, GFP_KERNEL);
> > +	if (!buffer)
> > +		return -ENOMEM;
> > +
> > +	mutex_lock(&data->io_mutex);
> 
> This and usbtmc_read() need a test for disconnection. Open() and disconnect
> are guarded in usbcore, read & write are not. By reference count you've made
> sure you have a valid device descriptor, but the device may have been reprobed.

If so, then struct usb_device would be different, right?  Oh, I see,
disconnect() using usbfs/sysfs.  Bah, is it really something that
happens in the real world?  Oh well, I'll go fix this...

> > +		retval = usb_bulk_msg(data->usb_dev,
> > +				      usb_sndbulkpipe(data->usb_dev,
> > +						      data->bulk_out),
> > +				      buffer, n_bytes, &actual, USBTMC_TIMEOUT);
> > +
> > +		data->bTag_last_write = data->bTag;
> 
> error case?

Will do.

> > +static int get_capabilities(struct usbtmc_device_data *data)
> > +{
> > +	struct device *dev = &data->usb_dev->dev;
> > +	char *buffer;
> > +	int rv;
> > +
> > +	buffer = kmalloc(0x18, GFP_KERNEL);
> > +	if (!buffer)
> > +		return -ENOMEM;
> > +
> > +	rv = usb_control_msg(data->usb_dev, usb_rcvctrlpipe(data->usb_dev, 0),
> > +			     USBTMC_REQUEST_GET_CAPABILITIES,
> > +			     USB_DIR_IN | USB_TYPE_CLASS | USB_RECIP_INTERFACE,
> > +			     0, 0, buffer, 0x18, USBTMC_TIMEOUT);
> > +	if (rv < 0) {
> > +		dev_err(dev, "usb_control_msg returned %d\n", rv);
> > +		return rv;
> 
> memory leak

Good find, will fix.

> > +	dev_dbg(dev, "GET_CAPABILITIES returned %x\n", buffer[0]);
> > +	dev_dbg(dev, "Interface capabilities are %x\n", buffer[4]);
> > +	dev_dbg(dev, "Device capabilities are %x\n", buffer[5]);
> > +	dev_dbg(dev, "USB488 interface capabilities are %x\n", buffer[14]);
> > +	dev_dbg(dev, "USB488 device capabilities are %x\n", buffer[15]);
> > +	if (buffer[0] != USBTMC_STATUS_SUCCESS) {
> > +		dev_err(dev, "GET_CAPABILITIES returned %x\n", buffer[0]);
> > +		return -EPERM;
> 
> memory leak

will fix.

> [..]
> > +static ssize_t store_TermChar(struct device *dev,
> > +			      struct device_attribute *attr,
> > +			      const char *buf, size_t count)
> > +{
> > +	struct usb_interface *intf = to_usb_interface(dev);
> > +	struct usbtmc_device_data *data = usb_get_intfdata(intf);
> > +
> > +	if (count < 1)
> > +		return -EINVAL;
> > +	data->TermChar = buf[0];
> 
> smp_wmb(); /* must hit RAM before enablement */

Not going to be an issue, it's ok to leave as-is.

> > +{									\
> > +	struct usb_interface *intf = to_usb_interface(dev);		\
> > +	struct usbtmc_device_data *data = usb_get_intfdata(intf);	\
> > +	ssize_t result;							\
> > +	unsigned val;							\
> > +									\
> > +	result = sscanf(buf, "%u\n", &val);				\
> > +	if (result != 1)						\
> > +		result = -EINVAL;					\
> 
> smp_rmb(); /* must hit RAM after the terminator */	\

Same as above.

> There are subtle penalties to avoiding ioctl(). Among them is the loss
> of atomicity.

Sure, but again, this isn't a real issue here.

> [..]
> > +static long usbtmc_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
> > +{
> > +	struct usbtmc_device_data *data;
> > +	int retval = -EBADRQC;
> > +
> > +	data = file->private_data;
> > +	mutex_lock(&data->io_mutex);
> 
> check for disconnect as in read & write
> 
> > +
> > +	switch (cmd) {
> > +	case USBTMC_IOCTL_CLEAR_OUT_HALT:
> > +		retval = usbtmc_ioctl_clear_out_halt(data);
> > +
> > +	case USBTMC_IOCTL_CLEAR_IN_HALT:
> > +		retval = usbtmc_ioctl_clear_in_halt(data);
> > +
> > +	case USBTMC_IOCTL_INDICATOR_PULSE:
> > +		retval = usbtmc_ioctl_indicator_pulse(data);
> > +
> > +	case USBTMC_IOCTL_CLEAR:
> > +		retval = usbtmc_ioctl_clear(data);
> > +
> > +	case USBTMC_IOCTL_ABORT_BULK_OUT:
> > +		retval = usbtmc_ioctl_abort_bulk_out(data);
> > +
> > +	case USBTMC_IOCTL_ABORT_BULK_IN:
> > +		retval = usbtmc_ioctl_abort_bulk_in(data);
> > +	}
> 
> This is missing a whole lot of "break;"

Bah, good catch, my fault.

> > +	retcode = get_capabilities(data);
> > +	if (retcode)
> > +		dev_err(&intf->dev, "can't read capabilities\n");
> > +	else
> > +		retcode = sysfs_create_group(&intf->dev.kobj,
> > +					     &capability_attr_grp);
> > +
> > +	retcode = sysfs_create_group(&intf->dev.kobj, &data_attr_grp);
> 
> If you ignore an error return, be open about it.

I'm not?  Should I print an error and then just continue on?  Would that
be sufficient?

> > +error_register:
> > +	sysfs_remove_group(&intf->dev.kobj, &capability_attr_grp);
> > +	sysfs_remove_group(&intf->dev.kobj, &data_attr_grp);
> 
> The groups might never have been created.

That's ok, the sysfs core should handle this safely.

> > +static void usbtmc_disconnect(struct usb_interface *intf)
> > +{
> > +	struct usbtmc_device_data *data;
> > +
> > +	dev_dbg(&intf->dev, "usbtmc_disconnect called\n");
> > +
> 
> You must set a flag for read, write and ioctl.

Will do.  Then I need to lock the flag with a mutex, right?

thanks,

greg k-h
