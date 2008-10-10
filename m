Return-Path: <linux-kernel-owner+w=401wt.eu-S1760178AbYJJOOK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760178AbYJJOOK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 10:14:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757295AbYJJONz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 10:13:55 -0400
Received: from stinky.trash.net ([213.144.137.162]:55420 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757541AbYJJONy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 10:13:54 -0400
Message-ID: <48EF631E.1010601@trash.net>
Date: Fri, 10 Oct 2008 16:13:50 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Nir Tzachar <nir.tzachar@gmail.com>
CC: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: WARNING: at net/ipv4/netfilter/nf_nat_standalone.c:89 nf_nat_fn+0x33/0x155()
References: <9b2db90b0810092324o729e29c0i2e654c812592bbd2@mail.gmail.com> <48EF5DF5.7070708@trash.net> <48EF5E31.1070606@trash.net>
In-Reply-To: <48EF5E31.1070606@trash.net>
Content-Type: multipart/mixed;
 boundary="------------000807010002030009010004"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000807010002030009010004
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Patrick McHardy wrote:
> Patrick McHardy wrote:
>> Nir Tzachar wrote:
>>> Hello.
>>>
>>> The following warning is reproducible with the code below on 2.6.25.6,
>>> which uses sendmsg on a udp socket using two iovecs:
>>>
>>> ....
>>> And I always get  the following warning twice:
>>>
>>> [ 6658.338116] ------------[ cut here ]------------
>>> [ 6658.338121] WARNING: at net/ipv4/netfilter/nf_nat_standalone.c:89
>>> nf_nat_fn+0x33/0x155()
>>
>> Thanks for the report. Does this patch fix it?
> 
> Actually, this can't be it. Let me look again.

Found it - we lost an ifdef during the transition to nf_conntrack
guarding an exception from defragmentation on loopback input.

This patch should fix the warning.

--------------000807010002030009010004
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index 5a955c4..7eb0b61 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -150,10 +150,12 @@ static unsigned int ipv4_conntrack_defrag(unsigned int hooknum,
 					  const struct net_device *out,
 					  int (*okfn)(struct sk_buff *))
 {
+#if !defined(CONFIG_NF_NAT) && !defined(CONFIG_NF_NAT_MODULE)
 	/* Previously seen (loopback)?  Ignore.  Do this before
 	   fragment check. */
 	if (skb->nfct)
 		return NF_ACCEPT;
+#endif
 
 	/* Gather fragments. */
 	if (ip_hdr(skb)->frag_off & htons(IP_MF | IP_OFFSET)) {

--------------000807010002030009010004--
