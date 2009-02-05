Return-Path: <linux-kernel-owner+w=401wt.eu-S1757151AbZBEP15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757151AbZBEP15 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 10:27:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752065AbZBEP1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 10:27:49 -0500
Received: from cnc.isely.net ([64.81.146.143]:48122 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699AbZBEP1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 10:27:48 -0500
X-Greylist: delayed 320 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Feb 2009 10:27:48 EST
Date: Thu, 5 Feb 2009 09:22:25 -0600 (CST)
From: Mike Isely <isely@isely.net>
Reply-To: Mike Isely <isely@pobox.com>
To: Floris Kraak <randakar@gmail.com>
cc: Roland Dreier <rdreier@cisco.com>, Robert Hancock <hancockrwd@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Trivial Patch Monkey <trivial@kernel.org>,
       Andreas Schwab <schwab@suse.de>
Subject: Re: [PATCH]: Cleanup: Remove gcc format string warnings when compiling
  with -Wformat-security (was: Re: [PATCH] Kbuild: Disable the  -Wformat-security
 gcc flag)
In-Reply-To: <56e1b5710902050641l5ece10e5hedd11fb3f4292886@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0902050908400.7489@cnc.isely.net>
References: <56e1b5710902050641l5ece10e5hedd11fb3f4292886@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Feb 2009, Floris Kraak wrote:

   [...]

> 
> Here's the patch that I get when I blindly patch every single location
> that emits this warning.
> As noted before in some cases I'm not 100% sure this is the right way
> to go about it but it certainly is the KISS solution.
> 
> If needed I can attempt to split this monster into 135 patches but
> given my limited experience with the tools involved a little help on
> how to go about creating such a series would be appreciated ;-)
> 
> ---
> Cleanup: Remove gcc format string warnings when compiling with -Wformat-security
> 
> When compiling the kernel with an allyesconfig and the gcc flags
> -Wformat and -Wformat-security the build process emits 135 warnings
> along these lines:
> 
> init/main.c:557: warning: format not a string literal and no format arguments
> init/initramfs.c:582: warning: format not a string literal and no
> format arguments
> arch/x86/kernel/dumpstack.c:115: warning: format not a string literal
> and no format arguments
> ...
> 
> While many of these warnings are harmless - the format string is
> statically set within the kernel itself and is known to not contain
> any format qualifiers - a number of them are potentially less so.
> This patch fixes all known call sites emitting this warning.
> 
> Signed-off-by: Floris Kraak <randakar@gmail.com>
> ---

   [...]

> diff --git a/drivers/media/video/pvrusb2/pvrusb2-hdw.c
> b/drivers/media/video/pvrusb2/pvrusb2-hdw.c
> index fa304e5..42ccab0 100644
> --- a/drivers/media/video/pvrusb2/pvrusb2-hdw.c
> +++ b/drivers/media/video/pvrusb2/pvrusb2-hdw.c
> @@ -1967,7 +1967,7 @@ static void pvr2_hdw_setup_low(struct pvr2_hdw *hdw)
>  	if (!pvr2_hdw_dev_ok(hdw)) return;
> 
>  	for (idx = 0; idx < hdw->hdw_desc->client_modules.cnt; idx++) {
> -		request_module(hdw->hdw_desc->client_modules.lst[idx]);
> +		request_module("%s", hdw->hdw_desc->client_modules.lst[idx]);
>  	}

The incoming string in this case comes from a static initialization in 
the same source file (it's a compiled-in list of support module names to 
select based on the specific hardware type that the driver has 
detected).


> 
>  	if (!hdw->hdw_desc->flag_no_powerup) {
> diff --git a/drivers/media/video/pvrusb2/pvrusb2-std.c
> b/drivers/media/video/pvrusb2/pvrusb2-std.c
> index ca9f83a..c18091e 100644
> --- a/drivers/media/video/pvrusb2/pvrusb2-std.c
> +++ b/drivers/media/video/pvrusb2/pvrusb2-std.c
> @@ -216,7 +216,7 @@ unsigned int pvr2_std_id_to_str(char *bufPtr,
> unsigned int bufSize,
>  			bufSize -= c2;
>  			bufPtr += c2;
>  			c2 = scnprintf(bufPtr,bufSize,
> -				       ip->name);
> +				       "%s", ip->name);
>  			c1 += c2;
>  			bufSize -= c2;
>  			bufPtr += c2;

The pointer "ip" points into another array of structs, a member of which 
is a const string which is where the 'name' field comes from.  Thus once 
again there's no way an outside influence can inject a '%' here.

In both of these cases, the proposed change doesn't do any harm, but it 
does introduce some otherwise pointless inefficiency.

But hey, if this is all with the goal of silencing another script 
casting a big net, I won't stand in the way.

Acked-By: Mike Isely <isely@pobox.com>

  -Mike


-- 

Mike Isely
isely @ pobox (dot) com
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
