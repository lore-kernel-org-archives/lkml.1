Return-Path: <linux-kernel-owner+w=401wt.eu-S1754650AbXJVD6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbXJVD6R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 23:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751532AbXJVD6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 23:58:08 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:47273 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbXJVD6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 23:58:07 -0400
Message-ID: <471C1FC9.1070705@mvista.com>
Date: Sun, 21 Oct 2007 22:58:01 -0500
From: Corey Minyard <cminyard@mvista.com>
User-Agent: Icedove 1.5.0.12 (X11/20070606)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
Cc: openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] ipmi_demangle_device_id(): remove dead code
References: <20071022024814.GL30533@stusta.de>
In-Reply-To: <20071022024814.GL30533@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, it's a problem, but wrong fix.  Thanks, I'll send a patch for it.

-corey

Adrian Bunk wrote:
> This patch removes obviously dead code spotted by the Coverity checker.
>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
>
> ---
>
>  include/linux/ipmi_smi.h |   10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)
>
> --- linux-2.6/include/linux/ipmi_smi.h.old	2007-10-21 23:03:03.000000000 +0200
> +++ linux-2.6/include/linux/ipmi_smi.h	2007-10-21 23:05:59.000000000 +0200
> @@ -158,44 +158,38 @@ static inline int ipmi_demangle_device_i
>  	if (data_len < 9)
>  		return -EINVAL;
>  	if (data[0] != IPMI_NETFN_APP_RESPONSE << 2 ||
>  	    data[1] != IPMI_GET_DEVICE_ID_CMD)
>  		/* Strange, didn't get the response we expected. */
>  		return -EINVAL;
>  	if (data[2] != 0)
>  		/* That's odd, it shouldn't be able to fail. */
>  		return -EINVAL;
>  
>  	data += 3;
>  	data_len -= 3;
>  	id->device_id = data[0];
>  	id->device_revision = data[1];
>  	id->firmware_revision_1 = data[2];
>  	id->firmware_revision_2 = data[3];
>  	id->ipmi_version = data[4];
>  	id->additional_device_support = data[5];
> -	if (data_len >= 6) {
> -		id->manufacturer_id = (data[6] | (data[7] << 8) |
> -				       (data[8] << 16));
> -		id->product_id = data[9] | (data[10] << 8);
> -	} else {
> -		id->manufacturer_id = 0;
> -		id->product_id = 0;
> -	}
> +	id->manufacturer_id = (data[6] | (data[7] << 8) | (data[8] << 16));
> +	id->product_id = data[9] | (data[10] << 8);
>  	if (data_len >= 15) {
>  		memcpy(id->aux_firmware_revision, data+11, 4);
>  		id->aux_firmware_revision_set = 1;
>  	} else
>  		id->aux_firmware_revision_set = 0;
>  
>  	return 0;
>  }
>  
>  /* Add a low-level interface to the IPMI driver.  Note that if the
>     interface doesn't know its slave address, it should pass in zero.
>     The low-level interface should not deliver any messages to the
>     upper layer until the start_processing() function in the handlers
>     is called, and the lower layer must get the interface from that
>     call. */
>  int ipmi_register_smi(struct ipmi_smi_handlers *handlers,
>  		      void                     *send_info,
>  		      struct ipmi_device_id    *device_id,
>   

