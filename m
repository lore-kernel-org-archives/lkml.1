Return-Path: <linux-kernel-owner+w=401wt.eu-S1753377AbYH2H2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377AbYH2H2q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 03:28:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751274AbYH2H2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 03:28:39 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:38199 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbYH2H2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 03:28:38 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: greg@kroah.com
Subject: Re: [patch 01/03] USB: USB/IP: add common functions needed
Date: Fri, 29 Aug 2008 09:29:51 +0200
User-Agent: KMail/1.9.9
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Brian Merrell <bgmerrell@novell.com>,
       Takahiro Hirofuchi <hirofuchi@users.sourceforge.net>, gregkh@suse.de
References: <20080828225248.758800945@mini.kroah.org> <20080828230031.GB15014@kroah.com>
In-Reply-To: <20080828230031.GB15014@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808290929.52547.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag 29 August 2008 01:00:31 schrieb greg@kroah.com:
> From: Takahiro Hirofuchi <hirofuchi@users.sourceforge.net>

> +static ssize_t store_flag(struct device *dev, struct device_attribute *attr,
> +		const char *buf, size_t count)
> +{
> +	unsigned long flag;
> +
> +	sscanf(buf, "%lx", &flag);

Needs error handling

> +	usbip_debug_flag = flag;
> +
> +	return count;
> +}
> +DEVICE_ATTR(usbip_debug, (S_IRUGO | S_IWUSR), show_flag, store_flag);
> +
> +static void usbip_dump_buffer(char *buff, int bufflen)

Such functions better print into a buffer, handed over in one go.
Otherwise you can get results
-second message-
like this

> +/* there may be more cases to tweak the flags. */
> +static unsigned int tweak_transfer_flags(unsigned int flags)
> +{
> +
> +	if (flags & URB_NO_TRANSFER_DMA_MAP)
> +		/*
> +		 * vhci_hcd does not provide DMA-mapped I/O. The upper
> +		 * driver does not need to set this flag. The remote
> +		 * usbip.ko does not still perform DMA-mapped I/O for
> +		 * DMA-caplable host controllers. So, clear this flag.
> +		 */
> +		flags &= ~URB_NO_TRANSFER_DMA_MAP;
> +
> +	if (flags & URB_NO_SETUP_DMA_MAP)
> +		flags &= ~URB_NO_SETUP_DMA_MAP;

There's no need to do this conditionally.

> +/* must free buffer */
> +void *usbip_alloc_iso_desc_pdu(struct urb *urb, ssize_t *bufflen)
> +{
> +	void *buff;
> +	struct usbip_iso_packet_descriptor *iso;
> +	int np = urb->number_of_packets;
> +	ssize_t size = np * sizeof(*iso);
> +	int i;
> +
> +	buff = kzalloc(size, GFP_KERNEL);

Are you sure you cannot badly recourse here?

	Regards
		Oliver
