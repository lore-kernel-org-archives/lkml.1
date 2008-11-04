Return-Path: <linux-kernel-owner+w=401wt.eu-S1755843AbYKDPsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843AbYKDPsm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 10:48:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753520AbYKDPsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 10:48:32 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:35676 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360AbYKDPsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 10:48:31 -0500
Date: Tue, 4 Nov 2008 15:48:23 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       "Koyama, Yoshiya" <Yoshiya.Koyama@hp.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Kay Sievers <kay.sievers@vrfy.org>, linux-fsdevel@vger.kernel.org
Subject: Re: v2.6.28-rc1: readlink /proc/*/exe returns uninitialized data
	to userspace
Message-ID: <20081104154823.GI28946@ZenIV.linux.org.uk>
References: <19f34abd0810251014s7968557br38e43aa0b9cdcf09@mail.gmail.com> <200810252241.53601.rjw@sisk.pl> <m163nggvhq.fsf@frodo.ebiederm.org> <19f34abd0810261408w61b1e2dbvb9a0e16ce5a10022@mail.gmail.com> <19f34abd0811040139t8334502i7a5d8501c5fe95ac@mail.gmail.com> <20081104100050.GA10398@x200.localdomain> <m1hc6nbw2c.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1hc6nbw2c.fsf@frodo.ebiederm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2008 at 02:54:35AM -0800, Eric W. Biederman wrote:

> does a memcpy of the new name to the target name,
> but it doesn't do anything with the source name.
> Then later we swap the name lengths.
> 
> So the length on the dentry no longer matches the data
> we put in the buffer.

Aye.  BTW, here's yesterday IRC log, after eparis had pointed to
" (deleted)" in the ends of two more reproducers (auditd spew after
crond upgrade, FWIW - same issue with d_path()):

13:48 #sec-eng: < viro> eparis: it's switch_names()
13:49 #sec-eng: < viro> if both names are internal
13:49 #sec-eng: < viro> in that case we want to copy ->d_name.len instead of swapping those
13:50 #sec-eng: < viro> IOW, I understand what's going on; it's not too nasty, fortunately, but it needs fixing
13:51 #sec-eng: < viro> pathname ends on " (deleted)" and has sane path
13:51 #sec-eng: < viro> i.e. we have dentry->d_name.{name,len} responsible for everything in between
13:52 #sec-eng: < viro> and .len is more than it ought to be
13:52 #sec-eng: < viro> OTOH, it's still within the limit on name length, so it's embedded into struct dentry
13:53 #sec-eng: < viro> i.e. we had either unlink() doing something _very_ odd or rename() buggering the name/len for (unhashed) target
13:53 #sec-eng: < viro> rename() => d_move()
13:54 #sec-eng: < viro> then testing a bit with copying /bin/sh to /tmp/<different names>, starting those and doing mv(1) of one over another had happily reproduced it
13:55 #sec-eng: < viro> so that was d_move() with short-over-short and source name longer than target one
13:56 #sec-eng: < viro> since there are only two lines handling d_name there (
13:56 #sec-eng: < viro>         /* Switch the names.. */
13:56 #sec-eng: < viro>         switch_names(dentry, target);
13:56 #sec-eng: < viro>         do_switch(dentry->d_name.len, target->d_name.len);
13:57 #sec-eng: < viro> and switch_names() is 4-way choice by "is the source name short enough"/"is the target name short enough"...
13:58 #sec-eng: < viro> IOW, after noticing that " (deleted)" it had been absolutely straightforward
13:58 #sec-eng: < viro> it's not junk in the end
13:59 #sec-eng: < viro> it's junk in the _middle_

> Certainly not a resource leak or any kind of deadlock.
> And the length is right.  But it is an information leak.
> 
> I suppose a clever person could figure out how to steal
> information that way.

Not much, but that certainly needs fixing, leak or not.
