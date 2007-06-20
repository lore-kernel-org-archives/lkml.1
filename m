Return-Path: <linux-kernel-owner+w=401wt.eu-S1761731AbXFTDiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761731AbXFTDiS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 23:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758862AbXFTDiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 23:38:08 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:38849 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758355AbXFTDiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 23:38:05 -0400
From: Vernon Mauery <vernux@us.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [-RT] multiple streams have degraded performance
Date: Tue, 19 Jun 2007 20:38:00 -0700
User-Agent: KMail/1.9.6
Cc: Ingo Molnar <mingo@redhat.com>, Jeff Garzik <jeff@garzik.org>,
       Peter Zijlstra <peterz@infradead.org>
References: <200706182212.22633.vernux@us.ibm.com>
In-Reply-To: <200706182212.22633.vernux@us.ibm.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_ZEKeG8ZOmM2SS2u"
Message-Id: <200706192038.01054.vernux@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_ZEKeG8ZOmM2SS2u
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Monday 18 June 2007 10:12:21 pm Vernon Mauery wrote:
> In looking at the performance characteristics of my network I found that
> 2.6.21.5-rt15 suffers from degraded thoughput with multiple threads.  The
> test that I did this with is simply invoking 1, 2, 4, and 8 instances of
> netperf at a time and measuring the total throughput.  I have two 4-way
> machines connected with 10GbE cards.  I tested several kernels (some older
> and some newer) and found that the only thing in common was that with -RT
> kernels the performance went down with concurrent streams.

I just tested this using lo instead of the 10GbE adapter.  I found similar 
results.  Since this makes it reproducible by just about anybody (maybe the 
only factor now is the number of CPUs), I have attached the script that I 
test things with.

So with the script run like ./stream_test 127.0.0.1 on 2.6.21 and 
2.6.21.5-rt17 I got the following:

2.6.21
=======================
default: 1 streams: Send at 2790.3 Mb/s, Receive at 2790.3 Mb/s
default: 2 streams: Send at 4129.4 Mb/s, Receive at 4128.7 Mb/s
default: 4 streams: Send at 7949.6 Mb/s, Receive at 7735.5 Mb/s
default: 8 streams: Send at 7930.7 Mb/s, Receive at 7910.1 Mb/s
1Msock: 1 streams: Send at 2810.7 Mb/s, Receive at 2810.7 Mb/s
1Msock: 2 streams: Send at 4093.4 Mb/s, Receive at 4092.6 Mb/s
1Msock: 4 streams: Send at 7887.8 Mb/s, Receive at 7880.4 Mb/s
1Msock: 8 streams: Send at 8091.7 Mb/s, Receive at 8082.2 Mb/s

2.6.21.5-rt17
======================
default: 1 streams: Send at 938.2 Mb/s, Receive at 938.2 Mb/s
default: 2 streams: Send at 1476.3 Mb/s, Receive at 1436.9 Mb/s
default: 4 streams: Send at 1489.8 Mb/s, Receive at 1145.0 Mb/s
default: 8 streams: Send at 1099.8 Mb/s, Receive at 1079.1 Mb/s
1Msock: 1 streams: Send at 921.4 Mb/s, Receive at 920.4 Mb/s
1Msock: 2 streams: Send at 1332.2 Mb/s, Receive at 1311.5 Mb/s
1Msock: 4 streams: Send at 1483.0 Mb/s, Receive at 1137.8 Mb/s
1Msock: 8 streams: Send at 1446.2 Mb/s, Receive at 1135.6 Mb/s

--Vernon

> While the test was showing the numbers for receiving as well as sending,
> the receiving numbers are not reliable because that machine was running a
> -RT kernel for these tests.
>
> I was just wondering if anyone had seen this problem before or would have
> any idea on where to start hunting for the solution.
>
> --Vernon
>
> The key for this is 'default' was invoked like:
> netperf -c -C -l 60 -H 10.2.2.4 -t UDP_STREAM -- -m 1472 -M 1472
> and '1Msock' was invoked like:
> netperf -c -C -l 60 -H 10.2.2.4 -t UDP_STREAM -- -m 1472 -M 1472 -s 1M -S
> 1M
>
> 2.6.21
> ==============
> default: 1 streams: Send at 2844.2 Mb/s, Receive at 2840.1 Mb/s
> default: 2 streams: Send at 3927.9 Mb/s, Receive at 3603.9 Mb/s
> default: 4 streams: Send at 4197.4 Mb/s, Receive at 3776.3 Mb/s
> default: 8 streams: Send at 4223.9 Mb/s, Receive at 3848.9 Mb/s
> 1Msock: 1 streams: Send at 4232.3 Mb/s, Receive at 3914.4 Mb/s
> 1Msock: 2 streams: Send at 5428.8 Mb/s, Receive at 3853.2 Mb/s
> 1Msock: 4 streams: Send at 6202.1 Mb/s, Receive at 3774.8 Mb/s
> 1Msock: 8 streams: Send at 6225.1 Mb/s, Receive at 3754.7 Mb/s
>
> 2.6.21.5-rt15
> ===============
> default: 1 streams: Send at 3091.6 Mb/s, Receive at 3048.1 Mb/s
> default: 2 streams: Send at 3768.8 Mb/s, Receive at 3714.2 Mb/s
> default: 4 streams: Send at 1873.6 Mb/s, Receive at 1825.9 Mb/s
> default: 8 streams: Send at 1806.5 Mb/s, Receive at 1792.7 Mb/s
> 1Msock: 1 streams: Send at 3680.4 Mb/s, Receive at 3255.6 Mb/s
> 1Msock: 2 streams: Send at 4129.8 Mb/s, Receive at 3991.5 Mb/s
> 1Msock: 4 streams: Send at 1862.1 Mb/s, Receive at 1787.1 Mb/s
> 1Msock: 8 streams: Send at 1790.2 Mb/s, Receive at 1556.8 Mb/s



