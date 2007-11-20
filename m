Return-Path: <linux-kernel-owner+w=401wt.eu-S1764351AbXKTVL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764351AbXKTVL4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 16:11:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759319AbXKTVLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 16:11:45 -0500
Received: from 41-052.adsl.zetnet.co.uk ([194.247.41.52]:33031 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760414AbXKTVLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 16:11:43 -0500
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       David Miller <davem@davemloft.net>, xiyou.wangcong@gmail.com,
       goodmenkernel@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: Is there any word about this bug in gcc ?
References: <E1IuMnZ-0003o3-00@gondolin.me.apana.org.au>
	<4742831F.9040408@zytor.com>
From: Nix <nix@esperi.org.uk>
Emacs: where editing text is like playing Paganini on a glass harmonica.
Date: Tue, 20 Nov 2007 21:10:49 +0000
In-Reply-To: <4742831F.9040408@zytor.com> (H. Peter Anvin's message of "20 Nov 2007 06:50:10 -0000")
Message-ID: <877ikc1v3a.fsf@hades.wkstn.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b28 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-CTc-dcc2-Metrics: hades 1031; Body=6 Fuz1=6 Fuz2=6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 Nov 2007, H. Peter Anvin outgrape:
> This one is definitely messy.  There is absolutely no way to know what
> gcc has miscompiled.

Actually, since this only affects abs() calls containing multiplications
or divisions by negative constants, you can at least make a pretty good
guess as to its prevalence with nothing more than grep (first grep -w
for abs, then grepping for "- *[0-9]" and filtering the rest by
eye). (This won't catch cases of macros using abs() which are then
called with negative constants, but it *will* catch those macros, and
one can check the calls to such things by hand. I've done that as well.)

I've grepped all the source on my system (1148 expanded upstream source
tarballs or git/cvs/svn trees including the Linux kernel, most of GNOME,
and all of KDE and X.org) and found that hits are extremely rare: not as
rare as calls to seekdir() and telldir() :) but rare. (Quite a lot of
things multiply by negative constants *inside* a call to abs(), but this
should be unaffected.)

Certain hits:

./nethack/3.4.3/src/cmd.c:        else if(x < -2*abs(y))
./nethack/3.4.3/src/cmd.c:        else if(y < -2*abs(x))

Possible hits (I'm not sure what the folder would do with this: the
extra level of brackets in the way might affect things but I don't think
so):

./libtheora/libtheora/lib/enc/pp.c:      TmpMod = 32 + QValue - 2*(abs(Src[j+Pitch]-Src[j]));
./libtheora/libtheora/lib/enc/pp.c:      TmpMod = 32 + QValue - 2*(abs(Src[j+1]-Src[j]));

./xmms/modules/projectM-0.94.20/main.c:   wave_x_temp=-2*0.4142*(abs(abs(wave_mystery)-.5)-.5);
./xmms/modules/projectM-0.94.20/main.c:   wave_x_temp=-2*0.4142*(abs(abs(wave_mystery)-.5)-.5);


None of these affected programs strike me as being exactly system-
critical. I think the impact of this bug is probably survivable. :)

I'd build a GCC with the patch and verify that these programs are
compiled differently with it, but they look unimportant enough that I'm
not really sure I care enough to do it...

-- 
`Some people don't think performance issues are "real bugs", and I think 
such people shouldn't be allowed to program.' --- Linus Torvalds
