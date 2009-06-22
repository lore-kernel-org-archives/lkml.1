Return-Path: <linux-kernel-owner+w=401wt.eu-S1755780AbZFVTJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755780AbZFVTJ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 15:09:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752048AbZFVTJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 15:09:51 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:41067 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751763AbZFVTJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 15:09:50 -0400
X-IronPort-AV: E=Sophos;i="4.42,270,1243807200"; 
   d="c'?scan'208";a="31734446"
Message-ID: <4A3FD721.3050606@inria.fr>
Date: Mon, 22 Jun 2009 21:10:25 +0200
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Stefan Lankes <lankes@lfbs.rwth-aachen.de>
CC: Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       "'Andi Kleen'" <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-numa@vger.kernel.org, Boris Bierbaum <boris@lfbs.rwth-aachen.de>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC PATCH 0/4]: affinity-on-next-touch
References: <000c01c9d212$4c244720$e46cd560$@rwth-aachen.de> <87zldjn597.fsf@basil.nowhere.org> <000001c9eac4$cb8b6690$62a233b0$@rwth-aachen.de> <20090612103251.GJ25568@one.firstfloor.org> <004001c9eb53$71991300$54cb3900$@rwth-aachen.de> <1245119977.6724.40.camel@lts-notebook> <003001c9ee8a$97e5b100$c7b11300$@rwth-aachen.de> <1245164395.15138.40.camel@lts-notebook> <000501c9ef1f$930fa330$b92ee990$@rwth-aachen.de> <1245299856.6431.30.camel@lts-notebook> <4A3F7A49.6070805@inria.fr> <1245680649.7799.54.camel@lts-notebook> <4A3FA326.8030802@inria.fr> <1245689724.7799.124.camel@lts-notebook> <4A3FBA11.8030304@inria.fr> <4A3FC68A.2030104@lfbs.rwth-aachen.de>
In-Reply-To: <4A3FC68A.2030104@lfbs.rwth-aachen.de>
X-Enigmail-Version: 0.95.0
Content-Type: multipart/mixed;
 boundary="------------090004030009030204080305"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090004030009030204080305
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Stefan Lankes wrote:
> I am not able to reconstruct any performance drawbacks on my system.
> Could you send me your low-level benchmark?

It's attached. As you may see, it's fairly trivial. It just does several
iterations of mbind+touch_all_pages for different power-of-two buffer
sizes. Just replace mbind with madvise in the inner loop if you want to
try with your affinit-on-next-touch.

Which kernels are you using when comparing your next-touch
implementation with Lee's patchset?

Brice


--------------090004030009030204080305
Content-Type: text/x-csrc;
 name="next-touch-mof-cost.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="next-touch-mof-cost.c"

#define _GNU_SOURCE 1
#include <unistd.h>
#include <sys/mman.h>
#include <sys/time.h>
#include <stdio.h>
#include <stdlib.h>
#include <numa.h>
#include <numaif.h>
#include <errno.h>
#include <sched.h>

#ifndef MPOL_MF_LAZY
#define MPOL_MF_LAZY (1<<3)
#endif

#define TOTALPAGES 262144

int nbpages, loop;
int pagesize;

int main(int argc, char **argv) {
  void *buffer;
  int i, err;
  unsigned long nodemask;
  int maxnode;
  struct timeval tv1, tv2;
  unsigned long us;
  cpu_set_t cset;

  /* put the thread on node 0 */
  CPU_ZERO(&cset);
  CPU_SET(0, &cset);
  err = sched_setaffinity(0, sizeof(cset), &cset);
  if (err < 0) {
    perror("sched_setaffinity");
    exit(-1);
  }

  pagesize = getpagesize();
  maxnode = numa_max_node();

  fprintf(stdout, "# Nb_pages\tCost(ns)\n");
  for(nbpages=2 ; nbpages<=TOTALPAGES ; nbpages*=2) {
    int loops = TOTALPAGES/nbpages;
    if (loops > 128) loops = 128;

    buffer = mmap(NULL, TOTALPAGES*pagesize, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0);
    if (buffer == MAP_FAILED) {
      perror("mmap");
      exit(-1);
    }

    /* bind to node 1 and prefault */
    nodemask = 1<<1;
    err = mbind(buffer, TOTALPAGES*pagesize, MPOL_BIND, &nodemask, maxnode+2, MPOL_MF_MOVE);
    if (err < 0) {
      perror("mbind");
      exit(-1);
    }
    for(i=0 ; i<TOTALPAGES ; i++)
      *(int*)(buffer+i*pagesize) = 0;

    gettimeofday(&tv1, NULL);
 
    for(loop=0 ; loop<loops ; loop++) {
      /* mark subbuf as next-touch and touch it */
      void *subbuf = buffer + loop*nbpages*pagesize;
      err = mbind(subbuf, nbpages*pagesize, MPOL_PREFERRED, NULL, 0, MPOL_MF_MOVE|MPOL_MF_LAZY);
      if (err < 0) {
        perror("mbind");
	exit(-1);
      }
      for(i=0;i<nbpages;i++)
        *(int*)(subbuf + i*pagesize) = 42;
    }
    gettimeofday(&tv2, NULL);

    us = (tv2.tv_sec - tv1.tv_sec) * 1000000 + (tv2.tv_usec - tv1.tv_usec);
    fprintf(stdout, "%d\t%ld\n", nbpages, us * 1000/loops);
    fflush(stdout);

    munmap(buffer, TOTALPAGES*pagesize);
  }

  return 0;
}

--------------090004030009030204080305--
