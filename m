Return-Path: <linux-kernel-owner+w=401wt.eu-S1767321AbXCIO2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767321AbXCIO2y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 09:28:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767324AbXCIO2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 09:28:53 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:7245 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767321AbXCIO2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 09:28:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VV7Sb2kBB2Ow8+Vv09ynwKayrPhkqhor4je6xDBGk6af6EpMtIwpiHY8JfL+NvrvHfwJtP+iNnOJbN1LDNYRzg8ad/oh0EbGF+6i7brBUGSE37F2FD2wfBUcX7nHrhv7nOsqPYeMpTM1FrtMeCepFx1rbnbcXeYzWSOTPSo6hIw=
Message-ID: <d120d5000703090628p46556d52qb94b523fda4e947d@mail.gmail.com>
Date: Fri, 9 Mar 2007 09:28:49 -0500
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Pete Zaitcev" <zaitcev@redhat.com>
Subject: Re: Fix locking in mousedev
Cc: linux-kernel@vger.kernel.org, linux-input@atrey.karlin.mff.cuni.cz
In-Reply-To: <20070228110631.86a150e4.zaitcev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070228110631.86a150e4.zaitcev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pete,

On 2/28/07, Pete Zaitcev <zaitcev@redhat.com> wrote:
> If a process is closing /dev/input/mice and an mouse disconnects simulta-
> neously, the system is likely to oops. This usually happens when someone
> hits <Alt><Ctrl>F1 or logs out from X, and flips a KVM while the system
> is reacting.
>
> I reproduced the issue by running this:
>  while true; do cat </dev/null >/dev/input/mice; done
> This way, it oopses on 2nd or 3rd disconnect reliably. With the patch,
> I can disconnect the mouse 20 times.
>
> Signed-off-by: Pete Zaitcev <zaitcev@redhat.com>
>
> ---
>
> Discussion
>
> One of the race scenarios is related to the list of handles. The cat
> calls mousedev_close -> mixdev_release, does list_for_each to walk for
> all handles for a given handler. Iterations are longish while it does
> input_close_device -> hidinput_close -> usbhid_close -> usb_kill_urb,
> which sleeps briefly. Into this gap goes khubd and does hid_disconnect ->
> hidinput_disconnect -> input_unregister_device. This corrupts the list
> of handles which cat process is walking.
>
> I was unable to devise a scheme to protect the stock h_list adequately,
> so I implemented a private list of mousedev instances, which can be
> protected correctly.
>
> Dmitry, please consider getting rid of the list of handles entirely.
> The other major user is drivers/char/keyboard.c.
>

I agree that handlers should not access h_list nad use their own
private lists instead. However input core still needs that list to
maintain its books.

> Other than that, the patch is straightforward. It adds a static mutex
> to guard common data structures. It has to be static because instances
> of mousedev share common structures, such as the mousedev_table[].
>
> This should be uncontroversial, but please let me know if I missed
> something obvious.
>

I agree with the patch, unfortunately in lands squarely in the middle
of me restructuring the code (swiitch to struct device, proper
refcounting, etc) but I will try to adopt it.

-- 
Dmitry
