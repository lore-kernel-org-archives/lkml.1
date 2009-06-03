Return-Path: <linux-kernel-owner+w=401wt.eu-S1756255AbZFCH4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255AbZFCH4W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 03:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756417AbZFCH4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 03:56:05 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:39114 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755717AbZFCH4D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 03:56:03 -0400
Date: Wed, 3 Jun 2009 17:55:59 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Oliver Neukum <oliver@neukum.org>
Subject: linux-next: manual merge of the usb tree with the ttydev tree
Message-Id: <20090603175559.f15753c9.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
drivers/usb/class/cdc-acm.c between commit
255e62420b88b3788826591a9b2880d3a88ef498 ("tty-usb-acm-clean") from the
ttydev tree and commit c0c91103ffdc941959e5c7dbcd190d8229ab7922 ("USB:
support for cdc-acm of single interface devices") from the usb tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/usb/class/cdc-acm.c
index ddeb691,2afff9f..0000000
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@@ -1045,10 -1008,40 +1052,40 @@@ next_desc
  			return -ENODEV;
  		}
  	}
 -	
 +
  	if (data_interface_num != call_interface_num)
 -		dev_dbg(&intf->dev,"Separate call control interface. That is not fully supported.\n");
 +		dev_dbg(&intf->dev, "Separate call control interface. That is not fully supported.\n");
  
+ 	if (control_interface == data_interface) {
+ 		/* some broken devices designed for windows work this way */
+ 		dev_warn(&intf->dev,"Control and data interfaces are not separated!\n");
+ 		combined_interfaces = 1;
+ 		/* a popular other OS doesn't use it */
+ 		quirks |= NO_CAP_LINE;
+ 		if (data_interface->cur_altsetting->desc.bNumEndpoints != 3) {
+ 			dev_err(&intf->dev, "This needs exactly 3 endpoints\n");
+ 			return -EINVAL;
+ 		}
+ look_for_collapsed_interface:
+ 		for (i = 0; i < 3; i++) {
+ 			struct usb_endpoint_descriptor *ep;
+ 			ep = &data_interface->cur_altsetting->endpoint[i].desc;
+ 
+ 			if (usb_endpoint_is_int_in(ep))
+ 				epctrl = ep;
+ 			else if (usb_endpoint_is_bulk_out(ep))
+ 				epwrite = ep;
+ 			else if (usb_endpoint_is_bulk_in(ep))
+ 				epread = ep;
+ 			else
+ 				return -EINVAL;
+ 		}
+ 		if (!epctrl || !epread || !epwrite)
+ 			return -ENODEV;
+ 		else
+ 			goto made_compressed_probe;
+ 	}
+ 
  skip_normal_probe:
  
  	/*workaround for switched interfaces */
@@@ -1068,11 -1059,11 +1105,11 @@@
  	}
  
  	/* Accept probe requests only for the control interface */
- 	if (intf != control_interface)
+ 	if (!combined_interfaces && intf != control_interface)
  		return -ENODEV;
 -	
 +
- 	if (usb_interface_claimed(data_interface)) { /* valid in this context */
+ 	if (!combined_interfaces && usb_interface_claimed(data_interface)) { /* valid in this context */
 -		dev_dbg(&intf->dev,"The data interface isn't available\n");
 +		dev_dbg(&intf->dev, "The data interface isn't available\n");
  		return -EBUSY;
  	}
  
@@@ -1110,8 -1101,8 +1148,9 @@@ made_compressed_probe
  	}
  
  	ctrlsize = le16_to_cpu(epctrl->wMaxPacketSize);
 -	readsize = le16_to_cpu(epread->wMaxPacketSize)* ( quirks == SINGLE_RX_URB ? 1 : 2);
 +	readsize = le16_to_cpu(epread->wMaxPacketSize) *
 +				(quirks == SINGLE_RX_URB ? 1 : 2);
+ 	acm->combined_interfaces = combined_interfaces;
  	acm->writesize = le16_to_cpu(epwrite->wMaxPacketSize) * 20;
  	acm->control = control_interface;
  	acm->data = data_interface;
@@@ -1222,10 -1206,10 +1263,11 @@@
  	}
  
  skip_countries:
 -	usb_fill_int_urb(acm->ctrlurb, usb_dev, usb_rcvintpipe(usb_dev, epctrl->bEndpointAddress),
 -			 acm->ctrl_buffer, ctrlsize, acm_ctrl_irq, acm,
 +	usb_fill_int_urb(acm->ctrlurb, usb_dev,
 +			usb_rcvintpipe(usb_dev, epctrl->bEndpointAddress),
 +			acm->ctrl_buffer, ctrlsize, acm_ctrl_irq, acm,
- 			epctrl->bInterval);
+ 			 /* works around buggy devices */
+ 			 epctrl->bInterval ? epctrl->bInterval : 0xff);
  	acm->ctrlurb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
  	acm->ctrlurb->transfer_dma = acm->ctrl_dma;
  
@@@ -1308,14 -1291,14 +1350,15 @@@ static void acm_disconnect(struct usb_i
  	stop_data_traffic(acm);
  
  	acm_write_buffers_free(acm);
 -	usb_buffer_free(usb_dev, acm->ctrlsize, acm->ctrl_buffer, acm->ctrl_dma);
 +	usb_buffer_free(usb_dev, acm->ctrlsize, acm->ctrl_buffer,
 +								acm->ctrl_dma);
  	acm_read_buffers_free(acm);
  
- 	usb_driver_release_interface(&acm_driver, intf == acm->control ?
+ 	if (!acm->combined_interfaces)
+ 		usb_driver_release_interface(&acm_driver, intf == acm->control ?
  					acm->data : acm->control);
  
 -	if (!acm->used) {
 +	if (acm->port.count == 0) {
  		acm_tty_unregister(acm);
  		mutex_unlock(&open_mutex);
  		return;
