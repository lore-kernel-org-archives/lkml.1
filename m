Return-Path: <linux-kernel-owner+w=401wt.eu-S1764299AbYBCLlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764299AbYBCLlR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 06:41:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754591AbYBCLlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 06:41:04 -0500
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:27209 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754420AbYBCLlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 06:41:02 -0500
Date: Sun, 3 Feb 2008 12:40:57 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>, herbert@gondor.apana.org.au,
       neilb@suse.de, schwidefsky@de.ibm.com, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: crypto/async_tx/* doesn't build on s390
Message-ID: <20080203114056.GB18211@osiris.ibm.com>
References: <0C7297FA1D2D244A9C7F6959C0BF1E521D1C6C@azsmsx413.amr.corp.intel.com> <20080201123738.24988af7@gondolin.boeblingen.de.ibm.com> <e9c3a7c20802011331j2064afe5vc6228fe8363e15de@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9c3a7c20802011331j2064afe5vc6228fe8363e15de@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2008 at 02:31:28PM -0700, Dan Williams wrote:
> On Feb 1, 2008 4:37 AM, Cornelia Huck <cornelia.huck@de.ibm.com> wrote:
> > On Thu, 31 Jan 2008 12:49:00 -0700,
> > "Williams, Dan J" <dan.j.williams@intel.com> wrote:
> >
> > > I am mistaken, the 'depends on ARCH...' precludes HAS_DMA.  Perhaps the compiler is emitting a call to async_tx_find_channel when it needs to be inline?  On x86 do_async_xor is successfully compiled away when CONFIG_DMA_ENGINE=n.
> >
> > Just checked why it compiled for me on one box but not on the other and
> > found that deactivating CONFIG_SECTION_MISMATCH makes it go away. Hmm...
> >
> 
> Here is what I have come up with as a fix.

The fix works for me. Thanks! However your mailer replaced tabs with spaces
and added an extra line break.

> ---
> async_tx: prevent do_async_xor from compiling on !HAS_DMA archs
> 
> With the addition of -fno-inline in CONFIG_DEBUG_SECTION_MISMATCH
> do_async_xor is no longer compiled away on !HAS_DMA archs like s390.
> Other async_tx calls to the dma-api are already open coded inline.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
> 
>  crypto/async_tx/async_xor.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> 
> diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
> index 2575f67..393f07d 100644
> --- a/crypto/async_tx/async_xor.c
> +++ b/crypto/async_tx/async_xor.c
> @@ -41,6 +41,14 @@ do_async_xor(struct dma_async_tx_descriptor *tx,
> struct dma_device *device,
>         enum dma_data_direction dir;
>         int i;
> 
> +       /* if this function is not inlined we need to prevent
> +        * the rest of the routine from compiling on !HAS_DMA
> +        * archs
> +        */
> +       #ifndef CONFIG_DMA_ENGINE
> +       return;
> +       #endif
> +
>         pr_debug("%s: len: %zu\n", __FUNCTION__, len);
> 
>         dir = (flags & ASYNC_TX_ASSUME_COHERENT) ?
