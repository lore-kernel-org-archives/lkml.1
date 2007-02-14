Return-Path: <linux-kernel-owner+w=401wt.eu-S932099AbXBNASy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099AbXBNASy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 19:18:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932101AbXBNASy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 19:18:54 -0500
Received: from ozlabs.org ([203.10.76.45]:53399 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932099AbXBNASx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 19:18:53 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17874.21860.598842.609322@cargo.ozlabs.ibm.com>
Date: Wed, 14 Feb 2007 11:18:44 +1100
From: Paul Mackerras <paulus@samba.org>
To: Andi Kleen <ak@suse.de>
Cc: Christoph Lameter <clameter@sgi.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Vojtech Pavlik <vojtech@suse.cz>, Jiri Bohac <jbohac@suse.cz>,
       linux-kernel@vger.kernel.org, ssouhlal@freebsd.org, tglx@linutronix.de,
       johnstul@us.ibm.com, zippel@linux-m68k.org, andrea@suse.de
Subject: Re: [patch 4/9] Remove the TSC synchronization on SMP machines
In-Reply-To: <200702131820.15180.ak@suse.de>
References: <20070201095952.589234000@jet.suse.cz>
	<1171348808.12771.19.camel@laptopd505.fenrus.org>
	<Pine.LNX.4.64.0702130906530.23634@schroedinger.engr.sgi.com>
	<200702131820.15180.ak@suse.de>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen writes:

> Just to avoid spreading misinformation: modulo some new broken hardware
> (which we always try to work around when found) i386/x86-64 gettimeofday
> is monotonic.  AFAIK on the currently known hardware it should be generally
> ok.
> 
> However ntpd can always screw you up, but that's inherent in the design.

On powerpc we manage to keep gettimeofday monotonic even when ntpd is
adjusting the clock.  We have 3 parameters used to convert a value
from the timebase register to the time of day, and these parameters
are adjusted if necessary at the beginning of each tick, based on the
value returned by current_tick_length().  The point is that
current_tick_length() tells you at the *beginning* of each tick how
much time will be added on to xtime at the *end* of that tick, and
that makes it possible to aim the interpolation to hit the same value
as xtime at the end of each tick.

Clearly if you make a discrete jump backwards with settimeofday or
adjtime, it's impossible to keep gettimeofday monotonic, but apart
from that it's monotonic on powerpc.

At least, that's the way it's supposed to work.  I hope the recent
timekeeping changes haven't broken it. :)

Paul.
