Return-Path: <linux-kernel-owner+w=401wt.eu-S1760891AbXIVFiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760891AbXIVFiT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 01:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753222AbXIVFiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 01:38:10 -0400
Received: from smtp117.sbc.mail.re3.yahoo.com ([66.196.96.90]:33101 "HELO
	smtp117.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751725AbXIVFiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 01:38:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=cy1pa94YT6/rW4mnK1OiUN1jYmTFcnwT67WKEHMVQXjITv3axB+bErfybp8bVn+umVZYENT/cRYy5tA7WD1xh87dMafKqjdNjcHJdkToKBQAMreS6PCxXBROfCfATeNEQ/eY/i0FMuGCYYwh4bzwezlJedxMbuw96l4wCPdQfTI=  ;
X-YMail-OSG: QnrNfXYVM1nm2wbos88hKX6wERzLQJts8iHwr4d8whohK0Hh2XAWpLcTXcWiyACWZxN_T.SAeWftUMIoLdty4O_WrEMmWaO9.3PJF.wwHLbtyKKnxaRo2PQuZrqVZ9woidHKtKVvCYVnuJTMXMHvdwK8yC425QsZdQ--
From: David Brownell <david-b@pacbell.net>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: RTC wakealarm write-only, still has 644 permissions
Date: Fri, 21 Sep 2007 22:38:04 -0700
User-Agent: KMail/1.9.6
Cc: rtc-linux@googlegroups.com, kernel list <linux-kernel@vger.kernel.org>,
       Alessandro Zummo <alessandro.zummo@towertech.it>
References: <20070920103225.GA4410@elf.ucw.cz> <20070920105002.GA4611@elf.ucw.cz>
In-Reply-To: <20070920105002.GA4611@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709212238.05130.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 September 2007, Pavel Machek wrote:
> Hi!
> 
> > ...should they be changed to 200? Or perhaps file should be readable?

No, mode 644 is fine.  No reason to prevent "other" people from
reading the alarm time (is there?) and if you write a legal value,
that will work.  So $SUBJECT is no problem at all.


> > 
> > root@amd:/sys/class/rtc/rtc0# cat wakealarm 
> > root@amd:/sys/class/rtc/rtc0# echo 132719 > wakealarm 

At which point I'd expect

# echo $?

would indicate the write failed.  That's a LONG time in the
past (January 2, 1970), so that setting would be rejected.


> > root@amd:/sys/class/rtc/rtc0# ls -al wakealarm 
> > -rw-r--r-- 1 root root 0 Sep 20 12:30 wakealarm
> > root@amd:/sys/class/rtc/rtc0# cat wakealarm 
> > root@amd:/sys/class/rtc/rtc0# cat wakealarm 

The alarm isn't set; so no value gets displayed.


> > root@amd:/sys/class/rtc/rtc0# 
> > 
> > 
> > ...standard PC with reasonably recent kernel...

Yeah, well a "standard PC" is chock full of fairly bizarrely
glitchey hardware.  Clocks and timers have more than their
fair share, or x86_64 NOHZ support would be merged by now!


> Hmm, something is definitely wrong in here. I sometimes _do_ get
> something back.
> 
> root@amd:~# s2ram
> Switching from vt9 to vt1
> 
> 
> switching back to vt9
> root@amd:~# 
> root@amd:~# 
> root@amd:~# cd /sys/class/rtc/rtc0
> root@amd:/sys/class/rtc/rtc0# ls
> date  dev  device@  name  power/  since_epoch  subsystem@  time
> uevent  wakealarm
> root@amd:/sys/class/rtc/rtc0# cat wakealarm 
> 2051629528
> root@amd:/sys/class/rtc/rtc0# cat power/wakeup 
> 
> root@amd:/sys/class/rtc/rtc0# cat wakealarm 
> 2051629528
> root@amd:/sys/class/rtc/rtc0# date +%s
> 1190285030

OK, in that situation you've definitely got some buglike behavior.
My question is:  how to fix it?

The problem is that the RTC is reporting an alarm value with some
fields flagged as "wildcard" -- e.g. day/month/year "out of range"
so the hardware ignores those fields.  This is very common on PC
based RTCs, and much less common on embedded systems.  (Which for
some reason don't tend to cheap out on full date specs like PCs.)

And those cause date reports to look like garbage; /proc/driver/rtc
would show "**" in those fields, rather than trying to display the
canonical "seconds since POSIX epoch" value.  But the wakealarm code
just calls rtc_tm_to_time(), which doesn't validate its fields and
so will gladly spew the garbage you saw.  (On PCs especially.  This
code was originally tested on sane embedded hardware.)

Now, in the /dev/rtcX code there's some code working with a similar
problem:  ioctl(RTC_ALM_SET) morphs partial alarm dates into valid
form before passing them down.  This needs the same kind of fix,
but going in the other direction -- and not always kicking in.  That
could go into either the wakealarm display code, or rtc_read_alarm(),
or maybe someplace else.

I'm not sure which fix would be best; maybe Alessandro has an opinion.

I'd lean towards just fixing the wakealarm display code, except that
would force anyone using that other routine to know about this rude
"wildcard" convention, which is rather hardware-specific... and that's
not really aligned with the goal of an RTC framework that "just works"
without needing to know about such quirks.


> root@amd:/sys/class/rtc/rtc0# echo 1190285050 > wakealarm 

That is, 20 seconds from "now" modulo timezone offsets.

Better might be

	echo $(( $(cat since_epoch) + 20 )) > wakealarm

which has no timezone offset issues.


> root@amd:/sys/class/rtc/rtc0# s2ram
> Switching from vt9 to vt1
> 
> 
> switching back to vt9
> root@amd:/sys/class/rtc/rtc0# 
> root@amd:/sys/class/rtc/rtc0# 
> root@amd:/sys/class/rtc/rtc0# cat wakealarm 
> root@amd:/sys/class/rtc/rtc0# cat wakealarm 

There's some wierdness related to ACPI, that crept in sometime
late in 2.6.21 (or thereabouts) ... where the RTC wake mechanism
got broken by redefining the pm_ops functions, for hibernation
at least.

That MIGHT be related to what you observe here ... unclear what
that was supposed to show.  If the RTC alarm woke that system
after 20 seconds, that's what you requested and all is fine.  If
not, and you had to wake it by hand, then you're seeing that issue
with the redefinition of hibernation ops having borked the RTC wake
mechanism interactions with ACPI.

In both cases, I'd expect that the result is that no alarm is
pending any more, so there's nothing to display.


> root@amd:/sys/class/rtc/rtc0# date +%s
> 1190285229

... which BTW should be what the "since_epoch" file shows,
other than the timezone offsets on some system RTCs.


> root@amd:/sys/class/rtc/rtc0# cat wakealarm 
> root@amd:/sys/class/rtc/rtc0# 
> 
> Also, is there some documentation for wakealarm?

"git show 3925a5ce44330767f7f0de5c58c6a797009f0f75" has some.


> sh-3.1$ cd Documentation/
> sh-3.1$ grep -ri wakealarm .
> 
> ...is it time in seconds? In UTC? In whatever timezone rtc clocks are
> using? It does not seem to work for me :-(.

Time in seconds since the POSIX epoch.  Same units as "since_epoch",
which has even less documentation...


Are you sure it's not working?  Other than the two issues I noted
above -- borkage w.r.t. ACPI (which wasn't necessarily shown in your
scripts above), and with wildcarding -- it looked to be correct.

- Dave
