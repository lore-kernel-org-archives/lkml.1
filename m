Return-Path: <linux-kernel-owner+w=401wt.eu-S1756099AbZGJTkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099AbZGJTkv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 15:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752573AbZGJTkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 15:40:42 -0400
Received: from anchor-post-2.mail.demon.net ([195.173.77.133]:52868 "EHLO
	anchor-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751718AbZGJTkl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 15:40:41 -0400
X-Greylist: delayed 1725 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Jul 2009 15:40:41 EDT
Date: Fri, 10 Jul 2009 19:57:50 +0100
From: Darren Salt <linux@youmustbejoking.demon.co.uk>
To: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Cc: Corentin Chary <corentin.chary@gmail.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       debian-eeepc-devel@lists.alioth.debian.org,
       acpi4asus-user@lists.sourceforge.net, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [2.6.31-rc2] Writing to /sys/class/rfkill/*/state fails
Message-ID: <507E3B9268%linux@youmustbejoking.demon.co.uk>
In-Reply-To: <4A575119.9070505@ph.tum.de>
References: <4A5716AA.5000903@ph.tum.de> 
 <71cd59b00907100545v6f440a19xfc3668826eb1e509@mail.gmail.com> 
 <4A5743AB.6090303@ph.tum.de> 
 <71cd59b00907100646h5e0283fcyce5874cc4a19106b@mail.gmail.com> 
 <4A575119.9070505@ph.tum.de>
Mail-Followup-To: Thiemo Nagel <thiemo.nagel@ph.tum.de>, Corentin Chary 
 <corentin.chary@gmail.com>, Johannes Berg <johannes@sipsolutions.net>, 
 debian-eeepc-devel@lists.alioth.debian.org, acpi4asus-user@lists.sourceforge.net,
  linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: Messenger-Pro/2.58.5.3087 (Qt/4.5.1) (Linux-x86_64)
X-NuLabour-Date: Fri, 8988 Dec 1984 19:57:50 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-SA-Exim-Connect-IP: 192.168.0.5
X-SA-Exim-Mail-From: linux@youmustbejoking.demon.co.uk
X-SA-Exim-Scanned: No (on pentagram.youmustbejoking.demon.co.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[full quoting for linux-{kernel,wireless} & the perpetrator]

I demand that Thiemo Nagel may or may not have written...

> Corentin Chary wrote:
>> On Fri, Jul 10, 2009 at 3:35 PM, Thiemo Nagel<thiemo.nagel@ph.tum.de>
>> wrote:
>>> Corentin Chary wrote:
>>>> On Fri, Jul 10, 2009 at 12:23 PM, Thiemo
>>>> Nagel<thiemo.nagel@ph.tum.de> wrote:
>>>>> I just tested the new GSM rfkill in 2.6.31-rc2 and I get the following
>>>>> on my EeePC 1000HGO:
>>>>>   eee:/# cat /sys/class/rfkill/rfkill2/name
>>>>>   eeepc-wwan3g
>>>>>   eee:/# echo 0 > /sys/class/rfkill/rfkill2/state
>>>>>   bash: echo: write error: Operation not permitted
>>>>> What could be the reason for that?
>>>> Reading the kernel source I can find:
>>>>         /*
>>>>          * The intention was that userspace can only take control over
>>>>          * a given device when/if rfkill-input doesn't control it due
>>>>          * to user_claim. Since user_claim is currently unsupported,
>>>>          * we never support changing the state from userspace -- this
>>>>          * can be implemented again later.
>>>>          */
>>>> It seems that rfkill should be controlled by /dev/rfkill (cf
>>>> Documentation/rfkill.txt).
>>>> Maybe network-manager can control that .. But I'm not sure.
>>>> Maybe you should CC the wireless mailing list.
>>> Thanks for the quick reply.  The interesting thing is, that the direct
>>> access works well for eeepc-wlan and eeepc-bluetooth rfkills.  I've CC'd
>>> debian-eeepc-devel, maybe they know something.
>> Are you sure that it works with newer kernels ?
>> This commit should have broken it for all rfkill.
>>   commit 19d337dff95cbf76edd3ad95c0cee2732c3e1ec5
>>   Author: Johannes Berg <johannes@sipsolutions.net>
>>   Date:   Tue Jun 2 13:01:37 2009 +0200

> You're right, all rfkills work with 2.6.30, but none works with 2.6.31-rc2.

This is the first that I've heard of this. I'd not noticed since I've not
needed Bluetooth on my 901 recently.

> For the debian-eeepc folks:  2.6.31-rc2 breaks bluetooth toggling using
> eeepc-acpi-scripts, but WLAN toggling still works.

FSVO "works" (http://bugzilla.kernel.org/show_bug.cgi?id=13390), but that's a
different problem.

I consider this a regression. It breaks an interface which, though flawed, is
ideally suited for scripting use and which eeepc-acpi-scripts uses in shell
scripts.

/dev/rfkill is not useful in shell scripts.

Trying to read from it to determine the current state (and only the current
state) results in the shell effectively hanging, and parsing is less than
trivial. So either we continue to use .../state or eeepc-acpi-scripts needs a
complete rewrite of the ACPI event-handling scripts in something other than
sh (probably perl) and would need a daemon instead of having scripts launched
from acpid (well, that or they'd need a helper binary or two).

Writing to it is doable, though slightly interesting. "echo 1 >/..." is
ideal.

We can't just drop support for older kernels ‒ at least, not yet – though
fortunately, prior to this breakage, all that we had to cope with were
changed file names; the content can be treated identically. We don't have to
deal with hard-blocked states, which helps...

-- 
| Darren Salt            | linux at youmustbejoking | nr. Ashington, | Doon
| using Debian GNU/Linux | or ds    ,demon,co,uk    | Northumberland | Army
| + Buy local produce. Try to walk or cycle. TRANSPORT CAUSES GLOBAL WARMING.

Passwords are implemented as a result of insecurity.
