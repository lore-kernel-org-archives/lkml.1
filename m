Return-Path: <linux-kernel-owner+w=401wt.eu-S1755444AbXEECyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444AbXEECyf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 22:54:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755446AbXEECyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 22:54:35 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:38315 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755444AbXEECye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 22:54:34 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Chris Wright <chrisw@sous-sol.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert "[PATCH] paravirt: Add startup infrastructure for paravirtualization"
References: <m1mz0ku7je.fsf@ebiederm.dsl.xmission.com>
	<1178280770.23670.61.camel@localhost.localdomain>
	<m1y7k4smmo.fsf@ebiederm.dsl.xmission.com>
	<1178289450.23670.100.camel@localhost.localdomain>
	<m1lkg4sk3f.fsf@ebiederm.dsl.xmission.com>
	<1178328168.12284.11.camel@localhost.localdomain>
Date: Fri, 04 May 2007 20:53:12 -0600
In-Reply-To: <1178328168.12284.11.camel@localhost.localdomain> (Rusty
	Russell's message of "Sat, 05 May 2007 11:22:48 +1000")
Message-ID: <m18xc4nfqf.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell <rusty@rustcorp.com.au> writes:

> Hi Eric,
>
> 	Well, I certainly don't recall that (that's not to say that someone
> didn't say it).  Trying to meet the requirements of Xen, VMI and other
> future hypervisors lead to an awkward result; this is the main reason I
> started on lguest, so we'd have a simple example in front of us to say
> "do it this way".
>
> 	(It's not certain that anyone else will ever use this code, but we
> should *try* IMHO).

Ok.  So the purpose of lguest is to be an experimental platform and
as much as possible be a good example.

>> Before lguest.  Thank you very much.  This code should never ever
>> have been in a stable kernel.  It is a very ill conceived interface.
>
> I disagree.  It was *not* obvious how paravirt kernels should boot.
> Lguest, for example, copied Xen's "set up kernel pagetables already"
> design decision, which now seems wrong.  But it was the example we had.

Makes some sense.  There was a bit of experience with booting kernels
without doing 16bit BIOS calls in nearly this way outside the paravirt
world though. 

>> And frankly I don't think lguest should be merged until we are as
>> close to certain as human beings can get that have the ABI reviewed
>> and sorted out.  ABIs unfortunately are very very hard to change.
>
> I think you misunderstand lguest.  I agree with this sentiment
> completely: this is *why* lguest doesn't have an ABI.  It's all in-tree,
> so it can simply be changed.  There's no guarantee that running
> different kernels as guest and host will work.

Reasonable.  Just so long as it is hidden under CONFIG_EXPERIMENTAL
And that people will know that mixing and matching is a problem.

Someday I might have to tell the story of the challenge of getting
the kexec on panic code path to all mixing and matching of kernels.

> Maybe later the ABI will nail down, but the last year of hacking on
> various hypervisors has shown it's folly to try to get it right now.  We
> need to play a lot first.
>
> Hope that clarifies!

For lguest at least.

The delicate part right now is that lguest is attempting to use the
standard kernel entry point which does have a fixed ABI.

If lguest uses that entry point in a hard to maintain way it provides
a bad example, and it potentially leads to other problems.  So I
really don't want to see the bad example happen, especially if the
code in the bad example is as general as it is today.

That said we have two practical short term solutions.
-  A separate entry point made advertised with an ELF note like
   Xen is currently doing.

-  We reserve a type field in the first 2K of the boot param area
   and if that type is lguest we immediately branch to your code.

Reserving the type field is a subset of what we are looking at for
the next rev of the boot protocol that will handle this clearly.

We have enough in flight work for cleaning up the booting of arch/i386
that I don't believe we can have a complete solution before the merge
window closes.  At best we can get a minor rev and reserve the fields
it looks like we will need in head.S

Frankly I think the least risk of problems comes from just doing a
separate entry point for lguest for now.  It means we don't even have
to touch the common code path and later dropping will be trivially 
lguest specific, and certain to not break anything else.

Eric
