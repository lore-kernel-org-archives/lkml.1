Return-Path: <linux-kernel-owner+w=401wt.eu-S1754894AbZBJN1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894AbZBJN1S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 08:27:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754087AbZBJN1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 08:27:05 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:41262 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbZBJN1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 08:27:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=fuaOPFI10I3p/FoQXRfj1ZN3UmcOKNheWCP15KgXCGOvN/96vwflMOWxzt5idM464C
         IWYtObhMt+39BEQKHKgwrOnN8CoXXkg9bFYgdMk9YTwKN0gmjIwQzFrFhktfcVv5DW0S
         /IwmOyFBl5E2k02+UpNDFik5yjxzlgBdGS9dA=
MIME-Version: 1.0
Date: Tue, 10 Feb 2009 14:26:57 +0100
Message-ID: <56e1b5710902100526l720b0115v9d604ba91e3d7b5f@mail.gmail.com>
Subject: [PATCH]: Cleanup: Remove trivial gcc format string warnings when 
	compiling with -Wformat-security (part 1: trivial cases)
From: Floris Kraak <randakar@gmail.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Robert Hancock <hancockrwd@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Trivial Patch Monkey <trivial@kernel.org>,
       Andreas Schwab <schwab@suse.de>, Mike Isely <isely@isely.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 5, 2009 at 3:41 PM, Floris Kraak <randakar@gmail.com> wrote:
>
> Here's the patch that I get when I blindly patch every single location
> that emits this warning.
>
> If needed I can attempt to split this monster into 135 patches but
> given my limited experience with the tools involved a little help on
> how to go about creating such a series would be appreciated ;-)
>

Here's the first part of a split series of patches dealing with this.
I will reply to this message with further patches in the series.

This patch that deals with all known trivial cases.
Each fix contained in this patch deals with a harmless warning that
gets emitted while all strings passed into the format argument contain
built-in kernel data and therefore cannot possibly be fixing an actual
bug. None of the changes in this patch goes beyond adding "%s" as a
format argument.


---
Cleanup: Remove trivial gcc format string warnings when compiling with
-Wformat-security (part 1: trivial cases)

When compiling the kernel with an allyesconfig and the gcc flags
-Wformat and -Wformat-security the build process emits ~150 warnings
along these lines:

init/main.c:557: warning: format not a string literal and no format arguments
init/initramfs.c:582: warning: format not a string literal and no
format arguments
arch/x86/kernel/dumpstack.c:115: warning: format not a string literal
and no format arguments
...

Many of these warnings are harmless - the format string is statically
set within the kernel itself and is known to not contain any format
qualifiers.
This patch fixes a number of trivial cases where there is absolutely
no doubt possible that the original format string could not get
corrupted or exploited somehow.

