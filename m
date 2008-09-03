Return-Path: <linux-kernel-owner+w=401wt.eu-S1756031AbYICTRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031AbYICTRS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 15:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753413AbYICTRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 15:17:08 -0400
Received: from mail.gmx.net ([213.165.64.20]:56908 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753286AbYICTRH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 15:17:07 -0400
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX1/q9lcSMHjqch+RP2W1hrsO1XkfKa5AcUDzStBT5I
	6tKqoNu/ah/BjT
From: Stefan Lippers-Hollmann <s.L-H@gmx.de>
To: Greg KH <gregkh@suse.de>
Subject: Re: [patch 29/42] net: Unbreak userspace which includes linux/mroute.h
Date: Wed, 3 Sep 2008 21:16:56 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       "David S. Miller" <davem@davemloft.net>
References: <20080903171927.534216229@mini.kroah.org> <20080903172624.GD7731@suse.de>
In-Reply-To: <20080903172624.GD7731@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200809032117.00425.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Mittwoch, 3. September 2008, Greg KH wrote:
> 2.6.26-stable review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> 
> From: David S. Miller <davem@davemloft.net>
> 
> [ Upstream commit 7c19a3d280297d43ef5ff7c6b205dc208a16d3d1 ]
> 
> This essentially reverts two commits:
> 
> 1) 2e8046271f68198dd37451017c1a4a2432e4ec68 ("[IPV4] MROUTE: Move PIM
>    definitions to <linux/pim.h>.")
> 
> and
> 
> 2) 80a9492a33dd7d852465625022d56ff76d62174d ("[IPV4] MROUTE: Adjust
>    include files for user-space.")
> 
> which broke userpsace, in particular the XORP build as reported by
> Jose Calhariz, the debain package maintainer for XORP.
> 
> Nothing originally in linux/mroute.h was exported to userspace
> ever, but some of this stuff started to be when it was moved into
> this new linux/pim.h, and that was wrong.  If we didn't provide these
> definitions for 10 years we can reasonable expect that applications
> defined this stuff locally or used GLIBC headers providing the
> protocol definitions.  And as such the only result of this can
> be conflict and userland build breakage.
> 
> The commit #1 had such a short and terse commit message, that we
> cannot even know why such a move and set of new userland exports were
> even made.
> 
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  include/linux/Kbuild   |    1 -
>  include/linux/mroute.h |   25 +++++++++++++++++++++----
>  include/linux/pim.h    |   45 ---------------------------------------------
>  3 files changed, 21 insertions(+), 50 deletions(-)

This patch is missing to remove the include for linux/pim.h in 
net/ipv6/ip6mr.c, leading to the following build failure:

  CC [M]  net/ipv6/ip6mr.o
net/ipv6/ip6mr.c:48:23: error: linux/pim.h: Datei oder Verzeichnis nicht gefunden
net/ipv6/ip6mr.c: In function ‘pim6_rcv’:
net/ipv6/ip6mr.c:354: error: dereferencing pointer to incomplete type
net/ipv6/ip6mr.c:358: error: dereferencing pointer to incomplete type
net/ipv6/ip6mr.c:358: error: ‘PIM_VERSION’ undeclared (first use in this function)
net/ipv6/ip6mr.c:358: error: (Each undeclared identifier is reported only once
net/ipv6/ip6mr.c:358: error: for each function it appears in.)
net/ipv6/ip6mr.c:358: error: ‘PIM_REGISTER’ undeclared (first use in this function)
net/ipv6/ip6mr.c:359: error: dereferencing pointer to incomplete type
net/ipv6/ip6mr.c:359: error: ‘PIM_NULL_REGISTER’ undeclared (first use in this function)
net/ipv6/ip6mr.c:360: error: dereferencing pointer to incomplete type
net/ipv6/ip6mr.c:366: error: dereferencing pointer to incomplete type
net/ipv6/ip6mr.c:370: error: dereferencing pointer to incomplete type
make[2]: *** [net/ipv6/ip6mr.o] Fehler 1
make[1]: *** [net/ipv6] Fehler 2
make: *** [net] Fehler 2

Regards
	Stefan Lippers-Hollmann
