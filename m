Return-Path: <linux-kernel-owner+w=401wt.eu-S1765686AbYCTAyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765686AbYCTAyh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 20:54:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753480AbYCTAyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 20:54:14 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:21600 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553AbYCTAyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 20:54:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rqcO9aIImxGgKS9kRyfpGxZ5DqLj98x1PY33HJuDt5iVO/KiNROsvIzFwrqrFx/KeCtrlc/emt06+vPERz5BqsS+swL5lfqr1eJOtotlVDhjf7h6UAwwm9PrbzALupb2Wc6uGZbJIuvFwV3sxxUb/WHLSLIc2Dn754dt/IU6Osw=
Message-ID: <170fa0d20803191754j2e4e5fcdg121c776d18c53dcb@mail.gmail.com>
Date: Wed, 19 Mar 2008 20:54:11 -0400
From: "Mike Snitzer" <snitzer@gmail.com>
To: "Daniel Phillips" <phillips@phunq.net>
Subject: Re: [ANNOUNCE] ddtree: A git kernel tree for storage servers
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <170fa0d20803191707y1591d389y898b34ba7b30e7be@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200803190102.25491.phillips@phunq.net>
	 <170fa0d20803191323o65bd9738j80511de2c9f6a03c@mail.gmail.com>
	 <200803191633.20922.phillips@phunq.net>
	 <170fa0d20803191707y1591d389y898b34ba7b30e7be@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2008 at 8:07 PM, Mike Snitzer <snitzer@gmail.com> wrote:

>  I typically use dm-linear devices built on MD (raid1 w/ one member
>  being remote via nbd).  The per-bdi dirty writeback accounting has
>  proven useful but I've recently hit a nasty livelock when the bdi
>  accounting for a device no longer enables writeback progress to be
>  made, e.g:
>
>  BdiWriteback:            0 kB
>  BdiReclaimable:     321408 kB
>  BdiDirtyThresh:     316364 kB
>  DirtyThresh:        381284 kB
>  BackgroundThresh:   190640 kB
>
>  With an all too familiar trace like the following:
>  ..
>   [<ffffffff8044cda6>] io_schedule_timeout+0x4b/0x79
>   [<ffffffff80271371>] congestion_wait+0x66/0x80
>   [<ffffffff802457bd>] autoremove_wake_function+0x0/0x2e
>   [<ffffffff8026c64d>] balance_dirty_pages_ratelimited_nr+0x21d/0x2b1
>   [<ffffffff80268191>] generic_file_buffered_write+0x5f3/0x711
>
>  I'm _hoping_ your simple/elegant patch can enable me to drop my 2.6.22
>  per-bdi backport and all will be right with the world.

Turns out my writeback woes were actually in... writeback ;)

I had backported Fengweng Wu's writeback work from 2.6.24 to 2.6.22
with the following commits/patches:

fix time ordering of the per superblock inode lists:
6610a0bc8dcc120daa1d93807d470d5cbf777c39
9852a0e76cd9c89e71f84e784212fdd7a97ae93a
f57b9b7b4f68e1723ca99381dc10c8bc07d6df14
c986d1e2a460cbce79d631c51519ae82c778c6c5
1b43ef91d40190b16ba10218e66d5c2c4ba11de3
c6945e77e477103057b4a639b4b01596f5257861
65cb9b47e0ea568a7a38cce7773052a6ea093629
670e4def6ef5f44315d62748134e535b479c784f
2c1365791048e8aff42138ed5f6040b3c7824a69

fix periodic superblock dirty inode flushing:
0e0f4fc22ece8e593167eccbb1a4154565c11faa

remove pages_skipped accounting in __block_write_full_page():
1f7decf6d9f06dac008b8d66935c0c3b18e564f9

speed up writeback of big dirty files:
http://lkml.org/lkml/2008/1/17/49

Given all but the last lkml.org patch reference went into 2.6.24 I'll
revisit the impact these changes have on my writeback progress when I
move to 2.6.24+.

Mike
