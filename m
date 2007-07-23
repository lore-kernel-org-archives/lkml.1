Return-Path: <linux-kernel-owner+w=401wt.eu-S933248AbXGWD07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933248AbXGWD07 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 23:26:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758559AbXGWD0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 23:26:50 -0400
Received: from smtpout.mac.com ([17.250.248.171]:63547 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853AbXGWD0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 23:26:49 -0400
In-Reply-To: <alpine.LFD.0.999.0707191100480.27353@woody.linux-foundation.org>
References: <20070718235504.GA9601@havoc.gtf.org> <alpine.LFD.0.999.0707181834070.27353@woody.linux-foundation.org> <469ECD29.2010909@garzik.org> <m3r6n4bjgg.fsf@maximus.localdomain> <alpine.LFD.0.999.0707191100480.27353@woody.linux-foundation.org>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <BF1FF315-482E-4ABF-8159-881C3426C28C@mac.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>, Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, ak@suse.de, adaplas@gmail.com,
       linux-fbdev-devel@lists.sourceforge.net, benh@kernel.crashing.org
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [git patches] two warning fixes
Date: Sun, 22 Jul 2007 23:26:09 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 19, 2007, at 14:04:29, Linus Torvalds wrote:
> On Thu, 19 Jul 2007, Krzysztof Halasa wrote:
>> Jeff Garzik <jeff@garzik.org> writes:
>>> My overall goal is killing useless warnings that continually  
>>> obscure real ones.
>>
>> Precisely, the goal should be to make must_check (and similar  
>> things) warn only in real cases.
>
> .. the problem with that mentality is that it's not how people work.
>
> People shut up warnings by adding code.
>
> Adding code tends to add bugs.
>
> People don't generally think "maybe that warning was bogus".
>
> More people *should* generally ask themselves: "was the warning  
> worth it?" and then, if the answer is "no", they shouldn't add  
> code, they should remove the thing that causes the warning in the  
> first place.
>
> For example, for compiler options, the correct thign is often to  
> just say "that option was broken", and not use "-fsign-warning",  
> for example. We've literally have had bugs *added* because people  
> "fixed" a sign warning.  More than once, in fact.
>
> Every time you see a warning, you should ask yourself: is the  
> warning interesting, correct and valid? And if it isn't all three,  
> then the problem is whatever *causes* the warning, not the code  
> itself.

I agree that there are a fair number of things (like the sysfs calls)  
that should just WARN() when they hit an error, but I also think that  
we're currently missing a *lot* of __must_check's that we should  
have.  For example a friend of mine was having problems with an HDAPS  
patch where it just kind of hung.  Turns out the problem was that the  
code blithely called scsi_execute_async() and then put itself to  
sleep on a completion... except scsi_execute_async() returned failure  
and the completion would never complete.

For instance, I would bet that a fair number of the other int- 
returning functions in include/scsi/scsi_device.h want __must_check  
on them.  That said, the person adding the __must_check should be  
REQUIRED to do at least a superficial audit of the code.

I'd propose a few simple rules:
   (1) If it can return the only pointer to freshly-allocated pointer  
then it's __must_check
   (2) If it can return a hard error which the caller must handle  
specially, then it's __must_check
   (3) If the only possible error is a kernel bug then make the damn  
thing return void and give it a big fat WARN() when it fails.
   (4) For any other case (or if you are unsure), don't flag it.

And of course the burden of proof is on the person trying to add the  
__must_check.

Cheers,
Kyle Moffett

