Return-Path: <linux-kernel-owner+w=401wt.eu-S1754077AbYHRABV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbYHRABV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 20:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021AbYHRABM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 20:01:12 -0400
Received: from smtp102.prem.mail.sp1.yahoo.com ([98.136.44.57]:23743 "HELO
	smtp102.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751985AbYHRABL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 20:01:11 -0400
X-YMail-OSG: JunU1RMVM1ln5bhKffNW7DYAT4SYx_VOefU9fogXzgLqLT6Q6ympfwtLHDPMm_JWeO9S1D37m9uOaDt1P_qSS5KDNqV2QmRZ70NQ7C8irlaX38mqouQMcWiixAYBlPQmUmA-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <48A8BBBA.6070206@schaufler-ca.com>
Date: Sun, 17 Aug 2008 17:00:58 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: david@lang.hm, Eric Paris <eparis@redhat.com>,
       Theodore Tso <tytso@mit.edu>, Rik van Riel <riel@redhat.com>,
       davecb@sun.com, linux-security-module@vger.kernel.org,
       Adrian Bunk <bunk@kernel.org>, Mihai Don??u <mdontu@bitdefender.com>,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to alinuxinterfaceforon
 access scanning
References: <20080813125638.GB6995@ucw.cz> <20080813135207.CC08C3765BC@pmx1.sophos.com> <20080814125410.GA2262@elf.ucw.cz> <2629CC4E1D22A64593B02C43E855530304AE4BE3@USILMS12.ca.com> <20080814223918.GC6370@elf.ucw.cz> <20080814200005.6b363716@bree.surriel.com> <20080815004335.GF13048@mit.edu> <1218769209.16613.31.camel@localhost.localdomain> <20080817221258.GC21112@atrey.karlin.mff.cuni.cz> <alpine.DEB.1.10.0808171542160.12859@asgard.lang.hm> <20080817225844.GE21112@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20080817225844.GE21112@atrey.karlin.mff.cuni.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
>
>   
>>>> And I still don't get this 'mmap problem' that I don't solve that
>>>> libmalware magically solves.  What?  don't use mmap?  I certainly hope
>>>> not.
>>>>         
>>> Don't use mmap, it is as simple as that. AFAICS mmap(MAP_SHARED) --
>>> which is basically shared memory -- is fundamentally incompatible with
>>> reliable virus scanning.
>>>
>>> ...or do you have a reasonable solution for mmap?
>>>       
>> mmap has a few different problems
>>
>> 1. intercepting reads and writes to take action at that time
>>
>> 2. the fact that two programs can use it as an inter-process communication 
>> mechanism.
>>     
>
> ...can and will use it as an IPC. So we need to modify some
> applications.
>
> Rather than modify all the applications using mmap (you can't tell if
> the other side is going to use it for shared memory... right?), we
> could simply modify all the Windows-facing applications using mmap.
>
>   
>> if you are worried about the IPC aspects, all you can do is forbid it, 
>>     
>
> Can you automatically tell if applications are using mmap for IPC?
>
> BTW in another mail you wanted to include /var/log/syslog from
> scanning. You should not be doing that if syslog is exported to
> Windows systems. Of course, you can get away with scanning syslog when
> Windows client tries to read it, which should be acceptable...
> 									Pavel
>   

There is a solution to this whole scanning thing, but I've been
reluctant to suggest it, and it will be pretty obvious why y'all
probably don't want to try it. Just to be sure the options are
out on the table, here goes.

Define an xattr, let's call it "UNSCANNED", which has as its value
a timestamp. A regular file with this attribute cannot be executed
or opened,(exec or open hangs or fails, either behavior has merit
and downsides) and it requires privilege (perhaps CAP_MAC_ADMIN)
to remove the attribute. File creation attaches the attribute. Any
open for write attaches the attribute.

Your scanner runs with privilege (say CAP_MAC_OVERRIDE) and passes
judgment on files with this attribute, removing either the file, if
it is Evil, or the attribute, if it is Good. The scanner is invoked
when a file that was open with write access is closed. This can be
done using mechanisms already discussed on this thread.

If you like, you could use a "SCANNED" attribute instead of an
"UNSCANNED" attribute, and reverse the sense of the test. The
major difference will show up on filesystems that don't support
xattrs. The implications should be obvious.

Now at the beginning I said that you wouldn't like this scheme,
and it shouldn't take a security expert to see the usability problems.
This is how an old school trusted systems junkie (like me) would do
it, and I don't see a better way that would actually achieve the
stated goals. If you wanted you could implement an LSM to do the
labeling bit in a day or two, the notification in about the same
time, which would leave the scanner as the long pole in your
development schedule.

P.S. - Library based security doesn't work.


