Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933411Ab0CLXFt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 18:05:49 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:6080 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932279Ab0CLXFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 18:05:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=I7HM/5IiIMMvZILf43Mw+jlaY1Lozr2jvisADyZQk+8webCkYMzXMDRAKIeMnVMCkA
         ET1iHkEKIPi7lAP+WKLncUKaDMOpsdxq+dc0flQPMZM1G/1/TQtJifAlW5Q5GeJA1MFw
         OyfcIvLdfrq/romI/79PVlateo50qRNteP2yI=
Message-ID: <4B9AC8C5.2010300@gmail.com>
Date: Fri, 12 Mar 2010 18:05:41 -0500
From: William Allen Simpson <william.allen.simpson@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       David Miller <davem@davemloft.net>, Michael Chan <mchan@broadcom.com>,
       Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH v4 2/7] net: remove old tcp_optlen function
References: <4B98D592.6040301@gmail.com> <4B98D9A2.8060603@gmail.com> <4B9A40BC.4030301@gmail.com> <20100312174656.GA12175@bicker>
In-Reply-To: <20100312174656.GA12175@bicker>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the drama is beside the point.  This patch merely removes a *rarely*
used function (2 drivers).  Not complicated....

There's a reason that this function isn't used much.  It doesn't work.


On 3/12/10 12:46 PM, Dan Carpenter wrote:
> So after you removed the checks this change includes:

I didn't remove any *existing* checks.  I had added *new* checks in my
earlier patch, then removed *my* checks from this patch as required by
David Miller.


> 1) Random slagging on the networking guys

I had to look up that "random slagging on" colloquialism.  Apparently,
the "random slagging" target would be *me* -- calling me "anal" and my
code "rediculious bloat" [sic] probably qualifies....

(Admittedly, I'm rather careful and may be overly cautious at times, after
some 30+ years of writing network drivers.  Once it's in half a billion
cell phones, it's hard/impossible to update.)

Since my first unpleasant interactions with David Miller on my very
earliest (October) netdev posts, I've conspicuously avoided contradicting
him.  I've merely *obeyed* his injunction here, and moved on....

The patch itself neutrally documents a coding requirement decision by that
networking maintainer by name.


> 2) u32 =>  int to ameliorate your static checker's complaints

Good idea.  Actually, I simply looked at the code and its history.


> 3) cleanups
>
Removing this function is really a *bug* fix (in several places), with
cleanups in the vicinity for obviously poor coding (variants in 3 places):

-	mss = 0;
-	if ((mss = skb_shinfo(skb)->gso_size) != 0) {
-		int tcp_opt_len, ip_tcp_len;

Cleaner as:

+	mss = skb_shinfo(skb)->gso_size;
+	if (mss != 0) {
+		struct tcphdr *th;

But I wouldn't have bothered had I not been changing that immediately
following line.  30+ years of experience with collaborative projects
informs me that it's best to make minor cleanups only where I'm already
improving the code nearby.  Otherwise, it creates patch conflicts.


> People have already explained that tcp_optlen() doesn't return
> negative values.

People?  The fact that the calculation itself can be negative appeared
the very first time I tested my own code using this bad function!


> negative values.  It would really help us if you could show how
> tcp_hdr(skb)->doff can be less than 5?
>
Oh, I've long since given up on lengthy explanations.  Both Eric and
Ilpo have repeatedly castigated me for being too wordy.

In this particular instance, I suggest that you take a look at all the
places that gso_size is set, and cross index with all the code paths that
place these TCP headers onto the txq without a check of doff -- as I did!

I'll specifically mention the tun and virtio_net devices, but I'm also
particularly concerned with af_packet.c and skbuff.c -- and the general
problem with inet_lro.c, too.

Amazingly enough, folks sometimes use Linux for routers....
