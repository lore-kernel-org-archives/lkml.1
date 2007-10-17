Return-Path: <linux-kernel-owner+w=401wt.eu-S1764098AbXJQQwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764098AbXJQQwn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 12:52:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754566AbXJQQwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 12:52:34 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50618 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754539AbXJQQwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 12:52:33 -0400
Date: Wed, 17 Oct 2007 09:50:32 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [bug] block subsystem related crash with latest -git
In-Reply-To: <20071017154655.GA13394@elte.hu>
Message-ID: <alpine.LFD.0.999.0710170929270.26902@woody.linux-foundation.org>
References: <20071017154655.GA13394@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 17 Oct 2007, Ingo Molnar wrote:
> 
> Jens, just got this crash on a testbox:

The code in question is:

     mov    %edx,0xc(%esp)
     mov    (%ebx),%edi
     mov    %edi,%edx
     sub    %eax,%edx
     mov    %edx,%eax
     sar    $0x5,%eax
     shl    $0xc,%eax
     add    0x8(%ebx),%eax
     cmp    %eax,0xc(%esp)
     je     +126
     mov    0x10(%esi),%eax	<----- Oops
     lea    0x10(%esi),%edx
     test   $0x1,%al
     jne    +76
     mov    %edi,(%esi)
     mov    %ebp,0xc(%esi)
     mov    0x8(%ebx),%eax
     mov    %eax,0x4(%esi)


and it looks like %esi is overflowing from one page to the next one, ie:

	BUG: unable to handle kernel paging request at virtual address 7ca76000
	ESI: 7ca75ff0

and you caught this thanks to page-alloc debugging again.

I think I can match that up with the source code: that's "sg_next()". It's 
doing:

        sg++;

        if (unlikely(sg_is_chain(sg)))
                sg = sg_chain_ptr(sg);

        return sg;

and the oopsing instruction is that load of "sg->page" in the assembly 
code:

	mov    0x10(%esi),%eax		# %eax = sg->page
	lea    0x10(%esi),%edx		# %edx = sg+1;
	test   $0x1,%al			# if (unlikely(sg_is_chain()))
	jne    +76

Jens?

		Linus
