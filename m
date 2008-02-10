Return-Path: <linux-kernel-owner+w=401wt.eu-S1755519AbYBJUTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519AbYBJUTc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 15:19:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753684AbYBJUTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 15:19:24 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50532 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753351AbYBJUTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 15:19:23 -0500
Date: Sun, 10 Feb 2008 21:19:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jan Kiszka <jan.kiszka@web.de>, Ray Lee <ray-lk@madrabbit.org>,
       Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@zip.com.au>, Thomas Gleixner <tglx@linutronix.de>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [git pull] kgdb light, v5
Message-ID: <20080210201904.GB24677@elte.hu>
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
> 
> Ok, so this is a pretty function after all the cleanups, but I 
> actually don't think that "if ((unsigned long)addr < TASK_SIZE)" is 
> really even asked for.
> 
> Why not let kgdb look at user memory? I'd argue that in a lot of 
> cases, it might be quite nice to do, to see what user arguments in 
> memory are etc etc (think things like futexes, where user memory 
> contents really do matter).

yes. We should allow kgdb to look at just about anything that can be 
done safely - and we've got all the necessary protections against 
pagefaults via pagefault_disable().

> So I'd suggest getting rid of the whole "kgdb_{get|set}_mem()" 
> functions, and just using "probe_kernel_{read|write}()" directly 
> instead.
> 
> (Not that I necessarily love those names either, but whatever..)
> 
> The TASK_SIZE checks make more sense in kgdb_validate_break_address() 
> and friends, where it actually does make sense to check that it's 
> really a *kernel* address.
> 
> But even there, I'm not sure if the right check is to compare against 
> TASK_SIZE, since kernel and user memory addresses can in theory be 
> distinct (that's why we have "set_fs()" historically, and while it's 
> no longer true on x86 and hasn't been in a long time, the kernel 
> conceptually allows it - see my previous reply about that whole 
> get_fs/set_fs thing in the definition of probe_kernel_read/write).

hm, is access_ok() safe on all architectures from irq context? That's 
the cross-arch equivalent of TASK_SIZE checks normally.

> > +	if (count == 2 && ((long)mem & 1) == 0)
> > +		err = probe_kernel_read(tmp, mem, 2);
> > +	else if (count == 4 && ((long)mem & 3) == 0)
> > +		err = probe_kernel_read(tmp, mem, 4);
> > +	else if (count == 8 && ((long)mem & 7) == 0)
> > +		err = probe_kernel_read(tmp, mem, 8);
> > +	else
> > +		err = probe_kernel_read(tmp, mem, count);
> 
> There's absolutely no reason to care about the alignment, since if you 
> now use "probe_kernel_read()", the sane thing to do is to just do
> 
> 	err = probe_kernel_read(tmp, mem, count);
> 	if (!err) {
> 		while (count > 0) {
> 			buf = pack_hex_byte(buf, *tmp);
> 			tmp++;
> 			count--;
> 	}
> 
> and you're all done. No?

yes, the full function now looks like this:

int kgdb_mem2hex(char *mem, char *buf, int count)
{
	char *tmp;
	int err;

	/*
	 * We use the upper half of buf as an intermediate buffer for the
	 * raw memory copy.  Hex conversion will work against this one.
	 */
	tmp = buf + count;

	err = probe_kernel_read(tmp, mem, count);
	if (!err) {
		while (count > 0) {
			buf = pack_hex_byte(buf, *tmp);
			tmp++;
			count--;
		}

		*buf = 0;
	}

	return err;
}

i'll test this a bit.

	Ingo

