Return-Path: <linux-kernel-owner+w=401wt.eu-S1753808AbXJIBa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808AbXJIBa1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 21:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751911AbXJIBaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 21:30:17 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47274 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbXJIBaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 21:30:16 -0400
Date: Tue, 9 Oct 2007 02:30:11 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Tim Pepper <lnxninja@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lockdep: Avoid /proc/lockdep & lock_stat infinite output
Message-ID: <20071009013011.GV8181@ftp.linux.org.uk>
References: <20071009011551.GA3592@tpepper-t42p.dolavim.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071009011551.GA3592@tpepper-t42p.dolavim.us>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2007 at 06:15:51PM -0700, Tim Pepper wrote:
> 
> When a read() requests an amount of data smaller than the amount of data
> that the seq_file's foo_show() outputs, the output starts looping and
> outputs the "stuck" element's data infinitely.  There may be multiple
> sequential calls to foo_start(), foo_next()/foo_show(), and foo_stop()
> for a single open with sequential read of the file.  The _start() does not
> have to start with the 0th element and _show() might be called multiple
> times in a row for the same element for a given open/read of the seq_file.
>  
>  static void *l_start(struct seq_file *m, loff_t *pos)
>  {
> -	struct lock_class *class = m->private;
> +	struct lock_class *class;
> +	loff_t i = 0;
>  
> -	if (&class->lock_entry == all_lock_classes.next)
> +	if (*pos == 0)
>  		seq_printf(m, "all lock classes:\n");

Do not generate output outside of ->show() and you won't have these
problems.  That's where your infinite output crap comes from.

IOW, NAK - fix the underlying problem.
