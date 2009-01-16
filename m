Return-Path: <linux-kernel-owner+w=401wt.eu-S934776AbZAPOIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934776AbZAPOIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 09:08:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755398AbZAPOII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 09:08:08 -0500
Received: from ernst.netinsight.se ([194.16.221.21]:19560 "HELO
	ernst.netinsight.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753020AbZAPOIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 09:08:05 -0500
X-Greylist: delayed 603 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Jan 2009 09:08:04 EST
From: seved@netinsight.net
To: linux-kernel@vger.kernel.org
Cc: seved@netinsight.net
Subject: next command started before previously called script is finished
Message-Id: <E1LNpCq-0002UU-4g@localhost>
Date: Fri, 16 Jan 2009 14:57:52 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Summary: next command started before previously called script is finished

bashbug:
--------
Configuration Information [Automatically generated, do not change]:
Machine: x86_64
OS: linux-gnu
Compiler: gcc
Compilation CFLAGS:  -DPROGRAM='bash' -DCONF_HOSTTYPE='x86_64' -DCONF_OSTYPE='linux-gnu' -DCONF_MACHTYPE='x86_64-pc-linux-gnu' -DCONF_VENDOR='pc' -DLOCALEDIR='/usr/share/locale' -DPACKAGE='bash' -DSHELL -DHAVE_CONFIG_H   -I.  -I../bash -I../bash/include -I../bash/lib   -g -O2
uname output: Linux jessie 2.6.18-5-amd64 #1 SMP Sat Dec 22 20:43:59 UTC 2007 x86_64 GNU/Linux
Machine Type: x86_64-pc-linux-gnu

Bash Version: 3.1
Patch Level: 17
Release Status: release

ver_linux:
----------

If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux jessie 2.6.24-etchnhalf.1-amd64 #1 SMP Tue Oct 14 03:11:45 UTC 2008 x86_64 GNU/Linux

Gnu C                  4.1.2
Gnu make               3.81
binutils               2.17
util-linux             2.12r
mount                  2.12r
module-init-tools      3.3-pre2
e2fsprogs              1.40-WIP
Linux C Library        2.3.6
Dynamic linker (ldd)   2.3.6
Procps                 3.2.7
Net-tools              1.60
Console-tools          0.2.3
Sh-utils               5.97
udev                   105
Modules Loaded         nfsd auth_rpcgss exportfs ppdev parport_pc lp parport autofs4 ac battery nfs lockd nfs_acl sunrpc ipv6 dm_snapshot dm_mirror dm_mod loop iTCO_wdt i2c_i801 i2c_core sg button sky2 pcspkr sr_mod evdev cdrom ext3 jbd mbcache raid1 md_mod ide_generic sd_mod generic piix ide_core ata_generic ahci libata scsi_mod ehci_hcd uhci_hcd thermal processor fan


Description:

This error is very hard to reproduce. It happens in the innermost loop 
in nightly jobs. Four jobs run in parallel and three of them will pass this 
point around 800 times each night, the fourth job only about 100 times. 
The error happens about once every second week, i.e. about once out of 
50000 times. The data supplied below was collected two months ago but 
similar reports have been generated on Nov 17th, Dec 1st, Dec 17th, Jan 2nd 
and Jan 15th. 

The main script contains two nested for loops and each time a function do_build 
is called. do_build creates a directory /tmp/build.nnnn and 'cd' into it. 
A separate script is called to setup some needed files including a Makefile 
and then 'make info' is performed. 

Normally this works fine but in rare cases when do_build continues the files 
are not yet created. Either the setup script has not finished (error in the 
kernel or in bash?) or the directory inode is not yet updated (error in 
the kernel?). Of course the 'make info' fails when there is no Makefile! 
It has taken some time to understand what happens but now some data are 
collected and sent to me when 'make info' fails. 
Earlier the second 'make' also failed but during the data collection job 
the files appear and the second 'make' is now successful. 

The build machine has 4 CPUs and 4GB RAM, see info at the bottom. 

##########################################################################
# function do_build ()

function do_build ()
{
# called with ARG1 = modulename ARG2 = configuration file ARG3 = logname
	cd $SOURCE_AREA
	test -d /tmp/build.$$ && mv /tmp/build.$$ /tmp/build.$$.old
	rm -rf /tmp/build.$$.old
	mkdir /tmp/build.$$
	cd /tmp/build.$$
	echo -n "Building $1 for  $2  in `pwd` on "
	date
	nsetup=$SOURCE_AREA/mksupp/nsetup.sh
	ln -s $SOURCE_AREA/$1 .
	SOURCE_AREA=. $nsetup -q $2
	make info   > $3 2>&1
	if [ $? -ne 0 ]; then 
	    lsres=`ls -ld ./* /tmp/b* 2>&1`
	    wdnow=`pwd 2>&1`
	    pstree=`ps fx`
	    mail -s 'make info failed' seved@netinsight.se <<EOF
	    Module:		$1
	    Config file:	$2
	    Branch:		$ver
	    Build area:		/tmp/build.$$
	    pwd:  $wdnow
	    pstree:  $pstree
	    ls -ld ./* /tmp/b* :
$lsres
EOF
	fi
	## more job including 'make all'
}
########################################################################


Resulting mail. N.B. 'ls' reports only one file, the newly created symlink,
and the 'ps fx' result (pstree:) shows that the main script build_node.sh, 
pid 23678, has 2 (TWO!) children: pid 23986 running nsetup and pid 24001 
running 'ps fx' and 24001 has thus performed 'make info' which failed.  

To: seved@netinsight.se
Subject: make info failed
Message-Id: <E1KzNUz-0006FX-N0@localhost>
From: iovbuild@netinsight.se
Date: Mon, 10 Nov 2008 04:31:33 +0100

	    Module:		ark-gpio
	    Config file:	/lhome/iovbuild/source_i386/head/sw/configs/nimbra680_debug.config
	    Branch:		head
	    Build area:		/tmp/build.23678
	    pwd:  /tmp/build.23678
	    pstree:    PID TTY      STAT   TIME COMMAND
29554 ?        Ss     0:00 /bin/bash -c /home/iovbuild/tools/nightly/build --arch arm -x testing iris head dev_ethernetff > /lhome/iovbuild/test/arm.log 2>&1 
29562 ?        S      0:00  \_ /bin/bash /home/iovbuild/tools/nightly/build --arch arm -x testing iris head dev_ethernetff
 2751 ?        S      0:00      \_ /bin/sh /home/iovbuild/tools/nightly/build_node.sh -x --branches head --increment nimbra340
 3265 ?        R      0:17          \_ cvs -qf -z 3 get -P sw/adt sw/alarm sw/base-files sw/base-files-nimbra300 sw/busybox sw/ccm sw/chm sw/crc sw/dcc sw/dcp sw/ddns sw/difinfo sw/dispatcher sw/dle sw/dlsp sw/dlsp_oam sw/dpeek sw/dscp-cmd sw/dsync sw/dsyp sw/dtm-if sw/dtm_addr sw/dtm_route sw/dtmd sw/dxl sw/dxl-if sw/eqm sw/eth-if sw/ethconf sw/ethtool sw/ets sw/event sw/flow sw/glibc sw/gpio sw/inetutils sw/inventory sw/ipconf sw/iptables sw/ism-bus sw/ism-dsync sw/ism-dxl sw/ism-eth sw/ism-gpio sw/ism-hal-iad sw/ism-hal-if sw/ism-mau sw/ism-ncb sw/ism-switch sw/ism-unknown sw/its sw/kernel sw/lurix sw/mibs sw/misc sw/module-init-tools sw/mtd-utils sw/nano sw/nb-syslog sw/nc-status sw/ncall sw/ncurses sw/netilib sw/netkit sw/ntp sw/oam sw/ooc sw/pest sw/plog-utils sw/pmm sw/protocol-mgr sw/rcmd sw/registry sw/rm sw/rst sw/sarq sw/slot sw/slot0-channel sw/snmp sw/snmp-if sw/sqc sw/supd sw/swap sw/sysklogd sw/sysvars sw/tim sw/tim-if sw/tnrm sw/ttf sw/twofish sw/tz sw/udev sw/web sw/zlib sw/nimbra340-dtm-base sw/nimbra340-os-base sw/nodemgmt sw/test-tools sw/configs
23664 ?        Ss     0:00 /bin/bash -c /home/iovbuild/tools/nightly/build --arch i386 -x testing iris head dev_ethernetff > /lhome/iovbuild/test/i386.log 2>&1 
23666 ?        S      0:00  \_ /bin/bash /home/iovbuild/tools/nightly/build --arch i386 -x testing iris head dev_ethernetff
23678 ?        S      0:06      \_ /bin/sh /home/iovbuild/tools/nightly/build_node.sh -x --branches testing iris head dev_ethernetff nimbra680
23986 ?        R      0:00          \_ /bin/bash /lhome/iovbuild/source_i386/head/sw/mksupp/nsetup.sh -q /lhome/iovbuild/source_i386/head/sw/configs/nimbra680_debug.config
24001 ?        R      0:00          \_ ps fx
	    ls -ld ./* /tmp/b* :
lrwxrwxrwx 1 iovbuild iovbuild  44 2008-11-10 04:31 ./ark-gpio -> /lhome/iovbuild/source_i386/head/sw/ark-gpio
drwxr-xr-x 6 labbon   users    120 2008-10-21 12:42 /tmp/b_tst
drwxr-xr-x 4 seved    users    260 2008-11-07 15:04 /tmp/build.11287
drwxr-xr-x 2 seved    users    120 2008-11-07 15:00 /tmp/build.12360
drwxrwxr-x 7 iovbuild iovbuild 300 2008-10-31 01:33 /tmp/build.13412
drwxrwxr-x 7 iovbuild iovbuild 300 2008-10-31 01:14 /tmp/build.14263
drwxrwxr-x 7 iovbuild iovbuild 300 2008-10-31 01:24 /tmp/build.1488
drwxr-xr-x 4 seved    users    260 2008-11-07 15:08 /tmp/build.15704
drwxrwxr-x 7 iovbuild iovbuild 300 2008-10-31 01:27 /tmp/build.17242
drwxrwxr-x 7 seved    users    280 2008-11-01 14:43 /tmp/build.1746
drwxrwxr-x 7 seved    users    300 2008-10-31 11:42 /tmp/build.18657
drwxrwxr-x 7 iovbuild iovbuild 300 2008-10-31 01:22 /tmp/build.2178
drwxrwxr-x 2 iovbuild iovbuild  60 2008-11-10 04:31 /tmp/build.23678
drwxr-xr-x 4 seved    users    260 2008-11-07 15:05 /tmp/build.23830
drwxrwxr-x 7 iovbuild iovbuild 300 2008-10-31 01:19 /tmp/build.24058
drwxr-xr-x 2 seved    users    120 2008-11-07 15:02 /tmp/build.27328
drwxrwxr-x 7 iovbuild iovbuild 300 2008-10-31 01:30 /tmp/build.29646
drwxrwxr-x 7 iovbuild iovbuild 300 2008-10-31 01:32 /tmp/build.7778
drwxr-xr-x 4 seved    users    260 2008-11-07 15:08 /tmp/build.9048

#########################################################################################
# cpuinfo and meminfo 

jessie:~> cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz
stepping        : 11
cpu MHz         : 2400.092
cache size      : 4096 KB
physical id     : 0
siblings        : 4
core id         : 0
cpu cores       : 4
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx lm constant_tsc pni monitor ds_cpl vmx est tm2 cx16 xtpr lahf_lm
bogomips        : 4804.35
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz
stepping        : 11
cpu MHz         : 2400.092
cache size      : 4096 KB
physical id     : 0
siblings        : 4
core id         : 1
cpu cores       : 4
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx lm constant_tsc pni monitor ds_cpl vmx est tm2 cx16 xtpr lahf_lm
bogomips        : 4800.18
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor       : 2
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz
stepping        : 11
cpu MHz         : 2400.092
cache size      : 4096 KB
physical id     : 0
siblings        : 4
core id         : 2
cpu cores       : 4
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx lm constant_tsc pni monitor ds_cpl vmx est tm2 cx16 xtpr lahf_lm
bogomips        : 4800.19
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor       : 3
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz
stepping        : 11
cpu MHz         : 2400.092
cache size      : 4096 KB
physical id     : 0
siblings        : 4
core id         : 3
cpu cores       : 4
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx lm constant_tsc pni monitor ds_cpl vmx est tm2 cx16 xtpr lahf_lm
bogomips        : 4800.45
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

jessie:~> cat /proc/meminfo
MemTotal:      8184084 kB
MemFree:         80584 kB
Buffers:       1954152 kB
Cached:         817544 kB
SwapCached:          0 kB
Active:        1278720 kB
Inactive:      1564872 kB
HighTotal:           0 kB
HighFree:            0 kB
LowTotal:      8184084 kB
LowFree:         80584 kB
SwapTotal:     9767512 kB
SwapFree:      6234136 kB
Dirty:             136 kB
Writeback:           0 kB
AnonPages:       72264 kB
Mapped:          20320 kB
Slab:          5190856 kB
PageTables:       5592 kB
NFS_Unstable:        0 kB
Bounce:              0 kB
CommitLimit:  13859552 kB
Committed_AS:  3837324 kB
VmallocTotal: 34359738367 kB
VmallocUsed:      4976 kB
VmallocChunk: 34359733379 kB
jessie:~>
