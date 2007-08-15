Return-Path: <linux-kernel-owner+w=401wt.eu-S1757687AbXHOGxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757687AbXHOGxc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 02:53:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750824AbXHOGxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 02:53:09 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35772 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731AbXHOGxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 02:53:06 -0400
Date: Wed, 15 Aug 2007 07:53:01 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Randy Dunlap <rddunlap@osdl.org>, Martin Bligh <mbligh@google.com>
Subject: Re: [patch 2/2] Sort module list by pointer address to get coherent sleepable seq_file iterators
Message-ID: <20070815065301.GK21089@ftp.linux.org.uk>
References: <20070812150844.305211039@polymtl.ca> <20070812151039.996081605@polymtl.ca> <20070815033945.GA13134@mail.ustc.edu.cn> <20070815041845.GJ21089@ftp.linux.org.uk> <20070815063741.GB5175@mail.ustc.edu.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070815063741.GB5175@mail.ustc.edu.cn>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2007 at 02:37:41PM +0800, Fengguang Wu wrote:
> static void *ct_seq_next(struct seq_file *s, void *v, loff_t *pos)
> {
>         loff_t *spos = (loff_t *) v;
>         *pos = ++(*spos);
>         return spos;
> }
> 
> I mean 'pos' is sometimes increased in ct_seq_next(), and sometimes from
> seq_file.c/seq_read(), too. Thus we cannot reliably do this:
> 
>         *pos = (*spos) + some_variable_offset;

Of course we can.  These guys can be sparse - note that ->start()
takes a pointer, and for a good reason.  ->start(m, p, pos) should
get the first entry with offset >= *pos (or NULL if we are done) and
set *pos accordingly.

That m->index++ is "we are done with the partial, step just past it, so
that ->start() will pick the first real entry after it the next time it's
called".

For dense case we don't need to update *pos in ->start() - either
we already have one with offset == *pos (and no update is needed),
or we are finished and should return NULL.

However, we have every right to live with sparse offsets; prototype of
->start() had been done the way it's done exactly to allow that kind
of use.
