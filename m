Return-Path: <linux-kernel-owner+w=401wt.eu-S934244AbXCVV2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934244AbXCVV2V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 17:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934240AbXCVV2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 17:28:20 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:40730 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934244AbXCVV2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 17:28:19 -0400
Date: Thu, 22 Mar 2007 22:28:25 +0100
From: Olaf Hering <olaf@aepfle.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] reject taskset for kernel threads
Message-ID: <20070322212825.GA12297@aepfle.de>
References: <20070321205353.GA32529@aepfle.de> <20070321145027.c76121dc.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070321145027.c76121dc.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, Andrew Morton wrote:

> On Wed, 21 Mar 2007 21:53:53 +0100
> Olaf Hering <olaf@aepfle.de> wrote:
> 
> > 
> > Do not allow taskset for kernel threads.
> > These commands will cause oopses due to stack corruption:
> > 
> > ls /proc/*/task | grep -v ^/ | xargs echo | xargs -n1 taskset -pc 2-9
> > taskset -pc 1 $$
> > taskset -pc 0 $((pidof john))
> 
> Why does the kernel oops?

I guess I have to find out. Sometimes it just deadlocks.
Linus tree (+patches) crashes nicely and loops in xmon exceptions, see below.

#/bin/bash
numcpus=`grep -Ec '^cpu[0-9]' /proc/stat || echo 1`
forked=
john=
for i in `seq 1 $numcpus`
do
        echo $i
        bash -c 'declare -i x=1 ; while test $x != 0 ; do : $(( x++ )) ; done' &
        forked="$forked $!"
done
echo "forked $forked"
nice -n -19 bash -c 'declare -i x=1 ; while test $x != 0 ; do : $(( x++ )) ; done' &
john=$!
sleep 3
ls -A /proc/*/task | grep -v ^/ | xargs echo | xargs -n1 taskset -pc 2-$numcpus
taskset -pc 2 $$
taskset -pc 0 $john
sleep 3
kill $forked $john



...
pid 4796's new affinity list: 2,3
pid 4797's current affinity list: 0-3
Page fault in user mode within_atomic() = 0 mm = 0000000000000000
NIP = fd8e590  MSR = 4000f032
cpu 0x1: Vector: 401 (Instruction Access) at [c0000000e9dfbea0]
    pc: 000000000fd8e590
    lr: 000000000fdf3cec
    sp: ffc2
            0c90
   msr: 4000f032
  current = 0xc0000000e74e2800
  paca    = 0xc0000000005b3000
    pid   = 4797, comm = bash
cpu 0x2: Vector: 400 (Instr------------[ cuut here ]--------c----
tion Access) at [c0000000e9dfb380]
cpu 0x2: Vector: 3865000000000400  at [c0000000e9dfac60]
    pc: c0000000e9dfae00
    lr: c0000000e9dfae00
    sp: c0000000e9dfaee0
   msr: c0000000004e6220
  cur e?n tfeorr  ?h eflopr
shxl 0 0pacfScP2 0(cf9f0c)2 0ics9 0i)n  iuss eirns puasceer
 pac h
  p1i:dm o n >=  4797, comm = bash
cpu 0x2: Exception 3835360000000400  in xmon, returning to main loop
cpu 0x2: Vector: 300 (Data Access) at [c0000000e9dfac10]
...
