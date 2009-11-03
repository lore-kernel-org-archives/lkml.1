Return-Path: <linux-kernel-owner+w=401wt.eu-S1753608AbZKCMNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608AbZKCMNW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 07:13:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbZKCMNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 07:13:19 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:49773 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591AbZKCMNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 07:13:18 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: virtualization@lists.linux-foundation.org
Subject: Re: [PATCHv6 1/3] tun: export underlying socket
Date: Tue, 3 Nov 2009 13:12:33 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       linux-mm@kvack.org, akpm@linux-foundation.org, hpa@zytor.com,
       gregory.haskins@gmail.com, Rusty Russell <rusty@rustcorp.com.au>,
       s.hetze@linux-ag.com
References: <cover.1257193660.git.mst@redhat.com> <20091102222612.GB15184@redhat.com>
In-Reply-To: <20091102222612.GB15184@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911031312.33580.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18ueCjAbte+YVeiIbHjzyAfBXJRdEdMLeDAosr
 kWMzC+0uhzkre/ZYR3VShDlUj/R9eBObstdXiaRWXIL+9PBbeJ
 14TCCP40U5vLtsjeoaOMA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 November 2009, Michael S. Tsirkin wrote:
> Tun device looks similar to a packet socket
> in that both pass complete frames from/to userspace.
> 
> This patch fills in enough fields in the socket underlying tun driver
> to support sendmsg/recvmsg operations, and message flags
> MSG_TRUNC and MSG_DONTWAIT, and exports access to this socket
> to modules.  Regular read/write behaviour is unchanged.
> 
> This way, code using raw sockets to inject packets
> into a physical device, can support injecting
> packets into host network stack almost without modification.
> 
> First user of this interface will be vhost virtualization
> accelerator.

You mentioned before that you wanted to export the socket
using some ioctl function returning an open file descriptor,
which seemed to be a cleaner approach than this one.

What was your reason for changing?

> index 3f5fd52..404abe0 100644
> --- a/include/linux/if_tun.h
> +++ b/include/linux/if_tun.h
> @@ -86,4 +86,18 @@ struct tun_filter {
>         __u8   addr[0][ETH_ALEN];
>  };
>  
> +#ifdef __KERNEL__
> +#if defined(CONFIG_TUN) || defined(CONFIG_TUN_MODULE)
> +struct socket *tun_get_socket(struct file *);
> +#else
> +#include <linux/err.h>
> +#include <linux/errno.h>
> +struct file;
> +struct socket;
> +static inline struct socket *tun_get_socket(struct file *f)
> +{
> +       return ERR_PTR(-EINVAL);
> +}
> +#endif /* CONFIG_TUN */
> +#endif /* __KERNEL__ */
>  #endif /* __IF_TUN_H */

Is this a leftover from testing? Exporting the function for !__KERNEL__
seems pointless.

	Arnd <><

