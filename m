Return-Path: <linux-kernel-owner+w=401wt.eu-S1756581AbYBXUyE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581AbYBXUyE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 15:54:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752878AbYBXUxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 15:53:52 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:58519 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752825AbYBXUxv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 15:53:51 -0500
Message-Id: <1203886430.22409.1238738169@webmail.messagingengine.com>
X-Sasl-Enc: JgU/meAomgvlOw45pAffM5vfkxIMviohPThWKyzUc+AA 1203886430
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "Andi Kleen" <ak@suse.de>, "Thomas Gleixner" <tglx@linutronix.de>,
       "LKML" <linux-kernel@vger.kernel.org>,
       "Alexander van Heukelum" <heukelum@mailshack.com>
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <20080224174605.GA21661@mailshack.com> <20080224194121.GA26451@elte.hu>
Subject: Re: [PATCH] Fix alignment of early reservation for EBDA
In-Reply-To: <20080224194121.GA26451@elte.hu>
Date: Sun, 24 Feb 2008 21:53:50 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Feb 2008 20:41:21 +0100, "Ingo Molnar" <mingo@elte.hu> said:
> 
> * Alexander van Heukelum <heukelum@mailshack.com> wrote:
> 
> > Hi Andi,
> > 
> > My eyes fell on the following table in the boot messages:
> > 
> > early res: 0 [0-fff] BIOS data page
> > early res: 1 [6000-7fff] SMP_TRAMPOLINE
> > early res: 2 [200000-374557] TEXT DATA BSS
> > early res: 3 [9fc00-a0bff] EBDA
> > early res: 4 [8000-afff] PGTABLE
> > 
> > The memory reserved for the EBDA overflows into the area normally 
> > reserved for the VGA adaptor. It seems that you wanted to force the 
> > allocation to cover whole pages, like:
> 
> well, that's what your EBDA descriptor says - it's set to 9fc00 which is 
> 512 bytes below the VGA range.

It's 1024 bytes below, but yes, the EBDA starts there. Then the first
two
bytes of the EBDA contain the value 0x0001, which means that its size is
1kb, so the BIOS is correct.

> This behavior didnt really change over 
> v2.6.24 (which reserved 'into' the VGA range too), it's just that in 
> v2.6.25 we also print out these early reservations.

Correct. I thought it was new code, but looking more closely, the
behaviour
has indeed not changed recently (note to self: git log -p somefile.c
does
not indicate in any way that code was moved from some other place.)

> Can you see any 
> regression? There should be no harm from overlapping into the VGA range 
> - these "reservations" only make RAM unavailable for normal allocations.

No regressions, it's just cosmetic.

> your patch on the other hand rounds the EBDA area down which could in 
> theory be unsafe on other boxes (where there could be real RAM above the 
> EBDA area): the safest approach is to round the beginning of it down, 
> the end of it up (to page boundary).

Not really: ebda_addr is just a local variable. If the system needs to
find the start of the EBDA, it will just have to look at the 16 bit
value
at address 0x40E again.

> Your patch _should_ be OK, but in 
> practice it doesnt hurt to reserve a bit more around the edges than to 
> accidentally give a page to the OS that the BIOS might rely upon.

The patch is exactly trying to do that. The code that was there seemed
to
imply that the author wanted to allocate whole pages, in such a way that
the allocation contained the whole EBDA. I think that is what it does
after this patch.

Greetings,
    Alexander
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - And now for something completely different…

