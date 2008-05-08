Return-Path: <linux-kernel-owner+w=401wt.eu-S1757942AbYEHEim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757942AbYEHEim (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 00:38:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752769AbYEHEic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 00:38:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:46510 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136AbYEHEia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 00:38:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,452,1204531200"; 
   d="scan'208";a="279090869"
Subject: Re: AIM7 40% regression with 2.6.26-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Ingo Molnar <mingo@elte.hu>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <alpine.LFD.1.10.0805072030480.3024@woody.linux-foundation.org>
References: <1210052904.3453.30.camel@ymzhang>
	 <20080506114449.GC32591@elte.hu> <20080506120934.GH19219@parisc-linux.org>
	 <20080506162332.GI19219@parisc-linux.org>
	 <1210217099.3453.92.camel@ymzhang>
	 <alpine.LFD.1.10.0805072030480.3024@woody.linux-foundation.org>
Content-Type: text/plain
Date: Thu, 08 May 2008 12:37:16 +0800
Message-Id: <1210221436.3453.98.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-05-07 at 20:34 -0700, Linus Torvalds wrote:
> 
> On Thu, 8 May 2008, Zhang, Yanmin wrote:
> > 
> > On Tue, 2008-05-06 at 10:23 -0600, Matthew Wilcox wrote:
> > > On Tue, May 06, 2008 at 06:09:34AM -0600, Matthew Wilcox wrote:
> > > > So the only likely things I can see are:
> > > > 
> > > >  - file locks
> > > >  - fasync
> > > 
> > > I've wanted to fix file locks for a while.  Here's a first attempt.
> > > It was done quickly, so I concede that it may well have bugs in it.
> > > I found (and fixed) one with LTP.
> > > 
> > > It takes *no account* of nfsd, nor remote filesystems.  We need to have
> > > a serious discussion about their requirements.
> >
> > I tested it on 8-core stoakley. aim7 result becomes 23% worse than the one of
> > pure 2.6.26-rc1.
> 
> Ouch. That's really odd. The BKL->spinlock conversion looks really 
> obvious, so it shouldn't be that noticeably slower.
> 
> The *one* difference is that the BKL has the whole "you can take it 
> recursively and you can sleep without dropping it because the scheduler 
> will drop it for you" thing. The spinlock conversion changed all of that 
> into explicit "drop and retake" locks, and maybe that causes some issues. 
> 
> But 23% worse? That sounds really odd/extreme.
> 
> Can you do a oprofile run or something?
I collected oprofile data. It looks not useful, as cpu idle is more than 50%.

samples  %        app name                 symbol name
270157    9.4450  multitask                add_long
266419    9.3143  multitask                add_int
238934    8.3534  multitask                add_double
187184    6.5442  multitask                mul_double
159448    5.5745  multitask                add_float
156312    5.4649  multitask                sieve
148081    5.1771  multitask                mul_float
127192    4.4468  multitask                add_short
80480     2.8137  multitask                string_rtns_1
57520     2.0110  vmlinux                  clear_page_c
53935     1.8856  multitask                div_long
48753     1.7045  libc-2.6.90.so           strncat
40825     1.4273  multitask                array_rtns
32807     1.1470  vmlinux                  __copy_user_nocache
31995     1.1186  multitask                div_int
31143     1.0888  multitask                div_float
28821     1.0076  multitask                div_double
26400     0.9230  vmlinux                  find_lock_page
26159     0.9146  vmlinux                  unmap_vmas
25249     0.8827  multitask                div_short
21509     0.7520  vmlinux                  native_read_tsc
18865     0.6595  vmlinux                  copy_user_generic_string
17993     0.6291  vmlinux                  copy_page_c
16367     0.5722  vmlinux                  system_call
14616     0.5110  libc-2.6.90.so           msort_with_tmp
13630     0.4765  vmlinux                  native_sched_clock
12952     0.4528  vmlinux                  copy_page_range
12817     0.4481  libc-2.6.90.so           strcat
12708     0.4443  vmlinux                  calc_delta_mine
12611     0.4409  libc-2.6.90.so           memset
11631     0.4066  bash                     (no symbols)
9991      0.3493  vmlinux                  update_curr
9328      0.3261  vmlinux                  unlock_page


