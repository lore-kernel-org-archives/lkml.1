Return-Path: <linux-kernel-owner+w=401wt.eu-S1755399AbYBJUly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399AbYBJUly (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 15:41:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753743AbYBJUlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 15:41:44 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44916 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753522AbYBJUln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 15:41:43 -0500
Date: Sun, 10 Feb 2008 21:41:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jan Kiszka <jan.kiszka@web.de>, Ray Lee <ray-lk@madrabbit.org>,
       Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@zip.com.au>, Thomas Gleixner <tglx@linutronix.de>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [git pull] kgdb light, v5
Message-ID: <20080210204124.GA26701@elte.hu>
References: <20080210071304.GA3788@elte.hu> <20080210104709.GB10790@uranus.ravnborg.org> <20080210163603.GB28201@elte.hu> <2c0942db0802100930y5338e545k808d996f9a19bac@mail.gmail.com> <47AF483E.10905@web.de> <alpine.LFD.1.00.0802101134470.2896@woody.linux-foundation.org> <20080210202930.GA25889@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080210202930.GA25889@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> all other places already use probe_kernel_{read|write}. (Now, there 
> are a few stray TASK_SIZE checks still, i'll double check them and 
> convert them to access_ok() checks.)

all the TASK_SIZE checks relate to the soft breakpoint write accesses.

and access_ok() does not cut it: it's also a bit dangerous from debug 
context: uses current->address_space, which is task dependent and can 
accidentally allow an int3 write to userspace if executed in a kernel 
thread that has lazy-inherited the TLB from a user task, etc., and it 
also does not give enough protection on some other architectures.

is_kernel_text() is not good, because it does not cover modules. 
is_module_address() is not good either, because it also covers module 
data areas, and is a bit thick (hence crash-risky) as well. So there's 
no existing facility to cover this.

so i'd say the safest would be to remove the TASK_SIZE check altogether. 
If someone typoes a raw breakpoint - it is still enumerated by gdb and 
can still be cleared. It's not like kgdb cannot be used to shoot in 
one's own foot ...

	Ingo
