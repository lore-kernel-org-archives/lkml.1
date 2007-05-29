Return-Path: <linux-kernel-owner+w=401wt.eu-S1763544AbXE2DzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763544AbXE2DzS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 23:55:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760207AbXE2DzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 23:55:06 -0400
Received: from smtpout.mac.com ([17.250.248.177]:62791 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753561AbXE2DzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 23:55:03 -0400
In-Reply-To: <9d732d950705280341x78575d85kaf95b0e2884723f3@mail.gmail.com>
References: <309300.41401.qm@web36615.mail.mud.yahoo.com> <B4A3C582-68F9-4077-B058-03B79A5577EB@mac.com> <Line.LNX.4.64.0705261442000.23020@d.namei> <9d732d950705261608j4bc72cd4s4378df9848101c84@mail.gmail.com> <EC769668-ED57-4D6D-80B2-1BFD039E113C@mac.com> <9d732d950705270025p1bedae23ne137f024eb78886f@mail.gmail.com> <4F828E03-DA6B-484E-A8F2-885D1BC6F23E@mac.com> <9d732d950705280341x78575d85kaf95b0e2884723f3@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <69A10107-78FE-4F11-AF52-9B8F648AFC0A@mac.com>
Cc: James Morris <jmorris@namei.org>, casey@schaufler-ca.com,
       Andreas Gruenbacher <agruen@suse.de>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSM hook
Date: Mon, 28 May 2007 21:54:46 -0400
To: Toshiharu Harada <haradats@gmail.com>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On May 28, 2007, at 06:41:11, Toshiharu Harada wrote:
> 2007/5/27, Kyle Moffett <mrmacman_g4@mac.com>:
>>>> If you can't properly manage your labels, then how do you expect  
>>>> any security at all?
>>> Please read my message again. I didn't say, "This can never be  
>>> achieved".  I said, "This can not be easily achieved".
>>
>> So you said "(data labels) can not be easily achieved".  My  
>> question for you is: How do you manage secure UNIX systems without  
>> standard UNIX permission bits?  Also:  If you have problems with  
>> data labels then what makes pathname based labels "easier"?  If  
>> there is something that could be done to improve SELinux and make  
>> it more readily configurable then it should probably be done.
>
> Permission bits can be checked easily with "ls" command but  
> assuring the correctness of labels are not that easy. I'll try to  
> explain.
>
> The correctness of the permission bit for a given file can be  
> judged solely by the result of "ls" command.  The correctness of  
> the label, on the other hand, can't be judged without understanding  
> of whole policy including domain transitions. (see the attached  
> figure) I can imagine that once one get the complete SELinux  
> policy, then it is able to modify and maintain it.

That's why there are a number of efforts to make modular SELinux  
policies.  A good SELinux policy provides a few core system types and  
labels which a policy developer needs to understand, as well as some  
good macros to simplify the human-editable policy files.  For  
instance, in my customized policy a daemon run by an initscript which  
reads a single config file in /etc needs this policy (Note that I use  
"_d" as a suffix for process domains instead of the usual "_t"):

initrc_daemon(foo_exec_t, foo_d)
daemon_config(foo_d, foo_conf_t)

Add maybe 2 lines for network port access, another 2 for database  
files in /var, plus maybe an "iptables" rule or two in your firewall  
file.

> I don't say making a complete SELinux policy is impossible, and  
> actually you said you did it.  But to be frank, I don't think you  
> are the average level user at all. ;-)

Average users are not supposed to be writing security policy.  To be  
honest, even average-level system administrators should not be  
writing security policy.  It's OK for such sysadmins to tweak  
existing policy to give access to additional web-docs or such, but  
only expert sysadmin/developers or security professionals should be  
writing security policy.  It's just too damn easy to get completely  
wrong.

>>> I'm very interested in how you can know that you have the correct  
>>> object labeling (this is my point). Could you tell?
>>
>> I know that I have the correct object labeling because:
>
> Do you mind if I add this?
>
> 0) I understood the default policy and perfectly understand the  
> every behavior of my system.
>
> this is where the difficulties exist.

You don't have to understand the entire default policy; that's the  
point of modular policy.  You only have to understand how to _use_  
the interfaces of the system policy (which are documented) and how  
the particular daemon policy is supposed to work.  The people  
developing the core system policy need to understand the inner  
workings of said policy, but they don't need to understand how the  
rest of the system works.  The core functionality behind this  
separation is macro interfaces and attributes.  By grouping types  
with attributes it is possible for arbitrary daemon types to  
categorize themselves under access rules defined by the base policy,  
and with interfaces the daemons don't really even need to know what  
those attributes are called.

>>> I don't deny DAC at all.  If we deny DAC, we can't live with  
>>> Linux it's the base.  MAC can be used to cover the shortages of  
>>> DAC and Linux's simple user model, that's it.
>>>
>>> From security point of view, simplicity is always the virtue and  
>>> the way to go.  Inode combined label is guaranteed to be a single  
>>> at any point time.  This is the most noticeable advantage of  
>>> label-based security.
>>
>> I would argue that pathname-based security breaks the "simplicity  
>> is the best virtue (of a security system)" paradigm, because it  
>> attributes multiple potentially-conflicting labels to the same piece
>
> I have a question for you.  With current implementation of SELinux,  
> only one label can be assigned.  But there are cases
> that one object can be used in different context, so I think it  
> might help if SELinux would allow objects to have multiple labels.  
> (I'm not talking about conflicts here)  What do you think?

This is the whole advantage of SELinux type attributes: you can  
define a type "var_foo_t" which has a specific list of attributes;  
rules which accept type specifiers can also accept attribute  
specifiers as well.  If what you want is a label which may be  
accessed in two different ways, then you declare attributes for each  
access method and declare a type which has the attributes "filetype",  
"access1", and "access2" (assuming access1 and access2 are the names  
of the attributes you declared and used in your access rules).

>>> But writing policy with labels are somewhat indirect way (I mean,  
>>> we need "ls -Z" or "ps -Z").  Indirect way can cause flaw so we  
>>> need a lot of work that is what I wanted to tell.
>>
>> I don't really use "ls -Z" or "ps -Z" when writing SELinux policy; I
>> do that only when I actually think I mislabeled files.
>
> I believe what you wrote, but it may not be as easy for average  
> Linux users.

As I said before, average Linux users should not be writing their own  
security policy.  I have yet to meet an "average Linux user" who  
could reliably quote for me what the file permissions on the "/tmp"  
directory should be, or what the sticky bit was.  A small percentage  
of average Linux system administrators don't get that right  
consistently, and if you don't understand the sticky bit then you  
should *definitely* not be controlling program permissions on a per- 
syscall basis.

Cheers,
Kyle Moffett

