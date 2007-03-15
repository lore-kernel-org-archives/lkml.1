Return-Path: <linux-kernel-owner+w=401wt.eu-S965028AbXCODNK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965028AbXCODNK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 23:13:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965024AbXCODNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 23:13:09 -0400
Received: from vms048pub.verizon.net ([206.46.252.48]:57946 "EHLO
	vms048pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965028AbXCODNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 23:13:08 -0400
Date: Wed, 14 Mar 2007 23:12:48 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: New thread RDSL, post-2.6.20 kernels and amanda (tar) miss-fires
In-reply-to: <2c0942db0703141449h5f6eb2e4sadf493741d67ecc0@mail.gmail.com>
To: linux-kernel@vger.kernel.org, ray-gmail@madrabbit.org
Message-id: <200703142312.48852.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200703130428.11014.gene.heskett@gmail.com>
 <200703132331.56140.gene.heskett@gmail.com>
 <2c0942db0703141449h5f6eb2e4sadf493741d67ecc0@mail.gmail.com>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 March 2007, Ray Lee wrote:
>On 3/13/07, Gene Heskett <gene.heskett@gmail.com> wrote:
>> On Tuesday 13 March 2007, Gene Heskett wrote:
>> >On Tuesday 13 March 2007, Gene Heskett wrote:
>> >>Greetings;
>> >>Someone suggested a fresh thread for this.
>> >>
>> >>I now have my scripts more or less under control, and I can report
>> >> that kernel-2.6.20.1 with no other patches does not exhibit the
>> >> undesirable behaviour where tar thinks its all new, even when told
>> >> to do a level 2 on a directory tree that hasn't been touched in
>> >> months to update anything.
>> >>
>> >>Next up, 2.6.20.2, plain and with the latest RDSL-0.30 patch.
>> >
>> >And amanda/tar worked normally for 2.6.20.2 plain.
>> >
>> >Next up, 2.6.21-rc1 if it will build here.
>>
>> It built, it booted, and its busted big time.  First, with an amdump
>> running in the background, the machine is so close to unusable that I
>> considered rebooting, but I needed the data to show the problem.  I am
>> losing the keyboard and mouse for a minute or more at a time but the
>> keystrokes seem to be being registered so it eventually catches up.
>>
>> Disk i/o seems to be the killer according to gkrellm.
>>
>> But to give one an idea of the fits this is giving tar, I'll snip a
>> line or 2 from an amstatus report here:
>> coyote:/GenesAmandaHelper-0.6 1 planner: [dumps way too big, 138200
>> KB, must skip incremental dumps]
>>
>> Huh?  138.2GB?  A 'du -h .' in that dir says 766megs.
>>
>> coyote:/root                  1     4426m wait for dumping
>> du -h says 5.0GB so that's ballpark, but its also a level 1, so maybe
>> 20 megs is actually new since 15:57 this afternoon local.  kmails
>> final maildir is in that dir.
>>
>> This goes on for much of the amstatus report, very few of the reported
>> sizes are close to sane.
>>
>> Now, can someone suggest a patch I can revert that might fix this? 
>> The total number of patches between 2.6.20 and 2.6.21-rc1 will have me
>> building kernels to bisect this till the middle of June at this rate.
>
>In a previous email, you said you were using ext3. If that's the case,
>there doesn't appear to be much going on in terms of patches between
>2.6.20 and 2.6.21-rc1. The only one that even comes close to looking
>like it might have an effect would only come in to play if you have a
>filesystem that has ACL information, but is mounted by a kernel that
>doesn't have ACL support.
>
>I have to echo wli here, I'm afraid, and recommend at least a *few*
>bisections to help narrow down the list of suspect patches.
>
>There are tutorials out there for git users. I use the mercurial
>repository, as I find the mercurial interface and workflow a lot more
>intuitive, but it has the same capability.
>
>Even 2-5 bisections will greatly help others hunt the bug down.
>
>Ray

Probably.  But I've now put a week into this, and from some other clues 
I've collected, I'm beginning to think tar has a tummy ache. After all, 
and ls -lc reports totally sane mtimes.  So why is tar going bonkers 
under kernels 2.6.21-rc*, with or without Cons patches?

I've also spent a day now looking for a valid place to put a bugzilla 
entry against tar, but googles search results are sending me to 
gcc.gnu.org and this is NOT the correct bugzilla for a tar problem.

Its no secret that with all the churn in tar over the last 5 years, worse 
churn than the kernel IMO in going from 2.0 to 2.6, that I'm not a fan of 
yet another _new_ version of tar, when what we just need is _one_ that 
works.  It is not capable of executing the recovery command listed in the 
first block of every amdump file it (amdump) ever built right now, and 
I've played the equ of the 10,000 monkeys writing Shakespear for several 
hours trying.  Damned frustrating is what it is.

The error it reports seems to indicate that it cannot write through the 
pipes involved.  But with tar's error reporting, who the hell knows for 
sure.

Here is an example
[root@coyote data]# dd if=00010.coyote._lib.1 bs=32k count=1
AMANDA: FILE 20070314104344 coyote /lib  lev 1 comp .gz program /bin/tar
To restore, position tape at start of file and run:
 dd if=<tape> bs=32k skip=1 |  /bin/gzip -dc |  /bin/tar -f - ...

And the elipsis is an error if not removed.  Then one is supposed to be 
able to redirect tars output with the usual >/tmp/test/ syntax

So:
[root@coyote data]# dd if=00010.coyote._lib.1 bs=32k 
skip=1 |  /bin/gzip -dc |  /bin/tar -f - >/tmp/test/
-bash: /tmp/test/: Is a directory

which is the return from any variation in how the redirect is done.

So what is it that am I doing wrong in the above command line?, so I can 
add it to my helper scripts to be published eventually on zmanda.org.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Trying to establish voice contact ... please ____yell into keyboard.
