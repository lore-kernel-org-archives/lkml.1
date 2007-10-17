Return-Path: <linux-kernel-owner+w=401wt.eu-S935134AbXJQAW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935134AbXJQAW6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 20:22:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760278AbXJQAWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 20:22:49 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:40793 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751849AbXJQAWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 20:22:48 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=nFQpV/77Wfl6C47QfJ+4FfjrX+r+gua5aEfbRDmAjY7oW/h57MvXC4xHXbsR+A7IAZp8//2nAOh9Ecrw85Geq3xNGHNmJ3KEfiorh+VDRmsSf7qe8Txf02630qWW+0ybaKsGg7eCXA3bAcNzRLmt5lN3mWOW5CEM5sNLoOyCsPQ=  ;
X-YMail-OSG: VJokzWwVM1mB66gyBKXIbXOUBAHV3l5.iPrZ9db1BD3SHwf3OR6Lnm6UigDcCNmQOGA.yDnbwQ--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patch][rfc] rewrite ramdisk
Date: Wed, 17 Oct 2007 10:28:22 +1000
User-Agent: KMail/1.9.5
Cc: Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       Christian Borntraeger <borntraeger@de.ibm.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
References: <200710151028.34407.borntraeger@de.ibm.com> <200710170808.30944.nickpiggin@yahoo.com.au> <m1ve96fwpa.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1ve96fwpa.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710171028.23226.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 October 2007 09:48, Eric W. Biederman wrote:
> Nick Piggin <nickpiggin@yahoo.com.au> writes:
> > On Wednesday 17 October 2007 07:28, Theodore Tso wrote:
> >> On Tue, Oct 16, 2007 at 05:47:12PM +1000, Nick Piggin wrote:
> >> > +	/*
> >> > +	 * ram device BLKFLSBUF has special semantics, we want to actually
> >> > +	 * release and destroy the ramdisk data.
> >> > +	 */
> >>
> >> We won't be able to fix completely this for a while time, but the fact
> >> that BLKFLSBUF has special semantics has always been a major wart.
> >> Could we perhaps create a new ioctl, say RAMDISKDESTORY, and add a
> >> deperecation printk for BLKFLSBUF when passed to the ramdisk?  I doubt
> >> there are many tools that actually take advantage of this wierd aspect
> >> of ramdisks, so hopefully it's something we could remove in a 18
> >> months or so...
> >
> > It would be nice to be able to do that, I agree. The new ramdisk
> > code will be able to flush the buffer cache and destroy its data
> > separately, so it can actually be implemented.
>
> So the practical problem are peoples legacy boot setups but those
> are quickly going away.

After that, is the ramdisk useful for anything aside from testing?


> The sane thing is probably something that can be taken as a low
> level format command for the block device.
>
> Say: dd if=/dev/zero of=/dev/ramX

We have 2 problems. First is that, for testing/consistency, we
don't want BLKFLSBUF to throw out the data. Maybe hardly anything
uses BLKFLSBUF now, so it could be just a minor problem, but still
one to fix.

Second is actually throwing out the ramdisk data. dd from /dev/null
isn't trivial because it isn't a "command" from the kernel's POV.
rd could examine the writes to see if they are zero and page aligned,
I suppose... but if you're transitioning everyone over to a new
method anyway, might as well make it a nice one ;)


> I know rewriting the drive with all zeroes can cause a modern
> disk to redo it's low level format.  And that is something
> we can definitely implement without any backwards compatibility
> problems.
>
> Hmm. Do we have anything special for punching holes in files?
> That would be another sane route to take to remove the special
> case for clearing the memory.

truncate_range, I suppose. A file descriptor syscall based
alternative for madvise would be nice though (like fallocate).

We could always put something in /sys/block/ram*/xxx
