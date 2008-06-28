Return-Path: <linux-kernel-owner+w=401wt.eu-S1757327AbYF1Nq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327AbYF1Nq7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 09:46:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753207AbYF1Nqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 09:46:51 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:49737 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752982AbYF1Nqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 09:46:51 -0400
Date: Sat, 28 Jun 2008 15:47:00 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: linux-kernel@vger.kernel.org, Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: [PATCH 2/3] mmc: Export ios settings for a host through debugfs
Message-ID: <20080628154700.426a422c@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <20080628153403.0870e96c@mjolnir.drzeus.cx>
References: <1214478589-21291-1-git-send-email-haavard.skinnemoen@atmel.com>
	<1214478589-21291-2-git-send-email-haavard.skinnemoen@atmel.com>
	<20080628153403.0870e96c@mjolnir.drzeus.cx>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Jun 2008 13:46:48.0309 (UTC) FILETIME=[69433A50:01C8D925]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman <drzeus-mmc@drzeus.cx> wrote:
> On Thu, 26 Jun 2008 13:09:48 +0200
> Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:

> > +static void mmc_remove_ios_debugfs(struct mmc_ios *ios)
> > +{
> > +	if (ios->dbg_root) {
> 
> You can save a bit of indentation if you do:
> 
> 	if (!ios->dbg_root)
> 		return;

Good point.

> > +static int mmc_add_ios_debugfs(struct mmc_ios *ios, struct dentry *parent)
> > +{
> > +	struct dentry *dir;
> > +
> > +	dir = debugfs_create_dir("ios", parent);
> > +	if (!dir)
> > +		return -EBUSY;	/* or whatever */
> 
> Is it undefined what a NULL return means here? I would have expected an
> ERRPTR or ENOMEM.

Yeah...debugfs_create_dir() may return an ERRPTR only if debugfs is
disabled. All other errors return NULL.

We wouldn't be here unless the caller managed to create the host
directory, so checking IS_ERR() is redundant. Maybe ENOMEM would make
more sense, but I could also be that the directory already exists,
hence EBUSY is appropriate. We really don't know as long as debugfs
keeps us in the dark...

> > +#ifdef CONFIG_MMC_DEBUG_FS
> > +	struct dentry		*dbg_root;
> > +	struct dentry		*dbg_clock;
> > +	struct dentry		*dbg_vdd;
> > +	struct dentry		*dbg_bus_mode;
> > +	struct dentry		*dbg_chip_select;
> > +	struct dentry		*dbg_power_mode;
> > +	struct dentry		*dbg_bus_width;
> > +	struct dentry		*dbg_timing;
> > +#endif
> 
> Can't we use debugfs' own bookkeeping to keep track of them? Saves us a
> lot of noise in these structures.

You mean d_subdirs in struct dentry? I guess we could do that...though
I was sort of trying not to dig too deply into VFS internals...

Haavard
