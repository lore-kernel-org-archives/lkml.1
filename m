Return-Path: <linux-kernel-owner+w=401wt.eu-S935001AbXGRRbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935001AbXGRRbv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 13:31:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932457AbXGRRbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 13:31:39 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:37301 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761752AbXGRRbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 13:31:38 -0400
X-Sasl-enc: 7TPlTBQelf6wKZDMC8d4GEDW1V0E4ivDtHyRUgUMsKps 1184779896
Subject: Re: [patch] CFS scheduler, -v19
From: Ian Kent <raven@themaw.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Chuck Ebbert <cebbert@redhat.com>,
       Bill Davidsen <davidsen@tmr.com>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.0.999.0707180852540.27353@woody.linux-foundation.org>
References: <20070706173319.GA2356@elte.hu>
	 <1184054902.12336.19.camel@Homer.simpson.net> <469512C1.6090406@tmr.com>
	 <20070711205556.GA27266@elte.hu> <4697EC49.4070303@tmr.com>
	 <469BE462.9030004@redhat.com> <20070716215541.GA27171@elte.hu>
	 <1184648474.3188.33.camel@raven.themaw.net>
	 <20070717074537.GA13539@elte.hu>
	 <alpine.LFD.0.999.0707180852540.27353@woody.linux-foundation.org>
Content-Type: text/plain
Date: Thu, 19 Jul 2007 01:31:31 +0800
Message-Id: <1184779891.4178.56.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-3.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-18 at 09:03 -0700, Linus Torvalds wrote:
> 
> On Tue, 17 Jul 2007, Ingo Molnar wrote:
> > 
> > * Ian Kent <raven@themaw.net> wrote:
> > > 
> > > In several places I have code similar to:
> > > 
> > > wait.tv_sec = time(NULL) + 1;
> > > wait.tv_nsec = 0;
> 
> Ok, that definitely should work.
> 
> Does the patch below help?
> 
> > ah! It passes in a low-res time source into a high-res time interface 
> > (pthread_cond_timedwait()). Could you change the time(NULL) + 1 to 
> > time(NULL) + 2, or change it to:
> > 
> > 	gettimeofday(&wait, NULL);
> > 	wait.tv_sec++;
> 
> This is wrong. It's wrong for two reasons:
> 
>  - it really shouldn't be needed. I don't think "time()" has to be 
>    *exactly* in sync, but I don't think it can be off by a third of a 
>    second or whatever (as the "30% CPU load" would seem to imply)
> 
>  - gettimeofday works on a timeval, pthread_cond_timedwait() works on a 
>    timespec.
> 
> So if it actually makes a difference, it makes a difference for the 
> *wrong* reason: the time is still totally nonsensical in the tv_nsec field 
> (because it actually got filled in with msecs!), but now the tv_sec field 
> is in sync, so it hides the bug.

Oh ya .. I thought it wouldn't hurt to add the fraction of the current
second for correctness and actually put things like:

gettimeofday(&now, NULL);
wait.tv_sec = now.tv_sec + 1;
wait.tv_nsec = now.tv_usec * 1000;

in autofs.

Ian


