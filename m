Return-Path: <linux-kernel-owner+w=401wt.eu-S1760709AbXJYW4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760709AbXJYW4e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 18:56:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753880AbXJYW40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 18:56:26 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:24573 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752972AbXJYW4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 18:56:25 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=DVQbcmvi9lJ6PbZEOrGJ6aOV0gyCdkwgU3V+jVbXiONVkpysWgvjdewHW9Ah5u1TSvIwNa0gz+hCfd8U5ij6myyjtC4YXcnjfdVRuoHRThnU/3Lva+Ong8YMB/5ZhnfKFkg5GU72ju3jYl18kZrxMwOQ9kY0JCsbWgjoXgkGEFE=  ;
X-YMail-OSG: U_js2LcVM1n.7y7Ja_UYWsMLpdOprikofVZ.ty1zBDhulSDGP8KgNrBRUH4NuIiLZnjAX6Otjw--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andi Kleen <ak@suse.de>
Subject: Re: Is gcc thread-unsafe?
Date: Fri, 26 Oct 2007 08:49:42 +1000
User-Agent: KMail/1.9.5
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <200710251324.49888.nickpiggin@yahoo.com.au> <200710250915.50675.ak@suse.de>
In-Reply-To: <200710250915.50675.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710260849.42776.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 October 2007 17:15, Andi Kleen wrote:
> On Thursday 25 October 2007 05:24, Nick Piggin wrote:
> > Basically, what the gcc developers are saying is that gcc is
> > free to load and store to any memory location, so long as it
> > behaves as if the instructions were executed in sequence.
>
> This case is clearly a bug, a very likely code pessimization.
> I guess it wasn't intentional, just an optimization that is useful
> for local register values doing too much.

Although there can be cases where it looks much more like an
optimisation (eg. where the branch and increment occurs much
more often), but it would still be a bug. Granted they are
rather constructed cases, but I don't think you want to rely on
the fact that most of the time it's OK.


> > I guess that dynamically allocated memory and computed pointers
> > are more difficult for gcc to do anything unsafe with, because
> > it is harder to tell if a given function has deallocated the
> > memory.
>
> Often accesses happen without function calls inbetween.
> Also I think newer gcc (not 3.x) can determine if a pointer
> "escapes" or not so that might not protect against it.
>
> > Any thoughts?
>
> We don't have much choice: If such a case is found it has to be marked
> volatile or that particular compiler version be unsupported.

Marking volatile I think is out of the question. To start with,
volatile creates really poor code (and most of the time we actually
do want the code in critical sections to be as tight as possible).
But also because I don't think these bugs are just going to be
found easily.


> It might be useful to come up with some kind of assembler pattern
> matcher to check if any such code is generated for the kernel
> and try it with different compiler versions.

Hard to know how to do it. If you can, then it would be interesting.
