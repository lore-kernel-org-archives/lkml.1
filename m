Return-Path: <linux-kernel-owner+w=401wt.eu-S1759729AbZDKX5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759729AbZDKX5r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 19:57:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756466AbZDKX5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 19:57:35 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:59914 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754297AbZDKX5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 19:57:33 -0400
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, Hugh Dickins <hugh@veritas.com>,
       Tejun Heo <tj@kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>
References: <m1skkf761y.fsf@fess.ebiederm.org>
	<20090411155852.GV26366@ZenIV.linux.org.uk>
	<m1k55ryw2n.fsf@fess.ebiederm.org>
	<20090411165651.GW26366@ZenIV.linux.org.uk>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sat, 11 Apr 2009 16:57:25 -0700
In-Reply-To: <20090411165651.GW26366@ZenIV.linux.org.uk> (Al Viro's message of "Sat\, 11 Apr 2009 17\:56\:51 +0100")
Message-ID: <m1skkeu4ka.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: viro@ZenIV.linux.org.uk, gregkh@suse.de, alan@lxorguk.ukuu.org.uk, torvalds@linux-foundation.org, adobriyan@gmail.com, tj@kernel.org, hugh@veritas.com, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Al Viro <viro@ZenIV.linux.org.uk>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [RFC][PATCH 0/9] File descriptor hot-unplug support
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> writes:

> On Sat, Apr 11, 2009 at 09:49:36AM -0700, Eric W. Biederman wrote:
>
>> The fact that in the common case only one task ever accesses a struct
>> file leaves a lot of room for optimization.
>
> I'm not at all sure that it's a good assumption; even leaving aside e.g.
> several tasks sharing stdout/stderr, a bunch of datagrams coming out of
> several threads over the same socket is quite possible.

Maybe not.  However those cases are already more expensive today.
Somewhere along the way we are already going to get cache line ping
pongs if there is real contention, and we are going to see the cost of
atomic operations.  In which case the extra ref counting I am doing is
a little more expensive.  And when I say a little more expensive I
mean 10-20ns per read/write more expensive.

At the same time if the common case really is applications not sharing
file descriptors (which seems sane) my current optimization easily
keeps the cost to practically nothing.

Using the srcu locking would also keep the cost down in the noise
because it guarantees non-shared cachelines and no expensive atomic
operations.  srcu has the downside of requiring per cpu memory which
seems wrong to me somehow.  However there are hybrid models like what
is used in mnt_want_write that are possible to limit the total amount
of per cpu memory while still getting the advantages.

Beyond that for correctness it looks like a pay me now or pay me later
situation.  Do we track when we are in the methods for an object
generically where we can do the work once, and then concentrate on
enhancements.  Or do we bog ourselves down using inferior
implementations that are replicated in varying ways from subsystem to
subsystem, and spend our time fighting the bugs in the subsystems?

I have the refcount/locking abstraction wrapped and have only to
perform the most basic of optimizations. So if we need to do something
more it should be easy.

Is performance your only concern with my patches?

Eric
