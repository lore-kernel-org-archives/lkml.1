Return-Path: <linux-kernel-owner+w=401wt.eu-S1753026AbYCIIV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026AbYCIIV5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 04:21:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751011AbYCIIVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 04:21:46 -0400
Received: from smtp2-g19.free.fr ([212.27.42.28]:42177 "EHLO smtp2-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750869AbYCIIVm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 04:21:42 -0400
Message-ID: <47D39E14.9050900@free.fr>
Date: Sun, 09 Mar 2008 09:21:40 +0100
From: matthieu castet <castet.matthieu@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.12) Gecko/20080129 Iceape/1.1.8 (Debian-1.1.8-2)
MIME-Version: 1.0
To: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       linux-usb@vger.kernel.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]  mass storage : emulation of sat scsi_pass_thru with
 ATACB
References: <47D2CD95.9070701@free.fr> <20080308183125.GB2820@one-eyed-alien.net> <47D2F23A.4020103@free.fr> <20080308212148.GC2820@one-eyed-alien.net>
In-Reply-To: <20080308212148.GC2820@one-eyed-alien.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Dharm wrote:
> On Sat, Mar 08, 2008 at 09:08:26PM +0100, matthieu castet wrote:
>> Hi Matthew,
>>
>> thanks for your comments
>>
>> Matthew Dharm wrote:
>>> Why are you using an initializer instead of a new protocol code?
>> Because using a new protocol code means I need to patch all the place 
>> where there is a comparison between us->subclass and US_SC_SCSI.
>> After all I am US_SC_SCSI with a special case for ATA12 & ATA16 commands.
>> I don't translate all scsi to atacb (that's what does US_SC_ISD200).
> 
> Yet, you call invoke_transport directly, just like any other protocol
> handler.
> 
> The proper way to do this is as a separate protocol handler.  If you want
> to make it clear that you are only intercepting a couple of command types,
> then don't call invoke_transport() directly, call the transparent scsi
> protocol handler (which, of course, does the same thing but provides
> clearer layering).
> 
> Oh, and you should add some "unlikely" tags to these if() conditionals.
Hum, may be to avoid confusion with a new protocol handler, I can add my 
hook in usb_stor_control_thread with a new flag.

Something like :
[...]
  /* Handle those devices which need us to fake
          * their inquiry data */
         else if ((us->srb->cmnd[0] == INQUIRY) &&
                 (us->flags & US_FL_FIX_INQUIRY)) {
[...]
	else if (( (us->srb->cmnd[0] == ATA_12) || (us->srb->cmnd[0] == ATA_16)) &&
                 (us->flags & US_FL_CYPRESS_ATACB)) {
         US_DEBUGP("emulating ATA pass thru\n");
		call to emulate_pass_thru_with_atacb code
         }

         /* we've got a command, let's do it! */
         else {
             US_DEBUG(usb_stor_show_command(us->srb));
             us->proto_handler(us->srb, us);
         }

Does it sound better ?

Matthieu
