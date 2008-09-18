Return-Path: <linux-kernel-owner+w=401wt.eu-S1756541AbYIRVZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541AbYIRVZW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 17:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754235AbYIRVZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 17:25:08 -0400
Received: from tac.ki.iif.hu ([193.6.222.43]:36005 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753368AbYIRVZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 17:25:07 -0400
From: Ferenc Wagner <wferi@niif.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: doubled idle count
References: <87vdwtfxng.fsf@tac.ki.iif.hu> <48D2AD5E.7040602@goop.org>
Date: Thu, 18 Sep 2008 23:24:44 +0200
In-Reply-To: <48D2AD5E.7040602@goop.org> (Jeremy Fitzhardinge's message of
	"Thu, 18 Sep 2008 12:34:54 -0700")
Message-ID: <871vzhrvtv.fsf@szonett.ki.iif.hu>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> Ferenc Wagner wrote:
>
>> After upgrading a Xen virtual machine to Debian's 2.6.26-4 kernel, I
>> noticed that the idle counter doubled its pace on one of the machines:
>
> Sorry, could you be clearer here?  What are we looking at?

Sure, see below:

>> service2:~# yes >/dev/null &
>> [1] 32578

Here I made the processor (a single virtual one) fully busy.

>> service2:~# grep cpu0 /proc/stat; sleep 1; grep cpu0 /proc/stat
>> cpu0 141208 9113 57273 13379659 61012 0 792 2350 0
>> cpu0 141310 9113 57274 13379659 61012 0 792 2350 0

Above, the difference of the first numbers is 102, which, given that
USER_HZ=100, means that the CPU spent all its cycles during the sleep
processing user code (the yes running in the background).

>> service2:~# fg
>> yes > /dev/null
>> ^C

Now the CPU is idle again, I killed the yes started above.

>> service2:~# grep cpu0 /proc/stat; sleep 1; grep cpu0 /proc/stat
>> cpu0 141952 9113 57277 13383481 61012 0 792 2350 0
>> cpu0 141953 9113 57278 13383681 61012 0 792 2350 0

And here, the difference of the fourth numbers is 200, meaning that
the processor spent 200% of its time in idle state during this second!
(If I read the procfs documentation correctly, of course.)

This seems wrong by a factor of two, as there are only 100 "ticks" in
a second (actually, this kernel is tickless, but USER_HZ=100, as I'm
running a 686 kernel).

>> One out of three machines show this effect, with the exact same kernel
>> and Xen versions (3.2.0, dom0 is Debian's stock Etch 2.6.18 kernel).
>> They aren't hosted by the same machine, though: the misbehaving one is
>> on a different installation with very similar hardware (3 vs 2 GHz).
>> All the guest are paravirtual.
>
> So you're saying that they are identical Xen and guest kernel binaries,
> but one of three is showing doubled idle time?

Yes.

> That seems unlikely.

I was very much surpised myself, too...  The version numbers surely
are the same, but the binaries came from different downloads.  I'll
compare them, and also start another domU next to the misbehaving one.

> The source of that time is from Xen itself, and I think it should be
> hardware independent, though I guess its possible there's something
> going on at in the Xen-level timekeeping.
>
> That said, I think there's some chance that stolen time may get counted
> as idle time.  Does the one machine with a different outcome have
> something else running in another virtual machine (including dom0)?

Yes, both Xen instances run other domUs, and at abount one on both
consumes significant CPU.  The other domUs are mostly idle, and the
dom0s too.
-- 
Thanks for taking time,
Feri.
