Return-Path: <linux-kernel-owner+w=401wt.eu-S1752909AbZDUGoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909AbZDUGoY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 02:44:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750814AbZDUGoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 02:44:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39322 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760AbZDUGoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 02:44:10 -0400
Date: Tue, 21 Apr 2009 08:43:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David VomLehn <dvomlehn@cisco.com>, Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux USB Mailing List <linux-usb@vger.kernel.org>,
       Linux Embedded Mailing List <linux-embedded@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Wait for console to become available, v3.2
Message-ID: <20090421064346.GB8020@elte.hu>
References: <20090420234006.GA1958@cuplxvomd02.corp.sa.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090420234006.GA1958@cuplxvomd02.corp.sa.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David VomLehn <dvomlehn@cisco.com> wrote:

> Parallelization to improve boot times has been successful enough 
> that race conditions now exist between the init_post() open of 
> /dev/console and initialization of the console device. When this 
> occurs, opening /dev/console fails and any applications inherited 
> from init have no standard in/out/error devices. This is expected 
> behavior if no console device is available, but quite unfortunate 
> in the case where the console is just a bit slow waking up.
> 
> Some buses, such as USB, offer no guarantees about how long it 
> takes to discover devices, so there is no reliable way to 
> distinguish between a missing console and a slow one.  The 
> pragmatic approach taken in this patch is to wait for a while to 
> see if a console shows up, and just go on if it doesn't. The 
> default delay is 1000 msec (1 second). This value is conjured out 
> of thing air; any suggestions for a value that more closely 
> approximates the effective delays from the olden days before USB 
> consoles starting failing are more than welcome.

hm, this really seems like a bad hack and a workaround to me and as 
such it is not really an acceptable solution.

The proper approach would be to use one of the async_synchronize*() 
facilities in kernel/async.c to properly order the opening of the 
console with device init.

Certain subsystems like storage (SCSI, libata, mount code and 
modules) has already been extended to this scheme.

So i think the right approach, if you want to speed up bootup, would 
be to extend the same concepts to console discovery, init and open 
methods.

	Ingo
