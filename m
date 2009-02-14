Return-Path: <linux-kernel-owner+w=401wt.eu-S1753222AbZBNDP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222AbZBNDP3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 22:15:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750778AbZBNDPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 22:15:15 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:4707 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbZBNDPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 22:15:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xQIX8fyDFo0BOQEiN3T6oVJ+iUzNLXPRxcYH/8cfOjuykwF79MS/7CZ6Szxz9PSANr
         U1R5F5C30utZb4sFeH7h/3D7ZmFn1XXwIPBzVj8MHSKZcgSbaamEvzaG4I9W69WF8U4o
         NUYoCD437FpEak2NpmYZfCQmZqlRGea3QFfq4=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0902130956400.3179@localhost.localdomain>
References: <20090212023308.GA21157@linux.vnet.ibm.com>
	 <20090212215959.GN6759@linux.vnet.ibm.com>
	 <200902140050.44550.nickpiggin@yahoo.com.au>
	 <20090213145653.GA6854@linux.vnet.ibm.com>
	 <20090213151045.GA1574@Krystal> <20090213155507.GA2838@Krystal>
	 <alpine.LFD.2.00.0902130808050.3099@localhost.localdomain>
	 <20090213173352.GB4684@Krystal>
	 <alpine.LFD.2.00.0902130945350.3179@localhost.localdomain>
	 <alpine.LFD.2.00.0902130956400.3179@localhost.localdomain>
Date: Fri, 13 Feb 2009 22:15:03 -0500
Message-ID: <8bd0f97a0902131915w37431976j873107d9876aca3d@mail.gmail.com>
Subject: Re: [Uclinux-dist-devel] [ltt-dev] [RFC git tree] Userspace RCU 
	(urcu) for Linux (repost)
From: Mike Frysinger <vapier.adi@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org,
       ltt-dev@lists.casi.polymtl.ca, uclinux-dist-devel@blackfin.uclinux.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 13, 2009 at 13:09, Linus Torvalds wrote:
> Btw, for user space, if you want to do this all right for something like
> BF. I think the only _correct_ thing to do (in the sense that the end
> result will actually be debuggable) is to essentially give full SMP
> coherency in user space.
>
> It's doable, but rather complicated, and I'm not 100% sure it really ends
> up making sense. The way to do it is to just simply say:
>
>  - never map the same page writably on two different cores, and always
>   flush the cache (on the receiving side) when you switch a page from one
>   core to another.
>
> Now, the kernel can't really do that reasonably, but user space possibly could.
>
> Now, I realize that blackfin doesn't actually even have a MMU or a TLB, so
> by "mapping the same page" in that case we end up really meaning "having a
> shared mapping or thread". I think that _should_ be doable. The most
> trivial approach might be to simply limit all processes with shared
> mappings or CLONE_VM to core 0, and letting core 1 run everything else
> (but you could do it differently: mapping something with MAP_SHARED would
> force you to core 0, but threads would just force the thread group to
> stay on _one_ core, rather than necessarily a fixed one).
>
> Yeah, because of the lack of real memory protection, the kernel can't
> _know_ that processes don't behave badly and access things that they
> didn't explicitly map, but I'm hoping that that is rare.
>
> And yes, if you really want to use threads as a way to do something
> across cores, you'd be screwed - the kenrel would only schedule the
> threads on one CPU. But considering the undefined nature of threading on
> such a cpu, wouldn't that still be preferable? Wouldn't it be nice to have
> the knowledge that user space _looks_ cache-coherent by virtue of the
> kernel just limiting cores appropriately?

the BF pseudo SMP does not allow threaded processes to run on multiple
cores simultaneously because of this desync crap.

well, the BF hardware does have optional memory protection, but the
overhead is often too great for most people.  it performs well enough
to do debugging, but not for people trying to multimedia and other fun
stuff.
-mike
