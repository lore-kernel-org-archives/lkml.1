Return-Path: <linux-kernel-owner+w=401wt.eu-S934083AbXLPNs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934083AbXLPNs2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 08:48:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765905AbXLPNsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 08:48:20 -0500
Received: from bizon.gios.gov.pl ([212.244.124.8]:51133 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932100AbXLPNsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 08:48:19 -0500
Date: Sun, 16 Dec 2007 14:46:36 +0100 (CET)
From: Krzysztof Oledzki <olel@ans.pl>
X-X-Sender: olel@bizon.gios.gov.pl
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Osterried <osterried@jesse.de>, protasnb@gmail.com,
       bugme-daemon@bugzilla.kernel.org, Thomas Osterried <osterried@jesse.de>
Subject: Re: [Bug 9182] Critical memory leak (dirty pages)
In-Reply-To: <20071216015112.d0ab08a1.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0712161440030.25065@bizon.gios.gov.pl>
References: <20071215221935.306A5108068@picon.linux-foundation.org>
 <Pine.LNX.4.64.0712152358240.14491@bizon.gios.gov.pl>
 <20071215203539.d6f71e96.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0712161016290.25065@bizon.gios.gov.pl>
 <20071216015112.d0ab08a1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-1450121612-1197812796=:25065"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-1450121612-1197812796=:25065
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Sun, 16 Dec 2007, Andrew Morton wrote:

> On Sun, 16 Dec 2007 10:33:20 +0100 (CET) Krzysztof Oledzki <olel@ans.pl> =
wrote:
>
>>
>>
>> On Sat, 15 Dec 2007, Andrew Morton wrote:
>>
>>> On Sun, 16 Dec 2007 00:08:52 +0100 (CET) Krzysztof Oledzki <olel@ans.pl=
> wrote:
>>>
>>>>
>>>>
>>>> On Sat, 15 Dec 2007, bugme-daemon@bugzilla.kernel.org wrote:
>>>>
>>>>> http://bugzilla.kernel.org/show_bug.cgi?id=3D9182
>>>>>
>>>>>
>>>>> ------- Comment #33 from protasnb@gmail.com  2007-12-15 14:19 -------
>>>>> Krzysztof, I'd hate point you to a hard path (at least time consuming=
), but
>>>>> you've done a lot of digging by now anyway. How about git bisecting b=
etween
>>>>> 2.6.20-rc2 and rc1? Here is great info on bisecting:
>>>>> http://www.kernel.org/doc/local/git-quick.html
>>>>
>>>> As I'm smarter than git-bistect I can tell that 2.6.20-rc1-git8 is as =
bad
>>>> as 2.6.20-rc2 but 2.6.20-rc1-git8 with one patch reverted seems to be =
OK.
>>>> So it took me only 2 reboots. ;)
>>>>
>>>> The guilty patch is the one I proposed just an hour ago:
>>>>   http://git.kernel.org/?p=3Dlinux%2Fkernel%2Fgit%2Fstable%2Flinux-2.6=
=2E20.y.git;a=3Dcommitdiff_plain;h=3Dfba2591bf4e418b6c3f9f8794c9dd8fe40ae7b=
d9
>>>>
>>>> So:
>>>>   - 2.6.20-rc1: OK
>>>>   - 2.6.20-rc1-git8 with fba2591bf4e418b6c3f9f8794c9dd8fe40ae7bd9 reve=
rted: OK
>>>>   - 2.6.20-rc1-git8: very BAD
>>>>   - 2.6.20-rc2: very BAD
>>>>   - 2.6.20-rc4: very BAD
>>>>   - >=3D 2.6.20: BAD (but not *very* BAD!)
>>>>
>>>
>>> well..  We have code which has been used by *everyone* for a year and i=
t's
>>> misbehaving for you alone.
>>
>> No, not for me alone. Probably only I and Thomas Osterried have systems
>> where it is so easy to reproduce. Please note that the problem exists on
>> my all systems, but only on one it is critical. It is enough to run
>> "sync; sleep 1; sunc; sleep 1; sync; grep Drirty /proc/meminfo" to be su=
re.
>> With =3D>2.6.20-rc1-git8 it *never* falls to 0 an *all* my hosts but onl=
y
>> on one it goes to ~200MB in about 2 weeks and then everything dies:
>> http://bugzilla.kernel.org/attachment.cgi?id=3D13824
>> http://bugzilla.kernel.org/attachment.cgi?id=3D13825
>> http://bugzilla.kernel.org/attachment.cgi?id=3D13826
>> http://bugzilla.kernel.org/attachment.cgi?id=3D13827
>>
>>>  I wonder what you're doing that is different/special.
>> Me to. :|
>>
>>> Which filesystem, which mount options
>>
>>   - ext3 on RAID1 (MD): / - rootflags=3Ddata=3Djournal
>
> It wouldn't surprise me if this is specific to data=3Djournal: that
> journalling mode is pretty complex wrt dairty-data handling and isn't wel=
l
> tested.
>
> Does switching that to data=3Dwriteback change things?

I'll confirm this tomorrow but it seems that even switching to=20
data=3Dordered (AFAIK default o ext3) is indeed enough to cure this problem=
=2E

Two questions remain then: why system dies when dirty reaches ~200MB=20
and what is wrong with ext3+data=3Djournal with >=3D2.6.20-rc2?

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1450121612-1197812796=:25065--
