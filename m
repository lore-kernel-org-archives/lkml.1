Return-Path: <linux-kernel-owner+w=401wt.eu-S1759034AbYBPAyD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759034AbYBPAyD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 19:54:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756034AbYBPAxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 19:53:54 -0500
Received: from qmta07.emeryville.ca.mail.comcast.net ([76.96.30.64]:44292 "EHLO
	QMTA07.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755071AbYBPAxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 19:53:53 -0500
X-Authority-Analysis: v=1.0 c=1 a=TEGKNp2qDdgA:10 a=4NgvHEp8MUIQUfoRQ2sA:9
 a=bbVOsrVf5rUawziPvE07dBMANPwA:4 a=iYlkOlhu7C0A:10
Subject: Re: [2.6.25-rc1] jerky mouse cursor and randoooom key repeats
From: Chris Holvenstot <cholvenstot@comcast.net>
To: elendil@planet.nl
Cc: Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 15 Feb 2008 18:53:39 -0600
Message-Id: <1203123219.6176.36.camel@popeye>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frans & Pavel;

I too saw the random key repeats you are seeing with 2.6.25-rc1 -
however, I saw it (or something very much like the problem you are
reporting - I am not smart enough to determine if the root cause is the
same) with 2.6.25-git15

A number of corrispondents on this list offered troubleshooting
suggestions, most of which centered arund the high performance timer.
If you too feel that the issue you are seeing might be releated to the
one I saw the following clips from the email I received might be of
interest to you.


>From Jiri Kosina:

It could be some timing problem. Does this happen also in console, or 
only when running X?

Could you please try to

- boot with 'nohpet' kernel parameter
- taskset -p 0x00000002 <pid_of_Xserver> if this is a multi-CPU/core 
  machine and you are experiencing the problems only in X


>From Thomas Gleixner:

Can you please apply the following patch, boot w/o nohpet and provide
the dmesg output ?



diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 429d084..4e98241 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -375,8 +375,10 @@ int __init hpet_enable(void)
 {
        unsigned long id;
 
-       if (!is_hpet_capable())
+       if (!is_hpet_capable()) {
+               printk(KERN_INFO "HPET not available\n");
                return 0;
+       }
 
        hpet_set_mapping();
 
@@ -392,6 +394,7 @@ int __init hpet_enable(void)
         * information and the number of channels
         */
        id = hpet_readl(HPET_ID);
+       printk(KERN_INFO "HPET available. ID = %lx\n", id);
 
 #ifdef CONFIG_HPET_EMULATE_RTC
        /*
@@ -412,6 +415,7 @@ int __init hpet_enable(void)
        return 0;
 
 out_nohpet:
+       printk(KERN_INFO "HPET disabled\n");
        hpet_clear_mapping();
        boot_hpet_disable = 1;
        return 0;


I have been trying to narrow it down using bisect (my first attempt at
using this utility) with mixed results - just when I think I understand
where the problem was introduced I hit a brick wall.

However, you comment on system loading may have turned the old light
bulb on - that is one area where I have not been consistant.

Chris


