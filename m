Return-Path: <linux-kernel-owner+w=401wt.eu-S1764080AbXHKVrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764080AbXHKVrg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 17:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760775AbXHKVr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 17:47:28 -0400
Received: from smtpout.mac.com ([17.250.248.176]:64516 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756661AbXHKVr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 17:47:26 -0400
In-Reply-To: <976827.87061.qm@web36611.mail.mud.yahoo.com>
References: <976827.87061.qm@web36611.mail.mud.yahoo.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <C9D4F464-7821-4483-8FA9-74073653D194@mac.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@osdl.org, torvalds@osdl.org
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [PATCH] Smack: Simplified Mandatory Access Control Kernel
Date: Sat, 11 Aug 2007 17:47:18 -0400
To: casey@schaufler-ca.com
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 11, 2007, at 17:01:09, Casey Schaufler wrote:
>> [SELinux...] which can do *all* of this, completely and without  
>> exceptions,
>
> That's quite a strong assertion.

It is, but I stand by it.  If anyone can point out some portion of  
this which *cannot* be implemented as SELinux policy I will humbly  
step completely out of this discussion.


>> but one does have to have complexity in order to handle everything  
>> from CD burning in X, to Apache daemons, to only allowing Top- 
>> Secret-level logins over the IPsec tunnel on the Top Secret  
>> network, etc.
>
> I do not agree with you. The MLS systems from the 1990's could do  
> all that (except the IPsec tunnel, the function of which was  
> preceeded by TSIG interfaces and protocols) without the complexity  
> required by SELinux policy.

No, most/all of the MLS systems from the 1990s did not integrate Bell- 
LaPadula, Type Enforcement, and Role-Based-Access-Control together.   
In addition, none of the MLS systems from the 1990s had modifiable  
constraints the way SELinux does (for example I can modify the  
fundamental policy to allow a process whose domain has the  
"i_am_special" attribute to override the BLP model for certain target  
types in certain special situations, all depending on how I apply  
that attribute and those types).

>> For  example, this set of rules basically defines your described  
>> "read-vs-write-vs-exec" policy as best I can figure out:
>>
>> user uu roles rr;
>>
>> role rr types { star floor hat huh };
>>
>> define(`r',`
>> allow $1 $2:file { read getattr };
>> allow $1 $2:socket { read getattr getopt recvfrom recv_msg };
>> allow $1 $2:ipc { getattr read associate unix_read };
>> ## List of more "read" allow rules for different types of  
>> objects... ##
>> ')
>
> It would be instructive for those who are not well versed in the  
> nuances of SELinux policy if you actually spelled out the whole  
> thing, rather than using "## and more ##". Part of the point of  
> Smack is the makeup of the full list that would be required here.

Well, yes, but how exactly do you define "read", "write", and  
"execute" for the full list of SELinux object classes found here:
http://www.tresys.com/selinux/obj_perms_help.html

I was considering compiling the complete list, but such an exercise  
would take me at least an hour to do properly and which categories  
individual permissions should be placed in could be argued for  
weeks.  The SELinux reference policy doesn't even completely qualify  
all of those things with MLS restrictions, and they're the ones who  
got the hooks implemented originally.

Specifically, do you classify the bind() syscall as a "read" or a  
"write" operation.  How would you classify accept()?  In order to  
support the full range of security controls that Linux has hooks for,  
you would need to identify a list of how to define "read", "write",  
and "execute" for every object-class in that massive list.   
Furthermore you would need to ensure that the definitions work for  
every process.  From the variations between different portions of the  
SELinux ref policy, I contend that there is no single definition of  
"read", or "write" which works for all usages of a given object-class.

>> And now to describe these rules:
>>
>>> Smack defines and uses these labels:
>>>   "*" - pronounced "star"
>>>   "_" - pronounced "floor"
>>>   "^" - pronounced "hat"
>>>   "?" - pronounced "huh"
>>>
>>> The access rules enforced by Smack are, in order:
>>>
>>> 1. Any access requested by a task labeled "*" is denied.
>>> 2. A read or execute access requested by a task labeled "^"
>>>    is permitted.
>>> 3. A read or execute access requested on an object labeled "_"
>>>    is permitted.
>>> 4. Any access requested on an object labeled "*" is permitted.
>>> 5. Any access requested by a task on an object with the same
>>>    label is permitted.
>>> 6. Any access requested that is explicitly defined in the loaded
>>>    rule set is permitted.
>>> 7. Any other access is denied.
>>
>> ## These are calls to the above macros which plug in the necessary
>> arguments
>> r(hat, {*})
>> x(hat, {*})
>> r(~{star}, floor)
>> x(~{star}, floor)
>> r(~{star}, star)
>> w(~{star}, star)
>> x(~{star}, star)
>> r(~{star}, self)
>> w(~{star}, self)
>> x(~{star}, self)
>> ## Include your "loaded rule set" here ##
>
> What would that look like?

The same kind of thing as the r, x, and w above, with occasional  
"type my_type_t; role rr types my_type_t;" to declare a type before  
use.  If you wanted to add support for attributes which apply to  
multiple types, you could put those after a comma after the "type  
my_type_t" portion of the type declaration.

>>> Smack rule sets can be easily defined that describe Bell&LaPadula  
>>> sensitivity, Biba integrity, and a variety of interesting  
>>> configurations. Smack rule sets can be modified on the fly to  
>>> accomodate changes in the operating environment or even the time  
>>> of day.
>>
>> SELinux can do this as well.  It even includes support for  
>> conditional policy:
>>
>> bool foo_can_do_logging true;
>> if (foo_can_do_logging) {
>> 	allow foo_t foo_log_t:file { create read getattr append };
>> }
>
> You have to build the booleans into the policy in advance.

Well, yes, but a policy which completely ignores


>> The SELinux tools also have support for policy modules, so you can  
>> extend the policy without modifying the base system.
>
> And that's a good thing, but you still have to compile and reload  
> your policy, and maybe relabel you filesystem when you do so.

What exactly prevents you from having to "reload" and "relabel the  
filesystem" when using your system?  When you change the meaning of  
new types, you clearly would need to first reload the policy then  
relaunch programs or relabel files to take advantage of the new  
types, otherwise they would be categorically ignored by the system.

The only difference is the "compile" step, which converts from a  
reasonably modifiable language into a binary format which the kernel  
can efficiently parse.  I suspect you'd get shot down instantly if  
you tried to stuff the policy compiler in the kernel too.

>>> Some practical use cases:
>>>
>>> Hierarchical levels. The less common of the two usual uses for  
>>> MLS  systems is to define hierarchical levels, often  
>>> unclassified, confidential, secret, and so on. To set up smack to  
>>> support this, these rules could be defined:
>>>
>>>    C        Unclass rx
>>>    S        C       rx
>>>    S        Unclass rx
>>>    TS       S       rx
>>>    TS       C       rx
>>>    TS       Unclass rx
>>>
>>> A TS process can read S, C, and Unclass data, but cannot write  
>>> it.  An S process can read C and Unclass. Note that specifying  
>>> that TS can read S and S can read C does not imply TS can read C,  
>>> it has to be explicitly stated.
>>
>> The big problem here is the duplication.  Say you have a locked- 
>> down Apache configuration and you want to run 2 apache processes,  
>> one at Secret and one at Top-Secret.  Under your model you have to  
>> copy-paste the policy and make sure to apply fixes/changes to both  
>> places.
>
> I'm sorry, but I don't understand your point at all.

Ok, let's say you want to use your model to restrict Apache and MySQL  
running at the same classification level.  You have to define  
combined labels, such as:
   S_Apache   S_MySQL rx
   [...]

Now if you want to run an apache/mysql pair at TS, you have to copy  
all those rules and substitute "S_" with "TS_".  With SELinux, you  
don't have to do anything other than define new labels for the secret- 
web-docs and the top-secret-web-docs folders, because the Apache  
*type-enforcement* policy is completely independent from the MLS  
levels.  You can write a 5-line policy to label 2 slightly different  
initscripts with different range-transitions.  The only difference  
between them will be the paths inside and the labels on them.  The  
rest of apache's policy stays the same.

>> This is exactly what my company does, but the ability to restrict  
>> *exactly* what mechanisms are used is important.  You restrict  
>> against file-system access implicitly, whereas SELinux does it  
>> explicitly:
>>    allow foo_t foo_sock_t:socket { .... };
>> versus:
>>    allow foo_t foo_log_t:file { ... };
>>
>> With SELinux you can also allow your program to create files  
>> labelled as "log files" in one directory in one type and "transfer  
>> files" in another directory in a completely different type.
>
> I would be very interested to see the policy that your guard box uses.

Unfortunately that's still considered company-proprietary information  
at the moment, although that's likely to change at some point in the  
future.  We're not all that different from the httpd policies and  
similar stuff found in the SELinux "refpolicy" available from tresys'  
website.

>> I'm proud to say that the software of the company I work for does  
>> not   need any extra privilege at all (aside from binding to ports  
>> <1024) to run under SELinux with strict MLS.
>
> That is an aspect of SELinux that has its dark side. While you are  
> not explicitly violating a policy (e.g. requiring a capability) you  
> are doing things that some of us would argue ought to require a  
> capability. SELinux integrates privilege into the policy mechanism.

How does "moving data around a system" require root privileges?  Why  
should it?  Admittedly, moving data from "TopSecret" to "Secret"  
requires a process labeled with a range including at least "S-TS"  
*and* with the MLS "read-to-clearance" attribute, but you can be as  
stingy with that attribute as you like.  That attribute is explicitly  
given its magic abilities in the mlsconstrain rules defined in the  
policy file itself, so it's also possible to do information flow  
analysis on it.

> Smack does not. Smack is designed to use traditional Linux  
> mechanisms for privilege.
>
>> Under Trusted Solaris and such we needed all sorts of dirty  
>> privilege hacks to relabel the files consistently, but under  
>> SELinux the policy does all the relabeling for us, we don't need  
>> to do a thing.
>
> Yeah. Well, you won't like Smack then. Implicit relabeling of  
> processes and files does not happen. This is a major philisophical  
> difference.

Here's an argument for why implicit labeling is good and explicit  
labeling is bad:  If your process wants to label things explicitly it  
needs special privileges to do so, and it can abuse those  
privileges.  Under SELinux the labeling is implicit *AND* the  
transitions are entirely within the policy.  This means that you can  
do information flow analysis (as I described above) and it *ALSO*  
means that the program cannot possibly "abuse" its privileges because  
it has none.  When httpd creates a file in its log directory that  
file is created with httpd_log_t and it is limited to being able to  
append to the file *only*.  So when your apache gets compromised, the  
attacker has NO WAY to modify the logs, and you can prove this with a  
60-second study of the policy.  In fact, on my companies productions  
systems I can *PROVE* that the only way to get audit data out of the  
system is via a local TTY by interacting with  
system_u:object_r:local_login_t:SystemLow-SystemHigh to log in with a  
process of someluser:auditreview_r:auditreview_t:SystemHigh, which  
may read the audit files, or  
otherluser:auditadmin_r:auditadmin_t:SystemHigh, which may read and  
delete the audit files.  I can even prove that no process on the  
system is allowed to modify the files after they are created, barring  
a kernel-level vulnerability.

So the implicit labeling of files actually restricts every process  
*FURTHER*.  They no longer have even an inkling of a choice about  
file labeling, and that's a GOOD thing.  The only remaining extension  
we need to really thoroughly lock down our systems is to allow last- 
path-component matching in type-transitions and allow rules (EG:   
When "vipw" creates a file named "passwd" in an "etc_t" directory, it  
is automatically labeled "etc_passwd_t")  From what I understand  
Stephen Smalley and others are thinking that over even now.  I'll do  
it myself as soon as I get time at work beyond prepping systems for  
shipping to clients if they haven't finished it by them.

Cheers,
Kyle Moffett

