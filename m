Return-Path: <linux-kernel-owner+w=401wt.eu-S933204AbXA2GIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933204AbXA2GIs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 01:08:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933197AbXA2GIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 01:08:48 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:53856 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933204AbXA2GIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 01:08:47 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: mm snapshot broken-out-2007-01-26-00-36.tar.gz uploaded
References: <200701260837.l0Q8blBr011622@shell0.pdx.osdl.net>
	<6bffcb0e0701270837i1ec40560l6e61e8876177e9da@mail.gmail.com>
	<45BBC444.8090109@imap.cc> <20070127134116.06bdadd8.akpm@osdl.org>
	<200701280241.l0S2f2ga015847@turing-police.cc.vt.edu>
	<200701290249.l0T2nZt8003676@turing-police.cc.vt.edu>
Date: Sun, 28 Jan 2007 23:08:17 -0700
In-Reply-To: <200701290249.l0T2nZt8003676@turing-police.cc.vt.edu> (Valdis
	Kletnieks's message of "Sun, 28 Jan 2007 21:49:35 -0500")
Message-ID: <m1d54ymkku.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu writes:

> On Sat, 27 Jan 2007 13:41:16 PST, Andrew Morton said:
>> > > >> The mm snapshot broken-out-2007-01-26-00-36.tar.gz has been uploaded to
>> > > >>
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-01-26-00-36.tar.gz
>> 
>> > I have everything compiling now, mostly.  The number of fixes which were
>> > needed was just extraordinary.  I'm thinking about making changes...
>
> Aliens ate my brain, part 1:
>
> I tried building an out-of-tree ipfilters (ipt_osf) that worked fine under
> 2.6.20-rc4-mm1.  After much scratching my head and adding debugging info,
> I discovered that this code was failing:
>
>         p = create_proc_entry("sys/net/ipv4/osf", S_IFREG | 0644, NULL);
>         if (!p) {
>                 ipt_unregister_match(&osf_match);
>                 return -ENXIO;
>         }
>
> After much *more* head-scratching, and adding of printk's, I tracked it down
> into fs/proc/generic.c, in xlate_proc_name:
>
>                 len = next - cp;
>                 for (de = de->subdir; de ; de = de->next) {
>                         if (proc_match(len, cp, de))
>                                 break;
>                 }
>                 if (!de) {
>                         rtn = -ENOENT;
>                         goto out;
>
> It appears that syssctl-reimplement-the-sysctl-proc-support.patch doesn't
> bother setting the de->subdir, so xlate_proc_name isn't able to find sys/net.

Does it find sys?  If so perhaps I should do something even more significant.
I guess if I get many complaints about this I will figure out how to print
out an appropriate error message.

> What's the intended semantics of create_proc_entry and xlate_proc_name in
> this new regime of no subdir pointers? Or am I just (yet again) one of the
> first to trip over a bug?

It is supposed to fail in this instance.  If you want something under /proc/sys
you are supposed to use register_sysctl like everyone else.  If it's not a
sysctl it should not show up under /proc/sys.

I think I fixed the one in tree instance of this behavior.

I'm glad to see my cleanup uncovering more bugs, I'm sorry you were the one
who had to find it.  I will you well fixing your out of tree ipfilter module.

Eric
