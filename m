Return-Path: <linux-kernel-owner+w=401wt.eu-S1754684AbZHCJRJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684AbZHCJRJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 05:17:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754528AbZHCJRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 05:17:09 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:48021 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845AbZHCJRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 05:17:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LavY7JlAXeL+DIElNXjWgl1qkDw3ZCW3FRvWnBYemTbE+HgKprZTSOyOZ93cDHy+6N
         9SwEgN9qiphyV/GKT3llHUfGc3BE+yS570DpMmkGbcGGslnht2Kvg94p78UP/q7+WI24
         mz7DiE8i2d81UGmN7nJ3eWzLdAG91Z69Kgb50=
MIME-Version: 1.0
In-Reply-To: <81b0412b0908021409h73fc2fcfo64c4ba9ee1f0d552@mail.gmail.com>
References: <81b0412b0908021339s739c07edvd4d5eb4c21cfa167@mail.gmail.com>
	 <Pine.LNX.4.44L0.0908021650020.14120-100000@netrider.rowland.org>
	 <81b0412b0908021409h73fc2fcfo64c4ba9ee1f0d552@mail.gmail.com>
Date: Mon, 3 Aug 2009 11:17:05 +0200
Message-ID: <81b0412b0908030217o1e687c2ewf0191687a78d6166@mail.gmail.com>
Subject: Re: Oops in CDC ACM after an Openmoko phone (neo1973) changes its usb 
	interface from ACM to Ethernet
From: Alex Riesen <raa.lkml@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oliver@neukum.org>, linux-usb@vger.kernel.org,
       Oliver Neukum <oliver@neukum.name>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <greg@kroah.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 2, 2009 at 23:09, Alex Riesen<raa.lkml@gmail.com> wrote:
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000003
> IP: [<ffffffffa005ce38>] acm_rx_tasklet+0x24e/0x3a3 [cdc_acm]

I tried to look a little around acm_rx_tasklet (cdc-acm.c, -rc5). I
think it is this code:

0000000000001bea <acm_rx_tasklet>:
...
    1e27:	4d 8b 44 24 18       	mov    0x18(%r12),%r8
    1e2c:	89 f8                	mov    %edi,%eax
    1e2e:	c1 f8 0f             	sar    $0xf,%eax
    1e31:	83 e0 0f             	and    $0xf,%eax
    1e34:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
    1e38:	0f b6 42 03          	movzbl 0x3(%rdx),%eax ; I think it crashed here

which is this:

	movq	24(%r12), %r8	# <variable>.base, temp.1149
	movl	%edi, %eax	# D.22806, tmp117
	sarl	$15, %eax	#, tmp117
	andl	$15, %eax	#, tmp119
	movq	(%rdx,%rax,8), %rdx	#, ep
	movzbl	3(%rdx), %eax	# <variable>.desc.bmAttributes,
<variable>.desc.bmAttributes

and correspondingly:

466		ep = (usb_pipein(acm->rx_endpoint) ? acm->dev->ep_in : acm->dev->ep_out)
467				[usb_pipeendpoint(acm->rx_endpoint)];
468		if (usb_endpoint_xfer_int(&ep->desc))

So it looks like ep is NULL (usb_endpoint_xfer_int accesses desc.bmAttributes,
which is 3 bytes off the beginning of struct usb_host_endpoint (desc being the
first field in usb_host_endpoint).

Any help with further debugging is very much appreciated (because
I don't know where to continue yet).
