Return-Path: <linux-kernel-owner+w=401wt.eu-S1759797AbZDBMqK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759797AbZDBMqK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 08:46:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753128AbZDBMpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 08:45:54 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:38676 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994AbZDBMpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 08:45:53 -0400
Date: Thu, 2 Apr 2009 13:43:05 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Michael Ellerman <michael@ellerman.id.au>
cc: Chris Friesen <cfriesen@nortel.com>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>, peterz@infradead.org,
       akpm@linux-foundation.org
Subject: Re: Resend: /proc/<pid>/maps offset output broken in 2.6.29
In-Reply-To: <1238659491.9041.133.camel@localhost>
Message-ID: <Pine.LNX.4.64.0904021324070.16207@blonde.anvils>
References: <49CA8501.1000000@nortel.com>  <49D3F662.4050100@nortel.com>
 <1238659491.9041.133.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Apr 2009, Michael Ellerman wrote:
> On Wed, 2009-04-01 at 17:18 -0600, Chris Friesen wrote:
> > Resending due to lack of response to original post.
> 
> Hi Chris,
> 
> You'll probably get a more useful response on lkml. You CC'ed
> linux-kernel-owner originally :)

Thanks.

> 
> > I was validating some code dealing with /proc/<pid>/maps on 2.6.29 and 
> > was surprised when it failed.  It turns out that at least on my ppc64 G5 
> > machine the offset value for the last entry is strange--it shows up as a 
> > 64-bit value even though the process itself is only 32-bit.
> > 
> > This behaviour also shows up in 2.6.25, but doesn't in 2.6.14.  I 
> > haven't yet tested anything else in between.
> > 
> > [cfriesen@localhost cfriesen]$ cat /proc/self/maps
> > 00100000-00103000 r-xp 00100000 00:00 0         [vdso]
> > 0fe70000-0ffbf000 r-xp 00000000 08:03 4312393   /lib/tls/libc-2.3.3.so
> > 0ffbf000-0ffc0000 ---p 0014f000 08:03 4312393   /lib/tls/libc-2.3.3.so
> > 0ffc0000-0ffc2000 r--p 00150000 08:03 4312393   /lib/tls/libc-2.3.3.so
> > 0ffc2000-0ffc6000 rwxp 00152000 08:03 4312393   /lib/tls/libc-2.3.3.so
> > 0ffc6000-0ffc8000 rwxp 0ffc6000 00:00 0
> > 0ffd0000-0ffec000 r-xp 00000000 08:03 4309011   /lib/ld-2.3.3.so
> > 0fff0000-0fff1000 r--p 00020000 08:03 4309011   /lib/ld-2.3.3.so
> > 0fff1000-0fff2000 rwxp 00021000 08:03 4309011   /lib/ld-2.3.3.so
> > 10000000-10004000 r-xp 00000000 08:03 917536    /bin/cat
> > 10013000-10015000 rwxp 00003000 08:03 917536    /bin/cat
> > 10015000-10036000 rwxp 10015000 00:00 0         [heap]
> > f7deb000-f7feb000 r--p 00000000 08:03 2560322 
> > /usr/lib/locale/locale-archive
> > f7feb000-f7fec000 rw-p f7feb000 00:00 0
> > ffe6d000-ffe82000 rw-p ffffffeb000 00:00 0      [stack]
> > 
> > I'm at a loss to explain what's going on here.  Anyone got any ideas?
> 
> It looks like for vmas that don't have a vm_file (like the stack),
> vm_pgoff is basically "internal use" - and so can be > 32 bit.

Yes, it's just a cosmetic blemish, which comes from how the args on
stack are initially prepared in a 64-bit space, then moved into place
for the 32-bit task - the anon vm_pgoff still reflects the original
location, precisely in order to track pages despite movements.

(2.6.14 had the same use of anon vm_pgoff, but args on stack
were limited, and inserted directly into the 32-bit space.)

Chris isn't the first to be concerned by that: there's a patch in
-mm which just shows 0 instead of anon vm_pgoff in /proc/<pid>/maps
output.  That patch is on akpm's list for 2.6.30 merge, but I think
hasn't gone to Linus yet: expect it in a later batch.

Hugh
