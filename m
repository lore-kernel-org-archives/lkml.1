Return-Path: <linux-kernel-owner+w=401wt.eu-S932689AbZD1P3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932689AbZD1P3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 11:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752745AbZD1P26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 11:28:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:45894 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754100AbZD1P25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 11:28:57 -0400
Subject: Re: IOMMU and graphics cards
From: David Woodhouse <dwmw2@infradead.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       mingo@redhat.com, fujita.tomonori@lab.ntt.co.jp, airlied@linux.ie
In-Reply-To: <20090428150531.GZ17438@amd.com>
References: <20090428150531.GZ17438@amd.com>
Content-Type: text/plain
Date: Tue, 28 Apr 2009 16:28:50 +0100
Message-Id: <1240932530.2567.91.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 (2.26.1-2.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-28 at 17:05 +0200, Joerg Roedel wrote:
> Hi David,
> 
> as I have seen the VT-d code implements a workaround for broken graphics
> card drivers. What it does, when enabled, is giving each grahics device
> direct access to all physical memory. I really don't like to implement
> this but a similar workaround for the AMD IOMMU seems to be necessary.
> The biggest problem here is that this kind of workaround disables device
> isolation for graphics cards. Device isolation is the main reason for
> using an IOMMU in an unvirtualized environment. So if this workaround is
> enabled it is as good as disable the IOMMU at all.

For that device, yes. The IOMMU still catches errors from _other_
devices, of course.

But I agree that it's a crap thing to have to do, and there are probably
a number of ways we could make it slightly less crap. For a start, we
could at least refrain from mapping the kernel text -- the card has no
business DMAing there, whatever happens.

> Thats why I think a kernel compile option for this workaround is not
> sufficient. Distributors will probably enable this in their kernels
> which also disables device isolation even if the user don't want to use
> these broken drivers.

Yes, that makes a lot of sense.

Is the reason you're doing this actually because of broken drivers? Or
just because of the performance implications? I've heard both cited as
reasons for the 1:1 mapping... and if it's mostly the former, then
perhaps the best way for me to help you is to stop enabling the option
in Fedora (rawhide, at least), so that the buggy drivers get _fixed_ and
you don't get stuck with "it works on Intel, why can't you make it
work?" reports?

> I think we should change that and provide a better way which allows to
> enable this workaround only if it is required (and it should be
> transparent to the user which IOMMU is built into the system).
> We have several options to do this:
> 
> 	* Implement a kernel command line option to enable/disable the
> 	  workaround (what should be default?)
> 	* Use the IOMMU-API and write a kernel module which creates a
> 	  direct mapped protection domain and assigns the graphics
> 	  cards to it (need to be done carefully to not break graphics 
> 	  drivers which do everything right and use the DMA-API)
> 	* Any other great idea?
> 
> So what do you (and all the others reading this :-) think? I would
> prefer the way of implementing a module but there may also be reasons
> against this. I would like this to be disussed before I implement the
> workaround for the AMD IOMMU.

I think I also prefer your second option. I don't like having this as a
hack in the IOMMU code.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

