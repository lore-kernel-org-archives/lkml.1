Return-Path: <linux-kernel-owner+w=401wt.eu-S1758045AbXFZRyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758045AbXFZRyX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 13:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756771AbXFZRyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 13:54:15 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:54595 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756680AbXFZRyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 13:54:14 -0400
Date: Tue, 26 Jun 2007 10:56:02 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Julio M. Merino Vidal" <jmerino@ac.upc.edu>
Cc: Arne Georg Gleditsch <argggh@dolphinics.no>,
       Oleg Verych <olecom@flower.upol.cz>, Andi Kleen <ak@suse.de>,
       lkml <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>
Subject: Re: NAK (bashizm in the /bin/sh script): [PATCH v3]
 doc/oops-tracing: add Code: decode info
Message-Id: <20070626105602.8bae494b.randy.dunlap@oracle.com>
In-Reply-To: <B2A2FE52-84FF-4F03-8B19-38AC894D857A@ac.upc.edu>
References: <20070621225108.bb69a93d.randy.dunlap@oracle.com>
	<200706221626.39969.ak@suse.de>
	<20070622094429.0910c7cb.randy.dunlap@oracle.com>
	<200706221923.02736.ak@suse.de>
	<20070622132810.3c758590.randy.dunlap@oracle.com>
	<E1I2159-0005AH-DS@flower>
	<20070623104303.a186c5a8.randy.dunlap@oracle.com>
	<87645bhtvw.fsf@pelargir.dolphinics.no>
	<20070626101958.1cf6c6ae.randy.dunlap@oracle.com>
	<B2A2FE52-84FF-4F03-8B19-38AC894D857A@ac.upc.edu>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jun 2007 19:25:00 +0200 Julio M. Merino Vidal wrote:

> On 26/06/2007, at 19:19, Randy Dunlap wrote:
> >
> > Are these 2 line changes all that is needed?
> >
> > I sort of expected expressions like $((a + 2)) to need change also...
> > maybe not for dash, but for sh?
> 
> The correct expression could be $((${a} + 2)).  Tested under NetBSD's  
> sh, which is very POSIX-compliant.

Thanks.  Does anyone see other changes that are needed?


The diff currently looks like:

--- decodecode.~3~	2007-06-22 13:25:39.000000000 -0700
+++ decodecode	2007-06-26 10:40:28.000000000 -0700
@@ -28,7 +28,7 @@
 fi
 
 if [ $marker -ne 0 ]; then
-	beforemark=${code:0:$((marker - 1))}
+	beforemark=`echo "$code" | cut -c-$((${marker} - 1))`
 	echo -n "	.byte 0x" > $T.s
 	echo $beforemark | sed -e 's/ /,0x/g' >> $T.s
 	as -o $T.o $T.s
@@ -36,7 +36,7 @@
 	rm $T.o $T.s
 
 # and fix code at-and-after marker
-	code=${code:$marker}
+	code=`echo "$code" | cut -c$((${marker} + 1))-`
 fi
 
 code=`echo $code | sed -e 's/ [<(]/ /;s/[>)] / /;s/ /,0x/g'`




and the complete script is:

#!/bin/sh
# Disassemble the Code: line in Linux oopses
# usage: decodecode < oops.file

T=`mktemp`
code=

while read i ; do

case "$i" in
*Code:*)
	code=$i
	;;
esac

done

if [ -z "$code" ]; then
	exit
fi

echo $code
code=`echo $code | sed -e 's/.*Code: //'`

marker=`expr index "$code" "\<"`
if [ $marker -eq 0 ]; then
	marker=`expr index "$code" "\("`
fi

if [ $marker -ne 0 ]; then
	beforemark=`echo "$code" | cut -c-$((${marker} - 1))`
	echo -n "	.byte 0x" > $T.s
	echo $beforemark | sed -e 's/ /,0x/g' >> $T.s
	as -o $T.o $T.s
	objdump -S $T.o
	rm $T.o $T.s

# and fix code at-and-after marker
	code=`echo "$code" | cut -c$((${marker} + 1))-`
fi

code=`echo $code | sed -e 's/ [<(]/ /;s/[>)] / /;s/ /,0x/g'`
echo -n "	.byte 0x" > $T.s
echo $code >> $T.s
as -o $T.o $T.s
objdump -S $T.o
rm $T.o $T.s
