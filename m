Return-Path: <linux-kernel-owner+w=401wt.eu-S1758063AbYJWWME@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758063AbYJWWME (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 18:12:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753426AbYJWWLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 18:11:54 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:61147 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407AbYJWWLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 18:11:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=YXkn9Dv9VjUVwWHV1cKtzd+mN/aRZ3H/jpb57qYDKD2ewUN8ttKVVYz77U6VwDmfX8
         XahRGdKEaAR53Vkrvk8NJKBDRkygrbPcA/fmq8kDBl7ujfdKA/Rwru6RP0aJaMz4WSuu
         yOhefvHizmMWtbSrylQGUfghmAYf1t9ClSgvk=
Message-ID: <50a66e370810231511m10a10ca2oa870e9fbd55f4b0e@mail.gmail.com>
Date: Thu, 23 Oct 2008 18:11:50 -0400
From: "Todd Hayton" <todd.hayton@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: IPv6 multicast forwarding
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let me apologize in advance for the length of this message - it is long!

I'm trying to test out IPv6 multicast forwarding on a 2.6.26 kernel
and I'm getting some strange values for the upcall messages from the
kernel. My code is below, but to give an overview, my setup is as
follows:

    sender ------ ff15::1 -----> [eth1] linux 2.6.26 [eth0] ------> ...

So my incoming interface is eth1 and my outgoing interface is eth0 and
I am sending traffic to IPv6 multicast group ff15::1

I am seeing that mifs are being created successfully:

[root@localhost mcast-tools]# cat /proc/net/ip6_mr_vif
Interface      BytesIn  PktsIn  BytesOut PktsOut Flags
 1 eth1              0       0         0       0 00000
 2 eth0              0       0         0       0 00000

And after I start sending traffic I can see that the kernel is
queueing the packets (as it does not yet have a route installed for
this traffic):

[root@localhost mcast-tools]# cat /proc/net/ip6_mr_cache
Group                            Origin                           Iif
    Pkts  Bytes     Wrong  Oifs
ff15:0000:0000:0000:0000:0000:0000:0001
fec0:0000:0000:0000:0000:0000:0000:0001 65535     1028        4
0

Which is where my code comes in, I am monitoring a raw ICMPV6 socket
so as to receive the kernel upcalls for this traffic. Now, I am
expecting to get a message from the kernel that "appears" to be an MLD
header but is in reality an mrt6msg, the flag being that the icmp6
type is set to 0 so as to indicate to the userland process that this
is an upcall.

However, in my code after I've detected that the raw socket is
readable and I read from it, I never really seem to get data that
looks like an mld_hdr:

...
      n = read(raw_icmpv6_sock, raw_recv_buf, sizeof(raw_recv_buf));
      if (n < 0) {
        perror("read: ");
        exit(1);
      }
     mh = (struct mld_hdr *)raw_recv_buf;
    if (mh->mld_icmp6_hdr.icmp6_type == 0) { /* kernel upcall */
...

Except the icmp6_type is *never* 0 - instead it's an assortment of
strange values.

I fired up gdb, examined the contents of raw_recv_buf, right after
read() occurs and mh is set to point to raw_recv_buf:

(gdb) p/x raw_recv_buf[0]@n
$13 = {0x20, 0x0, 0x80, 0x1, 0x20, 0x0, ....
(gdb) p/d mh->mld_icmp6_hdr.icmp6_type
$14 = 32

and then the next packet comes in with different values..

(gdb) p/x raw_recv_buf[0]@n
$15 = {0x86, 0x15, 0x60, 0x1, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
0xc2, 0x3, 0x18, 0x0, 0x95, 0x1a, 0x7, 0x0, 0x3, 0x15, 0x60, 0x1,
0x86, 0x15, 0x60, 0x1, 0xec, 0x\
ec, 0xe9, 0xe9, 0xe9, 0xe9, 0xff, 0xff, 0x0, 0x0, 0x0, 0x0}
(gdb) p/d mh->mld_icmp6_hdr.icmp6_type
$16 = 134

Now I am examining the traffic sent in another window:

[root@localhost linux]# tcpdump -xnnevi eth1
tcpdump: listening on eth1, link-type EN10MB (Ethernet), capture size 96 bytes
17:59:50.713520 08:00:27:9c:aa:88 > 33:33:00:00:00:01, ethertype IPv6
(0x86dd), length 66: (hlim 3, next-header UDP (17) payload length: 12)
fec0::1.40825 > ff15::1.31337: [udp sum ok] UDP, length 4
	0x0000:  6000 0000 000c 1103 fec0 0000 0000 0000
	0x0010:  0000 0000 0000 0001 ff15 0000 0000 0000
	0x0020:  0000 0000 0000 0001 9f79 7a69 000c 2354
	0x0030:  6162 6364
17:59:51.725815 08:00:27:9c:aa:88 > 33:33:00:00:00:01, ethertype IPv6
(0x86dd), length 66: (hlim 3, next-header UDP (17) payload length: 12)
fec0::1.40825 > ff15::1.31337: [udp sum ok] UDP, length 4
	0x0000:  6000 0000 000c 1103 fec0 0000 0000 0000
	0x0010:  0000 0000 0000 0001 ff15 0000 0000 0000
	0x0020:  0000 0000 0000 0001 9f79 7a69 000c 2354
	0x0030:  6162 6364

So either I'm misunderstanding the upcall mechanism here (most likely)
or there's a bug... If there's any other information I can include let
me know. Below is the code I am using to monitor the raw socket - it's
not pretty code :-) just what I am using for testing right now!

Todd H

#include <stdio.h>
#include <stdlib.h>
#include <strings.h>
#include <errno.h>

#include <sys/types.h>
#include <sys/uio.h>
#include <sys/socket.h>
#include <sys/select.h>
#include <sys/param.h>

#include <net/route.h>

#include <netinet/in.h>
#include <netinet/ip6.h>
#include <netinet/icmp6.h>
#include <linux/mroute6.h>

#include <arpa/inet.h>

#include <unistd.h>

#define IVIF 1
#define OVIF 2

static int raw_icmpv6_sock = -1;
static char raw_recv_buf[8192];

int raw_sock_init()
{
  struct icmp6_filter filt;

  raw_icmpv6_sock = socket(AF_INET6, SOCK_RAW, IPPROTO_ICMPV6);
  if (raw_icmpv6_sock < 0) {
    perror("socket: ");
    return -1;
  }

  ICMP6_FILTER_SETBLOCKALL(&filt);
  if (setsockopt(raw_icmpv6_sock, IPPROTO_ICMPV6, ICMP6_FILTER, &filt,
sizeof(filt)) < 0) {
    perror("setsockopt ICMP6_FILTER");
    return -1;
  }

  return 0;
}

int mrt6_init()
{
  int v;

  if (raw_sock_init() < 0)
    return -1;

  v = 1;
  if (setsockopt(raw_icmpv6_sock, IPPROTO_IPV6, MRT6_INIT,
		 (void *)&v, sizeof(int)) < 0) {
    perror("setsockopt: ");
    return -1;
  }
  return 0;
}

int mrt6_done()
{
  int v;
  v = 1;
  if (setsockopt(raw_icmpv6_sock, IPPROTO_IP, MRT6_DONE,
		 (void *)&v, sizeof(int)) < 0) {
    perror("setsockopt: ");
    return -1;
  }
  return 0;
}

int mrt6_add_mfc(struct sockaddr_in6 src, struct sockaddr_in6 grp)
{
  struct mf6cctl mc;

  bzero(&mc, sizeof(mc));
  mc.mf6cc_origin     = src;
  mc.mf6cc_mcastgrp   = grp;
  mc.mf6cc_parent     = IVIF;

  IF_ZERO(&mc.mf6cc_ifset);
  IF_SET(OVIF, &mc.mf6cc_ifset);

  if (setsockopt(raw_icmpv6_sock, IPPROTO_IPV6, MRT6_ADD_MFC,
		 (void *)&mc, sizeof(mc))) {
    perror("setsockopt: ");
    return -1;
  }

  return 0;
}

int mrt6_add_mif()
{
  struct mif6ctl mc;

  bzero(&mc, sizeof(mc));

  mc.mif6c_mifi = IVIF;
  mc.mif6c_pifi = 3;

  if (setsockopt(raw_icmpv6_sock, IPPROTO_IPV6, MRT6_ADD_MIF,
		 (void *)&mc, sizeof(mc))) {
    perror("setsockopt: ");
    return -1;
  }

  bzero(&mc, sizeof(mc));

  mc.mif6c_mifi = OVIF;
  mc.mif6c_pifi = 2;

  if (setsockopt(raw_icmpv6_sock, IPPROTO_IPV6, MRT6_ADD_MIF,
		 (void *)&mc, sizeof(mc))) {
    perror("setsockopt: ");
    return -1;
  }
  return 0;
}

int main()
{
  if (mrt6_init() < 0)
    exit(1);

  if (mrt6_add_mif() < 0)
    exit(1);

  /* wait for upcall */
  while (1) {
    int              n      = 0;
    fd_set           rset;
    struct mld_hdr * mh     = NULL;
    struct mrt6msg * upcall = NULL;

    FD_ZERO(&rset);
    FD_SET(raw_icmpv6_sock, &rset);

    n = select(raw_icmpv6_sock + 1, &rset, NULL, NULL, NULL);
    if (n < 0) {
      perror("select: ");
      exit(1);
    }

    n = read(raw_icmpv6_sock, raw_recv_buf, sizeof(raw_recv_buf));
    if (n < 0) {
      perror("read: ");
      exit(1);
    }
    mh = (struct mld_hdr *)raw_recv_buf;
    if (mh->mld_icmp6_hdr.icmp6_type == 0) { /* kernel upcall */
      upcall = (struct mrt6msg *)raw_recv_buf;
      if (upcall->im6_msgtype == MRT6MSG_NOCACHE) {
	char sbuf[64], dbuf[64];
	struct sockaddr_in6 src, grp;
	fprintf(stderr, "(%s,%s)\n",
		inet_ntop(AF_INET6, &upcall->im6_src, sbuf, sizeof(sbuf)),
		inet_ntop(AF_INET6, &upcall->im6_dst, dbuf, sizeof(dbuf)));	

	bzero(&src, sizeof(src));
	bzero(&grp, sizeof(grp));

	src.sin6_addr = upcall->im6_src;
	grp.sin6_addr = upcall->im6_dst;

	mrt6_add_mfc(src, grp);
      }
    }

  }
  if (mrt6_done() < 0)
    exit(1);

  exit(0);
}
