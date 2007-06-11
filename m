Return-Path: <linux-kernel-owner+w=401wt.eu-S1754151AbXFKW0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151AbXFKW0T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 18:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751947AbXFKW0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 18:26:11 -0400
Received: from ns2.suse.de ([195.135.220.15]:47239 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751726AbXFKW0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 18:26:10 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Intel-IOMMU 02/10] Library routine for pre-allocat pool handling
Date: Tue, 12 Jun 2007 00:16:58 +0200
User-Agent: KMail/1.9.6
Cc: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       gregkh@suse.de, muli@il.ibm.com, asit.k.mallick@intel.com,
       suresh.b.siddha@intel.com, arjan@linux.intel.com, ashok.raj@intel.com,
       shaohua.li@intel.com, davem@davemloft.net
References: <20070606185658.138237000@askeshav-devel.jf.intel.com> <20070611204442.GA4074@linux-os.sc.intel.com> <20070611141449.bfbc4769.akpm@linux-foundation.org>
In-Reply-To: <20070611141449.bfbc4769.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706120016.58317.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> If the only option is to panic then something's busted.  If it's network IO
> then there should be a way of dropping the frame.  If it's disk IO then we
> should report the failure and cause an IO error.

An block IO error is basically catastrophic for the system too. There isn't really
a concept of "temporary IO error that will resolve itself" concept in Unix.

There are still lots of users of pci_map_single() that don't check the return
value unfortunately.   That is mostly in old drivers; it is generally
picked on in reviews now. But then there is no guarantee that these rarely
used likely untested error handling paths actually work.

The alternative is writing out random junk which is somewhat risky.

We fixed over time all the pci_map_sg()s at least to do the checks correctly.

When I wrote the IOMMU code originally this wasn't the case and it destroyed
several file systems of test systems due to IOMMU leaks in drivers
(writing junk over the super block  when the IOMMU is full doesn't make
mount happy after the next reboot) 

Because of these experiences I'm more inclined towards the panic option,
although x86-64 defaults to not panic these days.

It would be really much better if sleeping was allowed, but it is hard.

-Andi
