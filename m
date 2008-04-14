Return-Path: <linux-kernel-owner+w=401wt.eu-S1761386AbYDNRcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761386AbYDNRcp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 13:32:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755610AbYDNRcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 13:32:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51310 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754020AbYDNRcf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 13:32:35 -0400
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
To: linux1394-devel@lists.sourceforge.net
Subject: Re: [PATCH update] firewire: fw-ohci: work around generation bug in TI controllers (fix AV/C and more)
Date: Mon, 14 Apr 2008 13:30:22 -0400
User-Agent: KMail/1.9.9
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-kernel@vger.kernel.org
References: <tkrat.95472d87fa4e6c81@s5r6.in-berlin.de> <tkrat.3e4f8089bffc4e81@s5r6.in-berlin.de>
In-Reply-To: <tkrat.3e4f8089bffc4e81@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804141330.22131.jwilson@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 12 April 2008 04:31:25 pm Stefan Richter wrote:
> Unlike the ohci1394 driver, fw-ohci uses the selfIDGeneration field of
> bus reset packets to determine the generation of incoming requests as
> per OHCI 1.1 clause 8.4.2.3.  This is more precise --- provided that the
> controller inserts the correct generation.  Texas Instruments chips
> often don't.
>
> This prevented the transmission of response packets, which for example
> broke AV/C transactions as used when communicating with miniDV cameras
> and any other AV/C devices.
>
> There is apparently no way to detect and adjust incorrect generations.
> Therefore we ignore the generation of bus reset packets from TI chips
> and use the generation of the self ID buffer instead.  Alas this is
> received at a slightly wrong time.  In rare cases, this could cause us
> to not respond to legitimate requests or to respond to expired requests.
> (The latter is less likely because the bus reset packet AR event is
> typically handled before the self ID complete event.)
>
> Bug reported by Mladen Kuntner, who was extraordinarily patient while
> dealing with the driver maintainers.
> https://bugzilla.redhat.com/show_bug.cgi?id=243081
>
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> ---
>
> update: use a quirk flag for simpler code

The work-around looks good to me, just one question.

> @@ -2360,6 +2369,8 @@ pci_probe(struct pci_dev *dev, const str
>  	ohci->old_uninorth = dev->vendor == PCI_VENDOR_ID_APPLE &&
>  			     dev->device == PCI_DEVICE_ID_APPLE_UNI_N_FW;
>  #endif
> +	ohci->bus_reset_packet_quirk = dev->vendor == PCI_VENDOR_ID_TI;
> +

I have a few cards with PCI_VENDOR_ID_CREATIVE with a TI TSB41AB2 chip on 'em 
(SoundBlaster Audigy w/FireWire port). I've not had any issues on any of the 
cards I've got, but do we want to add them to the work-around list just to be 
safe?


-- 
Jarod Wilson
jwilson@redhat.com
