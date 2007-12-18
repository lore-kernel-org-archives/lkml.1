Return-Path: <linux-kernel-owner+w=401wt.eu-S1754091AbXLRVAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091AbXLRVAa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 16:00:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753003AbXLRVAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 16:00:22 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:52264 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624AbXLRVAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 16:00:21 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <476834AC.9050401@s5r6.in-berlin.de>
Date: Tue, 18 Dec 2007 21:59:24 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071216 SeaMonkey/1.1.7
MIME-Version: 1.0
To: akepner@sgi.com
CC: Andrew Morton <akpm@linux-foundation.org>, grundler@parisc-linux.org,
       jbarnes@virtuousgeek.org, jes@sgi.com, randy.dunlap@oracle.com,
       rdreier@cisco.com, James.Bottomley@steeleye.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] dma: passing "attributes" to dma_map_* routines
References: <20071218001758.GO21916@sgi.com> <4767FA62.9060002@s5r6.in-berlin.de> <20071218200759.GE412@sgi.com>
In-Reply-To: <20071218200759.GE412@sgi.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

akepner@sgi.com wrote:
> Reorderings are possible on reads and
> writes. Things get synced up by either an interrupt or a write to
> a memory region with a "barrier attribute". Memory allocated with
> dma_alloc_coherent() gets the barrier attribute. The idea here is
> to allow memory allocated with plain old malloc() or whatever to
> get the same attribute.

>From its purpose it sounds like you need this only for few special
memory regions which would typically be mapped by dma_map_single() and
furthermore that drivers who need this behavior will be changed to
explicitly demand it.  If so, a nonintrusive API extension could simply
be to add an

dma_addr_t dma_map_single_write_last(struct device *dev, void *ptr,
size_t size, enum dma_data_direction direction);

or however you'd like to call it.  (DMA-maps a memory area for which it
is guaranteed that of all DMA writes pending at any time, a DMA
reordering interconnect --- if such an interconnect is present --- will
perform DMAs to other areas first and to this area last.  On machines
which don't reorder DMAs, this function is the same as dma_map_single().)

However, your older patch series looks like you want this behavior also
in areas which are mapped by dma_map_sg(), do you?.  Still, adding two
functions of the kind like above, if necessary, might still be
preferable to changing the call parameters of existing functions or to
overloading enum dma_data_direction.

So that would be option 3) of yours, though without your attrs
parameter.  Do you expect the need for even more flags for other kinds
of special behavior?
-- 
Stefan Richter
-=====-=-=== ==-- =--=-
http://arcgraph.de/sr/
