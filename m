Return-Path: <linux-kernel-owner+w=401wt.eu-S1756230AbYGUTh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230AbYGUTh5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 15:37:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754954AbYGUTho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 15:37:44 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:54918 "EHLO
	pd6mo1no-dmz.prod.shaw.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753560AbYGUThm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 15:37:42 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=u0jdh05EA0H1Dcq6ppUA:9 a=tOf0uBgXWf4bEhcg3Q0A:7 a=QlAMUVgZxDJAGZh1WWZdZjZkiJkA:4 a=Gr1l-fY1kBQA:10 a=CDgK0yFw8z8A:10
Message-ID: <4884E585.2050104@shaw.ca>
Date: Mon, 21 Jul 2008 13:37:41 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Tomas Styblo <tripie@cpan.org>
CC: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       usb-storage@lists.one-eyed-alien.net
Subject: Re: [PATCH] JMicron JM20337 USB-SATA data corruption bugfix - device
 152d:2338
References: <fa.eWQqoO1e4Mdhu8SK5jzMFAI/3NU@ifi.uio.no>
In-Reply-To: <fa.eWQqoO1e4Mdhu8SK5jzMFAI/3NU@ifi.uio.no>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(adding CCs)

Tomas Styblo wrote:
> 
> Hello,
> 
> this message includes a patch that provides a workaround for
> a silent data corruption bug caused by incorrect error handling in
> the JMicron JM20337 Hi-Speed USB to SATA & PATA Combo Bridge chipset,
> USB device id 152d:2338.
> 
> 
> - the problem occurs quite rarely, approx. once for 
>   every 20 GB of transfered data during heavy load
> 
> - it seems that only read operations are affected
> 
> - the problem is accompanied by these messages in syslog each
>   time it occurs:
> 
> May 17 15:06:56 kernel: sd 6:0:0:0: [sdb] Sense Key : 0x0 [current] 
> May 17 15:06:56 kernel: sd 6:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
> 
> - the bug is not detected as an error and incorrect data is returned, 
>   causing insidious data corruption
> 
> - tested with 3 external disk enclosures (Akasa Integral AK-ENP2SATA-BL) 
>   with different disks on different computers, with kernel 2.6.24 and 2.6.25
> 
> - the patch provides a crude workaround by detecting the error condition
>   and retrying the faulty transfer
> 
> 
> The fix needs a review as I don't know much about USB and SCSI.  
> It's possible that this approach is wrong and that the problem should
> be fixed somewhere else.
> 
> There are other problems with this chipset that make it necessary 
> to disconnect and power off the enclosure from time to time, but at least
> there's no data corruption anymore.

I'm not sure this is a good approach. More that this code right above in 
usb_stor_invoke_transport, which your code undoes the effect of for this 
device, doesn't seem right:

	/* If things are really okay, then let's show that.  Zero
	 * out the sense buffer so the higher layers won't realize
	 * we did an unsolicited auto-sense. */
	if (result == USB_STOR_TRANSPORT_GOOD &&
		/* Filemark 0, ignore EOM, ILI 0, no sense */
			(srb->sense_buffer[2] & 0xaf) == 0 &&
		/* No ASC or ASCQ */
			srb->sense_buffer[12] == 0 &&
			srb->sense_buffer[13] == 0) {
		srb->result = SAM_STAT_GOOD;
		srb->sense_buffer[0] = 0x0;
	}

So if the transport initially gets a failure, but then request sense 
doesn't show any error, we just go "hmm, guess it was ok after all". 
That seems kind of dangerous, I shouldn't think we should assume a 
successful transfer occurred if we got any kind of error.

If you just delete that code above, does the corruption go away?

Original attached patch was (likely whitespace damaged now):

--- linux-2.6.25.9/drivers/usb/storage/transport.c.orig	2008-06-24 
23:09:06.000000000 +0200
+++ linux-2.6.25.9/drivers/usb/storage/transport.c	2008-07-20 
05:14:32.000000000 +0200
@@ -661,6 +661,21 @@ void usb_stor_invoke_transport(struct sc
  			srb->result = SAM_STAT_GOOD;
  			srb->sense_buffer[0] = 0x0;
  		}
+
+        /* JMicron JM20337 chipset bug workaround - BEGIN */
+		if (us->pusb_dev->descriptor.idVendor == 0x152d &&
+            us->pusb_dev->descriptor.idProduct == 0x2338 &&
+            result == USB_STOR_TRANSPORT_FAILED &&
+			/* Filemark 0, ignore EOM, ILI 0, no sense */
+				(srb->sense_buffer[2] & 0xaf) == 0 &&
+			/* No ASC or ASCQ */
+				srb->sense_buffer[12] == 0 &&
+				srb->sense_buffer[13] == 0) {
+            printk(KERN_WARNING "USB Storage - Working around the 
JMicron JM20337 chipset bug (idVendor=%04x, idProduct=%04x, NO_SENSE, 
ASC=0, ASCQ=0) - retrying the read operation\n", 
us->pusb_dev->descriptor.idVendor, us->pusb_dev->descriptor.idProduct);
+		    srb->result = (DID_ERROR << 16) | (SUGGEST_RETRY << 24);
+            return;
+        }
+        /* JMicron JM20337 chipset bug workaround - END */
  	}

  	/* Did we transfer less than the minimum amount required? */
