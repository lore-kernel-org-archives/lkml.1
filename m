Return-Path: <linux-kernel-owner+w=401wt.eu-S1752543AbYJYVh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543AbYJYVh6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 17:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751214AbYJYVhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 17:37:50 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:45323 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbYJYVht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 17:37:49 -0400
Date: Sat, 25 Oct 2008 23:36:38 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Arjan van de Ven <arjan@infradead.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>
Subject: Re: [pull request] getting rid of __cpuinit
Message-ID: <20081025213638.GA27356@uranus.ravnborg.org>
References: <20081024142056.6a2d082a@infradead.org> <20081025162116.GA13303@uranus.ravnborg.org> <20081025092942.40342ad0@infradead.org> <200810252020.01352.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810252020.01352.rjw@sisk.pl>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > I tried to look a the numbers of a defconfig build here.
> > > cpuinit.text equals 0x5d97 = 23959
> > > cpuinit.data equals 0x3574 = 13684
> > > 
> > > [objdump of vmlinux.o gives you the size of the cpuinit sections]
> > > 
> > > So if we decide to drop cpuinit then it should be based on the
> > > above figure and not the 2k figure you gave in the original mail.
> > > 
> > > Or even better we should see the difference with a typical
> > > embedded configuration and not some big defconfig build.
> > > I will assume the saving is less on a typical embedded
> > > configuration.
> > 
> > it will be; on x86 you end up inheriting all cpu vendors init code.
> > on embedded you only have  the dedicated CPU code.
> > 
> > ... just that on x86... nobody seems to be in this position, it's
> > almost impossble to have HOTPLUG_CPU even be asked.
> 
> FWIW, I like the idea of removing __cpuinit.  It often is quite difficult to
> determine if given piece of code should be marked as __cpuinit and that leads
> to bugs that are not so easy to resolve.

Getting rid of __cpuinit would be good - I do not questions this.
I only want the decision to be taken based on the correct numbers,
which Arjan failed to provide initially.

I decided to try to build a typical arm target - netwinder.
It had HOTPLUG disabled which is why I took this one.

objdump -h a/vmlinux.o | grep cpu
  4 .cpuinit.text 000006ac  00000000  00000000  0023e3e4  2**2
 41 .cpuinit.data 00000040  00000000  00000000  002c31a8  2**2

objdump -h a/vmlinux.o | grep text
  0 .text         00227b44  00000000  00000000  00000040  2**5
  1 .text.head    00000240  00000000  00000000  00227ba0  2**5
  2 .init.text    000150b0  00000000  00000000  00227de0  2**5
  4 .cpuinit.text 000006ac  00000000  00000000  0023e3e4  2**2
  7 .devinit.text 00005c24  00000000  00000000  0023f78c  2**2
  9 .exit.text    00001124  00000000  00000000  002453e4  2**2
 11 .meminit.text 000002d4  00000000  00000000  002482b0  2**2
 12 .devexit.text 00000348  00000000  00000000  00248584  2**2

So we see that for this config on arm we only save ~1700 bytes
by the cpuinit stuff. And for data we save even less.

__cpuinit is almost not used in arm specific code so what we
have here is the savings from the shared code.

Considering these numbers the gain/pain ratio is too low
and I agree that the cpuinit stuff should go.

The reports that removing cpuinit/exit stuff adds a new set
of warnings should just be looked at.
Except from the tricky __cpuinit cases it is almost always
trivial to fix when you have understood the problem.

	Sam
