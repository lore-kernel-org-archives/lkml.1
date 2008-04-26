Return-Path: <linux-kernel-owner+w=401wt.eu-S1758232AbYDZX0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758232AbYDZX0f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 19:26:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753052AbYDZX02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 19:26:28 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:24123 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148AbYDZX01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 19:26:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Tq0egh4pNwRTj1LqEKtVD5Kso0CZG76lVVZKQaMi7eg++iU1AG8mNpWQ9stNRXKeTyv3OAAO5Huecj82pqB/0BpXSI+47ix6YqcmdVsXOjVEaKFNgWhivrdD3mmD68DO9I2Io3WyFOKJ2HCWzcIezAntrT4V2v/LZ4wg1A7hLfA=
Message-ID: <1ba2fa240804261626s4b491ac4y920e8996840fabfa@mail.gmail.com>
Date: Sun, 27 Apr 2008 02:26:25 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Luca Tettamanti" <kronos.it@gmail.com>
Subject: Re: [PATCH] Fix compile error with wifi & leds
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20080426203408.GA12074@dreamland.darkstar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080426203408.GA12074@dreamland.darkstar.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2008 at 11:34 PM, Luca Tettamanti <kronos.it@gmail.com> wrote:
> Hi,
>  I encountered a build error with current git tree:
>
>   CC [M]  net/mac80211/led.o
>  /home/kronos/src/linux-2.6.git/net/mac80211/led.c: In function 'ieee80211_led_init':
>  /home/kronos/src/linux-2.6.git/net/mac80211/led.c:58: error: invalid application of 'sizeof' to incomplete type 'struct led_trigger'
>  /home/kronos/src/linux-2.6.git/net/mac80211/led.c:62: error: dereferencing pointer to incomplete type
>  /home/kronos/src/linux-2.6.git/net/mac80211/led.c:63: error: implicit declaration of function 'led_trigger_register'
>  /home/kronos/src/linux-2.6.git/net/mac80211/led.c:69: error: invalid application of 'sizeof' to incomplete type 'struct led_trigger'
>  /home/kronos/src/linux-2.6.git/net/mac80211/led.c:73: error: dereferencing pointer to incomplete type
>  /home/kronos/src/linux-2.6.git/net/mac80211/led.c:80: error: invalid application of 'sizeof' to incomplete type 'struct led_trigger'
>  /home/kronos/src/linux-2.6.git/net/mac80211/led.c:84: error: dereferencing pointer to incomplete type
>  /home/kronos/src/linux-2.6.git/net/mac80211/led.c:91: error: invalid application of 'sizeof' to incomplete type 'struct led_trigger'
>  /home/kronos/src/linux-2.6.git/net/mac80211/led.c:95: error: dereferencing pointer to incomplete type
>  /home/kronos/src/linux-2.6.git/net/mac80211/led.c: In function 'ieee80211_led_exit':
>  /home/kronos/src/linux-2.6.git/net/mac80211/led.c:106: error: implicit declaration of function 'led_trigger_unregister'
>  make[3]: *** [net/mac80211/led.o] Error 1
>  make[2]: *** [net/mac80211] Error 2
>  make[1]: *** [net] Error 2
>  make: *** [sub-make] Error 2
>
>  This has been caused by commit e82404ad612ebabc65d15c3d59b971cb35c3ff36
>  from David Miller:
>
>   config IWL4965_LEDS
>         bool "Enable LEDS features in iwl4965 driver"
>  -       depends on IWL4965 && MAC80211_LEDS && LEDS_CLASS
>  +       depends on IWL4965
>  +       select MAC80211_LEDS
>  +       select LEDS_CLASS
>
>
>  the problem is that MAC80211_LEDS *depends* on LEDS_TRIGGER but does not
>  _select_ it. IOW enabling IWL4965_LEDS enables MAC80211_LEDS which in
>  turn does not compile if LEDS_TRIGGER is not enabled.
>
>  LEDS_TRIGGER is not enough though, NEW_LEDS (which is a menuconfig
>  guarding the aforementioned symbol) must also be selected.
>
>  ---
>
>  Since MAC80211_LEDS is selected by wireless drivers it must select its
>  own dependencies otherwise a build error may occur (kbuild will select
>  the symbol regardless of "depends" constraints).
>
>  Signed-Off-By: Luca Tettamanti <kronos.it@gmail.com>
>
>  ---
>
>   net/mac80211/Kconfig |    4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
>
>  diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
>  index 520a518..a24b459 100644
>  --- a/net/mac80211/Kconfig
>  +++ b/net/mac80211/Kconfig
>  @@ -73,7 +73,9 @@ config MAC80211_MESH
>
>   config MAC80211_LEDS
>         bool "Enable LED triggers"
>  -       depends on MAC80211 && LEDS_TRIGGERS
>  +       depends on MAC80211
>  +       select NEW_LEDS
>  +       select LEDS_TRIGGERS
>         ---help---
>           This option enables a few LED triggers for different
>           packet receive/transmit events.
>

This one was already posted
Thanks
Tomas
