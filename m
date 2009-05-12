Return-Path: <linux-kernel-owner+w=401wt.eu-S1755904AbZELVaJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904AbZELVaJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 17:30:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755385AbZELV3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 17:29:53 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53698 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755208AbZELV3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 17:29:48 -0400
Date: Wed, 13 May 2009 00:28:02 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: virtualization@lists.linux-foundation.org,
       Sheng Yang <sheng@linux.intel.com>, Matthew Wilcox <matthew@wil.cx>,
       kvm@vger.kernel.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
       Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH] msi-x: let drivers retry when not enough vectors
Message-ID: <20090512212802.GC28935@redhat.com>
References: <20090507082841.GA31751@redhat.com> <20090507095302.GI8112@parisc-linux.org> <200905071819.54426.sheng@linux.intel.com> <200905080925.01398.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905080925.01398.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 08, 2009 at 09:25:00AM +0930, Rusty Russell wrote:
> On Thu, 7 May 2009 07:49:53 pm Sheng Yang wrote:
> > On Thursday 07 May 2009 17:53:02 Matthew Wilcox wrote:
> > > Here's a good example.  Let's suppose you have a driver which supports
> > > two different models of cards, one has 16 MSI-X interrupts, the other
> > > has 10.  You can call pci_enable_msix() asking for 16 vectors.  If your
> > > card is model A, you get 16 interrupts.  If your card is model B, it says
> > > "you can have 10".
> 
> Sheng is absolutely right, that's a horrid API.
> 
> If it actually enabled that number and returned it, it might make sense (cf. 
> write() returning less bytes than you give it).  But overloading the return 
> value to save an explicit call is just ugly; it's not worth saving a few lines 
> of code at cost of making all the drivers subtle and tricksy.
> 
> Fail with -ENOSPC or something.
> 
> Rusty.

I do agree that returning a positive value from pci_enable_msix
it an ugly API (but note that this is the API that linux currently has).

Here's a wrapper that I ended up with in my driver:

static int enable_msix(struct pci_dev *dev, struct msix_entry *entries,
		       int *options, int noptions)
{
        int i;
        for (i = 0; i < noptions; ++i)
                if (!pci_enable_msix(dev, entries, options[i]))
                        return options[i];
        return -EBUSY;
}

This gets an array of options for # of vectors and tries them one after
the other until an option that the system can support is found.
On success, we get the # of vectors actually enabled, and
driver can then use them as it sees fit.

Is there interest in moving something like this to pci.h?

-- 
MST
