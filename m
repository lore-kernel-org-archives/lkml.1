Return-Path: <linux-kernel-owner+w=401wt.eu-S1754093AbYHLREq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbYHLREq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 13:04:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbYHLREj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 13:04:39 -0400
Received: from smtp-out.google.com ([216.239.33.17]:53642 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029AbYHLREi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 13:04:38 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=Iuja7LsD93bafFRCsjI3KFKAPbsrNrTvQq0u6NPkA5Oq2NXfoUy6NVYtjUX6uHuCV
	Jo74jeterm8MPcbJzDSeA==
Message-ID: <da824cf30808121004w1ea59dc9rd805e2ae4d9f47a7@mail.gmail.com>
Date: Tue, 12 Aug 2008 10:04:14 -0700
From: "Grant Grundler" <grundler@google.com>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] ieee1394: sbp2: enforce s/g segment size limit
Cc: linux1394-devel@lists.sourceforge.net,
       "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.8f7aa8cea95d423b@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <489CB8D8.60908@s5r6.in-berlin.de>
	 <20080809063159F.fujita.tomonori@lab.ntt.co.jp>
	 <489CC17F.7000208@s5r6.in-berlin.de>
	 <20080809071744I.fujita.tomonori@lab.ntt.co.jp>
	 <tkrat.8f7aa8cea95d423b@s5r6.in-berlin.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 9, 2008 at 11:20 AM, Stefan Richter
<stefanr@s5r6.in-berlin.de> wrote:
> 1. We don't need to round the SBP-2 segment size limit down to a
>   multiple of 4 kB (0xffff -> 0xf000).  It is only necessary to
>   ensure quadlet alignment (0xffff -> 0xfffc).
>
> 2. Use dma_set_max_seg_size() to tell the DMA mapping infrastructure
>   and the block IO layer about the restriction.  This way we can
>   remove the size checks and segment splitting in the queuecommand
>   path.
>
>   This assumes that no other code in the ieee1394 stack uses
>   dma_map_sg() with conflicting requirements.  It furthermore assumes
>   that the controller device's platform actually allows us to set the
>   segment size to our liking.  Assert the latter with a BUG_ON().
>
> 3. Also use blk_queue_max_segment_size() to tell the block IO layer
>   about it.  It cannot know it because our scsi_add_host() does not
>   point to the FireWire controller's device.
>
> We can also uniformly use dma_map_sg() for the single segment case just
> like for the multi segment case, to further simplify the code.
>
> Also clean up how the page table is converted to big endian.
>
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> ---
>
> Applicable after
>   [PATCH update] ieee1394: sbp2: stricter dma_sync
>   [PATCH] ieee1394: sbp2: check for DMA mapping failures
> from a few minutes ago.
>
>  drivers/ieee1394/sbp2.c |  106 +++++++++++++---------------------------
>  drivers/ieee1394/sbp2.h |   37 +++++--------
>  2 files changed, 52 insertions(+), 91 deletions(-)
...
> +               for_each_sg(sg, sg, sg_count, i) {
> +                       len = sg_dma_len(sg);
> +                       if (len == 0)
> +                               continue;
>
> -               orb->misc |= ORB_SET_DATA_SIZE(sg_count);
> +                       pt[j].high = cpu_to_be32(len << 16);
> +                       pt[j].low = cpu_to_be32(sg_dma_address(sg));
> +                       j++;
> +               }

While this code will probably work correctly, I believe if the
sg_dma_len() returns 0, one has walked off the end of the
"bus address" list.

pci_map_sg() returns how many DMA addr/len pairs are used
and that count could (should?) be used when pulling the
dma_len/addr pairs out of the sg list.

Effectively, the SG list is really two lists with seperate counts:
the original list with virtual addresses/len/count and the "DMA mapped"
list with it's own count of addresses/len pairs. When no IOMMU
is used those lists are 1:1.

hth,
grant

> -               sbp2util_cpu_to_be32_buffer(sg_element,
> -                               (sizeof(struct sbp2_unrestricted_page_table)) *
> -                               sg_count);
> +               orb->misc |= ORB_SET_PAGE_TABLE_PRESENT(0x1) |
> +                            ORB_SET_DATA_SIZE(j);
> +               orb->data_descriptor_lo = cmd->sge_dma;
>
>                dma_sync_single_for_device(dmadev, cmd->sge_dma,
>                                           sizeof(cmd->scatter_gather_element),
> @@ -2037,6 +2003,8 @@ static int sbp2scsi_slave_configure(stru
>                sdev->start_stop_pwr_cond = 1;
>        if (lu->workarounds & SBP2_WORKAROUND_128K_MAX_TRANS)
>                blk_queue_max_sectors(sdev->request_queue, 128 * 1024 / 512);
> +
> +       blk_queue_max_segment_size(sdev->request_queue, SBP2_MAX_SEG_SIZE);
>        return 0;
>  }
>
>
> --
> Stefan Richter
> -=====-==--- =--- -=--=
> http://arcgraph.de/sr/
>
>
