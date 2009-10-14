Return-Path: <linux-kernel-owner+w=401wt.eu-S1759525AbZJNVDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759525AbZJNVDT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 17:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755400AbZJNVDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 17:03:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36015 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750885AbZJNVDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 17:03:17 -0400
Date: Wed, 14 Oct 2009 14:02:10 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Boyan <btanastasov@yahoo.co.uk>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Oleg Nesterov <oleg@redhat.com>,
       Paul Fulghum <paulkf@microgate.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, Ed Tomlinson <edt@aei.ca>,
       hirofumi@mail.parknet.co.jp
Subject: Re: [Bug #14388] keyboard under X with 2.6.31
In-Reply-To: <4AD62DAD.9010604@yahoo.co.uk>
Message-ID: <alpine.LFD.2.01.0910141356400.6146@localhost.localdomain>
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera> <C4F8B19E-F4B4-47F3-AE5B-4581C8E3F3AE@gmail.com> <87ljjgfcbu.fsf@spindle.srvr.nix> <alpine.LFD.2.01.0910121703390.3438@localhost.localdomain> <alpine.LFD.2.01.0910122004200.3438@localhost.localdomain>
 <4AD3F769.5080405@gmail.com> <alpine.LNX.2.01.0910130405200.9297@dyndns.pervalidus.net> <4AD437F9.9020708@yahoo.co.uk> <alpine.LFD.2.01.0910130745550.3438@localhost.localdomain> <4AD4DE4C.4010402@yahoo.co.uk> <alpine.LFD.2.01.0910131317360.26777@localhost.localdomain>
 <4AD4F548.2030506@microgate.com> <alpine.LFD.2.01.0910131514100.3404@localhost.localdomain> <1255478932.19056.24.camel@localhost.localdomain> <4AD51D6B.7010509@microgate.com> <alpine.LFD.2.01.0910131744590.3404@localhost.localdomain>
 <20091014125846.1a3c8d40@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0910140804180.6146@localhost.localdomain> <alpine.LFD.2.01.0910140925440.6146@localhost.localdomain> <4AD62DAD.9010604@yahoo.co.uk>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 14 Oct 2009, Boyan wrote:
> 
> Works for me. I couldn't reproduce the problem with only this patch on
> top of  2.6.31.4.

So just to verify: both the flush_to_ldisc() patch _and_ the 
"flush_delayed_work()" one fixed the problem for you? And you tested them 
independently? And you said you could reliably trigger it before?

Ok, that makes me happy, because it implies that this really is the root 
cause, with two different approaches to fixing the same problem both 
working independently of each other.

So if you confirm that I understand your test situation right, I will 
probably commit them both: I think the flush_to_ldisc() patch is a real 
locking improvement regardless of whether we then avoid calling it in a 
nested manner or not, and the flush_delayed_work() thing seems to be the 
right thing(tm) to do too.

Besides, even with the flush_delayed_work() thing, we're still faced with 
the theory of multiple keventd threads running the flush_to_ldisc on 
separate CPU's. Even though it's probably unlikely enough to never happen.

			Linus
