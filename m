Return-Path: <linux-kernel-owner+w=401wt.eu-S932375AbYEGTX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932375AbYEGTX0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 15:23:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765825AbYEGTWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 15:22:49 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:20591 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933630AbYEGTWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 15:22:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=kypRhokoiVy32vEw1B80qmqFVGmiIAYCya5qSTnPraD1FQceFCvG17sMjaAgrGP/ISSXqEOxLM7k0D+RWs+gRhy/f++kHa1Uo/iqg24QUuWiR5VuHWq20TUUYJH+l63Nce2wJMZtVPYJIgJmlJthcMfwYqlEM07C/0Jwr1AaFd4=
Date: Thu, 8 May 2008 00:17:57 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>,
       linux-kernel@vger.kernel.org, ltp-list@lists.sourceforge.net,
       ltp-coverage@lists.sourceforge.net, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC PATCH 4/6] seq_file: add function to write binary data
Message-ID: <20080507201757.GC5131@martell.zuzino.mipt.ru>
References: <481F26B5.7010708@de.ibm.com> <20080505213644.b153ee68.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080505213644.b153ee68.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2008 at 09:36:44PM -0700, Andrew Morton wrote:
> On Mon, 05 May 2008 17:24:37 +0200 Peter Oberparleiter <peter.oberparleiter@de.ibm.com> wrote:
> > --- linux-2.6.26-rc1.orig/fs/seq_file.c
> > +++ linux-2.6.26-rc1/fs/seq_file.c

> > +int seq_write(struct seq_file *m, const void *s, size_t len)

> > +{
> > +	if (m->count + len < m->size) {
> 
> Are you sure that shouldn't be >=?

No!

->count is how much bytes are already in buffer.
len is len.
->size is end of page(s).

> 
> > +		memcpy(m->buf + m->count, s, len);
> > +		m->count += len;
> > +		return 0;
> > +	}
> > +	m->count = m->size;
> > +	return -1;
> > +}
> > +EXPORT_SYMBOL(seq_write);

I'd call function seq_memcpy() though.

> This function has an upper limit of PAGE_SIZE bytes, I think?  The covering
> documentation should explain such things.

Again, no.

At first buffer is PAGE_SIZE. If output is bigger, ->count is dubbed to
->size, so when ->show() returns, size of buffer is doubled until it
fits in. See "while(1)" loop in seq_read().

