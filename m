Return-Path: <linux-kernel-owner+w=401wt.eu-S1764297AbXG3OyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764297AbXG3OyW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 10:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754036AbXG3OyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 10:54:13 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:46842 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbXG3OyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 10:54:11 -0400
Date: Mon, 30 Jul 2007 16:55:43 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Satyam Sharma <satyam@infradead.org>
Cc: Chris Friesen <cfriesen@nortel.com>, David Woodhouse <dwmw2@infradead.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Satyam Sharma <satyam.sharma@gmail.com>
Message-ID: <20070730145542.GG9840@enneenne.com>
References: <20070727184418.GV9840@enneenne.com> <46AA42CA.4060004@nortel.com> <20070727192848.GW9840@enneenne.com> <46AA4A1E.8040302@nortel.com> <20070727194516.GX9840@enneenne.com> <a781481a0707271347w53dd9755j87e7762cfe953777@mail.gmail.com> <20070729091709.GY9840@enneenne.com> <alpine.LFD.0.999.0707300943550.10861@enigma.security.iitk.ac.in> <20070730083259.GD9840@enneenne.com> <alpine.LFD.0.999.0707301425540.13448@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0707301452380.13448@enigma.security.iitk.ac.in> <alpine.LFD.0.999.0707301438190.13448@enigma.security.iitk.ac.in> <alpine.LFD.0.999.0707301425540.13448@enigma.security.iitk.ac.in>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: LinuxPPS & spinlocks
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2007 at 02:37:26PM +0530, Satyam Sharma wrote:
> On Mon, 30 Jul 2007, Rodolfo Giometti wrote:
> > 
> > In pps_event() is not useful using spin_lock_irqsave/restore() since
> > the only difference between spin_lock_irqsave() and spin_lock() is
> > that the former will turn off interrupts if they are on, otherwise
> > does nothing (if we are already in an interrupt handler).
> 
> Yup. But two pps_event()'s on different CPU's could still race.

??? :-o

Maybe one CPU spins 'till the other holds the lock but any races
should happen...

> > Maybe you meant I should using spin_lock_irqsave/restore() in user
> > context, but doing like this I will disable interrupts
> 
> Yup, but the goal is to avoid races. Otherwise why bother doing any
> locking at all?

I meant that if you have to lock between user context and interrupt
context you have two choises:

1) using spin_lock_irqsave/restore() in user context and spin_lock/unlock()
in the interrupt context (as Rusty says),

2) or using spin_lock/unlock() in user context and
spin_trylock/unlock() in the interrupt context in order to avoid dead
locks.

Is that correct?

> > Of course, I meant "protecting data". In fact to protect pps_source[]
> > I need spin_lock() to protect user context from interrupt context and
> > mutex to protect user context from itself.
> 
> But that's nonsensical! That's not how you implement locking!
> 
> First, spin_lock() is *not* enough to protect access from process context
> from access from interrupt context.
> 
> Second, if you *already* have a lock to protect any data, introducing
> *another* lock to protect the same data is ... utterly crazy!

I see what you mean. But my question is about using spin_locks where
we can sleep. Let me explain, consider sys_time_pps_getparams():

   asmlinkage long sys_time_pps_getparams(int source,
                                           struct pps_kparams __user *params)
   {
           int ret = 0;

           pr_debug("%s: source %d\n", __FUNCTION__, source);

           /* Sanity checks */
           if (!params)
                   return -EINVAL;

           if (mutex_lock_interruptible(&pps_mutex))
                   return -EINTR;

           ret = pps_check_source(source);
           if (ret < 0) {
                   ret = -ENODEV;
                   goto sys_time_pps_getparams_exit;
           }

           /* Return current parameters */
           ret = copy_to_user(params, &pps_source[source].params,
                                                   sizeof(struct pps_kparams));
           if (ret)
                   ret = -EFAULT;

   sys_time_pps_getparams_exit:
           mutex_unlock(&pps_mutex);

           return ret;
   }

The copy_to_user() may sleep and if I change
mutex_lock_interruptible() with a spin_lock I may hold it and then
going to sleep... using mutex we can use the CPU for other
computations.

> > I see. But consider pps_register_source(). This function should
> > provide protection of pps_source against both interrupt context
> > (pps_event()) and user context (maybe pps_unregister_source() or one
> > syscalls). Using only mutex is not possible, since we cannot use mutex
> > in interrupt context, and using only spin_locks is not possible since
> > in UP() they became void.
> 
> Yup, but that's okay. On UP, spin_lock_irqsave() becomes local_irq_save()
> which is what you want anyway on UP.

But doing like this may happen that I first execute local_irq_save()
and then go to sleep due copy_to_user()? :-o

