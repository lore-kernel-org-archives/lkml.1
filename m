Return-Path: <linux-kernel-owner+w=401wt.eu-S1761428AbZEGK2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761428AbZEGK2Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 06:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753065AbZEGK2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 06:28:07 -0400
Received: from mga12.intel.com ([143.182.124.36]:24428 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750981AbZEGK2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 06:28:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,309,1239001200"; 
   d="scan'208";a="140167435"
From: Sheng Yang <sheng@linux.intel.com>
Organization: Intel Opensource Technology Center
To: michael@ellerman.id.au
Subject: Re: [PATCH] msi-x: let drivers retry when not enough vectors
Date: Thu, 7 May 2009 18:28:32 +0800
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; x86_64; ; )
Cc: Matthew Wilcox <matthew@wil.cx>, kvm@vger.kernel.org,
       "Michael S. Tsirkin" <mst@redhat.com>, jbarnes@virtuousgeek.org,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Matthew Wilcox <willy@linux.intel.com>,
       virtualization@lists.linux-foundation.org
References: <20090507082841.GA31751@redhat.com> <20090507095302.GI8112@parisc-linux.org> <1241691830.24385.6.camel@concordia>
In-Reply-To: <1241691830.24385.6.camel@concordia>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905071828.33593.sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 May 2009 18:23:50 Michael Ellerman wrote:
> On Thu, 2009-05-07 at 03:53 -0600, Matthew Wilcox wrote:
> > On Thu, May 07, 2009 at 05:40:15PM +0800, Sheng Yang wrote:
> > > It's indeed weird. Why the semantic of pci_enable_msix can be changed
> > > to "enable msix, or tell me how many vector do you have"? You can
> > > simply call pci_msix_table_size() to get what you want, also without
> > > any more work, no? I can't understand...
> >
> > Here's a good example.  Let's suppose you have a driver which supports
> > two different models of cards, one has 16 MSI-X interrupts, the other
> > has 10.  You can call pci_enable_msix() asking for 16 vectors.  If your
> > card is model A, you get 16 interrupts.  If your card is model B, it says
> > "you can have 10".
> >
> > This is less work in the driver (since it must implement falling back to
> > a smaller number of interrupts *anyway*) than interrogating the card to
> > find out how many interrupts there are, then requesting the right number,
> > and still having the fallback path which is going to be less tested.
>
> Not to mention that there's no guarantee that you'll get as many
> interrupts as the device supports, so you should really be coding to
> cope with that anyway. Like the example in MSI-HOWTO.txt:
>
> 197 static int foo_driver_enable_msix(struct foo_adapter *adapter, int
> nvec) 198 {
> 199         while (nvec >= FOO_DRIVER_MINIMUM_NVEC) {
> 200                 rc = pci_enable_msix(adapter->pdev,
> 201                                      adapter->msix_entries, nvec);
> 202                 if (rc > 0)
> 203                         nvec = rc;
> 204                 else
> 205                         return rc;
> 206         }
> 207
> 208         return -ENOSPC;
> 209 }
>
> So I agree, this patch is an improvement.
>
Oh yeah.

Forgot irq counts can also be changed from time to time.

OK, there should be a loop, so that's fine. :)

-- 
regards
Yang, Sheng
