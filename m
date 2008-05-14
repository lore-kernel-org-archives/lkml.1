Return-Path: <linux-kernel-owner+w=401wt.eu-S1760744AbYENOPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760744AbYENOPV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 10:15:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754109AbYENOPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 10:15:09 -0400
Received: from main.gmane.org ([80.91.229.2]:47864 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753494AbYENOPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 10:15:07 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
Subject: Re: HSO: add option hso driver
Date: Wed, 14 May 2008 16:59:52 +0300
Message-ID: <482AF058.3020505@teltonika.lt>
References: <20080513215134.GC6139@kroah.com> <20080513232727.21c74bb2@core> <482A23B8.7050705@pobox.com> <20080514015815.GA29785@kroah.com> <20080514045712.GA2843@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: linux-usb@vger.kernel.org, netdev@vger.kernel.org
X-Gmane-NNTP-Posting-Host: 82-135-208-232.static.zebra.lt
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
In-Reply-To: <20080514045712.GA2843@kroah.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Kroah-Hartman wrote:
> +#define DRIVER_VERSION			"1.2"

Maybe we should bump the version?
Now it is the same as the different driver at PHARscape.

> +/* called once for each interface upon device insertion */
> +static int hso_probe(struct usb_interface *interface,
> +		     const struct usb_device_id *id)
> +{
> +	int mux, i, if_num, port_spec;
> +	unsigned char port_mask;
> +	struct hso_device *hso_dev = NULL;
> +	struct hso_shared_int *shared_int;
> +	struct hso_device *tmp_dev = NULL;
> +
> +	if_num = interface->altsetting->desc.bInterfaceNumber;
> +
> +	/* Get the interface/port specification from either driver_info or from
> +	 * the device itself */
> +	if (id->driver_info)
> +		port_spec = ((u32 *)(id->driver_info))[if_num];
> +	else
> +		port_spec = hso_get_config_data(interface);
> +
> +	if (interface->cur_altsetting->desc.bInterfaceClass != 0xFF) {
> +		dev_err(&interface->dev, "Not our interface\n");
> +		return -ENODEV;
> +	}
> +	/* Check if we need to switch to alt interfaces prior to port
> +	 * configuration */
> +	if (interface->num_altsetting > 1)
> +		usb_set_interface(interface_to_usbdev(interface), if_num, 1);
> +	interface->needs_remote_wakeup = 1;
> +
> +	/* Allocate new hso device(s) */
> +	switch (port_spec & HSO_INTF_MASK) {
> +	case HSO_INTF_MUX:
> +		if ((port_spec & HSO_PORT_MASK) == HSO_PORT_NETWORK) {
> +			/* Create the network device */
> +			if (!disable_net) {
> +				hso_dev = hso_create_net_device(interface);
> +				if (!hso_dev)
> +					goto exit;
> +				tmp_dev = hso_dev;
> +			}
> +		}
> +
> +		if (hso_get_mux_ports(interface, &port_mask))
> +			/* TODO: de-allocate everything */
> +			goto exit;
> +
> +		shared_int = hso_create_shared_int(interface);
> +		if (!shared_int)
> +			goto exit;
> +
> +		for (i = 1, mux = 0; i < 0x100; i = i << 1, mux++) {
> +			if (port_mask & i) {
> +				hso_dev = hso_create_mux_serial_device(
> +						interface, i, shared_int);
> +				if (!hso_dev)
> +					goto exit;
> +			}
> +		}
> +
> +		if (tmp_dev)
> +			hso_dev = tmp_dev;
> +		break;
> +
> +	case HSO_INTF_BULK:
> +		/* It's a regular bulk interface */
> +		if (((port_spec & HSO_PORT_MASK) == HSO_PORT_NETWORK)
> +		    && !disable_net)
> +			hso_dev = hso_create_net_device(interface);
> +		else
> +			hso_dev =
> +			    hso_create_bulk_serial_device(interface, port_spec);
> +		if (!hso_dev)
> +			goto exit;
> +		break;
> +	default:
> +		goto exit;
> +	}
> +
> +	usb_driver_claim_interface(&hso_driver, interface, hso_dev);

Is usb_driver_claim_interface really needed?

> +	/* save our data pointer in this device */
> +	usb_set_intfdata(interface, hso_dev);
> +
> +	/* done */
> +	return 0;
> +exit:
> +	hso_free_interface(interface);
> +	return -ENODEV;
> +}

