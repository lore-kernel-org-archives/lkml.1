Return-Path: <linux-kernel-owner+w=401wt.eu-S1753614AbYL2VfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614AbYL2VfT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 16:35:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751831AbYL2VfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 16:35:06 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:55138 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbYL2VfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 16:35:05 -0500
X-IronPort-AV: E=Sophos;i="4.36,297,1228089600"; 
   d="scan'208";a="221140928"
From: Roland Dreier <rdreier@cisco.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Aleksey Senin <alekseys@voltaire.com>,
       "general\@lists.openfabrics.org" <general@lists.openfabrics.org>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: origin tree build failure
References: <20081229114321.4b6baea5.sfr@canb.auug.org.au>
	<ada4p0nve4r.fsf@cisco.com> <1230544737.4261.33.camel@alst60>
	<adaljtyu45d.fsf@cisco.com>
	<alpine.LFD.2.00.0812291304471.3082@localhost.localdomain>
X-Message-Flag: Warning: May contain useful information
Date: Mon, 29 Dec 2008 13:35:02 -0800
In-Reply-To: <alpine.LFD.2.00.0812291304471.3082@localhost.localdomain> (Linus
	Torvalds's message of "Mon, 29 Dec 2008 13:07:16 -0800 (PST)")
Message-ID: <adahc4mu0l5.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 29 Dec 2008 21:35:02.0486 (UTC) FILETIME=[4EB46F60:01C969FD]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > I'd suggest
 > 
 >   config IF_IPV6
 > 	bool
 > 	depends on INET
 > 	depends on !(INFINIBAND = y && IPV6 = m)
 > 	default y

Makes sense, will do.  How about calling it INFINIBAND_USE_IPV6 or
something like that, though?  (Since it's under the INFINIBAND config
stuff and exists to forbid INFINIBAND=y && IPV6=m trying to use IPv6).
But see below:

 > but also use it in the source code as a more readable version:
 > 
 > > diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
 > > index d98b05b..ec7abb5 100644
 > > --- a/drivers/infiniband/core/addr.c> +++ b/drivers/infiniband/core/addr.c
 > > @@ -128,6 +128,7 @@ int rdma_translate_ip(struct sockaddr *addr, struct rdma_dev_addr *dev_addr)
 > >  		ret = rdma_copy_addr(dev_addr, dev, NULL);
 > >  		dev_put(dev);
 > >  		break;
 > > +#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
 > 
 > ie use
 > 
 > 	#ifdef CONFIG_IF_IPV6

this doesn't make sense, does it?  Your CONFIG_IF_IPV6 will be set in
the case IPV6=n too I think.  (Which is the whole point... we want to
build this code, just without IPv6 support, if IPv6 is turned off
completely)

 - R.
