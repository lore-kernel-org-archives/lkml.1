Return-Path: <linux-kernel-owner+w=401wt.eu-S1757307AbZJFNbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307AbZJFNbb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 09:31:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757246AbZJFNba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 09:31:30 -0400
Received: from smtp.nokia.com ([192.100.122.233]:24718 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757169AbZJFNba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 09:31:30 -0400
Date: Tue, 6 Oct 2009 16:27:53 +0300
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "dbrownell@users.sourceforge.net" <dbrownell@users.sourceforge.net>
Subject: Re: TTY loosing bytes ?
Message-ID: <20091006132752.GZ4452@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <20091006094845.GT4452@nokia.com>
 <20091006114528.GV4452@nokia.com>
 <20091006131230.5301f711@lxorguk.ukuu.org.uk>
 <20091006130150.GY4452@nokia.com>
 <20091006141115.12ad22dd@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091006141115.12ad22dd@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 06 Oct 2009 13:29:36.0212 (UTC) FILETIME=[0C2B7940:01CA4689]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 06, 2009 at 03:11:15PM +0200, ext Alan Cox wrote:
> > With the patch above I still get this messages but it still goes through
> > since not receive_buf is returning the amount of bytes actually
> > received. Then flush_to_ldisc() will retry those bytes on the next
> > iteration. Maybe this is not the desired patch though ?
> > 
> > Thanks a lot for the comments Alan.
> 
> First guess try the following
> 
> n_tty: For some I/O patterns n_tty will lose bytes
> 
> From: Alan Cox <alan@linux.intel.com>
> 
> Fix the obvious disagreement between the receive path and the receive room
> logic.
> 
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---
> 
>  drivers/char/n_tty.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> 
> diff --git a/drivers/char/n_tty.c b/drivers/char/n_tty.c
> index 2e50f4d..27b28ca 100644
> --- a/drivers/char/n_tty.c
> +++ b/drivers/char/n_tty.c
> @@ -95,6 +95,9 @@ static void n_tty_set_room(struct tty_struct *tty)
>  	/* tty->read_cnt is not read locked ? */
>  	int	left = N_TTY_BUF_SIZE - tty->read_cnt - 1;
>  
> +	if (tty->real_raw)
> +	        left = min(left, N_TTY_BUF_SIZE - tty->read_head - 1);
> +
>  	/*
>  	 * If we are doing input canonicalization, and there are no
>  	 * pending newlines, let characters through without limit, so

unfortunately it didn't work. Although now I don't the debugging prints
complaining we've lost bytes, the transfer does get stuck in lot earlier
stage.

Maybe this is one fix but there's still other problem with that code ?

-- 
balbi
