Return-Path: <linux-kernel-owner+w=401wt.eu-S1757597AbZJDRjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757597AbZJDRjk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 13:39:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752995AbZJDRjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 13:39:39 -0400
Received: from brick.kernel.dk ([93.163.65.50]:46396 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753257AbZJDRji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 13:39:38 -0400
Date: Sun, 4 Oct 2009 19:39:01 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Vivek Goyal <vgoyal@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com,
       riel@redhat.com
Subject: Re: Do not overload dispatch queue (Was: Re: IO scheduler based IO
	controller V10)
Message-ID: <20091004173901.GD26573@kernel.dk>
References: <1254578553.7499.5.camel@marge.simson.net> <20091003142840.GE31616@kernel.dk> <1254581496.8293.8.camel@marge.simson.net> <20091003151445.GF31616@kernel.dk> <1254585420.7539.2.camel@marge.simson.net> <20091003173532.GG31616@kernel.dk> <1254596864.7153.9.camel@marge.simson.net> <20091003192321.GA26573@kernel.dk> <1254599386.7153.46.camel@marge.simson.net> <1254653434.7237.18.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254653434.7237.18.camel@marge.simson.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 04 2009, Mike Galbraith wrote:
> On Sat, 2009-10-03 at 21:49 +0200, Mike Galbraith wrote:
> 
> > It's a huge winner for sure, and there's no way to quantify.  I'm just
> > afraid the other shoe will drop from what I see/hear.  I should have
> > kept my trap shut and waited really, but the impression was strong.
> 
> Seems there was one "other shoe" at least.  For concurrent read vs
> write, we're losing ~10% throughput that we weren't losing prior to that
> last commit.  I got it back, and the concurrent git throughput back as
> well with the tweak below, _seemingly_ without significant sacrifice.
> 
> cfq-iosched:  adjust async delay.
> 
> 8e29675: "implement slower async initiate and queue ramp up" introduced a
> throughput regression for concurrent reader vs writer.  Adjusting async delay
> to use cfq_slice_async, unless someone adjusts async to have more bandwidth
> allocation than sync, restored throughput.

After comitting it yesterday, I was thinking more about this. We cannot
do the delay thing without at least doing one dispatch, or we risk
starving async writeout completely. This is problematic, as it could
cause indefinite delays and this opens up easy DoS attacks from local
users.

So I'll commit a change that doesn't do the delay at all, basically it
just offset the current code by one slice.

-- 
Jens Axboe

