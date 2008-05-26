Return-Path: <linux-kernel-owner+w=401wt.eu-S1754833AbYEZRwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbYEZRwZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 13:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753829AbYEZRwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 13:52:14 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:31432 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068AbYEZRwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 13:52:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mf6m1yoGas6PN0Vtu8SoD3okBh0d4cCoa3SykZPgN92+a4d+mwv0epk9O2815GnlqEXYUO85poHObx2214DkRoa5VdkDQ5yQDsQXUe9hyEr1HZSJcrf2MXz0nJ1fhVOD2o5d/h5PU1Z5pyHJKwEWHX0+0lGZ9OcRhOmywkfGXtw=
Message-ID: <19f34abd0805261052v38345716i3e6837ebe5d4a710@mail.gmail.com>
Date: Mon, 26 May 2008 19:52:12 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Justin Madru" <jdm64@gawab.com>
Subject: Re: Oops in mac80211 with 2.6.26-rc3 triggered playing a video
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <483AECEF.9030509@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <483A3F91.6020403@gawab.com>
	 <19f34abd0805260049j621c882r970444b65e384355@mail.gmail.com>
	 <483AECEF.9030509@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, May 26, 2008 at 7:01 PM, Justin Madru <jdm64@gawab.com> wrote:
> Vegard Nossum wrote:
>>
>> commit 0d580a774b3682b8b2b5c89ab9b813d149ef28e7
>> Author: Helmut Schaa <hschaa@suse.de>
>> Date:   Tue May 20 09:56:37 2008 +0200
>>
>>    mac80211: fix NULL pointer dereference in ieee80211_compatible_rates
>>
>>    Fix a possible NULL pointer dereference in ieee80211_compatible_rates
>>    introduced in the patch "mac80211: fix association with some APs". If
>> no bss
>>    is available just use all supported rates in the association request.
>>
>>    Signed-off-by: Helmut Schaa <hschaa@suse.de>
>>    Signed-off-by: John W. Linville <linville@tuxdriver.com>
>>
>> So does applying/cherry-picking that fix your problem? (Patch
>> attached, but not inlined.)
>
> I'll try that patch (probably just doing a git pull). But since the oops is
> hard to trigger, it will take a while to test, and make sure that fixed the
> problem.
>

Btw, I don't really see what access point association has to do with
playing a movie, so I'm inclined to believe the patch actually won't
fix your problem. But that's what the oops was. Perhaps you were
unlucky and hit a combination of two different issues... We'll see.

> How did you "decode" the oops and find what file and line number that had
> the problem?
> I tried to follow Documentation/oops-tracing.txt but I didn't know where to
> start.

To this, I will simply re-post an answer that I gave earlier today (in private):

--------
On Mon, May 26, 2008 at 2:56 PM, Carlos R. Mafra <> wrote:
> How did you do that?
>
> I see that among the number in Code: there is the sequence f3 a5 89 etc,
> but how do you know the first column (1d: 1f: 21: etc) and the assembly
> code from that?
>

There is a script scripts/decodecode to be found in the Linux source code.

I simply type

    echo 'Code: c6 00 00 ...' | bash scripts/decodecode

and it gives the full disassembly listing. Check out the script source
if you want to know exactly how it works, though yeah, you got the
general idea correct :-)

> And what is the reason for the "<---BAM!"? What exactly is the problem
> in doing that mov 0x90(%ebx), %ebx ?
>

:-) This was just my comment to say exactly where the fault happened.
If you look at the Code: line you will notice that one instruction has
<> around it, in this case "... 5d d0 <8b> 9b 90 ...". This is the EIP
address that triggered the Page Fault in the first place (this is
saved on the stack when the processor calls the page fault handler).

> Did you compile the same code and did a objdump and grep'ed for those
> strings? Is that how you do it?
>

Yes. I first find out which file the function belongs to using grep
(ieee80211_associate belongs to net/mac80211/mlme.c).

Then I initialise a default configuration, i.e. 'make defconfig' and
compile the file in question, i.e. 'make net/mac80211/mlme.o' (notice
the .o suffix).

There are some hints you can use. From the original report:
> > > EIP is at ieee80211_associate+0x24f/0x610 [mac80211]

The meaning of this +m/n syntax is: n is the size of the function (in
bytes) and m is at which offset from the beginning of the function
that the fault occurred. So from this you can deduce about where the
fault occurred in the newly compiled file (it is good to check that
the size of your newly compiled function roughly matches the size of
the crashing code). And you can look for similarities, but this cannot
be automated very well because the registers and structure may be
different, etc. A good clue is looking for constant offset movs, since
these typically mean the dereferencing of some struct, e.g. in this
case:

> > mov    0x90(%ebx),%ebx

Which probably means that %ebx was a pointer to a struct and 0x90 was
the offset of a particular member from the beginning of that struct.
(And structs tend to be semi-stable even over different configs. But
this is not always the case.)

There are cases where the newly generated assembly code is completely
different from what was in the Oops. You should at least have the same
kernel version as in the report (git makes checking out older
revisions very easy), but having the same config and gcc will probably
help a lot as well (in this case, I had neither his config nor his gcc
version, but I was lucky :-)).

If you can find the equivalent instruction that is faulting, you can
take the address that is shown by objdump (I used 'objdump -d
net/mac80211/mlme.o') and feed this to the addr2line program, such as:
'addr2line -e net/mac80211/mlme.o -i 203a', which will give you the
file/line information output that I posted in my previous e-mail.
--------

Hope this answers your question, please do ask if anything is still unclear :)


Vegard

PS: Some similar oops decoding was previously demonstrated on LKML
(Rusty Russell? I don't remember.). I couldn't find it with Google,
but maybe somebody else can give a pointer?

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
