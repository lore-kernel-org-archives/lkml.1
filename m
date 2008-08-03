Return-Path: <linux-kernel-owner+w=401wt.eu-S1759542AbYHCUHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759542AbYHCUHh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 16:07:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753754AbYHCUH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 16:07:29 -0400
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:63625 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753004AbYHCUH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 16:07:28 -0400
Message-ID: <48960FFE.1020408@lwfinger.net>
Date: Sun, 03 Aug 2008 15:07:26 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Chr <chunkeey@web.de>
CC: "David S. Miller" <davem@davemloft.net>,
       wireless <linux-wireless@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: p54usb broken by commit b19fa1f
References: <4893CF3D.1070504@lwfinger.net> <200808021457.46438.chunkeey@web.de>
In-Reply-To: <200808021457.46438.chunkeey@web.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chr wrote:
> On Saturday 02 August 2008 05:06:37 Larry Finger wrote:
>> In testing 2.6.27-rc1, I found that p54usb caused my machine to freeze. A
>> few times, I was able to use the KDE system status applet to see that the
>> system was using essentially 100% of the CPU's. One other time, the system
>> responded a little - enough for me to see tha wpa_supplicant was consuming
>> 100% of the my AMD Turion 64 X2 running an x86_64 kernel. From bisection,
>> the problem is due to
>>
>> commit b19fa1fa91845234961c64dbd564671aa7c0fd27
>> Author: David S. Miller <davem@davemloft.net>
>> Date:   Tue Jul 8 23:14:24 2008 -0700
>>
>>      net: Delete NETDEVICES_MULTIQUEUE kconfig option.
>>
>>      Multiple TX queue support is a core networking feature.
>>
>>      Signed-off-by: David S. Miller <davem@davemloft.net>
>>
>> Obviously, something in the driver cannot handle multiqueues, but I
>> have not found anything, and I have not been able to get any logged events
>> that show what is going wrong.
>>
> 
> Hmm that's a bit odd as my p54usb-adapter seems to work usual with
> 2.6.27-rc1?!... That said: it doesn't work nearly as stable as the
> minipci card that I have too. Is there anyone else who can confirm
> that this problem is specific to the p54 driver & 2.6.27-rc1?

The problem is triggered by the following section:

         if (priv->fw_var >= 0x300) {
                 /* Firmware supports QoS, use it! */
                 priv->tx_stats[0].limit = 3;
                 priv->tx_stats[1].limit = 4;
                 priv->tx_stats[2].limit = 3;
                 priv->tx_stats[3].limit = 1;
                 dev->queues = 4;
         }

If fw_var is less than 0x300, then the bug does not trigger. On my system, if I 
change the number of queues to 1, then all is OK.

Larry
