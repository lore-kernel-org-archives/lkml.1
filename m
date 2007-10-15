Return-Path: <linux-kernel-owner+w=401wt.eu-S1764226AbXJOACX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764226AbXJOACX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 20:02:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760101AbXJOACP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 20:02:15 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:22774 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759939AbXJOACO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 20:02:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:reply-to:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=lEUDLx2oaPtAyl9Q9U99bF/z3x7A85AvYhoh/jRmQaWGJP08LLGIHtVAdDwBY0J4Svc3khdQhVrvEiqivJbDPqV67VwxbJ1ae9lAv+RWOv6uBZZVCnswHBuuELJ2eiFNutN4gM75SRW4HNJ07NH062RhZic3Vl3z2vcb+qsbU1g=
Message-ID: <71b295590710141702r48be29f3s9308ab7dd8f7363c@mail.gmail.com>
Date: Sun, 14 Oct 2007 19:02:12 -0500
From: "Mark Weber" <crash@treysoft.com>
Reply-To: crash@treysoft.com
To: "Mark Lord" <lkml@rtr.ca>
Subject: Re: hdparm standby timeout not working for WD raptors?
Cc: "Bart Samwel" <bart@samwel.tk>, linux-kernel@vger.kernel.org
In-Reply-To: <4712A904.9010304@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <71b295590710061011g3cd43317i8eff3a7dce2a188@mail.gmail.com>
	 <470E7B90.5060203@rtr.ca>
	 <71b295590710112207v72b9eb8aqc19e59c610f20dd@mail.gmail.com>
	 <470F7705.3@rtr.ca>
	 <71b295590710121519i55d3471fha16210e698094bec@mail.gmail.com>
	 <47120D65.3080008@samwel.tk>
	 <71b295590710141330g7a4779e5q2d6b8f50387ee971@mail.gmail.com>
	 <471284A7.1060800@samwel.tk>
	 <71b295590710141505x54ca0a8fwebfd75ab4fdf2e71@mail.gmail.com>
	 <4712A904.9010304@rtr.ca>
X-Google-Sender-Auth: 31a148ec57a50eb4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/07, Mark Lord <lkml@rtr.ca> wrote:
> 1. How are you forcing the drives into standby?

hdparm -y



> 2. Have you reproduced this with a stock kernel.org kernel yet?

No; maybe later this week.



> One possibility is that these drives may be the kind that
> generate a "spurious" interrupt when they spin-down via the timer,
> and perhaps libata is "processing" that interrupt and sending
> additional command(s) that then wake the drive up again immediately.
>
> To rule this out, you could try using drivers/ide for a moment or two,
> and see if the same problem persists with those drives.
>
> You could also try dumping /proc/interrupts in conjunction with "hdparm -S1",
> and we can compare that with a "known good" system.
>
> Something like this:
>
> hdparm -B255 /dev/sda
> hdparm -S1 /dev/sda
> cat /proc/interrupts
> sleep 6
> cat /proc/interrupts




Here's the log for the second suggestion:



narf ~ # hdparm -B255 /dev/sda

/dev/sda:
 setting Advanced Power Management level to disabled
 HDIO_DRIVE_CMD failed: Input/output error

narf ~ # hdparm -S1 /dev/sda

/dev/sda:
 setting standby to 1 (5 seconds)
narf ~ # cat /proc/interrupts
           CPU0
  0:       2268   IO-APIC-edge      timer
  1:          2   IO-APIC-edge      i8042
  8:          5   IO-APIC-edge      rtc
  9:          0   IO-APIC-fasteoi   acpi
 12:          4   IO-APIC-edge      i8042
 14:     206827   IO-APIC-edge      ide0
 16:     350813   IO-APIC-fasteoi   sata_promise, uhci_hcd:usb5
 17:   39596029   IO-APIC-fasteoi   eth0
 18:          0   IO-APIC-fasteoi   uhci_hcd:usb4
 19:     728947   IO-APIC-fasteoi   libata, uhci_hcd:usb3
 20:          0   IO-APIC-fasteoi   ehci_hcd:usb1, uhci_hcd:usb2
NMI:          0
LOC:    2736793
ERR:          0
MIS:          0
narf ~ # sleep 6
narf ~ # cat /proc/interrupts
           CPU0
  0:       2268   IO-APIC-edge      timer
  1:          2   IO-APIC-edge      i8042
  8:          5   IO-APIC-edge      rtc
  9:          0   IO-APIC-fasteoi   acpi
 12:          4   IO-APIC-edge      i8042
 14:     206828   IO-APIC-edge      ide0
 16:     350813   IO-APIC-fasteoi   sata_promise, uhci_hcd:usb5
 17:   39596069   IO-APIC-fasteoi   eth0
 18:          0   IO-APIC-fasteoi   uhci_hcd:usb4
 19:     728947   IO-APIC-fasteoi   libata, uhci_hcd:usb3
 20:          0   IO-APIC-fasteoi   ehci_hcd:usb1, uhci_hcd:usb2
NMI:          0
LOC:    2736881
ERR:          0
MIS:          0
