Return-Path: <linux-kernel-owner+w=401wt.eu-S933783AbZJIQH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933783AbZJIQH4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 12:07:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933528AbZJIQH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 12:07:56 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:59585 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933516AbZJIQHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 12:07:54 -0400
Date: Fri, 9 Oct 2009 09:06:01 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Johannes Berg <johannes@sipsolutions.net>, gregkh@suse.de,
       devel@driverdev.osuosl.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wireless: make WEXT_SPY and WEXT_PRIV select WEXT_CORE
Message-Id: <20091009090601.73de5dc6.randy.dunlap@oracle.com>
In-Reply-To: <1255026563.3713.28.camel@johannes.local>
References: <20091007105720.a2457e5b.randy.dunlap@oracle.com>
	<1254949672-24022-1-git-send-email-linville@tuxdriver.com>
	<4ACD0E5A.7060106@oracle.com>
	<1254954842.3713.7.camel@johannes.local>
	<4ACD1C3D.3030506@oracle.com>
	<1254957256.3713.10.camel@johannes.local>
	<20091007171235.d40f0cc2.randy.dunlap@oracle.com>
	<1254995282.3713.18.camel@johannes.local>
	<20091008080615.09c8b803.randy.dunlap@oracle.com>
	<1255026563.3713.28.camel@johannes.local>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4ACF5F7A.01A9:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Oct 2009 20:29:23 +0200 Johannes Berg wrote:

> On Thu, 2009-10-08 at 08:06 -0700, Randy Dunlap wrote:
> 
> > > It's kinda strange though that you can select wireless drivers without
> > > selecting WIRELESS. Maybe the solution is as simple as making WLAN
> > > (drivers/net/wireless/Kconfig) depend on WIRELESS?
> > 
> > Yes, I think that would be a very good start.
> 
> On the other hand, of course, the whole WIRELESS thing is somewhat
> stupid. How about this?
> 
> johannes
> 
> From: Johannes Berg <johannes@sipsolutions.net>
> Subject: wireless: make wireless drivers select core
> 
> It is somewhat non-sensical to allow selecting wireless
> drivers without showing wireless core code options, and
> since the wext refactoring this has made it possible to
> generate configurations that will not build. Avoid this
> and make wireless drivers select the wireless options.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
>  drivers/net/wireless/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- wireless-testing.orig/drivers/net/wireless/Kconfig	2009-10-08 20:25:04.000000000 +0200
> +++ wireless-testing/drivers/net/wireless/Kconfig	2009-10-08 20:27:38.000000000 +0200
> @@ -5,6 +5,7 @@
>  menuconfig WLAN
>  	bool "Wireless LAN"
>  	depends on !S390
> +	select WIRELESS
>  	default y
>  	---help---
>  	  This section contains all the pre 802.11 and 802.11 wireless


I suppose that's OK, although I prefer "depends" rather than "select".

I tracked down one of the problems that I was seeing:

net/wireless/wext-priv.c:206: error: implicit declaration of function 'call_commit_handler'

with:
# CONFIG_WIRELESS is not set
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_PRIV=y

This is being caused by several drivers in drivers/staging/ doing
	select WEXT_PRIV
without using either enough dependencies or even more (ugly) selects.
(or just because kconfig isn't sufficient)


---
~Randy
