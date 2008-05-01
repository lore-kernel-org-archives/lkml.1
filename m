Return-Path: <linux-kernel-owner+w=401wt.eu-S1758291AbYEACIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758291AbYEACIS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 22:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753989AbYEACIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 22:08:05 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:62095 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423AbYEACID convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 22:08:03 -0400
Message-ID: <ab3f9b940804301907y5a3e84e1l6cb41a339bc2241b@mail.gmail.com>
Date: Wed, 30 Apr 2008 19:07:58 -0700
From: "Tom May" <tom@tommay.com>
To: "=?ISO-8859-1?Q?Daniel_Sp=E5ng?=" <daniel.spang@gmail.com>
Subject: Re: [PATCH 0/8][for -mm] mem_notify v6
Cc: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <cfd9edbf0804230127k33a56312i6582f926e00ea17@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20080402154910.9588.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <ab3f9b940804141716x755787f5h8e0122c394922a83@mail.gmail.com>
	 <20080417182121.A8CA.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <ab3f9b940804171223m722912bfy291a2c6d9d40b24a@mail.gmail.com>
	 <cfd9edbf0804230127k33a56312i6582f926e00ea17@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2008 at 1:27 AM, Daniel Spång <daniel.spang@gmail.com> wrote:
> Hi Tom
>
>
>  On 4/17/08, Tom May <tom@tommay.com> wrote:
>  >
>  >  Here is the start and end of the output from the test program.  At
>  >  each /dev/mem_notify notification Cached decreases, then eventually
>  >  Mapped decreases as well, which means the amount of time the program
>  >  has to free memory gets smaller and smaller.  Finally the oom killer
>  >  is invoked because the program can't react quickly enough to free
>  >  memory, even though it can free at a faster rate than it can use
>  >  memory.  My test is slow to free because it calls nanosleep, but this
>  >  is just a simulation of my actual program that has to perform garbage
>  >  collection before it can free memory.
>
>  I have also seen this behaviour in my static tests with low mem
>  notification on swapless systems. It is a problem with small programs
>  (typically static test programs) where the text segment is only a few
>  pages. I have not seen this behaviour in larger programs which use a
>  larger working set. As long as the system working set is bigger than
>  the amount of memory that needs to be allocated, between every
>  notification reaction opportunity, it seems to be ok.

Hi Daniel,

You're saying the program's in-core text pages serve as a reserve that
the kernel can discard when it needs some memory, correct?  And that
even if the kernel discards them, it will page them back in as a
matter of course as the program runs, to maintain the reserve?  That
certainly makes sense.

In my case of a Java virtual machine, where I originally saw the
problem, most of the code is interpreted byte codes or jit-compiled
native code, all of which resides not in the text segment but in
anonymous pages that aren't backed by a file, and there is no swap
space.  The actual text segment working set can be very small (memory
allocation, garbage collection, synchronization, other random native
code).  And, as KOSAKI Motohiro pointed out, it may be wise to mlock
these areas.  So the text working set doesn't make an adequate
reserve.

However, I can maintain a reserve of cached and/or mapped memory by
touching pages in the text segment (or any mapped file) as the final
step of low memory notification handling, if the cached page count is
getting low.  For my purposes, this is nearly the same as having an
additional threshold-based notification, since it forces notifications
to occur while the kernel still has some memory to satisfy allocations
while userspace code works to free memory.  And it's simple.

Unfortunately, this is more expensive than it could be since the pages
need to be read in from some device (mapping /dev/zero doesn't cause
pages to be allocated). What I'm looking for now is a cheap way to
populate the cache with pages that the kernel can throw away when it
needs to reclaim memory.

Thanks,
.tom
