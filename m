Return-Path: <linux-kernel-owner+w=401wt.eu-S1754493AbYI2Wqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493AbYI2Wqd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 18:46:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753066AbYI2Wq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 18:46:26 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:52329 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043AbYI2WqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 18:46:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=PG+vp3+FbvgR/ZPXvr/uDVR53q/qZv22701/8tu1wXMNOtAvyV9KrMIdlEfM3hEynL
         GqSbnP+lUeuaSQVNJMd9zt0GPjO99bCKk7qUxyR6rhvL8IiDhkIa3qUdQgZrl2UQNkcX
         TixyH6ooisTQiDRayxhhEsVh3udRrj2T7n5SU=
Message-ID: <47ed01bd0809291546q4d0dc85fif46667b75bfb7526@mail.gmail.com>
Date: Mon, 29 Sep 2008 18:46:23 -0400
From: "Dylan Taft" <d13f00l@gmail.com>
To: linux-kernel@vger.kernel.org, yinghai@kernel.org, hugh@mimosa.com
Subject: Re: questions about x86: mtrr cleanup for converting continuous to discrete layout
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think a workaround in the kernel is absolutely necessary.  A lot of
newer motherboards have this issue, where a whole section of memory
will be marked as write-back, and write-combining can't be
embedded/nested.
As far as I'm aware, changing MTRRs won't make a system unstable,
especially if done so early on, when the kernel is starting up.  All
it does is change the behavior on how the CPU will cache write
requests to memory.  All system memory should be marked as write-back,
how many MTRRs are used to do this...I'm not sure if it exactly
matters.  You can set MTRR_SPARE_REG_NR and control how many MTRR
slots the code will use.

Is it legal to mark a write-combining range within a write-back range?

Ideally, maybe adding a minimal amount of MTRRs might be best, as D.
Hugh Redelmeier's userspace app does, but I think a fix for this in
the _kernel_ is an absolute must for 2.6.27.  Weather a range that has
to be marked for write-combining is just "uncovered", or weather
ranges are entirely automatically generated in chunks, either should
work, but Hugh's suggestion might save MTRR entries in practice?

I'm no kernel dev, I code a bit here and there, but I spent a LOT of
time researching this when I ran into the problem myself on my new PC.
 There's a lot of posts about it too in the intel bug tracker for
people with newer boards and the g45 chipset.  Most users shouldn't
have to worry about this, and it should, "just work".

I don't think this should be pulled unless a different fix is in place
in the kernel.

Thanks!


Here's what bios does with my MTRRs, write combining can't be set up
for my video card
reg00: base=0x1b0000000 (6912MB), size= 256MB: uncachable, count=1
reg01: base=0x1c0000000 (7168MB), size=1024MB: uncachable, count=1
reg02: base=0x00000000 (   0MB), size=8192MB: write-back, count=1
reg03: base=0xd0000000 (3328MB), size= 256MB: uncachable, count=1
reg04: base=0xe0000000 (3584MB), size= 512MB: uncachable, count=1
reg05: base=0xc7e00000 (3198MB), size=   2MB: uncachable, count=1
reg06: base=0xc8000000 (3200MB), size= 128MB: uncachable, count=1

and with Yinghai Lu's patches in git tip, with working write-combining mark
reg00: base=0x00000000 (   0MB), size=2048MB: write-back, count=1
reg01: base=0x80000000 (2048MB), size=1024MB: write-back, count=1
reg02: base=0xc0000000 (3072MB), size= 128MB: write-back, count=1
reg03: base=0xc7e00000 (3198MB), size=   2MB: uncachable, count=1
reg04: base=0x100000000 (4096MB), size=2048MB: write-back, count=1
reg05: base=0x180000000 (6144MB), size= 512MB: write-back, count=1
reg06: base=0x1a0000000 (6656MB), size= 256MB: write-back, count=1
reg07: base=0xd0000000 (3328MB), size= 256MB: write-combining, count=1
