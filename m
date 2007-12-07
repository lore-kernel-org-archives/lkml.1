Return-Path: <linux-kernel-owner+w=401wt.eu-S1754181AbXLGKhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181AbXLGKhs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 05:37:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751216AbXLGKhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 05:37:39 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38625 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022AbXLGKhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 05:37:38 -0500
Date: Fri, 7 Dec 2007 11:36:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Miles Lane <miles.lane@gmail.com>, laurent.riffard@free.fr,
       linux-kernel@vger.kernel.org, roland@redhat.com, tglx@linutronix.de
Subject: Re: 2.6.24-rc4-mm1: VDSOSYM build error
Message-ID: <20071207103637.GB27307@elte.hu>
References: <20071204211701.994dfce6.akpm@linux-foundation.org> <47587796.8020705@free.fr> <20071206143754.07a67819.akpm@linux-foundation.org> <a44ae5cd0712061528j4c0ea529w71bd2b96e1e73043@mail.gmail.com> <20071206153415.353ddeea.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071206153415.353ddeea.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 6 Dec 2007 18:28:25 -0500
> "Miles Lane" <miles.lane@gmail.com> wrote:
> 
> > How can I find Roland's patches, so I can try backing them out?
> > I looked in the broken out patches and only saw one related
> > to VDSO.  Backing it out did not help.  I tried searching for
> > messages to LKML sent by "roland" but mostly got a bunch of
> > folks sending spam.
> 
> They're all clumped into git-x86.patch.  Hard.

in theory the git merges could be generated as a flat series of patch 
files:

 x86.git.foo-fixes.patch
 x86.git.bar-updates.patch
 x86.git.foo-fixes-feh.patch
 ...

which could also include the commit log. "git-log -p" might be a 
suitable generator. For example, x86.git can be processed per commit, 
via this script:

  for N in `git-rev-list --reverse --no-merges --remove-empty master..mm`; do 
    git-log -p $N
  done

the following git-export-quilt script (just wrote it, might be buggy, so 
careful - and it blows away the patches/ directory wherever you run it) 
will generate a series file into patches/series that can be applied via 
quilt:

  rm -rf patches
  mkdir patches
  for N in `git-rev-list --reverse --no-merges --remove-empty master..mm`; do
   git-log -p -1 $N > .tmp
   export SUBJECT=`head -5 .tmp | tail -1`

   # generate filename out of subject line:
   FILE=x86.git-"`echo $SUBJECT | cut -c10- |
        tr '[:punct:] \t' '-' | tr -s - | tr '[:upper:]' '[:lower:]'`"

   # generate unique name:
   while [ -f patches/$FILE.patch ]; do FILE="$FILE"_; done

   echo $FILE.patch
   mv .tmp patches/$FILE.patch
   echo $FILE.patch >> patches/series
  done

  ls -l patches/series

i ran this script over x86.git and it produced a patch series with 247 
patches that quilt was able to push correctly. (in theory this concept 
should work for other git trees too - but i have not tried it)

this would increase the series size quite substantially though - but it 
would make cherry-picking and patch based bisection a lot easier.

	Ingo
