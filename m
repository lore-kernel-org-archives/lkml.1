Return-Path: <linux-kernel-owner+w=401wt.eu-S1754221AbZGUNlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221AbZGUNlm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 09:41:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752085AbZGUNll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 09:41:41 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34826 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077AbZGUNlk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 09:41:40 -0400
Message-ID: <4A65C570.40108@redhat.com>
Date: Tue, 21 Jul 2009 09:41:04 -0400
From: Daniel J Walsh <dwalsh@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Christopher Pardy <cpardy@redhat.com>
CC: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov,
       sds@tycho.nsa.gov, jmorris@namei.org, spender@grsecurity.net,
       cl@linux-foundation.org, arjan@infradead.org, alan@lxorguk.ukuu.org.uk
Subject: Re: mmap_min_addr and your local LSM (ok, just SELinux)
References: <1248132223.2654.278.camel@localhost> <4A650867.2030205@redhat.com>
In-Reply-To: <4A650867.2030205@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2009 08:14 PM, Christopher Pardy wrote:
> On 07/20/2009 07:23 PM, Eric Paris wrote:
>> Brad Spengler recently pointed out that the SELinux decision on how to
>> handle mmap_min_addr in some ways weakens system security vs on a system
>> without SELinux (and in other ways can be stronger).  There is a trade
>> off and a reason I did what I did but I would like ideas and discussion
>> on how to get the best of both worlds.
>>
>> With SELinux mapping the 0 page requires an SELinux policy permission,
>> mmap_zero.  Without SELinux mapping the 0 page requires CAP_SYS_RAWIO.
>> Note that CAP_SYS_RAWIO roughly translates to uid=0 since noone really
>> does interesting things with capabilities.
>>
>> The main problem is WINE.  I'm told that WINE needs to map the 0 page to
>> support 16bit applications.  On distros without SELinux users must
>> disable the mmap_min_addr protections for the ENTIRE system if they want
>> to run WINE.
>>
>> http://wiki.winehq.org/PreloaderPageZeroProblem
>>
>> I believe (from reading mailing lists) if you install WINE on ubuntu it
>> automatically disables these protections.  Thus installing wine on
>> ubuntu disables ALL hardening gains of the mmap_min_addr.
>>
>> On Fedora, with SELinux, we allow users to run WINE in a domain that has
>> the SELinux mmap_zero permission and thus other programs/domains, do not
>> have security weakened.  Your daemons, like the web server, are still
>> unable to map the 0 page.  This is different than distros without
>> SELinux, remember they have to disable protection globally.
>>
>> But logged in users (by default), under SELinux, are 'unconfined' and
>> can by their very nature run their program in a domain that allows
>> mmap_zero.  Trying to 'confine' the 'unconfined' user with SELinux is an
>> open problem which we don't currently even reasonably attempt address on
>> a broad scale.  It's like besieging the user in a gentle mist of water
>> hoping they won't try to escape.
>>
>> So in Fedora your web server is a harder entry point to exploit kernel
>> NULL pointer bugs, but you have no protections against a malicious user.
>> On Ubuntu if you install WINE your web server and your logged in users
>> have no hardening.  If you do not install WINE non-root is hardened,
>> anything running as root is not (aka suid apps, aka pulseaudio).
>>
>> So I was thinking today, wondering how to get the best (or at least
>> better) of both worlds on an SELinux system.  I was considering adding a
>> second mmap_min_addr_lsm which would typically be equal to
>> mmap_min_addr.  The purpose would be to allow the sysadmin to
>> individually control DAC/LSM protections.  The security checks would
>> turn (sort of) into
>>
>> if (addr < mmap_min_addr)
>>    ret |= capable(CAP_SYS_RAWIO);
>> if (addr < mmap_min_addr_lsm)
>>    ret |= [insert LSM check here]
>>
>> So on a non-SELinux system users would end up with exactly what they
>> have today.  if you want to run WINE as a normal user you have to set
>> mmap_min_addr = 0 and then you no longer need CAP_SYS_RAWIO.  Not much
>> else we can do if your distro down support fine grained permissions.
>>
>> On an SELinux system what this lets me do is default to a stricter
>> setup, one in which you have to have both CAP_SYS_RAWIO and the selinux
>> mmap_zero permission.  You, out of the box, get protection for both your
>> malicious logged in user and your web server.  Then if a user decides to
>> run WINE they would turn down mmap_min_addr.  This would remove the
>> requirement that they are root, and leave the system vulnerable to a
>> malicious user, but would still allow SELinux to protect confined
>> domains and daemons.
>>
>> Does anyone see a better way to let users continue to be users while
>> protecting most people?  Yes SELinux is stronger in some areas than
>> without confining the ability to map the 0 page, but as has be rightly
>> pointed out it's foolish an broken that SELinux can weaken any
>> protections.
>>
>> -Eric
>>
>>
>> --
>> This message was distributed to subscribers of the selinux mailing list.
>> If you no longer wish to subscribe, send mail to majordomo@tycho.nsa.gov with
>> the words "unsubscribe selinux" without quotes as the message.
> 
> If I'm not mistaken whats happening here is that some old 16 bit windows libraries have static addresses rather than pc offset or dynamically calculated ones. I don't think linux apps have ever done this so...
> 
> Beyond wine no other applications should use this.
> 
> The best solution would be to add code to wine which performs address recalculations either or the fly or at load time. Alternatively you could tell people who want 16 bit support to run wine or windows in a VM.
> Or a boolean could be added to allow wine to support 16 bit applications which would allow it to do this, basically the same idea you had but in a way past selinux users might understand better then needing to set a system value. Make the default value off and tell users, you set this and your kernel may be compromised, try with it off first, run it in a VM and only if you absolutely have to should you allow this.
> 
> Christopher Pardy
> 
> --
> This message was distributed to subscribers of the selinux mailing list.
> If you no longer wish to subscribe, send mail to majordomo@tycho.nsa.gov with
> the words "unsubscribe selinux" without quotes as the message.


I kind of like the idea of removing any special handling of LSM so it works the same with SELinux enabled or disabled.
Secondly remove the default ability for wine to work with 16 bit apps.  So 32 bit wine apps just work out of the box without having to drop security.  Then either force wine users to turn off the protection to run their 16 bit apps or add a setuid application wine16 which is setuid and drops capabilities, so that you can run your 16 bit apps.

