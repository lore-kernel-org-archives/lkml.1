Return-Path: <linux-kernel-owner+w=401wt.eu-S933093AbZDCPb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933093AbZDCPb3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 11:31:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760619AbZDCPbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 11:31:15 -0400
Received: from mail-qy0-f118.google.com ([209.85.221.118]:52687 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755646AbZDCPbO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 11:31:14 -0400
MIME-Version: 1.0
In-Reply-To: <200903272109.21259.rjw@sisk.pl>
References: <200903261920.32173.tvrtko@ursulin.net>
	 <200903270801.46712.tvrtko@ursulin.net>
	 <200903271255.36429.rjw@sisk.pl> <200903272109.21259.rjw@sisk.pl>
Date: Fri, 3 Apr 2009 08:24:12 -0700
Message-ID: <9ae48b020904030824o1f94831asb60f979b3e489a8b@mail.gmail.com>
Subject: Re: [Regression in 2.6.29] forcedeth doesn't work after resume from 
	hibernation (was: Re: Resume after hibernation regression in 2.6.29)
From: Ed Swierk <eswierk@aristanetworks.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Tvrtko A. Ursulin" <tvrtko@ursulin.net>, Pavel Machek <pavel@ucw.cz>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       Tobias Diedrich <ranma+kernel@tdiedrich.de>,
       Ayaz Abdulla <aabdulla@nvidia.com>, netdev <netdev@vger.kernel.org>,
       Arthur Jones <ajones@riverbed.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 27, 2009 at 1:09 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> I was able to reproduce the problem and identify the commit that broke the
> resume of forcedeth, which turned out to be:
>
> commit cb52deba12f27af90a46d2f8667a64888118a888
> Author: Ed Swierk <eswierk@arastra.com>
> Date:   Mon Dec 1 12:24:43 2008 +0000
>
>    forcedeth: power down phy when interface is down
>
>    Signed-off-by: Ed Swierk <eswierk@arastra.com>
>    Tested-by: Arthur Jones <ajones@riverbed.com>
>    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>    Signed-off-by: David S. Miller <davem@davemloft.net>
>
> Since I have no slightest idea of what this commit is supposed to achieve,
> I can only ask for reverting it.  It reverts cleanly, BTW.

The change causes forcedeth to bring down the physical link when an
interface goes down; leaving it up causes the switch at the other end
to think the port is still active, with potentially random speed and
duplex parameters.

It's possible that the forcedeth driver needs to reset autonegotiation
after bringing it up the link again.

Can you please try this on a 2.6.29 kernel that's exhibiting the
symptoms you describe, after resuming the machine from hibernation:

  ethtool -s eth1 autoneg off speed 100 duplex full
  ethtool -s eth1 autoneg on

This should reset autonegotiation manually and bring the link. Let me
know how it goes.

Thanks,
--Ed
