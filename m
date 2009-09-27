Return-Path: <linux-kernel-owner+w=401wt.eu-S1753235AbZI0COx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235AbZI0COx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 22:14:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753173AbZI0COw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 22:14:52 -0400
Received: from mail-px0-f194.google.com ([209.85.216.194]:61733 "EHLO
	mail-px0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169AbZI0COv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 22:14:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vbwjFm6PUQMl5440o45yf46cYaIpe2pvhTE+emMN8E5AbQEoKOJKEniF1CysUOy7ix
         Gz0VpMQIJLNOTjVpZwMkhYOL54zNaMP3v0TvQh+YfG7F8RutMon9QrDbaLDEVly+iHQf
         sDxiJ/Q4ClprOxUiKsy6qXuwSsEku4qyLPv2w=
MIME-Version: 1.0
In-Reply-To: <871vluc5wi.fsf@spindle.srvr.nix>
References: <871vluc5wi.fsf@spindle.srvr.nix>
Date: Sat, 26 Sep 2009 19:14:55 -0700
Message-ID: <5f2db9d90909261914l3a927f4cya1dc5e4548688bce@mail.gmail.com>
Subject: Re: 2.6.31 regression: e1000e jumbo frames no longer work: 
	'Unsupported MTU setting'
From: Alexander Duyck <alexander.duyck@gmail.com>
To: Nix <nix@esperi.org.uk>
Cc: e1000-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       netdev <netdev@vger.kernel.org>, bruce.w.allan@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 26, 2009 at 4:16 AM, Nix <nix@esperi.org.uk> wrote:
> [Bruce, you have changes in net-next in this area, so you might have a clue
>  what's going on here.]
>
> In 2.6.30.x, I was happily bringing up the 82574L cards in one server like
> this:
>
> ip link set fastnet up mtu 7200
>
> As of 2.6.31.x, what I see is this:
>
> spindle:/root# ip link set mtu 7200 dev fastnet
> RTNETLINK answers: Invalid argument
> [ 3380.261796] 0000:02:00.0: fastnet: Unsupported MTU setting
>
> As far as I can tell, all MTUs above 1500 now fail.
>
> 'Unsupported' or not, this used to work, and I'd certainly expect jumbo
> frames to be supported on a gigabit card!
>
> I can't see any terribly relevant changes to e1000e between 2.6.30 and
> 2.6.31, so I'm Cc:ing netdev on the offchance that this is something
> more generic (unlikely, as 7200-byte MTUs still work fine in 2.6.31 with
> the r8169 I'm typing this on, but that doesn't help if half the subnet
> is forced to use MTUs of 1500).

It looks like the problem is that the 82574 and 82583 seem to have
their max_hw_frame_size values swapped.  You might try applying the
patch below.  I am not sure if it will apply since I hand generated it
using the git patch that seems to have introduced the problem, and I
am sending the patch through an untested account that may mangle the
patch.  I will see about submitting an official patch for this
sometime next few days.

Thanks,

Alex

diff --git a/drivers/net/e1000e/82571.c b/drivers/net/e1000e/82571.c
--- a/drivers/net/e1000e/82571.c
+++ b/drivers/net/e1000e/82571.c
@@ -1803,7 +1803,7 @@ struct e1000_info e1000_82574_info = {
 				  | FLAG_HAS_AMT
 				  | FLAG_HAS_CTRLEXT_ON_LOAD,
 	.pba			= 20,
-	.max_hw_frame_size	= ETH_FRAME_LEN + ETH_FCS_LEN,
+	.max_hw_frame_size	= DEFAULT_JUMBO,
 	.get_variants		= e1000_get_variants_82571,
 	.mac_ops		= &e82571_mac_ops,
 	.phy_ops		= &e82_phy_ops_bm,
@@ -1820,7 +1820,7 @@ struct e1000_info e1000_82583_info = {
 				  | FLAG_HAS_AMT
 				  | FLAG_HAS_CTRLEXT_ON_LOAD,
 	.pba			= 20,
-	.max_hw_frame_size	= DEFAULT_JUMBO,
+	.max_hw_frame_size	= ETH_FRAME_LEN + ETH_FCS_LEN,
 	.get_variants		= e1000_get_variants_82571,
 	.mac_ops		= &e82571_mac_ops,
 	.phy_ops		= &e82_phy_ops_bm,
