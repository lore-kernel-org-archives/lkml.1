Return-Path: <linux-kernel-owner+w=401wt.eu-S1762540AbXKAXQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762540AbXKAXQp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 19:16:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755320AbXKAXJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 19:09:07 -0400
Received: from xenotime.net ([66.160.160.81]:55389 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759770AbXKAXJB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 19:09:01 -0400
Date: Thu, 1 Nov 2007 16:08:57 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Andreas Mohr <andi@lisas.de>, herbert@gondor.apana.org.au
Cc: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/RFC] eradicate bashisms in scripts/patch-kernel
Message-Id: <20071101160857.6e877307.rdunlap@xenotime.net>
In-Reply-To: <20071101221606.GA10116@rhlx01.hs-esslingen.de>
References: <20071031211321.GA8363@rhlx01.hs-esslingen.de>
	<47290096.7080207@oracle.com>
	<20071101121133.GA14807@rhlx01.hs-esslingen.de>
	<20071101082457.ff9a5d67.randy.dunlap@oracle.com>
	<20071101221606.GA10116@rhlx01.hs-esslingen.de>
Organization: YPO4
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Nov 2007 23:16:06 +0100 Andreas Mohr wrote:

[add Herbert]

> Hi,
> 
> On Thu, Nov 01, 2007 at 08:24:57AM -0700, Randy Dunlap wrote:
> > On Thu, 1 Nov 2007 13:11:33 +0100 Andreas Mohr wrote:
> > > I'll think a bit more about these couple changed places (and whether
> > > this still truly works as intended) and mail a patch then.
> > > 
> > > (and a big NOTE: I'm no POSIX vs. non-POSIX shell guru at all, only a
> > > semi-versed shell script writer, thus these changes should be reviewed
> > > quite thoroughly)
> > 
> > Neither am I.  I read those web pages quickly yesterday, so after
> > you read them, we can discuss more and/or review more patches.
> 
> OK, next iteration (v2).
> 
> 
> Make the patch-kernel shell script sufficiently compatible with POSIX shells.
> 
> 
> Changes since v1:
> - don't actually change string quoting
> - prepend ./ at mktemp step already
> - remove added superfluous spaces in arithmetic expression
> - don't remove double braces in STOPSUBLEVEL evaluation,
>   since these are integer values to be compared
> 
> Full ChangeLog:
> - replaced non-standard "==" by standard "="
OK

> - replaced non-standard "source" statement by POSIX "dot" statement
OK

> - POSIX shell local file lookup needs ./ prepended, thus have mktemp
>   use this from the beginning and comment it properly

I would like the patch description to say something like:

Use ./ as a prefix on the TEMP filename so that the current search
PATH will not be searched and thus another file with this same
(pseudo random) name won't be used accidentally.

> - replace non-standard bash string parsing by sed expression
>   (is the sed syntax ok? correct? strict enough?)

I think that this is the part that bothers me.  I can't find
anything at
http://www.opengroup.org/onlinepubs/000095399/utilities/xcu_chap02.html
that says that this:
	EXTRAVER=${EXTRAVER%%[[:punct:]]*}

is invalid or even optional syntax.  OTOH, it does list such syntax,
so why are we working around this syntax?
Please point out to me what I am missing...

> - added missing $ signs to shell variable names
OK


> About the missing $ signs:
> http://www.opengroup.org/onlinepubs/009695399/utilities/xcu_chap02.html#tag_02_14
> says:
> "If the shell variable x contains a value that forms a valid integer
> constant, then the arithmetic expansions
>  "$((x))" and "$(($x))" shall return the same value."
> 
> Hmm, well, seems dash doesn't... (syntax error).
> Thus I still needed to add the $ signs despite opengroup.org specifying
> it differently.

Herbert?

