Return-Path: <linux-kernel-owner+w=401wt.eu-S1760470AbYGKTXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760470AbYGKTXQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 15:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758116AbYGKTUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 15:20:19 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:11711 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758965AbYGKTUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 15:20:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=aHQfgx2oPIDWQx7hxNpV45SfwIua/k7rYfE7+yaKGpZeHxIcXm10gcPdLhIw/Y2+Mv
         rGoc19BpjQBv+Gum6ReBTywOvJG72t7en1TG633AZB8ltvj3b2FINbO44VZzAvplE/b8
         ic17R8XM8GfHydqxSAOXJqJaa9L+UuSORe/mk=
Message-ID: <e9c3a7c20807111220q432e712q734e075e6d533e5c@mail.gmail.com>
Date: Fri, 11 Jul 2008 12:20:15 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Maciej Sosnowski" <maciej.sosnowski@intel.com>
Subject: Re: [PATCH 2/2] I/OAT: tcp_dma_copybreak default value dependant on I/OAT version
Cc: shannon.nelson@intel.com, linux-kernel@vger.kernel.org
In-Reply-To: <20080711113703.337.72444.stgit@linux.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080711113553.337.50006.stgit@linux.site>
	 <20080711113703.337.72444.stgit@linux.site>
X-Google-Sender-Auth: e4877b4908ed0177
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2008 at 4:37 AM, Maciej Sosnowski
<maciej.sosnowski@intel.com> wrote:
> I/OAT DMA performance tuning showed different optimal values
> of tcp_dma_copybreak for different I/OAT versions
> (4096 for 1.2 and 2048 for 2.0).
> This patch lets ioatdma driver set tcp_dma_copybreak value
> according to these results.
>
> Signed-off-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
> ---
>
>  drivers/dma/dmaengine.c   |    3 +++
>  drivers/dma/ioat_dma.c    |   15 +++++++++++++++
>  include/linux/dmaengine.h |    2 ++
>  3 files changed, 20 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
> index 97b329e..d57365a 100644
> --- a/drivers/dma/dmaengine.c
> +++ b/drivers/dma/dmaengine.c
> @@ -70,6 +70,7 @@ #include <linux/percpu.h>
>  #include <linux/rcupdate.h>
>  #include <linux/mutex.h>
>  #include <linux/jiffies.h>
> +#include <net/tcp.h>
>
>  static DEFINE_MUTEX(dma_list_mutex);
>  static LIST_HEAD(dma_device_list);
> @@ -402,6 +403,8 @@ int dma_async_device_register(struct dma
>        list_add_tail(&device->global_node, &dma_device_list);
>        mutex_unlock(&dma_list_mutex);
>
> +       sysctl_tcp_dma_copybreak = device->tcp_dma_copybreak;
> +

Hi Maciej,

When NET_DMA is not enabled this breaks the build.  Also, given that
NET_DMA is only beneficial on architectures with i/o coherent caches
this fix up should be done directly in the driver, not passed up to
the common core.

Regards,
Dan
