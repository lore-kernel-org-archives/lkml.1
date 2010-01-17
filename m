Return-Path: <linux-kernel-owner+w=401wt.eu-S1752443Ab0AQMxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443Ab0AQMxr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 07:53:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752178Ab0AQMxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 07:53:46 -0500
Received: from relay2.sgi.com ([192.48.179.30]:60019 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752174Ab0AQMxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 07:53:45 -0500
Date: Sun, 17 Jan 2010 06:53:43 -0600
From: Robin Holt <holt@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Roel Kluin <roel.kluin@gmail.com>, Cliff Wickman <cpw@sgi.com>,
       Robin Holt <holt@sgi.com>, Mike Travis <travis@sgi.com>,
       Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: bau_msg_head points to a_queue_first in
 uv_table_bases_finish()
Message-ID: <20100117125343.GZ6616@sgi.com>
References: <4B507093.6050002@gmail.com>
 <20100117071227.GC19512@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100117071227.GC19512@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 17, 2010 at 08:12:27AM +0100, Ingo Molnar wrote:
> 
> * Roel Kluin <roel.kluin@gmail.com> wrote:
> 
> > bau_msg_head should point to bau_msg_head
> > 
> > Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> > ---
> > Is this correct?
> > 
> > diff --git a/arch/x86/kernel/tlb_uv.c b/arch/x86/kernel/tlb_uv.c
> > index 364d015..3d66331 100644
> > --- a/arch/x86/kernel/tlb_uv.c
> > +++ b/arch/x86/kernel/tlb_uv.c
> > @@ -691,7 +691,7 @@ uv_table_bases_finish(int blade,
> >  			continue;
> >  
> >  		bcp = (struct bau_control *)&per_cpu(bau_control, cpu);
> > -		bcp->bau_msg_head	= bau_tablesp->va_queue_first;
> > +		bcp->bau_msg_head	= bau_tablesp->bau_msg_head;
> >  		bcp->va_queue_first	= bau_tablesp->va_queue_first;
> >  		bcp->va_queue_last	= bau_tablesp->va_queue_last;
> >  		bcp->msg_statuses	= bau_tablesp->msg_statuses;
> 
> Seems like you either caught a real bug - or that there's a somewhat quirky 
> initialization sequence here which should be commented upon in the source.
> 
> Cliff, Robin, what's your take on Roel's patch?

I think I will work with Cliff on rewriting uv_payload_queue_init().

Currently, that does not set up bau_msg_head so the code above is
functional.  In my opinion, it should set up bau_msg_head.  I am sure
I can be convinced otherwise.

Some of the other cleanups:

1)  Use the standard alignment macros instead of hand coding our own.
2)  Replace the kmalloc with a kzalloc and remove the memset which
    currently is zeroing the unaligned allocation instead of the aligned
    allocation so it would miss the last (up to 31) bytes of the last
    payload.

Thanks,
Robin