--Boundary-00=_ZEKeG8ZOmM2SS2u
Content-Type: text/plain;
  charset="utf-8";
  name="stream_test"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="stream_test"

#!/bin/sh
# File: stream_test
# Description: test network throughput with a varying number of streams
# Author: Vernon Mauery <vernux@us.ibm.com>
# Copyright: IBM Corporation (C) 2007


instances="1 2 4 8"
msg_size=
time=60
TEST=UDP_STREAM
sock_size=

function usage() {
	echo "usage: $0 [-t|-u] [-c N] [-m N] [-s N] [-T N] [-x ...] <target ip addr>"
	echo "	-t, -u	run TCP or UDP tests respectively (default: UDP)"
	echo "	-c N	run N concurrent instances (default \"1 2 4 8\")"
	echo "	-m N	set message size to N bytes (default 1472)"
	echo "	-s N	set socket buffer size (default 1M)"
	echo "	-T N	run test for N seconds (default 60)"
	echo "	-x '...'	pass extra ags to netperf (included after -- )"
	echo "	-h		display this message"
}

while [ $# -gt 0 ]; do
	case $1 in
		-t)
		TEST=TCP_STREAM
		;;
		-u)
		TEST=UDP_STREAM
		;;
		-c)
		shift
		instances=$1
		;;
		-m)
		shift
		msg_size=$1
		;;
		-s)
		shift
		sock_size=$1
		;;
		-T)
		shift
		time=$1
		;;
		-x)
		shift
		extra_args=$1;
		;;
		-h)
		usage
		exit 0
		;;
		*)
		TARGET=$1
		;;
	esac
	shift
done

if [ -z "$TARGET" ]; then
	exit 1
fi
if ! ping -c 1 $TARGET >&/dev/null; then
	echo "could not connect to $TARGET"
	usage
	exit 1
fi

if [ -z "$msg_size" ]; then
	case $TEST in
		TCP_STREAM)
		msg_size=256k
		;;
		UDP_STREAM)
		msg_size=1472
		;;
	esac
fi
if [ -z "$sock_size" ]; then
	case $TEST in
		TCP_STREAM)
		sock_size=2M
		;;
		UDP_STREAM)
		sock_size=1M
		;;
	esac
fi

function execute() {
	ITERS=$1
	NAME=$2
	ARGS=$3
	for ((i=0; i<$ITERS; i++)); do
		command="./netperf -c -C -l $time -H $TARGET -t $TEST -- $ARGS $extra_args"
		echo $command
		echo $command > out.$$.$i
		$command >> out.$$.$i &
	done
	for ((i=1; i<=$ITERS; i++)); do
		wait %$i
	done
	date > results-$NAME.$$.$ITERS
	uname -a >> results-$NAME.$$.$ITERS
	cat out.$$.* >> results-$NAME.$$.$ITERS
	rm -f out.$$.*
}

function parse_TCP_STREAM() {
	ITER=$1
	NAME=$2
	SEND=`( cat results-$NAME.$$.$ITER | grep "^[ 0-9]" | awk '{printf "%s + ", \$5 }';  echo "0 " ) | bc`
	echo "** $NAME: $ITER streams: Send at $SEND Mb/s"
}

function parse_UDP_STREAM() {
	ITER=$1
	NAME=$2
	SEND=`( cat results-$NAME.$$.$ITER | grep "^[ 0-9]" | awk 'NR % 2 == 1 {printf "%s + ", \$6 }';  echo "0 " ) | bc`
	RECV=`( cat results-$NAME.$$.$ITER | grep "^[ 0-9]" | awk 'NR % 2 == 0 {printf "%s + ", \$4 }';  echo "0 " ) | bc`
	echo "** $NAME: $ITER streams: Send at $SEND Mb/s, Receive at $RECV Mb/s"
}

function cleanup() {
	for ((i=1; i<=$ITERS; i++)); do
		kill -9 %$i
	done
	rm -f out.$$.*
	exit
}

trap cleanup SIGINT SIGQUIT

rm -f out.$$.*
echo "results can be found in results-$$.*"
for C in $instances; do
	execute $C default "-m $msg_size -M $msg_size"
	parse_$TEST $C default
	execute $C ${sock_size}sock "-m $msg_size -M $msg_size -s $sock_size -S $sock_size"
	parse_$TEST $C ${sock_size}sock
done


--Boundary-00=_ZEKeG8ZOmM2SS2u--
