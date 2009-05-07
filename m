Return-Path: <linux-kernel-owner+w=401wt.eu-S1760175AbZEGKTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760175AbZEGKTj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 06:19:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756060AbZEGKT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 06:19:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:59104 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754394AbZEGKTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 06:19:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,308,1239001200"; 
   d="scan'208";a="410273998"
From: Sheng Yang <sheng@linux.intel.com>
Organization: Intel Opensource Technology Center
To: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] msi-x: let drivers retry when not enough vectors
Date: Thu, 7 May 2009 18:19:53 +0800
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; x86_64; ; )
Cc: kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
       jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>,
       virtualization@lists.linux-foundation.org
References: <20090507082841.GA31751@redhat.com> <200905071740.16190.sheng@linux.intel.com> <20090507095302.GI8112@parisc-linux.org>
In-Reply-To: <20090507095302.GI8112@parisc-linux.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905071819.54426.sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 May 2009 17:53:02 Matthew Wilcox wrote:
> On Thu, May 07, 2009 at 05:40:15PM +0800, Sheng Yang wrote:
> > It's indeed weird. Why the semantic of pci_enable_msix can be changed to
> > "enable msix, or tell me how many vector do you have"? You can simply
> > call pci_msix_table_size() to get what you want, also without any more
> > work, no? I can't understand...
>
> Here's a good example.  Let's suppose you have a driver which supports
> two different models of cards, one has 16 MSI-X interrupts, the other
> has 10.  You can call pci_enable_msix() asking for 16 vectors.  If your
> card is model A, you get 16 interrupts.  If your card is model B, it says
> "you can have 10".
>
> This is less work in the driver (since it must implement falling back to
> a smaller number of interrupts *anyway*) than interrogating the card to
> find out how many interrupts there are, then requesting the right number,
> and still having the fallback path which is going to be less tested.

Yeah, partly understand now.

But the confusing of return value is not that pleasure compared to this 
benefit. And even you have to fall back if return > 0 anyway, but in the past, 
you just need fall back once at most; but now you may fall back twice. This 
make thing more complex - you need either two ifs or a simple loop. And just 
one "if" can deal with it before. All that required is one call for 
pci_msix_table_size(), and I believe most driver would like to know how much 
vector it have before it fill the vectors, so mostly no extra cost. But for 
this ambiguous return meaning, you have to add more code for fall back - yes, 
the driver may can assert that the positive return value always would be irq 
numbers if it call pci_msix_table_size() before, but is it safe in logic?

-- 
regards
Yang, Sheng
