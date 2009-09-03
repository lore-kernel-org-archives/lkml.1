Return-Path: <linux-kernel-owner+w=401wt.eu-S1754894AbZICKXB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894AbZICKXB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 06:23:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754854AbZICKXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 06:23:00 -0400
Received: from smtp-out.google.com ([216.239.45.13]:6820 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754841AbZICKW7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 06:22:59 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=XziCw75odHhb93YHl8Xw7rM/lWGkZ6jS+wn5qsAK1zHTArec6jqIkxmS7Fi2gtoC9
	SKk+39LugEHlCQa8r+ztA==
MIME-Version: 1.0
In-Reply-To: <4A9E8788.1090901@trash.net>
References: <20090902101417.11561.45663.stgit@jazzy.zrh.corp.google.com>
	 <20090902101538.11561.11911.stgit@jazzy.zrh.corp.google.com>
	 <4A9E8788.1090901@trash.net>
Date: Thu, 3 Sep 2009 12:22:53 +0200
Message-ID: <b5ddba180909030322h42aa9337o4c20696b86029b71@mail.gmail.com>
Subject: Re: [PATCH 2/3] IPVS: make friends with nf_conntrack
From: Hannes Eder <heder@google.com>
To: Patrick McHardy <kaber@trash.net>
Cc: lvs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
       =?ISO-8859-1?Q?Fabien_Duch=EAne?= <mad_fab@skynet.be>,
       Jan Engelhardt <jengelh@medozas.de>,
       Jean-Luc Fortemaison <jl.fortemaison@uclouvain.be>,
       Julian Anastasov <ja@ssi.bg>, Julius Volz <julius.volz@gmail.com>,
       Laurent Grawet <laurent.grawet@uclouvain.be>,
       Simon Horman <horms@verge.net.au>, Wensong Zhang <wensong@linux-vs.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 2, 2009 at 16:56, Patrick McHardy<kaber@trash.net> wrote:
> Hannes Eder wrote:
>> Update the nf_conntrack tuple in reply direction, as we will see
>> traffic from the real server (RIP) to the client (CIP).  Once this is
>> done we can use netfilters SNAT in POSTROUTING, especially with
>> xt_ipvs, to do source NAT, e.g.:
>>
>> % iptables -t nat -A POSTROUTING -m ipvs --vaddr 192.168.100.30/32 --vport 8080 \
>>> -j SNAT --to-source 192.168.10.10
>>
>
>> +static void
>> +ip_vs_update_conntrack(struct sk_buff *skb, struct ip_vs_conn *cp)
>> +{
>> +     struct nf_conn *ct = (struct nf_conn *)skb->nfct;
>> +
>> +     if (ct == NULL || ct == &nf_conntrack_untracked ||
>> +         nf_ct_is_confirmed(ct))
>> +             return;
>> +
>> +     /*
>> +      * The connection is not yet in the hashtable, so we update it.
>> +      * CIP->VIP will remain the same, so leave the tuple in
>> +      * IP_CT_DIR_ORIGINAL untouched.  When the reply comes back from the
>> +      * real-server we will see RIP->DIP.
>> +      */
>> +     ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.u3 = cp->daddr;
>> +     /*
>> +      * This will also take care of UDP and other protocols.
>> +      */
>> +     ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.u.tcp.port = cp->dport;
>> +}
>
> How does IPVS interact with conntrack helpers? If it does actually
> intend to use them (which will happen automatically), it might make
> sense to use nf_conntrack_alter_reply(), which will perform a new
> helper lookup based on the changed tuple.

Good point, I'll use nf_conntrack_alter_reply().  IHMO IPVS only deals
with ftp in a special way, I think something need to be done there as
well, I'll investigate that.
