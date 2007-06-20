Return-Path: <linux-kernel-owner+w=401wt.eu-S1757619AbXFTO03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757619AbXFTO03 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 10:26:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753120AbXFTO0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 10:26:04 -0400
Received: from smtp002.mail.ukl.yahoo.com ([217.12.11.33]:47162 "HELO
	smtp002.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752401AbXFTO0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 10:26:00 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Message-Id;
  b=rbBS5ivoysGvwkGs9kgHG2SrXF32PoqJvRVR8pQaOdrexWOlZqngVux9KX/f0UW18ROyTHpDcms+cWEmcHq2UueJhgHZlLKm/sq0iZlN+iVNcG8u2ytqqJ6xh0ido1L6HCLZxWFavjEswhbiB2nqon/3X/nt/S+pIhYnReWLAJI=  ;
X-YMail-OSG: 75Msm.QVM1mSyYvkbCgAODAaTKDpdG2EGK41RhW7IKEkMt91aJ4AgZ9EzILSiWyGSaKtsrjFx_WIt.mafaz_DYQ2W2ReBxhhdQvuxBNuJ8SnALjA
From: Blaisorblade <blaisorblade@yahoo.it>
To: user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [uml-devel] [PATCH 2/2] UML - Add stack usage monitoring
Date: Wed, 20 Jun 2007 16:18:56 +0200
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>, Jeff Dike <jdike@addtoit.com>,
       LKML <linux-kernel@vger.kernel.org>
References: <20070619184245.GA10567@c2.user-mode-linux.org> <20070619115422.de61abd5.akpm@linux-foundation.org>
In-Reply-To: <20070619115422.de61abd5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_QdTeGztoIgtpPKI"
Message-Id: <200706201618.56604.blaisorblade@yahoo.it>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_QdTeGztoIgtpPKI
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On marted=EC 19 giugno 2007, Andrew Morton wrote:
> On Tue, 19 Jun 2007 14:42:45 -0400
>
> Jeff Dike <jdike@addtoit.com> wrote:
> > Add a machanism to see how much of a kernel stack is used.  This
> > allocates zeroed stacks and sees where the lowest non-zero byte is on
> > process exit.  It keeps track of the lowest value and logs values as
> > they get lower.
>
> remind us again why the generic code is unsuitable?
>
> > +	for(p =3D stack; p < end; p++){
> > +		if(*p !=3D 0)
> > +	if(left < lowest_to_date){
>
> Are there any plans to fix UML coding style?
In Italy we say "habits are hard to die"...

In an (unanswered) thread, titled "[RFC] Auto-fixups for CodingStyle agains=
t=20
major UML violations" from 31/3/2007, also CC'ed to you, Jeff and LKML, I=20
published a script (reattached here) which integrates with quilt and kbuild=
=20
to fix all sources for these violations. It is not indent based, consequent=
ly=20
it does not do any damages that indent would do.

Plus, with just a couple of tiny changes (for substitutions implying the us=
e=20
of '^'), it can also be run on unified diffs.

The only problem is just coordinating to run it together on a source tree a=
nd=20
on the patch set applying on it. Otherwise the patchset manager would get=20
hard-to-fix rejects.

In the end: are you interested in this stuff? I'm busy right now but can wo=
rk=20
to apply these changes after this thursday (i.e. tomorrow). I'd need to get=
=20
Jeff's patchset to fix it.

Please let me know.

Bye!
=2D-=20
Inform me of my mistakes, so I can add them to my list!
Paolo Giarrusso, aka Blaisorblade
http://www.user-mode-linux.org/~blaisorblade

--Boundary-00=_QdTeGztoIgtpPKI
Content-Type: application/x-shellscript;
  name="do-src-style-fix"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="do-src-style-fix"

#!/bin/bash

# Parameters - PATHS can be set as $1.
BUILD_PARAMS='ARCH=um'
#Paths where to act
PATHS="arch/um include/asm-um"
[ -n "$1" ] && PATHS="$1"
COMPILE_TEST=0
PATCH_NAME=style-fixes-auto
[ -d "$OUT" -a -z "$KBUILD_OUTPUT" ] && KBUILD_OUTPUT=$OUT

# Customize for your source manager. {{{
new_patch() {
	#Broken when the patch already exists.
	if ! quilt new $PATCH_NAME; then
		# A patch can be applied but still not exist, if it's empty or
		# it hasn't been refreshed.
		#if [ -f patches/$PATCH_NAME ]; then

		if ! grep $PATCH_NAME .pc/applied-patches; then
			quilt push $PATCH_NAME
		else
			quilt pop $PATCH_NAME || echo "quilt pop failed!" && exit 1
		fi
	fi
}

add_to_patch() {
	#Always works.
	quilt add "$1"
}

patch_refresh() {
	quilt refresh --strip-trailing-whitespace
}
# }}}

#Functions for compile diffing {{{
compile_file() {
	export KBUILD_OUTPUT
	name=$1
	if [ "${name#.c}" != "$name" ]; then
		obj=${name#.c}.o
		make $BUILD_PARAMS $obj
		unset prefix
		[ -n "$KBUILD_OUTPUT" ] && prefix=$KBUILD_OUTPUT/
		echo ${prefix}${obj}
	fi
}

save_compiled() {
	out=`compile_file $1`
	[ -n "$out" ] && mv -f $out $OUTFILE_CC
}

check_compiled() {
	out=`compile_file $1`
	if [ -n "$out" ]; then
		if !diff $out $OUTFILE_CC; then
			echo "Serious changes with $1 compiled to $out"
			exit 1
		fi
	fi
}
# }}}

#For script debugging.
DEBUG=0

TMP=~/tmp
[ -d $TMP ] || TMP=/tmp

#START 
new_patch

OUTFILE=`mktemp $TMP/tfile.XXXXXXXXXX`

[ -n $COMPILE_TEST ] && OUTFILE_CC=`mktemp $TMP/tfilecc.XXXXXXXXXX`

[ $DEBUG = 1 ] || cond_redir_to_null='> /dev/null'
find $PATHS -name '*.[ch]'| \
while read i; do
	sed -e 's/\<return\>(\(.*\))/return \1/' \
	 -e 's/\<if\> \?(\(.*\)){/if (\1) {/'  \
	 -e 's/\<if\>(\(.*\))/if (\1)/' \
	 -e 's/\<for\> \?(\(.*\)){/for (\1) {/' \
	 -e 's/\<for\>(\(.*\))/for (\1)/' \
	 -e 's/\<while\> \?(\(.*\)){/while (\1) {/' \
	 -e 's/\<while\>(\(.*\))/while (\1)/' \
	 -e 's/^\([\t]*\) \{8\}/\1\t/' \
	 -e 's/^\([\t]*\) \{8\}/\1\t/' \
	 -e 's/^\([\t]*\) \{8\}/\1\t/' \
	 -e 's/^\([\t]*\) \{8\}/\1\t/' \
	 -e 's/^\([\t]*\) \{8\}/\1\t/' \
	 -e 's/^\([\t]*\) \{8\}/\1\t/' \
	 -e 's/^\([\t]*\) \{8\}/\1\t/' \
	 -e 's/^\([\t]*\) \{8\}/\1\t/' \
	 -e 's/^\([\t]*\) \{8\}/\1\t/' \
	 -e 's/^\([\t]*\) \{8\}/\1\t/' \
	 -e 's/^\([\t]*\) \{8\}/\1\t/' \
	 -e 's/^ \([a-z_]*:\)/\1/' \
	< $i > $OUTFILE
	# The tab substitution is repeated to act on multiple initial tabs.
	# PATCHES changes
	# The repeated line would become:
	# -e 's/^\([ +-]\)\([\t]*\) \{8\}/\1\2\t/' \
	# The last line would become:
	# -e 's/^\([ +-]\) \([a-z_]*:\)/\1\2/'

	if ! eval diff -u $i $OUTFILE $cond_redir_to_null; then
		save_compiled $i
		add_to_patch $i
		cat $OUTFILE > $i
		check_compiled $i
		[ $DEBUG = 1 ] && break
	fi
done
rm $OUTFILE
patch_refresh
# vim: set foldmethod=marker:

--Boundary-00=_QdTeGztoIgtpPKI--
