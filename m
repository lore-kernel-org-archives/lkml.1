Return-Path: <linux-kernel-owner+w=401wt.eu-S1756825AbZEZSv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825AbZEZSv5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 14:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755792AbZEZSvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 14:51:49 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:60933 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755694AbZEZSvs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 14:51:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=A4h5ZOs4v1GdZrk0itEoDshU4WXaUFax8G7K/gQEzeTzZo1xu1jMf2shY+60mY+mMa
         urj5fz8Wx/7EQriI83rEz4yPB1K83TXseQGh91x7vYEFtRMr+WA/9GqPPpNvnrq/L2T2
         uk66oFMyYz+Abdqwa392HRx8chWyh2deXDq0w=
MIME-Version: 1.0
In-Reply-To: <20090526184216.GA10560@sortiz.org>
References: <20090526174012.423883376@linux.intel.com>
	 <20090526174213.806710164@linux.intel.com>
	 <37219a840905261132q6b0a7289x3408fb904ddf90df@mail.gmail.com>
	 <20090526184216.GA10560@sortiz.org>
Date: Tue, 26 May 2009 14:44:45 -0400
X-Google-Sender-Auth: bcacd59bca9751e5
Message-ID: <37219a840905261144r1c74a42dq7b24bdce1b8059b@mail.gmail.com>
Subject: Re: [PATCH 4/6] dvb/dvb-usb: prepare for FIRMWARE_NAME_MAX removal
From: Michael Krufky <mkrufky@kernellabs.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartmann <greg@kroah.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Kay Sievers <kay.sievers@vrfy.org>,
       linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 2:42 PM, Samuel Ortiz <sameo@linux.intel.com> wrote:
> On Tue, May 26, 2009 at 02:32:45PM -0400, Michael Krufky wrote:
>> On Tue, May 26, 2009 at 1:40 PM, Samuel Ortiz <sameo@linux.intel.com> wrote:
>> > From: Samuel Ortiz <sameo@linux.intel.com>
>> > To: Mauro Carvalho Chehab <mchehab@infradead.org>
>> >
>> > We're going to remove the FIRMWARE_NAME_MAX definition in order to avoid any
>> > firmware name length restriction.
>> > This patch changes the dvb_usb_device_properties firmware field accordingly.
>> >
>> > Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
>> >
>> > ---
>> >  drivers/media/dvb/dvb-usb/dvb-usb.h |    2 +-
>> >  1 file changed, 1 insertion(+), 1 deletion(-)
>> >
>> > Index: iwm-2.6/drivers/media/dvb/dvb-usb/dvb-usb.h
>> > ===================================================================
>> > --- iwm-2.6.orig/drivers/media/dvb/dvb-usb/dvb-usb.h    2009-05-26 17:24:36.000000000 +0200
>> > +++ iwm-2.6/drivers/media/dvb/dvb-usb/dvb-usb.h 2009-05-26 17:25:19.000000000 +0200
>> > @@ -196,7 +196,7 @@ struct dvb_usb_device_properties {
>> >  #define CYPRESS_FX2     3
>> >        int        usb_ctrl;
>> >        int        (*download_firmware) (struct usb_device *, const struct firmware *);
>> > -       const char firmware[FIRMWARE_NAME_MAX];
>> > +       const char *firmware;
>> >        int        no_reconnect;
>> >
>> >        int size_of_priv;
>> >
>> > --
>> > Intel Open Source Technology Centre
>> > http://oss.intel.com/
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> > Please read the FAQ at  http://www.tux.org/lkml/
>> >
>>
>> Samuel,
>>
>> Your patch makes the following change:
>>
>> -       const char firmware[FIRMWARE_NAME_MAX];
>> +       const char *firmware;
>>
>> Before your change, struct dvb_usb_device_properties actually contains
>> memory allocated for the firmware filename.  After your change, this
>> is nothing but a pointer.
>>
>> This will cause an OOPS.
> No, not if it's correctly initialized, as it seems to be for all the
> dvb_usb_device_properties users right now.
> Typically, you'd initialize your dvb_usb_device_properties like this:
>
> static struct dvb_usb_device_properties a800_properties = {
>        .caps = DVB_USB_IS_AN_I2C_ADAPTER,
>
>        .usb_ctrl = CYPRESS_FX2,
>        .firmware = "dvb-usb-avertv-a800-02.fw",
> [...]
>
> And that's fine.

You're right -- there is nothing wrong with the change -- my bad.

I traced though the code after posting that last mail.  It looked
risky when I just looked at the patch, but in the end this is actually
cleaner and much better.

Sorry for the noise.

Acked /
Reviewed-by: Michael Krufky <mkrufky@kernellabs.com>
