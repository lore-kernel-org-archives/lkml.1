Return-Path: <linux-kernel-owner+w=401wt.eu-S1757351AbYG2IRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351AbYG2IRV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 04:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756246AbYG2IRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 04:17:04 -0400
Received: from wr-out-0506.google.com ([64.233.184.226]:37616 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757412AbYG2IRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 04:17:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=K42VvsGj3YIPM/OWrYB7MBB3Bpw+5QRrUKXSegAz2133itRF4R4VHS9MjBPC3TBTE3
         i8n19jwYHclAolSAhZDcTGLYai3OolSNYAO/PUh8088yAmPkDcU9rXI60EvFBgG6x/2z
         D09QsX0G4JT8JoaPZAnQ1F6ZZ+OIYBFk++VXQ=
Message-ID: <21d7e9970807290116j67a5ebfcv329930ae3003d84f@mail.gmail.com>
Date: Tue, 29 Jul 2008 18:16:58 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1 repost #1] DRM: don't enable irqs in locking
Cc: "=?ISO-8859-1?Q?Thomas_Hellstr=F6m?=" <thomas@tungstengraphics.com>,
       "Jiri Slaby" <jirislaby@gmail.com>, airlied@linux.ie,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <20080729003113.d39851b5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1216975369-6749-1-git-send-email-jirislaby@gmail.com>
	 <21d7e9970807250154q4a1958f5k45f62408e97ae3c7@mail.gmail.com>
	 <488E2CED.1040207@tungstengraphics.com>
	 <20080729003113.d39851b5.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2008 at 5:31 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Mon, 28 Jul 2008 22:32:45 +0200 Thomas Hellstr__m <thomas@tungstengraphics.com> wrote:
>
>> Dave Airlie wrote:
>> > On Fri, Jul 25, 2008 at 6:42 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
>> >
>> >> drm_lock_take(); and drm_lock_free(); are called from
>> >> drm_locked_tasklet_func(); which disables interrupts when grabbing its
>> >> spinlock.
>> >>
>> >> Don't allow these locking functions to re-enable interrupts when
>> >> the tasklet expects them disabled. I.e. use spin_lock_irqsave instead of
>> >> spin_lock_bh (with their unlock opposites).
>> >>
>> >
>> > Hmm this has bounced through 2-3 variations.. Thomas any ideas what
>> > the final correct answer is?
>> >
>> > Dave.
>> >
>> Hmm,
>> Yes, this bug could occur, but the remedy is not to use
>> spin_lock_irqsave() for lock_data::spinlock but to avoid calling
>> drm_lock_take with the drm_device::tasklet_lock held with irqs disabled.
>> I'll see if I can come up with a patch.
>>
>
> The code in drivers/gpu/drm/drm_lock.c needs some serious help in the
> kerneldoc department.
>
>
> /**
>  * Take the heavyweight lock.
>  *
>  * \param lock lock pointer.
>  * \param context locking context.
>  * \return one if the lock is held, or zero otherwise.
>  *
>  * Attempt to mark the lock as held by the given context, via the \p cmpxchg instruction.
>  */
>
> The /** leadin specifically introduces a kerneldoc-formatted comment.
> Yet that comment uses some strange home-made way of denoting function
> arguments.

It not homemade, its a standard used by everyone else called doxygen
:-), the Mesa people wrote the
drm comments so they could have them all in one format, however it
probably makes sense to move
the kernel side ones into kernel format.

Dave.
