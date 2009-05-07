Return-Path: <linux-kernel-owner+w=401wt.eu-S1760573AbZEGP37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760573AbZEGP37 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 11:29:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbZEGP3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 11:29:49 -0400
Received: from mx01.bfk.de ([193.227.124.2]:47106 "EHLO mx01.bfk.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752592AbZEGP3s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 11:29:48 -0400
X-Greylist: delayed 684 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 May 2009 11:29:47 EDT
To: Matt Mackall <mpm@selenic.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Arjan van de Ven <arjan@infradead.org>, Jake Edge <jake@lwn.net>,
       security@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
       Eric Paris <eparis@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Roland McGrath <roland@redhat.com>, mingo@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Dave Jones <davej@redhat.com>
Subject: Re: [Security] [PATCH] proc: avoid information leaks to non-privileged processes
References: <m1vdogbows.fsf@fess.ebiederm.org>
	<alpine.LFD.2.01.0905041514350.4983@localhost.localdomain>
	<20090505055011.GE31071@waste.org> <20090505063156.GA24504@elte.hu>
	<m14ow0ynjm.fsf@fess.ebiederm.org> <20090505195246.GC21973@elte.hu>
	<20090505202219.GL31071@waste.org> <20090506103034.GA25203@elte.hu>
	<20090506162543.GT31071@waste.org>
	<alpine.LFD.2.01.0905060942340.4983@localhost.localdomain>
	<20090506175717.GY31071@waste.org>
From: Florian Weimer <fweimer@bfk.de>
Date: Thu, 07 May 2009 17:16:27 +0200
In-Reply-To: <20090506175717.GY31071@waste.org> (Matt Mackall's message of "Wed, 6 May 2009 12:57:17 -0500")
Message-ID: <82prel54fo.fsf@mid.bfk.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Matt Mackall:

> On Wed, May 06, 2009 at 09:48:20AM -0700, Linus Torvalds wrote:
>> 
>> Matt, are you willing to ack my suggested patch which adds history to the 
>> mix? Did somebody test that? I have this memory of there being an 
>> "exploit" program to show the non-randomness of the values, but I can't 
>> recall details, and would really want to get a second opinion from 
>> somebody who cares about PRNG's.
>
> I still don't like it. I bounced it off some folks on the adversarial
> side of things and they didn't think it looked strong enough either.
> Full MD5 collisions can be generated about as fast as they can be
> checked, which makes _reduced strength_ MD4 not much better than an
> LFSR in terms of attack potential.

Well, with periodic reseeding, even that shouldn't be a problem.  You
don't need collision resistance at all, so those MD5 attacks don't
tell you anything about the difficulty of state recovery/prediction
attacks on your variant.  (The trouble with hash functions is that
they haven't got any secrets to work from.  With seeded PRNGs, this is
obviously different.)

On the other hand, most people who need a quick, unpredictable source
of randomness seem to use RC4 with a random key initialized from a
more costly source.  (If you're paranoid, you should discard the first
few hundred bytes.)  The nice thing is that you can use a well-tested
primitive, unchanged, so it's easier to avoid nasty suprises.

Oh, and you should really, really ditch that Tausworthe generator (in
lib/random32.c).

-- 
Florian Weimer                <fweimer@bfk.de>
BFK edv-consulting GmbH       http://www.bfk.de/
Kriegsstraﬂe 100              tel: +49-721-96201-1
D-76133 Karlsruhe             fax: +49-721-96201-99
