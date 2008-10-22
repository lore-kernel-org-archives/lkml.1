Return-Path: <linux-kernel-owner+w=401wt.eu-S1757142AbYJVQ3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757142AbYJVQ3h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 12:29:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756785AbYJVQ3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 12:29:24 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:35593 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756790AbYJVQ3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 12:29:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Jbm4OJAT/TOlz+Bn89tyWd7BYxSyO+RuBUgHOdmnUDvy7hwMH4ZTFaFUS5AOP910/h
         3jHf3hsmC17C1tTj+ezvYDfyWM4F77fVajPrfIH8TUdcWjJhwFVTbjyWuypHB5IBZf2N
         Dk1Td32MJfhNd+ocp0XP1suxYPiXk6MlZYh9I=
Message-ID: <4807377b0810220929v5906b42bgf9d63215370e5ab5@mail.gmail.com>
Date: Wed, 22 Oct 2008 09:29:21 -0700
From: "Jesse Brandeburg" <jesse.brandeburg@gmail.com>
To: "Sanjoy Mahajan" <sanjoy@mit.edu>
Subject: Re: e1000e fails after several S3 resumes (2.6.26 Debian, TP T60)
Cc: linux-kernel@vger.kernel.org, "NetDEV list" <netdev@vger.kernel.org>,
       e1000-devel@lists.sourceforge.net
In-Reply-To: <E1Ksdli-0005Os-MP@approx.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <E1Ksdli-0005Os-MP@approx.mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

added netdev, and maintainer's list.

On Wed, Oct 22, 2008 at 6:28 AM, Sanjoy Mahajan <sanjoy@mit.edu> wrote:
> Once in a while after resuming from S3 sleep, the Ethernet driver
> gets confused, whereupon dhcp'ing for an IP address fails, e.g.
>
>  /* doing the dhcp: */
>  Listening on LPF/eth0/00:16:41:52:50:de
>  Sending on   LPF/eth0/00:16:41:52:50:de
>  Sending on   Socket/fallback
>  DHCPDISCOVER on eth0 to 255.255.255.255 port 67 interval 7
>  /* and so on with various intervals */

ethtool -d ethX at this point might be interesting, also we have a
debug tool called ethregs that dumps all the registers of the adapter
that would help isolate the difference in the hardware configuration.
run it once you've hung after sending a few dhcp, and then again after
you reload the driver and things are working. You can download ethregs
at prdownloads.sourceforge.net/e1000

you'll have to build ethregs which I haven't tried to do on debian,
but it should be possible.

> I workaround it with
>
>  modprobe -rv e1000e ; modprobe -v e1000e
> (the '-v' options to make sure the module does vanish and return)

an ethtool -r eth0 might be sufficient.

> and then try again to get an address, which works.  A similar failure
> mode happens with the iwl3945 driver (and a similar workaround usually
> succeeds).
>
> How can I debug this issue the next time that it happens (it's about
> once every two weeks)?  Using 'ethtool' or 'lspci -vvvv'?

yes... :-)

>  $ uname -a
>  Linux approx 2.6.26-1-686 #1 SMP Thu Oct 9 15:18:09 UTC 2008 i686 GNU/Linux
>
> It's Debian unstable's kernel 2.6.26 based on 2.6.26.4.  The laptop is a
> Thinkpad T60 whose network controllers are given by lspci as
>
>  02:00.0 Ethernet controller: Intel Corporation 82573L Gigabit Ethernet Controller
>  03:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG [Golan] Network Connection (rev 02)
>
> Could it be caused by the kernel (and modules) getting upgraded
> underneath a running system?  In which case I'll just 'not do that
> again' as the simplest fix, and reboot after a kernel upgrade.  My
> installed kernel is based on 2.6.26.6, but the running kernel is based
> on 2.6.26.4 [where based on means 'with Debian's patches'].

no, if the kernel version changes, the modules that go with it are
only compatible with that version and would not be loaded
accidentally.  Also, e1000e does not get unloaded during S3 suspend,
but we do take a different init path.

There is also lots of opportunity for BIOS bugs to be effecting things
so please make sure that you have the latest bios.

Jesse
