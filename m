Return-Path: <linux-kernel-owner+w=401wt.eu-S1751499AbXBPHbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751499AbXBPHbz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 02:31:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315AbXBPHby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 02:31:54 -0500
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:30600 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751499AbXBPHbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 02:31:53 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=j0937vSADIoSpw0FoYFQQ5jfSKPtCrY4plYuBV0bWevljH4hWsfZvFfrR6Hm2/zWhGZkYPqxyqjCBfbFmgklcMJ5L2AhSb5gLae9UOnKn3Jnh6mB5ErPXe19BQJhxQ3XfWRe4Izpwnix0PaqZaMgYW/9s/Op3hZ77NTSpHms/qc=  ;
X-YMail-OSG: gA3f6cQVM1noRX8nWSff8eSWT2qvYJ22.ra2ct7gMvsEeZV09Oor.5InAH5TdZ4TC2qGrFgAON7fonBk5qRPJzGPKJcGkVa_2jKsAJmXxNCYy4FQ4PsiXL3bWarWJk95rPXqwqHdr_yakMQ-
Message-ID: <45D55DC2.3070703@yahoo.com.au>
Date: Fri, 16 Feb 2007 18:31:14 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@muc.de>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Zachary Amsden <zach@vmware.com>, Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       Christoph Lameter <clameter@sgi.com>,
       Linux Memory Management <linux-mm@kvack.org>,
       David Rientjes <rientjes@google.com>
Subject: Re: [patch 11/21] Xen-paravirt: Add apply_to_page_range() which applies
 a function to a pte range.
References: <20070216022449.739760547@goop.org>	<20070216022531.344125142@goop.org> <20070215223727.6819f962.akpm@linux-foundation.org>
In-Reply-To: <20070215223727.6819f962.akpm@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 15 Feb 2007 18:25:00 -0800 Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> 
> 
>>Add a new mm function apply_to_page_range() which applies a given
>>function to every pte in a given virtual address range in a given mm
>>structure. This is a generic alternative to cut-and-pasting the Linux
>>idiomatic pagetable walking code in every place that a sequence of
>>PTEs must be accessed.
>>
>>Although this interface is intended to be useful in a wide range of
>>situations, it is currently used specifically by several Xen
>>subsystems, for example: to ensure that pagetables have been allocated
>>for a virtual address range, and to construct batched special
>>pagetable update requests to map I/O memory (in ioremap()).
> 
> 
> There was some discussion about this sort of thing last week.  The
> consensus was that it's better to run the callback against a whole pmd's
> worth of ptes, mainly to amortise the callback's cost (a lot).
> 
> It was implemented in
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20/2.6.20-mm1/broken-out/smaps-extract-pmd-walker-from-smaps-code.patch


Speaking of that patch, I missed the discussion, but I'd hope it doesn't
go upstream in its current form.

We now have one way of walking range of ptes. The code may be duplicated a
few times, but it is simple, we know how it works, and it is easy to get
right because everyone does the same thing.

We used to have about a dozen slightly different ways of doing this until
Hugh spent the effort to standardise it all. Isn't it nice?

If we want an ever-so-slightly lower performing interface for those paths
that don't care to count every cycle -- which I think is a fine idea BTW
-- it should be implemented in mm/memory.c and it should use our standard
form of pagetable walking.

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
