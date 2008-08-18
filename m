Return-Path: <linux-kernel-owner+w=401wt.eu-S1753023AbYHRAnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023AbYHRAnU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 20:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750950AbYHRAnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 20:43:08 -0400
Received: from smtp101.prem.mail.sp1.yahoo.com ([98.136.44.56]:26764 "HELO
	smtp101.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750858AbYHRAnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 20:43:07 -0400
X-YMail-OSG: ODgqU3MVM1nbOD1WkrF1r0q.t1c2MpW1LDTeOBN1t6WZQC93y7YD3Pp0Hcvo6U85z_iavtTNCPQd2HcO918feoV6JxjXp2fdqj8ViN2aYYkT5B55osBsN7p1KwiEdmJGAfDF_jUeaaAe1auLmK4QP_81
X-Yahoo-Newman-Property: ymail-3
Message-ID: <48A8C58C.7030208@schaufler-ca.com>
Date: Sun, 17 Aug 2008 17:42:52 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: david@lang.hm
CC: Pavel Machek <pavel@suse.cz>, Eric Paris <eparis@redhat.com>,
       Theodore Tso <tytso@mit.edu>, Rik van Riel <riel@redhat.com>,
       davecb@sun.com, linux-security-module@vger.kernel.org,
       Adrian Bunk <bunk@kernel.org>, Mihai Don??u <mdontu@bitdefender.com>,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to alinuxinterfaceforon
 access scanning
References: <20080813125638.GB6995@ucw.cz> <20080813135207.CC08C3765BC@pmx1.sophos.com> <20080814125410.GA2262@elf.ucw.cz> <2629CC4E1D22A64593B02C43E855530304AE4BE3@USILMS12.ca.com> <20080814223918.GC6370@elf.ucw.cz> <20080814200005.6b363716@bree.surriel.com> <20080815004335.GF13048@mit.edu> <1218769209.16613.31.camel@localhost.localdomain> <20080817221258.GC21112@atrey.karlin.mff.cuni.cz> <alpine.DEB.1.10.0808171542160.12859@asgard.lang.hm> <20080817225844.GE21112@atrey.karlin.mff.cuni.cz> <48A8BBBA.6070206@schaufler-ca.com> <alpine.DEB.1.10.0808171708230.12859@asgard.lang.hm>
In-Reply-To: <alpine.DEB.1.10.0808171708230.12859@asgard.lang.hm>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm wrote:
> On Sun, 17 Aug 2008, Casey Schaufler wrote:
>
>> Pavel Machek wrote:
>>>>>> And I still don't get this 'mmap problem' that I don't solve that
>>>>>> libmalware magically solves.  What?  don't use mmap?  I certainly 
>>>>>> hope
>>>>>> not.
>>>>>>
>>>>> Don't use mmap, it is as simple as that. AFAICS mmap(MAP_SHARED) --
>>>>> which is basically shared memory -- is fundamentally incompatible 
>>>>> with
>>>>> reliable virus scanning.
>>>>>
>>>>> ...or do you have a reasonable solution for mmap?
>>>>>
>>>> mmap has a few different problems
>>>>
>>>> 1. intercepting reads and writes to take action at that time
>>>>
>>>> 2. the fact that two programs can use it as an inter-process 
>>>> communication mechanism.
>>>>
>>>
>>> ...can and will use it as an IPC. So we need to modify some
>>> applications.
>>>
>>> Rather than modify all the applications using mmap (you can't tell if
>>> the other side is going to use it for shared memory... right?), we
>>> could simply modify all the Windows-facing applications using mmap.
>>>
>>>
>>>> if you are worried about the IPC aspects, all you can do is forbid it, 
>>>
>>> Can you automatically tell if applications are using mmap for IPC?
>>>
>>> BTW in another mail you wanted to include /var/log/syslog from
>>> scanning. You should not be doing that if syslog is exported to
>>> Windows systems. Of course, you can get away with scanning syslog when
>>> Windows client tries to read it, which should be acceptable...
>>>                                     Pavel
>>>
>>
>> There is a solution to this whole scanning thing, but I've been
>> reluctant to suggest it, and it will be pretty obvious why y'all
>> probably don't want to try it. Just to be sure the options are
>> out on the table, here goes.
>>
>> Define an xattr, let's call it "UNSCANNED", which has as its value
>> a timestamp. A regular file with this attribute cannot be executed
>> or opened,(exec or open hangs or fails, either behavior has merit
>> and downsides) and it requires privilege (perhaps CAP_MAC_ADMIN)
>> to remove the attribute. File creation attaches the attribute. Any
>> open for write attaches the attribute.
>>
>> Your scanner runs with privilege (say CAP_MAC_OVERRIDE) and passes
>> judgment on files with this attribute, removing either the file, if
>> it is Evil, or the attribute, if it is Good. The scanner is invoked
>> when a file that was open with write access is closed. This can be
>> done using mechanisms already discussed on this thread.
>>
>> If you like, you could use a "SCANNED" attribute instead of an
>> "UNSCANNED" attribute, and reverse the sense of the test. The
>> major difference will show up on filesystems that don't support
>> xattrs. The implications should be obvious.
>>
>> Now at the beginning I said that you wouldn't like this scheme,
>> and it shouldn't take a security expert to see the usability problems.
>> This is how an old school trusted systems junkie (like me) would do
>> it, and I don't see a better way that would actually achieve the
>> stated goals. If you wanted you could implement an LSM to do the
>> labeling bit in a day or two, the notification in about the same
>> time, which would leave the scanner as the long pole in your
>> development schedule.
>
> did you read the proposal I wrote up? it's similar to (but more 
> flexible than) what you are saying

Sorry, I must have missed it. My bad.

> it would allow for multiple 'scanned' tags (to allow for multiple 
> scanning programs). the kernel would clear the tags when the file is 
> dirtied (not when it is closed, the file may not be closed for weeks 
> after all), there is a mechanism to tell the scanner(s) that a file 
> was modified (rather then having to scan the entire filesystem), and 
> if the scan was not done yet when a file is opened the scanner(s) can 
> be invoked at that time.
>

One xattr, multiple xattrs, all would work. It's simpler to clear the
"scanned" attribute on open than on dirty, a your scheme means looking
at writes, seeks, ioctls, fcntls, and so on.
 
>> P.S. - Library based security doesn't work.
>
> why not? (with the appropriate kernel support)

If you have kernel support it aint library based.

> it actually wouldn't be hard to have the kernel check the xattr, what 
> would be hard is hving the kernel know when it should then invoke the 
> scanner(s) and when it shouldn't. This is a policy decision that 
> doesn't belong in the kernel.

I'm old school. I say that all policy decisions regarding objects that
the kernel maintains belong in the kernel. That's why I say that any time
a file is closed with scanned unset (or unscanned set) the scanner should
be invoked or notified. The scanner can choose to ignore or queue the
notification, but the kernel will be done at that point. The kernel have
done all that it can and it's up to the scanner from then on.


