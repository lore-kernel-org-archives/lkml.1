Return-Path: <linux-kernel-owner+w=401wt.eu-S1756012AbXKFXbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012AbXKFXbx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 18:31:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754865AbXKFXbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 18:31:43 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:57743 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754767AbXKFXbm (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 18:31:42 -0500
Date: Wed, 7 Nov 2007 10:31:14 +1100
From: David Chinner <dgc@sgi.com>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Fengguang Wu <wfg@mail.ustc.edu.cn>, Peter Zijlstra <peterz@infradead.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, David Chinner <dgc@sgi.com>,
       linux-fsdevel@vger.kernel.org
Subject: Re: writeout stalls in current -git
Message-ID: <20071106233114.GB995458@sgi.com>
References: <393060478.03650@ustc.edu.cn> <64bb37e0710310822r5ca6b793p8fd97db2f72a8655@mail.gmail.com> <393903856.06449@ustc.edu.cn> <64bb37e0711011120i63cdfe3ci18995d57b6649a8@mail.gmail.com> <64bb37e0711011200n228e708eg255640388f83da22@mail.gmail.com> <E1InmAI-0003ME-2i@localhost> <1193998532.27652.343.camel@twins> <64bb37e0711021222q7d12c825mc62d433c4fe19e8@mail.gmail.com> <394340668.31055@ustc.edu.cn> <64bb37e0711061353g4a8b881cgd78fef3a11378b9c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64bb37e0711061353g4a8b881cgd78fef3a11378b9c@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2007 at 10:53:25PM +0100, Torsten Kaiser wrote:
> On 11/6/07, David Chinner <dgc@sgi.com> wrote:
> > Rather than vmstat, can you use something like iostat to show how busy your
> > disks are?  i.e. are we seeing RMW cycles in the raid5 or some such issue.
> 
> Both "vmstat 10" and "iostat -x 10" output from this test:
> procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
>  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
>  2  0      0 3700592      0  85424    0    0    31    83  108  244  2  1 95  1
> -> emerge reads something, don't knwo for sure what...
>  1  0      0 3665352      0  87940    0    0   239     2  343  585  2  1 97  0
....
> 
> The last 20% of the btrace look more or less completely like this, no
> other programs do any IO...
> 
> 253,0    3   104626   526.293450729   974  C  WS 79344288 + 8 [0]
> 253,0    3   104627   526.293455078   974  C  WS 79344296 + 8 [0]
> 253,0    1    36469   444.513863133  1068  Q  WS 154998480 + 8 [xfssyncd]
> 253,0    1    36470   444.513863135  1068  Q  WS 154998488 + 8 [xfssyncd]
                                                ^^
Apparently we are doing synchronous writes. That would explain why
it is slow. We shouldn't be doing synchronous writes here. I'll see if
I can reproduce this.

<goes off and looks>

Yes, I can reproduce the sync writes coming out of xfssyncd. I'll
look into this further and send a patch when I have something concrete.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
