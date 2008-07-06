Return-Path: <linux-kernel-owner+w=401wt.eu-S1760301AbYGFVeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760301AbYGFVeU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 17:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758591AbYGFVeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 17:34:04 -0400
Received: from zakalwe.fi ([80.83.5.154]:46237 "EHLO zakalwe.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757627AbYGFVeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 17:34:03 -0400
Date: Mon, 7 Jul 2008 00:33:59 +0300
From: Heikki Orsila <shdl@zakalwe.fi>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: On the number of Kconfig options
Message-ID: <20080706213359.GC4379@zakalwe.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote a small script that measures the number of kernel config options
as a function of time.

The following table contains 6 values on each row:

"date" is the time at which the source code tree was examined.
Torvalds's Git repository was used to set source code tree to a specific
time.

"A" is the number of source code lines as measured with sloccount (1)

"B" is the number of uncommented config options in .config for
"make defconfig" on x86-64.
"D" is the same value for "make allyesconfig".

"C" and "E" are the number of source code lines divided by the number of
config options for defconfig and allyesconfig, respectively.

The number of uncommented config options is measured with:
       cat .config |grep ^CONFIG_ |wc -l

date      | A     | B | C   | D  | E
--------------------------------------
2006-01-01 4697644 328 14322 2241 2096
2006-02-01 4809821 347 13861 2308 2083
2006-03-01 4817961 345 13965 2305 2090
2006-04-01 4876137 342 14257 2354 2071
2006-05-01 4880775 347 14065 2339 2086
2006-06-01 4885932 348 14040 2350 2079
2006-07-01 4938046 367 13455 2447 2018
2006-08-01 4959346 370 13403 2464 2012
2006-09-01 4966357 370 13422 2466 2013
2006-10-01 5084515 384 13240 2579 1971
2006-11-01 5109889 386 13238 2630 1942
2006-12-01 5112145 387 13209 2632 1942
2007-01-01 5189609 388 13375 2670 1943
2007-02-01 5196429 388 13392 2672 1944
2007-03-01 5284389 402 13145 2731 1934
2007-04-01 5284159 399 13243 2730 1935
2007-05-01 5321277 398 13370 2762 1926
2007-06-01 5442483 417 13051 2840 1916
2007-07-01 5445913 417 13059 2841 1916
2007-08-01 5491984 428 12831 2912 1885
2007-09-01 5471622 428 12784 2914 1877
2007-10-01 5497002 427 12873 2914 1886
2007-11-01 5679390 450 12620 3095 1835
2007-12-01 5683137 453 12545 3101 1832
2008-01-01 5682221 454 12515 3103 1831
2008-02-01 5799792 473 12261 3173 1827
2008-03-01 5907497 490 12056 3233 1827
2008-04-01 5911747 493 11991 3238 1825
2008-05-01 5990080 510 11745 3333 1797
2008-06-01 6005771 510 11776 3343 1796
2008-07-01 6015311 511 11771 3350 1795

For example, at 2006-01-01, there was:
 * 4697644 source code lines
 * 328 uncommented defconfig options
 * 2241 uncommented allyesconfig options
 * 14322 lines of code for each defconfig option
 * 2096 lines of code for each allyesconfig option

Change from 2006-01-01 to 2008-07-01 (2,5 years):

Value | Increase (%)
--------------------
A     |  28
B     |  56
C     | -18
D     |  49
E     | -14

Conclusions? No. Maybe the data is of interest to someone..


I used the following script to compute these numbers:

#!/bin/sh

git checkout -f master >/dev/null 2>/dev/null

# Advance time in reverse chronological order to optimize checkouts
for year in 2008 2007 2006 ; do
    months=$(seq -w 12 -1 1)
    if test "$year" = "2008" ; then
	months="07 06 05 04 03 02 01"
    fi

    for m in $months ; do
        d="$year-$m-01"

        h=$(git log --until="$d" --pretty="format:%H" |head -n1)
        git checkout -f "$h" >/dev/null 2>/dev/null
        if test "$?" != "0" ; then
            echo "checkout error $d"
            continue
        fi
        git clean -f -q
        make defconfig >/dev/null 2>/dev/null
        if test "$?" != "0" ; then
            echo "defconfig error $d"
            continue
        fi
        defconf=$(grep ^CONFIG_ < .config |wc -l)

        make allyesconfig >/dev/null 2>/dev/null
        if test "$?" != "0" ; then
            echo "allyesconfig error $d"
            continue
        fi
        allconf=$(grep ^CONFIG_ < .config |wc -l)

        lines=$(sloccount . 2>/dev/null |grep '^Total Physical' |cut -d= -f2 |tr -d ,)

        defratio=$((lines / defconf))
        allratio=$((lines / allconf))
        echo "$d $lines $defconf $defratio $allconf $allratio"
    done
done

-- 
Heikki Orsila
heikki.orsila@iki.fi
http://www.iki.fi/shd
