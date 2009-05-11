Return-Path: <linux-kernel-owner+w=401wt.eu-S1757301AbZEKPD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757301AbZEKPD5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 11:03:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757221AbZEKPDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 11:03:42 -0400
Received: from viefep19-int.chello.at ([62.179.121.39]:25505 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757232AbZEKPDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 11:03:40 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH][KVM][retry 1] Add support for Pause Filtering to AMD
 SVM
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Mark Langsdorf <mark.langsdorf@amd.com>,
       Joerg Roedel <joerg.roedel@amd.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <4A083B69.6010702@redhat.com>
References: <200905050909.58583.mark.langsdorf@amd.com>
	 <20090507135522.GJ4059@amd.com> <200905071000.14038.mark.langsdorf@amd.com>
	 <4A02FECC.6060609@redhat.com> <20090511141503.GC6175@elte.hu>
	 <4A083539.407@redhat.com> <20090511143320.GE6175@elte.hu>
	 <4A083B69.6010702@redhat.com>
Content-Type: text/plain
Date: Mon, 11 May 2009 17:01:49 +0200
Message-Id: <1242054109.11251.276.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-05-11 at 17:51 +0300, Avi Kivity wrote:
> Ingo Molnar wrote:
> > * Avi Kivity <avi@redhat.com> wrote:
> >
> >   
> >>> I.e. this is a somewhat poor solution as far as scheduling goes. 
> >>> But i'm wondering what the CPU side does. Can REP-NOP really take 
> >>> thousands of cycles? If yes, under what circumstances?
> >>>       
> >> The guest is running rep-nop in a loop while trying to acquire a 
> >> spinlock.  The hardware detects this (most likely, repeated 
> >> rep-nop with the same rip) and exits.  We can program the loop 
> >> count; obviously if we're spinning for only a short while it's 
> >> better to keep spinning while hoping the lock will be released 
> >> soon.
> >>
> >> The idea is to detect that the guest is not making forward 
> >> progress and yield.  If I could tell the scheduler, you may charge 
> >> me a couple of milliseconds, I promise not to sue, that would be 
> >> ideal. [...]
> >>     
> >
> > Ok, with such a waiver, who could refuse?
> >
> > This really needs a new kernel-internal scheduler API though, which 
> > does a lot of fancy things to do:
> >
> >         se->vruntime += 1000000;
> >
> > i.e. add 1 msec worth of nanoseconds to the task's timeline. (first 
> > remove it from the rbtree, then add it back, and nice-weight it as 
> > well) 
> 
> I suspected it would be as simple as this.

Is that thread guaranteed to run as SCHED_OTHER?

