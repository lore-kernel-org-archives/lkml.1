Return-Path: <linux-kernel-owner+w=401wt.eu-S1756843AbZCRDGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843AbZCRDGk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 23:06:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755550AbZCRDGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 23:06:10 -0400
Received: from n25.bullet.mail.mud.yahoo.com ([68.142.206.220]:32828 "HELO
	n25.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752922AbZCRDGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 23:06:07 -0400
X-Yahoo-Newman-Id: 532594.33223.bm@omp409.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=NQC4mtx2aeL2m1ihu11AkteUmdXf7Bll1HJtP5osAqHaaK5jZFYAaC/VkY2FH1vCSYgtGGAtWPaF2ULwjZo0s9isuemb6Ye6wZ8Q6WFdxtqGpSgC/c77N0dEAkBgMzz3AkwuH+QfPJWoZPUXcUYtsdg6F9K7a9eNmpncjBWG5/4=  ;
X-YMail-OSG: Gc2qRtoVM1k7aTcViwM8VNRBsY75Vo.XMZ9ZGSesYwDRrLeM8fzJxBuLC_rKz3esWW5o8OPoqhBUE_SNzfbT25K.ZZQ4uBj8PnHCtDpYYmFEgfxa2uSC3fOxDGr_MIsKk5EDROPFhq5ZgdbhWPCme179
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: lockdep and threaded IRQs (was: ...)
Date: Tue, 17 Mar 2009 19:00:30 -0700
User-Agent: KMail/1.9.10
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>, me@felipebalbi.com,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       felipe.balbi@nokia.com, dmitry.torokhov@gmail.com, sameo@openedhand.com,
       tglx@linutronix.de
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com> <200903021633.08736.david-b@pacbell.net> <20090303004427.GA8638@elte.hu>
In-Reply-To: <20090303004427.GA8638@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200903171900.30800.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 March 2009, Ingo Molnar wrote:
> 
> > > Since you care about them - could you please send patches on top 
> > > of the IRQ threading patches to add support for them?
> > 
> > I'll look at that, and try to prepare something on top
> > of the version of the threading patches that gets into
> > the -next tree.  I got the impression there was going
> > to be a v3 of those patches soonish...
> 
> Great! We'll sort out any conflicts so dont worry about that - 
> you can pick up v2 just fine and post patches.

One such patch is about to come, with different $SUBJECT
and trimmed CC list.

Note however that it's completely independent of Thomas'
patches.  It only affects the IRQ dispatch sub-problem;
other bits seem to be needed too.


> If you mean to push the chaining bits into the IRQ thread too, i 
> think the chaining bits actually should never be threaded. Is 
> there a good reason to do that? 

The chaining bits *MUST* be threaded.  The lack of that
support was a key issue with Thomas' patch.  The issue
being that access to the IRQ status registers, as needed
to dispatch the IRQ, is only possible in contexts that
can sleep.  That seems like a good reason.  :)


> It's not like they will really  
> be preemptible (preempting a chaining thread would mean the 
> whole demuxing chain is held up => bad).

See above.  The reason to thread this IRQ handling is
that it can't be done outside of threads ... there's
no other way to access registers via I2C (or SPI, etc).

Accordingly there's no way to avoid preemption ... but
since these IRQs aren't on performance-critical paths,
that's really no bother.



