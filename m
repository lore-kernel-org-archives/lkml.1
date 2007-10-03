Return-Path: <linux-kernel-owner+w=401wt.eu-S1757205AbXJCOJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757205AbXJCOJR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 10:09:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753603AbXJCOJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 10:09:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38622 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753784AbXJCOJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 10:09:03 -0400
Date: Wed, 3 Oct 2007 16:08:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [bug] crash when reading /proc/mounts (was: Re: Linux
	2.6.23-rc9 and a heads-up for the 2.6.24 series..)
Message-ID: <20071003140842.GA8837@elte.hu>
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org> <20071003084607.GC32218@elte.hu> <20071003133422.GI8181@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071003133422.GI8181@ftp.linux.org.uk>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Al Viro <viro@ftp.linux.org.uk> wrote:

> On Wed, Oct 03, 2007 at 10:46:07AM +0200, Ingo Molnar wrote:
> > 
> > hm, i just triggered the procfs crash below with -rc9 on a testbox. 
> > Config attached. It's easy to reproduce it via 'service sshd restart'. 
> > The crash site is:
> > 
> >  (gdb) list *0xc017599d
> >  0xc017599d is in seq_path (fs/seq_file.c:354).
> >  349             if (m->count < m->size) {
> >  350                     char *s = m->buf + m->count;
> >  351                     char *p = d_path(dentry, mnt, s, m->size - m->count);
> >  352                     if (!IS_ERR(p)) {
> >  353                             while (s <= p) {
> >  354                                     char c = *p++;
> >  355                                     if (!c) {
> >  356                                             p = m->buf + m->count;
> >  357                                             m->count = s - m->buf;
> >  358                                             return s - p;
> >  (gdb)
> > 
> > any ideas? Fortunately i was able to do an strace of the incident:
> 
> Charming...  So we get d_path() either returning junk or we get 
> something that isn't NUL-terminated.  Which one it is?  I.e. what does 
> p look like and what's in s?

could be use-after-free as well, as CONFIG_PAGEALLOC was enabled.

	Ingo
