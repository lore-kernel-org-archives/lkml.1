Return-Path: <linux-kernel-owner+w=401wt.eu-S1756947AbZBEQfF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756947AbZBEQfF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 11:35:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752349AbZBEQey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 11:34:54 -0500
Received: from fk-out-0910.google.com ([209.85.128.189]:33873 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbZBEQex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 11:34:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cpjTBg+iooGhWc324tnZd15PAUPrGAqByUf8W78lqC71Rl7UQ9/HLSntXHiwhD7Y2p
         tEq+ceqDFVxSdBvTkuI5asDG0AAhZ+fygYRjqty/q8jAcesR9iD80JHrd0NMmSoatAK6
         8rB7ioOc1i4EgwWkJt6Vtbjzx1RzGpyKKKYXk=
MIME-Version: 1.0
In-Reply-To: <56e1b5710902050641l5ece10e5hedd11fb3f4292886@mail.gmail.com>
References: <56e1b5710902050641l5ece10e5hedd11fb3f4292886@mail.gmail.com>
Date: Thu, 5 Feb 2009 17:34:50 +0100
Message-ID: <56e1b5710902050834y41d944eeia7e9bec2010f6d71@mail.gmail.com>
Subject: Re: [PATCH]: Cleanup: Remove gcc format string warnings when 
	compiling with -Wformat-security (was: Re: [PATCH] Kbuild: Disable the 
	-Wformat-security gcc flag)
From: Floris Kraak <randakar@gmail.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Robert Hancock <hancockrwd@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Trivial Patch Monkey <trivial@kernel.org>,
       Andreas Schwab <schwab@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 5, 2009 at 3:41 PM, Floris Kraak <randakar@gmail.com> wrote:
> On Thu, Feb 5, 2009 at 7:37 AM, Roland Dreier <rdreier@cisco.com> wrote:
>>  > Just how many of these warnings are showing up? In the cases you
>>  > posted it's presumably no problem, but if the string could either a)
>>  > be potentially set by a malicious user or b) accidentally contain
>>  > printk format characters then this code has a risk that things could
>>  > blow up..
>>
>> I get ~150 of them on an x86 allyesconfig build here (see below).  Many
>> but not all are trivial; some at least appear to be passing in strings
>> that come from random hardware/firmware or DNS names etc (ie there's at
>> least a chance of a '%'); and I didn't exhaustively audit to make sure
>> none of them could print something from an unprivileged user.
>>
>
> Here's the patch that I get when I blindly patch every single location
> that emits this warning.
> As noted before in some cases I'm not 100% sure this is the right way
> to go about it but it certainly is the KISS solution.
>

Looks like I missed a few places. That's what I get for sending
something out before the test build even finishes ;-)

---
Cleanup: Remove gcc format string warnings when compiling with
-Wformat-security (part 2)

When compiling the kernel with an allyesconfig and the gcc flags
-Wformat and -Wformat-security the build process emits 135 warnings
along these lines:

init/main.c:557: warning: format not a string literal and no format arguments
init/initramfs.c:582: warning: format not a string literal and no
format arguments
arch/x86/kernel/dumpstack.c:115: warning: format not a string literal
and no format arguments
...

While many of these warnings are harmless - the format string is
statically set within the kernel itself and is known to not contain
any format qualifiers - a number of them are potentially less so.
This patch fixes all known call sites emitting this warning.

Signed-off-by: Floris Kraak <randakar@gmail.com>
---
diff --git a/drivers/char/hw_random/intel-rng.c
b/drivers/char/hw_random/intel-rng.c
index 5dcbe60..5fb48ea 100644
--- a/drivers/char/hw_random/intel-rng.c
+++ b/drivers/char/hw_random/intel-rng.c
@@ -312,7 +312,7 @@ static int __init intel_init_hw_struct(struct
intel_rng_hw *intel_rng_hw,

 		if (no_fwh_detect)
 			return -ENODEV;
-		printk(warning);
+		printk("%s", warning);
 		return -EBUSY;
 	}

diff --git a/drivers/char/n_hdlc.c b/drivers/char/n_hdlc.c
index bacb3e2..f903fe7 100644
--- a/drivers/char/n_hdlc.c
+++ b/drivers/char/n_hdlc.c
@@ -942,7 +942,7 @@ static int __init n_hdlc_init(void)

 	status = tty_register_ldisc(N_HDLC, &n_hdlc_ldisc);
 	if (!status)
-		printk(hdlc_register_ok);
+		printk("%s", hdlc_register_ok);
 	else
 		printk(hdlc_register_fail, status);

@@ -965,7 +965,7 @@ static void __exit n_hdlc_exit(void)
 	if (status)
 		printk(hdlc_unregister_fail, status);
 	else
-		printk(hdlc_unregister_ok);
+		printk("%s", hdlc_unregister_ok);
 }

 module_init(n_hdlc_init);
