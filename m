Return-Path: <linux-kernel-owner+w=401wt.eu-S1757595AbYHHDAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757595AbYHHDAl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 23:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755795AbYHHC7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 22:59:55 -0400
Received: from smtp.knology.net ([24.214.63.101]:37784 "EHLO smtp.knology.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755526AbYHHC7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 22:59:54 -0400
Subject: Re: [GIT PULL]: firmware patches for building firmware into kernel
From: David Dillow <dave@thedillows.org>
To: Jaswinder Singh <jaswinder@infradead.org>
Cc: David Woodhouse <dwmw2@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <1218159490.2553.13.camel@jaswinder.satnam>
References: <1218128219.14483.7.camel@jaswinder.satnam>
	 <1218130222.18118.7.camel@lap75545.ornl.gov>
	 <1218130475.14483.16.camel@jaswinder.satnam>
	 <1218133288.18118.20.camel@lap75545.ornl.gov>
	 <1218159490.2553.13.camel@jaswinder.satnam>
Content-Type: text/plain; charset=utf-8
Date: Thu, 07 Aug 2008 22:59:51 -0400
Message-Id: <1218164391.17642.14.camel@obelisk.thedillows.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-08-08 at 07:08 +0530, Jaswinder Singh wrote:
> On Thu, 2008-08-07 at 14:21 -0400, David Dillow wrote:
> > Please drop that patch from the series for now; I'm not happy with it,
> > as it reintroduces things I've asked be changed. 
> 
> You mean this :
> 
> ﻿+       /*
> +        * Need to check request_firmware should be called only once
> +        * so you don't leak memory if there is more than one NIC.
> +        * Need to check if PCI probing gets multi-threaded as
> +        * mutex is used while loading the firmware.
> +        */
> +       if (typhoon_fw != NULL) {
> +               err = typhoon_init_firmware(tp);
> 
> This is not required now, As I already fixed request_firmware.
> 
> ﻿So it is replaced by :
> 
> ﻿+       err = typhoon_init_firmware(tp);
> 
> Do you think we still need above comments ?

No, the comments will be unneeded, but you don't need an extra function
to handle this, and I'm not real keen about the release_firmware_all()
interface -- it doesn't match up with the get/put semantics of the
reference count.

I don't like releasing the firmware before the pci_unregister_driver()
call. I worry about ordering issues during cleanup, though I'll admit I
have not yet researched if it will be a problem. In any event, if you're
going to request it once per adapter in typhoon_init_one(), then it
should be in the per-device struct, and released in
typhoon_remove_one().

Drop the typhoon patches, and once you fix the problems in the core,
I'll respin the patch in a style I'm comfortable with. It will also need
to be tested before it goes upstream.

Feel free to cc me on the core patches, I will try to review them.

Dave

