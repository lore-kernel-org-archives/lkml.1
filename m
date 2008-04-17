Return-Path: <linux-kernel-owner+w=401wt.eu-S1759778AbYDQHWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759778AbYDQHWt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 03:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753491AbYDQHWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 03:22:38 -0400
Received: from mail8.dotsterhost.com ([66.11.233.1]:52399 "HELO
	mail8.dotsterhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753247AbYDQHWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 03:22:37 -0400
Message-ID: <4806FB3E.10200@crispincowan.com>
Date: Thu, 17 Apr 2008 00:24:46 -0700
From: Crispin Cowan <crispin@crispincowan.com>
Organization: Crispin's Labs
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: casey@schaufler-ca.com
CC: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, sds@tycho.nsa.gov,
       serue@us.ibm.com, matthew@wil.cx, paul.moore@hp.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, takedakn@nttdata.co.jp,
       linux-fsdevel@vger.kernel.org
Subject: Re: [TOMOYO #7 30/30] Hooks for SAKURA and TOMOYO.
References: <687382.36673.qm@web36604.mail.mud.yahoo.com>
In-Reply-To: <687382.36673.qm@web36604.mail.mud.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler wrote:
> --- Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> wrote
>> Casey Schaufler wrote:
>>     
>>> The question of protections on the object named /etc/passwd came
>>> up time and time again. The notion that /etc/passwd could be a
>>> symlink to /home/smalley/heeheehee really gave evaluators the
>>> whillies. As did the chroot environment, where /roots/crispin/etc/passwd
>>> could magicly become /etc/passwd.
>>>       
>> Why do people continue speaking symlinks and chroots?
>>     
> Because on any given Linux system you could have an arbitrarily
> large number of different things that might be accessed by the
> name "/etc/passwd" and a different, but similarly large number
> of names other than "/etc/passwd" that can be used to access them.
>   
But that's not quite true.

"/etc/passwd" can indeed point anywhere, but it can only point to a 
single place at a time. I've alluded to this several times in pointing 
out that labels and names have dualistic many:one and one:many 
relationships to actual files.

This is Tetsuo's point: if you symlink or chroot /etc/shadow to point 
some place strange, then the redirection will be resolved *before* 
AppArmor and TOMOYO consider the security question of whether access 
should be allowed. Therefore, the fact that you re-directed it is 
irrelevant to security.

>> To avoid the effect of symlinks and chroots, AppArmor and TOMOYO Linux
>> derive pathnames from dentry and vfsmount.
>> If /etc/passwd was a symlink, the derived pathname will be
>> /home/smalley/heeheehee.
>> If accessed from inside a chroot, the derived pathname will be
>> /roots/crispin/etc/passwd.
>>     
> Which doesn't hold up under hard links, which I had carefully
> avoided and that both AppArmor and TOMOYO Linux have to place
> restrictions on for the systems to make sense.
>   
Hard links are indeed handled differently, but they are handled. I don't 
know what TOMOYO does. What AppArmor does is exploit the fact that you 
cannot hard link a directory, so the target of a hard link must be a 
file. From there, we can use the    dentry to disambiguate which file. 
So again, even though more than one name points to the inode, the name 
that was actually  used to get to this inode is unique, and we recover 
it and then consider the security question of whether you get to access 
that name.

>> It is true that namespace may differ between processes,
>> but I think that that is the matter of how to restrict namespace manipulation
>> operations.
>> As I said, a system can't survive if namespace is madly manipulated.
>>     
> That's hardly the viewpoint of those who would have every
> user mount their own version of /tmp.
>   
Well, AppArmor and TOMOYO don't do well if the namespace is madly 
manipulated. They remain secure, because they prohibit name space 
manipulations by confined processes. If what you wanted to do was lots 
of  name space manipulations, it makes (at least AppArmor) a poor choice 
for you.

>> It is true that the pathname may change while traversing up the
>> dentry/vfsmount trees.
>> But the change does not occur infinitely.
>> As I said, a system can't survive if files and directories are madly renamed.
>> The possible changes are bounded by the policy.
>>
>> At least, I want people not to speak symlinks and chroots when talking about
>> AppArmor and TOMOYO Linux.
>>     
> The issues with links, symlinks, chroots and mounts in the
> context of a name based access control scheme will always
> need to be addressed, just as the issues of unlabeled filesystems
> and /tmp will have to be in label based scheme.
>   
Agreed. Duality abounds in this space.

Crispin

-- 
Crispin Cowan, Ph.D.               http://crispincowan.com/~crispin
The Olympic Games: Symbolizing oppressiiion and corruption for over a
hundred years

