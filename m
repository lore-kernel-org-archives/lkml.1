Return-Path: <linux-kernel-owner+w=401wt.eu-S1754177AbXFDLWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177AbXFDLWX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 07:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753302AbXFDLWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 07:22:16 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:52249 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753568AbXFDLWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 07:22:15 -0400
Message-ID: <380956130.22584@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Mon, 4 Jun 2007 19:22:14 +0800
From: Fengguang Wu <fengguang.wu@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Eric Dumazet <dada1@cosmosbay.com>,
       linux-kernel@vger.kernel.org, cotte@de.ibm.com, hugh@veritas.com,
       neilb@suse.de, zanussi@us.ibm.com, hch@infradead.org
Subject: Re: [PATCH] sendfile removal
Message-ID: <20070604112214.GA7457@mail.ustc.edu.cn>
Mail-Followup-To: Jens Axboe <jens.axboe@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Eric Dumazet <dada1@cosmosbay.com>, linux-kernel@vger.kernel.org,
	cotte@de.ibm.com, hugh@veritas.com, neilb@suse.de,
	zanussi@us.ibm.com, hch@infradead.org
References: <465FB3AD.5030807@zytor.com> <465FC92C.50608@cosmosbay.com> <466040C1.6030004@zytor.com> <alpine.LFD.0.98.0706010904110.3957@woody.linux-foundation.org> <20070602150104.GH32105@kernel.dk> <alpine.LFD.0.98.0706020836360.23741@woody.linux-foundation.org> <20070603130507.GA11170@mail.ustc.edu.cn> <20070603142931.GA5916@mail.ustc.edu.cn> <20070604004647.GA8076@mail.ustc.edu.cn> <20070604080535.GP32105@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070604080535.GP32105@kernel.dk>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2007 at 10:05:35AM +0200, Jens Axboe wrote:
> On Mon, Jun 04 2007, Fengguang Wu wrote:
> > Hi Jens,
> > 
> > This is another try, still not in a comfortable state though.
> > //Busy waiting is possible for interleaved reads.
> 
> A few random comments...
> 
> Adding an internal flag is fine, but please put it at the upper end of
> the spectrum. So, use (1 << 31) for that flag.

OK.

> And please work on the #splice branch of the block repo, not -mm. There
> are quite a few things pending for inclusion in there, and I'm sure your
> patch as-is wont apply.

I'm afraid this patch cannot be moved over to your branch trivially.

The core of the algorithm reuses f_ra.prev_index to record the state.
It is OK for the on-demand readahead in the -mm tree. But the current
readahead code in 2.6.22-rc3 is sensible to the change. And it also
does not reliably tell if readahead I/O has been submitted.

We can either try other ways of doing non-blocking I/O, or just wait
until the merge of on-demand readahead?

The current patch should work perfect with single splice reader. In
the case of multiple readers on the same fd, we might simply err on
the side of I/O waiting, since busy EAGAIN looping is not acceptable.

Fengguang Wu

