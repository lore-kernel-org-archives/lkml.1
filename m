Return-Path: <linux-kernel-owner+w=401wt.eu-S1754435AbZEIMKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435AbZEIMKT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 08:10:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbZEIMKB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 08:10:01 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:58766 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866AbZEIMKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 08:10:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mail-followup-to
         :references:mime-version:content-type:content-disposition
         :in-reply-to:user-agent;
        b=rBuBnlivkMBNJMKX1mLWrOymw8sLv+OYQNBi786JiVc5N8+gLSus2pOdbiS2oXTQ7e
         xmYpPaYhnewbMn/5av/y6hTJAsnV1zdSbEUEMwgTAx7o0g5t56L0PBsKk0dZnHNJhfr/
         bSKvT/BynS0MOmQlI2XDhlOqRiVdircWtGmrs=
Date: Sat, 9 May 2009 14:09:55 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Borislav Petkov <petkovbb@googlemail.com>, bzolnier@gmail.com,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/14] ide-tape: fix potential fs requests bug
Message-ID: <20090509120955.GA5749@liondog.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com, Sam Ravnborg <sam@ravnborg.org>,
	Borislav Petkov <petkovbb@googlemail.com>, bzolnier@gmail.com,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1241855134-4984-1-git-send-email-petkovbb@gmail.com> <1241855134-4984-2-git-send-email-petkovbb@gmail.com> <20090509080245.GB22617@uranus.ravnborg.org> <20090509085008.GA5261@liondog.tnic> <20090509102514.GA23517@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090509102514.GA23517@uranus.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, May 09, 2009 at 12:25:14PM +0200, Sam Ravnborg wrote:
> OK - but If I am wondering maybe the next reader will
> think the same
> A small comment:
> /* idetape_get_mode_sense_results() prevent sizes less than 1 << 9 */
> Seems to be reasonable.

but you _shouldn't_ be wondering since there's no way for the ide tape
to have smaller blocksize, at least according to the spec - I've yet to
see a device with lesser blocksize.

However, if we still get divide-by-zero then there's something else
that is broken in the driver and a simple comment won't prevent us from
hitting the bug. Instead, the code has to be fixed (and we'll fix it
like the countless other times we've done it sofar).

By the way, ide-floppy does the same calculation because some devices
do have blocksize > 512. And there's no comment there either in
ide_floppy_get_capacity(), the line doing:

floppy->bs_factor = length / 512;

which is basically the same operation (>> 9) for integer types.

And the reason for not having comment there is that 512 is the smallest
blocksize for that type of devices and a comment like that is simply
superfluous because blocksize < 512 is just _not_ _happening_ for the
zillion devices out there.

-- 
Regards/Gruss,
    Boris.
