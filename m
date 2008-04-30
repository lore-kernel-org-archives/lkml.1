Return-Path: <linux-kernel-owner+w=401wt.eu-S1760932AbYD3Jc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760932AbYD3Jc6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 05:32:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754537AbYD3Jct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 05:32:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53309 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752071AbYD3Jcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 05:32:48 -0400
Date: Wed, 30 Apr 2008 11:32:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Bj?rn Steinbrink <B.Steinbrink@gmx.de>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH] x86: !x & y typo in mtrr code
Message-ID: <20080430093233.GD23528@elte.hu>
References: <1209268817.14173.43.camel@brick> <20080427042051.GL5882@ZenIV.linux.org.uk> <20080429210435.GA23008@elte.hu> <20080430064603.GA3602@atjola.homenet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080430064603.GA3602@atjola.homenet>
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


* Bj?rn Steinbrink <B.Steinbrink@gmx.de> wrote:

> > firstly, it _was_ caught via Sparse, ...
> 
> But that is exactly Al's point. Had you run sparse over your tree 
> _before_ it got pulled by Linus, that bug should have never made it 
> into mainline.

It is clear from your argument that you have never attempted to do this 
yourself for any significant size of code. Sparse output is way too 
verbose, the false positive rate is well above 50% and way too few 
subsystems care about it.

What you have also missed is the plain fact that x86 _is_ amongst the 
very few subsystems that _do_ regular Sparse runs.  The person who does 
this regular (and not trivial) manual Sparse sweep work for arch/x86 is 
... Harvey, the person who submitted this fix! Most of the time Harvey's 
Sparse fixes hit x86.git before we push it upstream. Sometimes, as in 
this case, after. As per the analysis of this specific bug no puppies 
were hurt - and that's typical of most Sparse fixes.

Sparse analysis is not just a matter of typing "make C=1" and fixing 
whatever it prints... FYI, today's -git has the following Sparse 
warnings histogram (sparse-0.4.1-2.fc9):

      2  error: incompatible types in comparison expression (different address spaces)
      3  error: dubious one-bit signed bitfield
      5  error: subtraction of different types can't work (different address spaces)
     10  error: incompatible types for operation (*)
     10  error: invalid assignment
     24  error: cannot size expression
     97  error: bad constant expression
    157  error: bad integer constant expression
  86817  error: attribute '__cold__': unknown attribute

even ignoring those nearly one hundred thousand '__cold__' warnings 
(which came upstream many months ago via commit v2.6.24-2245-gf3fe866), 
that's still more than 300 warnings to sift through.

The reality is that nearly nobody runs Sparse for every patch and nearly 
nobody cares about making the default C=1 output meaningful and 
interesting to newbies. It's a frustrating experience at the moment, and 
its (non-) uptake is reflecting that reality.

And as anyone can see it from the verbosity of the histogram above, 
Sparse validation is a deeply manual work today, for something as 
complex as general x86. Al has delta analysis automation around it but 
those tools are not part of the upstream kernel yet and it's not usable 
for daily patch-management.

Automating Sparse runs so that it can become part of our daily 
patch-flow is _not_ trivial and it's not just a matter of typing make 
C=1. Thomas is working on integrating Sparse delta analysis into our 
daily patch workflow nevertheless.

But to suggest that we somehow should have done this before shows deep 
ignorance of the problem space, at best.

	Ingo
