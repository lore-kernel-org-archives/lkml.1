Return-Path: <linux-kernel-owner+w=401wt.eu-S1752031AbZJTSyL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031AbZJTSyL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 14:54:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751823AbZJTSyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 14:54:11 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:41428 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbZJTSyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 14:54:10 -0400
To: Matt Mackall <mpm@selenic.com>
Cc: linux-kernel@vger.kernel.org, linux-net@vger.kernel.org
Subject: [PATCH] Allow renaming of network interfaces that are up.
From: Nix <nix@esperi.org.uk>
Emacs: a compelling argument for pencil and paper.
Date: Tue, 20 Oct 2009 19:54:02 +0100
In-Reply-To: <87k4yup9bd.fsf@spindle.srvr.nix> (nix@esperi.org.uk's message of "Sat, 17 Oct 2009 12:08:06 +0100")
Message-ID: <87vdi9ew1h.fsf_-_@spindle.srvr.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b29 (linux)
References: <87zl7rp1jy.fsf@spindle.srvr.nix> <1255723078.14249.16.camel@calx>
	<87k4yup9bd.fsf@spindle.srvr.nix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-URT-Metrics: spindle 1060; Body=3 Fuz1=3 Fuz2=3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ancient restriction banning renaming of busy network interfaces appears
to be purposeless. Everything that depends on a network interface's name is
done under the dev_base_lock in any case.

This makes it much easier to use things like netconsole which bring up a
network interface before userspace has started: presently these will cause
interface renamings to fail, breaking any userspace that relies on renaming
devices to avoid reliance on the potentially-unstable kernel-assigned name.

Signed-off-by: Nick Alcock <nix@esperi.org.uk>
---
 net/core/dev.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

Note: this may very well be wrong, as I know essentially nothing about this
part of the kernel. All I know is that without a patch something like this,
netconsole is nearly useless to me, so many panics are uncapturable. Maybe
there is some constraint preventing the kernel from reliably renaming
up interfaces. In that case, netconsole, DHCP netboot discovery and so on
probably need to grow the ability to rename them themselves.

diff --git a/net/core/dev.c b/net/core/dev.c
index b8f74cf..87e9f88 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -901,8 +901,6 @@ int dev_change_name(struct net_device *dev, const char *newname)
 	BUG_ON(!dev_net(dev));
 
 	net = dev_net(dev);
-	if (dev->flags & IFF_UP)
-		return -EBUSY;
 
 	if (!dev_valid_name(newname))
 		return -EINVAL;
-- 
1.6.5.1
