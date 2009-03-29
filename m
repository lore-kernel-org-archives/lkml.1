Return-Path: <linux-kernel-owner+w=401wt.eu-S1751293AbZC2ECK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751293AbZC2ECK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 00:02:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750740AbZC2EBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 00:01:55 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:51341 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbZC2EBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 00:01:55 -0400
Date: Sun, 29 Mar 2009 06:01:48 +0200
From: Daniel Mack <daniel@caiaq.de>
To: kernel list <linux-kernel@vger.kernel.org>
Subject: include-police.sh
Message-ID: <20090329040148.GA11678@buzzloop.caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I hacked a small and dumb shell script awhile ago that can help finding
superfluous include files. Even though it's far from perfect (see the 
inline comments), its output had helped occasionally, so I wanted to
share this, also in relationship to the 'reverse Xmas tree' thread.

Comments welcome :)

Daniel


#!/bin/sh
#
# Find possibly unneeded include files in C/C++ files
# Daniel Mack <daniel@caiaq.de>, GPLv2
#
# The script searches for includes in the given file and removes them, one
# after the other. After each cycle, 'make' is called to build the object
# file. Includes found safe to omit (i.e., the removal did not break the
# built) are echoed, and the file is reset to its original state
# again.
#
# At the end of the script, the file will be restored to what it was in
# the beginning.
#
# Limitations/bugs:
#  * The output is only to be taken as _hint_ for developers
#  * The script is not aware of conditional includes
#  * Include files that do forward declarations of locally implemented
#    symbols are erroneously reported superfluous
#  * Depends on 'make' as build tool and the object file is expected
#    to be at the same location as the source file
#  * Doesn't report anything when the built fails anyway (for other reasons)
#

file=$1

if [ -z "$file" ]; then echo "Usage: $0 <file> [build params]"; exit 1; fi
if [ ! -f "$file" ]; then echo "$0: unable to open file $file"; exit 2; fi

tmp=/tmp/$(basename $file)-$$
orig=/tmp/$(basename $file).orig-$$
obj=${file%%.c}.o
shift

cp $file $orig

for include in $(grep ^#include $file | cut -f2 -d' '); do
	echo checking $include ...
	cp $orig $tmp
	grep -v '^#include '$include $tmp > $file
	make $* $obj >/dev/null 2>&1
	[ $? -eq 0 ] && echo --- $include can be omitted
done

cp $orig $file
rm -f $tmp $orig

