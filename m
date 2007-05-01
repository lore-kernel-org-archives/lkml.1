Return-Path: <linux-kernel-owner+w=401wt.eu-S1945944AbXEAUq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945944AbXEAUq4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 16:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946003AbXEAUqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 16:46:36 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47258 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946000AbXEAUq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 16:46:26 -0400
Date: Tue, 1 May 2007 21:46:23 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "James E.J. Bottomley" <James.Bottomley@SteelEye.com>,
       Michael Schmitz <schmitz@debian.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [patch 01/33] m68k: Atari SCSI revival
Message-ID: <20070501204623.GA21080@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@SteelEye.com>,
	Michael Schmitz <schmitz@debian.org>,
	Roman Zippel <zippel@linux-m68k.org>
References: <20070501203234.252205858@mail.of.borg> <20070501203328.845749634@mail.of.borg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070501203328.845749634@mail.of.borg>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2007 at 10:32:35PM +0200, Geert Uytterhoeven wrote:
> From: Michael Schmitz <schmitz@opal.biophys.uni-duesseldorf.de>
> 
> SCSI should be working on a TT (but someone should really try!) but causes
> trouble on a Falcon (as in: it ate a filesystem of mine) at least when
> used concurrently with IDE. I have the notion it's because locking of the
> ST-DMA interrupt by IDE is broken in 2.6 (the IDE driver always complains
> about trying to release an already-released ST-DMA). Needs more work, but
> that's on the IDE or m68k interrupt side rather than SCSI.

>  /* 
> + * our own old-style timeout update
> + */
> +/*
> + * The strategy is to cause the timer code to call scsi_times_out()
> + * when the soonest timeout is pending.
> + * The arguments are used when we are queueing a new command, because
> + * we do not want to subtract the time used from this time, but when we
> + * set the timer, we want to take this value into account.
> + */
> +
> +int atari_scsi_update_timeout(Scsi_Cmnd * SCset, int timeout)
> +{
> +    int rtn;
> +
> +    /*
> +     * We are using the new error handling code to actually register/deregister
> +     * timers for timeout.
> +     */
> +
> +    if (!timer_pending(&SCset->eh_timeout)) {
> +	rtn = 0;
> +    } else {
> +	rtn = SCset->eh_timeout.expires - jiffies;
> +    }
> +
> +    if (timeout == 0) {
> +        del_timer(&SCset->eh_timeout);
> +        SCset->eh_timeout.data = (unsigned long) NULL;
> +        SCset->eh_timeout.expires = 0;
> +    } else {
> +        if (SCset->eh_timeout.data != (unsigned long) NULL) 
> +            del_timer(&SCset->eh_timeout);
> +        SCset->eh_timeout.data = (unsigned long) SCset;
> +        SCset->eh_timeout.expires = jiffies + timeout;
> +        add_timer(&SCset->eh_timeout);
> +    }
> +	return rtn;
> +}

NACK, driver have no business messing around with eh_timeout.

> +/* former generic SCSI error handling stuff */
> +
> +#define SCSI_ABORT_SNOOZE 0
> +#define SCSI_ABORT_SUCCESS 1
> +#define SCSI_ABORT_PENDING 2
> +#define SCSI_ABORT_BUSY 3
> +#define SCSI_ABORT_NOT_RUNNING 4
> +#define SCSI_ABORT_ERROR 5
> +
> +#define SCSI_RESET_SNOOZE 0
> +#define SCSI_RESET_PUNT 1
> +#define SCSI_RESET_SUCCESS 2
> +#define SCSI_RESET_PENDING 3
> +#define SCSI_RESET_WAKEUP 4
> +#define SCSI_RESET_NOT_RUNNING 5
> +#define SCSI_RESET_ERROR 6
> +
> +#define SCSI_RESET_SYNCHRONOUS		0x01
> +#define SCSI_RESET_ASYNCHRONOUS		0x02
> +#define SCSI_RESET_SUGGEST_BUS_RESET	0x04
> +#define SCSI_RESET_SUGGEST_HOST_RESET	0x08
> +
> +#define SCSI_RESET_BUS_RESET 0x100
> +#define SCSI_RESET_HOST_RESET 0x200
> +#define SCSI_RESET_ACTION   0xff

Please don't use these anymore but rather kill all uses of them.

Also note that we'd be much happier if you killed the atari
specific NCR8350 and used the generic one instead.
