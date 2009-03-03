Return-Path: <linux-kernel-owner+w=401wt.eu-S1757578AbZCCEay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578AbZCCEay (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 23:30:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753601AbZCCEap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 23:30:45 -0500
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:25099 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752827AbZCCEao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 23:30:44 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=47ZFn6/cV1NK9FRrU/isws7A8Kc1dzPlPwwm92jOX40uuibRfKehJr+qN4+uq5H2cPdP4GJs5ezQlzMlIcOlCIXbi46GcJmw0FvSppnPmHJiLfP+1HWpsRmXZus6PN4Pip6kaP/5Je4Gq+zAyckcLTBxU45gESputRi2zgHzhXM=  ;
X-YMail-OSG: Kf1xSd0VM1nRZsTkv_WL5A0tvgB6MVfP323zCb4H5PXNUuiin915kohLhpM1ePnDGatfDh3gXv1ysyv3vWY8IiXGrUwQw8GOwpuPbNomNY2fuFMMANwbOBw2IcfOK9x00e43Evsjjwg_3m64Q8KO1Qq1BJlCQ4a9ZCMD8.k23gd.OnBxeMSGtU5a9hP64sJWqUcq8k97nESOmZc5SfmuLmQoOPZVXjHE7L7Uxp_QHQ3G
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] x86, mm: pass in 'total' to __copy_from_user_*nocache()
Date: Tue, 3 Mar 2009 15:30:04 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
       sqazi@google.com, linux-kernel@vger.kernel.org, tglx@linutronix.de
References: <alpine.LFD.2.00.0902280904271.3111@localhost.localdomain> <alpine.LFD.2.00.0903021255020.3111@localhost.localdomain> <20090302212543.GD20228@elte.hu>
In-Reply-To: <20090302212543.GD20228@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903031530.05238.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 March 2009 08:25:43 Ingo Molnar wrote:
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > We can play games in the kernel. We do know how many sockets
> > there are. We do know the cache size. We _could_ try to make
> > an educated guess at whether the next user of the data will be
> > DMA or not. So there are unquestionably heuristics we could
> > apply, but I also do suspect that they'd inevitably be pretty
> > arbitrary.
>
> There's a higher-level meta-code argument to consider as well,
> and i find it equally important: finding this rather obvious and
> easy to measure performance regression caused by the
> introduction of MOVNT took us two years.
>
> That's _way_ too long - and adding more heuristics and more
> complexity will just increase this latency. (as we will create
> small niches of special cases with special workloads where we
> might or might not regress)
>
> So, if any such change is done, we can only do it if we have the
> latency of performance-regression-finding on the order of days
> or at most weaks - not years.

Something like temporal vs nontemporal stores, into the pagecache,
is a fundamental tradeoff that will depend on userspace access
pattern that the kernel can't know about. For the kernel side of
the equation, we could query the underlying backing store to see
whether it is going to do any CPU operations on the data before
writeout, eg checksumming or encryption etc. but even then, the
latency between dirtying the pagecache and initiating the writeout
means that it is probably not in cache any longer at the time of
writeout anyway. So the primary factor really is userspace access
patterns I think.

In situations like that, I think the only way to really "solve"
the problem is to provide a way for userspace to ask for temporal
or nontemporal access. Yeah this is just passing the buck, and
probably most apps that try to use this will do no better job than
the kernel :) But it allows ones that really care to give the
kernel much better information.

