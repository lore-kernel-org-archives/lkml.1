Return-Path: <linux-kernel-owner+w=401wt.eu-S1754800AbZIRAPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800AbZIRAPI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 20:15:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754286AbZIRAPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 20:15:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39648 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754738AbZIRAPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 20:15:04 -0400
Date: Thu, 17 Sep 2009 17:15:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: JBeulich@novell.com, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org
Subject: Re: [PATCH] fix BUILD_BUG_ON() and a couple of bogus uses of it
Message-Id: <20090917171504.649ba29b.akpm@linux-foundation.org>
In-Reply-To: <20090917.170156.152594715.davem@davemloft.net>
References: <4A8AEBFD0200007800010580@vpn.id2.novell.com>
	<20090917162437.b1a890de.akpm@linux-foundation.org>
	<20090917.170156.152594715.davem@davemloft.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Sep 2009 17:01:56 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Andrew Morton <akpm@linux-foundation.org>
> Date: Thu, 17 Sep 2009 16:24:37 -0700
> 
> > sparc64:
> > 
> > In file included from arch/sparc/kernel/vio.c:17:
> > /usr/src/devel/arch/sparc/include/asm/vio.h: In function `vio_dring_avail':
> > /usr/src/devel/arch/sparc/include/asm/vio.h:261: error: bit-field `<anonymous>' width not an integer constant
> > 
> > static inline u32 vio_dring_avail(struct vio_dring_state *dr,
> > 				  unsigned int ring_size)
> > {
> > 	BUILD_BUG_ON(!is_power_of_2(ring_size));
> > 
> > 	return (dr->pending -
> > 		((dr->prod - dr->cons) & (ring_size - 1)));
> > }
> > 
> > changing it to MAYBE_BUILD_BUG_ON seems to have fixed it.
> 
> That's completely bogus.
> 
> First of all, arch/sparc/kernel/vio.c never calls this function
> so it should never be evaluated.
> 
> Second of all, all the places that do call this function only
> pass pure constants as the 'ring_size' parameter.
> 
> drivers/block/sunvdc.c:
> 
> static inline u32 vdc_tx_dring_avail(struct vio_dring_state *dr)
> {
> 	return vio_dring_avail(dr, VDC_TX_RING_SIZE);
> }
> 
> drivers/net/sunvnet.c:
> 
> static inline u32 vnet_tx_dring_avail(struct vio_dring_state *dr)
> {
> 	return vio_dring_avail(dr, VNET_TX_RING_SIZE);
> }
> 
> Making this MAYBE_BUILD_BUG_ON shouldn't be necessary.

There's a shortcoming in the current BUILD_BUG_ON() - it silently does
nothing if passed a non-constant arg.

I suspect that in the 2.6.31 code, that BUILD_BUG_ON() just does
nothing at all, and that Jan's patch is now exposing this.  It might be
compiler-version dependent too.


<tests it>

Yup, on base 2.6.31, this:

--- a/arch/sparc/kernel/vio.c~a
+++ a/arch/sparc/kernel/vio.c
@@ -23,6 +23,8 @@ static const struct vio_device_id *vio_m
 	const char *type, *compat;
 	int len;
 
+	vio_dring_avail(NULL, 33);
+
 	type = dev->type;
 	compat = dev->compat;
 	len = dev->compat_len;
_

compiles without error with gcc-3.4.5.
