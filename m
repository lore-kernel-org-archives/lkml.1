Return-Path: <linux-kernel-owner+w=401wt.eu-S1758632AbYASOw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758632AbYASOw4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 09:52:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760421AbYASOws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 09:52:48 -0500
Received: from fk-out-0910.google.com ([209.85.128.191]:62863 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506AbYASOwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 09:52:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jl5LKEoqb2LoHQnNk3+IF/EO902a+SGPbEiqz2+kVL/yjAm3IwIV5Un5urk35Lb8ch1lTQeoQdt0Q/7BwNKggMvZgc5wNO3nBeH/l55VoZIcpkiLLmpWG6utNDyVR0un7Wce6+MGHiQekrZVdp2FwLLdqAB18mB/D1QV2Gol5nU=
Message-ID: <bcadbdf50801190652s75f36b1ai422d8b12c5e8ff95@mail.gmail.com>
Date: Sat, 19 Jan 2008 15:52:44 +0100
From: "dAniel hAhler" <dhahler@googlemail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Regression with idle cpu cycle handling in 2.6.24 (compared to 2.6.22)
In-Reply-To: <bcadbdf50801190605s212ebe26n3035d8664554f636@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <bcadbdf50801190605s212ebe26n3035d8664554f636@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've now found the reason and a workaround for this. Apparently, it's
related to CONFIG_FAIR_USER_SCHED and can be worked around by
assigning a really small value to the boinc users cpu_share (125 is
the uid of "boinc"):
$ echo 2 | sudo tee /sys/kernel/uids/125/cpu_share

While looking around, I've found the following patch, which seems to
address this:
http://www.ussg.iu.edu/hypermail/linux/kernel/0710.3/3849.html

It has been posted here, but without any response.

btw: writing 1 into "cpu_share" totally locks up the computer!


Cheers.

On Jan 19, 2008 3:05 PM, I wrote:
> Hello,
>
> I have BOINC running in the background with niceness 19.
> With a 2.6.22 kernel, only idle cpu cycles get assigned to this process, as
> expected.
>
> But with the 2.6.24 kernel, the BOINC process gets at least about half of
> all CPU cycles, even if there's another process (owned by another user)
> requesting CPU cycles (e.g. "cat /dev/urandom > /dev/null")
>
> This happens with the Ubuntu kernel (from Hardy) and the daily builds from
> http://kernel-archive.buildserver.net/debian-kernel/ (where I've just tested
> rc8 now).
>
> It appears that every user (here "boinc" and my user) get the same portion
> of the overall CPU cycles, regardless of the process niceness.
>
> Is this expected behaviour?
>
> I'm using an AMD64 3000+ processor. Please ask for additional information, if
> you need it (e.g. kernel config).
>
>
> TESTCASE:
> $ cat /dev/urandom > /dev/null &
> $ sudo -u another_user nice -n 19 python -c 'i = 0;
> while 1:
>   i += i
> '
>
> EXPECTED RESULT:
> The niced process should get nearly no CPU cycles.
>
> ACTUAL RESULT:
> The niced process gets about half of the CPU cycles (according to "top").
>
>
> The bug has been reported for Ubuntu on https://launchpad.net/bugs/177713
>
>
> --
> http://daniel.hahler.de/
>



-- 
http://daniel.hahler.de/
