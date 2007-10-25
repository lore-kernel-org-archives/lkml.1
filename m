Return-Path: <linux-kernel-owner+w=401wt.eu-S1761303AbXJYXmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761303AbXJYXmx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 19:42:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752730AbXJYXmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 19:42:44 -0400
Received: from mx1.suse.de ([195.135.220.2]:37331 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752692AbXJYXmn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 19:42:43 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Is gcc thread-unsafe?
Date: Fri, 26 Oct 2007 01:42:37 +0200
User-Agent: KMail/1.9.6
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200710251324.49888.nickpiggin@yahoo.com.au> <200710260116.10904.ak@suse.de> <alpine.LFD.0.999.0710251628440.30120@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0710251628440.30120@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710260142.37902.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 October 2007 01:32:53 Linus Torvalds wrote:
> 
> On Fri, 26 Oct 2007, Andi Kleen wrote:
> > 
> > No it can't (at least not on x86) as I have explained in the rest of the mail 
> > you conveniently snipped.
> 
> I "conveniently snipped it" because it was pointless.
> 
> "adc" or "cmov" has nothing what-so-ever to do with it. If some routine 
> returns 0-vs-1 and gcc then turns "if (routine()) x++" into 
> "x+=routine()", what does that have to do with adc or cmov?

That is not what gcc did in that case. I don't think it tracks sets of values
over function calls (or even inside functions) at all.

The generated code was

          cmpl    $1, %eax                ; test res
          movl    acquires_count, %edx    ; load
          adcl    $0, %edx                ; maybe add 1
          movl    %edx, acquires_count    ; store

So it just added the result of a comparison into a variable
by (ab)using carry for this.

In theory such things can be done with CMOV too by redirecting
a store into a dummy variable to cancel it, but gcc doesn't
do that on its own.

> The fact is, these kinds of optimizations are *bogus* and they are 
> dangerous.

The conditional add/sub using carry trick is not generally bogus. 
It's just bogus for memory addresses not pretty much guaranteed in L1
[aka small stack frame] because there the pipeline benefit is unlikely to 
offset the memory costs (and of course poor quality of implementation because of the 
missing thread safety). 

But for registers it's a fine optimization.

-Andi