> The simplest, most straightforward, and safest, most correct, way would
> be to just use spin_lock_irqsave/restore() to around all access to the
> shared/global data, from _any_ context.

Even if I may sleep while holding a spinlock? Rusty says here
(http://www.kernel.org/pub/linux/kernel/people/rusty/kernel-locking/c557.html)
that:

   Many functions in the kernel sleep (ie. call schedule()) directly
   or indirectly: you can never call them while __holding a
   spinlock__, or with preemption disabled. This also means you need
   to be in user context: calling them from an interrupt is illegal.

> Anyway, I'll try and see if I find some time this week to implement
> what I was mentioning ...

Thanks a lot, so we can discuss on code. :)

> > That's the point. I don't wish using _irqsave/restore() since they may
> > delay interrupt handler execution. As above, I prefere loosing the
> > event then registering it at wrong time.
> 
> Ok, think of it this way -- you don't have an option. You just *have*
> to use them. As I said, please read Rusty Russell's introduction to
> locking in the kernel.

I see but I don't see why using spin_lock/unlock() in user contex and
spin_trylock/unlock() in interrupt context is wrong. :)

> > Why you wish using one lock per sources? Just one lock for the
> > list/array is not enought? :-o
> 
> No, I am *not* wishing / advocating that at all. Just that you appear so
> _reluctant_ to use spinlocks and are unnecessarily worrying about
> contention, disabling interrupts, etc etc.
> 
> Just use the spin_lock_irqsave/restore() variants, and you'll be fine.

What I wish is just to avoid disabling IRQs in user context in order
to minimize the possibility to delay events recording. We this
requirement the only solution I see is using spin_trylock/unlock() in
interrupt context.

Another requirement is __not__ going to sleep while holding a spinlock
(as Rusty says) and again the only solution I see is using mutex.

Looking at my previous patch I found that it should be written like
this:

@@ -199,6 +200,7 @@ asmlinkage long sys_time_pps_setparams(int source,
                                        const struct pps_kparams __user *params) {
        int ret;
+       struct pps_kparams temp;
 
        pr_debug(``%s: source %d\n'', __FUNCTION__, source);
 
@@ -228,13 +230,16 @@ asmlinkage long sys_time_pps_setparams(int source,
        }
 
        /* Save the new parameters */
-       ret = copy_from_user(&pps_source[source].params, params,
-                                               sizeof(struct pps_kparams));
+       ret = copy_from_user(&temp, params, sizeof(struct pps_kparams));
        if (ret) {
                ret = -EFAULT;
                goto sys_time_pps_setparams_exit;
        }
 
+       spin_lock(&pps_lock);
+
+       pps_source[source].params = temp;
+
        /* Restore the read only parameters */
        if ((params->mode & (PPS_TSFMT_TSPEC | PPS_TSFMT_NTPFP)) == 0) {
                /* section 3.3 of RFC 2783 interpreted */
@@ -245,6 +250,8 @@ asmlinkage long sys_time_pps_setparams(int source,
                pps_source[source].params.mode |= PPS_CANWAIT;
        pps_source[source].params.api_version = PPS_API_VERS;
 
+       spin_unlock(&pps_lock);
+
 sys_time_pps_setparams_exit:
        mutex_unlock(&pps_mutex);
 
In this manner I can going to sleep in copy_from_user() whitout
holding any locks.

On Mon, Jul 30, 2007 at 02:50:56PM +0530, Satyam Sharma wrote:
> 
> No, it does *NOT*. All it says is:
> 
>     The time_pps_create() is used to convert an already-open UNIX file
>     descriptor, for an appropriate special file, into a PPS handle.
> 
> See? What I said is precisely the implementation the RFC envisages
> (and the only sane way to implement it too).
> 
> And later, where it gives an example, it shows:
> 
>     fd = open(PPSfilename, O_RDWR, 0);
> 
> What I'm saying is that the "PPSfilename", as is obvious from the name
> itself, is *not* a port such as lpXXX or ttySXXX, but an "appropriate
> special file" corresponding to a ... PPS source! Really, the RFC is
> quite clear and easy to read, I have no idea how to explain that more
> clearly ...

Ok, I see, but how you can get your PPS source data struct starting
from a file descriptor? :-o

> > As you propose you need _two_ open() and not just one...
> 
> No, why?

Please, take alook at NTPD code. Common usage is:

   fd = open("/dev/ttyS0", ...);

   pps_time_create(fd, &handler);

since RFC supposes that at filedes "fd" is mapped both GPS data _and_
PPS source.

With your suggestion code should be changed as follow:

   fd_gps = open("/dev/ttyS0", ...);

   fd_pps = open("/dev/pps0", ...);

   pps_time_create(fd_pps, &handler);

> > and even if
> > you decide to open the /dev/ppsX inside the pps_time_create(), how do
> > you recognise _which_ /dev/ppsX is connected with filedse "fd"?
> 
> That's trivial to implement in the kernel code for the time_pps_create()
> syscall.

I didn't find a good solution for it.

Furthermore with my pps_findpath() I can do:

   fd = open("/dev/ttyS0", ...);

   handler = pps_findpath("/dev/ttyS0", ...);

which in most cases its more easy to manage for both user and kernel
land.

Can do the same with char devices? Maybe you can easily create
/dev/pps0 but how can you relate it with the /dev/ttyS0 if your GPS
antenna and PPS source share the same serial port?

I studied the problem trying to find a good solution for both NTPD
code (tring to change it as less as possible) and PPS sources
connected with CPU's GPIOs, but currently I find nothing better that
this.

> > I quite sure that RFC is broken since it doesn't take in account that
> > a PPS source maybe not connected with any cahr device at all. I tried
> > to explain this problem to RFC's gurus but they never answered to me,
> > so I decided to resolve the problem by myself. ;)
> 
> Nopes, the RFC is not broken at all. All this physical-connection-port
> device vs PPS-source-device confusion is just in your mind :-)

Ok, if you don't think so try looking at NTPD code (written by RFC's
gurus) and try to resolve the problem where both GPS antenna and PPS
source are connected with a serial port, and the problem where only
the GPS antenna is connected with the serial port but the PPS source
is connected with a CPU's GPIO.

