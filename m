Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1757932AbYLQGR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757932AbYLQGR1 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 01:17:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751136AbYLQGRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 01:17:15 -0500
Received: from mail.gmx.net ([213.165.64.20]:42043 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750906AbYLQGRO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 01:17:14 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19LYwB1skFLL1sgUBMeI6GwqzlkxJifNbilr/IZ2e
	/5zPZGyatNHh3b
Subject: Re: [Bug #12208] uml is very slow on 2.6.28 host
From: Mike Galbraith <efault@gmx.de>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: rjw@sisk.pl, a.p.zijlstra@chello.nl, mingo@elte.hu,
        linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org
In-Reply-To: <E1LCbpI-0002MN-7R@pomaz-ex.szeredi.hu>
References: <u7kfEgp36eE.A.qpG.Y4_QJB@chimera>
	 <T1gm2CtAHBF.A.u6G.g4_QJB@chimera>  <E1LCO85-0000rR-Br@pomaz-ex.szeredi.hu>
	 <1229397927.5296.48.camel@marge.simson.net>
	 <E1LCX8h-0001sh-Uo@pomaz-ex.szeredi.hu>
	 <1229437180.5379.76.camel@marge.simson.net>
	 <E1LCbpI-0002MN-7R@pomaz-ex.szeredi.hu>
Content-Type: multipart/mixed; boundary="=-wHKTC3VbzE/ipZBAABSR"
Date: Wed, 17 Dec 2008 07:17:08 +0100
Message-Id: <1229494628.5280.24.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-wHKTC3VbzE/ipZBAABSR
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Tue, 2008-12-16 at 16:27 +0100, Miklos Szeredi wrote:

> Is there a way to trace what is happening in the scheduler?

Sure.  Ingo has a script for gathering info (attached), if you run it,
please gzip up the output and send me a copy offline to eyeball.

There's also ftrace, but I've not tried that yet, so can't offer any
advice, I use primitive but effective time_after() + printk() with klogd
wakeup disabled (deadlock).

	-Mike

--=-wHKTC3VbzE/ipZBAABSR
Content-Disposition: attachment; filename=cfs-debug-info.sh
Content-Type: application/x-shellscript; name=cfs-debug-info.sh
Content-Transfer-Encoding: 7bit


[ -e /proc/sched_debug ]    || echo "not a CFS kernel? continuing anyway."
[ "`id | grep root`" = "" ] && { echo "please run this as root!"; exit -1; }

FILE=cfs-debug-info-`date +%Y.%m.%d-%H.%M.%S`

echo "sched info dump (of tasks, modules, hw, dmesg, config, fs):"

echo "-- /proc/sched_debug: --"      >  $FILE
cat /proc/sched_debug                >> $FILE 2>/dev/null
echo "-- /proc/*/task/*/sched: --"   >> $FILE
cat /proc/*/task/*/sched             >> $FILE 2>/dev/null
echo "-- /proc/sys/kernel/sched: --" >> $FILE
for N in /proc/sys/kernel/sched*; do
  echo $N:                           >> $FILE 2>/dev/null
  cat $N                             >> $FILE 2>/dev/null
done
echo "-- modules: --"                >> $FILE
/sbin/lsmod                          >> $FILE 2>/dev/null
echo "-- hw: --"                     >> $FILE
/sbin/lspci -vvv                     >> $FILE 2>/dev/null
echo "-- interrupts: --"             >> $FILE
cat /proc/interrupts                 >> $FILE 2>/dev/null
echo "-- cpuinfo: --"                >> $FILE
cat /proc/cpuinfo                    >> $FILE 2>/dev/null
echo "-- cpufreq: --"                >> $FILE
cat /sys/devices/system/cpu/cpu*/cpufreq/* \
                                     >> $FILE 2>/dev/null
echo "-- meminfo: --"                >> $FILE
cat /proc/meminfo                    >> $FILE 2>/dev/null
echo "-- buddyinfo: --"              >> $FILE
cat /proc/buddyinfo                  >> $FILE 2>/dev/null
echo "-- vmstat: --"                 >> $FILE
cat /proc/vmstat                     >> $FILE 2>/dev/null
echo "-- zoneinfo: --"               >> $FILE
cat /proc/zoneinfo                   >> $FILE 2>/dev/null
echo "-- pagetypeinfo: --"           >> $FILE
cat /proc/pagetypeinfo               >> $FILE 2>/dev/null
echo "-- slabinfo: --"               >> $FILE
cat /proc/slabinfo                   >> $FILE 2>/dev/null
echo "-- dmesg: --"                  >> $FILE
dmesg -s 10000000                    >> $FILE 2>/dev/null
echo "-- /proc/timer_list: --"       >> $FILE
cat /proc/timer_list                 >> $FILE 2>/dev/null
echo "-- /proc/timer_info: --"       >> $FILE
cat /proc/timer_info                 >> $FILE 2>/dev/null
echo "-- /proc/config.gz: --"        >> $FILE
zcat /proc/config.gz                 >> $FILE 2>/dev/null
echo "-- current kernel config: --"  >> $FILE
KREL=`uname -r | sed 's/smp$//g'`
( cat "`rpm -ql kernel-$KREL 2>/dev/null | grep /boot/config`"
  cat "`rpm -ql kernel-smp-$KREL 2>/dev/null | grep /boot/config`"
  cat "`dpkg -L linux-image-$KREL 2>/dev/null | grep /boot/config`"
  cat /boot/config-$KREL 2>/dev/null
) >> $FILE 2>/dev/null
echo "-- filesystems: --"            >> $FILE
mount                                >> $FILE 2>/dev/null
echo "-- uptime: --"                 >> $FILE
uptime                               >> $FILE 2>/dev/null
echo "-- uname: --"                  >> $FILE
uname -a                             >> $FILE 2>/dev/null
echo "-- /sys/devices/system: --"    >> $FILE
for N in `find /sys/devices/system/ -type f`; do
  echo $N:			     >> $FILE
  cat $N			     >> $FILE 2>/dev/null
done
echo "gathering statistics for 15 seconds ..."
echo "-- top: --"                    >> $FILE
top -c -b -d 1 -n 5                  >> $FILE 2>/dev/null
echo "-- vmstat: --"                 >> $FILE
vmstat -n 1 5                        >> $FILE 2>/dev/null
for ((i=0; i<5; i++)); do
 echo "-- sched_debug #$i: --"       >> $FILE
 date                                >> $FILE
 cat /proc/sched_debug               >> $FILE 2>/dev/null
 sleep 1
done

ls -l $FILE


--=-wHKTC3VbzE/ipZBAABSR--

