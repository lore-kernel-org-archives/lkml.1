Return-Path: <linux-kernel-owner+w=401wt.eu-S1757314AbXELFpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314AbXELFpx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 01:45:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbXELFpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 01:45:46 -0400
Received: from ik-out-1112.google.com ([66.249.90.183]:12256 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbXELFpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 01:45:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lcaK0jxe37ydfWuHqSXuTSwf0h6MEuBoU//2DY1AzcKDPzC0PmSeQQvwcF7XWhCXzBmLs4SXoyUCRaaK2V+dYQlLN4rCDgEe+E5HAAwr5YZY3HxCt60dgQXyhn/qo/tLOqphcHO0kWB/xZr5JW+fWZXZwBuJZR9HEtU3Wupd1zw=
Message-ID: <a781481a0705112245u356759dcm9a550e432ed178fd@mail.gmail.com>
Date: Sat, 12 May 2007 11:15:43 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Dmitry Torokhov" <dtor@insightbb.com>
Subject: Re: 2.6.21-mm2: HDAPS? BUG: at kernel/mutex.c:311
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Matt Mackall" <mpm@selenic.com>, rlove@rlove.org,
       linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <200705120112.52859.dtor@insightbb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070512002115.GZ11166@waste.org>
	 <20070511175335.092aa0af.akpm@linux-foundation.org>
	 <200705120112.52859.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On 5/12/07, Dmitry Torokhov <dtor@insightbb.com> wrote:
> On Friday 11 May 2007 20:53, Andrew Morton wrote:
> > Ho hum. I suppose a suitable workaround would be to convert hdaps_mtx back
> > into a semaphore. ug.
>
> Actually I was looking for victimes^Wvolunteers to test the patch below.
> It gets rid of _trylock business.

Ah! You just beat me here, and your patch is definitely better.

I was wondering why this driver wanted to use a mutex (previously the
semaphore) to synchronize between process and interrupt context in the
first place. Most of the code in here uses synchronous delays so never
sleeps anyway, but then unfortunately it does a weird
repeated-waiting-hardware-status-register-check thingy in its .probe()
which meant a straightforward mutex -> spinlock wasn't possible.

So then made a patch pushing off the poll to keventd workqueue, when
I saw your mail that does exactly the same, but wrapped about in the
generic input-polldev infrastructure! It's barely 12 days old in mainline --
no wonder I didn't know about it. Seems to be good-looking code!

Thanks,
Satyam
