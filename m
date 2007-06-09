Return-Path: <linux-kernel-owner+w=401wt.eu-S1754602AbXFIFR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602AbXFIFR7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 01:17:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbXFIFRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 01:17:51 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:51291 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbXFIFRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 01:17:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=I6MrvJYSxJLcgvc0Mli80pkxPvRVkDx4FO0gznZq4193fG8bDmMwAqWHnp7QECdghNuYUFOvEbekEld6fiB8n0ObDziA3aTF0ONy2K5jVTEa9ut5oGRYKgXQPIEP7THhSeUmoMCDXGuOVHVQt2jMFcyYATdHUERVYjvaUgUReYg=
Message-ID: <787b0d920706082217m246400edv754ab1e37ca0ec3b@mail.gmail.com>
Date: Sat, 9 Jun 2007 01:17:49 -0400
From: "Albert Cahalan" <acahalan@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: JIT emulator needs
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20070608121059.4efcd338@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <787b0d920706072335v10d6025cwe1437194b6c60d84@mail.gmail.com>
	 <20070608121059.4efcd338@the-village.bc.nu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/8/07, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > There is an SE Linux execmem restriction that enforces W^X.
>
> This depends on whatever SELinux rulesets you are running. Its just a
> good rule to have present that most programs shouldn't be self patching,
> and then label those that do differently.

A marking in the executable would have made more sense.
It is really broken having an unprivileged user being able to
create whole new executables but unable to lift this restriction
on those executables.

In any case, the restriction is common and troublesome.

> > Sometimes it is very helpful to have the read/write mapping
> > be a fixed offset from the read/exec mapping. A power of 2
> > can be especially desirable.
>
> mmap MAP_FIXED can do this but you need to know a lot about the memory
> layout of the system so it gets a bit platform specific.

Yes. There are unportable programs, and UNPORTABLE ones.
Memory layout can vary between vendor kernels, between normal
and 32-on-64 situations, between two different C libraries...

> > Emulators often need a cheap way to change page permissions.
>
> mprotect(, range) rather than a page at a time. The kernel will do
> merging.

Nope. This can happen rapidly and repeatedly to pages
that are essentially random. The median length of a range
will be a page or two. Merging won't do very much at all.

> > a. sysctl to set IPC_RMID by default
> > b. shmget() flag to set IPC_RMID by default
>
> Use POSIX shared memory

That appears to have the exact same problem.

> > c. open() flag to unlink a file before returning the fd
>
> Is it really that costly to create a blank file, why do you need to do it
> a lot in a JIT ?

This part isn't about cost. It's about not leaving around
debris when the JIT crashes.

> > e. mremap() flag to get a read/write mapping of a read/exec one
> > f. mremap() flag to get a read/exec mapping of a read/write one
> > g. mremap() flag to make the 5th arg (new addr) be the upper limit
>
> This is all mprotect and munmap.

That won't get me a second mapping. Supposing that I had
a second mapping, SE Linux would deny the mprotect.
I'm looking for a mapping that is born executable or a mapping
that is born writable, as needed, so that no transition is needed.

> > h. 6-bit wide mremap() "flag" to set the upper limit above given base
> > i. support the prot argument to remap_file_pages
> > j. a documented way (madvise?) to punch same-VMA zero-page holes
>
> mmap (although you get more VMAs from that) so memset() is probably
> genuinely cheaper if the permissions are not changing.

Well cost is the problem here. I sure can find some way to
get the operation done, but it isn't cheap. For some usages,
the current setup is costly enough that one must consider
abandoning the hardware MMU in favor of a software one
emitted as part of the JIT. :-(
