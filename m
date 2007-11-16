Return-Path: <linux-kernel-owner+w=401wt.eu-S1752718AbXKPGBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718AbXKPGBK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 01:01:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751131AbXKPGA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 01:00:57 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:39934 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbXKPGA4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 01:00:56 -0500
Date: Thu, 15 Nov 2007 21:59:38 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       davem@davemloft.net, netdev@vget.kernel.org
Subject: Re: [NET]: rt_check_expire() can take a long time, add a
 cond_resched()
Message-ID: <20071115215938.44233733@laptopd505.fenrus.org>
In-Reply-To: <473D18A5.2090309@cosmosbay.com>
References: <200711150401.lAF41mSs021898@hera.kernel.org>
	<20071115193802.4ec64eef@laptopd505.fenrus.org>
	<473D131A.5000200@cosmosbay.com>
	<473D18A5.2090309@cosmosbay.com>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Nov 2007 05:12:21 +0100
Eric Dumazet <dada1@cosmosbay.com> wrote:

> Eric Dumazet a écrit :
> > Arjan van de Ven a écrit :
> >> On Thu, 15 Nov 2007 04:01:48 GMT
> >> Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:
> >>
> >>> Gitweb:
> >>> http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d90bf5a976793edfa88d3bb2393f0231eb8ce1e5 
> >>>
> >>> Commit:     d90bf5a976793edfa88d3bb2393f0231eb8ce1e5 Parent:
> >>> 66ba886254edbbd9442d30f1eef6f6fb0145027d Author:     Eric Dumazet
> >>> <dada1@cosmosbay.com> AuthorDate: Wed Nov 14 16:14:05 2007 -0800
> >>> Committer:  David S. Miller <davem@davemloft.net>
> >>> CommitDate: Wed Nov 14 16:14:05 2007 -0800
> >>>
> >>>     [NET]: rt_check_expire() can take a long time, add a
> >>> cond_resched()     On commit
> >>> 39c90ece7565f5c47110c2fa77409d7a9478bd5b:
> >>
> >>>     When the IP route cache is big, rt_check_expire() can take a
> >>> long time to run.  (default settings : 20% of the hash table is
> >>> scanned at each invocation)
> >>>         Adding cond_resched() helps giving cpu to higher priority 
> >>> tasks if
> >>>     necessary.
> >>>         Using a "if (need_resched())" test before calling
> >>> "cond_resched();" is necessary to avoid spending too much time
> >>> doing the resched check. 
> >>
> >> int __sched cond_resched(void)
> >> {
> >>         if (need_resched() &&  .....
> >>
> >> somehow I wonder why the second if() is useful at all; it's another
> >> spot for a branch predictor to miss... and a void function call is
> >> really really cheap... 
> > 
> > Its not that cheap. The ChangeLog included my own numbers, on a
> > Pentium M machine. (i686, 1.6 GHz, 1.5 GB ram)
> > 
> > Without "if (need_resched())" (so calling need_resched() X.XXX.XXX 
> > times), each run takes 88ms
> > 
> > With the extra check (and *much* less function calls), each run
> > takes 25ms
> > 
> 
> Looking at cond_resched(), I think the extra cost comes from
> "mov %esp,%edx ; and $0xffffe000,%edx" (current_thread_info())
> 
> I dont have oprofile numbers yet, but I suspect CPU may have some
> delays to compute this pointer value, since %esp is probably 'busy'
> because of the preceding "call"

yeah the explicit reference makes the stack pointer tracking engine do a
commit I suspect which then also creates a data dependency in the code
flow.

however... this is likely a good argument for making cond_resched() as a
whole a #define (or inline) that does this test and then calls the out
of line code (which then doesn't need to retest, so it avoids the
double test)...




-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
