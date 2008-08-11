Return-Path: <linux-kernel-owner+w=401wt.eu-S1753347AbYHKQjM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347AbYHKQjM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 12:39:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751189AbYHKQi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 12:38:58 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:36955 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbYHKQi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 12:38:57 -0400
Message-ID: <2653.69.2.248.210.1218471388.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <20080811135004.GS9038@one.firstfloor.org>
References: <20080807200659.GJ24801@one.firstfloor.org>
    <23175.1218148134@ocs10w> <20080808011500.GA531@redhat.com>
    <20080808022916.GM24801@one.firstfloor.org>
    <20080808132953.GB3840@redhat.com>
    <20080808180303.GB9038@one.firstfloor.org>
    <20080811130256.GB28030@redhat.com>
    <43117.166.70.238.45.1218460302.squirrel@webmail.wolfmountaingroup.com>
    <20080811135004.GS9038@one.firstfloor.org>
Date: Mon, 11 Aug 2008 10:16:28 -0600 (MDT)
Subject: Re: [ANNOUNCE] Merkey's Kernel Debugger
From: jmerkey@wolfmountaingroup.com
To: "Andi Kleen" <andi@firstfloor.org>
Cc: jmerkey@wolfmountaingroup.com, "Vivek Goyal" <vgoyal@redhat.com>,
       "Andi Kleen" <andi@firstfloor.org>, "Keith Owens" <kaos@ocs.com.au>,
       "Jay Lan" <jlan@sgi.com>, "Christoph Lameter" <cl@linux-foundation.org>,
       "Stefan Richter" <stefanr@s5r6.in-berlin.de>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Geert Uytterhoeven" <geert@linux-m68k.org>,
       "Josh Boyer" <jwboyer@gmail.com>, linux-kernel@vger.kernel.org,
       "Takenori Nagano" <t-nagano@ah.jp.nec.com>,
       "Bernhard Walle" <bwalle@suse.de>
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Aug 11, 2008 at 07:11:42AM -0600, jmerkey@wolfmountaingroup.com
> wrote:
>> I found a problem with APIC NMI support which seems to affect all the
>> debuggers, but appears machine specific -- at least I can reproduce it
>> with all of the modules MDB, KDB, and KGDB modules on my ACER 2410 dual
>
> A couple of laptop BIOS (e.g. some thinkpads) are unfortunately
> not NMI safe. There is no known workaround other than not using NMIs
> on these systems.
>
> There's unfortunately no global blacklist for these systems, although
> having would be useful for a couple of subsystems.
>
> -Andi
>
>

I seem to have nailed down the "voodoo" sequence for reproducing it and
the sequence of failure on the Acer 9410.

Processors 0,1

first set a global breakpoint (schedule) and load registers DR6/DR7

0 -> trigger int1 breakpoint
1 -> trigger int1 breakpoint
0 -> get debugger lock
1 -> spin at debugger lock
0-> NMI all processors but self
1-> gets NMI while spinning at debugger lock
1-> enters NMI code loop and spins
0-> enter debugger console
0-> leave debugger console
0-> release spinning processors
1-> leave NMI code issues IRETD (returns to debugger spinlock and spins)
0-> release debugger lock
1-> get debugger lock
1-> NMI all processors but self
...hard hang in send_IPI_allbutself(APIC_DM_NMI)....

If a delay is placed in the code that calls send_IPI_allbutself() that
waits until processor 0 has left the int1 exception handler and issued an
IRETD, then the hang does not occur.  Seems to be the workaround for this
problem.

This problem seems specific to my Acer 9410 laptop, and as you described
seems hardware related, though I am going to attempt to instrument a
workaround for it anyway.

Jeff




