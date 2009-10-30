Return-Path: <linux-kernel-owner+w=401wt.eu-S1756655AbZJ3JOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655AbZJ3JOI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 05:14:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756577AbZJ3JOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 05:14:08 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:59855 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756545AbZJ3JOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 05:14:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Darren Hart <dvhltc@us.ibm.com>
Subject: Re: [PATCH] RFC: futex: make futex_lock_pi interruptible
Date: Fri, 30 Oct 2009 10:13:46 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.31-11-generic; KDE/4.3.1; x86_64; ; )
Cc: "lkml, " <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       "Stultz, John" <johnstul@us.ibm.com>
References: <4AE63E3D.8030903@us.ibm.com> <4AEA3F15.2070900@us.ibm.com> <4AEA4547.30102@us.ibm.com>
In-Reply-To: <4AEA4547.30102@us.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910301013.46923.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18+Pm4sMCwr4C3nHpwLf1O6bHgIVWlX7brHHrF
 8IHwcX9EYcLy3XYFA/nyxzmHk6l+ZlMYT1fkrMVqE/I0wZh97i
 GffVErJ0Ira5EK28g/tSA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 30 October 2009, Darren Hart wrote:
> Darren Hart wrote:
> This appears to work fine. Can anyone think of a reason why this is an unsafe
> thing to do? I'll have to create a much more elaborate test case and review
> the glibc code of course to make sure the glibc mutex state isn't compromised.

The only reason I can see against it is the need to use one of the
rt signal numbers from library code, which may conflict with other
users of the signal. Being able to avoid a signal altogether would
be really nice, as in the futex_cancel extension you mentioned.

> /* Need some kind of per-thread variable here */
> jmp_buf env;
> pthread_mutex_t mutex;

Maybe instead of per-thread variables (which should work
fine), you could do

typedef struct {
	jmp_buf env;
	pthread_mutex_t mutex;
} interruptible_mutex_t;

> 	/* ensure the child has blocked on the lock */
> 	sleep(1);

In a real application, you might want to add some logic to avoid
this kind of race. For the test case, you probably need to do it
with the sleep.

	Arnd <><
