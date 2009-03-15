Return-Path: <linux-kernel-owner+w=401wt.eu-S1756819AbZCOSNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819AbZCOSNe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 14:13:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756049AbZCOSMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 14:12:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34553 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756277AbZCOSMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 14:12:54 -0400
Date: Sun, 15 Mar 2009 11:09:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jesper Krogh <jesper@krogh.cc>
cc: john stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>
Subject: Re: Linux 2.6.29-rc6
In-Reply-To: <49BD225C.4070305@krogh.cc>
Message-ID: <alpine.LFD.2.00.0903151050070.3131@localhost.localdomain>
References: <alpine.LFD.2.00.0902222023520.3111@localhost.localdomain>  <alpine.LFD.2.00.0902261232570.3111@localhost.localdomain>  <49A6FEE2.90700@krogh.cc>  <1f1b08da0902261319k7a60d80xaafc1101facfd2d9@mail.gmail.com>  <49A70B24.6090706@krogh.cc> 
 <1235685269.6811.11.camel@localhost.localdomain>  <alpine.LFD.2.00.0902262255190.9135@localhost.localdomain>  <1235687483.6811.26.camel@localhost.localdomain>  <49A78C79.304@krogh.cc>  <1235766936.7402.5.camel@localhost.localdomain> <49ACC853.8070205@krogh.cc>
  <1236110026.6068.18.camel@localhost> <49AD90E2.7050209@krogh.cc>  <1236118969.6068.87.camel@localhost> <49AE9EA4.2080500@krogh.cc>  <49AECA3B.5030503@krogh.cc>  <1236193075.3793.63.camel@jstultz-laptop>  <1236220759.6863.7.camel@localhost.localdomain>
 <1236221530.6863.9.camel@localhost.localdomain> <49B57F3D.5030008@krogh.cc> <alpine.LFD.2.00.0903141814180.7421@localhost.localdomain> <49BD225C.4070305@krogh.cc>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 15 Mar 2009, Jesper Krogh wrote:
> Linus Torvalds wrote:
> > 
> > Regardless of whether is succeeds or not, it will print out some debug
> > messages, which will be interesting to see.
> 
> 
> [    0.000000] Fast TSC delta=34227730, error=6223+6219=12442
> [    0.000000] Fast TSC calibration using PIT
> [    0.000000] Detected 2312.045 MHz processor.

Ok. This claims that the error really is smaller than 500ppm (it's about 
360 ppm). Which is about what we're aiming for (in real life, the actual 
error is about half that - we're just adding up the error terms for 
maximum theoretical error).

> Using "ntpq -c peers" .. the offset steadily grows as time goes.
> 
> Full dmesg: http://krogh.cc/~jesper/dmesg-linux-2.6.29-rc8-linus1.txt
> 
> jk@quad11:~$ ntpdc -c kerninfo
> pll offset:           0.085167 s
> pll frequency:        -18.722 ppm
> maximum error:        0.137231 s
> estimated error:      0.008823 s
> status:               0001  pll
> pll time constant:    6
> precision:            1e-06 s
> frequency tolerance:  500 ppm

Hmm. But now it all seems to _work_, no? Or do you still get time resets? 
Now your "pll frequency" and "estimated error" are real values, not just 
"0s" like in your previous failure cases.

Of course, maybe that happens only after the time reset actually kicks in.

But one thing my patch did - apart from the error estimation - was to 
synchronize the TSC read with the actual PIT MSB wrap event. Maybe that 
mattered.

The other possibility (if the time reset actually happens) is that your 
PIT is simply not running at the expected frequency. That would be really 
quite odd, since that nominal 1193181.8181 Hz frequency is very standard, 
and has been around foreve.

I do not know how to test that. We need a reference timer to sync to, and 
the PIT has traditionally been a _lot_ more reliable than the other timers 
in the system (the PM timer may be reliable on modern machines, but almost 
certainly not on anything a few years old).

			Linus
