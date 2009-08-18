Return-Path: <linux-kernel-owner+w=401wt.eu-S1750737AbZHRVRG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750737AbZHRVRG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 17:17:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750769AbZHRVRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 17:17:05 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:45637 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbZHRVRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 17:17:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DleKLDickGLx+bx9TKJHDdXuV0u7aUBPdhZxR2CUHuF1pveCpSCuS3wK1udwhYsEWo
         ZpnXUsvwzqjhm8lrC198lEjX0oZkCUKgs+yws7o2216N+Yz6q6O0sADREuUUyDgAr8de
         hi3O8KsU06buanPGjTbscGt15BtRg17sppzqs=
MIME-Version: 1.0
In-Reply-To: <4A8AE459.8060102@dell.com>
References: <4A89E768.7010207@dell.com>
	 <1250558643.30166.109.camel@localhost.localdomain>
	 <9b2b86520908180044l72cb8642j6256e246662f7971@mail.gmail.com>
	 <9b2b86520908180752k66feda09rf9034a96ac6ef470@mail.gmail.com>
	 <4A8AE459.8060102@dell.com>
Date: Tue, 18 Aug 2009 22:17:03 +0100
Message-ID: <9b2b86520908181417j26cf4c73i9a5acaa41ee11f6@mail.gmail.com>
Subject: Re: [PATCH 2/3] Add rfkill support to compal-laptop
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Mario Limonciello <mario_limonciello@dell.com>
Cc: Marcel Holtmann <marcel@holtmann.org>, cezary.jackiewicz@gmail.com,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/18/09, Mario Limonciello <mario_limonciello@dell.com> wrote:
> Hi Alan & Marcel:
>
> Alan Jenkins wrote:
>> Also, you're missing the calls to rfkill_destroy() here.
>>
>> Whew, I think that's everything.  I hope you find the feedback useful,
>> despite it being a little fragmented.
>>
>>
> Thanks for all the feedback.  I think i've addressed all of the concerns
> that were pointed out.  I appreciate the pointer to scripts/cleanpatch,
> that does significantly help in finding whitespace problems that the
> naked eye just browses over.

I think you've addressed most of the comments on your first patch.
There are still problems with the error handling though.

+static int setup_rfkill(void)
+{
+	int ret;
+
+	wifi_rfkill = rfkill_alloc("compal-wifi", &compal_device->dev,
+				RFKILL_TYPE_WLAN, &compal_rfkill_ops,
+				(void *) WLAN_MASK);
+	if (!wifi_rfkill) {
+		ret = -ENOMEM;
+		goto err_wifi;
+	}
+	ret = rfkill_register(wifi_rfkill);
+	if (ret) {
+		rfkill_unregister(wifi_rfkill);
+		goto err_wifi;
+	}

If you fail to register an rfkill device, you don't need to unregister
that rfkill device...

+
+	bt_rfkill = rfkill_alloc("compal-bluetooth", &compal_device->dev,
+				RFKILL_TYPE_BLUETOOTH, &compal_rfkill_ops,
+				(void *) BT_MASK);
+	if (!bt_rfkill) {
+		ret = -ENOMEM;
+		goto err_bt;
+	}
+	ret = rfkill_register(bt_rfkill);
+	if (ret) {
+		rfkill_unregister(bt_rfkill);
+		goto err_bt;
+	}

and the same applies here

+
+	return 0;
+
+err_bt:
+	rfkill_destroy(bt_rfkill);
+

... but you *do* need to unregister wifi_rfkill here, before you go on
to destroy it.

+err_wifi:
+	rfkill_destroy(wifi_rfkill);
+
+	return ret;
+}

Regards
Alan
