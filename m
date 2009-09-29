Return-Path: <linux-kernel-owner+w=401wt.eu-S1752758AbZI2PHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758AbZI2PHb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 11:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbZI2PHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 11:07:30 -0400
Received: from smtp-out.google.com ([216.239.45.13]:49696 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbZI2PH3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 11:07:29 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	content-type:content-transfer-encoding:x-system-of-record;
	b=QP53v0be5++0rCuzeskaXU2yGDGhFBHxvVWm1p2EFueZptvsFFkePBhpP37jAz5ww
	Gt7QLr9EB6Rm+oxkFzWbA==
MIME-Version: 1.0
In-Reply-To: <20090929145156.GB19797@verge.net.au>
References: <20090929123501.13798.84004.stgit@jazzy.zrh.corp.google.com>
	 <20090929145156.GB19797@verge.net.au>
Date: Tue, 29 Sep 2009 17:07:24 +0200
Message-ID: <b5ddba180909290807j4d1d1d2dl48af9453542612ff@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] IPVS full NAT support + netfilter 'ipvs' match 
	support
From: Hannes Eder <heder@google.com>
To: Hannes Eder <heder@google.com>, lvs-devel@vger.kernel.org,
       Wensong Zhang <wensong@linux-vs.org>,
       Julius Volz <julius.volz@gmail.com>, lvs-users@linuxvirtualserver.org,
       Laurent Grawet <laurent.grawet@uclouvain.be>,
       Jean-Luc Fortemaison <jl.fortemaison@uclouvain.be>,
       linux-kernel@vger.kernel.org, Jan Engelhardt <jengelh@medozas.de>,
       Julian Anastasov <ja@ssi.bg>, netfilter-devel@vger.kernel.org,
       netdev@vger.kernel.org,
       =?ISO-8859-1?Q?Fabien_Duch=EAne?= <mad_fab@skynet.be>,
       Joseph Mack NA3T <jmack@wm7d.net>, Patrick McHardy <kaber@trash.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 29, 2009 at 16:51, Simon Horman <horms@verge.net.au> wrote:
> On Tue, Sep 29, 2009 at 02:35:15PM +0200, Hannes Eder wrote:
>> The following series implements full NAT support for IPVS.  The
>> approach is via a minimal change to IPVS (make friends with
>> nf_conntrack) and adding a netfilter matcher, kernel- and user-space
>> part, i.e. xt_ipvs and libxt_ipvs.
>
> Its a bit late in the day for me to review the code, but I have a few
> quick comments.
>
>>
>> Example usage:
>>
>> % ipvsadm -A -t 192.168.100.30:80 -s rr
>> % ipvsadm -a -t 192.168.100.30:80 -r 192.168.10.20:80 -m
>> # ...
>>
>> # Source NAT for VIP 192.168.100.30:80
>> % iptables -t nat -A POSTROUTING -m ipvs --vaddr 192.168.100.30/32 \
>> > --vport 80 -j SNAT --to-source 192.168.10.10
>>
>> or SNAT-ing only a specific real server:
>>
>> % iptables -t nat -A POSTROUTING --dst 192.168.11.20 \
>> > -m ipvs --vaddr 192.168.100.30/32 -j SNAT --to-source 192.168.10.10
>
> If the iptables rule is not in place does LVS just use
> its old NAT behaviour?

Yes, without iptables rules LVS NAT does DNAT.

>> First of all, thanks for all the feedback.  This is the changelog for v2:
>>
>> - Make ip_vs_ftp work again.  Setup nf_conntrack expectations for
>>   related data connections (based on Julian's patch see
>>   http://www.ssi.bg/~ja/nfct/) and let nf_conntrack/nf_nat do the
>>   packet mangling and the TCP sequence adjusting.
>>
>>   This change rises the question how to deal with ip_vs_sync?  Does it
>>   work together with conntrackd?  Wild idea: what about getting rid of
>>   ip_vs_sync and piggy packing all on nf_conntrack and use conntrackd?
>>
>>   Any comments on this?
>
>    That sounds like a reasonable suggestion.
>
>    I think that ip_vs_sync came along before conntrackd
>    and no one has given much thought to merging the functionality.

Okay, I'll dig further in this direction.

Cheers,
-Hannes
