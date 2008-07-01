Return-Path: <linux-kernel-owner+w=401wt.eu-S1761228AbYGAXAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761228AbYGAXAw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 19:00:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755721AbYGAXAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 19:00:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54572 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751053AbYGAXAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 19:00:39 -0400
Date: Tue, 1 Jul 2008 15:59:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       dmitry.torokhov@gmail.com, robfitz@273k.net, jikos@jikos.cz,
       vojtech@suse.cz, dmonakhov@openvz.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 001/002] linux-input:  bcm5974-0.31: fixed resource
 leak, removed work struct, device data struct introduced
Message-Id: <20080701155925.a4c00a8e.akpm@linux-foundation.org>
In-Reply-To: <1214653629.10495.11.camel@alnilam>
References: <1214653629.10495.11.camel@alnilam>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Subject: [PATCH 001/002] linux-input:  bcm5974-0.31: fixed resource leak, removed work struct, device data struct introduced

hm, I wonder where [002/002] went.

Please copy the USB list on USB patches.

On Sat, 28 Jun 2008 14:54:20 +0200
Henrik Rydberg <rydberg@euromail.se> wrote:

> BCM5974: This driver adds support for the multitouch trackpad on the new
> Apple Macbook Air and Macbook Pro Penryn laptops. It replaces the
> appletouch driver on those computers, and integrates well with the
> synaptics driver of the Xorg system. 

- erk, the driver uses two-spaces for indenting all over the place. 
  Mayeb the email client mangled it in imaginative ways, but it _looks_
  to be intentional.

  If so, please don't do that.  Kernel code uses hard tabs at
  8-cols-per-tab for indenting.


> +config MOUSE_BCM5974
> +	tristate "Apple USB BCM5974 Multitouch trackpad support"
> +	depends on USB_ARCH_HAS_HCD
> +	select USB

