Return-Path: <linux-kernel-owner+w=401wt.eu-S1753808AbYEaJQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808AbYEaJQn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 05:16:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751244AbYEaJQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 05:16:32 -0400
Received: from ti-out-0910.google.com ([209.85.142.190]:47627 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbYEaJQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 05:16:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tcCJ/+SjuDplXm3xQZ92pynHEtl5W1st1JPch5OKeYbQP1SNctZEXEio1EpwW/gYy4HgF/4PXJ6SRdwwsJLqaL50N8RKiQE2hLwMVawHqT/ncely8Sd0A+oN4Oruk3Fj/PWLjwapekShljB7W0cTUBd2aXfrbwnrrDDREzgftCA=
Message-ID: <a8e1da0805310216g2f365ae3xd5dbd1386f219789@mail.gmail.com>
Date: Sat, 31 May 2008 17:16:28 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: davem@davemloft.net
Subject: Re: [PATCH] rfcomm deadlock fix
Cc: arjan@linux.intel.com, marcel@holtmann.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080531090908.GA5399@darkstar.domain.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080531090908.GA5399@darkstar.domain.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, I sent a wrong version, I will sent again after a while.

On Sat, May 31, 2008 at 5:09 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
> There's logic in __rfcomm_dlc_close:
>        rfcomm_dlc_lock(d);
>        d->state = BT_CLOSED;
>        d->state_changed(d, err);
>        rfcomm_dlc_unlock(d);
>
> In rfcomm_dev_state_change, it's possible that rfcomm_dev_put try to take the
> dlc lock, then we will deadlock.
>
> Here fixed it by unlock dlc before rfcomm_dev_get in rfcomm_dev_state_change.
>
> why not unlock just before rfcomm_dev_put? it's because there's another problem.
> rfcomm_dev_get/rfcomm_dev_del will take rfcomm_dev_lock, but in rfcomm_dev_add
> the lock order is : rfcomm_dev_lock --> dlc lock
>
> so I unlock dlc before the taken of rfcomm_dev_lock.
>
> Actually it's a regression caused by commit
> 1905f6c736cb618e07eca0c96e60e3c024023428, the dlc state_change could be two
> callbacks : rfcomm_sk_state_change and rfcomm_dev_state_change. I missed the rfcomm_sk_state_change that time.
>
> Thanks Arjan van de Ven <arjan@linux.intel.com> for the effort in commit
> 4c8411f8c115def968820a4df6658ccfd55d7f1a
> but he missed the rfcomm_dev_state_change lock issue.
>
> Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
>
> ---
> net/bluetooth/rfcomm/tty.c  |    9 +++++++++
> 1 files changed, 9 insertions(+)
>
> diff -upr linux/net/bluetooth/rfcomm/tty.c linux.new/net/bluetooth/rfcomm/tty.c
> --- linux/net/bluetooth/rfcomm/tty.c    2008-05-30 15:46:33.000000000 +0800
> +++ linux.new/net/bluetooth/rfcomm/tty.c        2008-05-30 16:02:38.000000000 +0800
> @@ -566,11 +566,20 @@ static void rfcomm_dev_state_change(stru
>        if (dlc->state == BT_CLOSED) {
>                if (!dev->tty) {
>                        if (test_bit(RFCOMM_RELEASE_ONHUP, &dev->flags)) {
> +                               /* Drop DLC lock here to avoid deadlock
> +                                * 1. rfcomm_dev_get will take rfcomm_dev_lock
> +                                *    but in rfcomm_dev_add there's lock order:
> +                                *    rfcomm_dev_lock -> dlc lock
> +                                * 2. rfcomm_dev_put will deaklock if it's
> +                                *    the last reference
> +                                */
> +                               rfcomm_dlc_unlock(dlc);
>                                if (rfcomm_dev_get(dev->id) == NULL)
>                                        return;
>
>                                rfcomm_dev_del(dev);
>                                rfcomm_dev_put(dev);
> +                               rfcomm_dlc_lock(dlc);
>                        }
>                } else
>                        tty_hangup(dev->tty);
>



-- 
---
Regards
dave
