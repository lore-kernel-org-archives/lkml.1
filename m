Return-Path: <linux-kernel-owner+w=401wt.eu-S1758247AbYEQT4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758247AbYEQT4T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 15:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753761AbYEQT4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 15:56:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54760 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752645AbYEQT4G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 15:56:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tobias Diedrich <ranma+kernel@tdiedrich.de>
Subject: Re: hibernate event order question
Date: Sat, 17 May 2008 21:56:12 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ayaz Abdulla <aabdulla@nvidia.com>
References: <20080517175046.GA9032@yamamaya.is-a-geek.org>
In-Reply-To: <20080517175046.GA9032@yamamaya.is-a-geek.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805172156.12686.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 17 of May 2008, Tobias Diedrich wrote:
> Hello,

Hi,

> for some time now I had the problem that after a suspend to disk
> network connectivitiy was down and also wake-on-lan would not work.
> 
> First a bit of information, for the real question please see (*)
> below.
> 
> Now I just found the ethtool -d (register dump) option
> and decided I want to try to debug this long-standing bug:
> http://bugzilla.kernel.org/show_bug.cgi?id=8381
> 
> I already found out why network connectivity is down after resume:
> 
> The interfaces eth0 and eth1 are bridged into br0.
> The bridging code sets the interfaces into promiscous mode, but this
> is not properly restored after resume.
> This bug is easily fixable by calling nv_set_multicast(dev) either
> from within nv_open() or after nv_open() in nv_resume().
> 
> The second problem (does not wol after s2disk) is still unsolved
> though.  However I have found that wake-on-lan works fine if I
> "rmmod forcedeth" before suspending.  This is even a usable
> workaround for me, since the bridge device stays configured and I
> just have to reload forcedeth and readd the interfaces to the bridge
> after resume.
> 
> (*)
> Now for my question:
> AFAICS the ordering of events is as follows:
> 1) User reqests hibernate
> 2) Tasks are frozen
> 3) Device suspend callbacks get called
> 4) Device resume callbacks get called
> 5) Memory image is written to disk

6) Device suspend callbacks get called again to prepare for the system sleep
   state.

> Now, the problem I see with this is that while step 3) prepares the
> device for suspend (and wake-on-lan), step 4) may undo some of this
> preparation.
> 
> In my case, I think the fix for the first bug (promiscous mode does
> not get restored on resume) breaks wake-on-lan (since the new value
> of NvRegPacketFilterFlags may be incompatible with wake-on-lan).
> 
> Shouldn't there be a 'prepare for poweroff'-callback, which gets called
> before the system is powered off for real?

Yes, it should and it's called in recent kernels.

> --- linux-2.6.26-rc2/drivers/net/forcedeth.c	2008-05-17 14:22:06.000000000 +0200
> +++ linux-2.6.26-rc2/drivers/net/forcedeth.c	2008-05-17 19:48:56.000000000 +0200
> @@ -5823,6 +5823,7 @@
>  	writel(txreg, base + NvRegTransmitPoll);
>  
>  	rc = nv_open(dev);
> +	nv_set_multicast(dev);
>  out:
>  	return rc;
>  }

Thanks for the patch, it looks sane to me.

Rafael
