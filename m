Return-Path: <linux-kernel-owner+w=401wt.eu-S1757019AbXJOVBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757019AbXJOVBb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 17:01:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754406AbXJOVBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 17:01:10 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36264 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754455AbXJOVBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 17:01:08 -0400
Date: Mon, 15 Oct 2007 14:00:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: aarapov@redhat.com, linux-kernel@vger.kernel.org,
       linux-netdev@vger.kernel.org, davem@redhat.com, jgarzik@redhat.com
Subject: Re: [PATCH] ipv4: kernel panic when only one unsecured port
 available
Message-Id: <20071015140025.84e73297.akpm@linux-foundation.org>
In-Reply-To: <20071015.130614.129757419.davem@davemloft.net>
References: <m3fy0k9yod.fsf@bandura.englab.brq.redhat.com>
	<20071015124919.30ed8f06.akpm@linux-foundation.org>
	<20071015.130614.129757419.davem@davemloft.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2007 13:06:14 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Andrew Morton <akpm@linux-foundation.org>
> Date: Mon, 15 Oct 2007 12:49:19 -0700
> 
> > This code has recently been reworked, but from my reading, that
> > divide-by-zero can still occur.  And given that the numbers in
> > /proc/sys/net/ipv4/ip_local_port_range are inclusive, the arithmetic in
> > inet_csk_get_port() seems to just be wrong?
> > 
> > So we have this, against David's current devel tree:
> 
> I'm pretty sure we took care of this, but maybe not :-)

<looks>

OK, in ipv4_local_port_range() we have 

                if (range[1] <= range[0])
                        ret = -EINVAL;

which will prevent the crashes.

But is it good to disallow high=low?  This disallows a port range of one
single port.  Unless "high" is exclusive.  But
Documentation/filesystems/proc.txt says

: ip_local_port_range
: -------------------
:
: Range of  ports  used  by  TCP  and UDP to choose the local port. Contains two
: numbers, the  first  number  is the lowest port, the second number the highest
: local port.  Default  is  1024-4999.  Should  be  changed  to  32768-61000 for
: high-usage systems.

ie: inclusive.

Documentation/networking/ip-sysctl.txt says

: ip_local_port_range - 2 INTEGERS
: 	Defines the local port range that is used by TCP and UDP to
: 	choose the local port. The first number is the first, the 
: 	second the last local port number. Default value depends on
: 	amount of memory available on the system:
: 	> 128Mb 32768-61000
: 	< 128Mb 1024-4999 or even less.
: 	This number defines number of active connections, which this
: 	system can issue simultaneously to systems not supporting
: 	TCP extensions (timestamps). With tcp_tw_recycle enabled
: 	(i.e. by default) range 1024-4999 is enough to issue up to
: 	2000 connections per second to systems supporting timestamps.

also inclusive.


