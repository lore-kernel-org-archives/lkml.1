Return-Path: <linux-kernel-owner+w=401wt.eu-S936713AbXGUIJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936713AbXGUIJS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 04:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760090AbXGUIJB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 04:09:01 -0400
Received: from barikada.upol.cz ([158.194.242.200]:47650 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079AbXGUII7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 04:08:59 -0400
To: Sam Ravnborg <sam@ravnborg.org>
Cc: kbuild-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier@gentoo.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 25/33] kbuild: use POSIX BRE in headers install target
In-Reply-To: <1184681344376-git-send-email-sam@ravnborg.org>
References: <11846813423231-git-send-email-sam@ravnborg.org> <11846813431389-git-send-email-sam@ravnborg.org> <1184681343412-git-send-email-sam@ravnborg.org> <11846813432249-git-send-email-sam@ravnborg.org> <1184681343297-git-send-email-sam@ravnborg.org> <11846813432231-git-send-email-sam@ravnborg.org> <1184681343423-git-send-email-sam@ravnborg.org> <11846813432234-git-send-email-sam@ravnborg.org> <11846813441521-git-send-email-sam@ravnborg.org> <11846813443387-git-send-email-sam@ravnborg.org> <1184681344594-git-send-email-sam@ravnborg.org> <11846813444176-git-send-email-sam@ravnborg.org> <11846813442297-g   it-send-email-sam@ravnborg.org> <11846813443187-git-send-email-sam@ravnborg.org> <11846813   444171-git-send-email-sam@ravnborg.org> <1184681344985-git-send-email-sam@ravnborg.org> <11846813442810-git-send-email-sam@ravnborg.org> <118468134441-git-send-email-sam@ravnborg.org> <11846813441741-git-send-email-sam@ravnborg.org> <1184681344376-git-send-email-sam@ravnborg.org>
Date: Sat, 21 Jul 2007 10:22:34 +0200
Message-Id: <E1ICAEU-0005an-5F@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Date: Tue, 17 Jul 2007 16:08:54 +0200
>
> From: Mike Frysinger <vapier@gentoo.org>
>
> The sed expression used at the moment in scripts/Makefile.headersinst
> relies on the (handy) GNU extension where you can escape ERE's in an
> otherwise BRE without using the GNU -r option.  The following patch
> replaces this "\+" usage with a functionally equivalent POSIX BRE compliant
> "\{1,\}".

Matching at least one occurrence, right?

> Tested with `make headers_install` against blackfin/x86_64/i386
> targets.
>
> Stupid whiny OS X users and their crappy sed ;)

That may be. My games with strict POSIX sed syntax render busybox's sed
as crap for example. So, you never know.

>  # Eliminate the contents of (and inclusions of) compiler.h

OK, that means annotations and non ANSI 'inline' thing. Lets see.

>  HDRSED  := sed 	-e "s/ inline / __inline__ /g" \
[]
> -		-e "s/[[:space:]]__attribute_const__[[:space:]]\+/\ /g" \

* [[:space:]] are more than tab and space isspace(3), is it more
  effective to use [[:blank:]] instead?

> +		-e 
> "s/[[:space:]]__user[[:space:]]\{1,\}

substitute one or more ' __user '

> / /g" \

with ' ', everywhere (flag 'g'). So, is it really needed that '\{' thing?

> +		-e "s/(__user[[:space:]]\{1,\}/ (/g" \
> +		-e "s/[[:space:]]__force[[:space:]]\{1,\}/ /g" \
> +		-e "s/(__force[[:space:]]\{1,\}/ (/g" \
> +		-e "s/[[:space:]]__iomem[[:space:]]\{1,\}/ /g" \
> +		-e "s/(__iomem[[:space:]]\{1,\}/ (/g" \
> +		-e "s/[[:space:]]__attribute_const__[[:space:]]\{1,\}/\ /g" \
>  		-e "s/[[:space:]]__attribute_const__$$//" \

Is it allowed to use identifiers like '__attribute_const__foo' or
__attribute_const__[anything]? If it's not, last line is useless also.

>  		-e "/^\#include <linux\/compiler.h>/d"
whitespace is allowed   ^ here and is used for better readability
sometimes.
____
