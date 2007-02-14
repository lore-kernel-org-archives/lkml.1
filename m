Return-Path: <linux-kernel-owner+w=401wt.eu-S1751299AbXBNWwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751299AbXBNWwh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 17:52:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751330AbXBNWwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 17:52:37 -0500
Received: from ozlabs.org ([203.10.76.45]:40580 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299AbXBNWwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 17:52:37 -0500
Subject: Re: [PATCH 9/11] Panic delay fix
From: Rusty Russell <rusty@rustcorp.com.au>
To: Zachary Amsden <zach@vmware.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akp=m@osdl.org>, Andi Kleen <ak@muc.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>, Alan <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <200702060353.l163rUmj000771@zach-dev.vmware.com>
References: <200702060353.l163rUmj000771@zach-dev.vmware.com>
Content-Type: text/plain
Date: Thu, 15 Feb 2007 09:51:46 +1100
Message-Id: <1171493506.19842.179.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-05 at 19:53 -0800, Zachary Amsden wrote:
> Failure to use real-time delay here causes the keyboard to become demonically
> possessed in the event of a kernel crash, with wildly blinking lights and
> unpredictable behavior.  This has resulted in several injuries.

The problem is the normal one when we introduce a new concept into the
kernel; there are two kinds of udelay, and they've been conflated.  The
most common case is a delay for real hardware devices; this can be
eliminated for paravirtualization.  The other cases, the tiny minority,
are visible delays (keyboard leds), not knowing if they're necessary
(very early boot), and async events (other CPUs coming up): ie.
everything else.

Is implementation of this distinction worth it?  The answer IMHO is no;
this is a case where simplicity wins.

Firstly, most modern distributions ship kernels which have almost no
drivers, and modprobe in early boot.  So assuming paravirtualized
drivers, we don't even experience the boot delays.

Secondly, the major delay for my current kernel is IDE probing (3 out of
5 seconds of boot time!), but implementing the delay ops in lguest does
*nothing* for this, because it uses "msleep()" not "mdelay()". so the
current solution isn't sufficient anyway.  If this is a real problem for
users I'd rather try to convince the IDE maintainer to use a
"real_hardware_mdelay()" or something here.

Cheers!
Rusty.
PS.  lguest doesn't implement the delay functions; I just tried
implemented that now for testing.


