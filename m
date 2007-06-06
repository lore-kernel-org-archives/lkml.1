Return-Path: <linux-kernel-owner+w=401wt.eu-S934444AbXFFF4N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934444AbXFFF4N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 01:56:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934031AbXFFFz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 01:55:58 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:61459 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756176AbXFFFz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 01:55:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JSsVBBrgVI3ga+EyEC/Cey3iDUDUe2mvHEfHySfNTfmNMcBEuFmvckagCvB8XZrWVUz9SC4WaqO6rmzb0UiPZVq6dihVmDhZNYrMde0j67fT/chngzxw+5EEGpXQEnUX/ciDHggQ672gSFk3bM0CU9HX0uT/qEUNhv7bYQrYLdo=
Message-ID: <a8e1da0706052255sa487d5ck1724c5a07620a88b@mail.gmail.com>
Date: Wed, 6 Jun 2007 05:55:56 +0000
From: "young dave" <hidave.darkstar@gmail.com>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: [BUG] 2.6.22-rc3-mm1 remove bluetooth usb adapter caused kmalloc bug
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0706052211500.7930@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a8e1da0706051856g242dad96rf4286283192b06c4@mail.gmail.com>
	 <Pine.LNX.4.64.0706052211500.7930@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
>2007/6/6, Christoph Lameter <clameter@sgi.com>:
> Note that the corruption seems to have its cause in a decrement done at
> offset 16 into the object pointing to the refcount in struct hci_dev. So
> it looks like the refcount was decremented after the object was freed.
>
> sysfs related?
>
I noticed in hci_core.c:

hci_dev_close call hci_dev_do_close , then call hci_dev_put

but in hci_dev_do_close  also call hci_dev_put

Maybe this is the reason, by apply the below patch the bug seems
doesn't exist,  but the strange thing is the 2.4.22-rc4 seems works, I
will test once more to see the result.

Signed-off-by: dave young <hidave.darkstar@gmail.com>
---
 net/bluetooth/hci_core.c |    1 -
 1 file changed, 1 deletion(-)

diff -dur linux/net/bluetooth/hci_core.c linux.new/net/bluetooth/hci_core.c
--- linux/net/bluetooth/hci_core.c      2007-06-06 13:47:14.000000000 +0000
+++ linux.new/net/bluetooth/hci_core.c  2007-06-06 13:46:58.000000000 +0000
@@ -577,7 +577,6 @@

        hci_req_unlock(hdev);

-       hci_dev_put(hdev);
        return 0;
 }

Regards
dave
