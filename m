Return-Path: <linux-kernel-owner+w=401wt.eu-S1751612AbXC3R17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751612AbXC3R17 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 13:27:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751979AbXC3R17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 13:27:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:42508 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612AbXC3R16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 13:27:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,354,1170662400"; 
   d="scan'208"; a="66522740:sNHT24264765"
Message-ID: <460D4896.9090302@intel.com>
Date: Fri, 30 Mar 2007 10:27:50 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Mail/News 1.5.0.10 (X11/20070311)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@sw.ru>
CC: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: 2.6.21-rc5-mm3: fix e1000 compilation
References: <20070330085029.GA6556@localhost.sw.ru>	<460D2108.1080101@intel.com>	<20070330100104.9b770cd8.akpm@linux-foundation.org> <20070330100709.44127796.randy.dunlap@oracle.com>
In-Reply-To: <20070330100709.44127796.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Mar 2007 17:27:51.0139 (UTC) FILETIME=[BE287B30:01C772F0]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Fri, 30 Mar 2007 10:01:04 -0700 Andrew Morton wrote:
> 
>> On Fri, 30 Mar 2007 07:39:04 -0700 "Kok, Auke" <auke-jan.h.kok@intel.com> wrote:
>>
>>> Alexey Dobriyan wrote:
>>>>   CC [M]  drivers/net/e1000/e1000_main.o
>>>> drivers/net/e1000/e1000_main.c: In function 'e1000_tso':
>>>> drivers/net/e1000/e1000_main.c:2968: error: dereferencing pointer to incomplete type
>>>> 	...
>>>>
>>> can you send me your config? I'd like to see why nobody here didn't spot this on 
>>> any of our tests.
>>>
>> test.kernel.org got thoroughly broken by e1000, but Alexey's patch fixed things
>> up.
> 
> My daily/nightly builds were also broken by it...

turns out that NETIF_F_TSO6 is defined even if CONFIG_IPV6 is turned off, which 
is what broke e1000. That in itself might be a problem. Perhaps this should be 
fixed in netdevice.h (gratuitous bad inline patch below) but I'm not sure if 
people would appreciate this, as it's rather ugly, and it gets all horrible when 
people disable TCP protocol support...

In any case, I was not suspecting this at all. The patch to e1000 is fine with me.

Auke


---
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 1a52854..f077137 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -331,10 +331,16 @@ struct net_device
  #define NETIF_F_UFO            (SKB_GSO_UDP << NETIF_F_GSO_SHIFT)
  #define NETIF_F_GSO_ROBUST     (SKB_GSO_DODGY << NETIF_F_GSO_SHIFT)
  #define NETIF_F_TSO_ECN        (SKB_GSO_TCP_ECN << NETIF_F_GSO_SHIFT)
+#ifdef CONFIG_IPV6
  #define NETIF_F_TSO6           (SKB_GSO_TCPV6 << NETIF_F_GSO_SHIFT)
+#endif

         /* List of features with software fallbacks. */
+#ifdef CONFIG_IPV6
  #define NETIF_F_GSO_SOFTWARE   (NETIF_F_TSO | NETIF_F_TSO_ECN | NETIF_F_TSO6)
+#else
+#define NETIF_F_GSO_SOFTWARE   (NETIF_F_TSO | NETIF_F_TSO_ECN)
+#endif

  #define NETIF_F_GEN_CSUM       (NETIF_F_NO_CSUM | NETIF_F_HW_CSUM)
  #define NETIF_F_ALL_CSUM       (NETIF_F_IP_CSUM | NETIF_F_GEN_CSUM)
