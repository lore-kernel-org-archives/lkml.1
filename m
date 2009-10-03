Return-Path: <linux-kernel-owner+w=401wt.eu-S932151AbZJCNmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932151AbZJCNmn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 09:42:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756354AbZJCNmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 09:42:42 -0400
Received: from mail-gx0-f212.google.com ([209.85.217.212]:35116 "EHLO
	mail-gx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbZJCNml convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 09:42:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Ga4yIyiOmjfN1XDAuSdfim26axr5rnR0vKS4LAQVi+Q/ff5PcRSrRCxBdcgGy8i42P
         2k8hNX/4+b2WhPIVy50b+xJICDIGyLnCQlFMAhZ9T7mCflqBR2e7psykPwiIgZtDyNCL
         Dh+VNlHrDfAGj/qi98a+9K5q8lU3eScv9kuSI=
MIME-Version: 1.0
In-Reply-To: <200910022342.47977.rjw@sisk.pl>
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera> <200910021917.31509.rjw@sisk.pl>
	 <b637ec0b0910021437l5a011f13qfa4dd541607a6dfb@mail.gmail.com>
	 <200910022342.47977.rjw@sisk.pl>
Date: Sat, 3 Oct 2009 15:36:01 +0200
Message-ID: <b637ec0b0910030636h66d13f21m31f1a894505b2067@mail.gmail.com>
Subject: Re: [Bug #13943] WARNING: at net/mac80211/mlme.c:2292 with ath5k
From: Fabio Comolli <fabio.comolli@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael.

On Fri, Oct 2, 2009 at 11:42 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Friday 02 October 2009, Fabio Comolli wrote:
>> Hi.
>>
>> On Fri, Oct 2, 2009 at 7:17 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > On Friday 02 October 2009, Fabio Comolli wrote:
>> >> Hi.
>> >> I suppose this is still valid. I had to work around it by rfkill-ing
>> >> the device during the suspend process and reenabling at resume time.
>> >
>> > Thanks for the update.
>> >
>> >> I can try to reproduce it with 2.6.31.1 if you want it.
>> >
>> > In fact I'm more interested in whether or not it's still present in the Linus'
>> > tree.
>> >
>>
>> Well, I just tried 2.6.32-rc1-git3 and I have to say that it's mostly
>> useless with my eeepc. The warning didn't show up after resume but it
>> was impossible to reassociate with my AP and after some tentative the
>> screen went blank.
>>
>> I was able to poweroff the netbook using the power button but I'm a
>> little scared to try again.
>
> It shouldn't kill the system cold dead, so as long as you have your data
> backed up, you can do some debugging IMHO.
>
>> Maybe I'll try with -rc3 or something.
>
> I guess you should report the issues you have at the moment.  Then, it's
> actually more likely that someone will take care of fixing them.
>

OK. This is what I've been able to come up with so far:

* with 2.6.31.x the warning shows up more or less every suspend-to-ram cycle;
* with 2.6.32-rc the warning never shows up;
* with 2.6.31.x when the warning shows up wifi is unusable until rfkill cycle;
* whith 2.6.32-rc after suspend-to-ram cycle wifi is unusable and
rfkill does not cure it unless I rfkill it off - suspend-to-ram -
resume - rfkill it on. This seems to work.

When wifi does not work in 2.6.32-rc the messages show:

---------------------------------------------
[   49.647233] wlan0: direct probe to AP xx:xx:xx:xx:xx:xx (try 1)
[   49.649234] wlan0: direct probe responded
[   49.649244] wlan0: authenticate with AP xx:xx:xx:xx:xx:xx (try 1)
[   49.650546] wlan0: authenticated
[   49.650581] wlan0: associate with AP xx:xx:xx:xx:xx:xx (try 1)
[   49.652183] wlan0: RX AssocResp from xx:xx:xx:xx:xx:xx (capab=0x451
status=12 aid=1)
[   49.652190] wlan0: AP denied association (code=12)
---------------------------------------------

The script I feed to pm-utils to have wifi work across the
suspend-to-ram cycle is just:

---------------------------------------------
#!/bin/sh
RFKILL=`basename /sys/devices/platform/eeepc/rfkill/*`

case "$1" in
	hibernate|suspend)
		cat /sys/devices/platform/eeepc/rfkill/$RFKILL/state > /tmp/suspend
		echo 0 > /sys/devices/platform/eeepc/rfkill/$RFKILL/state
		;;
	thaw|resume)
		cat /tmp/suspend > /sys/devices/platform/eeepc/rfkill/$RFKILL/state
		;;
	*) exit $NA
		;;
esac
---------------------------------------------

I can confirm that with 32-rc sometimes the screen flickers badly
after resume, for example running a simple dmesg command. However,
nothing is written in the logs, neither messages nor Xorg.0.log.
Chipset is i915.

Hope this helps. Please note that git is not an option for me on this machine.

> Thanks,
> Rafael

Regards,
Fabio


> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
