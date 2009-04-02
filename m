Return-Path: <linux-kernel-owner+w=401wt.eu-S1761814AbZDBTCJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761814AbZDBTCJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 15:02:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751550AbZDBTBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 15:01:55 -0400
Received: from mo-p05-ob.rzone.de ([81.169.146.182]:28981 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028AbZDBTBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 15:01:54 -0400
X-RZG-AUTH: :LWIQcGC8af5qXkYNYt77sURZEFmV4M3TAgvB+Qeh4tE+44JfzNbdalLaF0lu
X-RZG-CLASS-ID: mo05
Message-ID: <49D50B9D.608@ursus.ath.cx>
Date: Thu, 02 Apr 2009 21:01:49 +0200
From: "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Hans-Peter Jansen <hpj@urpla.net>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       linux-kernel@vger.kernel.org, arjan@linux.intel.com
Subject: Re: Linux 2.6.29
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain> <1238168777.5969.18.camel@marge.simson.net> <alpine.LFD.2.00.0903270852070.3994@localhost.localdomain> <200903310000.11522.hpj@urpla.net>
In-Reply-To: <200903310000.11522.hpj@urpla.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 31.03.2009 00:00 Hans-Peter Jansen wrote:

> I build kernel rpms from your git tree, and have a bunch of BUILDs lying 
> around. 
So you have a place where you have a git repository from which you copy
the source tree to rpms, which have no connection to the git anymore?

> Sure, I can always fetch the tarballs or fiddle with git, but why? 

You may add a small script like this into .git/hooks/post-checkout:

-----
#!/bin/bash

if [ "$3" == 1 ]; then # don't do it for file checkouts
 sed -ri "s/^(EXTRAVERSION =.*)/\1$(scripts/setlocalversion)/" Makefile
fi
-----

That will append the EXTRAVERSION automatically with what
CONFIG_LOCALVERSION_AUTO=y would append to the version string.


> Having a Makefile start commit allows to make sure with simplest tools, 
> say "head Makefile" that a locally copied 2.6.29 tree is really a 2.6.29, 
> and not something moving towards the next release. That's all, nothing 
> less, nothing more, it's just a strong hint which blend is in the box.

If you are working on a tagged version, the EXTRAVERSION won't be
extended, on an untagged version it will have some ident for that
intermediate version

e.g.
git checkout master       -> EXTRAVERSION =-07100-g833bb30
git checkout HEAD~1       -> EXTRAVERSION =-07099-g8b53ef3
git checkout v2.6.29      -> EXTRAVERSION =
git checkout HEAD~1       -> EXTRAVERSION = -rc8-00303-g0030864
git checkout v2.6.29-rc8  -> EXTRAVERSION = -rc8

In that way your copies of the source tree will have the EXTRAVERSION
set in the Makefile. You can detect an intermediate version easily in
the Makefile and you even can checkout that exact version from the git
tree later, if you need to. Or just make an diff between two rpms by
diffing the versions taken from the Makefiles e.g.

git diff 07099-g8b53ef3..07100-g833bb30
or
git diff 00303-g0030864..v2.6.29

Attention:
Of course, the Makefile is changed in your working tree as if you had
changed it yourself. Therefore you have to use "git checkout Makefile"
to revert the changes before you can checkout a different version from
the git tree.

This is only a hack and there might be a better way to do it, but maybe
it helps as a starting point in your special situation.


Andreas

