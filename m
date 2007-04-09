Return-Path: <linux-kernel-owner+w=401wt.eu-S1752040AbXDIAOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040AbXDIAOR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 20:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752041AbXDIAOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 20:14:17 -0400
Received: from nz-out-0506.google.com ([64.233.162.231]:63433 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbXDIAOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 20:14:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=t1cpxkc2NuHyXlkpCFtmUdP7MMLfvZ8DuxRXBs7A5MdyuoINWK+kKfYQ4F5ikLBkFDusREaXfmTFMco2Jvuiwm0XGOMTr7QUHpPdMCg7AaNPvVZZze1Qm+YfkD0gGqtIil8DCfmOuS9G6M9ynAlgawd96z4nJuMzhaX7/q101ac=
Message-ID: <b647ffbd0704081714j2af41daaq6643e187b7511b03@mail.gmail.com>
Date: Mon, 9 Apr 2007 02:14:14 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Mike Galbraith" <efault@gmx.de>
Subject: Re: SD scheduler testing hitch
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Con Kolivas" <kernel@kolivas.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <1176019324.8244.6.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b647ffbd0704040704k2e4b3abcyfadc7662dff37f5b@mail.gmail.com>
	 <20070404141546.GA862@elte.hu>
	 <b647ffbd0704041305t2a140369q56cf9f0746b8fd86@mail.gmail.com>
	 <20070406170319.2c961eba.akpm@linux-foundation.org>
	 <20070407092401.GB16356@elte.hu>
	 <1175962840.10478.49.camel@Homer.simpson.net>
	 <1175966255.11408.5.camel@Homer.simpson.net>
	 <1176019324.8244.6.camel@Homer.simpson.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/07, Mike Galbraith <efault@gmx.de> wrote:
> On Sat, 2007-04-07 at 19:17 +0200, Mike Galbraith wrote:
>
> > I lowered the time to 500us, and ran at nice -10.. it starves tenpercent
> > here every time.  (ran as taskset -c 1 nice -n -10 ./fairtest)  The
> > starving 10% duty cycle task has trouble getting 1% CPU.
>

Something is odd, very odd indeed. But surprise-surprise, it does not
seem to be something merely SD-releated.

In short, the question is - can we always believe statistics being
provided by "top" (i.e. the way it's being collected by the kernel)?

The tests are below. Somewhere in the middle are thoughts on how HZ
and an interval of cpu usage by a given task may be connected to such
a behaviour.

The system: Pentiium 3 Coppermine 750 MHz (iThinkPad T21), 256 RAM.

I tested 3 configurations:

(1)  2.6.13-15 (default in SuSE 10)
(2)  2.6.19
(3)  2.6.21-rc5 + sd-0.39

TEST: just a tenp.c, i.e. without Mike's "steal" (either as xx.c or as
a part of modified fairtest.c) thingy, but

tenp    -- a tenp.c with a single running copy;
tenp2  -- a tenp.c with 2 (1 additionally forked) running copies
tenp15 - 15 copies (only for SD)


(1)  2.6.13-15

Tasks:  74 total,   1 running,  73 sleeping,   0 stopped,   0 zombie
Cpu(s):  8.6% us,  0.7% sy,  0.0% ni, 90.4% id,  0.0% wa,  0.3% hi,  0.0% si

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 5582 dimm      15   0  1460  428  348 S  6.0  0.2   0:02.03 tenp
 4047 messageb  17   0  3520 1584 1324 S  1.3  0.6   0:00.28 dbus-daemon


Tasks:  76 total,   1 running,  75 sleeping,   0 stopped,   0 zombie
Cpu(s): 14.9% us,  0.3% sy,  0.0% ni, 84.8% id,  0.0% wa,  0.0% hi,  0.0% si

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 5598 dimm      15   0  1460  428  348 S  7.2  0.2   0:01.42 tenp2
 5599 dimm      15   0  1460  432  352 S  6.9  0.2   0:00.87 tenp2
 5591 dimm      16   0  2108  988  764 R  0.3  0.4   0:00.47 top
    1 root      16   0   688  260  224 S  0.0  0.1   0:01.78 init

I repeated 7 times each of the tests (tenp and tenp2). All are ok.


Now an interesting part starts.

(2)  2.6.19

[ 2.1 ]

ks:  73 total,   1 running,  72 sleeping,   0 stopped,   0 zombie
Cpu(s):  1.3% us,  0.7% sy,  0.0% ni, 98.0% id,  0.0% wa,  0.0% hi,  0.0% si

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 8312 root      15   0 27168  14m 2128 S  0.7  5.6   0:08.29 X
 8640 dimm      15   0 28656  13m   9m S  0.7  5.4   0:03.44 konsole
 8813 dimm      15   0  1460  432  352 S  0.3  0.2   0:00.32 tenp
    1 root      15   0   696  268  228 S  0.0  0.1   0:01.12 init

[ 2.2 ]

ks:  73 total,   3 running,  70 sleeping,   0 stopped,   0 zombie
Cpu(s):  6.6% us,  0.7% sy,  0.0% ni, 92.7% id,  0.0% wa,  0.0% hi,  0.0% si

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 8816 dimm      15   0  1464  432  352 S  5.0  0.2   0:01.49 tenp
 8312 root      15   0 27168  14m 2128 R  1.7  5.6   0:09.08 X

See a difference between [ 2.1 ] and [ 2.2 ] ?  [ 2.2 ] (which is ok)
has happened 3 out of 10 times.

Now for tenp2

[ 2.3 ]

ks:  74 total,   1 running,  73 sleeping,   0 stopped,   0 zombie
Cpu(s): 14.6% us,  0.3% sy,  0.0% ni, 85.1% id,  0.0% wa,  0.0% hi,  0.0% si

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 8850 dimm      15   0  1460  432  352 S  6.6  0.2   0:01.32 tenp2
 8851 dimm      15   0  1460  112   32 S  6.3  0.0   0:00.77 tenp2
 8312 root      15   0 27168  14m 2128 S  0.7  5.6   0:11.73 X

[ 2.4 ]

ks:  74 total,   2 running,  72 sleeping,   0 stopped,   0 zombie
Cpu(s):  3.3% us,  0.3% sy,  0.0% ni, 96.3% id,  0.0% wa,  0.0% hi,  0.0% si

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 8312 root      15   0 27168  14m 2128 S  2.0  5.6   0:12.97 X
 8640 dimm      15   0 28748  13m   9m R  0.7  5.4   0:07.22 konsole
 8532 dimm      18   0  2476  416  268 S  0.3  0.2   0:00.04 gpg-agent
 8852 dimm      15   0  2116  996  772 R  0.3  0.4   0:00.27 top
 8859 dimm      15   0  1460  432  352 S  0.3  0.2   0:00.44 tenp2
 8860 dimm      15   0  1460  112   32 S  0.3  0.0   0:00.02 tenp2
    1 root      15   0   696  268  228 S  0.0  0.1   0:01.12 init

Again, [ 2.3 ] took place only 3 times.

Some observations:

/1/  for the "ok" ( [ 2.2 ] and [ 2.3 ] ) cases, the "will run" and
"will sleep" times from tenp's calibration output look /higher/ than
on average :

e.g.
Each fork will run for 5863 usecs and sleep for 52767 usecs

v.s. something in between

Each fork will run for 2392 usecs and sleep for 21528 usecs
Each fork will run for 3880 usecs and sleep for 34920 usecs

for the most part of cases (when tenp's cpu% ~0.3).


/2/  HZ = 250 for 2.6.19 and I think it was still 1000 for 2.6.13
(arghh.. forgot to check and would like to avoid a reboot in this
already late hour... but I believe it was still the time of 1000 by
default).

=============

(*)

HZ == 250 ==> timer_tick is once in 4 ms. So - "will run for" < 4 ms -
may come well unaccounted? :o)

The funny thing is (at least in theory) - if a task is using CPU in
portions < 1/HZ s. and specially shifted against timer interrupts ->
scheduler_tick() - its time_slice isn't decreasing at all (very
theoretically) or just more or less slower (with another load a moment
when the task is running should drift wrt moments of timer interrupts
and hit them from time to time -> get accounted).

