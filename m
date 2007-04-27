Return-Path: <linux-kernel-owner+w=401wt.eu-S1755650AbXD0Llv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650AbXD0Llv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 07:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755651AbXD0Llv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 07:41:51 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:34856 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755649AbXD0Llt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 07:41:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=c/Ecq9csGLKu6cCtH0YmOFWzNOa6/Qy1ZSeNrKS2YJi6kdRH3ythhhqP8kPkN2Tutt5wivJp4QzRt3eiNrlFYgf9QrC5jZN8D2fLJJQlS9jd3Tl5T0/3LHbyR+zGXUwI+UXI24sSb8s1SaOn99ToaFaOZQ+lDYmxLZ1Xx1kSTYs=  ;
X-YMail-OSG: 7ppLlicVM1mr9vaj1DZk8UQ4Opo_z2eWEsS2AEMEpwq2VPZLPFUUmRTO8rZ6BBSX_JixX3hf3w--
Message-ID: <4631E173.7000204@yahoo.com.au>
Date: Fri, 27 Apr 2007 21:41:39 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, David Chinner <dgc@sgi.com>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
References: <20070424222105.883597089@sgi.com>	<20070426190438.3a856220.akpm@linux-foundation.org>	<20070427022731.GF65285596@melbourne.sgi.com>	<20070426195357.597ffd7e.akpm@linux-foundation.org>	<20070427042046.GI65285596@melbourne.sgi.com>	<20070426221528.655d79cb.akpm@linux-foundation.org>	<Pine.LNX.4.64.0704262239580.4758@schroedinger.engr.sgi.com>	<20070426235542.bad7035a.akpm@linux-foundation.org> <17969.55533.59287.509889@cargo.ozlabs.ibm.com>
In-Reply-To: <17969.55533.59287.509889@cargo.ozlabs.ibm.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mackerras wrote:
> Andrew Morton writes:
> 
> 
>>If x86 had larger pagesize we wouldn't be seeing any of this.  It is a workaround
>>for present-generation hardware.
> 
> 
> Unfortunately, it's not really practical to increase the page size
> very much on most systems, because you end up wasting a lot of space
> in the page cache.  So there is a tension between wanting a small page
> size so your page cache uses memory efficiently, and wanting a large
> page size so the TLB covers more address space and your programs run
> faster (not to mention other benefits such as the kernel having to
> manage fewer pages, and I/O being done in bigger chunks).
> 
> Thus there is not really any single page size that suits all workloads
> and machines.  With distros wanting to just have a single kernel per
> architecture, and the fact that the page size is a compile-time
> constant, we currently end up having to pick one size and just put up
> with the fact that it will suck for some users.  We currently have
> this situation on ppc64 now that POWER5+ and POWER6 machines have
> hardware support for 64k pages as well as 4k pages.
> 
> So I can see a few different options:
> 
> (a) Keep things more or less as they are now and just wear the fact
> that we will continue to show lower performance than certain
> proprietary OSes, or
> 
> (b) Somehow manage to make the page size a variable rather than a
> compile-time constant, and pick a suitable page size at boot time
> based on how much memory the machine has, or something.  I looked at
> implementing this at one point and recoiled in horror. :)
> 
> (c) Make the page cache able to use small pages for small files and
> large pages for large files.  AIUI this is basically what Christoph is
> proposing.
> 
> Option (a) isn't very palatable to me (nor I expect, Christoph :)
> since it basically says that Linux is very much focussed on the
> embedded and desktop end of things and isn't really suitable as a
> high-performance OS for large SMP systems.  I don't want to believe
> that. ;)
> 
> Option (b) would be a bit of an ugly hack.
> 
> Which leaves option (c) - unless you have a further option.  So I have
> to say I support Christoph on this, at least as far as the general
> principle is concerned.

For the TLB issue, higher order pagecache doesn't help. If distros
ship with a 4K page size on powerpc, and use some larger pages in
the pagecache, some people are still going to get angry because
they wanted to use 64K pages... But I agree 64K pages is too big
for most things anyway, and 16 would be better as a default (which
hopefully x86-64 will get one day).

Anyway, for io performance, there are alternatives, dispite what
some people seem to be saying. We can submit larger sglists to the
device for larger ios, which Jens is looking at (which could help
all types of workloads, not just those with sequential large file
IO).

After that, I'd find it amusing if HBAs worth thousands of $ have
trouble looking up sglists at the relatively glacial pace that IO
requires, and/or can't spare a few more K for reasonable sglist
sizes, but if that is really the case, then we could use iommus
and/or just attempt to put physically contiguous pages in pagecache,
rather than require it.

-- 
SUSE Labs, Novell Inc.
