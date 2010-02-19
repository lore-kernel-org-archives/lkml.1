Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631Ab0BSVyv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 16:54:51 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56013 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755326Ab0BSVyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 16:54:50 -0500
Date: Fri, 19 Feb 2010 13:53:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rodolfo Giometti <giometti@linux.it>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
       Dave Jones <davej@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
       Greg KH <greg@kroah.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       Alexander Gordeev <lasaine@lvk.cs.msu.su>
Subject: Re: [PATCH 6/8] pps: serial clients support.
Message-Id: <20100219135359.a5c195ea.akpm@linux-foundation.org>
In-Reply-To: <1266313885-1195-7-git-send-email-giometti@linux.it>
References: <1266313885-1195-1-git-send-email-giometti@linux.it>
	<1266313885-1195-2-git-send-email-giometti@linux.it>
	<1266313885-1195-3-git-send-email-giometti@linux.it>
	<1266313885-1195-4-git-send-email-giometti@linux.it>
	<1266313885-1195-5-git-send-email-giometti@linux.it>
	<1266313885-1195-6-git-send-email-giometti@linux.it>
	<1266313885-1195-7-git-send-email-giometti@linux.it>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Feb 2010 10:51:23 +0100
Rodolfo Giometti <giometti@linux.it> wrote:

> Adds support, by using the PPS line discipline, for the PPS sources
> connected with the CD (Carrier Detect) pin of a serial port.
> 
> ...
>
> +static int (*n_tty_open)(struct tty_struct *tty);
> +
> +static int pps_tty_open(struct tty_struct *tty)
> +{
> +	struct pps_source_info info;
> +	struct tty_driver *drv = tty->driver;
> +	int index = tty->index + drv->name_base;
> +	int ret;
> +
> +	info.owner = THIS_MODULE;
> +	info.dev = NULL;
> +	snprintf(info.name, PPS_MAX_NAME_LEN, "%s%d", drv->driver_name, index);
> +	snprintf(info.path, PPS_MAX_NAME_LEN, "/dev/%s%d", drv->name, index);
> +	info.mode = PPS_CAPTUREBOTH | \
> +			PPS_OFFSETASSERT | PPS_OFFSETCLEAR | \
> +			PPS_CANWAIT | PPS_TSFMT_TSPEC;
> +
> +	ret = pps_register_source(&info, PPS_CAPTUREBOTH | \
> +				PPS_OFFSETASSERT | PPS_OFFSETCLEAR);
> +	if (ret < 0) {
> +		pr_err("cannot register PPS source \"%s\"\n", info.path);
> +		return ret;
> +	}
> +	tty->disc_data = (void *) ret;
> +
> +	/* Should open N_TTY ldisc too */
> +	ret = n_tty_open(tty);
> +	if (ret < 0)
> +		pps_unregister_source((int) tty->disc_data);
> +
> +	pr_info("PPS source #%d \"%s\" added\n", ret, info.path);
> +
> +	return 0;
> +}

hm.  The n_tty_open/close layering is a bit grubby but I guess we don't
have a need to create anything more comprehensive at this stage.

A small stylistic thing: the code's a bit confusing at present because
the names n_tty_open/n_tty_close are identical to the global functions
over in n_tty.c.  A user of ctags will be tricked.  Also, the _way_ in
which these function pointers are called:

	ret = n_tty_open(tty);

make it look like the code is calling
drivers/char/n_tty.c:n_tty_open().  Except it isn't.

So I think it's better to do it with

	ret = (*n_tty_open)(tty);

to avoid misleading the reader.

And perhaps to rename these variables to avoid the duplication with the
global functions.