=============

(3)  2.6.21-rc5 + sd-0.39

Here the results are similar to (2).

Cpu(s): 10.6% us,  0.0% sy,  0.0% ni, 89.4% id,  0.0% wa,  0.0% hi,  0.0% si

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 3624 dimm      20   0  1460  428  352 S  5.0  0.2   0:01.50 tenp2
 3625 dimm      20   0  1460  108   32 S  4.6  0.0   0:00.76 tenp2
 2797 root      20   0 27112  13m 2128 S  0.3  5.6   0:18.62 X

Cpu(s):  2.0% us,  0.3% sy,  0.0% ni, 97.7% id,  0.0% wa,  0.0% hi,  0.0% si

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 3738 dimm      20   0  1460  432  352 S  0.3  0.2   0:00.60 tenp2
 3739 dimm      20   0  1460  112   32 S  0.3  0.0   0:00.18 tenp2

and now let's run both tenp and tenp15

look at the "tenp" below

/1/

 Tasks:  82 total,  10 running,  72 sleeping,   0 stopped,   0 zombie

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 3760 dimm      31   0  1464  112   32 S  7.9  0.0   0:01.82 tenp15
 3773 dimm      31   0  1460  432  352 R  7.2  0.2   0:01.24 tenp
 3758 dimm      31   0  1464  112   32 S  6.9  0.0   0:01.73 tenp15
 3759 dimm      31   0  1464  112   32 S  6.9  0.0   0:01.65 tenp15
 3757 dimm      31   0  1464  432  352 R  6.2  0.2   0:01.89 tenp15
 3762 dimm      31   0  1464  112   32 R  6.2  0.0   0:01.70 tenp15
 3763 dimm      31   0  1464  112   32 S  6.2  0.0   0:01.75 tenp15
 3765 dimm      31   0  1464  112   32 S  6.2  0.0   0:01.82 tenp15
 3767 dimm      31   0  1464  112   32 S  6.2  0.0   0:01.73 tenp15
 3764 dimm      31   0  1464  112   32 R  5.9  0.0   0:01.70 tenp15
 3769 dimm      31   0  1464  112   32 R  5.9  0.0   0:01.65 tenp15
 3761 dimm      31   0  1464  112   32 S  5.6  0.0   0:01.66 tenp15
 3766 dimm      31   0  1464  112   32 R  5.6  0.0   0:01.68 tenp15
 3768 dimm      31   0  1464  112   32 R  5.6  0.0   0:01.77 tenp15
 3771 dimm      31   0  1464  112   32 R  5.6  0.0   0:01.72 tenp15
 3770 dimm      31   0  1464  112   32 S  5.2  0.0   0:01.54 tenp15
 3178 dimm      20   0 28996  13m   9m R  0.7  5.6   0:17.49 konsole


and now let's kill tenp15 so tenp remains alone.

Cpu(s):  0.0% us,  0.3% sy,  0.0% ni, 99.7% id,  0.0% wa,  0.0% hi,  0.0% si

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 3773 dimm      20   0  1460  432  352 S  0.3  0.2   0:03.59 tenp
 3775 dimm      20   0  2120 1000  772 R  0.3  0.4   0:00.19 top

strange.

I doesn't happen for tenp15 (each always consumes ~6%). I repeated
about 10 times.

Well, it's a late hour, so maybe I'm missing something... but it does
look to be HZ and "will run" time interval related issue. Like
described in (*). Or maybe we both observe similar situations but have
different reasons behind them.


>         -Mike

-- 
Best regards,
Dmitry Adamushko
