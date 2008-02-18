Return-Path: <linux-kernel-owner+w=401wt.eu-S1753341AbYBROsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341AbYBROsq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 09:48:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751583AbYBROsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 09:48:37 -0500
Received: from ts.adaptec.com ([162.62.93.58]:48715 "EHLO mail-gw3.adaptec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407AbYBROsg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 09:48:36 -0500
From: "Salyzyn, Mark" <Mark_Salyzyn@adaptec.com>
To: Omar Kilani <omar.kilani@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 18 Feb 2008 06:48:29 -0800
Subject: RE: aacraid: Host adapter reset request. SCSI hang ?
Thread-Topic: aacraid: Host adapter reset request. SCSI hang ?
Thread-Index: AchwZoL8kZDpXfjiQQClhBaZp92KNABzBs9w
Message-ID: <532ABFBDAAC3A34EB12EBA6CEC2838F4399FCFAF@ADPE2K703.adaptec.com>
References: <f0cc3e3e0802152238t59498e3bv229d02ee3d96cea7@mail.gmail.com>
In-Reply-To: <f0cc3e3e0802152238t59498e3bv229d02ee3d96cea7@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This 'Host adapter reset request. SCSI hang ?' message hides a rather complicated-to-explain underlying hardware behavior.

Aacraid based controllers have an underlying timeout/recovery cycle that is 35 seconds long, there is a driver patch for this POST RHEL5 (but is going into RHEL5.2) that increases the default Linux per-device timeout to 45 seconds. The default in some SCSI subsystems was 60 seconds in the past, but is now standardized at 30 seconds which results in an interference pattern between the controller and Linux' SCSI subsystem. The alternate workaround is for the user to adjust the timeout in sysfs if it is shorter than this value. This is the only likely Linux driver issue that you may be having, everything is out of the scope for Linux or the aacraid driver; and needs to be addressed separately. This is not the panacea, so do NOT get your hopes up, and do NOT feel that the warning behavior is in fact a problem that needs to be solved (!)

Keep in mind that I/O completions on these controllers when everything is working is typically in the millisecond region or less.

The 3405 (or generically any aacraid based controller) is likely going through an error correction cycle on the SAS/SATA bus that is delaying the completion of I/O beyond the Linux default timeout set for the device, this may be a hardware issue (i.e.: driver or OS will not change anything) and typically will be of little concern to the Linux Kernel or Distribution folks. Or this may be a problem with an overly aggressive default timeout value as outlined immediately above. The fact that all you get are these messages and I/O continues indicates that everything is working as-designed dealing with or working around whatever the hardware issue is.

That does not mean the driver is free and clear, perhaps we are reaching a fundamental resource limit in the controller, on the bus, on the enclosure or in the drives. You may be able to mitigate this by adjusting the maximum queue depth down somewhat. You can adjust this in sysfs or indirectly through driver's controller-wide limit using insmod parameter numacb. If you find this to be the case and it is prevalent, we may need to adjust the rules within the driver regarding load balancing and queue depths to improve the general reliability and responsiveness of the system. A balance between reliability, performance, responsiveness and periodic warning messages in your logs? Target devices typically have the ability to handle at least 32 outstanding commands, often more.

My guess is that if the drives, enclosure and the controllers are all up to date (latest Firmware on all) and swapping components has not resulted in any changes in behavior, and this problem persists at per-device queue depths below 32 and timeouts of 60 seconds, that you likely have a drive compatibility problem.

One of the first incompatibilities that needs to be reconciled that comes to mind is the use of desktop class (typically self correcting, which can take more than ten seconds to respond to I/O requests) or off-spec (i.e., higher error rate drives often shipped into low-budget markets) drives. The controller needs to work with these drives, and it does, and is dealing with them in an as-designed manner. If these are the drives you have, then you are getting what you paid for. If this is the case, you can reduce the annoyance by increasing the component's timeout by programming an updated value in sysfs.

Keep in mind that if the purchaser has in their mind that they wanted an enterprise class drive, and the supplier (or the manufacturer) supplied you desktop class drives; that they are often very willing to swap out the desktop class drives in exchange for the enterprise class drives. The difference is often merely as simple as a Drive Firmware behavior.

I would not increase this timeout much beyond 120 seconds, for anything larger starts affecting your rough guarantee of I/O delivery required for server network connections. The timeout results in a quescing of I/O to the device and results in the servicing of any starved requests that may be backed up behind resource limits in the components and thus also has an affect on dealing with the fundamental resource limit issues indicated above. The messages you are seeing, although annoying, are actually a desirable, albeit clunky, handshake somewhat ensuring the guarantee of I/O delivery. It is clunky because it also leads to a pause in more recently submitted I/O as it offers up ten seconds of silence in it's honor :-(

Another problem can arise surrounding the enclosure compatibility, for it may be negotiating in bad faith with the components, or has an incompatibility with the enclosure services in the controller. Especially if the enclosure has not been certified for use with the controller.

Another is that the drive is server/enterprise class and because it is a late-model unit, specifically has never been certified with the controller and has an odd behavior not yet worked around within the contoller's firmware.

If either of these incompatibilities is the case, it is in Adaptec's interest to work with you via the technical support department to resolve this problem. They will no doubt immediately ask you for the 'diagnostic dump'. If that does not bear any fruit, then they will work with you to either internally duplicate the problem, or as a last resort require your system to duplicate the issue to acquire the all-important SAS/SATA trace.

I hope you can see why these messages are discussed ad-nauseam on the network, fingers pointing in all different directions. Good luck working on this issue now armed with this understanding!

My cookbook for the 'aacraid: Host adapter reset request. SCSI hang ?' message:

- Check for any updated firmware for the controller, targets and enclosure on the respective manufacturer's websites.
- If you get a BlinkLED (rare) following this message, contact the controller supplier's technical support department
- Check per-device queue depth in sysfs to make sure it is reasonable.
- Check per-device timeout in sysfs to make sure it is reasonable.
- Engage Drive supplier's technical support department to check through compatibility or drive class issues.
- Engage Enclosure supplier's technical support department to check through compatibility issues.
- Engage Controller supplier's (some aacraid controllers are OEM'd through other channels) technical support department to check through compatibility issues.
        - Tech support will ask for the 'support.zip' and diagnostic dumps to triage issue.
        - Tech support may further engage you to work with you to acquire additional details from your specific system.
