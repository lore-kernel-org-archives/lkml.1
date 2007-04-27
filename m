Return-Path: <linux-kernel-owner+w=401wt.eu-S1755596AbXD0LF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596AbXD0LF2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 07:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755600AbXD0LF1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 07:05:27 -0400
Received: from ozlabs.org ([203.10.76.45]:53418 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755596AbXD0LF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 07:05:26 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17969.55533.59287.509889@cargo.ozlabs.ibm.com>
Date: Fri, 27 Apr 2007 21:05:17 +1000
From: Paul Mackerras <paulus@samba.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <clameter@sgi.com>, David Chinner <dgc@sgi.com>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
In-Reply-To: <20070426235542.bad7035a.akpm@linux-foundation.org>
References: <20070424222105.883597089@sgi.com>
	<20070426190438.3a856220.akpm@linux-foundation.org>
	<20070427022731.GF65285596@melbourne.sgi.com>
	<20070426195357.597ffd7e.akpm@linux-foundation.org>
	<20070427042046.GI65285596@melbourne.sgi.com>
	<20070426221528.655d79cb.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704262239580.4758@schroedinger.engr.sgi.com>
	<20070426235542.bad7035a.akpm@linux-foundation.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton writes:

> If x86 had larger pagesize we wouldn't be seeing any of this.  It is a workaround
> for present-generation hardware.

Unfortunately, it's not really practical to increase the page size
very much on most systems, because you end up wasting a lot of space
in the page cache.  So there is a tension between wanting a small page
size so your page cache uses memory efficiently, and wanting a large
page size so the TLB covers more address space and your programs run
faster (not to mention other benefits such as the kernel having to
manage fewer pages, and I/O being done in bigger chunks).

Thus there is not really any single page size that suits all workloads
and machines.  With distros wanting to just have a single kernel per
architecture, and the fact that the page size is a compile-time
constant, we currently end up having to pick one size and just put up
with the fact that it will suck for some users.  We currently have
this situation on ppc64 now that POWER5+ and POWER6 machines have
hardware support for 64k pages as well as 4k pages.

So I can see a few different options:

(a) Keep things more or less as they are now and just wear the fact
that we will continue to show lower performance than certain
proprietary OSes, or

(b) Somehow manage to make the page size a variable rather than a
compile-time constant, and pick a suitable page size at boot time
based on how much memory the machine has, or something.  I looked at
implementing this at one point and recoiled in horror. :)

(c) Make the page cache able to use small pages for small files and
large pages for large files.  AIUI this is basically what Christoph is
proposing.

Option (a) isn't very palatable to me (nor I expect, Christoph :)
since it basically says that Linux is very much focussed on the
embedded and desktop end of things and isn't really suitable as a
high-performance OS for large SMP systems.  I don't want to believe
that. ;)

Option (b) would be a bit of an ugly hack.

Which leaves option (c) - unless you have a further option.  So I have
to say I support Christoph on this, at least as far as the general
principle is concerned.

Regards,
Paul.
