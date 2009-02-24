Return-Path: <linux-kernel-owner+w=401wt.eu-S1756784AbZBXDYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784AbZBXDYS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 22:24:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751761AbZBXDYB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 22:24:01 -0500
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:46451 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751412AbZBXDYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 22:24:00 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=TBs2nsNIi8VHDnNI7YzL05PJdANh6x9RJDoWXiLwlnmDQB490RC0BRpIcBRHahDARg47EmqZo2LBSujDKMtp2Qg/E32QO6Gf9cIMfADHuzNcSuv2FhXUbEfXJ30Ne/EAVNt3Dcb4XdRdw11ozxkX/y3rbIjIUvZN1ALt7vCJPSo=  ;
X-YMail-OSG: 7mT2w2AVM1lsYZgYNX3lJud_8QhokD5Nrph0zUB7NPgL1_WIZLjdEQMNVMuVRPWs0UKyI9_zTMhlnArlO4uZwGJVh_IJpmeDXK.MRCqFX1q4KbfgOXmIa8XPhp6v8G_79OjGDzFo_RS6MiZu5CS7XbtFrzMA_IEOp9xdiVJizFVdFw50PNeJD9HKe8zOuXn.N9K9FQRWwqac2sa6pLsjIEsLBvLdOiqnsOmtm6H2MMLL
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH] mm: fix lazy vmap purging (use-after-free error)
Date: Tue, 24 Feb 2009 14:23:19 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Vegard Nossum <vegard.nossum@gmail.com>, stable@kernel.org,
       Nick Piggin <npiggin@suse.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org
References: <20090220140157.GA12799@elte.hu> <20090223193351.GA11921@elte.hu> <20090223204359.GT6751@linux.vnet.ibm.com>
In-Reply-To: <20090223204359.GT6751@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902241423.21091.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 February 2009 07:43:59 Paul E. McKenney wrote:
> On Mon, Feb 23, 2009 at 08:33:51PM +0100, Ingo Molnar wrote:
> > * Andrew Morton <akpm@linux-foundation.org> wrote:
> > > On Mon, 23 Feb 2009 08:17:26 -0800 "Paul E. McKenney" 
<paulmck@linux.vnet.ibm.com> wrote:
> > > > On Tue, Feb 24, 2009 at 12:29:36AM +1100, Nick Piggin wrote:
> > > > > On Monday 23 February 2009 16:17:09 Paul E. McKenney wrote:
> > > > > > The boot CPU runs in the context of its idle thread during
> > > > > > boot-up. During this time, idle_cpu(0) will always return
> > > > > > nonzero, which will fool Classic and Hierarchical RCU into
> > > > > > deciding that a large chunk of the boot-up sequence is a big long
> > > > > > quiescent state.  This in turn causes RCU to prematurely end
> > > > > > grace periods during this time.
> > > > > >
> > > > > > This patch creates a new global variable that is set to 1 just
> > > > > > before the boot CPU first enters the scheduler, after which the
> > > > > > idle task really is idle.
> > > > >
> > > > > Nice work all (btw. if this patch goes in rather than using
> > > > > system_state, then please make the variable __read_mostly).
> > > >
> > > > Hmmm...  I misread this and made system_state be __read_mostly.  Let
> > > > me know if this is bad, easy to fix if needed.
> > >
> > > Please don't use system_state.  The whole thing is just bad
> > > design. It's a global variable, breaks encapsulation, creates
> > > interactions etc. CS-101 stuff.
> >
> > ok, i've removed the patch - Paul, would you mind to re-send
> > your original flag solution, with it marked __read_mostly and
> > with the extern declarations put into a suitable header file?
> >
> > Paul, incidentally, this very minute i tracked down that the
> > patch is also causing boot lockups in -tip testing. I havent yet
> > fully debugged it, but a question comes immediately: if there's
> > no grace periods during bootup, wont rcu_sync() & friends just
> > hang indefinitely?
>
> Ouch!!!  Indeed they would.
>
> > More thought is needed.
>
> One fix would be to sprinkle calls to rcu_qsctr_inc() through the
> boot process.  But a much better approach would be for me to make
> synchronize_rcu() check this same flag, and simply return if called
> during early boot.  The rationale for this is that there is but a single
> CPU during early boot, so tinyrcu.c's optimization can be used.  ;-)

Well can you simply return if called if num_online_cpus() == 1, regardless
of the state of boot?

> Out of both paranoia and self defense, I would check num_online_cpus()
> in my proposed call into RCU.  ;-)
>
> Seem reasonable?  And does synchronize_sched() also need the UP-only
> optimization?

