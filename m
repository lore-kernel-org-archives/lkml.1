Return-Path: <linux-kernel-owner+w=401wt.eu-S1751348AbXBVIGD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751348AbXBVIGD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 03:06:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751456AbXBVIGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 03:06:03 -0500
Received: from twin.jikos.cz ([213.151.79.26]:46595 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348AbXBVIGB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 03:06:01 -0500
Date: Thu, 22 Feb 2007 09:04:47 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Pete Zaitcev <zaitcev@redhat.com>
cc: vinctre@videotron.ca, marcel@holtmann.org, vincent.fortier1@ec.gc.ca,
       linux-kernel@vger.kernel.org
Subject: Re: Boot time Bluetooth BUG: warning: (value > m) at hid-core.c:793
In-Reply-To: <20070221185012.e4deeb68.zaitcev@redhat.com>
Message-ID: <Pine.LNX.4.64.0702220835370.10496@twin.jikos.cz>
References: <200702192111.47017.vinctre@videotron.ca>
 <Pine.LNX.4.64.0702200854520.25686@twin.jikos.cz> <20070221185012.e4deeb68.zaitcev@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Feb 2007, Pete Zaitcev wrote:

> Can I get something useful without a kernel recompile, with something 
> like evtest? I have users on Fedora hitting this too. It very likely is 
> a regression caused by the new unified HID.
> https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=227598
> https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=228755

Hi Pete,

I don't think that this is caused by the newly introduced generic HID 
layer - I can see that both the bugreports in RH bugzilla are reported 
against 2.6.19-1.2895.fc6. I have downloaded the source RPM and discovered 
that these kernels are based on vanilla 2.6.19.2 - these kernels didn't 
have generic HID layer yet, so this can't be the case.

The thing is that hid2hci sends through hiddev some excessivelly large 
value, and HID subsystem then complains about it. It could be that the 
device has a broken report descriptor (*), which results in buggy behavior 
of sw.

It would be really nice to get the report descriptor - Vincent, it wasn't 
in your output. There is a following code in drivers/usb/input/hid-core.c

#ifdef DEBUG_DATA
        printk(KERN_DEBUG __FILE__ ": report descriptor (size %u, read %d) = ", rsize, n);
        for (n = 0; n < rsize; n++)
                printk(" %02x", (unsigned char) rdesc[n]);
        printk("\n");
#endif

Could you make sure that you really compiled this file with 

	#define DEBUG_DATA

so that you get this output upon connection of new USB HID device?

(*) Which looks quite probable to me - I have been playing yesterday with 
another masterpiece from Logitech (S510 keyboard), which also requires 
fixing its report descriptor on-the-fly because it is fully usable :(

-- 
Jiri Kosina
