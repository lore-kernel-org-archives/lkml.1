Return-Path: <linux-kernel-owner+w=401wt.eu-S1754178AbZIALfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178AbZIALfT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 07:35:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754143AbZIALfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 07:35:18 -0400
Received: from cantor.suse.de ([195.135.220.2]:35219 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754117AbZIALfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 07:35:17 -0400
Date: Tue, 1 Sep 2009 13:35:18 +0200
From: Jiri Bohac <jbohac@suse.cz>
To: "Yu, Fenghua" <fenghua.yu@intel.com>
Cc: "'Jiri Bohac'" <jbohac@suse.cz>, "Luck, Tony" <tony.luck@intel.com>,
       "'kenneth.w.chen@intel.com'" <kenneth.w.chen@intel.com>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "'linux-ia64@vger.kernel.org'" <linux-ia64@vger.kernel.org>
Subject: Re: [RFC][PATCH] ia64: fix csum_ipv6_magic()
Message-ID: <20090901113518.GA4874@midget.suse.cz>
References: <20090827211113.GA22793@midget.suse.cz>
 <A6AD88C3F2289247BE726C37303E1EB8B954B4A6@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A6AD88C3F2289247BE726C37303E1EB8B954B4A6@orsmsx505.amr.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 28, 2009 at 02:19:19PM -0700, Yu, Fenghua wrote:
> >I was seeing "nf_ct_icmpv6: ICMPv6 checksum failed" errors on
> >every ICMPv6 packet received. The packets did not pass the
> >netfilter checksum verification but they did pass the standard
> >verification later and got processed. This happenns with hardware
> >checksumming turned off or with adapters that do not checksum
> >ICMP packets (e.g. tg3). I tracked the problem down to the ia64
> >version of csum_ipv6_magic() introduced by 007d77d0c5.  For some
> >arguments, it gives differrent results than the generic version.
> >
> >The following patch fixes the problem for me. IA64 experts, can
> >you please have a look?
> 
> Looks good to me. Do you know the caller function for the failed csum_ipv6_magic()?

I saw the problem when csum_ipv6_magic() was called from
nf_ip6_checksum(), in the CHECKSUM_NONE branch.

The the bug is triggered by having some bits set in the high
32-bits of the register used to pass the sum parameter to
csum_ipv6_magic().

For some reason, the 
	csum_sub(skb->csum, skb_checksum(skb, 0, dataoff, 0))
in the CHECKSUM_COMPLETE branch does not seem to trigger this,
while the
	csum_sub(0, skb_checksum(skb, 0, dataoff, 0))
in the CHECKSUM_NONE branch does.

I haven't looked at the disassembly to see why, though.

-- 
Jiri Bohac <jbohac@suse.cz>
SUSE Labs, SUSE CZ

