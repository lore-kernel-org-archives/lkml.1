Return-Path: <linux-kernel-owner+w=401wt.eu-S1755197AbYFAHGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197AbYFAHGm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 03:06:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751215AbYFAHGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 03:06:35 -0400
Received: from senator.holtmann.net ([87.106.208.187]:47360 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbYFAHGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 03:06:34 -0400
Cc: davem@davemloft.net, arjan@linux.intel.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org
Message-Id: <11DE897D-FD47-4F22-9F12-FE258B30D000@holtmann.org>
From: Marcel Holtmann <marcel@holtmann.org>
To: Dave Young <hidave.darkstar@gmail.com>
In-Reply-To: <20080601013410.GA3600@darkstar.domain.name>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Re: [PATCH][resend] rfcomm deadlock fix
Date: Sun, 1 Jun 2008 09:06:22 +0200
References: <20080601013410.GA3600@darkstar.domain.name>
X-Mailer: Apple Mail (2.919.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

> There's logic in __rfcomm_dlc_close:
> 	rfcomm_dlc_lock(d);
> 	d->state = BT_CLOSED;
> 	d->state_changed(d, err);
> 	rfcomm_dlc_unlock(d);
>
> In rfcomm_dev_state_change, it's possible that rfcomm_dev_put try to  
> take the
> dlc lock, then we will deadlock.
>
> Here fixed it by unlock dlc before rfcomm_dev_get in  
> rfcomm_dev_state_change.
>
> why not unlock just before rfcomm_dev_put? it's because there's  
> another problem.
> rfcomm_dev_get/rfcomm_dev_del will take rfcomm_dev_lock, but in  
> rfcomm_dev_add
> the lock order is : rfcomm_dev_lock --> dlc lock
>
> so I unlock dlc before the taken of rfcomm_dev_lock.
>
> Actually it's a regression caused by commit
> 1905f6c736cb618e07eca0c96e60e3c024023428, the dlc state_change could  
> be two
> callbacks : rfcomm_sk_state_change and rfcomm_dev_state_change. I  
> missed the rfcomm_sk_state_change that time.
>
> Thanks Arjan van de Ven <arjan@linux.intel.com> for the effort in  
> commit
> 4c8411f8c115def968820a4df6658ccfd55d7f1a
> but he missed the rfcomm_dev_state_change lock issue.
>
> Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
>
> ---
> net/bluetooth/rfcomm/tty.c |   13 ++++++++++++-
> 1 file changed, 12 insertions(+), 1 deletion(-)
>
> diff -upr linux/net/bluetooth/rfcomm/tty.c linux.new/net/bluetooth/ 
> rfcomm/tty.c
> --- linux/net/bluetooth/rfcomm/tty.c	2008-05-30 15:46:33.000000000  
> +0800
> +++ linux.new/net/bluetooth/rfcomm/tty.c	2008-05-30  
> 17:08:30.000000000 +0800
> @@ -566,11 +566,22 @@ static void rfcomm_dev_state_change(stru
> 	if (dlc->state == BT_CLOSED) {
> 		if (!dev->tty) {
> 			if (test_bit(RFCOMM_RELEASE_ONHUP, &dev->flags)) {
> -				if (rfcomm_dev_get(dev->id) == NULL)
> +				/* Drop DLC lock here to avoid deadlock
> +				 * 1. rfcomm_dev_get will take rfcomm_dev_lock
> +				 *    but in rfcomm_dev_add there's lock order:
> +				 *    rfcomm_dev_lock -> dlc lock
> +				 * 2. rfcomm_dev_put will deaklock if it's
> +				 *    the last reference

I meant this one :)  s/deaklock/deadlock/

Regards

Marcel

