Return-Path: <linux-kernel-owner+w=401wt.eu-S1760608AbZLKHav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760608AbZLKHav (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 02:30:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759151AbZLKHaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 02:30:46 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:1346 "EHLO
	VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754536AbZLKHap convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 02:30:45 -0500
X-SpamScore: -33
X-BigFish: VPS-33(zz1432R98dN936eM148cM9371Pzz1202hzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KUH8V0-01-A9K-02
X-M-MSG: 
Date: Fri, 11 Dec 2009 08:30:39 +0100
From: Borislav Petkov <borislav.petkov@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Aristeu Rozanski <aris@redhat.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Doug Thompson <norsk5@yahoo.com>, linux-kernel@vger.kernel.org,
       x86 <x86@kernel.org>
Subject: Re: [PATCH] x86, msr: add support for non-contiguous cpumasks
Message-ID: <20091211073039.GA21312@aftab>
References: <20091207122133.GA24877@aftab>
 <4B21A50E.5090801@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <4B21A50E.5090801@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 11 Dec 2009 07:30:36.0564 (UTC) FILETIME=[D4CD8540:01CA7A33]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 10, 2009 at 05:49:02PM -0800, H. Peter Anvin wrote:
> On 12/07/2009 04:21 AM, Borislav Petkov wrote:
> >  
> >  struct msr {
> > +	int cpu;
> >  	union {
> >  		struct {
> >  			u32 l;
> 
> I really don't like this patch, for multiple reasons.  One of them is
> the above: this has no business being part of struct msr, which reflects
> an MSR value (and ideally should replace at least the use of two
> pointers in other places over time).  Having a CPU field and not an MSR
> number field particular doesn't make any sense.

Why, MSRs are per-CPU. My reasoning here is to reflect the value of an
MSR on a particular CPU...

[..]

> The ideal probably would be to use a percpu variable.  Now, this would
> either have to be a dynamic percpu allocation (which would have to be
> the responsibility of the caller, and reused, lest this would be a
> *very* expensive proposition), or we would have to make these functions
> run under a mutex.  However, as long as the expected callers of this are
> things that get set up once and then pretty much stick around, a percpu
> variable might just work.

I think this would be the cleanest way. Also, best it'll be to allocate
those dynamically only when they're really needed (e.g. on driver
loading) and later reuse them.

[..]

> The third option would be to at least require that the struct msr
> contents are at least serial in the order of the bitmask, not by adding
> another field.

I had that version already done but it seemed half-baked and clumsy for
the MSRs array to traverse. I'll give the percpu variables a shot and
get back to you when I have something ready.

Thanks for reviewing.

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