- Or ... be happy with what class of underlying target components you have selected; for a warning does not mean there is a problem that needs to be resolved.

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org
> [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Omar Kilani
> Sent: Saturday, February 16, 2008 1:38 AM
> To: linux-kernel@vger.kernel.org
> Subject: aacraid: Host adapter reset request. SCSI hang ?
>
> Hi there,
>
> We're having issues with our Adaptec RAID controller and I was
> wondering if anyone would be able to advise on how to go about
> resolving them. :)
>
> The system:
>
> RHEL 5.1 x86_64
> Kernel 2.6.18-53.1.4.el5
> aacraid 1.1-5[2437]-mh4 (The default module shipped with the
> RHEL kernel)
>
> The controller:
>
> Adaptec 3405 + BBU
>
> BIOS : 5.2-0 (12415)
> Firmware : 5.2-0 (12415)
> Driver : 1.1-5 (2437)
> Boot Flash : 5.2-0 (12415)
>
> The disks:
>
> 4x Seagate ST373455SS (Firmware 0002) in a RAID10
>
> The issue:
>
> We continually get what seem to be adapter lockups with the error:
>
> aacraid: Host adapter abort request (3,0,0,0)
> aacraid: Host adapter reset request. SCSI hang ?
>
> The controller hangs for a while, recovers, and everything
> continues normally.
>
> We've tried a replacement controller and a replacement set of disks
> (we swapped out all 4 disks) to no avail.
>
> The problem seems (?) to happen during spikes of IO -- like when the
> PostgreSQL autovacuum daemon kicks in. But not always.
>
> From searching around LKML and Google, this seems to be a fairly
> common issue, but I'm not quite clear on the cause (hardware?
> software? firmware?) or the resolution.
>
> Any help would be greatly appreciated.
>
> Thanks!
>
> Regards,
> Omar
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
