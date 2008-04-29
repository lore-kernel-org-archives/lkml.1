Return-Path: <linux-kernel-owner+w=401wt.eu-S1763195AbYD2SwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763195AbYD2SwW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 14:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762010AbYD2Suv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 14:50:51 -0400
Received: from ns2.suse.de ([195.135.220.15]:41275 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761960AbYD2Sus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 14:50:48 -0400
Date: Tue, 29 Apr 2008 11:49:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Francois Romieu <romieu@fr.zoreil.com>,
       Jeff Garzik <jgarzik@redhat.com>
Subject: [04/12] tehuti: check register size (CVE-2008-1675)
Message-ID: <20080429184932.GE24199@suse.de>
References: <20080429184543.308594866@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="tehuti-check-register-size.patch"
In-Reply-To: <20080429184911.GA24199@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.24-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: Francois Romieu <romieu@fr.zoreil.com>

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/tehuti.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/net/tehuti.c
+++ b/drivers/net/tehuti.c
@@ -625,6 +625,12 @@ static void __init bdx_firmware_endianes
 		s_firmLoad[i] = CPU_CHIP_SWAP32(s_firmLoad[i]);
 }
 
+static int bdx_range_check(struct bdx_priv *priv, u32 offset)
+{
+	return (offset > (u32) (BDX_REGS_SIZE / priv->nic->port_num)) ?
+		-EINVAL : 0;
+}
+
 static int bdx_ioctl_priv(struct net_device *ndev, struct ifreq *ifr, int cmd)
 {
 	struct bdx_priv *priv = ndev->priv;
@@ -646,6 +652,9 @@ static int bdx_ioctl_priv(struct net_dev
 	switch (data[0]) {
 
 	case BDX_OP_READ:
+		error = bdx_range_check(priv, data[1]);
+		if (error < 0)
+			return error;
 		data[2] = READ_REG(priv, data[1]);
 		DBG("read_reg(0x%x)=0x%x (dec %d)\n", data[1], data[2],
 		    data[2]);
@@ -655,6 +664,11 @@ static int bdx_ioctl_priv(struct net_dev
 		break;
 
 	case BDX_OP_WRITE:
+		if (!capable(CAP_NET_ADMIN))
+			return -EPERM;
+		error = bdx_range_check(priv, data[1]);
+		if (error < 0)
+			return error;
 		WRITE_REG(priv, data[1], data[2]);
 		DBG("write_reg(0x%x, 0x%x)\n", data[1], data[2]);
 		break;

-- 
