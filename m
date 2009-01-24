Return-Path: <linux-kernel-owner+w=401wt.eu-S1758286AbZAXQ1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758286AbZAXQ1U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 11:27:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751945AbZAXQ1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 11:27:11 -0500
Received: from outbound-mail-18.bluehost.com ([69.89.20.233]:43037 "HELO
	outbound-mail-18.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751508AbZAXQ1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 11:27:10 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=rRkzTcv0+Yq8EFZpTnf+MdK8EH5w8MSbQzB/3uCQFU11V3C9Ek/Kel4nxdO0YSK3SJha7UazBIojtnC6ECiQ1qiy1FybsDeo2RAv3Ap8kB+x73l9cSAEe5W468fjaWjX;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: Re: BISECTED: 2.6.29-rc2 regression: hibernation hang on eeepc-701
Date: Sat, 24 Jan 2009 08:27:05 -0800
User-Agent: KMail/1.9.10
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, kernel-testers@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Pavel Machek <pavel@suse.cz>
References: <9b2b86520901180345j434eacbdn7386958991ee50b@mail.gmail.com> <200901232306.33309.rjw@sisk.pl> <497AF845.2000002@tuffmail.co.uk>
In-Reply-To: <497AF845.2000002@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901240827.05557.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, January 24, 2009 3:15 am Alan Jenkins wrote:
> Rafael J. Wysocki wrote:
> > On Friday 23 January 2009, Alan Jenkins wrote:
> >> Rafael J. Wysocki wrote:
> >>> On Thursday 22 January 2009, Alan Jenkins wrote:
> >>>> Rafael J. Wysocki wrote:
> >>>>> On Thursday 22 January 2009, Alan Jenkins wrote:
> >>>>>> Alan Jenkins wrote:
> >>>>>>> Hibernation hangs just after writing the image.  With s2disk I can
> >>>>>>> see this from the console messages.  The same hang happens with
> >>>>>>> kernel swsusp ('echo disk | sudo tee /sys/power/state'), and I can
> >>>>>>> see that the image has been written from the HDD led.
> >>>>>>>
> >>>>>>> In either case, I can still hard-power-off and resume from
> >>>>>>> hibernation.
> >>>>>>>
> >>>>>>> It doesn't hang if I use the shutdown method (either 'echo shutdown
> >>>>>>> | sudo tee /sys/power/disk' or  's2disk -P "shutdown
> >>>>>>> method=shutdown"').
> >>>>>>
> >>>>>> I've bisected this to commit
> >>>>>> 571ff7584bb9e05fca0eb79752ae55a46faf3a98. It doesn't revert cleanly
> >>>>>> from RC2.
> >>>>>>
> >>>>>> I think it's distinct from the other two reported suspend
> >>>>>> regressions. I'm not using acpi-cpufreq, and the issue doesn't
> >>>>>> affect resume.
> >>>>>
> >>>>> It looks distinct.
> >>>>>
> >>>>> Do you suspend this box to RAM and does it work?
> >>>>
> >>>> Yes, I do use STR on it occasionally, and it still works in RC2.
> >>>>
> >>>>> Please retest with the appended patch applied.
> >>>>
> >>>> That fixes it.
> >>>
> >>> OK, it won't hurt to apply it.
> >>>
> >>> Still, the hardware or the BIOS in your box seems to be broken, or
> >>> both, so I'd like to debug it a bit more if you don't mind.
> >>>
> >>> Can you please test the patch below instead of the previous one?
> >>
> >> It hangs at the same point as the unpatched RC2.  As before, it doesn't
> >> hang if I use "shutdown" instead of "platform".
> >>
> >> Going by sysfs, I have 4 PCI devices without a kernel driver.
> >>
> >> 8086:2592   Mobile 915 Express Graphics Controller
> >> 8086:2792   Mobile 915 Express Graphics Controller (driven by X)
> >> 8086:2448   82801 Mobile PCI Bridge
> >> 8086:2641   82801FBM (ICH6M) LPC Interface Bridge
> >
> > The bridges shouldn't be affected, so I bet on the graphics.
> >
> > It seems that the BIOS doesn't expect it to be in D3 while entering S4,
> > although it apparently doesn't mind it to be in D3 while entering S3.
> >
> > I blame the Asus BIOS writers. ;-)
>
> Wouldn't Windows normally put it into D3?  There are many reports of
> successful hibernation under Windows on this hardware.  The motivation
> being that S3 drains the battery in <24 hours.  (Fewer people hibernate
> on linux because you only have a 4G SSD, so a swap partition wastes a
> lot of space, and most installers can't set up swap files).

Sounds like the BIOS pokes at gfx during S3 (then hopefully puts it into D3) 
but doesn't bother when going into S4, that's kind of strange, but maybe it's 
spec'd somewhere.

> Also it sounds like it would break when the linux kernel mode setting
> driver is used.  I thought kernel mode setting was going to make suspend
> _more_ reliable :-).

In the kernel mode setting case (and also in the X case) the device should 
have an associated kernel driver.  If there are still problems when one is 
loaded, we might have to figure out what to do with the "dummy" video device 
(device 2:1).

> So in the long term I think we either need to find a more specific root
> cause, or implement a PCI quirk for this quirky machine.

Yeah.

-- 
Jesse Barnes, Intel Open Source Technology Center
