Return-Path: <linux-kernel-owner+w=401wt.eu-S933269AbXA2IZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933269AbXA2IZ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 03:25:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933270AbXA2IZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 03:25:28 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:38629 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933269AbXA2IZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 03:25:27 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: mm snapshot broken-out-2007-01-26-00-36.tar.gz uploaded
References: <200701260837.l0Q8blBr011622@shell0.pdx.osdl.net>
	<6bffcb0e0701270837i1ec40560l6e61e8876177e9da@mail.gmail.com>
	<45BBC444.8090109@imap.cc> <20070127134116.06bdadd8.akpm@osdl.org>
	<200701280241.l0S2f2ga015847@turing-police.cc.vt.edu>
	<200701290249.l0T2nZt8003676@turing-police.cc.vt.edu>
	<m1d54ymkku.fsf@ebiederm.dsl.xmission.com>
	<200701290645.l0T6jX0S030597@turing-police.cc.vt.edu>
Date: Mon, 29 Jan 2007 01:24:57 -0700
In-Reply-To: <200701290645.l0T6jX0S030597@turing-police.cc.vt.edu> (Valdis
	Kletnieks's message of "Mon, 29 Jan 2007 01:45:33 -0500")
Message-ID: <m164aqme92.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu writes:

> On Sun, 28 Jan 2007 23:08:17 MST, Eric W. Biederman said:
>> Valdis.Kletnieks@vt.edu writes:
>
>> Does it find sys?  If so perhaps I should do something even more significant.
>> I guess if I get many complaints about this I will figure out how to print
>> out an appropriate error message.
>
> It found sys, and then the second iteration in in xlate_proc_name it failed
> to find net because the de->subdir for sys/net wasn't set.

Thanks. 

>> > What's the intended semantics of create_proc_entry and xlate_proc_name in
>> > this new regime of no subdir pointers? Or am I just (yet again) one of the
>> > first to trip over a bug?
>> 
>> It is supposed to fail in this instance.  If you want something under
> /proc/sys
>> you are supposed to use register_sysctl like everyone else.  If it's not a
>> sysctl it should not show up under /proc/sys.
>
> Wasn't my code originally - I think the original author thought that since
> all the *other* config stuff for ipv4 was down under /proc/sys/net/ipv4, this
> one should be as well because that's where sysadmins would look for it, and
> wasn't thinking so much about whether it was a sysctl or not.
>
>> I'm glad to see my cleanup uncovering more bugs, I'm sorry you were the one
>> who had to find it.  I will you well fixing your out of tree ipfilter module.
>
> It's easy enough to move the entry under /proc/net or someplace instead.
>
> What's the current advice on what kernel interface to use for this scenario:
>
> In userspace, we do something like this:
>
> (while read foo; do echo $foo > /proc/my_file; done) < /etc/bunch_of_lines
>
> and we want to catch, parse, and save each line as it enters the kernel, and
> we end up with several dozen entries saved.
>
> If we do a 'cat /proc/my_file', we iterate across the list of saved lines
> and dump them all out.

Well it is a non-fixed number of entries so it does not sound appropriate for
a sysctl.  sysctl tends to work well for simple settings, not complicated things.

/proc/net would be the easy place, although I think traditionally /proc/net
is just reporting.

Given the context I will suggest setsockopt as most of iptables is configured
using that.

Generally going beyond one value per file is discouraged, in any context.

So I guess the general advice is don't have that scenario :)

In your situation I would find something in the kernel that does something
similar and see how it provides for a user interface.  If there is a way
that it is done for similar modules do that. 

If there is no precedent something under sysfs likely makes the most sense.
/proc is really supposed for things related to processes.

I usually spend my time keeping the old things going and useful in new and
interesting situations instead of figuring out the interface recommendation
of the week.

I would be really surprised if your configuration requirements were unique
and there weren't several somethings in the kernel that solved the
same problem in a different way.

Eric
