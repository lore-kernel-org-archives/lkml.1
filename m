Return-Path: <linux-kernel-owner+w=401wt.eu-S965026AbZLQSbK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965026AbZLQSbK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 13:31:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935554AbZLQSbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 13:31:05 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:35907 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935535AbZLQSbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 13:31:01 -0500
To: Andi Kleen <andi@firstfloor.org>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
References: <20091216112844.GA31705@basil.fritz.box>
	<m16385abat.fsf@fess.ebiederm.org>
	<20091217164614.GI9804@basil.fritz.box>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 17 Dec 2009 10:30:53 -0800
In-Reply-To: <20091217164614.GI9804@basil.fritz.box> (Andi Kleen's message of "Thu\, 17 Dec 2009 17\:46\:14 +0100")
Message-ID: <m1iqc5zc4i.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH] SYSCTL: Fix sysctl breakage on systems with older glibc
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

> On Thu, Dec 17, 2009 at 07:07:54AM -0800, Eric W. Biederman wrote:
>> reaction would be.  If it makes logging in and manually using the
>> machine unbearable on systems with versions of glibc from days of
>> yore, the level of logging is too high.
>
> The reason I was slightly annoyed is because I flagged this 
> during code review and it wasn't addressed before merging.

No, you did not flag that in the review.

You said the performance would get worse with my implementation, which
is something else entirely.  I did not change anything when I
discovered that versions of glibc old enough to still have that code
were rare enough I could not find one installed anywhere.

>> > I see this on a SUSE 10.0 system with glibc 2.3.5.
>> > Don't warn for this common case.
>> 
>> Perhaps it is just my sample of the world but glibc < 2.5 isn't
>> common, especially on machines that I am putting new kernels on.
>> Equally machines with 3+ year old installs are rare.
>
> Linux simply cannot abandon older user land. We still (near) 
> fully support a.out executables, even on 64bit.

You think what I have done is abandonment of userland?

My position is and has been since I added the entry to
Docuementation/feature-removal.txt that actual real applications that
care about binary sysctls are so rare as to be practically
non-existent, and that the maintenance practices of the binary sysctl
interface show that we abandoned those applications long ago.

One of the signs of this abandonment of the binary sysctl interface is
that no one has ever done a proper 32/64 interface for it, and we do
have 4 sysctls where this actually matters.

I rewrote all of the binary sysctls in terms of their ascii
counterparts so that there would be a reasonable chance that they
would continue to work for as long as we need them.

So I think I have gone above and beyond in my effort to keep from
abandoning the one program out there that actually cares.

As for glibc.  The usage in glibc before glibc 2.5 does not count as a
user space application that cares.  You can return any string or
-ENOSYS and glibc works fine.  In addition to the fact that glibc will
read from proc if sysctl(2) fails it.

>> > Signed-off-by: Andi Kleen <ak@linux.intel.com>
>> >
>> > diff -u linux-2.6.32-git12/kernel/sysctl_binary.c-o linux-2.6.32-git12/kernel/sysctl_binary.c
>> > --- linux-2.6.32-git12/kernel/sysctl_binary.c-o	2009-12-16 12:15:52.000000000 +0100
>> > +++ linux-2.6.32-git12/kernel/sysctl_binary.c	2009-12-16 12:14:58.000000000 +0100
>> > @@ -1399,6 +1399,13 @@
>> >  {
>> >  	int i;
>> >  
>> > +	/* 
>> > +	 * CTL_KERN/KERN_VERSION is used by older glibc and cannot 
>> > +	 * ever go away.
>> > +	 */
>> The comment is wrong.  Older versions of glibc are perfectly happy
>> getting -ENOSYS form sys_sysctl.
>
> and it fills and fills and fills the kernel log. In practice
> that's not usable.

Which is why I think a printk_once is the right solution.

>> > +	if (name[0] == CTL_KERN && name[1] == KERN_VERSION)
>> > +		return;
>> 
>> If you make it printk_once for this case I think that strikes the right
>> balance.  You won't be spammed to death by messages telling you about
>> a silly old glibc, but you will be told.
>
> It's not a "silly old glibc", it's a "perfectly functional old glibc"

It is a perfectly functional silly old glibc.  It does silly things so
I will call it silly.  I don't intend to deliberately break it but I
don't intend to encourage it's silly behavior or it's use either.

The real issue is I don't know that only glibc ever calls CTL_KERN
KERN_VERSION.  We have not been warning about it for years.  So if
there is some userspace application out there besides glibc I want to
warn them.

I want to warn because for all practical purposes we abandoned
sysctl(2) a long time ago.  For now I have tested and verified my
wrapper works.  I expect my wrapper to work for the foreseeable
future.  However since nothing uses sysctl(2) that cares ultimately
the code will bit rot and fail.  I would like whatever random
userspace applications are out there to have a chance to migrate
to something we actually maintain before that happens.

To give that warning teeth that people will believe I have to continue
to say I am going to remove sysctl.  I do honestly intend in another
year when the deadline rolls around to turn sysctl(2) off by default.
I would be truly surprised if anyone noticed.

Eric
