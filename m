Return-Path: <linux-kernel-owner+w=401wt.eu-S1760879AbYJIT0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760879AbYJIT0r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 15:26:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755344AbYJIT0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 15:26:37 -0400
Received: from wr-out-0506.google.com ([64.233.184.239]:19382 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759456AbYJIT0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 15:26:34 -0400
Message-ID: <48EE5AE1.5030002@codemonkey.ws>
Date: Thu, 09 Oct 2008 14:26:25 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
Newsgroups: gmane.linux.network,gmane.linux.kernel,gmane.linux.kernel.virtualization
To: Mark McLoughlin <markmc@redhat.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] virtio_net: Improve the recv buffer allocation  
 scheme
References: <1223494499-18732-1-git-send-email-markmc@redhat.com>	 <1223494499-18732-2-git-send-email-markmc@redhat.com>	 <200810091155.59731.rusty@rustcorp.com.au>	 <20081009153035.GA21542@gondor.apana.org.au> <1223574013.13792.23.camel@blaa>
In-Reply-To: <1223574013.13792.23.camel@blaa>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark McLoughlin wrote:
> 
> Also, including virtio_net_hdr in the data buffer would need another
> feature flag. Rightly or wrongly, KVM's implementation requires
> virtio_net_hdr to be the first buffer:
> 
>     if (elem.in_num < 1 || elem.in_sg[0].iov_len != sizeof(*hdr)) {
>         fprintf(stderr, "virtio-net header not in first element\n");
>         exit(1);
>     }
> 
> i.e. it's part of the ABI ... at least as KVM sees it :-)

This is actually something that's broken in a nasty way.  Having the 
header in the first element is not supposed to be part of the ABI but it 
sort of has to be ATM.

If an older version of QEMU were to use a newer kernel, and the newer 
kernel had a larger header size, then if we just made the header be the 
first X bytes, QEMU has no way of knowing how many bytes that should be. 
  Instead, the guest actually has to allocate the virtio-net header in 
such a way that it only presents the size depending on the features that 
the host supports.  We don't use a simple versioning scheme, so you'd 
have to check for a combination of features advertised by the host but 
that's not good enough because the host may disable certain features.

Perhaps the header size is whatever the longest element that has been 
commonly negotiated?

So that's why this aggressive check is here.  Not to necessarily cement 
this into the ABI but as a way to make someone figure out how to 
sanitize this all.

Regards,

Anthony Liguori
