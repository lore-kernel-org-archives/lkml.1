Return-Path: <linux-kernel-owner+w=401wt.eu-S1758582AbXJaAjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758582AbXJaAjV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 20:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752914AbXJaAjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 20:39:13 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:51333 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbXJaAjM (ORCPT
	<rfc822;Linux-Kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 20:39:12 -0400
Date: Tue, 30 Oct 2007 17:38:50 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Linux Netdev <linux-netdev@vger.kernel.org>,
       Linux Kernel Mailing List <Linux-Kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: dev_ifname32() fails on 32->64bit calls in copy_in_user().
Message-ID: <20071031003850.GE7517@tasint.org>
Mail-Followup-To: Linux Netdev <linux-netdev@vger.kernel.org>,
	Linux Kernel Mailing List <Linux-Kernel@vger.kernel.org>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello folks,
	I've been using a nice program on ppc32 with a ppc64
system+kernel.  It uses netlink to determine some network interface
information.  Recent kernels cause it to exit at the netlink stage.  At
first, I thought it was a bug in the program.  Now I'm not so sure.
	The situation is specifically the use of SIOCGIFNAME in 32bit
binaries on 64 bit platforms+kernels.  I've tested ppc32 on ppc64 and 
ia32 on amd64.  amd64 on amd64, ia32 on ia32,and ppc64 on ppc64
all work fine.
	I've cooked up a test program to evince the problem.  It just
asks netlink for an interface list, then uses SIOCGIFNAME to get the
interface name.  On kernels before commit 
32da477a5bfe96b6dfc8960e0d22d89ca09fd10a [NET]: Don't implement
dev_ifname32 inline, the test program runs fine.  Kernels after, I get
EFAULT.  This behavior is the same as the original program. 
	Instrumenting the kernel with printks, the EFAULT comes from
the first copy_in_user() at line 325 of fs/compat_ioctl.c (in
dev_ifname32()).  I put some access_ok() checks in, and they do not
trigger (access is ok).  The call never even gets into sys_ioctl().
	I'm assuming at this point that copy_in_user() for ia32/amd64
and ppc32/ppc64 is what is having trouble.  Test program follows.

Joel

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdarg.h>
#include <sys/types.h>
#include <sys/ioctl.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <errno.h>
#include <unistd.h>

#include <net/if.h>
#include <asm/types.h>
#include <linux/rtnetlink.h>

#define NETLINK_BUFSIZE 16384

static void bail(int rc, char *fmt, ...)
{
    va_list args;

    if (fmt) {
        va_start(args, fmt);
        vfprintf(stderr, fmt, args);
        va_end(args);
    }

    exit(rc);
}

int main(int argc, char *argv[])
{
    int fd, ioctl_fd, rc, len;
    struct {
        struct nlmsghdr nlh;
        struct rtgenmsg g;
    } req;
    struct sockaddr_nl nladdr;
    static char rcvbuf[NETLINK_BUFSIZE];
    struct nlmsghdr *h;
    struct iovec iov = {rcvbuf, sizeof(rcvbuf) };
    struct msghdr msg = {
        (void *)&nladdr, sizeof(nladdr),
        &iov, 1,
        NULL, 0,
        0
    };
    struct ifreq ifr;
    struct ifaddrmsg *ifa;

    fd = socket(AF_NETLINK, SOCK_RAW, NETLINK_ROUTE);
    if (fd < 0)
        bail(1, "Unable to open netlink socket: %s\n", strerror(errno));

    if (setsockopt(fd, SOL_SOCKET, SO_RCVBUF, &rcvbuf, sizeof(rcvbuf)))
        bail(1, "Unable to set socket options: %s\n", strerror(errno));

    memset(&nladdr, 0, sizeof(nladdr));
    nladdr.nl_family = AF_NETLINK;
    req.nlh.nlmsg_len = sizeof(req);
    req.nlh.nlmsg_type = RTM_GETADDR;
    req.nlh.nlmsg_flags = NLM_F_ROOT|NLM_F_MATCH|NLM_F_REQUEST;
    req.nlh.nlmsg_pid = 0;
    req.nlh.nlmsg_seq = 1;
    req.g.rtgen_family = AF_INET;

    if (sendto(fd, (void *)&req, sizeof(req), 0,
               (struct sockaddr *)&nladdr, sizeof(nladdr)) < 0)
        bail(1, "Unable to send netlink request: %s\n", strerror(errno));

    while (1)
    {
        rc = recvmsg(fd, &msg, 0);
        if (!rc)
            bail(1, "Netlink socket closed\n");

        h = (struct nlmsghdr *)rcvbuf;
        if (h->nlmsg_type == NLMSG_DONE)
            break;

        if (h->nlmsg_type == NLMSG_ERROR)
            bail(1, "Error from netlink socket\n");

        len = rc;
        for (; NLMSG_OK(h, len); h = NLMSG_NEXT(h, len)) {
            if (h->nlmsg_type != RTM_NEWADDR)
                continue;

            ioctl_fd = socket(AF_INET, SOCK_STREAM, 0);
            if (ioctl_fd < 0)
                bail(1, "Unable to create ioctl socket: %s\n",
                     strerror(errno));

            ifa = NLMSG_DATA(h);
            memset(&ifr, 0, sizeof(ifr));
            ifr.ifr_ifindex = ifa->ifa_index;

            rc = ioctl(ioctl_fd, SIOCGIFNAME, &ifr);
            if (rc)
                bail(1, "Unable to get name: %s\n", strerror(errno));

            fprintf(stdout, "Interface %d, %s\n", ifr.ifr_ifindex,
                    ifr.ifr_ifrn.ifrn_name);
        }
    }

    return 0;
}

-- 

"What no boss of a programmer can ever understand is that a programmer
 is working when he's staring out of the window"
	- With apologies to Burton Rascoe

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
