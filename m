Return-Path: <linux-kernel-owner+w=401wt.eu-S1755385AbZFBXVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385AbZFBXVd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 19:21:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755253AbZFBXVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 19:21:19 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:39063 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755009AbZFBXVR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 19:21:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xfiTKG5AD5LIdoHRlCxYANXVJ7/6CJQovbui/Pt1W5BoH2aavOIoKjS0tDyngu+ASh
         RRdG0xsgdNKfjIOAiWLWgApp+quWlMkCKFJViBMHDoRY6Xxe3xuQ5G4e73JJYzEnFwDs
         OTrlGZGMbUfNgmQBUlLeHblfrB9OcJa8pRMqY=
MIME-Version: 1.0
In-Reply-To: <4A25A1DC.3000305@gmail.com>
References: <1243970734-31541-1-git-send-email-vapier@gentoo.org>
	 <4A25A1DC.3000305@gmail.com>
Date: Tue, 2 Jun 2009 19:21:18 -0400
Message-ID: <8bd0f97a0906021621x3f47028tffa49aeff3bc6c57@mail.gmail.com>
Subject: Re: [PATCH] tty: bfin_jtag_comm: emulate a TTY over the Blackfin 
	EMUDAT/JTAG interface
From: Mike Frysinger <vapier.adi@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       uclinux-dist-devel@blackfin.uclinux.org, Bryan Wu <cooloney@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/2 Jiri Slaby <jirislaby@gmail.com>:
> On 06/02/2009 09:25 PM, Mike Frysinger wrote:
>> diff --git a/drivers/char/bfin_jtag_comm.c b/drivers/char/bfin_jtag_comm.c
>> new file mode 100644
>> index 0000000..854f265
>> --- /dev/null
>> +++ b/drivers/char/bfin_jtag_comm.c
>> @@ -0,0 +1,365 @@
>> +#define pr_init(fmt, args...) ({ static const __initdata char __fmt[] = fmt; printk(__fmt, ## args); })
>
> This should be __initconst.

looks like my earlier scan missed this driver, thanks

>> +#define debug(fmt, args...) pr_debug(DRV_NAME ": " fmt, ## args)
>
> Just define pr_fmt, instead of yet another debug macro.

i missed the new pr_fmt() macro addition

>> +static void
>> +bfin_jc_wait_until_sent(struct tty_struct *tty, int timeout)
>> +{
>> +     unsigned long expire = jiffies + timeout;
>> +     while (!circ_empty(&bfin_jc_write_buf)) {
>> +             if (signal_pending(current))
>> +                     break;
>> +             if (time_after(jiffies, expire))
>> +                     break;
>
> Maybe some sort of sleep here?

i could add a schedule() call.  the process has to stay running though
because there is no async notification in the hardware that would be
able to wake this guy up.

>> +     }
>> +}
>
> The tty handling is weird. You should take a reference before accessing
> the structure.

tty documentation is non-existent.  what reference exactly do you mean
?  tty_driver_kref_get() and tty_driver_kref_put() ?  no other tty
driver uses that.

the tty handling is weird because of the hardware.  we have to create
a dedicated thread that constantly polls the hardware and this is all
async to userspace accessing the tty.
-mike
