Return-Path: <linux-kernel-owner+w=401wt.eu-S1754943AbZIBIeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943AbZIBIeu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 04:34:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753119AbZIBIeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 04:34:50 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:52490 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864AbZIBIet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 04:34:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: [PATCH 2/3] Add MAP_HUGETLB for mmaping pseudo-anonymous huge page regions
Date: Wed, 2 Sep 2009 10:34:40 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-6-generic; KDE/4.3.0; x86_64; ; )
Cc: Eric B Munson <ebmunson@us.ibm.com>, Mel Gorman <mel@csn.ul.ie>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org, linux-man@vger.kernel.org,
       Michael Kerrisk <mtk.manpages@gmail.com>, randy.dunlap@oracle.com
References: <cover.1251282769.git.ebmunson@us.ibm.com> <20090901130801.GB7995@us.ibm.com> <Pine.LNX.4.64.0909011418490.8674@sister.anvils>
In-Reply-To: <Pine.LNX.4.64.0909011418490.8674@sister.anvils>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909021034.40827.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19blNigrqrns4iVO+skcwvsf/GDyHvlYG9fekc
 DqIDUCi9foCH70ijm4GgMv+YtG8/uvP0SzIlM0hNVOCvH6bpue
 r52OqM2POel8UFOk1aNXw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 September 2009, Hugh Dickins wrote:
> On Tue, 1 Sep 2009, Eric B Munson wrote:
> > On Tue, 01 Sep 2009, Hugh Dickins wrote:
> > > 
> > > That is explained by you #defining MAP_HUGETLB in include/asm-generic/
> > > mman-common.h to a number which is already being used for other MAP_s
> > > on some architectures.  That's a separate bug which needs to be fixed
> > > by distributing the MAP_HUGETLB definition across various asm*/mman.h.
> > 
> > Would it be okay to keep the define in include/asm-generic/mman.h
> > if a value that is known free across all architectures is used?
> > 0x080000 is not used by any arch and, AFAICT would work just as well.
> 
> That's a very sensible suggestion, but departs from how we have
> assigned new numbers up until now: so include/asm-generic/mman-common.h
> isn't actually where we'd expect to find a Linux-specific MAP_ define.
> 
> I'd say, yes, do that for now, so as not to hit this conflict while
> testing in mmotm.  But whether it should stay that way, or later the
> arch/*/include/asm/mman.h's be updated as I'd imagined, I don't know.
> 
> Arnd, Michael, do you have any views on this?

The minimal procedure would be to add it to mman-common.h, plus
the asm/mman.h files for xtensa, mips, parisc and alpha, which all
use a version that is compatible to a Unix variant, but that would
be confusing the next person that needs to add a flag.

I'd use the number 0x40000 for all architectures except alpha,
because that makes the most sense for asm-generic/mman.h. Alpha
is weird anyway here, so we don't need to avoid conflicts with it.

With a few exceptions (sparc, powerpc), I think we should change
all architectures to use asm-generic/mman.h instead of mman-common.h
in the long run. If you touch those anyway, one option would be
to do it in one step.

	Arnd <><
