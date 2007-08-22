Return-Path: <linux-kernel-owner+w=401wt.eu-S1764611AbXHVPGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764611AbXHVPGs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 11:06:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762984AbXHVPFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 11:05:42 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:39647 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763328AbXHVPFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 11:05:41 -0400
Date: Wed, 22 Aug 2007 10:28:25 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andi Kleen <ak@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [RFC][PATCH -mm 3/4] Hibernation: Pass CR3 in the image header on x86_64
Message-ID: <20070822082825.GC2479@elf.ucw.cz>
References: <200708221015.16493.rjw@sisk.pl> <200708221020.34988.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708221020.34988.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Since we already pass the address of restore_registers() in the image header,
> we can also pass the value of the CR3 register from before the hibernation in
> the same way.  This will allow us to avoid using init_level4_pgt page tables
> during the restore.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

> @@ -253,10 +262,13 @@ int arch_hibernation_header_save(void *a
>  {
>  	struct restore_data_record *rdr = addr;
>  
> -	if (max_size < sizeof(struct restore_data_record))
> +	if (max_size < sizeof(*rdr))
>  		return -EOVERFLOW;
>  	rdr->jump_address = restore_jump_address;
> -	rdr->control = (restore_jump_address ^ RESTORE_MAGIC);
> +	rdr->cr3 = restore_cr3;
> +	rdr->magic = RESTORE_MAGIC;
> +	rdr->crc = 0;
> +	rdr->crc = crc32_le(0, addr, sizeof(*rdr));
>  	return 0;
>  }

No, I do not think I like that. I believe both -> control and -> crc
is just useless paranoia. Bitflip in this area is not going to be any
worse than bitflip anywhere else, we should not pretend this is
somehow "more important".

-> control should really be "protocol version"... probably should
contain some field that is easy to increment.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
