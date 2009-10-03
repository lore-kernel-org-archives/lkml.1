Return-Path: <linux-kernel-owner+w=401wt.eu-S1755677AbZJCQHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755677AbZJCQHX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 12:07:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751943AbZJCQHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 12:07:22 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:52834 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbZJCQHV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 12:07:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=GVL22WQ1k4CADT2PNsK/mXlZA8//oC9HuOdUZNAba1Z8Odgve2St2iF0Gkz+hYqpNx
         eQ3b76TcsCeniy+jw9jbeONkpXeuWByLefzAwPJlqaw6fvmDAYcGucI5jfYa8P2lq/QH
         yOKHdkCXLzok+3lnG4e6sHjyzsNA85YbfxY8U=
MIME-Version: 1.0
In-Reply-To: <200910022337.42283.rjw@sisk.pl>
References: <cb0375e10910021044n182d696dy8fd566925e46b134@mail.gmail.com>
	 <cb0375e10910021229x7924ec56o61627ec0f625a70c@mail.gmail.com>
	 <200910022337.42283.rjw@sisk.pl>
Date: Sat, 3 Oct 2009 11:58:58 -0400
X-Google-Sender-Auth: aedb069849a91303
Message-ID: <cb0375e10910030858i63051557j5fad3312d3bd3a4c@mail.gmail.com>
Subject: Re: High power consumption after suspend/resume cycle
From: Andrew Lutomirski <luto@mit.edu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, linux-thinkpad@linux-thinkpad.org,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 2, 2009 at 5:37 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Friday 02 October 2009, Andrew Lutomirski wrote:
>> [Adding cc's to linux-pm and linux-acpi and ]
>>
>> On Fri, Oct 2, 2009 at 1:44 PM, Andrew Lutomirski <luto@mit.edu> wrote:
>> > Hi all-
>> >
>> > I'm running a git kernel that's slightly newer than 2.6.32-rc1.
>> >
>> > First, thanks for all the great work everywhere on laptop power
>> > consumption -- on my Lenovo X200s, it looks like Linux is getting
>> > close to Windows (Windows wins by about 0.7W, except that its power
>> > usage frequently spikes since Windows apparently still doesn't know
>> > how to sit still and do nothing, whereas Linux's seems more stable.),
>> > even running KDE with compositing enabled and
>> > while connected to wifi, at least after some tweaking.
>>
>> [fixed irrelevant typo above, too.]
>>
>> >
>> > There's a catch, though: after a suspend/resume cycle, power
>> > consumption goes up by over well over a watt.  (On a system that draws
>> > about 7 watts before suspending, that's a big deal.)  I've tried
>> > turning off X, suspending with 'echo mem > /sys/power/state' to avoid
>> > any distro scripts running, and manually restoring SATA power saving
>> > settings, but it still happens.  I even tried unbinding e1000e and
>> > both USB drivers, unloading the i2400 (wimax) driver, iwlagn, and
>> > iwlcore, and it still happens.  This is 100% reproducible, and I'd be
>> > happy to test things.
>> >
>> > This could be a BIOS bug I suppose (although I'm running the latest
>> > BIOS), but Windows 7 does not have this problem at all.
>> >
>> > Any ideas about what to try or what subsystem to blame?
>
> It's quite hard to say.  Most likely one of devices is put into the full power
> state during resume and not put back into the low power state it was in before.
>
> That may be a result of the PCI core handling of resume, which puts all devices
> into D0 in order to restore their standard config registers and doesn't put
> them into low power states afterwards.

I don't think that's the problem at all -- I diffed the output of
lspci -vvvvxxxx before and after suspend and none of the differences
looked interesting.  Everything was in D0 both before and after.  One
of the EHCI devices had PME asserted after resume, but clearing that
with setpci made no difference.

I did some more experiments that make it look like it's a bug in i915.
 I'll email the maintainers.

>
> If that's really the case, PCI run-time PM should help here once implemented,
> although that's going to take some time to achieve.

I'm looking forward to another little bit of power savings there, too :)

Thanks,
Andy
