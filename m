Return-Path: <linux-kernel-owner+w=401wt.eu-S1751684AbXBCKIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751684AbXBCKIw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 05:08:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751766AbXBCKIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 05:08:51 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55560 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbXBCKIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 05:08:51 -0500
Date: Sat, 3 Feb 2007 10:08:49 +0000
From: Christoph Hellwig <hch@infradead.org>
To: akuster@mvista.com
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: [patch 1/1] PM: Adds remount fs ro at suspend
Message-ID: <20070203100848.GA28806@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>, akuster@mvista.com,
	linux-kernel@vger.kernel.org, akpm@osdl.org
References: <20070202235132.EDBDF1C448@hermes.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070202235132.EDBDF1C448@hermes.mvista.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 02, 2007 at 01:50:10PM -1000, akuster@mvista.com wrote:
> 
> 
> This adds the ability for the file system to remounted as read only during a
> system suspend.  Log the mount points so when the resume occurs, they can be 
> remounted back to their original states. This is so in an advent of a power
> failure, we try our best to keep data from being corrupted or lost.

Can you please explain why this can't be done in userspace?  In fact
all existing suspend solutions seem to be doing fine doing things like
this in userspace.

> +static struct suspremount *suspremount_list;
> +
> +void suspend_remount_log_fs(struct super_block *sb)
> +{
> +	struct suspremount *remountp;
> +
> +	if ((remountp = (struct suspremount *)
> +		kmalloc(sizeof(struct suspremount), GFP_KERNEL)) != NULL) {

No need to cast kmalloc return values, and please split assignments and
conditionals into separate lines.

> + * Remount filesystems prior to suspend, in case the
> + * power source is removed (ie, battery removed) or
> + * battery dies during suspend.
> + */
> +
> +void suspend_remount_all_fs_ro(void)
> +{
> +	suspremount_list = NULL;
> +	emergency_remount();

NACK.  emergency_remount is exactly what it sais and should never ever
be used for a system that you want to keep on using later on.  If you
look at it's implementation it's not correct and can't serve as more than
a bandaid for susrq.  In fact we should probably just remove it..

> +EXPORT_SYMBOL(suspend_remount_all_fs_ro);

And something like this for sure should not be exported.

> +EXPORT_SYMBOL(resume_remount_fs_rw);

ditto.

