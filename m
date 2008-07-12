Return-Path: <linux-kernel-owner+w=401wt.eu-S1755930AbYGLXLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930AbYGLXLV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 19:11:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752417AbYGLXLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 19:11:12 -0400
Received: from THAUM.MIT.EDU ([18.95.3.27]:37687 "EHLO luto.stanford.edu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751759AbYGLXLL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 19:11:11 -0400
Message-ID: <48793A0E.3050803@myrealbox.com>
Date: Sat, 12 Jul 2008 19:11:10 -0400
From: Andy Lutomirski <luto@myrealbox.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Ingo Molnar <mingo@elte.hu>,
       public-kernel-testers-u79uwXL29TY76Z2rM5mHXA@lo.gmane.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFT] x86 acpi: normalize segment descriptor register on resume
References: <200807010148.02135.rjw@sisk.pl> <200807122051.25634.rjw@sisk.pl> <48791675.6060805@myrealbox.com> <200807122253.32382.rjw@sisk.pl>
In-Reply-To: <200807122253.32382.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Saturday, 12 of July 2008, Andy Lutomirski wrote:
>> Rafael J. Wysocki wrote:
>>> On Saturday, 12 of July 2008, Andy Lutomirski wrote:
>>>> My Lenovo X61s fails to resume if I suspend it from within X, on both 
>>>> 2.6.26-rc9 and recent wireless-testing.  2.6.26-rc8 is fine, as is 
>>>> wireless-testing with 4b4f7280 reverted.  My in-progress bisect between 
>>>> -rc8 and -rc9 is also consistent with this being the problem.
>>>>
>>>> The symptom is that, when I push the power button to resume, the hard 
>>>> drive light turns on, the fan turns on, then the hard drive light turns 
>>>> off, the sleep light stays on, and the fan keeps running.  Sometimes the 
>>>> battery light will blink off very briefly (1/4 sec, maybe) every few 
>>>> seconds.  The system is locked hard at this point.
>>>>
>>>> I'm using Ubuntu Hardy userspace.
>>> Well, that's bad.
>>>
>>> There is the bugzilla entry at http://bugzilla.kernel.org/show_bug.cgi?id=11064
>>> for this bug and you've just confirmed my suspicion that this particular
>>> commit is to blame.
>>>
>>> Can you please see if the appended patch changes anything?
>> More correctly:
>>
>> If I suspend by typing pm-suspend or echo mem >/sys/power/state, then it 
>> resumes just fine.  If I log in to Gnome and push the suspend button, 
>> then it does not resume.  This seems to be the case with or without your 
>> patch.
> 
> Is there an Intel graphics in your box?

Yes.

> 
>> -rc8 and -rc9 with the original patch 4b4f7280 resume fine no matter how 
>> I suspend.
> 
> That's _really_ strange.
> 
> In fact I have only one explanation, which is that the Gnome suspend button
> causes some user-space quirks to be applied, which are harmful and break the
> resume.  Also, without commit 4b4f7280 those quirks might have not been really
> executed.  Peter, does it sound reasonable?

Bingo.  It's a HAL quirk.

Testing from the console (not X):

With 4b4f7280:
# echo mem >/sys/power/state -- works fine

# echo 3 >/proc/sys/kernel/acpi_video_flags
# echo mem >/sys/power state -- fails to resume

Without 4b4f7280:
# echo mem >/sys/power/state -- works fine

# echo 3 >/proc/sys/kernel/acpi_video_flags
# echo mem >/sys/power state -- works fine

So HAL contains an apparently unnecessary quirk for my laptop, and 
4b4f7280 breaks that quirk.  Of course, it's entirely possible that 
4b4f7280 is 100% correct, but that the quirk only worked by accident and 
4b4f7280 broke the call into video BIOS.

--Andy
