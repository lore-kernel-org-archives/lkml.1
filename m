Return-Path: <linux-kernel-owner+w=401wt.eu-S1755610AbYJVLnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610AbYJVLnS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 07:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752735AbYJVLnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 07:43:06 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47630 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043AbYJVLnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 07:43:04 -0400
Date: Wed, 22 Oct 2008 13:43:02 +0200
From: Pavel Machek <pavel@suse.cz>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Greg Kroah-Hartman <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] w35und: wb35_probe() cleanup
Message-ID: <20081022114302.GG7843@atrey.karlin.mff.cuni.cz>
References: <Pine.LNX.4.64.0810221103550.13366@melkki.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0810221103550.13366@melkki.cs.Helsinki.FI>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> Fix error handling in wb35_probe() function and clean it up a bit.
> 
> Cc: Pavel Machek <pavel@suse.cz>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>

ACK. And thanks for the series!
									Pavel

> ---
>  drivers/staging/winbond/linux/wbusb.c |  101 +++++++++++++++------------------
>  1 files changed, 45 insertions(+), 56 deletions(-)
> 
> diff --git a/drivers/staging/winbond/linux/wbusb.c b/drivers/staging/winbond/linux/wbusb.c
> index 9f1064d..b4be0d8 100644
> --- a/drivers/staging/winbond/linux/wbusb.c
> +++ b/drivers/staging/winbond/linux/wbusb.c
> @@ -181,26 +181,32 @@ int wb35_probe(struct usb_interface *intf, const struct usb_device_id *id_table)
>  	PWBUSB		pWbUsb;
>          struct usb_host_interface *interface;
>  	struct usb_endpoint_descriptor *endpoint;
> -	int	ret = -1;
>  	u32	ltmp;
>  	struct usb_device *udev = interface_to_usbdev(intf);
> +	struct wbsoft_priv *priv;
> +	struct ieee80211_hw *dev;
> +	int err;
>  
>  	usb_get_dev(udev);
>  
> -	printk("[w35und]wb35_probe ->\n");
> -
>  	// 20060630.2 Check the device if it already be opened
> -	ret = usb_control_msg(udev, usb_rcvctrlpipe( udev, 0 ),
> +	err = usb_control_msg(udev, usb_rcvctrlpipe( udev, 0 ),
>  			      0x01, USB_TYPE_VENDOR|USB_RECIP_DEVICE|USB_DIR_IN,
>  			      0x0, 0x400, &ltmp, 4, HZ*100 );
> -	if (ret < 0)
> +	if (err)
>  		goto error;
>  
>  	ltmp = cpu_to_le32(ltmp);
> -	if (ltmp)  // Is already initialized?
> +	if (ltmp) {  // Is already initialized?
> +		err = -EBUSY;
>  		goto error;
> +	}
>  
>  	adapter = kzalloc(sizeof(*adapter), GFP_KERNEL);
> +	if (!adapter) {
> +		err = -ENOMEM;
> +		goto error;
> +	}
>  
>  	my_adapter = adapter;
>  	pWbUsb = &adapter->sHwData.WbUsb;
> @@ -215,70 +221,53 @@ int wb35_probe(struct usb_interface *intf, const struct usb_device_id *id_table)
>  	}
>  
>  	if (!WbWLanInitialize(adapter)) {
> -		printk("[w35und]WbWLanInitialize fail\n");
> -		goto error;
> +		err = -EINVAL;
> +		goto error_free_adapter;
>  	}
>  
> -	{
> -		struct wbsoft_priv *priv;
> -		struct ieee80211_hw *dev;
> -		int res;
> -
> -		dev = ieee80211_alloc_hw(sizeof(*priv), &wbsoft_ops);
> -
> -		if (!dev) {
> -			printk("w35und: ieee80211 alloc failed\n" );
> -			BUG();
> -		}
> +	dev = ieee80211_alloc_hw(sizeof(*priv), &wbsoft_ops);
> +	if (!dev)
> +		goto error_free_adapter;
>  
> -		my_dev = dev;
> +	my_dev = dev;
>  
> -		SET_IEEE80211_DEV(dev, &udev->dev);
> -		{
> -			phw_data_t pHwData = &adapter->sHwData;
> -			unsigned char		dev_addr[MAX_ADDR_LEN];
> -			hal_get_permanent_address(pHwData, dev_addr);
> -			SET_IEEE80211_PERM_ADDR(dev, dev_addr);
> -		}
> -
> -
> -		dev->extra_tx_headroom = 12;	/* FIXME */
> -		dev->flags = 0;
> -
> -		dev->channel_change_time = 1000;
> -//		dev->max_rssi = 100;
> +	SET_IEEE80211_DEV(dev, &udev->dev);
> +	{
> +		phw_data_t pHwData = &adapter->sHwData;
> +		unsigned char		dev_addr[MAX_ADDR_LEN];
> +		hal_get_permanent_address(pHwData, dev_addr);
> +		SET_IEEE80211_PERM_ADDR(dev, dev_addr);
> +	}
>  
> -		dev->queues = 1;
> +	dev->extra_tx_headroom = 12;	/* FIXME */
> +	dev->flags = 0;
>  
> -		static struct ieee80211_supported_band band;
> +	dev->channel_change_time = 1000;
> +	dev->queues = 1;
>  
> -		band.channels = wbsoft_channels;
> -		band.n_channels = ARRAY_SIZE(wbsoft_channels);
> -		band.bitrates = wbsoft_rates;
> -		band.n_bitrates = ARRAY_SIZE(wbsoft_rates);
> +	static struct ieee80211_supported_band band;
>  
> -		dev->wiphy->bands[IEEE80211_BAND_2GHZ] = &band;
> -#if 0
> -		wbsoft_modes[0].num_channels = 1;
> -		wbsoft_modes[0].channels = wbsoft_channels;
> -		wbsoft_modes[0].mode = MODE_IEEE80211B;
> -		wbsoft_modes[0].num_rates = ARRAY_SIZE(wbsoft_rates);
> -		wbsoft_modes[0].rates = wbsoft_rates;
> +	band.channels = wbsoft_channels;
> +	band.n_channels = ARRAY_SIZE(wbsoft_channels);
> +	band.bitrates = wbsoft_rates;
> +	band.n_bitrates = ARRAY_SIZE(wbsoft_rates);
>  
> -		res = ieee80211_register_hwmode(dev, &wbsoft_modes[0]);
> -		BUG_ON(res);
> -#endif
> +	dev->wiphy->bands[IEEE80211_BAND_2GHZ] = &band;
>  
> -		res = ieee80211_register_hw(dev);
> -		BUG_ON(res);
> -	}
> +	err = ieee80211_register_hw(dev);
> +	if (err)
> +		goto error_free_hw;
>  
> -	usb_set_intfdata( intf, adapter );
> +	usb_set_intfdata(intf, adapter);
>  
> -	printk("[w35und] _probe OK\n");
>  	return 0;
> +
> +error_free_hw:
> +	ieee80211_free_hw(dev);
> +error_free_adapter:
> +	kfree(adapter);
>  error:
> -	return -ENOMEM;
> +	return err;
>  }
>  
>  void packet_came(char *pRxBufferAddress, int PacketSize)

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
