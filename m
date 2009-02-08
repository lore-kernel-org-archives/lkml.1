Return-Path: <linux-kernel-owner+w=401wt.eu-S1753863AbZBHSlF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863AbZBHSlF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 13:41:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753183AbZBHSkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 13:40:52 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:43681 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077AbZBHSkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 13:40:52 -0500
Date: Sun, 8 Feb 2009 18:25:45 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Sami Farin <safari-kernel@safari.iki.fi>
cc: Linux kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.28.4 regression: mmap fails if mlockall used
In-Reply-To: <20090208105222.hj7zhcyxyqfjeobt@m.safari.iki.fi>
Message-ID: <Pine.LNX.4.64.0902081802480.14394@blonde.anvils>
References: <20090208105222.hj7zhcyxyqfjeobt@m.safari.iki.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Feb 2009, Sami Farin wrote:

> 2.6.28.2 + gcc-4.3.2-7 works.
> 2.6.28.4 + gcc-4.4.0-0.16 does not work.
> I run x86_64 SMP kernel.

If it's really a bug, in kernel or gcc, then it will help to know
how 2.6.28.4 + gcc-4.3.2-7 behaves.  And are you using the respective
version of gcc to build both the kernel and the a.out?

> 
> # strace ./a.out ntp
> 12:10:14.780726 mmap(NULL, 2147624, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = -1 EFAULT (Bad address) <0.000038>

I wonder where that 2147624 originates from.  Because EFAULT is exactly
what you get on an mmap of a file, following an mlockall(MCL_FUTURE),
if the file is actually a page or more shorter than the size given:
the mlocking tries to fault in a non-existent page of the file, if
in userspace you'd get SIGBUS, but within the kernel it's EFAULT
returned from the mmap.

My suspicion is that the 2147624 is just wrong: is it a filesize,
but the file gets truncated before the mmap? or is it the size given
in an ELF section perhaps, but the file actually not that big?
Any ENOSPC in that filesystem recently?

> 12:10:14.780809 close(3)                = 0 <0.000012>
> 12:10:14.780856 munmap(0x7f3476e0d000, 421232) = 0 <0.000145>
> 12:10:14.781054 write(2, "./a.out: getpwnam failed: Success\n"..., 34./a.out: getpwnam failed: Success
> ) = 34 <0.000015>
> 
> I can do malloc(3000000), then mmap call is
> 12:50:20.694207 mmap(NULL, 3002368, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f8a8d16b000 <0.003078>

Whereas in the case of anonymous, we don't have an underlying object
to fault in (or create the object in response to the mmap), so no
such problem.

I didn't manage to reproduce this here, but I wasn't using the same
version of gcc nor (I'd guess!) your kernel config nor your a.out.

Hugh
