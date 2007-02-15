Return-Path: <linux-kernel-owner+w=401wt.eu-S1161214AbXBOUpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161214AbXBOUpx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 15:45:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161213AbXBOUpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 15:45:53 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:64091 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161211AbXBOUpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 15:45:52 -0500
Date: Thu, 15 Feb 2007 12:41:43 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Zwane Mwaikambo <zwane@infradead.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Tobias Hain <tobias.hain@gmx.de>
Subject: Re: [PATCH] Don't probe for DDC on VBE1.2
Message-Id: <20070215124143.b52ad45b.randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.64.0702132145460.28458@montezuma.fsmlabs.com>
References: <Pine.LNX.4.64.0702132145460.28458@montezuma.fsmlabs.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Feb 2007 08:29:49 -0800 (PST) Zwane Mwaikambo wrote:

> VBE1.2 doesn't support function 15h (DDC) resulting in a 'hang' whilst
> uncompressing kernel with some video cards. Make sure we check VBE version 
> before fiddling around with DDC.
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=1458
> 
> Opened: 2003-10-30 09:12 Last update: 2007-02-13 22:03
> 
> :(

true.

Just one question:  why use 'je' instead of 'jle' (jge ?) : check for
current version <= 0x0102, whatever that is in gas; I'm still used
to intel syntax.

> Much thanks to Tobias Hain for help in testing and investigating the bug. 
> Tested on;
> 
> i386, Chips & Technologies 65548 VESA VBE 1.2
> CONFIG_VIDEO_SELECT=Y
> CONFIG_FIRMWARE_EDID=Y
> 
> Untested on x86_64.
> 
> Signed-off-by: Zwane Mwaikambo <zwane@infradead.org>
> 
> Index: linux-2.6.20-rc6-mm1/arch/i386/boot/video.S
> ===================================================================
> RCS file: /home/cvsroot/linux-2.6.20-rc6-mm1/arch/i386/boot/video.S,v
> retrieving revision 1.1.1.1
> diff -u -p -B -r1.1.1.1 video.S
> --- linux-2.6.20-rc6-mm1/arch/i386/boot/video.S	30 Jan 2007 05:28:31 -0000	1.1.1.1
> +++ linux-2.6.20-rc6-mm1/arch/i386/boot/video.S	15 Feb 2007 16:27:32 -0000
> @@ -1945,6 +1945,20 @@ store_edid:
>  	rep
>  	stosl
>  
> +	pushw	%es
> +	pushw	%ds
> +	popw	%es
> +	leaw	modelist+1024, %di
> +	movw	$0x4f00, %ax
> +	int	$0x10
> +	popw	%es
> +
> +	cmpw	$0x004f, %ax
> +	jne	no_edid
> +
> +	cmpw	$0x0102, 4(%di)			# only do EDID on > 1.2
> +	je	no_edid
> +
>  	pushw   %es				# save ES
>  	xorw    %di, %di                        # Report Capability
>  	pushw   %di
> Index: linux-2.6.20-rc6-mm1/arch/x86_64/boot/video.S
> ===================================================================
> RCS file: /home/cvsroot/linux-2.6.20-rc6-mm1/arch/x86_64/boot/video.S,v
> retrieving revision 1.1.1.1
> diff -u -p -B -r1.1.1.1 video.S
> --- linux-2.6.20-rc6-mm1/arch/x86_64/boot/video.S	30 Jan 2007 05:28:36 -0000	1.1.1.1
> +++ linux-2.6.20-rc6-mm1/arch/x86_64/boot/video.S	15 Feb 2007 16:27:32 -0000
> @@ -1945,6 +1945,20 @@ store_edid:
>  	rep
>  	stosl
>  
> +	pushw	%es
> +	pushw	%ds
> +	popw	%es
> +	leaw	modelist+1024, %di
> +	movw	$0x4f00, %ax
> +	int	$0x10
> +	popw	%es
> +
> +	cmpw	$0x004f, %ax
> +	jne	no_edid
> +
> +	cmpw	$0x0102, 4(%di)			# only do EDID on > 1.2
> +	je	no_edid
> +
>  	pushw   %es				# save ES
>  	xorw    %di, %di                        # Report Capability
>  	pushw   %di
> -

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
