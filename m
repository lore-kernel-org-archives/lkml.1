Return-Path: <linux-kernel-owner+w=401wt.eu-S1755145AbYDWRMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145AbYDWRMK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 13:12:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752576AbYDWRL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 13:11:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55989 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752272AbYDWRLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 13:11:55 -0400
Date: Wed, 23 Apr 2008 10:11:23 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Ingo Molnar <mingo@elte.hu>, Frans Pop <elendil@planet.nl>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, gregkh@suse.de,
       zaitcev@redhat.com
Subject: Re: [sched-devel/latest] WARNING: at mm/slub.c:2443
Message-Id: <20080423101123.a69e4945.zaitcev@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0804231038210.26134@sbz-30.cs.Helsinki.FI>
References: <200804212310.41729.elendil@planet.nl>
	<20080422134034.GF7311@elte.hu>
	<20080422235148.c49dc6b7.zaitcev@redhat.com>
	<Pine.LNX.4.64.0804231038210.26134@sbz-30.cs.Helsinki.FI>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.5.0beta1 (GTK+ 2.12.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Apr 2008 10:38:45 +0300 (EEST), Pekka J Enberg <penberg@cs.helsinki.fi> wrote:

> > The code analysis for usbmon shows nothing. Anyone wants to have
> > a look?

Thanks for taking this little challenge, let's have a look...

> --- a/drivers/usb/mon/mon_text.c
> +++ b/drivers/usb/mon/mon_text.c
> @@ -449,6 +449,7 @@ static struct mon_event_text *mon_text_read_wait(struct mon_reader_text *rp,
>  		if (file->f_flags & O_NONBLOCK) {
>  			set_current_state(TASK_RUNNING);
>  			remove_wait_queue(&rp->wait, &waita);
> +			kmem_cache_free(rp->e_slab, ep);
>  			return ERR_PTR(-EWOULDBLOCK);

The code looks like this:

	while ((ep = mon_text_fetch(rp, mbus)) == NULL) {
		if (file->f_flags & O_NONBLOCK) {
			set_current_state(TASK_RUNNING);
			remove_wait_queue(&rp->wait, &waita);
			return ERR_PTR(-EWOULDBLOCK);

It's impossible to get inside the while() with non-null ep,
so your patch doesn't fix anything (even if kmem_cache_free
can survive a NULL object).

Any other ideas?

-- Pete
