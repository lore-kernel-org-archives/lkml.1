Return-Path: <linux-kernel-owner+w=401wt.eu-S1754654AbXFLCwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654AbXFLCwQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 22:52:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751552AbXFLCwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 22:52:06 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:58600 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751533AbXFLCwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 22:52:04 -0400
Message-ID: <381616717.23813@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Tue, 12 Jun 2007 10:52:01 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, Jens Axboe <jens.axboe@oracle.com>,
       Oleg Nesterov <oleg@tv-sign.ru>, Steven Pratt <slpratt@austin.ibm.com>,
       Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH 1/9] readahead: introduce PG_readahead
Message-ID: <20070612025201.GA6447@mail.ustc.edu.cn>
Mail-Followup-To: Rusty Russell <rusty@rustcorp.com.au>,
	Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
	Andi Kleen <andi@firstfloor.org>,
	Jens Axboe <jens.axboe@oracle.com>, Oleg Nesterov <oleg@tv-sign.ru>,
	Steven Pratt <slpratt@austin.ibm.com>,
	Ram Pai <linuxram@us.ibm.com>
References: <20070516224752.500812933@mail.ustc.edu.cn> <20070516224818.246719596@mail.ustc.edu.cn> <1181610294.16428.133.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181610294.16428.133.camel@localhost.localdomain>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

On Tue, Jun 12, 2007 at 11:04:54AM +1000, Rusty Russell wrote:
> On Thu, 2007-05-17 at 06:47 +0800, Fengguang Wu wrote:
> > plain text document attachment (mm-introduce-pg_readahead.patch)
> > Introduce a new page flag: PG_readahead.
> > 
> > It acts as a look-ahead mark, which tells the page reader:
> > Hey, it's time to invoke the read-ahead logic.  For the sake of I/O pipelining,
> > don't wait until it runs out of cached pages!
> 
> Hi Fengguang!
> 
> 	I've been reading your patches, and I have some (possibly dumb!)
> questions.
> 
> For this patch: why set a bit in the page, rather than keep a value
> inside the "struct file_ra_state"?

Good question. I should have documented it in the patch ;)

The short answer:
there can be multiple read streams per fd, i.e.  interleaved reads.

file_ra_state can not easily track all of the streams. Solaris zfs
does it by managing a list in struct dnode. While PG_readahead plus
the context based readahead(http://lkml.org/lkml/2006/11/15/54) makes
another solution. The two solutions are comparable in complexity.
The context based readahead is a bit more feature rich: it is sensible
to memory pressure, and supports an unlimited number of streams. Note
that random reads can be regarded as a huge number of one-shot streams,
which can interfere with zfs's list-based readahead states badly.

Fengguang

