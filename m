Return-Path: <linux-kernel-owner+w=401wt.eu-S1757185AbZBRVG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757185AbZBRVG4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 16:06:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752814AbZBRVGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 16:06:41 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:48203 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbZBRVGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 16:06:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Kk08N3SmLUmL4pM1L7jktUayWHo7mTg3A6ziddFoI46ClSi/FO5izWazMPXcaklyS+
         BStthxZPH+XT5swLzfp0/IYuXwxLx/4+QgOGruDPI0R+rClhkhuVHsoP+mKbpWK7MAiY
         3F7L2nYk38coC/jnqBDoiUbLaou6f9VKZFKTY=
Date: Wed, 18 Feb 2009 22:05:07 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Karl Hiramoto <karl@hiramoto.org>
Cc: netdev@vger.kernel.org, netfilter@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: problem with IPoA (CLIP),  NAT, and VLANS
Message-ID: <20090218210507.GA2698@ami.dom.local>
References: <20090217231255.GA3389@ami.dom.local> <499C49CD.3000709@hiramoto.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <499C49CD.3000709@hiramoto.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 18, 2009 at 06:47:57PM +0100, Karl Hiramoto wrote:
...
> Thanks for the replies.  Jarek, the last debugging patch you sent did
> not work.  It did give me a good hint though.  The attached patch in for
> AF_PACKET   receive in the when tcpdump is active and which calls
> skb_clone() did fix my issue.

Yes, good point!

> CONFIG_IXP400_ETH_SKB_RECYCLE does not exist in the code i have..  From
> what i downloaded from intel,  i stripped out all the stuff that is not
> having to do with ATM.  The functionalities of ixp4xx_qmgr ixp4xx_npe
> and ixp4xx_eth  are now in the mainline kernel.    Ideally it would be
> nice to get what this library does with the atm hardware into the
> mainline, however the code in it's current state would not meet kernel
> standards, and is quite a mess.
> 
> 
> But yes,  the skb->data is   recycled  in a memory pool,   and i think i
> noticed a few times packets that were corrupt, were really pointing to
> old recycled packets.   I haven't confirmed this yet though.
> 
> 
> I did eliminate the first  patch i sent 
> http://lkml.org/lkml/2009/2/16/163    to  __vlan_put_tag()
> 
> And now only use the patch Jarek sent:  http://lkml.org/lkml/2009/2/17/104

Yes, this patch looks like formally needed, but I guess currently it
isn't used by any path: otherwise we would know about it earlier.

> 
> Now i don't have any problems with the vlan tags after changing my atm
> driver to do skb_reserve() like:
> 
> skb = dev_alloc_skb(size + NET_SKB_PAD);
> 
> skb_reserve(skb, NET_SKB_PAD);
> 
> 
> So something with my driver causes skb_clone() to corrupt the packet
> but  calling skb_copy() instead  keeps everything working.   There are
> definitely other cases where skb_clone() is called so really have to fix
> this in the atm_dev, but not really sure at the moment where to look next.

Alas I've been mostly interested in verifying your first suspicion of
skb_cow_head() bug, and not so much in this driver ;-) IMHO after your
current findings the driver definitely looks like the main sinner. I'm
glad you found these hacks to make it workable, but I hope you realize
your data could be still corrupted in more or less visible way.

I looked only a bit into ixp400_eth.c without tracking libraries and
there are some rather strange things I didn't found in other drivers
like skb->truesize use. It looks like both skb and skb->header could
be used together for this recycling without respect for clones. If
so, this could still break in many places e.g.: if it affected you in
__vlan_put_tag() it seems this dev_queue_xmit_nit() could hit you too,
depending on your config or even size of packets. So I guess, knowing
this all, you should better try to hack this driver more yet.

Cheers,
Jarek P.
