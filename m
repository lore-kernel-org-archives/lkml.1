Return-Path: <linux-kernel-owner+w=401wt.eu-S1758435AbYEWTOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758435AbYEWTOW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 15:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754139AbYEWTOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 15:14:15 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48102 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074AbYEWTOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 15:14:14 -0400
Subject: Re: [PATCH 1/3] firmware: allow firmware files to be built into
	kernel	image
From: David Woodhouse <dwmw2@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
       aoliva@redhat.com, Abhay Salunke <Abhay_Salunke@dell.com>,
       kay.sievers@vrfy.org, Haroldo Gamal <gamal@alternex.com.br>
In-Reply-To: <20080523163303.492c89e4@core>
References: <1211550282.28967.8.camel@pmac.infradead.org>
	 <s5hbq2xul4s.wl%tiwai@suse.de>
	 <1211554711.28967.25.camel@pmac.infradead.org>
	 <20080523163303.492c89e4@core>
Content-Type: text/plain
Date: Fri, 23 May 2008 20:14:07 +0100
Message-Id: <1211570047.28967.75.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-05-23 at 16:33 +0100, Alan Cox wrote:
> > Yeah, I thought about that. I was slightly concerned that drivers might
> > actually try to _modify_ the firmware they loaded, though. As it is,
> > there's no fundamental reason why they shouldn't do that.
> 
> I've not seen any that do and judicious use of "const" should catch
> offenders.

Like this one...

static const int dvico_firmware_id_offsets[] = { 6638, 3204 };
static int bluebird_patch_dvico_firmware_download(struct usb_device *udev,
						  const struct firmware *fw)
{
	int pos;

	for (pos = 0; pos < ARRAY_SIZE(dvico_firmware_id_offsets); pos++) {
		int idoff = dvico_firmware_id_offsets[pos];

		if (fw->size < idoff + 4)
			continue;

		if (fw->data[idoff] == (USB_VID_DVICO & 0xff) &&
		    fw->data[idoff + 1] == USB_VID_DVICO >> 8) {
			fw->data[idoff + 2] =
				le16_to_cpu(udev->descriptor.idProduct) + 1;
			fw->data[idoff + 3] =
				le16_to_cpu(udev->descriptor.idProduct) >> 8;

			return usb_cypress_load_firmware(udev, fw, CYPRESS_FX2);
		}
	}

	return -EINVAL;
}

-- 
dwmw2