Signed-off-by: Floris Kraak <randakar@gmail.com>
---
diff --git a/drivers/net/wireless/hostap/hostap_ioctl.c
b/drivers/net/wireless/hostap/hostap_ioctl.c
index c40fdf4..db5a4b4 100644
--- a/drivers/net/wireless/hostap/hostap_ioctl.c
+++ b/drivers/net/wireless/hostap/hostap_ioctl.c
@@ -3269,7 +3269,7 @@ static int prism2_ioctl_siwencodeext(struct
net_device *dev,

 	ops = lib80211_get_crypto_ops(alg);
 	if (ops == NULL) {
-		request_module(module);
+		request_module("%s", module);
 		ops = lib80211_get_crypto_ops(alg);
 	}
 	if (ops == NULL) {
diff --git a/drivers/net/wireless/ipw2x00/libipw_wx.c
b/drivers/net/wireless/ipw2x00/libipw_wx.c
index 31ea3ab..8ab3122 100644
--- a/drivers/net/wireless/ipw2x00/libipw_wx.c
+++ b/drivers/net/wireless/ipw2x00/libipw_wx.c
@@ -608,7 +608,7 @@ int ieee80211_wx_set_encodeext(struct
ieee80211_device *ieee,

 	ops = lib80211_get_crypto_ops(alg);
 	if (ops == NULL) {
-		request_module(module);
+		request_module("%s", module);
 		ops = lib80211_get_crypto_ops(alg);
 	}
 	if (ops == NULL) {
diff --git a/init/initramfs.c b/init/initramfs.c
index d9c941c..aa2a250 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -579,7 +579,7 @@ static int __init populate_rootfs(void)
 	char *err = unpack_to_rootfs(__initramfs_start,
 			 __initramfs_end - __initramfs_start, 0);
 	if (err)
-		panic(err);
+		panic("%s", err);
 	if (initrd_start) {
 #ifdef CONFIG_BLK_DEV_RAM
 		int fd;
diff --git a/net/netfilter/nf_conntrack_proto_dccp.c
b/net/netfilter/nf_conntrack_proto_dccp.c
index 8fcf176..6b6d335 100644
--- a/net/netfilter/nf_conntrack_proto_dccp.c
+++ b/net/netfilter/nf_conntrack_proto_dccp.c
@@ -447,7 +447,8 @@ static bool dccp_new(struct nf_conn *ct, const
struct sk_buff *skb,

 out_invalid:
 	if (LOG_INVALID(net, IPPROTO_DCCP))
-		nf_log_packet(nf_ct_l3num(ct), 0, skb, NULL, NULL, NULL, msg);
+		nf_log_packet(nf_ct_l3num(ct), 0, skb, NULL, NULL, NULL,
+				"%s", msg);
 	return false;
 }

@@ -593,7 +594,7 @@ static int dccp_error(struct net *net, struct sk_buff *skb,

 out_invalid:
 	if (LOG_INVALID(net, IPPROTO_DCCP))
-		nf_log_packet(pf, 0, skb, NULL, NULL, NULL, msg);
+		nf_log_packet(pf, 0, skb, NULL, NULL, NULL, "%s", msg);
 	return -NF_ACCEPT;
 }

diff --git a/sound/isa/es1688/es1688_lib.c b/sound/isa/es1688/es1688_lib.c
index 4fbb508..1c5246f 100644
--- a/sound/isa/es1688/es1688_lib.c
+++ b/sound/isa/es1688/es1688_lib.c
@@ -736,7 +736,7 @@ int snd_es1688_pcm(struct snd_es1688 * chip, int
device, struct snd_pcm ** rpcm)

 	pcm->private_data = chip;
 	pcm->info_flags = SNDRV_PCM_INFO_HALF_DUPLEX;
-	sprintf(pcm->name, snd_es1688_chip_id(chip));
+	sprintf(pcm->name, "%s", snd_es1688_chip_id(chip));
 	chip->pcm = pcm;

 	snd_pcm_lib_preallocate_pages_for_all(pcm, SNDRV_DMA_TYPE_DEV,
diff --git a/Documentation/networking/ifenslave.c
b/Documentation/networking/ifenslave.c
index 1b96ccd..5f911c4 100644
--- a/Documentation/networking/ifenslave.c
+++ b/Documentation/networking/ifenslave.c
@@ -260,7 +260,7 @@ int main(int argc, char *argv[])
 		case 'V': opt_V++; exclusive++; break;

 		case '?':
-			fprintf(stderr, usage_msg);
+			fprintf(stderr, "%s", usage_msg);
 			res = 2;
 			goto out;
 		}
@@ -268,13 +268,13 @@ int main(int argc, char *argv[])

 	/* options check */
 	if (exclusive > 1) {
-		fprintf(stderr, usage_msg);
+		fprintf(stderr, "%s", usage_msg);
 		res = 2;
 		goto out;
 	}

 	if (opt_v || opt_V) {
-		printf(version);
+		printf("%s", version);
 		if (opt_V) {
 			res = 0;
 			goto out;
@@ -282,14 +282,14 @@ int main(int argc, char *argv[])
 	}

 	if (opt_u) {
-		printf(usage_msg);
+		printf("%s", usage_msg);
 		res = 0;
 		goto out;
 	}

 	if (opt_h) {
-		printf(usage_msg);
-		printf(help_msg);
+		printf("%s", usage_msg);
+		printf("%s", help_msg);
 		res = 0;
 		goto out;
 	}
@@ -309,7 +309,7 @@ int main(int argc, char *argv[])
 			goto out;
 		} else {
 			/* Just show usage */
-			fprintf(stderr, usage_msg);
+			fprintf(stderr, "%s", usage_msg);
 			res = 2;
 			goto out;
 		}
@@ -320,7 +320,7 @@ int main(int argc, char *argv[])
 	master_ifname = *spp++;

 	if (master_ifname == NULL) {
-		fprintf(stderr, usage_msg);
+		fprintf(stderr, "%s", usage_msg);
 		res = 2;
 		goto out;
 	}
@@ -339,7 +339,7 @@ int main(int argc, char *argv[])

 	if (slave_ifname == NULL) {
 		if (opt_d || opt_c) {
-			fprintf(stderr, usage_msg);
+			fprintf(stderr, "%s", usage_msg);
 			res = 2;
 			goto out;
 		}
diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index cceace6..2e68188 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -3376,7 +3376,7 @@ static int cdrom_print_info(const char *header,
int val, char *info,
 	struct cdrom_device_info *cdi;
 	int ret;

-	ret = scnprintf(info + *pos, max_size - *pos, header);
+	ret = scnprintf(info + *pos, max_size - *pos, "%s", header);
 	if (!ret)
 		return 1;

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
diff --git a/drivers/input/tablet/aiptek.c b/drivers/input/tablet/aiptek.c
index 7d005a3..29face8 100644
--- a/drivers/input/tablet/aiptek.c
+++ b/drivers/input/tablet/aiptek.c
@@ -1370,7 +1370,7 @@ static ssize_t
show_tabletDiagnosticMessage(struct device *dev, struct device_at
 	default:
 		return 0;
 	}
-	return snprintf(buf, PAGE_SIZE, retMsg);
+	return snprintf(buf, PAGE_SIZE, "%s", retMsg);
 }

 static DEVICE_ATTR(diagnostic, S_IRUGO, show_tabletDiagnosticMessage, NULL);
diff --git a/drivers/media/video/cx2341x.c b/drivers/media/video/cx2341x.c
index cbbe47f..7dca1eb 100644
--- a/drivers/media/video/cx2341x.c
+++ b/drivers/media/video/cx2341x.c
@@ -471,7 +471,7 @@ static int cx2341x_ctrl_query_fill(struct
v4l2_queryctrl *qctrl,
 	qctrl->step = step;
 	qctrl->default_value = def;
 	qctrl->reserved[0] = qctrl->reserved[1] = 0;
-	snprintf(qctrl->name, sizeof(qctrl->name), name);
+	snprintf(qctrl->name, sizeof(qctrl->name), "%s", name);
 	return 0;
 }

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
index 39ac122..58943c7 100644
--- a/drivers/net/3c515.c
+++ b/drivers/net/3c515.c
@@ -420,7 +420,7 @@ int init_module(void)
 	if (debug >= 0)
 		corkscrew_debug = debug;
 	if (corkscrew_debug)
-		printk(version);
+		printk("%s", version);
 	while (corkscrew_scan(-1))
 		found++;
 	return found ? 0 : -ENODEV;
@@ -437,7 +437,7 @@ struct net_device *tc515_probe(int unit)

 	if (corkscrew_debug > 0 && !printed) {
 		printed = 1;
-		printk(version);
+		printk("%s", version);
 	}

 	return dev;
diff --git a/drivers/net/3c59x.c b/drivers/net/3c59x.c
index cdbbb62..eea45d4 100644
--- a/drivers/net/3c59x.c
+++ b/drivers/net/3c59x.c
@@ -1015,7 +1015,7 @@ static int __devinit vortex_probe1(struct device *gendev,
 	struct eisa_device *edev = NULL;

 	if (!printed_version) {
-		printk (version);
+		printk("%s", version);
 		printed_version = 1;
 	}

diff --git a/drivers/net/acenic.c b/drivers/net/acenic.c
index 9589d62..c39ce35 100644
--- a/drivers/net/acenic.c
+++ b/drivers/net/acenic.c
@@ -500,7 +500,7 @@ static int __devinit acenic_probe_one(struct pci_dev *pdev,

 	/* we only display this string ONCE */
 	if (!boards_found)
-		printk(version);
+		printk("%s", version);

 	if (pci_enable_device(pdev))
 		goto fail_free_netdev;
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
diff --git a/drivers/net/defxx.c b/drivers/net/defxx.c
index 6445ced..d6da3f1 100644
--- a/drivers/net/defxx.c
+++ b/drivers/net/defxx.c
@@ -531,7 +531,7 @@ static int __devinit dfx_register(struct device *bdev)

 	if (!version_disp) {	/* display version info if adapter is found */
 		version_disp = 1;	/* set display flag to TRUE so that */
-		printk(version);	/* we only display this string ONCE */
+		printk("%s", version);	/* we only display this string ONCE */
 	}

 	dev = alloc_fddidev(sizeof(*bp));
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
diff --git a/drivers/net/eql.c b/drivers/net/eql.c
index 4012569..9364ab2 100644
--- a/drivers/net/eql.c
+++ b/drivers/net/eql.c
@@ -584,7 +584,7 @@ static int __init eql_init_module(void)
 {
 	int err;

-	printk(version);
+	printk("%s", version);

 	dev_eql = alloc_netdev(sizeof(equalizer_t), "eql", eql_setup);
 	if (!dev_eql)
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
diff --git a/drivers/net/fealnx.c b/drivers/net/fealnx.c
index daf7272..26c8b5c 100644
--- a/drivers/net/fealnx.c
+++ b/drivers/net/fealnx.c
@@ -503,7 +503,7 @@ static int __devinit fealnx_init_one(struct pci_dev *pdev,
 #ifndef MODULE
 	static int printed_version;
 	if (!printed_version++)
-		printk(version);
+		printk("%s", version);
 #endif

 	card_idx++;
diff --git a/drivers/net/forcedeth.c b/drivers/net/forcedeth.c
index 5b910cf..f9b4b5d 100644
--- a/drivers/net/forcedeth.c
+++ b/drivers/net/forcedeth.c
@@ -923,7 +923,7 @@ static int reg_delay(struct net_device *dev, int
offset, u32 mask, u32 target,
 		delaymax -= delay;
 		if (delaymax < 0) {
 			if (msg)
-				printk(msg);
+				printk("%s", msg);
 			return 1;
 		}
 	} while ((readl(base + offset) & mask) != target);
diff --git a/drivers/net/hamachi.c b/drivers/net/hamachi.c
index 7e8b3c5..21010e0 100644
--- a/drivers/net/hamachi.c
+++ b/drivers/net/hamachi.c
@@ -601,7 +601,7 @@ static int __devinit hamachi_init_one (struct pci_dev *pdev,
 #ifndef MODULE
 	static int printed_version;
 	if (!printed_version++)
-		printk(version);
+		printk("%s", version);
 #endif

 	if (pci_enable_device(pdev)) {
diff --git a/drivers/net/hamradio/6pack.c b/drivers/net/hamradio/6pack.c
index 2d40898..f977bb6 100644
--- a/drivers/net/hamradio/6pack.c
+++ b/drivers/net/hamradio/6pack.c
@@ -797,7 +797,7 @@ static int __init sixpack_init_driver(void)
 {
 	int status;

-	printk(msg_banner);
+	printk("%s", msg_banner);

 	/* Register the provided line protocol discipline */
 	if ((status = tty_register_ldisc(N_6PACK, &sp_ldisc)) != 0)
diff --git a/drivers/net/hamradio/bpqether.c b/drivers/net/hamradio/bpqether.c
index 46f8f33..fc9e6af 100644
--- a/drivers/net/hamradio/bpqether.c
+++ b/drivers/net/hamradio/bpqether.c
@@ -614,7 +614,7 @@ static int __init bpq_init_driver(void)

 	register_netdevice_notifier(&bpq_dev_notifier);

-	printk(banner);
+	printk("%s", banner);

 	return 0;
 }
diff --git a/drivers/net/hamradio/mkiss.c b/drivers/net/hamradio/mkiss.c
index bbdb311..5e24e5d 100644
--- a/drivers/net/hamradio/mkiss.c
+++ b/drivers/net/hamradio/mkiss.c
@@ -991,7 +991,7 @@ static int __init mkiss_init_driver(void)
 {
 	int status;

-	printk(banner);
+	printk("%s", banner);

 	if ((status = tty_register_ldisc(N_AX25, &ax_ldisc)) != 0)
 		printk(msg_regfail);
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
 	
diff --git a/drivers/net/hamradio/yam.c b/drivers/net/hamradio/yam.c
index 5407f74..37eda03 100644
--- a/drivers/net/hamradio/yam.c
+++ b/drivers/net/hamradio/yam.c
@@ -1114,7 +1114,7 @@ static int __init yam_init_driver(void)
 	int i, err;
 	char name[IFNAMSIZ];

-	printk(yam_drvinfo);
+	printk("%s", yam_drvinfo);

 	for (i = 0; i < NR_PORTS; i++) {
 		sprintf(name, "yam%d", i);
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
diff --git a/drivers/net/natsemi.c b/drivers/net/natsemi.c
index c5dec54..19938d6 100644
--- a/drivers/net/natsemi.c
+++ b/drivers/net/natsemi.c
@@ -813,7 +813,7 @@ static int __devinit natsemi_probe1 (struct pci_dev *pdev,
 #ifndef MODULE
 	static int printed_version;
 	if (!printed_version++)
-		printk(version);
+		printk("%s", version);
 #endif

 	i = pci_enable_device(pdev);
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

diff --git a/drivers/net/ne2k-pci.c b/drivers/net/ne2k-pci.c
index f090d3b..19cccd4 100644
--- a/drivers/net/ne2k-pci.c
+++ b/drivers/net/ne2k-pci.c
@@ -231,7 +231,7 @@ static int __devinit ne2k_pci_init_one (struct
pci_dev *pdev,
 #ifndef MODULE
 	static int printed_version;
 	if (!printed_version++)
-		printk(version);
+		printk("%s", version);
 #endif

 	fnd_cnt++;
diff --git a/drivers/net/pcmcia/axnet_cs.c b/drivers/net/pcmcia/axnet_cs.c
index 0afa720..de9fb96 100644
--- a/drivers/net/pcmcia/axnet_cs.c
+++ b/drivers/net/pcmcia/axnet_cs.c
@@ -1713,7 +1713,7 @@ static void axdev_setup(struct net_device *dev)
 {
 	struct ei_device *ei_local;
 	if (ei_debug > 1)
-		printk(version_8390);
+		printk("%s", version_8390);

 	ei_local = (struct ei_device *)netdev_priv(dev);
 	spin_lock_init(&ei_local->page_lock);
diff --git a/drivers/net/rrunner.c b/drivers/net/rrunner.c
index d890829..a4c9c22 100644
--- a/drivers/net/rrunner.c
+++ b/drivers/net/rrunner.c
@@ -134,7 +134,7 @@ static int __devinit rr_init_one(struct pci_dev *pdev,
 		/* set display flag to TRUE so that */
 		/* we only display this string ONCE */
 		version_disp = 1;
-		printk(version);
+		printk("%s", version);
 	}

 	pci_read_config_byte(pdev, PCI_LATENCY_TIMER, &pci_latency);
diff --git a/drivers/net/sis900.c b/drivers/net/sis900.c
index be4465b..9b42659 100644
--- a/drivers/net/sis900.c
+++ b/drivers/net/sis900.c
@@ -425,7 +425,7 @@ static int __devinit sis900_probe(struct pci_dev *pci_dev,
 #ifndef MODULE
 	static int printed_version;
 	if (!printed_version++)
-		printk(version);
+		printk("%s", version);
 #endif

 	/* setup various bits in PCI command register */
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

diff --git a/drivers/net/starfire.c b/drivers/net/starfire.c
index da3a76b..4a39b5a 100644
--- a/drivers/net/starfire.c
+++ b/drivers/net/starfire.c
@@ -682,7 +682,7 @@ static int __devinit starfire_init_one(struct pci_dev *pdev,
 #ifndef MODULE
 	static int printed_version;
 	if (!printed_version++)
-		printk(version);
+		printk("%s", version);
 #endif

 	card_idx++;
diff --git a/drivers/net/sundance.c b/drivers/net/sundance.c
index feaf0e0..b580743 100644
--- a/drivers/net/sundance.c
+++ b/drivers/net/sundance.c
@@ -486,7 +486,7 @@ static int __devinit sundance_probe1 (struct pci_dev *pdev,
 #ifndef MODULE
 	static int printed_version;
 	if (!printed_version++)
-		printk(version);
+		printk("%s", version);
 #endif

 	if (pci_enable_device(pdev))
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
diff --git a/drivers/net/tulip/de4x5.c b/drivers/net/tulip/de4x5.c
index 6418f74..aa034f5 100644
--- a/drivers/net/tulip/de4x5.c
+++ b/drivers/net/tulip/de4x5.c
@@ -1265,7 +1265,7 @@ de4x5_hw_init(struct net_device *dev, u_long
iobase, struct device *gendev)
     }

     if (de4x5_debug & DEBUG_VERSION) {
-	printk(version);
+	printk("%s", version);
     }

     /* The DE4X5-specific entries in the device structure. */
diff --git a/drivers/net/tulip/dmfe.c b/drivers/net/tulip/dmfe.c
index 2e5c999..d5d021b 100644
--- a/drivers/net/tulip/dmfe.c
+++ b/drivers/net/tulip/dmfe.c
@@ -375,7 +375,7 @@ static int __devinit dmfe_init_one (struct pci_dev *pdev,
 	DMFE_DBUG(0, "dmfe_init_one()", 0);

 	if (!printed_version++)
-		printk(version);
+		printk("%s", version);

 	/* Init network device */
 	dev = alloc_etherdev(sizeof(*db));
@@ -2188,7 +2188,7 @@ static int __init dmfe_init_module(void)
 {
 	int rc;

-	printk(version);
+	printk("%s", version);
 	printed_version = 1;

 	DMFE_DBUG(0, "init_module() ", debug);
diff --git a/drivers/net/tulip/uli526x.c b/drivers/net/tulip/uli526x.c
index 030e02e..d340b5c 100644
--- a/drivers/net/tulip/uli526x.c
+++ b/drivers/net/tulip/uli526x.c
@@ -274,7 +274,7 @@ static int __devinit uli526x_init_one (struct pci_dev *pdev,
 	ULI526X_DBUG(0, "uli526x_init_one()", 0);

 	if (!printed_version++)
-		printk(version);
+		printk("%s", version);

 	/* Init network device */
 	dev = alloc_etherdev(sizeof(*db));
@@ -1816,7 +1816,7 @@ MODULE_PARM_DESC(mode, "ULi M5261/M5263: Bit 0:
10/100Mbps, bit 2: duplex, bit 8
 static int __init uli526x_init_module(void)
 {

-	printk(version);
+	printk("%s", version);
 	printed_version = 1;

 	ULI526X_DBUG(0, "init_module() ", debug);
diff --git a/drivers/net/tulip/winbond-840.c b/drivers/net/tulip/winbond-840.c
index f467bf8..9de1885 100644
--- a/drivers/net/tulip/winbond-840.c
+++ b/drivers/net/tulip/winbond-840.c
@@ -1663,7 +1663,7 @@ static struct pci_driver w840_driver = {

 static int __init w840_init(void)
 {
-	printk(version);
+	printk("%s", version);
 	return pci_register_driver(&w840_driver);
 }

diff --git a/drivers/net/via-rhine.c b/drivers/net/via-rhine.c
index 3b8e632..736c88c 100644
--- a/drivers/net/via-rhine.c
+++ b/drivers/net/via-rhine.c
@@ -652,7 +652,7 @@ static int __devinit rhine_init_one(struct pci_dev *pdev,
 #ifndef MODULE
 	static int printed_version;
 	if (!printed_version++)
-		printk(version);
+		printk("%s", version);
 #endif

 	io_size = 256;
diff --git a/drivers/net/wan/lapbether.c b/drivers/net/wan/lapbether.c
index 5b61b3e..0f4e51a 100644
--- a/drivers/net/wan/lapbether.c
+++ b/drivers/net/wan/lapbether.c
@@ -438,7 +438,7 @@ static int __init lapbeth_init_driver(void)

 	register_netdevice_notifier(&lapbeth_dev_notifier);

-	printk(banner);
+	printk("%s", banner);

 	return 0;
 }
diff --git a/drivers/net/wan/z85230.c b/drivers/net/wan/z85230.c
index 3d00971..3dfa48b 100644
--- a/drivers/net/wan/z85230.c
+++ b/drivers/net/wan/z85230.c
@@ -1779,7 +1779,7 @@ static char banner[] __initdata = KERN_INFO
"Generic Z85C30/Z85230 interface dri

 static int __init z85230_init_driver(void)
 {
-	printk(banner);
+	printk("%s", banner);
 	return 0;
 }
 module_init(z85230_init_driver);
diff --git a/drivers/net/yellowfin.c b/drivers/net/yellowfin.c
index 2f1645d..557bad8 100644
--- a/drivers/net/yellowfin.c
+++ b/drivers/net/yellowfin.c
@@ -390,7 +390,7 @@ static int __devinit yellowfin_init_one(struct
pci_dev *pdev,
 #ifndef MODULE
 	static int printed_version;
 	if (!printed_version++)
-		printk(version);
+		printk("%s", version);
 #endif

 	i = pci_enable_device(pdev);
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
diff --git a/init/main.c b/init/main.c
index 8442094..78fc0d8 100644
--- a/init/main.c
+++ b/init/main.c
@@ -554,7 +554,7 @@ asmlinkage void __init start_kernel(void)
 	boot_cpu_init();
 	page_address_init();
 	printk(KERN_NOTICE);
-	printk(linux_banner);
+	printk("%s", linux_banner);
 	setup_arch(&command_line);
 	mm_init_owner(&init_mm, &init_task);
 	setup_command_line(command_line);
diff --git a/kernel/power/main.c b/kernel/power/main.c
index b4d2190..d5f0294 100644
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -714,7 +714,7 @@ static int __init test_suspend(void)
 	if (pony)
 		rtc = rtc_class_open(pony);
 	if (!rtc) {
-		printk(warn_no_rtc);
+		printk("%s", warn_no_rtc);
 		goto done;
 	}

diff --git a/net/802/psnap.c b/net/802/psnap.c
index 70980ba..10f1fe6 100644
--- a/net/802/psnap.c
+++ b/net/802/psnap.c
@@ -103,7 +103,7 @@ static int __init snap_init(void)
 	snap_sap = llc_sap_open(0xAA, snap_rcv);

 	if (!snap_sap)
-		printk(snap_err_msg);
+		printk("%s", snap_err_msg);

 	return 0;
 }
diff --git a/net/appletalk/ddp.c b/net/appletalk/ddp.c
index 5abce07..8c55482 100644
--- a/net/appletalk/ddp.c
+++ b/net/appletalk/ddp.c
@@ -1891,7 +1891,7 @@ static int __init atalk_init(void)
 	(void)sock_register(&atalk_family_ops);
 	ddp_dl = register_snap_client(ddp_snap_id, atalk_rcv);
 	if (!ddp_dl)
-		printk(atalk_err_snap);
+		printk("%s", atalk_err_snap);

 	dev_add_pack(&ltalk_packet_type);
 	dev_add_pack(&ppptalk_packet_type);
diff --git a/net/decnet/af_decnet.c b/net/decnet/af_decnet.c
index cf0e184..90bc10c 100644
--- a/net/decnet/af_decnet.c
+++ b/net/decnet/af_decnet.c
@@ -2374,7 +2374,7 @@ static int __init decnet_init(void)
 {
 	int rc;

-	printk(banner);
+	printk("%s", banner);

 	rc = proto_register(&dn_proto, 1);
 	if (rc != 0)
diff --git a/net/ipv4/ipip.c b/net/ipv4/ipip.c
index 5079dfb..983843f 100644
--- a/net/ipv4/ipip.c
+++ b/net/ipv4/ipip.c
@@ -833,7 +833,7 @@ static int __init ipip_init(void)
 {
 	int err;

-	printk(banner);
+	printk("%s", banner);

 	if (xfrm4_tunnel_register(&ipip_handler, AF_INET)) {
 		printk(KERN_INFO "ipip init: can't register tunnel\n");
diff --git a/net/ipx/af_ipx.c b/net/ipx/af_ipx.c
index b6e70f9..5aecae0 100644
--- a/net/ipx/af_ipx.c
+++ b/net/ipx/af_ipx.c
@@ -1999,21 +1999,21 @@ static int __init ipx_init(void)
 	if (pEII_datalink)
 		dev_add_pack(&ipx_dix_packet_type);
 	else
-		printk(ipx_EII_err_msg);
+		printk("%s", ipx_EII_err_msg);

 	p8023_datalink = make_8023_client();
 	if (p8023_datalink)
 		dev_add_pack(&ipx_8023_packet_type);
 	else
-		printk(ipx_8023_err_msg);
+		printk("%s", ipx_8023_err_msg);

 	p8022_datalink = register_8022_client(ipx_8022_type, ipx_rcv);
 	if (!p8022_datalink)
-		printk(ipx_llc_err_msg);
+		printk("%s", ipx_llc_err_msg);

 	pSNAP_datalink = register_snap_client(ipx_snap_id, ipx_rcv);
 	if (!pSNAP_datalink)
-		printk(ipx_snap_err_msg);
+		printk("%s", ipx_snap_err_msg);

 	register_netdevice_notifier(&ipx_dev_notifier);
 	ipx_register_sysctl();
diff --git a/net/llc/af_llc.c b/net/llc/af_llc.c
index 56fd85a..1ae72e5 100644
--- a/net/llc/af_llc.c
+++ b/net/llc/af_llc.c
@@ -1137,17 +1137,17 @@ static int __init llc2_init(void)
 	llc_ui_sap_last_autoport = LLC_SAP_DYN_START;
 	rc = llc_proc_init();
 	if (rc != 0) {
-		printk(llc_proc_err_msg);
+		printk("%s", llc_proc_err_msg);
 		goto out_unregister_llc_proto;
 	}
 	rc = llc_sysctl_init();
 	if (rc) {
-		printk(llc_sysctl_err_msg);
+		printk("%s", llc_sysctl_err_msg);
 		goto out_proc;
 	}
 	rc = sock_register(&llc_ui_family_ops);
 	if (rc) {
-		printk(llc_sock_err_msg);
+		printk("%s", llc_sock_err_msg);
 		goto out_sysctl;
 	}
 	llc_add_pack(LLC_DEST_SAP, llc_sap_handler);
diff --git a/net/tipc/bcast.c b/net/tipc/bcast.c
index 3ddaff4..dfd9c01 100644
--- a/net/tipc/bcast.c
+++ b/net/tipc/bcast.c
@@ -800,7 +800,7 @@ int tipc_bclink_init(void)
 	tipc_link_set_queue_limits(bcl, BCLINK_WIN_DEFAULT);
 	bcl->b_ptr = &bcbearer->bearer;
 	bcl->state = WORKING_WORKING;
-	sprintf(bcl->name, tipc_bclink_name);
+	sprintf(bcl->name, "%s", tipc_bclink_name);

 	if (BCLINK_LOG_BUF_SIZE) {
 		char *pb = kmalloc(BCLINK_LOG_BUF_SIZE, GFP_ATOMIC);
diff --git a/net/tipc/node.c b/net/tipc/node.c
index 20d98c5..f659411 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -703,7 +703,7 @@ struct sk_buff *tipc_node_get_links(const void
*req_tlv_area, int req_tlv_space)

 	link_info.dest = htonl(tipc_own_addr & 0xfffff00);
 	link_info.up = htonl(1);
-	sprintf(link_info.str, tipc_bclink_name);
+	sprintf(link_info.str, "%s", tipc_bclink_name);
 	tipc_cfg_append_tlv(buf, TIPC_TLV_LINK_INFO, &link_info, sizeof(link_info));

 	/* Add TLVs for any other links in scope */
diff --git a/sound/core/seq/seq_clientmgr.c b/sound/core/seq/seq_clientmgr.c
index 8ca2be3..a6869b8 100644
--- a/sound/core/seq/seq_clientmgr.c
+++ b/sound/core/seq/seq_clientmgr.c
@@ -2446,7 +2446,7 @@ static void snd_seq_info_dump_subscribers(struct
snd_info_buffer *buffer,
 		up_read(&group->list_mutex);
 		return;
 	}
-	snd_iprintf(buffer, msg);
+	snd_iprintf(buffer, "%s", msg);
 	list_for_each(p, &group->list_head) {
 		if (is_src)
 			s = list_entry(p, struct snd_seq_subscribers, src_list);

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
