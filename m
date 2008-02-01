Return-Path: <linux-kernel-owner+w=401wt.eu-S1763174AbYBAFdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763174AbYBAFdS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 00:33:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751245AbYBAFdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 00:33:10 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:60800 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbYBAFdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 00:33:09 -0500
Date: Fri, 1 Feb 2008 05:33:05 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Santiago Garcia Mantinan <manty@manty.net>
Cc: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org
Subject: Re: dl2k stopped working on 2.6.24
Message-ID: <20080201053305.GK27894@ZenIV.linux.org.uk>
References: <20080125211153.GA10203@dis.manty.net> <20080128233334.GA14326@dis.manty.net> <20080131215541.GA22018@dis.manty.net> <20080131213711.GM8953@1wt.eu> <20080201000442.GA26357@dis.manty.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080201000442.GA26357@dis.manty.net>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2008 at 01:04:42AM +0100, Santiago Garcia Mantinan wrote:
> > I have today compiled dl2k from git, the version with the 2007-12-23 patches
> > from Al Viro: dl2k endianness fixes (.24 fodder?) Right before the Al Viro
> > patches. This seems to be working perfectly on my system.
> 
> Ok, I've been applying Al's patches one by one, everything went fine till I
> applied the "dl2k: MSCR, MSSR, ESR, PHY_SCR fixes" patch. With this patch I
> experimented the behaviour I commented on my first message.
> 
> I don't know what else to try now, any ideas?
> 
> Regards...

Very interesting.  Relevant part seems to be
-               mscr.image = mii_read (dev, phy_addr, MII_MSCR);
-               mssr.image = mii_read (dev, phy_addr, MII_MSSR);
-               if (mscr.bits.media_1000BT_FD & mssr.bits.lp_1000BT_FD) {
+               mscr = mii_read (dev, phy_addr, MII_MSCR);
+               mssr = mii_read (dev, phy_addr, MII_MSSR);
+               if (mscr & MII_MSCR_1000BT_FD && mssr & MII_MSSR_LP_1000BT_FD) {
                        np->speed = 1000;
                        np->full_duplex = 1;
                        printk (KERN_INFO "Auto 1000 Mbps, Full duplex\n");
-               } else if (mscr.bits.media_1000BT_HD & mssr.bits.lp_1000BT_HD) {
+               } else if (mscr & MII_MSCR_1000BT_HD && mssr & MII_MSSR_LP_1000BT_HD) {
                        np->speed = 1000;
                        np->full_duplex = 0;
                        printk (KERN_INFO "Auto 1000 Mbps, Half duplex\n");

More specifically, this:
-               if (mscr.bits.media_1000BT_FD & mssr.bits.lp_1000BT_FD) {
+               if (mscr & MII_MSCR_1000BT_FD && mssr & MII_MSSR_LP_1000BT_FD) {

We used to have mscr declared as
typedef union t_MII_MSCR {
       u16 image;
       struct {
               u16 _bit_7_0:8; // bit 7:0
               u16 media_1000BT_HD:1;  // bit 8
               u16 media_1000BT_FD:1;  // bit 9
               u16 port_type:1;        // bit 10
               u16 cfg_value:1;        // bit 11
               u16 cfg_enable:1;       // bit 12
               u16 test_mode:3;        // bit 15:13
       } bits;
} MSCR_t, *PMSCR_t;

and mssr as
typedef union t_MII_MSSR {
       u16 image;
       struct {
               u16 idle_err_count:8;   // bit 7:0
               u16 _bit_9_8:2; // bit 9:8
               u16 lp_1000BT_HD:1;     // bit 10
               u16 lp_1000BT_FD:1;     // bit 11
               u16 remote_rcv_status:1;        // bit 12
               u16 local_rcv_status:1; // bit 13
               u16 cfg_resolution:1;   // bit 14
               u16 cfg_fault:1;        // bit 15
       } bits;
} MSSR_t, *PMSSR_t;

so it looks like these constants had not been right...  Damn right, they
had not - 
        MII_MSSR_LP_1000BT_HD = 0x0800,
        MII_MSSR_LP_1000BT_FD = 0x0400,
and that has HD at bit 11 and FD at bit 10 - swapped, IOW.  Driver had them
defined wrong all along, but they were not used until now, so bug had not been
noticed.

See if the patch below takes care of all of that:

diff --git a/drivers/net/dl2k.h b/drivers/net/dl2k.h
index d66c605..266ec87 100644
--- a/drivers/net/dl2k.h
+++ b/drivers/net/dl2k.h
@@ -388,8 +388,8 @@ enum _mii_mssr {
 	MII_MSSR_CFG_RES = 0x4000,
 	MII_MSSR_LOCAL_RCV_STATUS = 0x2000,
 	MII_MSSR_REMOTE_RCVR = 0x1000,
-	MII_MSSR_LP_1000BT_HD = 0x0800,
-	MII_MSSR_LP_1000BT_FD = 0x0400,
+	MII_MSSR_LP_1000BT_FD = 0x0800,
+	MII_MSSR_LP_1000BT_HD = 0x0400,
 	MII_MSSR_IDLE_ERR_COUNT = 0x00ff,
 };
 

