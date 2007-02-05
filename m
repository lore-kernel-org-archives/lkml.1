Return-Path: <linux-kernel-owner+w=401wt.eu-S1751811AbXBEQ4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811AbXBEQ4T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 11:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751798AbXBEQ4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 11:56:18 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:56092 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbXBEQ4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 11:56:17 -0500
Date: Mon, 5 Feb 2007 16:56:11 +0000
From: Christoph Hellwig <hch@infradead.org>
To: akuster <akuster@mvista.com>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: [patch 1/1] PM: Adds remount fs ro at suspend
Message-ID: <20070205165611.GA4777@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	akuster <akuster@mvista.com>, linux-kernel@vger.kernel.org,
	akpm@osdl.org
References: <20070202235132.EDBDF1C448@hermes.mvista.com> <20070203100848.GA28806@infradead.org> <45C53841.5000505@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45C53841.5000505@mvista.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 03, 2007 at 03:34:57PM -1000, akuster wrote:
> >Can you please explain why this can't be done in userspace?  
> 
> I am sure it can.  The idea came from customer inputs, speed is my 
> guess. echo mem > /sys/../state seems a whole lot simpler and cleaner 
> than having userspace figure out what it mounted and then doing echo mem.

I don't think we really want people to use the kernel interface directly.
Currently the distros seem to use the s2ram and s2disk helpers IIRC.

In any case there should be a userland abstraction doing all helper work
and finally calling into the kernel.

It would be nice if the embedded folk could work together with the desktop
people on the userland bits for power managment.

> In fact
> >all existing suspend solutions seem to be doing fine doing things like
> >this in userspace.
> 
> I guess I missed that boat. If you don't mind, could you point at one 
> solution.

> >NACK.  emergency_remount is exactly what it sais and should never ever
> >be used for a system that you want to keep on using later on.  
> 
> The code "emergency_remount" is almost identical to what we have been 
> using. I wanted to reuse existing code rather than dup it.

The problem with emergency_remount is that it calls do_remount_sb with
the force argument, which then calls into mark_files_ro.  This isn't
very useful because it doesn't actually stop existing writers and seems
to have a racy f_mode access.  Then again it doesn't really help either
that we want to get rid of file_list_lock the sb->s_files :)

If you really want to stop all current writes you need to call freeze_bdev,
and I'd rather expose that through a separate user interface instead of
hooking it into the suspend process at the kernel side.  For XFS you
could use the private ioctls already today, but I'd prefer a more general
solution.

