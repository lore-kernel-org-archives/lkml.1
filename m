Return-Path: <linux-kernel-owner+w=401wt.eu-S1756384AbYBJUaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756384AbYBJUaA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 15:30:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753011AbYBJU3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 15:29:53 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59939 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752744AbYBJU3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 15:29:52 -0500
Date: Sun, 10 Feb 2008 21:29:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jan Kiszka <jan.kiszka@web.de>, Ray Lee <ray-lk@madrabbit.org>,
       Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@zip.com.au>, Thomas Gleixner <tglx@linutronix.de>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [git pull] kgdb light, v5
Message-ID: <20080210202930.GA25889@elte.hu>
References: <20080210071304.GA3788@elte.hu> <20080210104709.GB10790@uranus.ravnborg.org> <20080210163603.GB28201@elte.hu> <2c0942db0802100930y5338e545k808d996f9a19bac@mail.gmail.com> <47AF483E.10905@web.de> <alpine.LFD.1.00.0802101134470.2896@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802101134470.2896@woody.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > +static int kgdb_get_mem(char *addr, unsigned char *buf, int count)
> >  {
> > +	if ((unsigned long)addr < TASK_SIZE)
> > +		return -EFAULT;
> >  
> > +	return probe_kernel_read(buf, addr, count);
> >  }
> 
> Ok, so this is a pretty function after all the cleanups, but I 
> actually don't think that "if ((unsigned long)addr < TASK_SIZE)" is 
> really even asked for.
> 
> Why not let kgdb look at user memory? I'd argue that in a lot of 
> cases, it might be quite nice to do, to see what user arguments in 
> memory are etc etc (think things like futexes, where user memory 
> contents really do matter).
> 
> So I'd suggest getting rid of the whole "kgdb_{get|set}_mem()" 
> functions, and just using "probe_kernel_{read|write}()" directly 
> instead.

ok, on a second thought: kgdb_{get|set}_mem() is _only_ used to validate 
and set the software breakpoint (int3). And i think kgdb correctly 
restricts that to kernel-space addresses only - you can typo an address 
down into user-space and overwrite user-space memory and not know what 
hit you ... [you can still explicitly touch user-space memory, but that 
has to be done intentionally]

So to reduce the confusion i've removed these functions and open-coded 
the probe_kernel_*() functions into kgdb_validate_break_address() and 
kgdb_arch_set_breakpoint().

all other places already use probe_kernel_{read|write}. (Now, there are 
a few stray TASK_SIZE checks still, i'll double check them and convert 
them to access_ok() checks.)

btw., based on your previous comment about alignment, i found another 
function that used weird alignment checks, kgdb_hex2mem():

	if (count == 2 && ((long)mem & 1) == 0)
		err = probe_kernel_write(mem, tmp_raw, 2);
	else if (count == 4 && ((long)mem & 3) == 0)
		err = probe_kernel_write(mem, tmp_raw, 4);
	else if (count == 8 && ((long)mem & 7) == 0)
		err = probe_kernel_write(mem, tmp_raw, 8);
	else
		err = probe_kernel_write(mem, tmp_raw, count);

	return err;
}

I just converted it to:

	return probe_kernel_write(mem, tmp_raw, count);

which looks _a lot_ cleaner.

	Ingo
