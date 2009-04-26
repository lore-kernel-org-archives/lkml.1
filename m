Return-Path: <linux-kernel-owner+w=401wt.eu-S1753272AbZDZGP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272AbZDZGP7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 02:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751248AbZDZGPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 02:15:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35428 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871AbZDZGPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 02:15:48 -0400
Date: Sun, 26 Apr 2009 08:15:47 +0200
From: Nick Piggin <npiggin@suse.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 01/27] fs: cleanup files_lock
Message-ID: <20090426061547.GB28555@wotan.suse.de>
References: <20090425012020.457460929@suse.de> <20090425012209.061706790@suse.de> <20090425104234.3c2ea3b4@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090425104234.3c2ea3b4@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 25, 2009 at 10:42:34AM +0100, Alan Cox wrote:
> On Sat, 25 Apr 2009 11:20:21 +1000
> npiggin@suse.de wrote:
> 
> > Lock tty_files with tty_mutex, provide helpers to manipulate the per-sb
> > files list, and unexport the files_lock spinlock.
> 
> This looks half like a backward step to me: It swaps clean method calls
> for open coded stuff and it adds more random undocumented uses to
> tty_mutex, which has far too much already.
> 
> I don't think
> 
> -	file_move(filp, &tty->tty_files);
> +
> +	mutex_lock(&tty_mutex);
> +	file_list_del(filp);
> +	list_add(&filp->f_u.fu_list, &tty->tty_files);
> +	mutex_unlock(&tty_mutex);
> 
> is exactly an improvement, nor is 
> 
> -	file_move(filp, &tty->tty_files);
> -	check_tty_count(tty, "tty_open");
> +	mutex_lock(&tty_mutex);
> +	BUG_ON(list_empty(&filp->f_u.fu_list));
> +	file_list_del(filp); /* __dentry_open has put it on the sb list
>   */
> +	list_add(&filp->f_u.fu_list, &tty->tty_files);
> +	__check_tty_count(tty, "tty_open");
> +	mutex_unlock(&tty_mutex);
> 
> The basic idea looks totally sound but it can use its own lock and there
> should be helpers so this stuff doesn't have to get open coded.

Yes, I agree it was silly to try reusing tty_mutex for this, as you
and Al point out. I've just added a new spinlock for the tty layer
for the moment, which makes it much more like a mechanical search/
replace.

