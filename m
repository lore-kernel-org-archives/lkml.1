Return-Path: <linux-kernel-owner+w=401wt.eu-S1756007AbXLSHhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007AbXLSHhb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 02:37:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752716AbXLSHhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 02:37:19 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:43522 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752669AbXLSHhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 02:37:17 -0500
Message-ID: <398049842.25517@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Wed, 19 Dec 2007 15:37:11 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 0/9] mmap read-around and readahead
References: <397806667.28507@ustc.edu.cn> <alpine.LFD.0.9999.0712161535090.21557@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.9999.0712161535090.21557@woody.linux-foundation.org>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.17 (2007-11-01)
Message-Id: <E1J4tUN-0002IB-F6@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 16, 2007 at 03:35:58PM -0800, Linus Torvalds wrote:
> 
> 
> On Sun, 16 Dec 2007, Fengguang Wu wrote:
> > 
> > Here are the mmap read-around related patches initiated by Linus.
> > They are for linux-2.6.24-rc4-mm1.  The one major new feature -
> > auto detection and early readahead for mmap sequential reads - runs
> > as expected on my desktop :-)
> 
> Just out of interest - did you check to see if it makes any difference to 
> any IO patterns (or even timings)?

Now I have some numbers on 100,000 sequential mmap reads:

                                    user       system    cpu        total
(1-1)  plain -mm, 128KB readaround: 3.224      2.554     48.40%     11.838
(1-2)  plain -mm, 256KB readaround: 3.170      2.392     46.20%     11.976
(2)  patched -mm, 128KB readahead:  3.117      2.448     47.33%     11.607

The patched (2) has smallest total time. It has no cache hit overheads
and less I/O block time(thanks to async readahead). Here the I/O size
makes no much difference, since there's only one single stream.

Note that (1-1)'s real I/O size is 64KB and (1-2)'s real I/O size is
128KB, since the half of the read-around pages will be cache hits.

Fengguang
---

PS. raw time numbers:

        1) linux-2.6.24-rc5-mm1, 128KB read_ahead_kb:

                3.27s user 2.62s system 50% cpu 11.730 total
                3.25s user 2.65s system 49% cpu 11.816 total
                3.07s user 2.62s system 47% cpu 11.911 total
                3.32s user 2.42s system 48% cpu 11.948 total
                3.21s user 2.46s system 48% cpu 11.787 total

        2) linux-2.6.24-rc5-mm1, 256KB read_ahead_kb:

                3.00s user 2.46s system 45% cpu 12.077 total
                3.41s user 2.51s system 49% cpu 12.038 total
                3.25s user 2.34s system 47% cpu 11.889 total
                3.13s user 2.33s system 45% cpu 11.922 total
                3.06s user 2.32s system 45% cpu 11.952 total

        3) linux-2.6.24-rc5-mm1 + this patchset, 128KB read_ahead_kb:

                2.79s user 2.26s system 43% cpu 11.515 total
                3.19s user 2.21s system 46% cpu 11.563 total
                3.28s user 2.51s system 49% cpu 11.596 total
                3.22s user 2.75s system 51% cpu 11.687 total
                3.08s user 2.58s system 48% cpu 11.643 total
                3.14s user 2.38s system 47% cpu 11.637 total