diff --git a/drivers/char/riscom8.c b/drivers/char/riscom8.c
index 9af8d74..7392e39 100644
--- a/drivers/char/riscom8.c
+++ b/drivers/char/riscom8.c
@@ -1497,7 +1497,7 @@ static int __init riscom8_init(void)
 	int i;
 	int found = 0;

-	printk(banner);
+	printk("%s", banner);

 	if (rc_init_drivers())
 		return -EIO;
@@ -1507,7 +1507,7 @@ static int __init riscom8_init(void)
 			found++;
 	if (!found)  {
 		rc_release_drivers();
-		printk(no_boards_msg);
+		printk("%s", no_boards_msg);
 		return -EIO;
 	}
 	return 0;
diff --git a/drivers/net/3c505.c b/drivers/net/3c505.c
index 6124605..1b2a9bf 100644
--- a/drivers/net/3c505.c
+++ b/drivers/net/3c505.c
@@ -1287,7 +1287,7 @@ static int __init elp_sense(struct net_device *dev)

 	/* Wait for a while; the adapter may still be booting up */
 	if (elp_debug > 0)
-		printk(stilllooking_msg);
+		printk("%s", stilllooking_msg);

 	if (orig_HSR & DIR) {
 		/* If HCR.DIR is up, we pull it down. HSR.DIR should follow. */
@@ -1312,7 +1312,7 @@ static int __init elp_sense(struct net_device *dev)
 	 * It certainly looks like a 3c505.
 	 */
 	if (elp_debug > 0)
-		printk(found_msg);
+		printk("%s", found_msg);

 	return 0;
 out:
diff --git a/drivers/net/3c515.c b/drivers/net/3c515.c
index 39ac122..4b4724f 100644
--- a/drivers/net/3c515.c
+++ b/drivers/net/3c515.c
@@ -437,7 +437,7 @@ struct net_device *tc515_probe(int unit)

 	if (corkscrew_debug > 0 && !printed) {
 		printed = 1;
-		printk(version);
+		printk("%s", version);
 	}

 	return dev;
diff --git a/drivers/net/at1700.c b/drivers/net/at1700.c
index 72ea6e3..aef90cf 100644
--- a/drivers/net/at1700.c
+++ b/drivers/net/at1700.c
@@ -446,7 +446,7 @@ found:
 	outb(0x00, ioaddr + COL16CNTL);

 	if (net_debug)
-		printk(version);
+		printk("%s", version);

 	memset(lp, 0, sizeof(struct net_local));

diff --git a/drivers/net/cs89x0.c b/drivers/net/cs89x0.c
index ff64976..b992f16 100644
--- a/drivers/net/cs89x0.c
+++ b/drivers/net/cs89x0.c
@@ -620,7 +620,7 @@ cs89x0_probe1(struct net_device *dev, int ioaddr,
int modular)
 		lp->send_cmd = TX_NOW;

 	if (net_debug  &&  version_printed++ == 0)
-		printk(version);
+		printk("%s", version);

 	printk(KERN_INFO "%s: cs89%c0%s rev %c found at %#3lx ",
 	       dev->name,
diff --git a/drivers/net/depca.c b/drivers/net/depca.c
index e4cef49..1fd842e 100644
--- a/drivers/net/depca.c
+++ b/drivers/net/depca.c
@@ -789,7 +789,7 @@ static int __init depca_hw_init (struct net_device
*dev, struct device *device)
 	}

 	if (depca_debug > 1) {
-		printk(version);
+		printk("%s", version);
 	}

 	/* The DEPCA-specific entries in the device structure. */
diff --git a/drivers/net/ewrk3.c b/drivers/net/ewrk3.c
index b852303..2de0379 100644
--- a/drivers/net/ewrk3.c
+++ b/drivers/net/ewrk3.c
@@ -600,7 +600,7 @@ ewrk3_hw_init(struct net_device *dev, u_long iobase)
 	}

 	if (ewrk3_debug > 1) {
-		printk(version);
+		printk("%s", version);
 	}
 	/* The EWRK3-specific entries in the device structure. */
 	dev->open = ewrk3_open;
