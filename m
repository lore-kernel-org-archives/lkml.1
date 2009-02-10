Return-Path: <linux-kernel-owner+w=401wt.eu-S1755935AbZBJOzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935AbZBJOzc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 09:55:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754555AbZBJOzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 09:55:14 -0500
Received: from lon1-post-2.mail.demon.net ([195.173.77.149]:45757 "EHLO
	lon1-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755075AbZBJOzL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 09:55:11 -0500
Date: Tue, 10 Feb 2009 14:12:44 +0000
From: Darren Salt <linux@youmustbejoking.demon.co.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Matthew Garrett <mjg@redhat.com>,
       Corentin Chary <corentincj@iksaif.net>
Message-ID: <5030E21460%linux@youmustbejoking.demon.co.uk>
In-Reply-To: <20090209234911.GB862@elte.hu>
References: <alpine.LFD.2.00.0902081251090.3048@localhost.localdomain> 
 <gemini.ket9w800w44dc0hvg.linux@youmustbejoking.demon.co.uk> 
 <20090209234911.GB862@elte.hu>
Mail-Followup-To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org, 
 linux-acpi@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown 
 <lenb@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton 
 <akpm@linux-foundation.org>, Jesse Barnes <jbarnes@virtuousgeek.org>, Thomas 
 Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, Darren Salt 
 <linux@youmustbejoking.demon.co.uk>, Matthew Garrett <mjg@redhat.com>,
 Corentin Chary <corentincj@iksaif.net>
User-Agent: Gemini/2.29m (Qt/3.3.8b) (Linux-x86_64)
X-SDate: Tue, 5642 Sep 1993 14:12:44 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-SA-Exim-Connect-IP: 192.168.0.5
X-SA-Exim-Mail-From: linux@youmustbejoking.demon.co.uk
Subject: Re: Oopses and ACPI problems (Linus 2.6.29-rc4)
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on pentagram.youmustbejoking.demon.co.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Adding Matthew Garrett & Corentin Chary to Cc]

I demand that Ingo Molnar may or may not have written...

> * Darren Salt <linux@youmustbejoking.demon.co.uk> wrote:
>> I'm seeing various oopses with -rc4, where -rc3 is fine; config, dmesg
>> (captured via netconsole) and decoded oops data attached ¹. The last few
>> oopses were followed by a scrambled display and a hard lockup.

>> All oopses follow an otherwise successful suspend-to-RAM.

> Various folks Cc:-ed. There's been a late, rather large ACPI merge, so
> one post-rc3 suspect would be one of these commits:

[snip]
> 7695fb0: eeepc-laptop: fix oops when changing backlight brightness during
eeepc-laptop init

No, that one's harmless :-)

[snip]
> 2b25c9f: eeepc-laptop: use netlink interface

That one makes acpid (apparently) useless. The rest of the commit description
is:
    To be prepared for /proc/acpi/event removal we export events
    also through generic netlink interface.

Note that "also". The actual effect of the patch is "instead".

Adding the two removed lines (but removing the post-increment of the event
count) fixes this.

> 5740294: eeepc-laptop: Implement rfkill hotplugging in eeepc-laptop

Reverting this fixes the rfkill oops; things work correctly again. I don't
know why this appears to be needed, since things work fine without this patch
‒ both Fn-F2 and echoing to /sys/class/rfkill/rfkill0/state ‒ even when I
start up with init=/bin/sh and test directly from that shell.

(901; BIOS rev. 1808.)

[snip]
> 2a7dc0d: asus-laptop: use generic netlink interface

That one also says "also" where it should say "instead" (not that it affects
me).

... oh yes, there's a long delay between output of these two lines during
boot:
  input: ETPS/2 Elantech Touchpad as /class/input/input5
  eeepc: Hotkey init flags 0x41
(not seen in .28 or .28.1; not checked later .28.*.)

Anyway, a patch for the ACPI reporting problems will follow this message.

[snip]
-- 
| Darren Salt    | linux or ds at              | nr. Ashington, | Toon
| RISC OS, Linux | youmustbejoking,demon,co,uk | Northumberland | Army
| + Output less CO2 => avoid massive flooding.    TIME IS RUNNING OUT *FAST*.

Life is that brief interlude between nothingness and eternity.
