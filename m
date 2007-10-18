Return-Path: <linux-kernel-owner+w=401wt.eu-S1763557AbXJRAel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763557AbXJRAel (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 20:34:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760912AbXJRAed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 20:34:33 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33525 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760208AbXJRAec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 20:34:32 -0400
Date: Wed, 17 Oct 2007 17:34:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Shannon Nelson <shannon.nelson@intel.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       shannon.nelson@intel.com, dan.j.williams@intel.com,
       randy.dunlap@oracle.com
Subject: Re: [PATCH 4/5] I/OAT: Tighten descriptor setup performance
Message-Id: <20071017173421.2995d0b9.akpm@linux-foundation.org>
In-Reply-To: <20071018001433.31147.43339.stgit@localhost.localdomain>
References: <20071018001416.31147.86176.stgit@localhost.localdomain>
	<20071018001433.31147.43339.stgit@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Oct 2007 17:14:33 -0700
Shannon Nelson <shannon.nelson@intel.com> wrote:

> The change to the async_tx interface cost this driver some performance by
> spreading the descriptor setup across several functions, including multiple
> passes over the new descriptor chain.  Here we bring the work back into one
> primary function and only do one pass.
> 
> Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
> ---
> 
>  drivers/dma/ioat_dma.c |  170 +++++++++++++++++++++++++-----------------------
>  drivers/dma/ioatdma.h  |    6 +-
>  2 files changed, 93 insertions(+), 83 deletions(-)
> 
> diff --git a/drivers/dma/ioat_dma.c b/drivers/dma/ioat_dma.c
> index c44f551..117ac38 100644
> --- a/drivers/dma/ioat_dma.c
> +++ b/drivers/dma/ioat_dma.c
> @@ -46,9 +46,12 @@
>  /* internal functions */
>  static void ioat_dma_start_null_desc(struct ioat_dma_chan *ioat_chan);
>  static void ioat_dma_memcpy_cleanup(struct ioat_dma_chan *ioat_chan);
> +static inline struct ioat_desc_sw *ioat_dma_get_next_descriptor(
> +					      struct ioat_dma_chan *ioat_chan);

A forward-declared static inline is pretty weird.  Does gcc actually do the
right thing with it?

This function is far too large to be inlined anyway.