diff --git a/drivers/net/hamradio/scc.c b/drivers/net/hamradio/scc.c
index c011af7..b7cd05d 100644
--- a/drivers/net/hamradio/scc.c
+++ b/drivers/net/hamradio/scc.c
@@ -2105,7 +2105,7 @@ static int __init scc_init_driver (void)
 {
 	char devname[IFNAMSIZ];
 	
-	printk(banner);
+	printk("%s", banner);
 	
 	sprintf(devname,"%s0", SCC_DriverName);
 	
diff --git a/drivers/net/lne390.c b/drivers/net/lne390.c
index 41cbaae..479970a 100644
--- a/drivers/net/lne390.c
+++ b/drivers/net/lne390.c
@@ -268,7 +268,7 @@ static int __init lne390_probe1(struct net_device
*dev, int ioaddr)
 	ei_status.word16 = 1;

 	if (ei_debug > 0)
-		printk(version);
+		printk("%s", version);

 	ei_status.reset_8390 = &lne390_reset_8390;
 	ei_status.block_input = &lne390_block_input;
diff --git a/drivers/net/ne2.c b/drivers/net/ne2.c
index a53bb20..314d735 100644
--- a/drivers/net/ne2.c
+++ b/drivers/net/ne2.c
@@ -324,7 +324,7 @@ static int __init ne2_probe1(struct net_device
*dev, int slot)
 	static unsigned version_printed;

 	if (ei_debug && version_printed++ == 0)
-		printk(version);
+		printk("%s", version);

 	printk("NE/2 ethercard found in slot %d:", slot);

diff --git a/drivers/net/smc-ultra32.c b/drivers/net/smc-ultra32.c
index cb6c097..ef64b43 100644
--- a/drivers/net/smc-ultra32.c
+++ b/drivers/net/smc-ultra32.c
@@ -199,7 +199,7 @@ static int __init ultra32_probe1(struct net_device
*dev, int ioaddr)
 	}

 	if (ei_debug  &&  version_printed++ == 0)
-		printk(version);
+		printk("%s", version);

 	model_name = "SMC Ultra32";

diff --git a/drivers/net/tokenring/ibmtr.c b/drivers/net/tokenring/ibmtr.c
index fa7bce6..4c6d36f 100644
--- a/drivers/net/tokenring/ibmtr.c
+++ b/drivers/net/tokenring/ibmtr.c
@@ -695,7 +695,7 @@ static int __devinit ibmtr_probe1(struct
net_device *dev, int PIOaddr)
 	}

 	if (!version_printed++) {
-		printk(version);
+		printk("%s", version);
 	}
 #endif /* !PCMCIA */
 	DPRINTK("%s %s found\n",
diff --git a/drivers/net/tokenring/smctr.c b/drivers/net/tokenring/smctr.c
index 50eb29c..320e5d6 100644
--- a/drivers/net/tokenring/smctr.c
+++ b/drivers/net/tokenring/smctr.c
@@ -3641,7 +3641,7 @@ static int __init smctr_probe1(struct net_device
*dev, int ioaddr)
         __u32 *ram;

         if(smctr_debug && version_printed++ == 0)
-                printk(version);
+                printk("%s", version);

         spin_lock_init(&tp->lock);
         dev->base_addr = ioaddr;
diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index 8059494..83a96b1 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -923,7 +923,7 @@ static void __init aha1542_setup(char *str, int *ints)
 	}
 	if (ints[0] < 1 || ints[0] > 4) {
 		printk(KERN_ERR "aha1542: %s\n", str);
-		printk(ahausage);
+		printk("%s", ahausage);
 		printk(KERN_ERR "aha1542: Wrong parameters may cause system
malfunction.. We try anyway..\n");
 	}
 	setup_called[setup_idx] = ints[0];
@@ -953,7 +953,7 @@ static void __init aha1542_setup(char *str, int *ints)
 			break;
 		default:
 			printk(KERN_ERR "aha1542: %s\n", str);
-			printk(ahausage);
+			printk("%s", ahausage);
 			printk(KERN_ERR "aha1542: Valid values for DMASPEED are 5-8, 10
MB/s.  Using jumper defaults.\n");
 			break;
 		}
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 8dde84b..235823d 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -2926,7 +2926,7 @@ int nfs4_proc_setclientid(struct nfs_client
*clp, u32 program, unsigned short po
 		setclientid.sc_netid_len = scnprintf(setclientid.sc_netid,
 				sizeof(setclientid.sc_netid),
 				rpc_peeraddr2str(clp->cl_rpcclient,
-							RPC_DISPLAY_NETID));
+						"%s", RPC_DISPLAY_NETID));
 		setclientid.sc_uaddr_len = scnprintf(setclientid.sc_uaddr,
 				sizeof(setclientid.sc_uaddr), "%s.%u.%u",
 				clp->cl_ipaddr, port >> 8, port & 255);
diff --git a/fs/reiserfs/prints.c b/fs/reiserfs/prints.c
index 740bb8c..e3d4f62 100644
--- a/fs/reiserfs/prints.c
+++ b/fs/reiserfs/prints.c
@@ -289,7 +289,7 @@ void reiserfs_info(struct super_block *sb, const
char *fmt, ...)
 static void reiserfs_printk(const char *fmt, ...)
 {
 	do_reiserfs_warning(fmt);
-	printk(error_buf);
+	printk("%s", error_buf);
 }

 void reiserfs_debug(struct super_block *s, int level, const char *fmt, ...)
---

Regards,
Floris
---
"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."
  -- Ben Franklin

"The course of history shows that as a government grows, liberty
decreases."
  -- Thomas Jefferson
