Return-Path: <linux-kernel-owner+w=401wt.eu-S1755154AbYFKMgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154AbYFKMgz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 08:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754144AbYFKMgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 08:36:46 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:35452 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754129AbYFKMgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 08:36:45 -0400
X-Sasl-enc: qyrjdvu1Ebh3flsPOczof8jijyHlgSpxi5ZkpA6PbKOM 1213187803
Subject: Re: [PATCH] autofs4: fix 32-bit userspace vs 64-bit kernel
	communications
From: Ian Kent <raven@themaw.net>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: autofs mailing list <autofs@linux.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Konstantin Khlebnikov <khlebnikov@openvz.org>
In-Reply-To: <484FA0B8.2000002@openvz.org>
References: <484FA0B8.2000002@openvz.org>
Content-Type: text/plain
Date: Wed, 11 Jun 2008 20:32:59 +0800
Message-Id: <1213187579.4994.25.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-06-11 at 13:54 +0400, Pavel Emelyanov wrote:
> From: Konstantin Khlebnikov <khlebnikov@openvz.org>
> 
> The struct autofs_v5_packet has only one difference between
> 32-bit and 64-bit versions - on 64-bit gcc aligns its size and
> it is 4 bytes larger that it is on 32-bit kernel. This confuses
> 32-bit user-space daemon, when talking to 64-bit kernel.

No, I don't think that's quite right.

As far as I know this issue arises when a user space program, compiled
as a 32-bit application is executed within 64-bit user space.

> 
> This is very critical for containerized setups, when containers
> with <different>-bit tolls are used.

Have you tested different situations with this change?
Will this affect the existing check and adjustment the version 5
automount daemon does now?

> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> Acked-by: Pavel Emelyanov <xemul@openvz.org>
> 
> ---
> 
> diff --git a/fs/autofs4/waitq.c b/fs/autofs4/waitq.c
> index 1e4a539..9855b6e 100644
> --- a/fs/autofs4/waitq.c
> +++ b/fs/autofs4/waitq.c
> @@ -132,6 +132,14 @@ static void autofs4_notify_daemon(struct autofs_sb_info *sbi,
>  		struct autofs_v5_packet *packet = &pkt.v5_pkt.v5_packet;
>  
>  		pktsz = sizeof(*packet);
> +#if defined(CONFIG_X86_64) && defined(CONFIG_IA32_EMULATION)
> +		/*
> +		 * On x86_64 autofs_v5_packet struct is padded with 4 bytes
> +		 * which breaks 32-bit autofs daemon.
> +		 */
> +		if (test_thread_flag(TIF_IA32))
> +			pktsz -= 4;
> +#endif
>  
>  		packet->wait_queue_token = wq->wait_queue_token;
>  		packet->len = wq->len;
> 

