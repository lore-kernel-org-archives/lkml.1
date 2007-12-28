Return-Path: <linux-kernel-owner+w=401wt.eu-S1753977AbXL1MlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977AbXL1MlS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 07:41:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752623AbXL1MlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 07:41:07 -0500
Received: from tim.rpsys.net ([194.106.48.114]:46450 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752668AbXL1MlF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 07:41:05 -0500
Subject: Kernel bloat - is it happening and if so, where?
From: Richard Purdie <rpurdie@rpsys.net>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 28 Dec 2007 12:40:55 +0000
Message-Id: <1198845655.4663.58.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A tricky question to answer.

On ARM based Zaurus handhelds the kernel has to fit into a 1.2MB
partition. It makes sense to have as much core functionality compiled
into the kernel as possible but its becoming increasingly difficult to
fit functional kernels into the space available. The devices only have
32MB or 64MB of RAM so a small kernel runtime is also a priority.

I wanted to compare a 2.6.17 build with 2.6.23 but comparing kernels is
surprisingly difficult. scripts/bloat-o-meter tells me about the
differences in function size but lots of functions were renamed and
between .17 and .23 the results are nearly meaningless.

The information below is a summary of the quick hacks I used to find out
where the size change (bloat?) was coming from. I'm mentioning it here
since some of the results are interesting and I'm also hoping someone
with more time might be able to improve the script and/or this way of
analysing the kernel...


To look at my specific problem I hacked "bloat-by-subsys" together
(included below). It only cares about the things built into the kernel,
specifically by looking at the "built-in.o" files as I wanted to look at
the "core". It assumes the tree layout didn't change too much between
the two kernel versions (directories move a lot less frequently than
function names change) and that directories make good units for
comparison.

The output from two kernel trees for the poodle machine I happened to
have handy was:

function                                     old     new   delta
./kernel/built-in.o                       203261  326552 +123291
./drivers/built-in.o                      496936  616632 +119696
./kernel/time/built-in.o                       -   67028  +67028
./drivers/video/built-in.o                 91772  131002  +39230
./drivers/video/logo/built-in.o             4104   38002  +33898
./drivers/hid/built-in.o                       -   24970  +24970
./kernel/irq/built-in.o                        -   23668  +23668
./drivers/cpufreq/built-in.o                   -   21910  +21910
./fs/built-in.o                           436077  457252  +21175
./drivers/mmc/core/built-in.o                  -   16724  +16724
./net/built-in.o                          479570  493951  +14381
./arch/arm/mach-pxa/built-in.o             12336   24284  +11948
./drivers/mmc/built-in.o                   15712   25972  +10260
./mm/built-in.o                           143359  153248   +9889
./net/ipv4/built-in.o                     252918  261638   +8720
./drivers/base/built-in.o                  30892   39160   +8268
./drivers/char/built-in.o                 117976  125357   +7381
./net/core/built-in.o                     105436  112412   +6976
./drivers/mmc/card/built-in.o                  -    5880   +5880
./arch/arm/common/built-in.o               11076   16172   +5096
./net/wireless/built-in.o                      -    4728   +4728
./drivers/input/built-in.o                 17008   21132   +4124
./crypto/built-in.o                         7992   12008   +4016
./fs/proc/built-in.o                       34544   38512   +3968
./drivers/mmc/host/built-in.o                  -    3368   +3368
./lib/built-in.o                           32112   35424   +3312
./net/netlink/built-in.o                   18062   21070   +3008
./lib/lzo/built-in.o                           -    2880   +2880
./ipc/built-in.o                           19388   22064   +2676
./drivers/video/console/built-in.o         47773   50009   +2236
./drivers/input/touchscreen/built-in.o         0    2104   +2104
./fs/sysfs/built-in.o                      12960   14936   +1976
./drivers/pcmcia/built-in.o                41300   43244   +1944
./arch/arm/mm/built-in.o                   17584   19000   +1416
./fs/jffs2/built-in.o                      79280   80344   +1064
./net/netfilter/built-in.o                  8548    9276    +728
./net/unix/built-in.o                      16864   17489    +625
./net/ipv6/built-in.o                       3980    4596    +616
./drivers/serial/built-in.o                18356   18952    +596
./kernel/power/built-in.o                   3048    3632    +584
./fs/partitions/built-in.o                  4272    4824    +552
./drivers/ide/built-in.o                   68017   68529    +512
./drivers/ide/legacy/built-in.o             3988    4404    +416
./drivers/block/built-in.o                  8280    8696    +416
./drivers/leds/built-in.o                   4736    4984    +248
./drivers/usb/gadget/built-in.o             9232    9412    +180
./drivers/rtc/built-in.o                   10892   11064    +172
./block/built-in.o                         47218   47366    +148
./drivers/input/keyboard/built-in.o         1396    1508    +112
./net/packet/built-in.o                    11240   11308     +68
./net/ethernet/built-in.o                   1187    1247     +60
./fs/fat/built-in.o                        30750   30806     +56
./arch/arm/nwfpe/built-in.o                23697   23737     +40
./security/built-in.o                       1548    1544      -4
./drivers/mtd/maps/built-in.o                796     792      -4
./fs/devpts/built-in.o                      1556    1540     -16
./fs/vfat/built-in.o                        6592    6516     -76
./drivers/net/built-in.o                    1668    1580     -88
./drivers/video/backlight/built-in.o        3016    2900    -116
./fs/nls/built-in.o                         9656    9536    -120
./lib/zlib_deflate/built-in.o              17536   17412    -124
./drivers/mtd/chips/built-in.o              1272    1036    -236
./drivers/mtd/built-in.o                   44938   44694    -244
./fs/ramfs/built-in.o                       1560    1300    -260
./drivers/mtd/nand/built-in.o              24864   24504    -360
./fs/ext2/built-in.o                       27692   27260    -432
./drivers/i2c/busses/built-in.o             3428    2960    -468
./drivers/i2c/built-in.o                   16037   15490    -547
./net/sched/built-in.o                      4284    3656    -628
./drivers/base/power/built-in.o             3328    2220   -1108
./drivers/i2c/algos/built-in.o              4697    2786   -1911
./lib/zlib_inflate/built-in.o              11452    8920   -2532
./init/built-in.o                          19803    9412  -10391
./net/xfrm/built-in.o                      45808   35132  -10676
./arch/arm/kernel/built-in.o               45613   30028  -15585

Some information is repeated here as a high level built-in.o contains
the built-in files from the directories below it. I think this
simplistic approach provides a good overview of the status though. 

The single most shocking figure is that for ./kernel which showed a 60%
increase in size:

./kernel/built-in.o                       203261  326552 +123291
./kernel/time/built-in.o                       -   67028  +67028
./kernel/irq/built-in.o                        -   23668  +23668
./kernel/power/built-in.o                   3048    3632    +584

I've not looked into it yet but it makes me wonder what I gained for the
123kb of RAM usage and the increased kernel size... (yes, from the above
I can make some guesses)

The results also highlight other issues, I've given interpretations of
some of the changes below:

function                                     old     new   delta
./drivers/video/logo/built-in.o             4104   38002  +33898

A logo was added into the 2.6.23 defconfig, this highlights the space it
takes up...

./drivers/hid/built-in.o                       -   24970  +24970

This shouldn't be being built in, a defconfig error

./drivers/cpufreq/built-in.o                   -   21910  +21910

2.6.17 didn't have cpufreq support

./arch/arm/mach-pxa/built-in.o             12336   24284  +11948

Probably from the pxa updates to support multiple cpus and the pxa3xx
series in one kernel - it comes at a price.

./lib/lzo/built-in.o                           -    2880   +2880

LZO wasn't present in 2.6.17

./drivers/input/built-in.o                 17008   21132   +4124
./drivers/input/touchscreen/built-in.o         0    2104   +2104

I disabled the touchscreen in 2.6.17 due to build issues so this is
partly bogus. This was the only change I made to the code.

./arch/arm/nwfpe/built-in.o                23697   23737     +40

Probably the NWFPE preempt fixes.

./drivers/video/backlight/built-in.o        3016    2900    -116

Probably the backlight cleanup.

./lib/zlib_deflate/built-in.o              17536   17412    -124
./lib/zlib_inflate/built-in.o              11452    8920   -2532

The zlib update had the side effect of space savings!

./fs/ext2/built-in.o                       27692   27260    -432

I didn't expect that...

./net/xfrm/built-in.o                      45808   35132  -10676

./net increased overall in size though counteracting this quite a bit...

./init/built-in.o                          19803    9412  -10391
./arch/arm/kernel/built-in.o               45613   30028  -15585

Some good looking code size changes here at least at first glance.

So some of the changes were due to extra features, one was an accidental
defconfig misconfiguration. There were surprise space savings and some
worrying size increases.


The script itself, keep in mind this is an extremely quick hack and it
could be a ton more efficient. Certain code was left in case I wanted to
go back to looking at things at a function level too:

#!/usr/bin/python
#
# Copyright 2007 Richard Purdie <rpurdie@rpsys.net>
# Copyright 2004 Matt Mackall <mpm@selenic.com>
#
# Based on python Bloat-O-Meter (c) 2004 by Matt Mackall
#
# This software may be used and distributed according to the terms
# of the GNU General Public License, incorporated herein by reference.

import sys, os, re

if len(sys.argv) != 3:
    sys.stderr.write("usage: %s tree1 tree2\n" % sys.argv[0])
    sys.exit(-1)

def getsizes(file):
    sym = {}
    total = 0
    for l in os.popen("nm --size-sort " + file).readlines():
        size, type, name = l[:-1].split()
        if type in "tTdDbB":
            if "." in name: name = "static." + name.split(".")[0]
            sym[name] = sym.get(name, 0) + int(size, 16)
            total = total + sym[name]
    return sym, total

startdir = os.getcwd()

old = {}
total_old = {}
os.chdir(sys.argv[1])
for root, dirs, files in os.walk("."):
    for name in files:
        if name == "built-in.o":
            fn = os.path.join(root, name)
            old[fn], total_old[fn] = getsizes(fn)
os.chdir(startdir)

new = {}
total_new = {}
os.chdir(sys.argv[2])
for root, dirs, files in os.walk("."):
    for name in files:
        if name == "built-in.o":
            fn = os.path.join(root, name)
            new[fn], total_new[fn] = getsizes(fn)
os.chdir(startdir)

grow, shrink, add, remove, up, down = 0, 0, 0, 0, 0, 0
delta, common = [], {}

for a in total_old:
    if a in total_new:
        common[a] = 1

for name in total_old:
    if name not in common:
        remove += 1
        down += total_old[name]
        delta.append((-total_old[name], name))

for name in total_new:
    if name not in common:
        add += 1
        up += total_new[name]
        delta.append((total_new[name], name))

for name in common:
        d = total_new.get(name, 0) - total_old.get(name, 0)
        if d>0: grow, up = grow+1, up+d
        if d<0: shrink, down = shrink+1, down-d
        delta.append((d, name))

delta.sort()
delta.reverse()

print "%-40s %7s %7s %+7s" % ("function", "old", "new", "delta")
for d, n in delta:
    if d: print "%-40s %7s %7s %+7d" % (n, total_old.get(n,"-"), total_new.get(n,"-"), d)


