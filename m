Return-Path: <linux-kernel-owner+w=401wt.eu-S1754818AbXJ3IwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818AbXJ3IwP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 04:52:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751583AbXJ3IwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 04:52:00 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:44694 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbXJ3Iv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 04:51:59 -0400
From: Oliver Neukum <oliver@neukum.org>
To: linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] [PATCH 1/2] usb_gigaset: suspend support
Date: Tue, 30 Oct 2007 09:52:43 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Tilman Schmidt <tilman@imap.cc>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Hansjoerg Lipp <hjlipp@web.de>, Karsten Keil <kkeil@suse.de>,
       i4ldeveloper@listserv.isdn4linux.de
References: <20071029185311.4C955FC04C@xenon.ts.pxnet.com>
In-Reply-To: <20071029185311.4C955FC04C@xenon.ts.pxnet.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710300952.44232.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 29 Oktober 2007 schrieb Tilman Schmidt:
> From: Tilman Schmidt <tilman@imap.cc>
> 
> Add basic suspend/resume support to the usb_gigaset driver.
> 
> Signed-off-by: Tilman Schmidt <tilman@imap.cc>
> ---
> 
>  drivers/isdn/gigaset/usb-gigaset.c |   69 ++++++++++++++++++++++++++++++++++++-
>  1 file changed, 68 insertions(+), 1 deletion(-)
> 
> --- a/drivers/isdn/gigaset/usb-gigaset.c	2007-10-23 01:48:12.000000000 +0200
> +++ b/drivers/isdn/gigaset/usb-gigaset.c	2007-10-24 00:47:32.000000000 +0200
> @@ -104,10 +104,15 @@ MODULE_DEVICE_TABLE(usb, gigaset_table);
>   * flags per packet.
>   */
>  
> +/* functions called if a device of this driver is connected/disconnected */
>  static int gigaset_probe(struct usb_interface *interface,
>  			 const struct usb_device_id *id);
>  static void gigaset_disconnect(struct usb_interface *interface);
>  
> +/* functions called before/after suspend */
> +static int gigaset_suspend(struct usb_interface *intf, pm_message_t message);
> +static int gigaset_resume(struct usb_interface *intf);
> +
>  static struct gigaset_driver *driver = NULL;
>  static struct cardstate *cardstate = NULL;
>  
> @@ -117,6 +122,11 @@ static struct usb_driver gigaset_usb_dri
>  	.probe =	gigaset_probe,
>  	.disconnect =	gigaset_disconnect,
>  	.id_table =	gigaset_table,
> +	.suspend =	gigaset_suspend,
> +	.resume =	gigaset_resume,
> +	.reset_resume =	gigaset_resume,
> +	.pre_reset =	gigaset_suspend,
> +	.post_reset =	gigaset_resume,
>  };
>  
>  struct usb_cardstate {
> @@ -831,7 +843,7 @@ static void gigaset_disconnect(struct us
>  	usb_set_intfdata(interface, NULL);
>  	tasklet_kill(&cs->write_tasklet);
>  
> -	usb_kill_urb(ucs->bulk_out_urb);	/* FIXME: only if active? */
> +	usb_kill_urb(ucs->bulk_out_urb);
>  
>  	kfree(ucs->bulk_out_buffer);
>  	usb_free_urb(ucs->bulk_out_urb);
> @@ -847,6 +859,63 @@ static void gigaset_disconnect(struct us
>  	gigaset_unassign(cs);
>  }
>  
> +/* gigaset_suspend
> + * This function is called before the USB connection is suspended or reset.
> + */
> +static int gigaset_suspend(struct usb_interface *intf, pm_message_t message)
> +{
> +	struct cardstate *cs;
> +	struct usb_cardstate *ucs;
> +	int rc;
> +
> +	if ((cs = usb_get_intfdata(intf)) == NULL ||
> +	    (ucs = cs->hw.usb) == NULL) {
> +		err("%s: no cardstate", __func__);
> +		return -EFAULT;
> +	}
> +
> +	//FIXME stop common module activities? ISDN_STAT_STOP? block open()?
> +
> +	/* stop submitting bulk URBs */
> +	tasklet_disable(&cs->write_tasklet);
> +
> +	/* kill pending read URB */
> +	usb_kill_urb(ucs->read_urb);

no pending write URB?

	Regards
		Oliver
