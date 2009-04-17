Return-Path: <linux-kernel-owner+w=401wt.eu-S1760251AbZDQA6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760251AbZDQA6b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 20:58:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753180AbZDQA6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 20:58:19 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:2971 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377AbZDQA6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 20:58:18 -0400
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
Date: Thu, 16 Apr 2009 17:58:04 -0700
From: "Matt Carlson" <mcarlson@broadcom.com>
To: "David Miller" <davem@davemloft.net>
cc: "rjw@sisk.pl" <rjw@sisk.pl>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kernel-testers@vger.kernel.org" <kernel-testers@vger.kernel.org>,
       "Benjamin Li" <benli@broadcom.com>,
       "Matthew Carlson" <mcarlson@broadcom.com>,
       "Michael Chan" <mchan@broadcom.com>, "holt@sgi.com" <holt@sgi.com>,
       James.Bottomley@HansenPartnership.com
Subject: Re: [Bug #13111] Linux 2.6.30-rc1 tg3 endian issues with MAC
 addresses on BCM5701
Message-ID: <20090417005804.GA16432@xw6200.broadcom.net>
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera>
 <nY3-4PrO6XH.A.LI.Sw85JB@chimera>
 <20090416.174310.260350758.davem@davemloft.net>
MIME-Version: 1.0
In-Reply-To: <20090416.174310.260350758.davem@davemloft.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-WSS-ID: 65F90B973849013323-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 16, 2009 at 05:43:10PM -0700, David Miller wrote:
> From: "Rafael J. Wysocki" <rjw@sisk.pl>
> Date: Thu, 16 Apr 2009 23:45:05 +0200 (CEST)
> 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13111
> > Subject		: Linux 2.6.30-rc1 tg3 endian issues with MAC addresses on BCM5701
> > Submitter	: Robin Holt <holt@sgi.com>
> > Date		: 2009-04-08 7:12 (9 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=e4f341103e4a2b35f56a0f89802f1b1448e8d04b
> > References	: http://marc.info/?l=linux-kernel&m=123917477312823&w=4
> > Handled-By	: Matt Carlson <mcarlson@broadcom.com>
> 
> We're half-way to a fix for this, see the commit below.
> 
> But we're not completely finished, so keep this entry open.

Actually, I think we do have a fix for this.  James and Robin both
reported that the test patch I sent out worked for them.  I'm preparing
a patchset for submission now.

James, Robin, can you confirm that you performed your tests with David's
patch reverted?

> commit 0d489ffb76de0fe804cf06a9d4d11fa7342d74b9
> Author: James Bottomley <James.Bottomley@HansenPartnership.com>
> Date:   Mon Apr 13 14:31:51 2009 -0700
> 
>     tg3: fix big endian MAC address collection failure
>     
>     We noticed on parisc that our broadcoms all swapped MAC addresses going
>     from 2.6.29 to 2.6.30-rc1:
>     
>     Apr 11 07:48:24 ion kernel: eth0: Tigon3 [partno(BCM95700A6) rev 0105] (PCI:66MHz:64-bit) MAC address 00:30:6e:4b:15:59
>     Apr 13 07:34:34 ion kernel: eth0: Tigon3 [partno(BCM95700A6) rev 0105] (PCI:66MHz:64-bit) MAC address 00:00:59:15:4b:6e
>     
>     The problem patch is:
>     
>     commit 6d348f2c1e0bb1cf7a494b51fc921095ead3f6ae
>     Author: Matt Carlson <mcarlson@broadcom.com>
>     Date:   Wed Feb 25 14:25:52 2009 +0000
>     
>         tg3: Eliminate tg3_nvram_read_swab()
>     
>     With the root cause being the use of memcpy to set the mac address:
>     
>        memcpy(&dev->dev_addr[0], ((char *)&hi) + 2, 2);
>        memcpy(&dev->dev_addr[2], (char *)&lo, sizeof(lo));
>     
>     This might work on little endian machines, but it can't on big endian
>     ones.  You have to use the original setting mechanism to be correct on
>     all architectures.
>     
>     The attached patch fixes parisc.
>     
>     Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
>     Signed-off-by: David S. Miller <davem@davemloft.net>
> 

