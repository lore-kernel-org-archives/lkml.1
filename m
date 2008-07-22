Return-Path: <linux-kernel-owner+w=401wt.eu-S1756179AbYGVChh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179AbYGVChh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 22:37:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754524AbYGVCh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 22:37:29 -0400
Received: from netrider.rowland.org ([192.131.102.5]:2827 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750718AbYGVCh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 22:37:28 -0400
Date: Mon, 21 Jul 2008 22:37:25 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Robert Hancock <hancockr@shaw.ca>
cc: Tomas Styblo <tripie@cpan.org>, <linux-kernel@vger.kernel.org>,
       <linux-usb@vger.kernel.org>, <usb-storage@lists.one-eyed-alien.net>
Subject: Re: [PATCH] JMicron JM20337 USB-SATA data corruption bugfix - device
 152d:2338
In-Reply-To: <4884E585.2050104@shaw.ca>
Message-ID: <Pine.LNX.4.44L0.0807212232001.5882-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jul 2008, Robert Hancock wrote:

> (adding CCs)
> 
> Tomas Styblo wrote:
> > 
> > Hello,
> > 
> > this message includes a patch that provides a workaround for
> > a silent data corruption bug caused by incorrect error handling in
> > the JMicron JM20337 Hi-Speed USB to SATA & PATA Combo Bridge chipset,
> > USB device id 152d:2338.

The two of you should read through

	http://bugzilla.kernel.org/show_bug.cgi?id=9638

which concerns this very problem.

> > - the problem occurs quite rarely, approx. once for 
> >   every 20 GB of transfered data during heavy load
> > 
> > - it seems that only read operations are affected
> > 
> > - the problem is accompanied by these messages in syslog each
> >   time it occurs:
> > 
> > May 17 15:06:56 kernel: sd 6:0:0:0: [sdb] Sense Key : 0x0 [current] 
> > May 17 15:06:56 kernel: sd 6:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
> > 
> > - the bug is not detected as an error and incorrect data is returned, 
> >   causing insidious data corruption
> > 
> > - tested with 3 external disk enclosures (Akasa Integral AK-ENP2SATA-BL) 
> >   with different disks on different computers, with kernel 2.6.24 and 2.6.25
> > 
> > - the patch provides a crude workaround by detecting the error condition
> >   and retrying the faulty transfer
> > 
> > 
> > The fix needs a review as I don't know much about USB and SCSI.  
> > It's possible that this approach is wrong and that the problem should
> > be fixed somewhere else.
> > 
> > There are other problems with this chipset that make it necessary 
> > to disconnect and power off the enclosure from time to time, but at least
> > there's no data corruption anymore.
> 
> I'm not sure this is a good approach. More that this code right above in 
> usb_stor_invoke_transport, which your code undoes the effect of for this 
> device, doesn't seem right:
> 
> 	/* If things are really okay, then let's show that.  Zero
> 	 * out the sense buffer so the higher layers won't realize
> 	 * we did an unsolicited auto-sense. */
> 	if (result == USB_STOR_TRANSPORT_GOOD &&
> 		/* Filemark 0, ignore EOM, ILI 0, no sense */
> 			(srb->sense_buffer[2] & 0xaf) == 0 &&
> 		/* No ASC or ASCQ */
> 			srb->sense_buffer[12] == 0 &&
> 			srb->sense_buffer[13] == 0) {
> 		srb->result = SAM_STAT_GOOD;
> 		srb->sense_buffer[0] = 0x0;
> 	}
> 
> So if the transport initially gets a failure, but then request sense 
> doesn't show any error, we just go "hmm, guess it was ok after all". 
> That seems kind of dangerous, I shouldn't think we should assume a 

No, no -- you have misread the code.  If the transport initially got a 
failure then result would be equal to USB_STOR_TRANSPORT_FAILED, not 
USB_STOR_TRANSPORT_GOOD, so this code wouldn't run.

> If you just delete that code above, does the corruption go away?

Alan Stern

