Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478Ab0BTN50 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 08:57:26 -0500
Received: from ixro-out-rtc.ixiacom.com ([92.87.192.98]:5113 "EHLO
	ixro-ex1.ixiacom.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754863Ab0BTN5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 08:57:24 -0500
From: Octavian Purdila <opurdila@ixiacom.com>
Organization: Ixia
To: Cong Wang <amwang@redhat.com>
Subject: Re: [net-next PATCH v5 0/3] net: reserve ports for applications using fixed port numbers
Date: Sat, 20 Feb 2010 15:57:04 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.32-2-686; KDE/4.3.2; i686; ; )
Cc: David Miller <davem@davemloft.net>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Neil Horman <nhorman@tuxdriver.com>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
References: <1266532210-11536-1-git-send-email-opurdila@ixiacom.com> <4B7F993C.9000007@redhat.com>
In-Reply-To: <4B7F993C.9000007@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201002201557.04427.opurdila@ixiacom.com>
X-OriginalArrivalTime: 20 Feb 2010 13:55:50.0534 (UTC) FILETIME=[6921B260:01CAB234]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 20 February 2010 10:11:40 you wrote:
> Octavian Purdila wrote:
> > This patch introduces /proc/sys/net/ipv4/ip_local_reserved_ports which
> > allows users to reserve ports for third-party applications.
> >
> > The reserved ports will not be used by automatic port assignments
> > (e.g. when calling connect() or bind() with port number 0). Explicit
> > port allocation behavior is unchanged.
> >
> > Changes from the previous version:
> > - switch the /proc entry format to coma separated list of range ports
> > - treat -EFAULT just like any other error and acknowledge written values
> > - use isdigit() in proc_get_ulong
> >
> > Octavian Purdila (3):
> >   sysctl: refactor integer handling proc code
> >   sysctl: add proc_do_large_bitmap
> >   net: reserve ports for applications using fixed port numbers
> 
> Hi,
> 
> This version looks fine for me, but I need to give them a test, and
> I will put feedbacks asap. Thanks for your work!
> 
> Still two things:
> 
> 1) bitops are always atomic on every arch, right? If yes, then ok.

AFAIK, yes.

> 2) I hope you could add some documentation to show the relations
>     between ip_local_port_range and ip_local_reserved_ports.
> 

How does this sound:

ip_local_reserved_ports - list of comma separated ranges
        Specify the ports which are reserved for known third-party
        applications. These ports will not be used by automatic port
        assignments (e.g. when calling connect() or bind() with port
        number 0). Explicit port allocation behavior is unchanged.

        The format used for both input and output is a comma separated
        list of ranges (e.g. "1,2-4,10-10" for ports 1, 2, 3, 4 and
        10). Writing to the file will clear all previously reserved
        ports and update the current list with the one given in the
        input.

        Note that ip_local_port_range and ip_local_port_range settings
        are independent and both are considered by the kernel when
        determining which ports are available for automatic port
        assignments.

        You can reserve ports which are not in the current
        ip_local_port_range, e.g.:

        $ cat /proc/sys/net/ipv4/ip_local_port_range
        32000   61000
        $ cat /proc/sys/net/ipv4/ip_local_reserved_ports
        8080,9148

        although this is redundant. However such a setting is useful
        if later the port range is changed to a value that will
        include the reserved ports.



