Return-Path: <linux-kernel-owner+w=401wt.eu-S1758656AbXKGRbK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758656AbXKGRbK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 12:31:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757902AbXKGRaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 12:30:52 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:36733 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757475AbXKGRav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 12:30:51 -0500
Message-ID: <4731F64A.7080309@us.ibm.com>
Date: Wed, 07 Nov 2007 11:30:50 -0600
From: Anthony Liguori <aliguori@us.ibm.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Dor Laor <dor.laor@qumranet.com>, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, lguest <lguest@ozlabs.org>
Subject: Re: [PATCH] virtio config_ops refactoring
References: <4730A8F3.6020008@us.ibm.com> <200711070957.44165.rusty__13109.5125260346$1194390035$gmane$org@rustcorp.com.au> <4730F351.5060006@us.ibm.com> <200711071704.09752.rusty@rustcorp.com.au>
In-Reply-To: <200711071704.09752.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> After discussion with Anthony, the virtio config has been simplified.  We
> lose some minor features (the virtio_net address must now be 6 bytes) but
> it turns out to be a wash in terms of complexity, while simplifying PCI.
>   

Hi Rusty,

Thanks for posting this!  It's really simplified things for me.

> -
>  /**
> - * virtio_use_bit - helper to use a feature bit in a bitfield value.
> - * @dev: the virtio device
> - * @token: the token as returned from vdev->config->find().
> - * @len: the length of the field.
> - * @bitnum: the bit to test.
> + * __virtio_config_val - get a single virtio config without feature check.
> + * @vdev: the virtio device
> + * @offset: the type to search for.
> + * @val: a pointer to the value to fill in.
>   *
> - * If handed a NULL token, it returns false, otherwise returns bit status.
> - * If it's one, it sets the mirroring acknowledgement bit. */
> -int virtio_use_bit(struct virtio_device *vdev,
> -		   void *token, unsigned int len, unsigned int bitnum);
> + * The value is endian-corrected and returned in v. */
> +#define __virtio_config_val(vdev, offset, v) do {			\
> +	BUILD_BUG_ON(sizeof(*(v)) != 1 && sizeof(*(v)) != 2		\
> +		     && sizeof(*(v)) != 4 && sizeof(*(v)) != 8);	\
> +	(vdev)->config->get((vdev), (offset), (v), sizeof(*(v)));	\
> +	switch (sizeof(*(v))) {						\
> +	case 2: le16_to_cpus((__u16 *) v); break;			\
> +	case 4: le32_to_cpus((__u32 *) v); break;			\
> +	case 8: le64_to_cpus((__u64 *) v); break;			\
> +	}								\
> +} while(0)
>   

I would prefer that the virtio API not expose a little endian standard.  
I'm currently converting config->get() ops to ioreadXX depending on the 
size which already does the endianness conversion for me so this just 
messes things up.  I think it's better to let the backend deal with 
endianness since it's trivial to handle for both the PCI backend and the 
lguest backend (lguest doesn't need to do any endianness conversion).

Regards,

Anthony Liguori

>  #endif /* __KERNEL__ */
>  #endif /* _LINUX_VIRTIO_CONFIG_H */
> diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
> index ae469ae..8bf1602 100644
> --- a/include/linux/virtio_net.h
> +++ b/include/linux/virtio_net.h
> @@ -5,16 +5,16 @@
>  /* The ID for virtio_net */
>  #define VIRTIO_ID_NET	1
>
> -/* The bitmap of config for virtio net */
> -#define VIRTIO_CONFIG_NET_F	0x40
> +/* The feature bitmap for virtio net */
>  #define VIRTIO_NET_F_NO_CSUM	0
>  #define VIRTIO_NET_F_TSO4	1
>  #define VIRTIO_NET_F_UFO	2
>  #define VIRTIO_NET_F_TSO4_ECN	3
>  #define VIRTIO_NET_F_TSO6	4
> +#define VIRTIO_NET_F_MAC	5
>
> -/* The config defining mac address. */
> -#define VIRTIO_CONFIG_NET_MAC_F	0x41
> +/* The config defining mac address (6 bytes) */
> +#define VIRTIO_CONFIG_NET_MAC_F	0
>
>  /* This is the first element of the scatter-gather list.  If you don't
>   * specify GSO or CSUM features, you can simply ignore the header. */
>   

