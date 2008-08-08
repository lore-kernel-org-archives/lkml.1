Return-Path: <linux-kernel-owner+w=401wt.eu-S1757524AbYHHL3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524AbYHHL3y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 07:29:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754537AbYHHL3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 07:29:45 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:42261 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754648AbYHHL3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 07:29:43 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Received:Message-ID:In-Reply-To:References:Date:Subject:From:To:Cc:User-Agent:MIME-Version:Content-Type:Content-Transfer-Encoding:X-Priority:Importance;
	b=gUVpQYj2pviB/41yheRksKeFEoAuO5E36h4SlMsbKTkuIENf2+h1BQcMtbUyhnh3vl+PZd+yBNqlAuPZJi7aOfqNXVdF7YKkT9jLWM9+zhCcgtp4R4WRXvI42ttEFjD9;
Message-ID: <19319b3fe3c10503fe594310f2fddab1743bfe8b@8b5064a13e22126c1b9329f0dc35b8915774b7c3.invalid>
In-Reply-To: <489C10C5.9060208@keyaccess.nl>
References: <Pine.LNX.4.44L0.0807311510220.5019-100000@iolanthe.rowland.org>
    <4899F035.9040003@simon.arlott.org.uk>
    <489C10C5.9060208@keyaccess.nl>
Date: Fri, 8 Aug 2008 12:29:26 +0100
Subject: Re: [PATCH RFC] USB: Add HCD fastboot
From: "Simon Arlott" <simon@fire.lp0.eu>
To: "Rene Herman" <rene.herman@keyaccess.nl>
Cc: "Alan Stern" <stern@rowland.harvard.edu>,
       "Arjan van de Ven" <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, "Daniel Walker" <dwalker@mvista.com>,
       "USB list" <linux-usb@vger.kernel.org>,
       "Greg Kroah-Hartman" <gregkh@suse.de>
User-Agent: SquirrelMail/1.4.10a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, August 8, 2008 10:24, Rene Herman wrote:
> On 06-08-08 20:40, Simon Arlott wrote:
>>>> Ok - so there could be some big improvements to be had by making the
>>>> hcd init happen as early as possible and the device initcalls later?
>>>
>>> Maybe.  Perhaps a better approach would be to make the device driver
>>> initcalls before there are any devices for their probe routines to
>>> block on.
>>
>> What about this?
>>
>> The Makefiles become a bit messy, but by moving things around I get the
>> desired effect without splitting their initcalls.
>>
>> [    7.941890] Write protecting the kernel read-only data: 5656k
>> [    5.437709] Write protecting the kernel read-only data: 5656k
>>
>> 2.5s faster, which is almost half the boot time.
>>
>> Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
>
> Interesting... I haven't been able to get stable improvements, with all
> USB kernel modules built-in, just a USB mouse on OHCI and otherwise a
> switched of USB HD on EHCI and usb-storage, but I do get the idea that
> with your parch, I "get lucky" more often.

It does depend on what else is running... I have e1000 (500ms) and
sata_nv (2200ms) so there's plenty of additional time for usb devices
to finish initialising.

> I have knfsd as a module and it loads through the exportfs trigger
> during bootup and outputs the last message to my dmesg:
>
> 4 boots without your patch: 6.12, 6.41, 6.38, 6.34 seconds
> 4 boots with              : 5.39, 6.33, 5.37, 6.34
>
> Booting with the external HD switched on adds a tiny bit to the actual
> kernel startup time -- completely repeatable 2.62 seconds until freeing
> init code with the HD off versus 2.73 with it on -- but doesn't seem to
> change the picture otherwise...

usb-storage by default delays 2 seconds before trying to use the device,
so it won't add much time itself if there's already an driver initcall
trying probe for devices it supports.

> Would those results make sense you feel? I'm not looking forward to
> putting an actual statistical analysis on it ;-)

I suggest adding initcall_debug=1, it'll show how long the usb and other
initcalls take to run. You should see the first usb device driver initcall
take a second or two to run (without the patch). Maybe I'm just badly
affected by having HCDs with 10 ports (of which only 4 are physically
usable...).

dmesg|grep initcall\
|sed -e 's/.*initcall \([^ ]\+\( \(\[[^]]\+\]\)\)\?\) returned [^ ]\+ after \([^ ]\+\) secs/\4 \1/'\
|sort -n

-- 
Simon Arlott
