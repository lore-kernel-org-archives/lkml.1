Return-Path: <linux-kernel-owner+w=401wt.eu-S1753290AbXCMQET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290AbXCMQET (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 12:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753296AbXCMQET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 12:04:19 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:35131 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290AbXCMQES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 12:04:18 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Herbert Poetzl <herbert@13thfloor.at>, Kirill Korotaev <dev@sw.ru>,
       containers@lists.osdl.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Paul Menage <menage@google.com>, Pavel Emelianov <xemul@sw.ru>,
       Dave Hansen <hansendc@us.ibm.com>
Subject: Re: [RFC][PATCH 4/7] RSS accounting hooks over the code
References: <45ED7DEC.7010403@sw.ru> <45ED81F2.80402@sw.ru>
	<m14porwq1c.fsf@ebiederm.dsl.xmission.com> <45F57E7D.6080604@sw.ru>
	<1173718208.11945.54.camel@localhost.localdomain>
	<20070312235452.GB11578@MAIL.13thfloor.at>
	<m1veh5sbwy.fsf@ebiederm.dsl.xmission.com>
	<45F67C2D.7020303@yahoo.com.au>
Date: Tue, 13 Mar 2007 10:01:54 -0600
In-Reply-To: <45F67C2D.7020303@yahoo.com.au> (Nick Piggin's message of "Tue,
	13 Mar 2007 21:25:49 +1100")
Message-ID: <m1odmxrv2l.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <nickpiggin@yahoo.com.au> writes:

> Eric W. Biederman wrote:
>>
>> First touch page ownership does not guarantee give me anything useful
>> for knowing if I can run my application or not.  Because of page
>> sharing my application might run inside the rss limit only because
>> I got lucky and happened to share a lot of pages with another running
>> application.  If the next I run and it isn't running my application
>> will fail.  That is ridiculous.
>
> Let's be practical here, what you're asking is basically impossible.
>
> Unless by deterministic you mean that it never enters the a non
> trivial syscall, in which case, you just want to know about maximum
> RSS of the process, which we already account).

Not per process I want this on a group of processes, and yes that
is all I want just.  I just want accounting of the maximum RSS of
a group of processes and then the mechanism to limit that maximum rss.

>> I don't want sharing between vservers/VE/containers to affect how many
>> pages I can have mapped into my processes at once.
>
> You seem to want total isolation. You could use virtualization?

No.  I don't want the meaning of my rss limit to be affected by what
other processes are doing.  We have constraints of how many resources
the box actually has.  But I don't want accounting so sloppy that
processes outside my group of processes can artificially
lower my rss value, which magically raises my rss limit.

>> Now sharing is sufficiently rare that I'm pretty certain that problems
>> come up rarely.  So maybe these problems have not shown up in testing
>> yet.  But until I see the proof that actually doing the accounting for
>> sharing properly has intolerable overhead.  I want proper accounting
>> not this hand waving that is only accurate on the third Tuesday of the
>> month.
>
> It is basically handwaving anyway. The only approach I've seen with
> a sane (not perfect, but good) way of accounting memory use is this
> one. If you care to define "proper", then we could discuss that.

I will agree that this patchset is probably in the right general ballpark.
But the fact that pages are assigned exactly one owner is pure non-sense.
We can do better.  That is all I am asking for someone to at least attempt
to actually account for the rss of a group of processes and get the numbers
right when we have shared pages, between different groups of
processes.  We have the data structures to support this with rmap.

Let me describe the situation where I think the accounting in the
patchset goes totally wonky. 


Gcc as I recall maps the pages it is compiling with mmap.
If in a single kernel tree I do:
make -jN O=../compile1 &
make -jN O=../compile2 &

But set it up so that the two compiles are in different rss groups.
If I run the concurrently they will use the same files at the same
time and most likely because of the first touch rss limit rule even
if I have a draconian rss limit the compiles will both be able to
complete and finish.   However if I run either of them alone if I
use the most draconian rss limit I can that allows both compiles to
finish I won't be able to compile a single kernel tree.

The reason for the failure with a single tree (in my thought
experiment) is that the rss limit was set below the what is actually
needed for the code to work.  When we were compiling two kernels and
they were mapping the same pages at the same time we could put the rss
limit below the minimum rss needed for the compile to execute and
still have it complete because of with first touch only one group
accounted for the pages and the other just leached of the first, as
long as both compiles grabbed some of the pages they could complete.

No I know in practice most draconian limits will simply result in the
page staying in the page cache but not mapped into processes in the
group with the draconian limit, or they will result in pages of the
group with the draconian limit being pushed out into the swap cache.
So the chances of actual application failure even with a draconian
rss limit are quite unlikely.  (I actually really appreciate this
fact).

However the messed up accounting that doesn't handle sharing between
groups of processes properly really bugs me.  Especially when we have
the infrastructure to do it right.

Does that make more sense?

Eric
