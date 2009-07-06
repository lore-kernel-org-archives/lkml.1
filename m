Return-Path: <linux-kernel-owner+w=401wt.eu-S1754505AbZGFMGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505AbZGFMGX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 08:06:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbZGFMGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 08:06:16 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:60749 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824AbZGFMGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 08:06:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gWyHVv9VHH+TWXpMRT+an7M/5Y9SitR6czE8+ZgtilSQx9hQqeFxOW89guR5FVNlea
         f4/jRsYQ5qJ96a+71YRI4a7hpGgXpa5D9yX9mL/JY9Y0ynLlB7+SeaJhFQ6szKMLoyQl
         BAiGiISjWVgEdC/oCL3CEjS7xk2t9P7nTiizw=
MIME-Version: 1.0
In-Reply-To: <4A51B127.8080807@tlinx.org>
References: <4A51B127.8080807@tlinx.org>
Date: Mon, 6 Jul 2009 14:06:17 +0200
Message-ID: <4e5e476b0907060506m3d57a454va94d2eafd61d73a0@mail.gmail.com>
Subject: Re: pipe(2), read/write, maximums and behavior.
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Linda Walsh <lkml@tlinx.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linda,
the limit displayed by the shell is the amunt of data that the sender
can send to the pipe before it would block waiting for the receiver to
read.
In your case, you make larger transfers, so they become synchronous.

For such large transfers, you should consider using vmsplice, that
allows moving data through pipes without copying.

Corrado

On 7/6/09, Linda Walsh <lkml@tlinx.org> wrote:
> I've seen a few shells claim to limit pipe sizes to 8 512Byte buffers.
> Don't know where they get this value or how they think it applies, but
> it certainly doesn't seem to apply in linux.   However, I'm not
> sure what limits do apply compared to available memory.
>
> I suppose, starting off, one might look at at a maximum of
> (Physical+Swap-resident-non-swappable mem)/2 as a top limit.
>
> A test machine I have has 8GB physical memory with a bit over 4GB
> of swap space making for about 12GB of memory.
>
> If total memory was to go toward my proglet that splits into a master
> writer and slave pipe reader, they'd have to split memory to have
> matching buffer read/write sizes. I'd "expect", (I think) at least
> a 2GB write/read to work, and possibly a 4GB write/read to work
> with alot of swap activity -- that's assuming there are no other
> restraints in dividing 12GB of address space.
>
> As it turns out -- the program dies at 2GB (the 1GB write/read works)
> but when the program tries a 2GB write & read it refuses the full write
> and the child gets less than 2GB.
>
> The master gets back that it wrote 2097148KB, though it tried to
> write 2097152KB (and the child receives the 2GB-4K buffer upon read).
>
> This is on a x86_64 machine, and unsigned long values are 8-bytes
> wide and being used with the read and write calls for lengths.
>
> Shouldn't a 2GB read/write work?  At most, together the master
> and slave would have only used 4GB for each to have a 2GB buffer.
>
> How would one determine the maximum size for 1 huge read or write
> through the pipe (from the pipe system call)?
>
> On 2GHz multi-core machines, I get about 512MB/s throughput.
>
> I attached the source file so anyone can see my methodology.
>
> you have to include "-lrt" on the gcc command line as it uses
> clock_gettime to estimate the time for the write call (the read
> call always comes back with values too small to be reasonable, so
> I don't bother printing them.
>
>
>
>


-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
