Return-Path: <linux-kernel-owner+w=401wt.eu-S932870AbZJHW6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932870AbZJHW6U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 18:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932481AbZJHW6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 18:58:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:36868 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757447AbZJHW6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 18:58:18 -0400
Subject: Re: [RFC][PATCH] kmap_atomic_push
From: Peter Zijlstra <peterz@infradead.org>
To: jim owens <jowens@hp.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-arch <linux-arch@vger.kernel.org>
In-Reply-To: <4ACE674E.30403@hp.com>
References: <1255016123.17055.17.camel@laptop>
	 <20091008155344.GA11727@elte.hu> <1255019362.26976.311.camel@twins>
	 <alpine.LFD.2.01.0910080945230.3432@localhost.localdomain>
	 <Pine.LNX.4.64.0910081850270.4553@sister.anvils>  <4ACE674E.30403@hp.com>
Content-Type: text/plain
Date: Fri, 09 Oct 2009 00:57:16 +0200
Message-Id: <1255042636.17055.33.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-08 at 18:27 -0400, jim owens wrote:
> So if I understand this correctly, the sequence:
> 
> in = kmap_atomic(inpage, KM_USER1);
> 
> out = kmap_atomic(outpage, KM_USER0);
> 
> kunmap_atomic(in, KM_USER1);
> 
> in = kmap_atomic(next_inpage, KM_USER1);
> 
> is now illegal with this patch, which breaks code
> I am testing now for btrfs.
> 
> My code does this because the in/out are zlib inflate
> and the in/out run at different rates.

You can do things like:

do {
 in = kmap_atomic(inpage);
 out = kmap_atomic(outpage);

 <deflate until end of either in/out>

 kunmap_atomic(outpage);
 kunmap_atomic(inpage);

 cond_resched();

 <iterate bits>

} while (<not done>)

The double unmap gives a preemption point, which sounds like a good
thing to have, because your scheme could run for a long while without
enabling preemption, which is badness.

