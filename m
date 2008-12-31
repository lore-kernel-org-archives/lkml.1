Return-Path: <linux-kernel-owner+w=401wt.eu-S1755769AbYLaE65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769AbYLaE65 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 23:58:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754738AbYLaE6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 23:58:47 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:49262 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754710AbYLaE6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 23:58:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=cEWtfDrhrE6Ef6WgiO/wH6DBUsUVeDozSnqWzD9lbihdqZT4+JEQa/qEYgrH3YoIJj
         kh/ekdTUrpxQxVodkFMwaPDMjNbXpSefdInoUy/SyyG24NxH47QryNu29tGdCtrsymM9
         jiuhAroZ6j4E2x5L38qt2seafPnsXqKoNtZNY=
Message-ID: <45a44e480812302058k365eddcfxf902095657b78534@mail.gmail.com>
Date: Tue, 30 Dec 2008 23:58:44 -0500
From: "Jaya Kumar" <jayakumar.lkml@gmail.com>
To: "Robin Getz" <rgetz@blackfin.uclinux.org>
Subject: Re: [RFC 2.6.27 1/1] gpiolib: add support for batch set of pins
Cc: "David Brownell" <david-b@pacbell.net>,
       "Eric Miao" <eric.y.miao@gmail.com>, "Sam Ravnborg" <sam@ravnborg.org>,
       "Eric Miao" <eric.miao@marvell.com>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Philipp Zabel" <philipp.zabel@gmail.com>,
       "Russell King" <rmk@arm.linux.org.uk>,
       "Ben Gardner" <bgardner@wabtec.com>, "Greg KH" <greg@kroah.com>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org
In-Reply-To: <200812302355.45193.rgetz@blackfin.uclinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12276535632759-git-send-email-jayakumar.lkml@gmail.com>
	 <200812281346.56703.rgetz@blackfin.uclinux.org>
	 <200812291156.12230.david-b@pacbell.net>
	 <200812302355.45193.rgetz@blackfin.uclinux.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 30, 2008 at 11:55 PM, Robin Getz <rgetz@blackfin.uclinux.org> wrote:
> Yeah, I hadn't thought about spanning more than one gpio_chip. That's a good
> point.

The currently posted code already supports spanning more than one gpio_chip.

+       do {
+               chip = gpio_to_chip(gpio + i);
+               WARN_ON(extra_checks && chip->can_sleep);
+
+               if (!chip->set_bus) {
+                       while (((gpio + i) < (chip->base + chip->ngpio))
+                               && bitwidth) {
+                               value = values & (1 << i);
+                               chip->set(chip, gpio + i - chip->base, value);
+                               i++;
+                               bitwidth--;
+                       }
+               } else {
+                       value = values >> i; /* shift off the used stuff */
+                       remwidth = ((chip->base + (int) chip->ngpio) -
+                                       ((int) gpio + i));
+                       width = min(bitwidth, remwidth);
+
+                       chip->set_bus(chip, gpio + i - chip->base, value,
+                                       width);
+                       i += width;
+                       bitwidth -= width;
+               }
+       } while (bitwidth);
