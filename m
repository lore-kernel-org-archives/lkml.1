Return-Path: <linux-kernel-owner+w=401wt.eu-S932543AbXFEOrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932543AbXFEOrY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 10:47:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932576AbXFEOqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 10:46:43 -0400
Received: from raven.upol.cz ([158.194.120.4]:45149 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932489AbXFEOql (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 10:46:41 -0400
Date: Tue, 5 Jun 2007 16:57:59 +0200
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       kbuild-devel@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [kbuild-devel] [PATCH 08/19] scripts: Make cleanfile/cleanpatch warn about long lines
Message-ID: <20070605145759.GP7266@flower.upol.cz>
References: <20070603204700.GH9240@uranus.ravnborg.org> <20070605073335.GM7266@flower.upol.cz> <20070605081959.GB21991@uranus.ravnborg.org> <20070605133834.GO7266@flower.upol.cz> <20070605141254.GA24722@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070605141254.GA24722@uranus.ravnborg.org>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2007 at 04:12:54PM +0200, Sam Ravnborg wrote:
> On Tue, Jun 05, 2007 at 03:38:34PM +0200, Oleg Verych wrote:
> > On Tue, Jun 05, 2007 at 10:19:59AM +0200, Sam Ravnborg wrote:
> > []
> > > If on the other hand you are proposing a script to clean whitespace
> > > damage in the code then git already does this nicely.
> > 
> > I've read that too quickly, sorry. What then all that clean scripts
> > are for?
> cleanfile compress spaces to tabs where appropriate. It does more
> than just warn about too long lines and remove leading whitespace.

Ah!

It's not an occasion, that this script does job of two, you are referring
to. I should add documentation to this script, that will far longer, that
script itself.

-*- slightly i/o optimized <clean-whitespace.sh> -*-
#!/bin/sh -e
# clean whitespace damage; i/o=stdin/stdout
#
IFS='' ; t="`printf '\t'`" ; s=' ' ; s7="$s$s$s$s$s$s$s" ; w79=79 ;
case $0 in *diff* | *patch*) p='+' ; s='';; esac

expand | while read line
do case "$line" in
   ++*) echo "$line";;
   $p*)	[ ${#line} -gt $w79 ] && : ${long:=line}
	echo "$line" | sed "/^$p/{s_ *\$__;s_^$p$s7${s}_$p${t}_;s_$s7 _${t}_g}"
	;;
     *) echo "$line";;
   esac
done
[ -n "$long" ] && echo "at least one line, wider than $w79 chars, found" 1>&2

-*-

First line stops word splitting, puts tab symbol in t, space in s,
seven spaces to s7 and line width limit to w79.

Second -- adjust set variables for need of unified diff processing, if
name of the script $0 (can be changed to match command-line
parameters) have "diff" or "patch".

Last -- bark, if there is at least one line longer that w79.

Rest is processing of files/patches to expand(posix tool) tabs to spaces
then:
- patches are processed only by lines, starting from `+', but not `++'
- remove trailing whitespace;
- substitute eight spaces to one tab symbol
- patches have "linestart`+tab'" expanded to seven spaces, due to `+' and
  tabstop, thus seven spaces are substituted in this case.

Anything else, if have not noticed in whitespace damage matching can be
added on request ;)

> Please look at latest -git tree if you are trying to improve
> the clean* scripts or add counterparts.
> 
> Thanks,
> 	Sam
____
