Return-Path: <linux-kernel-owner+w=401wt.eu-S933131AbXBMCQK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933131AbXBMCQK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 21:16:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933132AbXBMCQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 21:16:10 -0500
Received: from ozlabs.org ([203.10.76.45]:47493 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933131AbXBMCQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 21:16:08 -0500
Subject: Re: [PATCH 5/8] lguest: trivial guest network driver
From: Rusty Russell <rusty@rustcorp.com.au>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.osdl.org>,
       jgarzik <jgarzik@pobox.com>
In-Reply-To: <20070212155553.GA15627@gondor.apana.org.au>
References: <1171251406.10409.13.camel@localhost.localdomain>
	 <1171251471.10409.15.camel@localhost.localdomain>
	 <1171251578.10409.17.camel@localhost.localdomain>
	 <1171251698.10409.20.camel@localhost.localdomain>
	 <1171251770.10409.23.camel@localhost.localdomain>
	 <1171251894.10409.26.camel@localhost.localdomain>
	 <1171251965.10409.28.camel@localhost.localdomain>
	 <1171252113.10409.30.camel@localhost.localdomain>
	 <1171252219.10409.33.camel@localhost.localdomain>
	 <1171252321.10409.36.camel@localhost.localdomain>
	 <20070212155553.GA15627@gondor.apana.org.au>
Content-Type: text/plain
Date: Tue, 13 Feb 2007 13:15:18 +1100
Message-Id: <1171332919.19842.74.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-13 at 02:55 +1100, Herbert Xu wrote:
> On Mon, Feb 12, 2007 at 02:52:01PM +1100, Rusty Russell wrote:
> >
> > +static void skb_to_dma(const struct sk_buff *skb, unsigned int len,
> > +		       struct lguest_dma *dma)
> > +{
> > +	unsigned int i, seg;
> > +
> > +	for (i = seg = 0; i < len; seg++, i += rest_of_page(skb->data + i)) {
> 
> The length field from the skb covers the fragmented parts as well.
> So you don't want to use it as the boundary for the loop over the
> skb header data.  As it is, if the skb has fragments, the first
> loop will try to read them off the header.

Good spotting!  This function needs to be passed skb_headlen(skb),
rather than skb->len.  Patch is below (I renamed the parameter as well,
for clarity).

It's fascinating why this "worked".  Firstly, for inter-guest
communication, I am not calculating checksums, nor checking them.
Secondly, for guest->host, I turn off hw checksumming so the kernel
disables SG and this code is never executed.  Thirdly, for virtbench's
inter-guest sendfile test does not check the data received is actually
correct.  Finally, while we end up producing a packet which is larger
than skb->len of 1514, the DMA receive buffer for the other guest is
only 1514 bytes, so the result of the transfer is 1514 (==skb->len), so
no error reported by the driver.

==
lguest network driver fix: handle scatter-gather packets correctly

Thanks to Herbert Xu for noticing the bug: "len" here is skb_headlen(),
not skb->len.  Renamed the function to clarify, too.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r ed6484d145a4 drivers/net/lguest_net.c
--- a/drivers/net/lguest_net.c	Tue Feb 13 11:30:39 2007 +1100
+++ b/drivers/net/lguest_net.c	Tue Feb 13 12:07:15 2007 +1100
@@ -59,14 +59,14 @@ static unsigned long peer_addr(struct lg
 	return info->peer_phys + 4 * peernum;
 }
 
-static void skb_to_dma(const struct sk_buff *skb, unsigned int len,
+static void skb_to_dma(const struct sk_buff *skb, unsigned int headlen,
 		       struct lguest_dma *dma)
 {
 	unsigned int i, seg;
 
-	for (i = seg = 0; i < len; seg++, i += rest_of_page(skb->data + i)) {
+	for (i = seg = 0; i < headlen; seg++, i += rest_of_page(skb->data+i)) {
 		dma->addr[seg] = virt_to_phys(skb->data + i);
-		dma->len[seg] = min((unsigned)(len - i),
+		dma->len[seg] = min((unsigned)(headlen - i),
 				    rest_of_page(skb->data + i));
 	}
 	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++, seg++) {
@@ -90,7 +90,7 @@ static void transfer_packet(struct net_d
 	struct lguestnet_info *info = dev->priv;
 	struct lguest_dma dma;
 
-	skb_to_dma(skb, skb->len, &dma);
+	skb_to_dma(skb, skb_headlen(skb), &dma);
 	pr_debug("xfer length %04x (%u)\n", htons(skb->len), skb->len);
 
 	hcall(LHCALL_SEND_DMA, peer_addr(info,peernum), __pa(&dma),0);


