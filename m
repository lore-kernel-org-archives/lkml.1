Return-Path: <linux-kernel-owner+w=401wt.eu-S1753732AbZGLKZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732AbZGLKZi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 06:25:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbZGLKZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 06:25:29 -0400
Received: from aun.it.uu.se ([130.238.12.36]:42461 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108AbZGLKZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 06:25:28 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19033.46146.685018.240686@pilspetsen.it.uu.se>
Date: Sun, 12 Jul 2009 12:00:34 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Cheng Renquan <crq@kernel.org>
Cc: linux-kbuild@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       crquan@gmail.com
Subject: Re: [PATCH 1/6] add symbol value to help find the real depend
In-Reply-To: <1247386308-19628-2-git-send-email-crq@kernel.org>
References: <1247386308-19628-1-git-send-email-crq@kernel.org>
	<1247386308-19628-2-git-send-email-crq@kernel.org>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cheng Renquan writes:
 > From: Cheng Renquan <crquan@gmail.com>
 > 
 > kbuild-menuconfig-display-depend-value.patch
 > 
 > Sometimes when configuring need to disable some unused item, but the item is
 > selected by many other items, it's hard to find the real dependency which
 > selected it, This patch add every symbol's value accompanied to make it
 > possible to find the real dependency easily.
 > 
 > An example is CONFIG_RFKILL,
 > 
 >   ---------------------- RF switch subsystem support ----------------------
 >   | CONFIG_RFKILL:                                                        |
 >   |                                                                       |
 >   | Say Y here if you want to have control over RF switches               |
 >   | found on many WiFi and Bluetooth cards.                               |
 >   |                                                                       |
 >   | To compile this driver as a module, choose M here: the                |
 >   | module will be called rfkill.                                         |
 >   |                                                                       |
 >   | Symbol: RFKILL [=m]                                                   |
 >   | Prompt: RF switch subsystem support                                   |
 >   |   Defined at net/rfkill/Kconfig:4                                     |
 >   |   Depends on: NET [=y]                                                |
 >   |   Location:                                                           |
 >   |     -> Networking support (NET [=y])                                  |
 >   |   Selected by: IWLCORE [=n] && NETDEVICES [=y] && !S390 [=S390] && PC |
 >   |                                                                       |
 >   ----------------------------------------------------------------( 99%)---

I like this concept, but I'd like to see it supported with make oldconfig.
Let's say I copy a .config from kernel X into kernel Y (Y>X) and make oldconfig.
Sometimes the new kernel will enable some previously disabled option, and
it would be very useful to see WHY.

To take a concrete example, in my 2.6.30 .config I had:

CONFIG_DRM=m
CONFIG_DRM_RADEON=m
# CONFIG_FB is not set

which when oldconfig'd in 2.6.31-rc changed to

CONFIG_DRM=m
CONFIG_DRM_RADEON=m
CONFIG_FB=m
(+ some more FB stuff)

In this case it would have been nice to get an explanation that DRM_RADEON
was responsible for (wrongly, IMO) selecting FB. Something like

# CONFIG_FB was selected by CONFIG_DRM_RADEON
CONFIG_FB=m

These comments should only be emitted for options added by select that
previously were absent or 'is not set'.

/Mikael
