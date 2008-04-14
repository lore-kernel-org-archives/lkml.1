Return-Path: <linux-kernel-owner+w=401wt.eu-S1760515AbYDNINO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760515AbYDNINO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 04:13:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760477AbYDNIMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 04:12:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58174 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760463AbYDNIMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 04:12:46 -0400
Date: Mon, 14 Apr 2008 10:12:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, mingo <mingo@redhat.com>,
       tglx <tglx@linutronix.de>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for April 10 (arch/x86)
Message-ID: <20080414081220.GA19865@elte.hu>
References: <20080410181404.b76939a6.sfr@canb.auug.org.au> <20080410150950.5913b16a.randy.dunlap@oracle.com> <20080411074631.GB6410@elte.hu> <20080411081901.f56f5180.randy.dunlap@oracle.com> <20080411152648.GK9785@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080411152648.GK9785@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Al Viro <viro@ZenIV.linux.org.uk> wrote:

> On Fri, Apr 11, 2008 at 08:19:01AM -0700, Randy Dunlap wrote:
> 
> > > It
> > > is a totally uninteresting warning that we pass in a narrower type to 
> > > printk(). It cannot ever cause any bugs or problems. Why does gcc warn 
> > > about it?
> > 
> > No idea about that part.
> 
> Er...  That's kinda obvious - vararg function getting the wrong-sized
> argument is *NOT* a harmless situation.  And yes, it's certainly a bug -
> gcc manages to recover by using the knowledge of printf() formats (i.e.
> it guesses that we want a long long and does conversion), but try to
> do
> 	char *s = "%llx %c";
> 	printf(s, 1, '.');
> and watch the show...

well, gcc does not "recover", we _gave_ it the format string as a 
constant, and do so in 99.9% of the cases. It is a totally 
well-specified thing.

so yes, this warning is bogus.

You are right that passing in a non-constant string to printf is 
inherently dangerous though, and i'd suggest we warn about _that_ very 
prominently.

but the constant noise from gcc about printf formats, where the 
conversion is very clear and could be done implicitly, only hinders us 
and only teaches people to _ignore_ gcc warnings - which is actually 
very dangerous.

the only warning from gcc in this area should be where the format 
results in information _loss_ (i.e. the format has a narrower type than 
we pass into it) - there a warning is very much needed - and the 
programmer should then fix the bug or add a cast.

	Ingo
