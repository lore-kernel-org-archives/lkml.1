Return-Path: <linux-kernel-owner+w=401wt.eu-S1756164AbYFBBqI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164AbYFBBqI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 21:46:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752982AbYFBBpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 21:45:53 -0400
Received: from ti-out-0910.google.com ([209.85.142.191]:5310 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756145AbYFBBpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 21:45:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=L8fA7e+hywCrAxK3ORDYVfrG66sFIE0Xx93b4k9IuGUxRKcuI3uoT5WOXGyo4ftVEoSAoX4UtEjARVwpX/R+nW9exJr23k65CgKyUy1M8C0Ouyg5yJZqGhTgpAGUShMJuo7RsonmDlT7eYTsYsl2DAhCA9NkauTaXWaLYIXtbEc=
Message-ID: <a8e1da0806011845o5ad3f6a6ja30a05609bfee758@mail.gmail.com>
Date: Mon, 2 Jun 2008 09:45:35 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Marcel Holtmann" <marcel@holtmann.org>
Subject: Re: [PATCH][resend] rfcomm deadlock fix
Cc: davem@davemloft.net, arjan@linux.intel.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org
In-Reply-To: <11DE897D-FD47-4F22-9F12-FE258B30D000@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080601013410.GA3600@darkstar.domain.name>
	 <11DE897D-FD47-4F22-9F12-FE258B30D000@holtmann.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 1, 2008 at 3:06 PM, Marcel Holtmann <marcel@holtmann.org> wrote:
> Hi Dave,
>
>> There's logic in __rfcomm_dlc_close:
>>        rfcomm_dlc_lock(d);
>>        d->state = BT_CLOSED;
>>        d->state_changed(d, err);
>>        rfcomm_dlc_unlock(d);
>>
>> In rfcomm_dev_state_change, it's possible that rfcomm_dev_put try to take
>> the
>> dlc lock, then we will deadlock.
>>
>> Here fixed it by unlock dlc before rfcomm_dev_get in
>> rfcomm_dev_state_change.
>>
>> why not unlock just before rfcomm_dev_put? it's because there's another
>> problem.
>> rfcomm_dev_get/rfcomm_dev_del will take rfcomm_dev_lock, but in
>> rfcomm_dev_add
>> the lock order is : rfcomm_dev_lock --> dlc lock
>>
>> so I unlock dlc before the taken of rfcomm_dev_lock.
>>
>> Actually it's a regression caused by commit
>> 1905f6c736cb618e07eca0c96e60e3c024023428, the dlc state_change could be
>> two
>> callbacks : rfcomm_sk_state_change and rfcomm_dev_state_change. I missed
>> the rfcomm_sk_state_change that time.
>>
>> Thanks Arjan van de Ven <arjan@linux.intel.com> for the effort in commit
>> 4c8411f8c115def968820a4df6658ccfd55d7f1a
>> but he missed the rfcomm_dev_state_change lock issue.
>>
>> Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
>>
>> ---
>> net/bluetooth/rfcomm/tty.c |   13 ++++++++++++-
>> 1 file changed, 12 insertions(+), 1 deletion(-)
>>
>> diff -upr linux/net/bluetooth/rfcomm/tty.c
>> linux.new/net/bluetooth/rfcomm/tty.c
>> --- linux/net/bluetooth/rfcomm/tty.c    2008-05-30 15:46:33.000000000
>> +0800
>> +++ linux.new/net/bluetooth/rfcomm/tty.c        2008-05-30
>> 17:08:30.000000000 +0800
>> @@ -566,11 +566,22 @@ static void rfcomm_dev_state_change(stru
>>        if (dlc->state == BT_CLOSED) {
>>                if (!dev->tty) {
>>                        if (test_bit(RFCOMM_RELEASE_ONHUP, &dev->flags)) {
>> -                               if (rfcomm_dev_get(dev->id) == NULL)
>> +                               /* Drop DLC lock here to avoid deadlock
>> +                                * 1. rfcomm_dev_get will take
>> rfcomm_dev_lock
>> +                                *    but in rfcomm_dev_add there's lock
>> order:
>> +                                *    rfcomm_dev_lock -> dlc lock
>> +                                * 2. rfcomm_dev_put will deaklock if it's
>> +                                *    the last reference
>
> I meant this one :)  s/deaklock/deadlock/

Fixed, thanks.
