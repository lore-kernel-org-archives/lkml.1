Return-Path: <linux-kernel-owner+w=401wt.eu-S1751987AbXAaGxJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987AbXAaGxJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 01:53:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751943AbXAaGxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 01:53:09 -0500
Received: from moutng.kundenserver.de ([212.227.126.179]:60927 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179AbXAaGxH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 01:53:07 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: cbe-oss-dev@ozlabs.org, maynardj@us.ibm.com
Subject: Re: [Cbe-oss-dev] [RFC, PATCH 4/4] Add support to OProfile for profiling Cell BE SPUs -- update
Date: Wed, 31 Jan 2007 07:52:48 +0100
User-Agent: KMail/1.9.5
Cc: linuxppc-dev@ozlabs.org, oprofile-list@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
References: <45BE4ED0.5030808@us.ibm.com> <45BFBB78.7060907@us.ibm.com> <45BFCC8E.4000008@us.ibm.com>
In-Reply-To: <45BFCC8E.4000008@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200701310752.48632.arnd@arndb.de>
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:c48f057754fc1b1a557605ab9fa6da41
X-Provags-ID2: V01U2FsdGVkX18B2wypXxodavw5uSI/l6j3UJuFfyO7GYBp4WlAQTwBdwImeViqrDpI5pVac15N5DOEK7RD1N8ZbMR/pNRuQh+Q0OrSjSkvLbs9IpJ5AH/9kQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 January 2007 23:54, Maynard Johnson wrote:

> >>Why do you store them per spu in the first place? The physical spu
> >>doesn't have any relevance to this at all, the only data that is
> >>per spu is the sample data collected on a profiling interrupt,
> >>which you can then copy in the per-context data on a context switch.
> > 
> > The sample data is written out to the event buffer on every profiling 
> > interrupt.  But we don't write out the SPU program counter samples 
> > directly to the event buffer.  First, we have to find the cached_info 
> > for the appropriate SPU context to retrieve the cached vma-to-fileoffset 
> > map.  Then we do the vma_map_lookup to find the fileoffset corresponding 
> > to the SPU PC sample, which we then write out to the event buffer.  This 
> > is one of the most time-critical pieces of the SPU profiling code, so I 
> > used an array to hold the cached_info for fast random access.  But as I 
> > stated in a code comment above, the negative implication of this current 
> > implementation is that the array can only hold the cached_info for 
> > currently running SPU tasks.  I need to give this some more thought.
> 
> I've given this some more thought, and I'm coming to the conclusion that 
> a pure array-based implementation for holding cached_info (getting rid 
> of the lists) would work well for the vast majority of cases in which 
> OProfile will be used.  Yes, it is true that the mapping of an SPU 
> context to a phsyical spu-numbered array location cannot be guaranteed 
> to stay valid, and that's why I discard the cached_info at that array 
> location when the SPU task is switched out.  Yes, it would be terribly 
> inefficient if the same SPU task gets switched back in later and we 
> would have to recreate the cached_info.  However, I contend that 
> OProfile users are interested in profiling one application at a time. 
> They are not going to want to muddy the waters with multiple SPU apps 
> running at the same time.  I can't think of any reason why someone would 
> conscisouly choose to do that.
> 
> Any thoughts from the general community, especially OProfile users?
> 
Please assume that in the near future we will be scheduling SPU contexts
in and out multiple times a second. Even in a single application, you
can easily have more contexts than you have physical SPUs.

The event buffer by definition needs to be per context. If you for some
reason want to collect the samples per physical SPU during an event
interrupt, you should at least make sure that they are copied into the
per-context event buffer on a context switch.

At the context switch point, you probably also want to drain the
hw event counters, so that you account all events correctly.

We also want to be able to profile the context switch code itself, which
means that we also need one event buffer associated with the kernel to
collect events that for a zero context_id.

Of course, the recording of raw samples in the per-context buffer does
not need to have the dcookies along with it, you can still resolve
the pointers when the SPU context gets destroyed (or an object gets
unmapped).

	Arnd <><
