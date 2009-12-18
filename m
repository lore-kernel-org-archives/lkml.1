Return-Path: <linux-kernel-owner+w=401wt.eu-S1752540AbZLSPz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540AbZLSPz3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 10:55:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752160AbZLSPz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 10:55:28 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34744 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752110AbZLSPz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 10:55:27 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Async suspend-resume patch w/ completions (was: Re: Async suspend-resume patch w/ rwsems)
Date: Sat, 19 Dec 2009 00:42:28 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0912091729530.2672-100000@iolanthe.rowland.org> <200912170249.00676.rjw@sisk.pl> <200912180251.22655.rjw@sisk.pl>
In-Reply-To: <200912180251.22655.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912190042.28884.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 December 2009, Rafael J. Wysocki wrote:
> On Thursday 17 December 2009, Rafael J. Wysocki wrote:
> ...
> > Tomorrow I'll try to mark as many devices as reasonably possible as async
> > and see how the total suspend-resume times change.
> 
> I didn't manage to do that, but I was able to mark sd and i8042 as async and
> see the impact of this.
> 
> The raw data are in the usual place:
> 
> http://www.sisk.pl/kernel/data/async-suspend-resume.pdf
> 
> and the individual device timings and logs are in:
> 
> http://www.sisk.pl/kernel/data/nx6325/
> http://www.sisk.pl/kernel/data/wind/
> 
> This is the summary (previous results are inculded for easier reference):
> 
> 			HP nx6325	MSI Wind U100
> 
> sync suspend		1482 (+/- 40)	1180 (+/- 24)
> sync resume		2955 (+/- 2)	3597 (+/- 25)
> 
> async suspend		1553 (+/- 49)	1177 (+/- 32)
> async resume		2692 (+/- 326)	3556 (+/- 33)
> 
> async+one-liner suspend	1600 (+/- 39)	1212 (+/- 41)
> async+one-liner resume	2692 (+/- 324)	3579 (+/- 24)
> 
> async+extra suspend	1496 (+/- 37)	1217 (+/- 38)
> async+extra resume	1859 (+/- 114)	1923 (+/- 35)
> 
> with "async" i8042 and sd:
> 
> async suspend		1319 (+/- 51)	1045 (+/- 41)
> async resume		2929 (+/- 3)	3546 (+/- 27)
> 
> async+extra suspend	1327 (+/- 36)	(didn't work)
> async+extra resume	1742 (+/- 164)	1896 (+/- 28)
> 
> (the summary is also available at: http://www.sisk.pl/kernel/data/results.txt).
> 
> So, it actually makes the case for async suspend!  Although it's not very
> strong, with these two additional devices marked as "async" we get noticeable
> suspend time improvement.
> 
> Still, the "extra" patch doesn't help on suspend at all and on the Wind the
> suspend part of it didn't even work (I'm yet to figure out which of the two
> devices crashed the suspend).

Small update.  I've just verified that sd was the failing device, although I'm
not sure about the reason.

Apart from this, I ran some tests on the Wind with i8042 marked as "async"
and sd marked as "sync".  In that case all of the tests succeeded and I got
the following numbers:

suspend (i8042 async, full extra patch applied): 1070 (+/- 40)
resume (i8042 async, full extra patch applied): 1915,84 (+/- 27)
suspend (i8042 async, resume part of extra patch applied): 1050 (+/- 34)

First, It looks like the suspend speedup was related to marking i8042 as
"async".  Since the serio devices, which are the i8042's children, were also
"async" (just like in all of the tests before), this means that the speedup
resulted from removing a suspend stall caused by a sync parent of async
children (i8042 and serio, respectively, in this case).

However, the suspend part of the extra patch doesn't help really.  In fact it
even makes things worse.

So, I still think the resume part of the extra patch is definitely useful, but
the suspend part of it is not.  IOW, it's worth running async resumes upfront,
but it's not worth running async suspends upfront.

Rafael
