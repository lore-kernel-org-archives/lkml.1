Return-Path: <linux-kernel-owner+w=401wt.eu-S1755988AbZBBXOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988AbZBBXOv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 18:14:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753188AbZBBXOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 18:14:43 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42778
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752855AbZBBXOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 18:14:42 -0500
Date: Mon, 02 Feb 2009 15:14:39 -0800 (PST)
Message-Id: <20090202.151439.124517945.davem@davemloft.net>
To: mingo@elte.hu
Cc: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
       hpa@zytor.com
Subject: Re: x86's nmi_hz wrt. oprofile's nmi_timer_int.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090130.135409.180077287.davem@davemloft.net>
References: <20090129.155852.161923905.davem@davemloft.net>
	<20090130150125.GF31009@elte.hu>
	<20090130.135409.180077287.davem@davemloft.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Fri, 30 Jan 2009 13:54:09 -0800 (PST)

> From: Ingo Molnar <mingo@elte.hu>
> Date: Fri, 30 Jan 2009 16:01:25 +0100
> 
> > 
> > * David Miller <davem@davemloft.net> wrote:
> > 
> > Reducing it to 1 HZ was kind of a performance hack: running NMIs at HZ 
> > needlessly interrupts the CPU HZ times a second. It's more than enough to 
> > have 1 nmi-watchdog tick per second to notice deadlocks that take longer 
> > than 5 seconds.
> 
> For the NMI watchdog's purposes I understand the intent, and this
> is perfectly fine.
> 
> The problem is that it stays at '1' when oprofile starts using the NMI
> watchdog, and we certainly want more than one oprofile tick per second
> :-)

Just making sure you understand the problem, here is the
sequence of events:

1) At bootup, the NMI watchdog is tested.

   It is tested with nmi_hz=HZ

2) If the test passes, nmi_hz is reduced down to '1'

As I stated, everything up to this point is fine.  Next:

3) oprofile initializes and if we choose to use the NMI
   timer for oprofile profiling it is implemented using
   a simple DIE_NMI notifier.

   However, nmi_hz is still just '1' which means that oprofile
   will only receive one sample per-second.  And this is definitely
   not what we want.

Somehow the code in arch/x86/oprofile/nmi_timer_int.c needs to
have an interface into the NMI watchdog core so that it can
increase nmi_hz back up to "HZ" when the NMI timer profiling is
enabled and back down to "1" when such profiling stops.
