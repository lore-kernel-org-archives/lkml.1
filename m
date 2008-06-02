Return-Path: <linux-kernel-owner+w=401wt.eu-S1757138AbYFBGPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757138AbYFBGPb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 02:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752028AbYFBGPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 02:15:22 -0400
Received: from senator.holtmann.net ([87.106.208.187]:37348 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943AbYFBGPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 02:15:22 -0400
Cc: davem@davemloft.net, arjan@linux.intel.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org
Message-Id: <E5C422A2-82BC-4E9E-B113-835A11AB8CBD@holtmann.org>
From: Marcel Holtmann <marcel@holtmann.org>
To: Dave Young <hidave.darkstar@gmail.com>
In-Reply-To: <20080602014625.GA2893@darkstar.te-china.tietoenator.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Re: [PATCH] bluetooth: rfcomm_dev_state_change deadlock fix
Date: Mon, 2 Jun 2008 08:15:03 +0200
References: <20080602014625.GA2893@darkstar.te-china.tietoenator.com>
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

looks good. Thanks for adding a clear comment why we have to do it  
this way.

Acked-by: Marcel Holtmann <marcel@holtmann.org>

Regards

Marcel

