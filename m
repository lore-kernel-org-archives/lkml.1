Return-Path: <linux-kernel-owner+w=401wt.eu-S1752057AbXBFNM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057AbXBFNM5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 08:12:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752053AbXBFNM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 08:12:57 -0500
Received: from mail2.domainserver.de ([213.83.41.143]:3999 "EHLO
	smtp.domainserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbXBFNM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 08:12:56 -0500
X-Greylist: delayed 1030 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Feb 2007 08:12:55 EST
Envelope-to: linux-kernel@vger.kernel.org
Delivery-date: Tue, 06 Feb 2007 14:12:56 +0100
From: Daniel Kabs <daniel.kabs@mobotix.com>
Organization: MOBOTIX AG
To: David Miller <davem@davemloft.net>
Subject: Re: Problem with unix sockets: SOCK_DGRAM ignores MSG_TRUNC
Date: Tue, 6 Feb 2007 13:55:39 +0100
User-Agent: KMail/1.7.2
Cc: linux-kernel@vger.kernel.org
References: <200701291259.50155.dkabs@mobotix.com> <20070204.165235.26305735.davem@davemloft.net>
In-Reply-To: <20070204.165235.26305735.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702061355.39660.daniel.kabs@mobotix.com>
X-AUTH: - 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 February 2007 01:52, David Miller wrote:
> > Thus I used recv() with flags MSG_TRUNC|MSG_PEEK in order to detect
> > message truncation due to insufficient buffer size.
>
> What part of "Only valid for packet sockets" from the manual page
> escapes you?  :-))
> It's a feature which only was meant to be valid for AF_PACKET sockets.

Thanks for pointing that out. I thought, "packet sockets" means  
"datagram-oriented  socket". Obviously it means PF_PACKET instead. It's 
hard to learn programming IPC by only reading man pages :-)

> What UDP is doing is different, it's returning the full packet length
> when the packet is larger then the given buffer size, but it does this
> irregardless of whether you set MSG_TRUNC in the recvmsg() passed-in
> flags.  UDP itself sets the MSG_TRUNC flag when it detects this
> situation.

Please correct me gently if I am wrong: According to the kernel source 
code, this behaviour was introduced with patch-2.6.8: 

http://www.kernel.org/diff/diffview.cgi?file=/pub/linux/kernel/v2.6/patch-2.6.8.gz;z=4325

linux/net/ipv4/udp.c 
+
         err = copied;
+        if (flags & MSG_TRUNC)
+          err = skb->len - sizeof(struct udphdr);

I think local sockets (PF_UNIX) implement a different semantics: According 
to unix_dgram_recvmsg() in linux/net/unix/af_unix.c, in case of 
truncation the buffer size is returned and not the full packet length.

In my opinion this implementation of local sockets (PF_UNIX) is not 
following the wording of the man page man 2 recv: "These  calls  return  
the  number of bytes received". Am I getting something wrong here?

Why not improve consistency and make unix_dgram_recvmsg() return the full 
packet length? So it would behave as UDP does. What do you think about 
adding the following code to linux/net/unix/af_unix.c:
        err = size;
+        if (flags & MSG_TRUNC)
+                err = skb->len;


Cheers
Daniel
