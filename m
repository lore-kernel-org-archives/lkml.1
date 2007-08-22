Return-Path: <linux-kernel-owner+w=401wt.eu-S933112AbXHVUnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933112AbXHVUnW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 16:43:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758283AbXHVUnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 16:43:15 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:50763 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbXHVUnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 16:43:14 -0400
Date: Wed, 22 Aug 2007 16:42:54 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Mike Mohr <akihana@gmail.com>
Cc: Rene Herman <rene.herman@home.nl>, linux-kernel@vger.kernel.org,
       Guido Guenther <agx@sigxcpu.org>, Bodo Eggert <7eggert@gmx.de>
Subject: Re: group ownership of tun devices -- nonfunctional?
Message-ID: <20070822204254.GA13410@c2.user-mode-linux.org>
References: <8Tpwf-3Nb-1@gated-at.bofh.it> <E1IMnHK-00012c-VC@be1.lrz> <46C86B6C.8090209@home.nl> <Pine.LNX.4.58.0708192333170.2426@be1.lrz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0708192333170.2426@be1.lrz>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I can create devices that are owned by my user account (tunctl -u
> `whoami` -t tap0) and it works fine.  However, if I use group
> permissions with -g it stops working.  In all cases, if I pass -g
> <group>, the interface is created correctly but it is unusable as a
> non-root user.

I can't reproduce this - it seems to work fine on -rc3-mm1:

As root:
	./tunctl -u user -g user -t tap1
	ifconfig tap1 192.168.0.130 up
	route add -host 192.168.0.131 dev tap1
	chmod 666 /dev/net/tun

As a normal user:
	./tunread # tunread source is below

As root again:
	ping 192.168.0.131

tunread output:
	0xffffffff 0xffffffff 0xffffffff 0xffffffff 0xffffffff 0xffffffff 0x0 0xffffffff 0xffffff9b 0x51 0xffffffb9 0xffffffd9 0x8 0x6 0x0 0x1 0x8 0x0 0x6 0x4 0x0 0x1 0x0 0xffffffff 0xffffff9b 0x51 0xffffffb9 0xffffffd9 0xffffffc0 0xffffffa8 0x0 0xffffff82 
0x0 0x0 0x0 0x0 0x0 0x0 0xffffffc0 0xffffffa8 0x0 0xffffff83 0xffffffff 0xffffffff 0xffffffff 0xffffffff 0xffffffff 0xffffffff 0x0 0xffffffff 0xffffff9b 0x51 0xffffffb9 0xffffffd9 0x8 0x6 0x0 0x1 0x8 0x0 0x6 0x4 0x0 0x1 0x0 0xffffffff 0xffffff9b 0x51 0xffffffb9 0xffffffd9 0xffffffc0 0xffffffa8 0x0 0xffffff82 
0x0 0x0 0x0 0x0 0x0 0x0 0xffffffc0 0xffffffa8 0x0 0xffffff83 0xffffffff 0xffffffff 0xffffffff 0xffffffff 0xffffffff 0xffffffff 0x0 0xffffffff 0xffffff9b 0x51 0xffffffb9 0xffffffd9 0x8 0x6 0x0 0x1 0x8 0x0 0x6 0x4 0x0 0x1 0x0 0xffffffff 0xffffff9b 0x51 0xffffffb9 0xffffffd9 0xffffffc0 0xffffffa8 0x0 0xffffff82 

				Jeff

-- 
Work email - jdike at linux dot intel dot com

#include <stdio.h>
#include <errno.h>
#include <fcntl.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/ioctl.h>
#define __KERNEL__
#include <linux/socket.h>
#include <linux/if.h>
#include <linux/if_tun.h>

int main(int argc, char **argv)
{
  char packet[1600];
  struct ifreq ifr;
  int fd, err, i, n;

  if((fd = open("/dev/net/tun", O_RDWR)) < 0){
    perror("Opening /dev/net/tun");
    exit(1);
  }

  memset(&ifr, 0, sizeof(ifr));

  /* Flags: IFF_TUN   - TUN device (no Ethernet headers) 
   *        IFF_TAP   - TAP device  
   *
   *        IFF_NO_PI - Do not provide packet information  
   */ 
  ifr.ifr_flags = IFF_TUN; 
  strncpy(ifr.ifr_name, "tap1", IFNAMSIZ);

  if((err = ioctl(fd, TUNSETIFF, (void *) &ifr)) < 0){
    perror("TUNSETIFF");
    exit(1);
  }

  while(1){
    n = read(fd, packet, sizeof(packet));
    if(n < 0){
      perror("read");
      exit(1);
    }
    else if(n == 0)
      break;

    for(i = 0; i < n; i++){
      printf("0x%x ", packet[i]);
      if((i % 32) == 31)
        printf("\n");
    }
  }
}