> Updated version verified again to now work with both bash and dash
> on Debian stable.
> 
> Patch intended for inclusion in -mm, once it has survived some reviews.
> 
> Thanks.
> 
> Signed-off-by: Andreas Mohr <andi@lisas.de>
> 
> --- linux-2.6.23/scripts/patch-kernel.orig	2007-11-01 22:51:34.000000000 +0100
> +++ linux-2.6.23/scripts/patch-kernel	2007-11-01 22:10:14.000000000 +0100
> @@ -65,7 +65,7 @@
>  patchdir=${2-.}
>  stopvers=${3-default}
>  
> -if [ "$1" == -h -o "$1" == --help -o ! -r "$sourcedir/Makefile" ]; then
> +if [ "$1" = -h -o "$1" = --help -o ! -r "$sourcedir/Makefile" ]; then
>  cat << USAGE
>  usage: $PNAME [-h] [ sourcedir [ patchdir [ stopversion ] [ -acxx ] ] ]
>    source directory defaults to /usr/src/linux,
> @@ -182,10 +182,12 @@
>  }
>  
>  # set current VERSION, PATCHLEVEL, SUBLEVEL, EXTRAVERSION
> -TMPFILE=`mktemp .tmpver.XXXXXX` || { echo "cannot make temp file" ; exit 1; }
> +# sourcing $TMPFILE.1 below needs lookup in local directory in a POSIX shell,
> +# thus prepend ./ to mktemp argument
> +TMPFILE=`mktemp ./.tmpver.XXXXXX` || { echo "cannot make temp file" ; exit 1; }
>  grep -E "^(VERSION|PATCHLEVEL|SUBLEVEL|EXTRAVERSION)" $sourcedir/Makefile > $TMPFILE
>  tr -d [:blank:] < $TMPFILE > $TMPFILE.1
> -source $TMPFILE.1
> +. $TMPFILE.1
>  rm -f $TMPFILE*
>  if [ -z "$VERSION" -o -z "$PATCHLEVEL" -o -z "$SUBLEVEL" ]
>  then
> @@ -202,13 +204,7 @@
>  EXTRAVER=
>  if [ x$EXTRAVERSION != "x" ]
>  then
> -	if [ ${EXTRAVERSION:0:1} == "." ]; then
> -		EXTRAVER=${EXTRAVERSION:1}
> -	else
> -		EXTRAVER=$EXTRAVERSION
> -	fi
> -	EXTRAVER=${EXTRAVER%%[[:punct:]]*}
> -	#echo "$PNAME: changing EXTRAVERSION from $EXTRAVERSION to $EXTRAVER"
> +	EXTRAVER=`echo $EXTRAVERSION|sed -s 's/^[\.]\?\([^[:punct:]]*\).*/\1/'`
>  fi
>  
>  #echo "stopvers=$stopvers"
> @@ -251,16 +247,16 @@
>  do
>      CURRENTFULLVERSION="$VERSION.$PATCHLEVEL.$SUBLEVEL"
>      EXTRAVER=
> -    if [ $stopvers == $CURRENTFULLVERSION ]; then
> +    if [ $stopvers = $CURRENTFULLVERSION ]; then
>          echo "Stopping at $CURRENTFULLVERSION base as requested."
>          break
>      fi
>  
> -    SUBLEVEL=$((SUBLEVEL + 1))
> +    SUBLEVEL=$(($SUBLEVEL + 1))
>      FULLVERSION="$VERSION.$PATCHLEVEL.$SUBLEVEL"
>      #echo "#___ trying $FULLVERSION ___"
>  
> -    if [ $((SUBLEVEL)) -gt $((STOPSUBLEVEL)) ]; then
> +    if [ $(($SUBLEVEL)) -gt $(($STOPSUBLEVEL)) ]; then
>  	echo "Stopping since sublevel ($SUBLEVEL) is beyond stop-sublevel ($STOPSUBLEVEL)"
>  	exit 1
>      fi
> @@ -297,7 +293,7 @@
>  if [ x$gotac != x ]; then
>    # Out great user wants the -ac patches
>  	# They could have done -ac (get latest) or -acxx where xx=version they want
> -	if [ $gotac == "-ac" ]; then
> +	if [ $gotac = "-ac" ]; then
>  	  # They want the latest version
>  		HIGHESTPATCH=0
>  		for PATCHNAMES in $patchdir/patch-${CURRENTFULLVERSION}-ac*\.*
> -

Thanks,
---
~Randy
