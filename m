Return-Path: <linux-kernel-owner+w=401wt.eu-S1761633AbXHOIhO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761633AbXHOIhO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 04:37:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756205AbXHOIgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 04:36:53 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:46032 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756086AbXHOIgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 04:36:50 -0400
Message-ID: <387167005.05651@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Wed, 15 Aug 2007 16:36:45 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Randy Dunlap <rddunlap@osdl.org>, Martin Bligh <mbligh@google.com>
Subject: Re: [patch 2/2] Sort module list by pointer address to get
	coherent sleepable seq_file iterators
Message-ID: <20070815083645.GA6544@mail.ustc.edu.cn>
Mail-Followup-To: Al Viro <viro@ftp.linux.org.uk>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	Randy Dunlap <rddunlap@osdl.org>, Martin Bligh <mbligh@google.com>
References: <20070812150844.305211039@polymtl.ca> <20070812151039.996081605@polymtl.ca> <20070815033945.GA13134@mail.ustc.edu.cn> <20070815041845.GJ21089@ftp.linux.org.uk> <20070815063741.GB5175@mail.ustc.edu.cn> <20070815065301.GK21089@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070815065301.GK21089@ftp.linux.org.uk>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2007 at 07:53:01AM +0100, Al Viro wrote:
> On Wed, Aug 15, 2007 at 02:37:41PM +0800, Fengguang Wu wrote:
> > static void *ct_seq_next(struct seq_file *s, void *v, loff_t *pos)
> > {
> >         loff_t *spos = (loff_t *) v;
> >         *pos = ++(*spos);
> >         return spos;
> > }
> > 
> > I mean 'pos' is sometimes increased in ct_seq_next(), and sometimes from
> > seq_file.c/seq_read(), too. Thus we cannot reliably do this:
> > 
> >         *pos = (*spos) + some_variable_offset;
> 
> Of course we can.  These guys can be sparse - note that ->start()
> takes a pointer, and for a good reason.  ->start(m, p, pos) should
> get the first entry with offset >= *pos (or NULL if we are done) and
> set *pos accordingly.
>
> That m->index++ is "we are done with the partial, step just past it, so
> that ->start() will pick the first real entry after it the next time it's
> called".
> 
> For dense case we don't need to update *pos in ->start() - either
> we already have one with offset == *pos (and no update is needed),
> or we are finished and should return NULL.
> 
> However, we have every right to live with sparse offsets; prototype of
> ->start() had been done the way it's done exactly to allow that kind
> of use.

So sparse offsets are supported, with some special cares on ->start.

My case is to scan the address space in ranges. The "object" is the
start offset of a range:

__________________#######______________________#############__________
                  ^start                       ^start

Now the solution can be:
        - ->show shows the current range
        - ->next seeks to next range
        - ->start must *also* do the seek

The last requirement is made clear by you, a fact I refused to accept :)
My old concept was that a ->next should be called to move pages
forward after a new start.

