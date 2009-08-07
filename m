Return-Path: <linux-kernel-owner+w=401wt.eu-S1757759AbZHGM1D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757759AbZHGM1D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 08:27:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757733AbZHGM1C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 08:27:02 -0400
Received: from ocean.emcraft.com ([213.221.7.182]:44699 "EHLO
	ocean.emcraft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757258AbZHGM1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 08:27:00 -0400
X-Greylist: delayed 3353 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Aug 2009 08:27:00 EDT
Date: Fri, 7 Aug 2009 15:31:06 +0400
From: Sergei Poselenov <sposelenov@emcraft.com>
To: linux-kernel@vger.kernel.org
Cc: wd@denx.de
Subject: Re: [PATCH] Fix userland build failure in linux/if_tunnel.h
Message-ID: <20090807153106.335b1b8f@emcraft.com>
In-Reply-To: <20090618183738.662f7ef1@emcraft.com>
References: <20090618183738.662f7ef1@emcraft.com>
Organization: Emcraft Systems
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

Unfortunately, received no replies, but the problem still persists.

Probably, I was unclear describing the issue. It is not the busybox
build problem - any application including exported linux/if_tunnel.h
could fail the linkage because of unresolved __cpu_to_be16().

Here is a reduced testcase program:

#include <netinet/ip.h>
#include <net/if.h>
#include <net/if_arp.h>
#include <asm/types.h>

#include <linux/if_tunnel.h>

void foo(void);
void foo(void)
{
	int a = GRE_CSUM;
}

How to reproduce:

bash> arm-linux-gcc -c t.c
bash> nm -n t.o
         U __cpu_to_be16
00000000 t $a
00000000 T foo

As you see, __cpu_to_be16 is undefined, so linking will fail.
Adding <asm/byteorder.h> to if_tunnel.h, as I suggested, fixes the
problem.

Thanks for any comments,
Sergei

On Thu, 18 Jun 2009 18:37:38 +0400
Sergei Poselenov <sposelenov@emcraft.com> wrote:

> Hello all,
> 
> The last commit to linux/if_tunnel.h broke the busybox
> application build.
> When linking the final image linker complains:
> networking/libiproute/lib.a(iptunnel.o): In function `parse_args':
> /work/psl/e/arm-aa/target_rpms/busybox/BUILD/busybox-1.7.1/networking/libiproute/iptunnel.c:189:
> undefined reference to
> `__cpu_to_be16' /work/psl/e/arm-aa/target_rpms/busybox/BUILD/busybox-1.7.1/networking/libiproute/iptunnel.c:190:
> undefined reference to
> `__cpu_to_be16' /work/psl/e/arm-aa/target_rpms/busybox/BUILD/busybox-1.7.1/networking/libiproute/iptunnel.c:202:
> undefined reference to `__cpu_to_be16'
> ...
> 
> Please review the following patch, which fixes the build error.
> 
> Subject: [PATCH] The busybox application build failed in linking
> complaining to unresolved __cpu_to_be16 (ARM target). This patch
> fixes this.
> 
> Signed-off-by: Sergei Poselenov <sposelenov@emcraft.com>
> ---
>  include/linux/if_tunnel.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/if_tunnel.h b/include/linux/if_tunnel.h
> index 5a9aae4..137130b 100644
> --- a/include/linux/if_tunnel.h
> +++ b/include/linux/if_tunnel.h
> @@ -2,6 +2,7 @@
>  #define _IF_TUNNEL_H_
>  
>  #include <linux/types.h>
> +#include <asm/byteorder.h>
>  
>  #ifdef __KERNEL__
>  #include <linux/ip.h>

