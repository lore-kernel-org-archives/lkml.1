Return-Path: <linux-kernel-owner+w=401wt.eu-S1765868AbXHFUTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765868AbXHFUTh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 16:19:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763721AbXHFUTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 16:19:24 -0400
Received: from elasmtp-mealy.atl.sa.earthlink.net ([209.86.89.69]:33769 "EHLO
	elasmtp-mealy.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763035AbXHFUTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 16:19:21 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=fOWGhBI6+XjnNtpM18hehTUtuG5NX4+zsynt6gkMgk2K7xTZj2+C18ip+porIop3;
  h=Received:Message-ID:Reply-To:From:To:Cc:Subject:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:X-Priority:X-MSMail-Priority:X-Mailer:X-MimeOLE:X-ELNK-Trace:X-Originating-IP;
Message-ID: <000501c7d867$4be6da80$6501a8c0@earthlink.net>
Reply-To: "Mitchell Erblich" <erblichs@earthlink.net>
From: "Mitchell Erblich" <erblichs@earthlink.net>
To: <linux-kernel@vger.kernel.org>
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "\"T. J. Brumfield\"" <enderandrew@gmail.com>
Subject: Re: about modularization
Date: Mon, 6 Aug 2007 13:20:54 -0700
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1106
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1106
X-ELNK-Trace: 074f60c55517ea841aa676d7e74259b7b3291a7d08dfec7912e6e3062050058af3ce4bb17895072b350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 68.164.93.68
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar and group,

    If we just concentrate on CPU schedulars...

     IMO,  POSIX requirements almost guarantee
     the support for modularization. The different
     task scheds allow a set of task class specific
     funcs to be generated. The question is whether
     those modular schedulars will ALWAYS consume
     kernel footprint space?

    With the arg of modularization is really targeted
    to optional hardware and decreases the kernel
    footprint size. Then here is a arg to support only 1
    default schedular and take the rest of the sched
    code and modularize that..

      IMO, ONLY some envs REQUIRE RT
      sched and some envs REQUIRE MP
      (multi-core and multi-processor) scheduling.
      I question whether the core kernel needs
      this support.
      .
    This additional capability could be removed
    from the growing kernel footprint and
    additional schedulars could be kept in the src
    code base with increasingly minimal effort if full
    modularization support were added.

    Thus, a hybrid schedular approach could be taken
    that would default to a single uni-processor schedular
    (ex: CFS) and the other schedulars could be
    modularized.

    Mitchell Erblich
    ------------------------







    Ingo Molnar wrote:
>
> * T. J. Brumfield <enderandrew@gmail.com> wrote:
>
> > 1 - Can someone please explain why the kernel can be modular in every
> > other aspect, including offering a choice of IO schedulers, but not
> > kernel schedulers?
>
> that's a fundamental misconception. If you boot into a distro kernel on
> a typical PC, about half of the kernel code that the box runs in any
> moment will be in modules, half of it is in the "kernel core". For
> example, on a random laptop:
>
>  $ echo `lsmod | cut -c1-30 | cut -d' ' -f2-` | sed 's/Size //' |
>    sed 's/ /+/g' | bc
>  2513784
>
> i.e. 2.5 MB of modules. The core kernel's size:
>
>  $ dmesg | grep 'kernel code'
>  Memory: 2053212k/2087808k available (2185k kernel code, 33240k reserved,
1174k data, 244k init, 1170304k highmem)
>
> 2.1 MB of kernel core code. (of course the total body of "possible
> drivers" is 10 times larger than that of the core kernel - but the
> fundamental 'variety' is not.)
>
> most of the modules are for stuff where there is a significant physical
> difference between the components they support. Drivers for different
> pieces of hardware. Filesystem drivers for different on-disk physical
> layouts. Network protocol drivers for different on-wire formats. The
> sanest technological decision there is clearly to modularize.
>
> And note that often it's not even about choice there: the user's system
> has a particular piece of hardware, to which there is usually one
> primary driver. The user does not have any real 'choice' over the
> modularization here, it's largely a technological act to make the
> kernel's footprint smaller.
>
> But the kernel core, which does not depend as much on the physical
> properties of the stuff it supports (it depends on the physics of the
> machine of course, but those rules are mostly shared between all
> machines of that architecture), and is fundamentally influenced by the
> syscall API (which is not modular either) and by our OS design
> decisions, has much less reason to be modularized.
>
> The core kernel was always non-modular, and it depends on the technical
> details whether we want to or _have to_ modularize something so that it
> becomes modular to the user too. For example we dont have 'competing',
> modular versions of the IPv4 stack. Neither of the VFS. Nor of timers,
> futexes, nor of locking code or of the CPU scheduler. But we can switch
> out any of those implementations from the core kernel, and did so
> numerous times in the past and will do so in the future.
>
> CPU schedulers are as core kernel code as it gets - you cannot even boot
> without having a CPU scheduler. IO schedulers, although similar in name,
> are quite different beasts from CPU schedulers, and they are somewhere
> between the core kernel and drivers. They are not 'physical drivers' (an
> IO scheduler can drive any disk), nor are they fully 'core kernel code'
> in the sense of a kernel not even being able to boot without them. Also,
> disks are physically different from CPUs, in a way which works _against_
> the user-modularization of CPU schedulers. (there are also many other
> differences which have been pointed out in the past)
>
> In any case, the IO subsystem maintainers decided to modularize IO
> schedulers, and that's their decision. One of the authors of the IO
> scheduler code said it on lkml recently that while modularization of IO
> scheduler had advantages too, in retrospect he wishes they would not
> have made IO schedulers modular and now that decision cannot be undone.
> So even that much different situation was far from a clear decision, and
> some negative effects can be felt today too, in form of having two
> primary IO schedulers but not having one IO scheduler that works well in
> all cases. For CPU schedulers the circumstances point away away from
> user-selectable modularization even stronger.
>
>         Ingo
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

