Return-Path: <linux-kernel-owner+w=401wt.eu-S1757604AbYA1Bqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757604AbYA1Bqt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 20:46:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752705AbYA1Bqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 20:46:42 -0500
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:31096 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752449AbYA1Bql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 20:46:41 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Message-Id;
  b=U8L1EB6dsXe5IoQDz9w/H7Ue8uDJfyOGWlhdp9TO4bEnrjF0cQx1+leciOjCNcpqo0xycP9j9wyKACMCiQc6svHxQdYw7Kn45bez42LB1MD7cQkK8GA/WoLkGXAgdoaB0Aqtv0qQH6AW3u4I0yFXMLF3FLuqNk/N25U551qtLfI=  ;
X-YMail-OSG: WCQAcScVM1lTIQ5LRIWrdHXv1BUP8dmIOoacsEZcXi_f9iSzapH1zqXSZL06jJU4HpsueV1Gbw--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Frederik Himpe <fhimpe@telenet.be>,
       Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org
Subject: Re: 2.6.24 regression: pan hanging unkilleable and un-straceable
Date: Mon, 28 Jan 2008 12:46:23 +1100
User-Agent: KMail/1.9.5
Cc: Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
References: <1200949086.6648.19.camel@Anastacia> <200801221625.58615.nickpiggin@yahoo.com.au> <1201354155.6853.4.camel@Anastacia>
In-Reply-To: <1201354155.6853.4.camel@Anastacia>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_wPTnHldzXCLYPGl"
Message-Id: <200801281246.24043.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_wPTnHldzXCLYPGl
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sunday 27 January 2008 00:29, Frederik Himpe wrote:
> On di, 2008-01-22 at 16:25 +1100, Nick Piggin wrote:
> > > > On Tuesday 22 January 2008 07:58, Frederik Himpe wrote:
> > > > > With Linux 2.6.24-rc8 I often have the problem that the pan usenet
> > > > > reader starts using 100% of CPU time after some time. When this
> > > > > happens, kill -9 does not work, and strace just hangs when trying
> > > > > to attach to the process. The same with gdb. =EF=BB=BFps shows th=
e process
> > > > > as being in the R state.
> > > > >
> > > > > I pressed Ctrl-Alt-SysRq-T, and this was shown for pan:
> > > > > Jan 21 21:45:01 Anastacia kernel: pan           R  running task
> > > > > 0
> >
> > Nasty. The attached patch is something really simple that can sometimes
> > help. sysrq+p is also an option, if you're on a UP system.
> >
> > Any luck getting traces?
>
> I just succeeded to reproduce the problem with this patch. Does this
> smell like an XFS problem?
>
> Jan 26 14:17:43 Anastacia kernel: pan           R  running task        0=
=20
> 7564      1 Jan 26 14:17:43 Anastacia kernel:  000000003f5b3248
> 0000000000001000 ffffffff880c28b0 0000000000000000 Jan 26 14:17:43
> Anastacia kernel:  ffff81003f5b3248 ffff81002d1ed900 000000002d1ed900
> 0000000000000000 Jan 26 14:17:43 Anastacia kernel:  ffff810016050dd0
> fffff000fffff000 0000000000000000 ffff81002d1eda10 Jan 26 14:17:43
> Anastacia kernel: Call Trace:
> Jan 26 14:17:43 Anastacia kernel:  [_end+127964408/2129947720]
> :xfs:xfs_get_blocks+0x0/0x10 Jan 26 14:17:43 Anastacia kernel:=20
> [unix_poll+0/176] unix_poll+0x0/0xb0 Jan 26 14:17:43 Anastacia kernel:=20
> [_end+127964408/2129947720] :xfs:xfs_get_blocks+0x0/0x10 Jan 26 14:17:43
> Anastacia kernel:  [iov_iter_copy_from_user_atomic+65/160]
> iov_iter_copy_from_user_atomic+0x41/0xa0 Jan 26 14:17:43 Anastacia kernel=
:=20
> [iov_iter_copy_from_user_atomic+46/160]
> iov_iter_copy_from_user_atomic+0x2e/0xa0 Jan 26 14:17:43 Anastacia kernel=
:=20
> [generic_file_buffered_write+383/1728]

Well after trying a lot of writev combinations, I've reproduced a hang
*hangs head*.

Does this help?

--Boundary-00=_wPTnHldzXCLYPGl
Content-Type: text/x-diff;
  charset="utf-8";
  name="mm-zerolen-iov-fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="mm-zerolen-iov-fix.patch"

Zero length iovecs can go into an infinite loop in writev, because the
iovec iterator does not always advance over them.

The sequence required to trigger this is not trivial. I think it requires
that a zero-length iovec be followed by a non-zero-length iovec which causes
a pagefault in the atomic usercopy. This causes the writev code to drop back
into single-segment copy mode, which then tries to copy the 0 bytes of the
zero-length iovec; a zero length copy looks like a failure though, so it
loops.

Put a test into iov_iter_advance to catch zero-length iovecs. We could just
put the test in the fallback path, but I feel it is more robust to skip
over zero-length iovecs throughout the code (iovec iterator may be used in
filesystems too, so it should be robust).

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
Index: linux-2.6/mm/filemap.c
===================================================================
--- linux-2.6.orig/mm/filemap.c
+++ linux-2.6/mm/filemap.c
@@ -1733,7 +1733,11 @@ static void __iov_iter_advance_iov(struc
 		const struct iovec *iov = i->iov;
 		size_t base = i->iov_offset;
 
-		while (bytes) {
+		/*
+		 * The !iov->iov_len check ensures we skip over unlikely
+		 * zero-length segments.
+		 */
+		while (bytes || !iov->iov_len) {
 			int copy = min(bytes, iov->iov_len - base);
 
 			bytes -= copy;
@@ -2251,6 +2255,7 @@ again:
 
 		cond_resched();
 
+		iov_iter_advance(i, copied);
 		if (unlikely(copied == 0)) {
 			/*
 			 * If we were unable to copy any data at all, we must
@@ -2264,7 +2269,6 @@ again:
 						iov_iter_single_seg_count(i));
 			goto again;
 		}
-		iov_iter_advance(i, copied);
 		pos += copied;
 		written += copied;
 

--Boundary-00=_wPTnHldzXCLYPGl--
