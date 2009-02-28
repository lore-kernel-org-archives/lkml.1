Return-Path: <linux-kernel-owner+w=401wt.eu-S1754072AbZB1IXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072AbZB1IXv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 03:23:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752028AbZB1IXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 03:23:43 -0500
Received: from mail-in-03.arcor-online.net ([151.189.21.43]:57840 "EHLO
	mail-in-03.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751761AbZB1IXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 03:23:42 -0500
X-DKIM: Sendmail DKIM Filter v2.6.0 mail-in-07.arcor-online.net ADF0F3CA47A
From: Prakash Punnoor <prakash@punnoor.de>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] pci: don't enable too many HT MSI mapping
Date: Sat, 28 Feb 2009 09:25:55 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc6; KDE/4.2.0; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Robert Hancock <hancockrwd@gmail.com>, david@lang.hm,
       Matthew Wilcox <matthew@wil.cx>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
References: <alpine.DEB.1.10.0902171419000.26625@asgard.lang.hm> <200902270752.44078.prakash@punnoor.de> <49A8541C.4030601@kernel.org>
In-Reply-To: <49A8541C.4030601@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200902280925.56450.prakash@punnoor.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Freitag 27 Februar 2009 21:59:08 Yinghai Lu wrote:
> Prakash Punnoor wrote:
> > On Dienstag 24 Februar 2009 18:37:35 Jesse Barnes wrote:
> >> On Monday, February 23, 2009 11:51:59 am Yinghai Lu wrote:
> >>> Impact: fix bug
> >>>
> >>> Prakash reported that his c51-mcp51 system ondie sound card doesn't
> >>> work MSI but if he hack out the HT-MSI on mcp51, the MSI will work well
> >>> with sound card.
> >>>
> >>> this patch rework the nv_msi_ht_cap_quirk()
> >>> and will only enable ht_msi on own root device and try to avoid to
> >>> enable ht_msi on device following that root dev
> >>>
> >>> Reported-by: Prakash Punnoor <prakash@punnoor.de>
> >>> Tested-by: Prakash Punnoor <prakash@punnoor.de>
> >>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> >>
> >> Thanks Yinghai & Prakash, applied this fix to my for-linus branch.
> >
> > I am very sorry, but I made a mistake testing this patch. I messed up my
> > kernels and got a false positive and only noticed this now. The patch
> > does NOT work and even makes things worse:
> >
> > dmesg|grep HT
> > pci 0000:00:09.0: Found disabled HT MSI Mapping
> > pci 0000:00:09.0: Enabling HT MSI Mapping
> > pci 0000:00:09.0: Found enabled HT MSI Mapping
> > pci 0000:00:09.0: Found enabled HT MSI Mapping
> > pci 0000:00:09.0: Found enabled HT MSI Mapping
> > pci 0000:00:09.0: Found enabled HT MSI Mapping
> >
> > This is exactly the device which shouldn't be MSI enabled for me. On the
> > other hand, it doesn't enable the needed devices anymore.
>
> please check this one, please power off the system before load the kernel
> with new patch.

Well, the problem now is that MSI doesn't get enabled on the needed host 
bridge 00.0 (device 10de:02f0), so MSI doesn't work at all on my system (but 
also doesn't hang my system.) I have no idea how to differentiate the 00.0 
device from the "forbidden" 09.0 (device 10de:0270) on my system. Perhaps a 
blacklist is really the best? The original patch by NVidia had a white list, 
btw, see also here:
http://kerneltrap.org/mailarchive/linux-kernel/2007/11/25/443612/thread

The output of your current patch:
pci 0000:00:05.0: Boot video device                                                                                               
pci 0000:00:09.0: Found disabled HT MSI Mapping                                                                                   
pci 0000:00:0e.0: Enabling HT MSI Mapping                                                                                         
pci 0000:00:09.0: Found disabled HT MSI Mapping                                                                                   
pci 0000:00:0f.0: Enabling HT MSI Mapping                                                                                         
pci 0000:00:09.0: Found disabled HT MSI Mapping                                                                                   
pci 0000:00:10.0: Enabling HT MSI Mapping                                                                                         
pci 0000:00:09.0: Found disabled HT MSI Mapping                                                                                   
pci 0000:00:10.1: Enabling HT MSI Mapping  

So, ok, MSI gets enabled on the devices as such (good), not enabled on 09.0 
(good), but also not on the needed host bridge 00.0 (bad).

BTW, I noticed a typo in the patch. In ht_disable_msi_mapping you want the 
text to be "Disabling"... instead of
+                       dev_info(&dev->dev, "Enabling HT MSI Mapping\n");

And a minor simplification in ht_check_msi_mapping would be instead of 
+                       if (flags & HT_MSI_FLAGS_ENABLE) {
+                               if (found < 2) {
+                                       found = 2;
+                                       break;
+                               }
+                       }

just

+                       if (flags & HT_MSI_FLAGS_ENABLE) {
+                                found = 2;
+                                break;
+                       }

as it is the only place where found is set to something higher than 1 and then 
the function is exited anyway. Or make the return paths clearer by this change 
from

+       int pos, ttl = 48;
+       int found = 0;
+
+       /* check if there is HT MSI cap or enabled on this device */
+       pos = pci_find_ht_capability(dev, HT_CAPTYPE_MSI_MAPPING);
+       while (pos && ttl--) {
+               u8 flags;
+
+               if (found < 1)
+                       found = 1;
+               if (pci_read_config_byte(dev, pos + HT_MSI_FLAGS,
+                                        &flags) == 0) {
+                       if (flags & HT_MSI_FLAGS_ENABLE) {
+                               if (found < 2) {
+                                       found = 2;
+                                       break;
+                               }
+                       }
+               }
+               pos = pci_find_next_ht_capability(dev, pos,
+                                                 HT_CAPTYPE_MSI_MAPPING);
+       }
+
+       return found;

to

+       int pos, ttl = 48;
+
+       /* check if there is HT MSI cap or enabled on this device */
+       pos = pci_find_ht_capability(dev, HT_CAPTYPE_MSI_MAPPING);
+       if (!pos)
+	        return 0;
+
+       do {
+               u8 flags;
+
+               if (pci_read_config_byte(dev, pos + HT_MSI_FLAGS,
+                                        &flags) == 0) {
+                       if (flags & HT_MSI_FLAGS_ENABLE)
+                                         return 2;
+               }
+               pos = pci_find_next_ht_capability(dev, pos,
+                                                 HT_CAPTYPE_MSI_MAPPING);
+       } while (pos && --ttl);
+
+       return 1;
+}

Then at least I would have to think less, under which conditions found takes 
the values 0, 1 or 2.

Regards,

Prakash
