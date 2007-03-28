Return-Path: <linux-kernel-owner+w=401wt.eu-S965752AbXC1UPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965752AbXC1UPK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 16:15:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965757AbXC1UPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 16:15:09 -0400
Received: from smtp.osdl.org ([65.172.181.24]:57658 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965752AbXC1UPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 16:15:07 -0400
Date: Wed, 28 Mar 2007 13:14:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Kosina <jikos@jikos.cz>
Cc: Lee Revell <rlrevell@joe-job.com>,
       Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
       andrea@suse.de, viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: fs/block_dev.c:953: warning: 'found' might be used
 uninitialized in this function
Message-Id: <20070328131454.cdb06bc3.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703281909240.29565@twin.jikos.cz>
References: <200703281847.05356.toralf.foerster@gmx.de>
	<75b66ecd0703280956i522cf6cbyc4c9ef8b1666ec15@mail.gmail.com>
	<Pine.LNX.4.64.0703281909240.29565@twin.jikos.cz>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Mar 2007 19:23:32 +0200 (CEST)
Jiri Kosina <jikos@jikos.cz> wrote:

> blockdev: bd_claim_by_kobject() could check value of unititalized pointer
> 
> Fixes this warning:
> 
> fs/block_dev.c: In function `bd_claim_by_kobject':
> fs/block_dev.c:953: warning: 'found' might be used uninitialized in this function
> 
> struct bd_holder *found is initialized only when bd_claim() returns zero. If it
> returns nonzero, ptr stays uninitialized. Later the value of the pointer is checked.
> 
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> 
> diff --git a/drivers/usb/input/hid-tmff.c b/drivers/usb/input/hid-tmff.c
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index 575076c..e87d84a 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -950,7 +950,7 @@ static int bd_claim_by_kobject(struct block_device *bdev, void *holder,
>  				struct kobject *kobj)
>  {
>  	int res;
> -	struct bd_holder *bo, *found;
> +	struct bd_holder *bo, *found = NULL;

that generates extra code and people get upset.

One approach which we could ue in here is

	struct bd_holder *found = found;  /* Suppress bogus gcc warning */

which (surprisingly) gcc will currently accept, and which shouldn't
generate more code, although I haven't verified this.


But it's all rather ad-hoc and unpleasant.  I tend to think that we should
come up with some standardised way of squashing this warning - something
which stands out when one is reading the code, like

	struct bd_holder *found;

	squash_bogus_uninit_warning(found);	/* useful comment goes here */

which is also unpleasant, but not as unpleasant as a screenful of warnings
which hide real problems, IMO.


