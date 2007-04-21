Return-Path: <linux-kernel-owner+w=401wt.eu-S1031045AbXDUNaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031045AbXDUNaq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 09:30:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030866AbXDUNap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 09:30:45 -0400
Received: from wine.ocn.ne.jp ([220.111.47.146]:51352 "EHLO
	smtp.wine.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754442AbXDUNao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 09:30:44 -0400
X-Greylist: delayed 1983 seconds by postgrey-1.27 at vger.kernel.org; Sat, 21 Apr 2007 09:30:43 EDT
To: agruen@suse.de
Cc: alan@lxorguk.ukuu.org.uk, jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chrisw@sous-sol.org, akpm@linux-foundation.org
Subject: Re: [d_path 3/7] Add d_namespace_path() to compute namespace relative pathnames
From: Tetsuo Handa <penguin-fsdevel@I-love.SAKURA.ne.jp>
References: <20070412090809.917795000@suse.de>
	<200704170335.21805.agruen@suse.de>
	<20070417182126.2327d89d@the-village.bc.nu>
	<20070419232303.300441585@schurl.suse.de>
	<20070419234704.123573327@schurl.suse.de>
In-Reply-To: <20070419234704.123573327@schurl.suse.de>
Message-Id: <200704212157.GCF15034.WFMQGJHFTFOtEOV@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50]
X-Accept-Language: ja,en
Date: Sat, 21 Apr 2007 21:57:46 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I've just returned from ELC2007 and
I haven't read all posts in this thread yet,
but I want to comment to this function.

> In AppArmor, we are interested in pathnames relative to the namespace root.
> This is the same as d_path() except for the root where the search ends. Add
> a function for computing the namespace-relative path.
Yes. You came to the same conclusion as TOMOYO Linux does.
http://tomoyo.sourceforge.jp/cgi-bin/lxr/source/fs/realpath.c#L39


TOMOYO Linux uses pathnames relative to the namespace root.
You do this using d_path()'s way, but there needs some extensions
if you want to use d_namespace_path() for access control/auditing purpose.

In Linux, all characters other than NULL can be used in its pathname.
This means that you can't assume that whitespaces are delimiters.
For example, when you process entries in "Access ..... granted/rejected\n" format
(where ..... is a pathname and \n is a carriage return, like "Access /bin/ls granted\n"),
an entry "Access /bin/ls granted\nAccess /bin/cat granted\n" can be produced
if ..... is "/bin/ls granted\nAccess /bin/cat".
Processing such entry will produce wrong result.

Also, you want wildcards (usually "*") when doing pathname comparison,
but there are files that contains wildcards
(for example, "/usr/share/guile/1.6/ice-9/and-let*.scm" in CentOS 4.4).
You need to escape so that you can tell whether "*" indicates
a literal "*" or a wildcard.

Also, in non-English regions, characters that are out of ASCII printable range
are included in its pathname (for example, files created via Samba from Windows client).
Some programs can't handle characters that have MSB bit on,
so you may want to represent all characters without using MSB bit.

It may be OK if you use d_namespace_path() for processing a userland's configuration file,
but it is not OK if you use it for processing a kernel's configuration file.
The kernel has to be able to handle any characters.

So, you may want customized version of d_namespace_path()?
