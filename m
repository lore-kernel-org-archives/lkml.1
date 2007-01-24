Return-Path: <linux-kernel-owner+w=401wt.eu-S1752073AbXAXUzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073AbXAXUzi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 15:55:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752070AbXAXUzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 15:55:38 -0500
Received: from raven.upol.cz ([158.194.120.4]:38612 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752067AbXAXUzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 15:55:37 -0500
To: Rob Landley <rob@landley.net>, Andrew Morton <akpm@osdl.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [rft] (g)awk substitution (Re: [PATCH] sed s/gawk/awk/scripts/gen_init_ramfs.sh)
In-Reply-To: <200701241230.40996.rob@landley.net>
References: <200701151624.18033.rob@landley.net> <20070115221146.GA12698@uranus.ravnborg.org> <20070123164944.db8acbad.akpm@osdl.org> <200701241230.40996.rob@landley.net>
Organization: Palacky University in Olomouc, experimental physics department.
Date: Wed, 24 Jan 2007 21:03:55 +0000
Message-Id: <E1H9pHf-0002Iu-4D@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tuesday 23 January 2007 7:49 pm, Andrew Morton wrote:
>> If the kernel is being compiled on a non-Linux system (eg: legacy Unix)
>> then it is, I guess, possible for `awk' and `gawk' to offer different
>> features.  If the kernel's use of gawk uses GNU extensions then this patch
>> might break things on such a system.
>> 
>> I guess we'll find out...

OK, this is what (g) awk is needed for:

,-*- diff: shell script -*-
|                        local maj=$(LC_ALL=C ls -l "${location}" | \
|			-                                       gawk
|'{sub(/,/, "", $5); print $5}')
|+                                       awk '{sub(/,/, "", $5); print
|$5}')
|                        local min=$(LC_ALL=C ls -l "${location}" | \
|			-                                       gawk
|'{print $6}')
|+                                       awk '{print $6}')
|
|                        if [ -b "${location}" ]; then
|			                                dev_type="b"
|							@@ -134,7
|+134,7 @@
|                        ;;
|			                "slink")
|					                        local
|target=$(LC_ALL=C ls -l "${location}" | \
|-                                       gawk '{print $11}')
|+                                       awk '{print $11}')
`-*-

Let me propose you to test this as solution, that need no awk, only shell:
-*- sh -*-
#/bin/sh
# usage: $0 node symlink

nod=$1
sym=$2

pos_param() {
  set -- $@
  shift $1
  echo $1
}

location=${nod}
maj=`pos_param 5 $(LC_ALL=C ls -l "${location}")`
maj=${maj%,}
min=`pos_param 6 $(LC_ALL=C ls -l "${location}")`
echo "maj min:" $maj $min

location=${sym}
target=`pos_param 11 $(LC_ALL=C ls -l "${location}")`
echo "symlink target:" ${target}

-*- Result of testcase -*-
olecom@flower:/tmp$ ./awkless.sh /dev/null null
maj min: 1 3
symlink target: /dev/null
olecom@flower:/tmp$
olecom@flower:/tmp$
-*-

p.s. who is going to make alternative to GNU make ? ;D
---
-o--=O`C  info emacs : not found  /. .\ ( is there any reason to live? )
 #oo'L O  info make  : not found      o (R.I.P. Debian Operating System)
<___=E M  man gcc    : not found    .-- (          TNX, RMS.           )
