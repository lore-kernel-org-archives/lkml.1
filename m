Return-Path: <linux-kernel-owner+w=401wt.eu-S1757809AbYCNV2K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757809AbYCNV2K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 17:28:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754893AbYCNV14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 17:27:56 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:60433 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754328AbYCNV1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 17:27:55 -0400
Subject: Re: [patch 0/6] Guest page hinting version 6.
From: Zachary Amsden <zach@vmware.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Hugh Dickins <hugh@veritas.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       virtualization@lists.osdl.org, akpm@linux-foundation.org,
       nickpiggin@yahoo.com.au, frankeh@watson.ibm.com, rusty@rustcorp.com.au,
       andrea@qumranet.com, clameter@sgi.com, a.p.zijlstra@chello.nl,
       Keir Fraser <keir@xensource.com>, Ian Pratt <ian.pratt@xensource.com>
In-Reply-To: <47DAC435.1050105@goop.org>
References: <20080312132132.520833247@de.ibm.com>
	 <Pine.LNX.4.64.0803131627450.17244@blonde.site> <47D9754B.1030509@goop.org>
	 <Pine.LNX.4.64.0803131848080.800@blonde.site>
	 <1205438038.14987.1.camel@bodhitayantram.eng.vmware.com>
	 <47DAC435.1050105@goop.org>
Content-Type: text/plain
Date: Fri, 14 Mar 2008 14:32:38 -0700
Message-Id: <1205530358.14987.32.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-03-14 at 11:30 -0700, Jeremy Fitzhardinge wrote:
> Zachary Amsden wrote:
> > How about a fake hypervisor, which is really just a random page evictor,
> > following the rules of CMM?
> >   
> 
> Probably simpler to just have variants of the page_set_* functions which 
> simulate the worst-possible host action immediately (ie, stealing pages, 
> logically swapping them, etc).  That wouldn't give you full coverage, 
> but it would go some way.  An async variant which schedules a change in 
> a few milliseconds would help too.
> 
> I guess that's equivalent to having a special-purpose hypervisor built 
> into the kernel (hm, sounds familiar...).

It needn't be that hard on s390, I believe you don't need to worry about
PTEs becoming asynchronous when stealing a page, since if I understand
the hypervisor architecture, there is a per-page mapping level
available, allowing you to generate discard faults on access.  It might
be possible to use this mapping layer without implementing a full blown
hypervisor.  Martin?

For x86, at discard time, you would have to manually walk and invalidate
any PTEs potentially mapping the discarded page, but there is already
this great thing called Xen paravirt-ops which actually does that for
completely different reasons (PT page protection).

I think a random exponential distribution for discard would be needed to
catch all the racey failure modes.

Zach

