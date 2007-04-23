Return-Path: <linux-kernel-owner+w=401wt.eu-S1751630AbXDWICL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751630AbXDWICL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 04:02:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752800AbXDWICL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 04:02:11 -0400
Received: from wx-out-0506.google.com ([66.249.82.236]:5834 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbXDWICH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 04:02:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Q2oBs5yz+qQmurXTsaXn3CwGl+uKuiQFCQo5txrr1Xi7xLhA0+cyCwbwgbg8MUZsqcB1WDCVRv72xt4m4zM6/CijpSzsF3K9+N+J27JVQuAn6FToUkS52JBY5E+SuGY17lr1J7GlSloaysxnSFkmySaxpV+ntadjjk4kGI7TGqY=
Message-ID: <a781481a0704230102g1ddd7c33heb65150487228a06@mail.gmail.com>
Date: Mon, 23 Apr 2007 13:32:06 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Eddie C. Dost" <ecd@atecom.com>
Subject: Re: [PATCH] use spinlock instead of binary mutex in idt77252 driver
Cc: "Matthias Kaehlcke" <matthias.kaehlcke@gmail.com>,
       "Kyle Moffett" <mrmacman_g4@mac.com>, chas@cmf.nrl.navy.mil,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070423074019.GA14549@gannet>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070422213959.GP5013@traven>
	 <45C4C5F0-4F09-416D-A237-82FC28DF1883@mac.com>
	 <20070423065520.GR5013@traven> <20070423071608.GA15338@gannet>
	 <20070423074026.GC10339@traven> <20070423074019.GA14549@gannet>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 4/23/07, Eddie C. Dost <ecd@atecom.com> wrote:
> as long as mutexes are not converted to nop when CONFIG_SMP is not
> defined (I don't know what current kernels do), this is of course
> correct. You need to verify the headerfiles for the above.

Yes, even on UP different threads accessing the same data could race.
Mutexes (== binary semaphores) are *required* to synchronize access to
shared data.

You might be confusing mutexes with spinlocks. Spinlocks _are_
compiled away on UP (actually !CONFIG_SMP && !CONFIG_PREEMPT) kernels,
but that is still safe because spinlocks are busy-waiting loops
(unlike mutexes and semaphores that block) and hence no thread is
allowed to sleep when holding a spinlock.

> On Mon, Apr 23, 2007 at 09:40:26AM +0200, Matthias Kaehlcke wrote:
> > El Mon, Apr 23, 2007 at 09:16:08AM +0200 Eddie C. Dost ha dit:
> > > Please note that the semaphore is used to lock the idt77252 config
> > > tables among multiple users including atmsigd even on single processor
> > > machines. Does this work with mutexes?
> >
> > afaik mutexes have the same behaviour as binary semaphores that are
> > used as mutexes (always locked and unlocked by the same
> > process/thread):

Mutexes / binary semaphores / spinlocks are used to synchronize access
to shared data by *multiple* threads ... there is no meaning in
locking access to something if we know only one thread will ever touch
it.

Cheers,
S
