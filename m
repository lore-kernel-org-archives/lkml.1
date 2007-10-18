Return-Path: <linux-kernel-owner+w=401wt.eu-S1764934AbXJRBIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764934AbXJRBIl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 21:08:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763605AbXJRBIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 21:08:16 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33864 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762090AbXJRBIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 21:08:15 -0400
Date: Wed, 17 Oct 2007 18:07:19 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
cc: jens.axboe@oracle.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       jgarzik@pobox.com, alan@lxorguk.ukuu.org.uk, tomof@acm.org
Subject: Re: [bug] ata subsystem related crash with latest -git
In-Reply-To: <20071018080048O.fujita.tomonori@lab.ntt.co.jp>
Message-ID: <alpine.LFD.0.999.0710171801000.26902@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0710171321400.26902@woody.linux-foundation.org>
 <20071017203140.GF15552@kernel.dk> <alpine.LFD.0.999.0710171342550.26902@woody.linux-foundation.org>
 <20071018080048O.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 18 Oct 2007, FUJITA Tomonori wrote:
> 
> Looks that (sglist) - 1 isn't initialized and we use sg_next for it?

sg_next() - as it stands now - never actually looks at the SG that its 
argument points to: it explicitly *only* looks at the next one.

That's the bug. If sg_next() looked at the actual *current* sg entry, we 
wouldn't have any issues to begin with, and that's what I'm arguing we 
should do in the longer run (where "longer run" is defined as "when Jens 
does it asap").

So the hacky solution as it stands right now is to actually use the 
behaviour of "sg_next()" to our advantage in for_each_sg(), and starting 
off by setting sg to (sglist)-1. That way we can do the "sg_next()" (which 
will *not* look at the uninitialized space before the array) before 
entering the loop, regardless of whether it's the first time through the 
loop or not.

So no, it's not technically "strictly conforming ANSI C", because we use a 
pointer (not do not dereference it!) outside of its allocation, which is 
strictly speaking against the standard. However, the kernel does those 
kinds of things all the time, since the kernel does its own memory 
allocation, so that's not actually relevant.

The *standard* may say that you cannot decrement a pointer to before the 
beginning of the object and then increment it back up again and be 
strictly conforming, but the fact is, we very much depend on contiguous 
and flat kernel pointer model, and always have (and probably always will)

		Linus
