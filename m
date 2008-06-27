Return-Path: <linux-kernel-owner+w=401wt.eu-S1754221AbYF0JXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221AbYF0JXN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 05:23:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750874AbYF0JXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 05:23:00 -0400
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:14158 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750814AbYF0JW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 05:22:59 -0400
Message-ID: <4864B158.6080301@panasas.com>
Date: Fri, 27 Jun 2008 12:22:32 +0300
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: fix uninitialized variables in keyspan_pda
References: <4864944B.5020601@panasas.com>	<1214553534-9970-1-git-send-email-bhalevy@panasas.com> <20080627095816.4b9c8a2e@lxorguk.ukuu.org.uk>
In-Reply-To: <20080627095816.4b9c8a2e@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Jun 2008 09:22:34.0907 (UTC) FILETIME=[557C4EB0:01C8D837]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun. 27, 2008, 11:58 +0300, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Fri, 27 Jun 2008 10:58:54 +0300
> Benny Halevy <bhalevy@panasas.com> wrote:
> 
>> The compiler (gcc 4.3.0) warns that status might be used uninitialized
>> in keyspan_pda_tiocmget and keyspan_pda_tiocmset.
>>
>> It is technically correct and therefore this patch initializes
>> status to 0 in both cases.
>>
>> Note that keyspan_pda_get_modem_info sets *value only when
>> usb_control_msg returns rc > 0, otherwise it must
>> return an error rc < 0, and it must never return rc == 0, hence
>> a WARN_ON(rc == 0) was added in case usb_control_msg ever return 0.
> 
> That seems like overkill - and by forcing status to 0 you will hide
> future gcc error catches. Far better to change the two callers to test
> for > 0 not >= 0 surely ?

Well, since usb_control_msg is not supposed to ever return 0
I'm really not sure what to do if it does. I'll gladly defer that
decision to Greg...

The following patch makes gcc happy as you said and if it's
correct I, too, like it much better.

Benny

diff --git a/drivers/usb/serial/keyspan_pda.c b/drivers/usb/serial/keyspan_pda.c
index ff54203..197d283 100644
--- a/drivers/usb/serial/keyspan_pda.c
+++ b/drivers/usb/serial/keyspan_pda.c
@@ -420,7 +420,7 @@ static int keyspan_pda_get_modem_info(struct usb_serial *serial,
                             3, /* get pins */
                             USB_TYPE_VENDOR|USB_RECIP_INTERFACE|USB_DIR_IN,
                             0, 0, &data, 1, 2000);
-       if (rc > 0)
+       if (rc >= 0)
                *value = data;
        return rc;
 }

> 
> Alan

