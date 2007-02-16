Return-Path: <linux-kernel-owner+w=401wt.eu-S1423219AbXBPE5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423219AbXBPE5U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 23:57:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423230AbXBPE5U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 23:57:20 -0500
Received: from smtp.osdl.org ([65.172.181.24]:49803 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423219AbXBPE5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 23:57:19 -0500
Date: Thu, 15 Feb 2007 20:56:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Zwane Mwaikambo <zwane@infradead.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Tobias Hain <tobias.hain@gmx.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] Don't probe for DDC on VBE1.2
Message-Id: <20070215205658.56096f97.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0702132145460.28458@montezuma.fsmlabs.com>
References: <Pine.LNX.4.64.0702132145460.28458@montezuma.fsmlabs.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Feb 2007 08:29:49 -0800 (PST) Zwane Mwaikambo <zwane@infradead.org> wrote:

> VBE1.2 doesn't support function 15h (DDC) resulting in a 'hang' whilst
> uncompressing kernel with some video cards. Make sure we check VBE version 
> before fiddling around with DDC.
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=1458
> 
> Opened: 2003-10-30 09:12 Last update: 2007-02-13 22:03
> 
> :(
> 
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

This makes the long-suffering-but-vigorously-defended Vaio come up with a
black display.  Everything's working OK otherwise.  Sort of a Black Screen
of Life.  I wouldn't call it an improvement though.
