Return-Path: <linux-kernel-owner+w=401wt.eu-S1754169AbXL3A3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169AbXL3A3U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 19:29:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751182AbXL3A3D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 19:29:03 -0500
Received: from an-out-0708.google.com ([209.85.132.244]:11562 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbXL3A3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 19:29:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=VDayFsk9DWc432ICt3e7M97UrerZuPHnK4Hx19KwBl0PUe7bcwZts33eFsWvWDY0QCqeYrUMXpsh8nHFDMY6baqYhNDA89boFqBiE5FO4W4QeRhDKsH8pdqmW64TbVQbELAFMoritPZfTNm/QXS17VIACXFhEF/aJJ5RKrCTkEA=
Subject: Re: [PATCH] Option to disable AMD C1E (allows dynticks to work)
From: Islam Amer <pharon@gmail.com>
Reply-To: pharon@gmail.com
To: "David P. Reed" <dpreed@reed.com>
Cc: Richard Harman <richard@richardharman.com>,
       Eduard-Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
       Rene Herman <rene.herman@keyaccess.nl>
In-Reply-To: <47765D11.2040903@reed.com>
References: <47765D11.2040903@reed.com>
Content-Type: text/plain
Date: Sun, 30 Dec 2007 00:28:54 +0200
Message-Id: <1198967334.5049.3.camel@iamer-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the detailed response.

I thought I had gotten to the bottom of my problems when I found that
udev workaround, I guess I was naive.

I did the two tests you described and they predictably caused the hard
hangs. I needed to run the port80 program only once to get the hard
hang.

The output of the dmidecode commands were :

Quanta
30B7

I applied the patch you provided ( luckily I am using 2.6.24-rc6-git3
kernel because I need the b43 driver ), added these values and compiled.


	{
		.callback	= dmi_io_delay_port_alt,
		.ident		= "Compaq Presario v6000",
		.matches	= {
			DMI_MATCH(DMI_BOARD_VENDOR, "Quanta"),
			DMI_MATCH(DMI_BOARD_NAME, "30B7")
		}
	},

I was able to boot without the udev workaround and can now use hwclock
without hanging the system. In dmesg I can see this new line :



On Sat, 2007-12-29 at 09:43 -0500, David P. Reed wrote: 
> Islam Amer wrote:
> > Hello.
> > I was interested in getting dynticks to work on my compaq presario v6000
> > to help with the 1 hour thirty minutes battery time, but after this
> > discussion I lost interest.
> >
> > I too had the early boot time hang, and found it was udev triggering the
> > bug.
> >   
> This early boot time hang is *almost certainly* due to the in/out port 
> 80 bug, which I discovered a few weeks ago, which affects hwclock and 
> other I/O device drivers on a number of HP/Compaq machines in exactly 
> this way.  The proper fix for this bug is in dispute, and will probably 
> not occur in the 2.6.24 release because it touches code in many, many 
> drivers.  The simplest way to test if you have a problem of this sort is 
> to try this shell line as root, after you boot successfully.  If your 
> machine hangs hard,  you have a problem that really looks like the port 
> 80 problem.
> 
> for ((i = 0; i < 1000; i = i + 1)); do cat /dev/nvram > /dev/null; done
> 
> I have also attached a c program that only touches port 80.  Compile it 
> for 32-bit mode (see comment), run it as root, and after two or three 
> runs, it will hang a system that has the port 80 bug.
> 
> If you then run:
> 
> dmidecode -s baseboard-manufacturer
> dmidecode -s baseboard-product-name
> 
> are the values you should plug into the .matches field in the 
> dmi_system_id struct in the attached patch. It would be great if you 
> could do that, test, and post back with those values so they can be 
> accumulated.  HP/Compaq machines with quanta m/b's are very popular, and 
> very common - so at least a quirk patch for all the broken models would 
> be worth doing in 2.6.25 or downstream in the distros.  The right 
> patches will probably take a long time - there is a dispute as to what 
> the semantics of port 80 writes even mean among the core kernel 
> developers, because the hack is lost in the dim dark days of history, 
> and safe resolution will take time
> 
> There is also a C1E issue with the BIOS in my machine (an HP Pavilion 
> dv9000z).  I don't know if it is a bug, yet, but that's a different 
> problem - associated with dynticks, perhaps.  I have to say that 
> researching the AMD Kernel/BIOS docs on C1E (a very new feature in the 
> last year on AMD) leaves me puzzled as to whether the dynticks problem 
> exists on my machine at all, but the patch for it turns off dynticks!
> 
> 
> 
> > Changing the /etc/init.d/udev script so that the line containing
> >
> > /sbin/udevtrigger
> >
> > to
> >
> > /sbin/udevtrigger --subsystem-nomatch="*misc*"
> >
> > seemed to fix things.
> >
> > the hang is triggered specifically by 
> >
> > echo add > /sys/class/misc/rtc/uevent
> > after inserting rtc.ko
> >
> > Also using hwclock to set the rtc , will cause a hard hang, if you are
> > using 64bit linux. Disable the init scripts that set the time, or use
> > the 32bit binary, as suggested here : 
> >
> > http://www.mail-archive.com/opensuse@opensuse.org/msg41964.html
> >
> > I hope this helps. But your hardware is slightly different though.
> >   
> 

