Return-Path: <linux-kernel-owner+w=401wt.eu-S1030361AbXBZRbE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030361AbXBZRbE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 12:31:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030364AbXBZRbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 12:31:04 -0500
Received: from madara.hpl.hp.com ([192.6.19.124]:50867 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030361AbXBZRbC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 12:31:02 -0500
Date: Mon, 26 Feb 2007 09:28:55 -0800
From: Stephane Eranian <eranian@hpl.hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jiri Slaby <jirislaby@gmail.com>, Uwe Bugla <uwe.bugla@gmx.de>,
       akpm@linux-foundation.org, bunk@stusta.de, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, venkatesh.pallipadi@intel.com
Subject: Re: bug in kernel 2.6.21-rc1-git1: conventional floppy drive cannot be mounted without hanging up the whole system
Message-ID: <20070226172855.GB19403@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <20070224175424.176030@gmx.net> <45E2B88B.1090706@gmail.com> <45E2F8C5.3080905@gmail.com> <Pine.LNX.4.64.0702260741040.12485@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702260741040.12485@woody.linux-foundation.org>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Feb 26, 2007 at 07:51:19AM -0800, Linus Torvalds wrote:
> 
> 
> On Mon, 26 Feb 2007, Jiri Slaby wrote:
> > 
> > Ok, this commit is the culprit:
> > Commit: 2ff2d3d74705d34ab71b21f54634fcf50d57bdd5
> > Author: Stephane Eranian <eranian@hpl.hp.com> Tue, 13 Feb 2007 13:26:22 +0100
> > 
> >     [PATCH] i386: add idle notifier
> 
> Interesting. It doesn't touch floppy at all, but it *does* seem to play 
> around with irq state. 
> 
> In particular, the floppy uses IRQF_DISABLED (which means that it doesn't 
> want interrupts enabled when in the irq handler), and I get the feeling 
> that the poll_idle() stuff made that not work.
> 
> That said, the only thing that *really* seems to change (as far as a 
> floopy driver could notice) is the added "exit_idle()" in the do_IRQ() 
> sequence, and I'm not seeing that one enabling interrupts. 
> 
> But the idle sequence definitely does (ie now we disable/enable interrupts 
> in cpu_idle(). I'm not seeing why that should matter, though.
> 
> Stephane, any ideas?
> 
I think this may be related to the issue fixed by Venkatesh here:
	http://www.ussg.iu.edu/hypermail/linux/kernel/0611.3/1264.html

The same code was used for i386 but I think for both architectures, the patch
is missing default_idle(). I believe deault idle should look as follows:

void default_idle(void)
{
        if (!hlt_counter && boot_cpu_data.hlt_works_ok) {
                current_thread_info()->status &= ~TS_POLLING;
                /*
                 * TS_POLLING-cleared state must be visible before we
                 * test NEED_RESCHED:
                 */
                smp_mb();

                local_irq_disable();
                if (!need_resched())
                        safe_halt();    /* enables interrupts racelessly */
                else
                        local_irq_enable();
                current_thread_info()->status |= TS_POLLING;
        } else {
                /* loop is done by the caller */
---->		local_irq_enable();
                cpu_relax();
        }
}
I do not have any machine with floppy drives. Could you try this?

Thanks.

-- 
-Stephane
