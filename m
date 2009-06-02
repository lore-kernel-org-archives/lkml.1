Return-Path: <linux-kernel-owner+w=401wt.eu-S1757029AbZFBRWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757029AbZFBRWU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 13:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754722AbZFBRWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 13:22:07 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:59571 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754632AbZFBRWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 13:22:06 -0400
X-AuthUser: davidel@xmailserver.org
Date: Tue, 2 Jun 2009 10:16:01 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Gregory Haskins <ghaskins@novell.com>
cc: kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com, mst@redhat.com, paulmck@linux.vnet.ibm.com
Subject: Re: [KVM-RFC PATCH 2/2] kvm: use POLLHUP to close an irqfd instead
 of an explicit ioctl
In-Reply-To: <20090602151538.29746.40356.stgit@dev.haskins.net>
Message-ID: <alpine.DEB.1.10.0906021011390.12866@makko.or.mcafeemobile.com>
References: <20090602151135.29746.91320.stgit@dev.haskins.net> <20090602151538.29746.40356.stgit@dev.haskins.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Jun 2009, Gregory Haskins wrote:

> @@ -64,12 +101,28 @@ irqfd_wakeup(wait_queue_t *wait, unsigned mode, int sync, void *key)
>  {
>  	struct _irqfd *irqfd = container_of(wait, struct _irqfd, wait);
>  
> -	/*
> -	 * The wake_up is called with interrupts disabled.  Therefore we need
> -	 * to defer the IRQ injection until later since we need to acquire the
> -	 * kvm->lock to do so.
> -	 */
> -	schedule_work(&irqfd->work);
> +	switch ((unsigned long)key) {
> +	case POLLIN:
> +		/*
> +		 * The POLLIN wake_up is called with interrupts disabled.
> +		 * Therefore we need to defer the IRQ injection until later
> +		 * since we need to acquire the kvm->lock to do so.
> +		 */
> +		schedule_work(&irqfd->inject);
> +		break;
> +	case POLLHUP:
> +		/*
> +		 * The POLLHUP is called unlocked, so it theoretically should
> +		 * be safe to remove ourselves from the wqh
> +		 */
> +		remove_wait_queue(irqfd->wqh, &irqfd->wait);
> +		flush_work(&irqfd->inject);
> +		irqfd_disconnect(irqfd);
> +
> +		cleanup_srcu_struct(&irqfd->srcu);
> +		kfree(irqfd);
> +		break;
> +	}

Since "key" is an event *bitmap*, you better be treating it as such. Do 
not assume what eventfd delivers today (event bitmaps with only one bit 
set). So this better be like:

	if (key & POLLIN) {
		...
	}
	if (key & POLLHUP) {
		...
	}


- Davide


