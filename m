Return-Path: <linux-kernel-owner+w=401wt.eu-S1423050AbXBBNJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423050AbXBBNJt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 08:09:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423048AbXBBNJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 08:09:49 -0500
Received: from 147.175.241.83.in-addr.dgcsystems.net ([83.241.175.147]:13009
	"EHLO tmnt04.transmode.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1423039AbXBBNJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 08:09:48 -0500
Subject: [PATCH]ip_auto_config bug in 2.6.20-rc6
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Reply-To: joakim.tjernlund@transmode.se
To: Netdev <netdev@vger.kernel.org>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1170329187.15627.11.camel@gentoo-jocke.transmode.se>
References: <1170329187.15627.11.camel@gentoo-jocke.transmode.se>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Transmode AB
Date: Fri, 02 Feb 2007 14:09:43 +0100
Message-Id: <1170421783.15627.23.camel@gentoo-jocke.transmode.se>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-02-01 at 12:26 +0100, Joakim Tjernlund wrote:
> The following commandline:
>  root=/dev/mtdblock6 rw rootfstype=jffs2 ip=192.168.1.10:::255.255.255.0:localhost.localdomain:eth1:off console=ttyS0,115200
> makes ip_auto_config fall back to DHCP and complain "IP-Config: Incomplete network configuration information."
> depending on if CONFIG_IP_PNP_DHCP is set or not.
> 
> The only way I can make ip_auto_config accept my IP config is to add an entry for the server IP:
> ip=192.168.1.10:192.168.1.15::255.255.255.0:localhost.localdomain:eth1:off
> 
> I think this is a bug since I am not using a NFS root FS.
> 
>  Jocke

The following patch fixes the above problem. This change was present in
2.4 but has been removed from 2.6, dunno why.

Signed-off-by: Joakim Tjernlund <joakim.tjernlund@transmode.se>

diff --git a/net/ipv4/ipconfig.c b/net/ipv4/ipconfig.c
index 9f245de..b90479c 100644
--- a/net/ipv4/ipconfig.c
+++ b/net/ipv4/ipconfig.c
@@ -1282,7 +1282,8 @@ static int __init ip_auto_config(void)
 #ifdef CONFIG_ROOT_NFS
 	    (MAJOR(ROOT_DEV) == UNNAMED_MAJOR
 	     && root_server_addr == NONE
-	     && ic_servaddr == NONE) ||
+	     && ic_servaddr == NONE
+	     && ROOT_DEV == Root_NFS) ||
 #endif
 	    ic_first_dev->next) {
 #ifdef IPCONFIG_DYNAMIC


