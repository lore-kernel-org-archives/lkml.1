Return-Path: <linux-kernel-owner+w=401wt.eu-S1754007Ab0AZTuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007Ab0AZTuM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 14:50:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752658Ab0AZTuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 14:50:11 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:52451 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab0AZTuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 14:50:09 -0500
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Al Viro <viro@ZenIV.linux.org.uk>,
       Tavis Ormandy <taviso@google.com>, Jeff Dike <jdike@addtoit.com>,
       Julien Tinnes <jln@google.com>, Matt Mackall <mpm@selenic.com>
Subject: Re: [06/11] tty: fix race in tty_fasync
References: <20100126191624.538119758@mini.kroah.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 26 Jan 2010 11:49:58 -0800
In-Reply-To: <20100126191624.538119758@mini.kroah.org> (Greg KH's message of "Tue\, 26 Jan 2010 11\:14\:42 -0800")
Message-ID: <m1bpggy7bt.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@suse.de> writes:

> 2.6.27-stable review patch.  If anyone has any objections, please let us know.

Only that __f_setown by way of f_modown unconditionally enables interrupts.  So
without touching f_modown as well in mainline we have nasty sounding lockdep warnings.

Eric


> ------------------
>
> From: Greg Kroah-Hartman <gregkh@suse.de>
>
> commit 703625118069f9f8960d356676662d3db5a9d116 upstream.
>
> We need to keep the lock held over the call to __f_setown() to
> prevent a PID race.
>
> Thanks to Al Viro for pointing out the problem, and to Travis for
> making us look here in the first place.
>
> Cc: Eric W. Biederman <ebiederm@xmission.com>
> Cc: Al Viro <viro@ZenIV.linux.org.uk>
> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Tavis Ormandy <taviso@google.com>
> Cc: Jeff Dike <jdike@addtoit.com>
> Cc: Julien Tinnes <jln@google.com>
> Cc: Matt Mackall <mpm@selenic.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>
> ---
>  drivers/char/tty_io.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- a/drivers/char/tty_io.c
> +++ b/drivers/char/tty_io.c
> @@ -2437,8 +2437,8 @@ static int tty_fasync(int fd, struct fil
>  			pid = task_pid(current);
>  			type = PIDTYPE_PID;
>  		}
> -		spin_unlock_irqrestore(&tty->ctrl_lock, flags);
>  		retval = __f_setown(filp, pid, type, 0);
> +		spin_unlock_irqrestore(&tty->ctrl_lock, flags);
>  		if (retval)
>  			goto out;
>  	} else {
