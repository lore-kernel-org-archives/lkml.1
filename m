Return-Path: <linux-kernel-owner+w=401wt.eu-S1761166AbXHETzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761166AbXHETzZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 15:55:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753835AbXHETzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 15:55:14 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57299 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755839AbXHETzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 15:55:13 -0400
Subject: Re: [patch] implement smarter atime updates support
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jakob Oestergaard <jakob@unthought.net>, Jeff Garzik <jeff@garzik.org>,
       miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de,
       dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       nikita@clusterfs.com, trond.myklebust@fys.uio.no,
       yingchao.zhou@gmail.com, richard@rsk.demon.co.uk, david@lang.hm
In-Reply-To: <20070805192226.GA20234@elte.hu>
References: <alpine.LFD.0.999.0708040915360.5037@woody.linux-foundation.org>
	 <20070804163733.GA31001@elte.hu>
	 <alpine.LFD.0.999.0708041030040.5037@woody.linux-foundation.org>
	 <46B4C0A8.1000902@garzik.org> <20070805102021.GA4246@unthought.net>
	 <46B5A996.5060006@garzik.org> <20070805105850.GC4246@unthought.net>
	 <20070805124648.GA21173@elte.hu>
	 <alpine.LFD.0.999.0708050944470.5037@woody.linux-foundation.org>
	 <20070805190928.GA17433@elte.hu>  <20070805192226.GA20234@elte.hu>
Content-Type: text/plain
Organization: Intel International BV
Date: Sun, 05 Aug 2007 12:53:02 -0700
Message-Id: <1186343582.25667.3.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> +static int relatime_need_update(struct inode *inode, struct timespec now)
> +{
> +	/*
> +	 * Is mtime younger than atime? If yes, update atime:
> +	 */
> +	if (timespec_compare(&inode->i_mtime, &inode->i_atime) >= 0)
> +		return 1;
> +	/*
> +	 * Is ctime younger than atime? If yes, update atime:
> +	 */
> +	if (timespec_compare(&inode->i_ctime, &inode->i_atime) >= 0)
> +		return 1;
> +
> +	/*
> +	 * Is the previous atime value older than a day? If yes,
> +	 * update atime:
> +	 */
> +	if ((long)(now.tv_sec - inode->i_atime.tv_sec) >= 24*60*60)
> +		return 1;


you might want to add

	/* 
	 * if the inode is dirty already, do the atime update since
	 * we'll be doing the disk IO anyway to clean the inode.
	 */
	if (inode->i_state & I_DIRTY)
		return 1;


