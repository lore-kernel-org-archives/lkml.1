Return-Path: <linux-kernel-owner+w=401wt.eu-S1759096AbYEIOTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759096AbYEIOTT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 10:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753383AbYEIOTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 10:19:08 -0400
Received: from mail.ift.unesp.br ([200.145.46.3]:54223 "EHLO mail.ift.unesp.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753010AbYEIOTG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 10:19:06 -0400
Date: Fri, 9 May 2008 11:18:48 -0300
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Glauber Costa <gcosta@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: Possible regression?  2.6.26-rc1: T61s failure after
	suspend/resume
Message-ID: <20080509141848.GA23727@beyonder.ift.unesp.br>
Mail-Followup-To: Hugh Dickins <hugh@veritas.com>,
	Theodore Ts'o <tytso@mit.edu>, Glauber Costa <gcosta@redhat.com>,
	Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
References: <E1JuCBA-0002NZ-4E@closure.thunk.org> <Pine.LNX.4.64.0805082148060.3994@blonde.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805082148060.3994@blonde.site>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu  8.May'08 at 22:48:57 +0100, Hugh Dickins wrote:
> [...] 
> To reproduce the problem, I start off by building a kernel with
> make -j3 (from habit, perhaps with priming the pagecache in mind),
> then interrupt that around the time it gets to filemap.o, bootmem.o.
> I pm-suspend, close the lid, wait a few seconds, open the lid;
> make mrproper and start a make -j3 build again.  (Though the very
> first time I noticed the problem, it was a segfault in a git pull
> after resume.)
> 
> How quickly it goes bad varies a lot: often hangs right at the
> start while sedding stuff before getting down to the build itself.
> Often gets well into the build before gcc reports Real-time signal
> (most commonly 14 but others seen) killed cc1.  But my favourite,
> the most distinctive failure, is segfault (usually in sh or make)
> at 20295564 ip .....2f2 error 6 in ld-2.6.1.so (openSUSE 10.3).
> 
> Always 20295564; and objdumping ld-2.6.1.so shows 0x14 of that is
> just the offset from %edi, so the crucial address is 0x20295550.
> Which is "PU) ", though I've not found that string anywhere in
> the running vmlinux (but of course it does appear in kernel source).

I have an issue similar to yours, Hugh.

I see a lot of segfaults when compiling the kernel with make -j3
after coming back from a "echo standby > /sys/power/state" in
my desktop.

For example,

sh[10355]: segfault at 80fd0a4 ip 0807a9a8 sp bfe56800 error 5 in bash[8048000+b4000]
make[12628]: segfault at 80593d0 ip 080593d0 sp bfd8087c error 5 in make[8048000+26000]
wmnet[3570]: segfault at 804c000 ip 0804c000 sp bffa5dd0 error 5 in wmnet[8048000+6000]
sh[13992]: segfault at 80b3030 ip 080b3030 sp bf8b050c error 5 in bash[8048000+b4000]
make[16300]: segfault at 804d230 ip 0804d230 sp bfcbf78c error 5 in make[8048000+26000]
sh[22895]: segfault at 80b75f0 ip 080b75f0 sp bfb3985c error 5 in bash[8048000+b4000]
sh[23507]: segfault at 80fd0a4 ip 0807a9a8 sp bffa27c0 error 5 in bash[8048000+b4000]
sh[23656]: segfault at 80fd0a4 ip 0807a9a8 sp bfb3eb70 error 5 in bash[8048000+b4000]
make[25753]: segfault at 805f4d0 ip 0805f4d0 sp bf9716cc error 5 in make[8048000+26000]
make[4857]: segfault at 804953c ip 0804953c sp bfe8fd6c error 5 in make[8048000+26000]
sh[15677]: segfault at 805bf18 ip 0805bf18 sp bf96b62c error 5 in bash[8048000+b4000]
make[15475]: segfault at 80496ac ip 080496ac sp bf92638c error 5 in make[8048000+26000]
gcc[19534]: segfault at 805ec3b ip 0805ec3b sp bfe99060 error 5 in gcc-4.2.3[8048000+2f000]
as[23425]: segfault at 8057920 ip 08057920 sp bfa91260 error 5 in as[8048000+46000]

I've just tried Ingo's suggestion of "nopat" but it did not solve my
problem. I think I will try to bisect it this weekend if I manage
to get some time.

Just wanted to say I have this problem for now. More info about my
desktop is here: 
http://www.ift.unesp.br/users/crmafra/cfs-debug-info-2008.05.09-10.58.50
