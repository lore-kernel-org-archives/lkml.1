Return-Path: <linux-kernel-owner+w=401wt.eu-S1753282AbXJWAHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282AbXJWAHa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 20:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751178AbXJWAHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 20:07:20 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57891
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751162AbXJWAHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 20:07:19 -0400
Date: Mon, 22 Oct 2007 17:07:41 -0700 (PDT)
Message-Id: <20071022.170741.41638232.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: alan@lxorguk.ukuu.org.uk, geert@linux-m68k.org, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu, linux-m68k@vger.kernel.org
Subject: Re: [PATCH 09/10] Change table chaining layout
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.0.999.0710221444220.30120@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0710221343330.30120@woody.linux-foundation.org>
	<20071022224343.4abf3c96@the-village.bc.nu>
	<alpine.LFD.0.999.0710221444220.30120@woody.linux-foundation.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 22 Oct 2007 14:47:38 -0700 (PDT)

> On Mon, 22 Oct 2007, Alan Cox wrote:
> 
> > Still doesn't answer the rather more important question - why not just
> > stick a NULL on the end instead of all the nutty hacks ?
> 
> You still do need one bit for the discontiguous case, so it's not like you 
> can avoid the hacks anyway (unless you just blow up the structure 
> entirely) and make it a separate member). So once you have that 
> bit+pointer, using a separate NULL entry isn't exactly prettier. 
> 
> Especially as we actally want to see the difference between 
> "end-of-allocation" and "not yet filled in", so you shouldn't use NULL 
> anyway, you should probably use something like "all-ones".

Indeed that's the crux of the matter, we need to express a trinary
state "end of scatterlist, next entry is linear, next entry is
indirect" plus a pointer for the indirect case.

Generally, Jens was doing a good job cooking up the patch that
implemented this fully and I took care of making sure tricky
ports like sparc64 built cleanly etc.

He went away for a few days, but when he gets back we should seriously
work on integrating his work.

I fully recognize Alan's m68k on-stack alignment concern.  The on-stack
cases are troublesome in other ways as well, and I think therefore the
way to move forward is to convert those to some kind of dynamic scheme.
Usually such code is working in a locked context on some object
(crypto instance, for example) and thus the scatterlist chunk can
be embedded into that object for ensured alignment.
