Return-Path: <linux-kernel-owner+w=401wt.eu-S965055AbXDVSzI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965055AbXDVSzI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 14:55:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965641AbXDVSzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 14:55:07 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46439 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965055AbXDVSzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 14:55:05 -0400
Date: Sun, 22 Apr 2007 11:54:41 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nicolas Pitre <nico@cam.org>
cc: Junio C Hamano <junkio@cox.net>, git@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Today's 'master' leaves .idx/.pack in 0400
In-Reply-To: <alpine.LFD.0.98.0704221431430.28339@xanadu.home>
Message-ID: <alpine.LFD.0.98.0704221144250.9964@woody.linux-foundation.org>
References: <7vhcrml4wx.fsf@assigned-by-dhcp.cox.net> <7v1widrl0o.fsf@assigned-by-dhcp.cox.net>
 <alpine.LFD.0.98.0704221019100.9964@woody.linux-foundation.org>
 <7vvefonvdz.fsf@assigned-by-dhcp.cox.net> <7vmz10nv1h.fsf_-_@assigned-by-dhcp.cox.net>
 <alpine.LFD.0.98.0704221422250.28339@xanadu.home> <7vejmcnu28.fsf@assigned-by-dhcp.cox.net>
 <alpine.LFD.0.98.0704221431430.28339@xanadu.home>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 22 Apr 2007, Nicolas Pitre wrote:
> 
> Well, actually there is no point making pack files writable.  If they're 
> modified, they get corrupted.
> 
> Here's the fix I wanted to propose:
> 
> diff --git a/builtin-pack-objects.c b/builtin-pack-objects.c
> index c72e07a..85c6e6e 100644
> --- a/builtin-pack-objects.c
> +++ b/builtin-pack-objects.c
> @@ -1786,11 +1786,13 @@ int cmd_pack_objects(int argc, const char **argv, const char *prefix)
>  		if (rename(pack_tmp_name, tmpname))
>  			die("unable to rename temporary pack file: %s",
>  			    strerror(errno));
> +		chmod(tmpname, 0444);

I think this is wrong (as is Junio's). I think we should still honor the 
repository permission setting, and default to honoring umask.

So I think that if the user has a umask that says "nobody else can read", 
then we should *not* make it world readable (unless the 
"shared_repository" thing is set to override it, of course).

		Linus