If you solve both them all PPS users will thank you a lot forever! :)

> > Ok, but in this case you still are _not_ RFC compliant (as showed
> > above). You need that users give to you _two_ devices (the serial line
> > and the PPS source), meanwhile, for the RFC, you just need one. So no
> > differences from my solution from this point of view.
> 
> Yeah, so how am I not RFC compliant? Userspace will *only* open(2) the
> special char device of the *PPS source*, and have *nothing* to do with
> the device corresponding to the physical device/port it is connected
> through!

Ok, in your sceraio no problem, but continue to read RFC:

   All of the other functions in the PPS API operate on PPS handles
   (type: pps_handle_t).  The time_pps_create() is used to convert an
   already-open UNIX file descriptor, for an appropriate special file,
   into a PPS handle.

   The definition of what special files are appropriate for use with the
   PPS API is outside the scope of this specification, and may vary
   based on both operating system implementation, and local system
   configuration.  One typical case is a serial line, whose DCD pin is
   connected to a source of PPS events.

This shows that RFC creators though only at PPS sources connected with
an _already_ opened device (as serial ports or parallel one), if not
why don't define the function time_pps_create() as:

   int time_pps_create(char *ppsdev, pps_handle_t *handle);

???

No, they require an _already_ opened file descriptor because they
supposed you can use serial line file descriptor! So, if this is not
your case (because your PPS source is connected with a CPU's GPIO) you
_must_ use a second open() (not considere at all into NTPD code) or,
as I did, use a special function like pps_findsource/path().

> > I need them (or just one of them) in order to find a PPS source into
> > the system. Just as you need the second device name in your solution
> > with char devices.
> 
> No, I don't need any "second device". I *only* need the "appropriate
> special file" as mentioned in the RFC. I don't give a *damn* for
> what *physical device/port* the source is actually connected through.
> I suggest you should read the RFC again ...

I read it. Ok, according your solution and not considering the two
open()s to do we should do:

   fd_pps = open("/dev/pps0", ...);

   time_pps_create(fd_pps, &handle);

ok? Two qeustions:

1) If the RFC wan't broken why it doesn't simply say that you can use
   fd_pps and pps handler?

2) How can you get kernel PPS source data just getting as input
   fd_pps value?

Again, RFC was sane if it said that you can get a PPS hadler by simply
doing:

   time_pps_create("/dev/pps0", &handle);

this could be easily implemented with just an open()...

They didn't like this because they __never__ considered the case where
the PPS source is not connected at all with any serial/parallel
decices.

On Mon, Jul 30, 2007 at 03:01:28PM +0530, Satyam Sharma wrote:
> 
> What does the section on locking between hard irq contexts (or between
> user process context and hard irq context) say?

That I should use spin_lock_irqsave() but the document also:

1) says that I cannot hold spinlocks while sleeping and

2) doesn't say that using spin_lock/unlock() in user context and
spin_trylock/unlock() in interrupt context is wrong.

> As I said, you could just use the spin_lock_irqsave/restore() variants ...
> If you want, I can try and implement the other bits that I had suggested
> for the other things as well :-)

Great! Thanks a lot, so we can discuss on them and maybe we can prive
Linux of this PPS support! :)

Thanks a lot for your time, this discussion was most important for me
in better understanding locks problems (and also to improve my poor
english, eheheheh :).

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
