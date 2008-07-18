Return-Path: <linux-kernel-owner+w=401wt.eu-S1761125AbYGRR3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761125AbYGRR3c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 13:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760703AbYGRR3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 13:29:21 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:55348 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757612AbYGRR3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 13:29:19 -0400
Subject: Re: latest -git: BUG at fs/jfs/namei.c:512 assert(ip->i_nlink)
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: jfs-discussion@lists.sourceforge.net,
       Johannes Weiner <hannes@saeurebad.de>, linux-kernel@vger.kernel.org
In-Reply-To: <19f34abd0807180129k5d7e64a0nd86bbd6333df72d2@mail.gmail.com>
References: <19f34abd0807171135m4a3b39e6v4065ed676720ae46@mail.gmail.com>
	 <1216336164.32175.3.camel@norville.austin.ibm.com>
	 <19f34abd0807180110k5a19e525y463b59208f0587b2@mail.gmail.com>
	 <19f34abd0807180129k5d7e64a0nd86bbd6333df72d2@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 18 Jul 2008 12:29:17 -0500
Message-Id: <1216402157.11215.21.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-07-18 at 10:29 +0200, Vegard Nossum wrote:
> On Fri, Jul 18, 2008 at 10:10 AM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> > On Fri, Jul 18, 2008 at 1:09 AM, Dave Kleikamp
> > <shaggy@linux.vnet.ibm.com> wrote:
> >> On Thu, 2008-07-17 at 20:35 +0200, Vegard Nossum wrote:
> >>> Hi,
> >>>
> >>> I got this on latest -git with an intentionally corrupted filesystem image:
> >>>
> >>> BUG at fs/jfs/namei.c:512 assert(ip->i_nlink)
> >>
> >> This assert shouldn't be here.  It would be better to handle this with
> >> jfs_error(), which will mark the superblock dirty, and take appropriate
> >> action.
> >>
> >>> Full log at http://folk.uio.no/vegardno/linux/log-1216318656.txt, but
> >>> I think the preceding messages are just left-overs from previous
> >>> mount/remount attempts. I can test patches.
> >>
> >> How about this one?  So far, compile tested only.
> >>
> >> JFS: The kernel shouldn't trap when deleting a file with nlink == 0.
> >>
> >> Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
> >
> > Thanks!
> >
> > But whether it truly helped or not, I don't know. I got something different now:
> >
> > jfs_unlink: dtDelete returned -116
> > jfs_unlink: dtDelete returned -116
> > ------------[ cut here ]------------
> > kernel BUG at fs/inode.c:262!
> 
> Running the test for some more on a freshly booted system also gives
> me this after a while (I don't know if it's related, but it might give
> some additional clues?):
> 
> BUG: unable to handle kernel paging request at c08845af
> IP: [<c02f9122>] release_metapage+0x32/0x1c0
> *pde = 37ab2163 *pte = 00884161
> Oops: 0003 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> Pid: 387, comm: jfsCommit Not tainted (2.6.26-03415-gdf3030b #45)
> EIP: 0060:[<c02f9122>] EFLAGS: 00010202 CPU: 1
> EIP is at release_metapage+0x32/0x1c0
> EAX: 00000246 EBX: f470e5d8 ECX: f7a2afd0 EDX: 00000000
> ESI: c08845af EDI: 00000000 EBP: f735fd98 ESP: f735fd7c
>  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> Process jfsCommit (pid: 387, ti=f735e000 task=f7a2afd0 task.ti=f735e000)
> Stack: c015b6e9 00000001 00000286 00000246 00000002 00000000 00000000 f735fed0
>        c02e4202 00000020 f7a2afd0 c015addb 00000000 f470e9a4 f735fe34 00000000
>        00000000 f470e85c c015addb 00000000 00000000 f470e5d8 f470e6d8 00000002
> Call Trace:
>  [<c015b6e9>] ? __lock_acquire+0x2c9/0x1110
>  [<c02e4202>] ? xtTruncate+0xd42/0x1060

xtTruncate can call release_metapage() in several places.  If you still
have this kernel, could you please run addr2line against c02e4202?  If
you've rebuilt your kernel since then, I understand.

Thanks,
Shaggy
-- 
David Kleikamp
IBM Linux Technology Center

