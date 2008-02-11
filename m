Return-Path: <linux-kernel-owner+w=401wt.eu-S1759220AbYBKQ5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759220AbYBKQ5i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 11:57:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754999AbYBKQ53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 11:57:29 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36844 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751563AbYBKQ52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 11:57:28 -0500
Date: Mon, 11 Feb 2008 08:32:14 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Matthew Keenan <matt@opcode-solutions.com>
cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org
Subject: Re: Linux 2.6.22.18
In-Reply-To: <1202729485.24584.5.camel@bazbox.opcode-solutions.com>
Message-ID: <alpine.LFD.1.00.0802110822450.2920@woody.linux-foundation.org>
References: <20080211074313.GA23195@kroah.com>  <20080211074346.GB23195@kroah.com> <1202729485.24584.5.camel@bazbox.opcode-solutions.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 11 Feb 2008, Matthew Keenan wrote:
> 
> Maybe I'm missing something here, but is there are reason that the patch
> for 2.6.22 differs from 2.6.2[34]? The "if(unlikely(!base))" is removed
> in the latter.

No real reason, except that there are simply two versions of the patches 
floating around: the original (that added the "access_ok()"), and the one 
I actually applied to the development tree (in which I hand-edited the 
patch to remove the old "!base" comparison, since I thought that one was 
just wrong).

Which one you prefer is probably a matter of taste, and which one you 
ended up picking up is probably a matter of just luck. They are basically 
the same, with the only difference being whether you think NULL is special 
or not. I don't personally think it should be, and if people want to put 
data at their linear address zero, they may have reasons for it (vm86 mode 
is one such reason, things like wine might be another - basically some 
environments may have legacy reasons to think that address 0 can be 
something else than just NULL).

For any *normal* program, this should be totally immaterial, since address 
0 won't be mapped, and you'll just take an EFAULT later. And from the 
security standpoint in this particular case, address 0 is a perfectly 
normal user address, so there is nothing special about it.

[ What _is_ special about address 0 is that if the kernel forgets some 
  NULL pointer check, we'd want to see an oops, not a user space access. 

  But that's really a totally different class of bug, and quite frankly, 
  if you want to disallow people mmap'ing at offset zero, it's an mmap() 
  issue, not anything else. See the new SECURITY_DEFAULT_MMAP_MIN_ADDR 
  thing for that. ]

In this particular case, maybe some -stable person might have felt that 
they just didn't want to change semantics for the NULL pointer, or maybe 
they didn't even notice that what I committed to the development tree was 
slightly changed. It _really_ doesn't matter.

			Linus
