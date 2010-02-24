Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863Ab0BXMBm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 07:01:42 -0500
Received: from ixro-out-rtc.ixiacom.com ([92.87.192.98]:31840 "EHLO
	ixro-ex1.ixiacom.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756815Ab0BXMBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 07:01:41 -0500
From: Octavian Purdila <opurdila@ixiacom.com>
Organization: Ixia
To: Cong Wang <amwang@redhat.com>
Subject: Re: [net-next PATCH v5 2/3] sysctl: add proc_do_large_bitmap
Date: Wed, 24 Feb 2010 14:02:54 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.32-2-686; KDE/4.3.2; i686; ; )
Cc: David Miller <davem@davemloft.net>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
References: <1266752533.3428.28.camel@Nokia-N900-42-11> <201002221829.13987.opurdila@ixiacom.com> <4B84B7F0.7090709@redhat.com>
In-Reply-To: <4B84B7F0.7090709@redhat.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_uVRhL6R0Ci1mtjv"
Message-Id: <201002241402.54122.opurdila@ixiacom.com>
X-OriginalArrivalTime: 24 Feb 2010 12:01:39.0116 (UTC) FILETIME=[1F0546C0:01CAB549]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_uVRhL6R0Ci1mtjv
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit


On Wednesday 24 February 2010 07:24:00 you wrote:
> Octavian Purdila wrote:
> > Here is a new version of this patch which fixes both the comma and
> > invalid value issues, please give it a try.
> 
> Sorry, it is even worse. :(
> 
> > [net-next PATCH v5 2/3] sysctl: add proc_do_large_bitmap
> >
> > The new function can be used to read/write large bitmaps via /proc. A
> > comma separated range format is used for compact output and input
> > (e.g. 1,3-4,10-10).
> 
> Writing "50000-50100" gets EINVAL, it should be success.
> Writing "50000,50100" fails too.
> 

Hmm, they don't fail for me :-/

> Please, at least, do some basic testing.
> 

I do test them, I've attached the current test batch I was using.

Anyways, today I've noticed that "1,2 3" does not fail and even more 
importantly the final value is "3". 

Being that I don't see a way of fixing this without not acknowledging 1,2 even 
though we will do set these values, I revisited the "1 2 3" issue. And I don't 
understand why this is actually an issue, we are just being more permissive 
(i.e. we are allowing as separators both whitespaces and ,).


> Also some comments below.
> 
> > diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> > index 5259727..d8ea839 100644
> > --- a/kernel/sysctl.c
> > +++ b/kernel/sysctl.c
> > @@ -2635,6 +2635,140 @@ static int proc_do_cad_pid(struct ctl_table
> > *table, int write,
> 
> The above line is wrong, it should be a part of previous line.
> 

Probably my email client corrupted the patch, sorry about that, I will be more 
careful next time.

> > +	int left = *lenp, err = 0;
> 
> 'left' should be size_t.
> 

Will fix, thanks for catching this.

I will resend the whole patch series once we get this formatting issue 
resolved.

--Boundary-00=_uVRhL6R0Ci1mtjv
Content-Type: text/x-log;
  charset="UTF-8";
  name="rp_test.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="rp_test.log"

+ cat /proc/sys/net/ipv4/ip_local_reserved_ports
40002
+ echo 50000
+ cat /proc/sys/net/ipv4/ip_local_reserved_ports
50000
+ echo 50000-50100
+ cat /proc/sys/net/ipv4/ip_local_reserved_ports
50000-50100
+ echo
+ cat /proc/sys/net/ipv4/ip_local_reserved_ports

+ echo 40000-50000,50000-50100,50101-50101
+ cat /proc/sys/net/ipv4/ip_local_reserved_ports
40000-50101
+ set +e
+ echo 40000a
rp_test.sh: line 12: echo: write error: Invalid argument
+ cat /proc/sys/net/ipv4/ip_local_reserved_ports
40000-50101
+ echo 40000-
rp_test.sh: line 14: echo: write error: Invalid argument
+ cat /proc/sys/net/ipv4/ip_local_reserved_ports
40000-50101
+ echo 70000
rp_test.sh: line 16: echo: write error: Invalid argument
+ cat /proc/sys/net/ipv4/ip_local_reserved_ports
40000-50101
+ echo 40000-30000
rp_test.sh: line 18: echo: write error: Invalid argument
+ cat /proc/sys/net/ipv4/ip_local_reserved_ports
40000-50101
+ echo 40000,
+ cat /proc/sys/net/ipv4/ip_local_reserved_ports
40000
+ echo 40000,40001,40000b
rp_test.sh: line 22: echo: write error: Invalid argument
+ cat /proc/sys/net/ipv4/ip_local_reserved_ports
40000-40001
+ echo 40000 40001 40002
rp_test.sh: line 24: echo: write error: Invalid argument
+ cat /proc/sys/net/ipv4/ip_local_reserved_ports
40000-40001
+ echo 40000,40001 40002
+ cat /proc/sys/net/ipv4/ip_local_reserved_ports
40002

--Boundary-00=_uVRhL6R0Ci1mtjv
Content-Type: application/x-shellscript;
  name="rp_test.sh"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="rp_test.sh"

set -xe
cat /proc/sys/net/ipv4/ip_local_reserved_ports
echo 50000 > /proc/sys/net/ipv4/ip_local_reserved_ports
cat /proc/sys/net/ipv4/ip_local_reserved_ports
echo 50000-50100 > /proc/sys/net/ipv4/ip_local_reserved_ports
cat /proc/sys/net/ipv4/ip_local_reserved_ports
echo > /proc/sys/net/ipv4/ip_local_reserved_ports
cat /proc/sys/net/ipv4/ip_local_reserved_ports
echo 40000-50000,50000-50100,50101-50101 > /proc/sys/net/ipv4/ip_local_reserved_ports
cat /proc/sys/net/ipv4/ip_local_reserved_ports
set +e
echo 40000a > /proc/sys/net/ipv4/ip_local_reserved_ports
cat /proc/sys/net/ipv4/ip_local_reserved_ports
echo 40000- > /proc/sys/net/ipv4/ip_local_reserved_ports
cat /proc/sys/net/ipv4/ip_local_reserved_ports
echo 70000 > /proc/sys/net/ipv4/ip_local_reserved_ports
cat /proc/sys/net/ipv4/ip_local_reserved_ports
echo 40000-30000 > /proc/sys/net/ipv4/ip_local_reserved_ports
cat /proc/sys/net/ipv4/ip_local_reserved_ports
echo 40000, > /proc/sys/net/ipv4/ip_local_reserved_ports
cat /proc/sys/net/ipv4/ip_local_reserved_ports
echo 40000,40001,40000b > /proc/sys/net/ipv4/ip_local_reserved_ports
cat /proc/sys/net/ipv4/ip_local_reserved_ports
echo 40000 40001 40002 > /proc/sys/net/ipv4/ip_local_reserved_ports
cat /proc/sys/net/ipv4/ip_local_reserved_ports
echo 40000,40001 40002 > /proc/sys/net/ipv4/ip_local_reserved_ports
cat /proc/sys/net/ipv4/ip_local_reserved_ports
--Boundary-00=_uVRhL6R0Ci1mtjv--
