Return-Path: <linux-kernel-owner+w=401wt.eu-S1755433AbYAENWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433AbYAENWR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 08:22:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754277AbYAENWD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 08:22:03 -0500
Received: from one.firstfloor.org ([213.235.205.2]:48083 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400AbYAENWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 08:22:01 -0500
Date: Sat, 5 Jan 2008 14:24:02 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Russell Leidich <rml@google.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Torsten Kaiser <just.for.lkml@googlemail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       valdis.kletnieks@vt.edu, thockin@google.com
Subject: Re: [PATCH] AMD Thermal Interrupt Support
Message-ID: <20080105132402.GA705@one.firstfloor.org>
References: <p731w9410yc.fsf@bingen.suse.de> <3f1a065b0801021143y5fc15e29r4201ac19bc7c1daa@mail.gmail.com> <20080102200039.GA13784@one.firstfloor.org> <3f1a065b0801021312w6f823cbeh9ea6b73d2b0c46c8@mail.gmail.com> <64bb37e0801021333g3cccff81k68df75463e4a21d0@mail.gmail.com> <3f1a065b0801021350x7fd065fbj9680ce1a4f3c6538@mail.gmail.com> <20080102215433.GB13784@one.firstfloor.org> <3f1a065b0801041333x579d0a8fs9c5535f95dd56015@mail.gmail.com> <20080104222637.GA19248@one.firstfloor.org> <3f1a065b0801041653y77c27a8cvce703cb7d13e10a0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f1a065b0801041653y77c27a8cvce703cb7d13e10a0@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> But if PCI locks are spinlocks, then how can one access config space
> in an interrupt handler, as it might be locked by the foreground?  (No

They disable interrupts

> locks would be required at all, if everyone just saved 0xCF8 and
> 0xCFC, but I digress.)  

Not sure what you mean? Since it is two non atomic accesses even
saving restoring the registers would not make the accesses safe for lockless.
If someone changes 0xcf8 before you can access 0xcfc you always have
a problem.

In fact we had (or still have) races with some older user land accessing these
ports directly.

The only access method that is lockless is mmconfig, which will work
on most (but not all) Fam10h systems.

> And it's one thing to be "likely" already in a
> thread, and another to be sure.  If you can address these issues, I'll
> change or remove the comment.  I just want to prevent a
> reasonable-looking but bad coding change from happening in the future.

Well at least as written the comment is not quite correct.
> 
> 
> Agreed.  I had it at the top of the function, but now I've worked it
> into both places.
> 
> >
> > Anyways I'm unsure about the blacklist here -- white list would
> > probably have been better. k8_northbridges[] will certainly include
> > Griffin northtbridges and who knows if TT will work there or not.
> > [sorry for mentioning that not earlier]
> 
> Ideally, every ID in the k8_northbridges[] whitelist would have

k8_northbridges[] is used by various subsystems, most of them
do not care at all about thermal throttling.

> functional thermal throttling.  If more IDs than 0x1103 turn out to
> have this feature broken, then we may need to add a blacklist as well.

? you already got a blacklist ? 

>  But I expect that most future IDs will function correctly, hence my
> reliance on the whitelist. 

? but you don't have a whitelist, you have a black list.

> In my view, anyone who adds an ID to a
> whitelist (or just a list, for that matter) is obligated to perform a
> static analysis (i.e. grep for "k8_northbridges") of the implications
> of such act; 

That view would require the whitelist.

-Andi
