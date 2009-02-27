Return-Path: <linux-kernel-owner+w=401wt.eu-S1759090AbZB0H0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759090AbZB0H0Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 02:26:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757591AbZB0HZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 02:25:58 -0500
Received: from an-out-0708.google.com ([209.85.132.251]:62058 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757406AbZB0HZ4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 02:25:56 -0500
MIME-Version: 1.0
In-Reply-To: <49A70245.9010405@hp.com>
References: <49A5ADB3.2010709@hp.com> <28797.1235599858@death.nxdomain.ibm.com>
	 <20090225.141430.166906161.davem@davemloft.net>
	 <49A6C6ED.3070801@hp.com> <22876.1235672073@death.nxdomain.ibm.com>
	 <49A6ED6D.3090508@hp.com> <7418.1235679608@death.nxdomain.ibm.com>
	 <49A70245.9010405@hp.com>
Date: Fri, 27 Feb 2009 02:25:54 -0500
Message-ID: <f73f7ab80902262325q2779f3f5y4870bc30a062971d@mail.gmail.com>
Subject: Re: [PATCH v2] bonding: move IPv6 support into a separate kernel 
	module
From: Kyle Moffett <kyle@moffetthome.net>
To: Vlad Yasevich <vladislav.yasevich@hp.com>
Cc: Jay Vosburgh <fubar@us.ibm.com>, Brian Haley <brian.haley@hp.com>,
       David Miller <davem@davemloft.net>, arvidjaar@mail.ru,
       chuck.lever@oracle.com, tytso@mit.edu, Valdis.Kletnieks@vt.edu,
       rjw@sisk.pl, netdev@vger.kernel.org,
       bonding-devel@lists.sourceforge.net, jamagallon@ono.com,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 26, 2009 at 3:57 PM, Vlad Yasevich
<vladislav.yasevich@hp.com> wrote:
>
> Yes.  The bitmask to disable certain family can be useful, but it's orthogonal
> the issue of IPv6 support.  As you said, it can be used to disable
> any address family that user wishes.  The slight issue with this might
> be, should the settings affect already create sockets?
>
> I guess it comes down how many levels of control to do we want to provide.
> Things that have been suggested so far:
>        1) Global on/off switch (i.e module parameter)
>        2) Per interface on/off switch (currently exists, but has bugs).
>        3) Socket on/off switch (i.e blocker bitmask)
>
> I think numbers 1 and 2 turn off the IPv6 protocol on the wire, while number
> 3 turns off the interface to the user.  The two can be done independent.

I feel extremely nervous about people discussing disabling IPv6 going
forward.  Current estimates are that the first RIRs will begin to
exhaust their address spaces (after IANA's address space is exhausted)
early in 2011.  If you consider that any change probably won't be in a
released kernel until June or so, there would be all of 18 months left
until IPv6 is *required* to contact some hosts on the internet.

At this point in time, anyone looking at "disabling" IPv6 should be
doing so with standard firewall rules *exactly* the same way that they
would disable IPv4 traffic; adding rules using ip6tables or ebtables
is easy.

You could simply drop all IPv6 ethernet frames:
  ebtables -P INPUT ACCEPT
  ebtables -A INPUT -p IPv6 -j DROP
  ebtables -P FORWARD ACCEPT
  ebtables -A FORWARD -p IPv6 -j DROP
  ebtables -P OUTPUT ACCEPT
  ebtables -A OUTPUT -p IPv6 -j DROP

Alternatively for a per-interface switch you could "ebtables -A INPUT
-i eth4 -p IPv6 -j DROP", etc...

You could also do this instead (this includes IPv6 tunnels and whatnot):
  ip6tables -t raw -P INPUT DROP
  ip6tables -t raw -P OUTPUT DROP

This allows programs which have been written to use AF_INET6 even for
IPv4 sockets to continue to function appropriately (and there are at
least a few).

Cheers,
Kyle Moffett
