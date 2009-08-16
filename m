Return-Path: <linux-kernel-owner+w=401wt.eu-S1751919AbZHPNrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919AbZHPNrz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 09:47:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750919AbZHPNrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 09:47:55 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58194 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221AbZHPNrx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 09:47:53 -0400
Message-ID: <4A880DFE.2040507@redhat.com>
Date: Sun, 16 Aug 2009 16:47:42 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Shirley Ma <mashirle@us.ibm.com>
CC: netdev@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] defer skb allocation in virtio_net -- mergable buff part
References: <1250145231.6653.29.camel@localhost.localdomain>
In-Reply-To: <1250145231.6653.29.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2009 09:33 AM, Shirley Ma wrote:
> Guest virtio_net receives packets from its pre-allocated vring
> buffers, then it delivers these packets to upper layer protocols
> as skb buffs. So it's not necessary to pre-allocate skb for each
> mergable buffer, then frees it when it's useless.
>
> This patch has deferred skb allocation to when receiving packets,
> it reduces skb pre-allocations and skb_frees. And it induces two
> page list: freed_pages and used_page list, used_pages is used to
> track pages pre-allocated, it is only useful when removing virtio_net.
>
> This patch has tested and measured against 2.6.31-rc4 git,
> I thought this patch will improve large packet performance, but I saw
> netperf TCP_STREAM performance improved for small packet for both
> local guest to host and host to local guest cases. It also reduces
> UDP packets drop rate from host to local guest. I am not fully understand
> why.
>
> The netperf results from my laptop are:
>
> mtu=1500
> netperf -H xxx -l 120
>
> 		w/o patch	w/i patch (two runs)	
> guest to host:  3336.84Mb/s   3730.14Mb/s ~ 3582.88Mb/s
>
> host to guest:  3165.10Mb/s   3370.39Mb/s ~ 3407.96Mb/s
>
> Here is the patch for your review. The same approach can apply to non-mergable
> buffs too, so we can use code in common. If there is no objection, I will
> submit the non-mergable buffs patch later.
>
>
> Signed-off-by: Shirley Ma<xma@us.ibm.com>
> ---
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 2a6e81d..e31ebc9 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -17,6 +17,7 @@
>    * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
>    */
>   //#define DEBUG
> +#include<linux/list.h>
>   #include<linux/netdevice.h>
>   #include<linux/etherdevice.h>
>   #include<linux/ethtool.h>
> @@ -39,6 +40,12 @@ module_param(gso, bool, 0444);
>
>   #define VIRTNET_SEND_COMMAND_SG_MAX    2
>
> +struct page_list
> +{
> +	struct page *page;
> +	struct list_head list;
> +};
>    

This is an inefficient way to store a list of pages.  Each page requires 
an allocation and a cache line.

Alternatives include:
- store the link in the page itself
- have an array of pages per list element instead of just one pointer
- combine the two, store an array of page pointers in one of the free pages
- use the struct page::lru member

The last is the most traditional and easiest so I'd recommend it (though 
it still takes the cacheline hit).

> +static struct page_list *get_a_free_page(struct virtnet_info *vi, gfp_t gfp_mask)
> +{
> +	struct page_list *plist;
> +
> +	if (list_empty(&vi->freed_pages)) {
> +		plist = kmalloc(sizeof(struct page_list), gfp_mask);
> +		if (!plist)
> +			return NULL;
> +		list_add_tail(&plist->list,&vi->freed_pages);
> +		plist->page = alloc_page(gfp_mask);
>    

What if the allocation fails here?

-- 
error compiling committee.c: too many arguments to function