selecting USB here seems like a bad idea, although I note that several
other drivers had bad ideas.  `depends on' would be better, IMO.

> +	help
> +	  Say Y here if you have an Apple USB BCM5974 Multitouch
> +	  trackpad.
> +
> +          The BCM5974 is the multitouch trackpad found in the Macbook
> +          Air (JAN2008) and Macbook Pro Penryn (FEB2008) laptops.
> +
> +          It is also found in the IPhone (2007) and Ipod Touch (2008).
> +
> +	  This driver provides multitouch functionality together with
> +          the synaptics X11 driver.
> +
> +          The interface is currently identical to the appletouch interface,
> +          for further information, see
> +          <file:Documentation/input/appletouch.txt>.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called bcm5974.
> +
>  config MOUSE_INPORT
>  	tristate "InPort/MS/ATIXL busmouse"
>  	depends on ISA
> diff -puN drivers/input/mouse/Makefile~input-support-for-bcm5974-multitouch-trackpad drivers/input/mouse/Makefile
> --- a/drivers/input/mouse/Makefile~input-support-for-bcm5974-multitouch-trackpad
> +++ a/drivers/input/mouse/Makefile
> @@ -6,6 +6,7 @@
>  
>  obj-$(CONFIG_MOUSE_AMIGA)	+= amimouse.o
>  obj-$(CONFIG_MOUSE_APPLETOUCH)	+= appletouch.o
> +obj-$(CONFIG_MOUSE_BCM5974)	+= bcm5974.o
>  obj-$(CONFIG_MOUSE_ATARI)	+= atarimouse.o
>  obj-$(CONFIG_MOUSE_RISCPC)	+= rpcmouse.o
>  obj-$(CONFIG_MOUSE_INPORT)	+= inport.o
>
> ...
>
> +static inline
> +const struct atp_config_t *atp_product_config(struct usb_device *udev)
> +{
> +  u16 id = le16_to_cpu(udev->descriptor.idProduct);
> +  const struct atp_config_t *config;
> +  for (config = atp_config_table; config->ansi; ++config)
> +    if (config->ansi == id || config->iso == id || config->jis == id)
> +      return config;
> +  return atp_config_table;
> +}

This is waaaaaaay too big for inlining.

> +/* Wellspring initialization constants */
> +#define ATP_WELLSPRING_MODE_READ_REQUEST_ID   1
> +#define ATP_WELLSPRING_MODE_WRITE_REQUEST_ID  9
> +#define ATP_WELLSPRING_MODE_REQUEST_VALUE     0x300
> +#define ATP_WELLSPRING_MODE_REQUEST_INDEX     0
> +#define ATP_WELLSPRING_MODE_VENDOR_VALUE_1    0x01
> +#define ATP_WELLSPRING_MODE_VENDOR_VALUE_2    0x05
> +
> +#define dprintk(format, a...) \
> +  { if (debug) printk(KERN_DEBUG format, ##a); }
> +
> +MODULE_AUTHOR("Henrik Rydberg");
> +MODULE_DESCRIPTION("Apple USB BCM5974 multitouch driver");
> +MODULE_LICENSE("GPL");
> +
> +static int debug = 1;
> +module_param(debug, int, 0644);
> +MODULE_PARM_DESC(debug, "Activate debugging output");
> +
> +static int atp_wellspring_init(struct usb_device *udev)
> +{
> +  const struct atp_config_t *cfg = atp_product_config(udev);
> +  char *data = kmalloc(8, GFP_DMA);
> +  int size;
> +
> +  /* reset button endpoint */
> +  if (usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
> +		      USB_REQ_CLEAR_FEATURE, USB_RECIP_ENDPOINT,
> +		      0, cfg->bt_ep, NULL, 0, 5000)) {
> +    err("Could not reset button endpoint");
> +    goto error;
> +  }
> +
> +  /* reset trackpad endpoint */
> +  if (usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
> +		      USB_REQ_CLEAR_FEATURE, USB_RECIP_ENDPOINT,
> +		      0, cfg->tp_ep, NULL, 0, 5000)) {
> +    err("Could not reset trackpad endpoint");
> +    goto error;
> +  }
> +
> +  /* read configuration */
> +  size = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
> +			 ATP_WELLSPRING_MODE_READ_REQUEST_ID,
> +			 USB_DIR_IN | USB_TYPE_CLASS | USB_RECIP_INTERFACE,
> +			 ATP_WELLSPRING_MODE_REQUEST_VALUE,
> +			 ATP_WELLSPRING_MODE_REQUEST_INDEX, data, 8, 5000);
> +
> +  if (size != 8) {
> +    err("Could not do mode read request from device (Wellspring Raw mode)");
> +    goto error;
> +  }
> +
> +  /* apply the mode switch */
> +  data[0] = ATP_WELLSPRING_MODE_VENDOR_VALUE_1;
> +  data[1] = ATP_WELLSPRING_MODE_VENDOR_VALUE_2;

This will crash the kernel if the kmalloc() failed.  And
kmalloc(GFP_DMA) can easily fail.

Do we really need memory from the GFP_DMA region for this driver?  It
would be terribly old-fashioned.

I dunno what USB driver normally use for their dma memory.  Perhaps
dma_alloc_coherent()?

> +  /* write configuration */
> +  size = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
> +			 ATP_WELLSPRING_MODE_WRITE_REQUEST_ID,
> +			 USB_DIR_OUT | USB_TYPE_CLASS | USB_RECIP_INTERFACE,
> +			 ATP_WELLSPRING_MODE_REQUEST_VALUE,
> +			 ATP_WELLSPRING_MODE_REQUEST_INDEX, data, 8, 5000);
> +
> +  if (size != 8) {
> +    err("Could not do mode write request to device (Wellspring Raw mode)");
> +    goto error;
> +  }
> +
> +  kfree(data);
> +  return 0;
> +
> + error:
> +  kfree(data);
> +  return -EIO;
> +}
> +
> +/* Structure to hold all of our device specific stuff */
> +struct atp {
> +  char			phys[64];
> +  struct usb_device    *udev;	      /* usb device */
> +  struct input_dev     *input;	      /* input dev */
> +  struct atp_config_t	cfg;	      /* device configuration */
> +  unsigned		open;	      /* non-zero if opened */
> +  struct urb	       *bt_urb;	      /* button usb request block */
> +  signed char	       *bt_data;      /* button transferred data */
> +  unsigned		bt_valid;     /* are the button sensors valid ? */
> +  unsigned		bt_state;     /* current button state */
> +  struct urb	       *tp_urb;	      /* trackpad usb request block */
> +  signed char	       *tp_data;      /* trackpad transferred data */
> +  unsigned		tp_valid;     /* are the trackpad sensors valid ? */
> +};
> +
> +static inline int raw2int(__le16 x)
> +{
> +  return (short)le16_to_cpu(x);

Given that this function returns signed 32-bit, I'd worry about what it
does when it is presented with 0xffff.  otoh, perhaps you indeed
intended to handle negative 16-bit quantities in that fashion, which
would make sense.

> +}
> +
> +static inline int int2scale(const struct atp_params_t *p, int x)
> +{
> +  return ((p->max-p->min)*x)/(p->devmax-p->devmin);
> +}

Is there any way in which this can get a divide-by-zero?

> +/**
> + * all value ranges, both device and logical, are assumed to be [a,b).
> + */
> +static inline int int2bound(const struct atp_params_t *p, int x)
> +{
> +  int s = p->min+int2scale(p, x);

Please put a space around the operators in expressions like this.

> +  return s < p->min?p->min:s >= p->max?p->max-1:s;

That's just unreadable. Please simplify it.

> +}
> +
> +/**

This leadin is exclusively used to identify a kerneldoc-style comment.

> + * check quality of reading.
> + * -1: bad data
> + * 0:  ignore this reading
> + * 1:  good reading
> + */

But this is not a kerneldoc comment.  Please remove all the incorrect
/** instances.

>
> ...
>
> +/**
> + * convert raw data to synaptics sensor output.
> + * returns the number of fingers on the trackpad,
> + * or a negative number in vase of bad data.
> + */
> +static int compute_movement(int *abs_x, int *abs_y,
> +			    int *rel_x, int *rel_y,
> +			    int *pressure,
> +			    struct atp_config_t *cfg,
> +			    const unsigned char *data, int size)
> +{
> +  const int nfinger = (size-26)/28;
> +  const struct tp_data_t *tp = (struct tp_data_t *) data;
> +
> +  if (nfinger) {
> +    *abs_x = int2bound(&cfg->x, raw2int(tp->finger->abs_x) - cfg->x.devmin);
> +    *abs_y = int2bound(&cfg->y, cfg->y.devmax - raw2int(tp->finger->abs_y));
> +    *rel_x = int2scale(&cfg->x, raw2int(tp->finger->rel_x));
> +    *rel_y = int2scale(&cfg->y, -raw2int(tp->finger->rel_y));
> +    *pressure = int2bound(&cfg->p, raw2int(tp->finger->force_major));
> +  } else {
> +    *abs_x = 0;
> +    *abs_y = 0;
> +    *rel_x = 0;
> +    *rel_y = 0;
> +    *pressure = 0;
> +  }
> +
> +  /* report zero fingers for zero pressure */
> +  return *pressure > 0?nfinger:0;

Normal style is

	return *pressure > 0 ? nfinger : 0;

(lots of other places)

> +}
> +
> +static void atp_button(struct urb *urb)
> +{
> +  struct atp *dev = urb->context;
> +  const unsigned char *data = dev->bt_data;
> +  const int size = dev->bt_urb->actual_length;
> +  int button = 0, retval;
> +
> +  switch (urb->status) {
> +  case 0:
> +    /* success */
> +    break;
> +  case -EOVERFLOW:
> +  case -ECONNRESET:
> +  case -ENOENT:
> +  case -ESHUTDOWN:
> +    /* This urb is terminated, clean up */
> +    dbg("%s - urb shutting down with status: %d",
> +	__func__, urb->status);
> +    return;
> +  default:
> +    dbg("%s - nonzero urb status received: %d",
> +	__func__, urb->status);
> +    goto exit;
> +  }
> +
> +  /* first sample data ignored */
> +  if (!dev->bt_valid) {
> +    dev->bt_valid = 1;
> +    goto exit;
> +  }
> +
> +  /* drop incomplete datasets */
> +  if (size != 4) {
> +    dprintk("bcm5974: incomplete button package (first byte: %d, length: %d)\n",
> +	    (int)data[0], size);
> +    goto exit;
> +  }
> +
> +  button = data[1];
> +
> +  /* only report button state changes */
> +  if (button != dev->bt_state) {
> +    input_report_key(dev->input, BTN_LEFT, button);
> +    input_sync(dev->input);
> +  }
> +
> +  dev->bt_state = button;
> +
> + exit:
> +  retval = usb_submit_urb(dev->bt_urb, GFP_ATOMIC);

GFP_ATOMIC is a red flag.  Is this quite unrelaible allocation mode
really needed here?

> +  if (retval) {
> +    err("%s - button usb_submit_urb failed with result %d",
> +	__func__, retval);
> +  }
> +}
> +
> +static void atp_trackpad(struct urb *urb)
> +{
> +  struct atp *dev = urb->context;
> +  int abs_x, abs_y, rel_x, rel_y, pressure;
> +  int quality, nfinger, retval;
> +
> +  switch (urb->status) {
> +  case 0:
> +    /* success */
> +    break;
> +  case -EOVERFLOW:
> +  case -ECONNRESET:
> +  case -ENOENT:
> +  case -ESHUTDOWN:
> +    /* This urb is terminated, clean up */
> +    dbg("%s - urb shutting down with status: %d",
> +	__func__, urb->status);
> +    return;
> +  default:
> +    dbg("%s - nonzero urb status received: %d",
> +	__func__, urb->status);
> +    goto exit;
> +  }
> +
> +  /* first sample data ignored */
> +  if (!dev->tp_valid) {
> +    dev->tp_valid = 1;
> +    goto exit;
> +  }
> +
> +  /* determine quality of reading */
> +  quality = compute_quality(dev->tp_data, dev->tp_urb->actual_length);
> +
> +  /* drop incomplete datasets */
> +  if (quality < 0) {
> +    dprintk("bcm5974: incomplete trackpad package "
> +	    "(first byte: %d, length: %d)\n",
> +	    (int)dev->tp_data[0], dev->tp_urb->actual_length);
> +    goto exit;
> +  }
> +
> +  /* drop poor quality readings */
> +  if (quality == 0)
> +    goto exit;
> +
> +  nfinger = compute_movement(&abs_x, &abs_y, &rel_x, &rel_y, &pressure,
> +			     &dev->cfg,
> +			     dev->tp_data, dev->tp_urb->actual_length);
> +
> +  if (debug > 1) {
> +    printk(KERN_DEBUG "bcm5974: x: %04d y: %04d dx: %3d dy: %3d p: %3d\n",
> +	   abs_x, abs_y, rel_x, rel_y, pressure);
> +  }
> +
> +  /* input_report_key(dev->input,BTN_TOUCH,pressure>dev->cfg.p.fuzz); */
> +  input_report_abs(dev->input, ABS_PRESSURE, pressure);
> +  input_report_abs(dev->input, ABS_X, abs_x);
> +  input_report_abs(dev->input, ABS_Y, abs_y);
> +  /* input_report_rel(dev->input, REL_X, rel_x); */
> +  /* input_report_rel(dev->input, REL_Y, rel_y); */
> +  input_report_key(dev->input, BTN_TOOL_FINGER, nfinger == 1);
> +  input_report_key(dev->input, BTN_TOOL_DOUBLETAP, nfinger == 2);
> +  input_report_key(dev->input, BTN_TOOL_TRIPLETAP, nfinger > 2);
> +  input_sync(dev->input);
> +
> + exit:
> +  retval = usb_submit_urb(dev->tp_urb, GFP_ATOMIC);

ditto.

> +  if (retval) {
> +    err("%s - trackpad usb_submit_urb failed with result %d",
> +	__func__, retval);
> +  }
> +}
> +
> +static int atp_open(struct input_dev *input)
> +{
> +  struct atp *dev = input_get_drvdata(input);
> +
> +  if (usb_submit_urb(dev->bt_urb, GFP_ATOMIC))
> +    goto error;
> +
> +  if (usb_submit_urb(dev->tp_urb, GFP_ATOMIC))
> +    goto err_free_bt_urb;

etc.

> +  dev->open = 1;
> +  return 0;
> +
> + err_free_bt_urb:
> +  usb_free_urb(dev->bt_urb);
> + error:
> +  return -EIO;
> +}
> +
>
> ...
>

