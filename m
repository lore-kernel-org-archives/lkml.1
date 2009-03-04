Return-Path: <linux-kernel-owner+w=401wt.eu-S1757723AbZCDS7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757723AbZCDS7o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 13:59:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757205AbZCDS73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 13:59:29 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:55434 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757179AbZCDS72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 13:59:28 -0500
Subject: Re: Linux 2.6.29-rc6
From: John Stultz <johnstul@us.ibm.com>
To: Jesper Krogh <jesper@krogh.cc>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>
In-Reply-To: <49AECA3B.5030503@krogh.cc>
References: <alpine.LFD.2.00.0902222023520.3111@localhost.localdomain>
	 <49A6F39F.9040801@krogh.cc>
	 <alpine.LFD.2.00.0902261232570.3111@localhost.localdomain>
	 <49A6FEE2.90700@krogh.cc>
	 <1f1b08da0902261319k7a60d80xaafc1101facfd2d9@mail.gmail.com>
	 <49A70B24.6090706@krogh.cc>
	 <1235685269.6811.11.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0902262255190.9135@localhost.localdomain>
	 <1235687483.6811.26.camel@localhost.localdomain>  <49A78C79.304@krogh.cc>
	 <1235766936.7402.5.camel@localhost.localdomain> <49ABACA0.3090300@krogh.cc>
	 <1236029277.7756.0.camel@localhost.localdomain> <49ACC853.8070205@krogh.cc>
		 <1236110026.6068.18.camel@localhost> <49AD90E2.7050209@krogh.cc>
	 <1236118969.6068.87.camel@localhost> <49AE9EA4.2080500@krogh.cc>
	  <49AECA3B.5030503@krogh.cc>
Content-Type: text/plain
Date: Wed, 04 Mar 2009 10:57:55 -0800
Message-Id: <1236193075.3793.63.camel@jstultz-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-04 at 19:36 +0100, Jesper Krogh wrote:
> Jesper Krogh wrote:
> > john stultz wrote:
> >> I guess something to test my idea above (that the drift is bad enough
> >> that NTPd isn't making slew adjustments via adjtimex offset) is to
> >> remove NTPd from the init.d startup.
> >>
> >> Then after rebooting (into 2.6.29), run the attached python script for
> >> 10 minutes or so to get an idea of the ppm drift. Then repeat with
> >> 2.6.26.
> >>
> >> To run: ./drift-test.py <ntp server>
> >>
> >> It will give some wild ppm numbers, but after a few minutes it should
> >> settle down to the "natural drift" of the system.
> > 
> > Ok. I removed ntpd from the system... heres is from "non-working 
> 
> Updated. I think I has NTPd running in the former "non-working" test. I 
> just tried to reproduce the numbers, and they look like this 
> (reproducible on 2.6.29-rc6).

Yea, the last numbers did look odd :)

> jk@quad12:~$ python drift-test.py 10.192.96.19
> 04 Mar 19:27:10         offset: -0.157696       drift: -693.0 ppm
> 04 Mar 19:28:10         offset: -0.195134       drift: -625.098360656 ppm
> 04 Mar 19:29:10         offset: -0.232579       drift: -624.595041322 ppm
> 04 Mar 19:30:10         offset: -0.270021       drift: -624.408839779 ppm
> 04 Mar 19:31:11         offset: -0.307461       drift: -621.727272727 ppm
> 04 Mar 19:32:11         offset: -0.344903       drift: -622.185430464 ppm
> 04 Mar 19:33:11         offset: -0.382345       drift: -622.491712707 ppm
> 04 Mar 19:34:11         offset: -0.419794       drift: -622.727488152 ppm
> 04 Mar 19:35:11         offset: -0.457239       drift: -622.89626556 ppm


Yea, so from this and the settled ntpdc -c kerninfo data before, we can
see that the drift is further out then the 500ppm NTP can handle.

So with that at least confirmed, we can focus back on to the fast-pit
tsc calibration code.

Ingo, Thomas: I'm missing a bit of the context to that patch, other then
just speeding up boot times, was there other rational for moving away
from the ACPI PM timer based calibration?

Could we maybe add a quick test that the pit reads actually take the
assumed 2us max? Doing this maybe via the HPET/ACPI PM?

thanks
-john


