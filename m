Return-Path: <linux-kernel-owner+w=401wt.eu-S1753259AbXHLEcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259AbXHLEcr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 00:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751030AbXHLEcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 00:32:36 -0400
Received: from smtpout.mac.com ([17.250.248.175]:53320 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845AbXHLEce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 00:32:34 -0400
In-Reply-To: <586955.79589.qm@web36615.mail.mud.yahoo.com>
References: <586955.79589.qm@web36615.mail.mud.yahoo.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <DA8BD064-80B9-402B-9C99-2AAA0EB0FC22@mac.com>
Cc: linux-security-module@vger.kernel.org,
       LKML Kernel <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [PATCH] Smack: Simplified Mandatory Access Control Kernel
Date: Sun, 12 Aug 2007 00:32:29 -0400
To: casey@schaufler-ca.com
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus and AKPM pulled from CC, I'm sure they're bored to tears by  
now ;-).

On Aug 11, 2007, at 21:21:55, Casey Schaufler wrote:
> --- Kyle Moffett <mrmacman_g4@mac.com> wrote:
>> On Aug 11, 2007, at 17:01:09, Casey Schaufler wrote:
>>> It would be instructive for those who are not well versed in the  
>>> nuances of SELinux policy if you actually spelled out the whole  
>>> thing, rather than using "## and more ##". Part of the point of  
>>> Smack is the makeup of the full list that would be required here.
>>
>> Well, yes, but how exactly do you define "read", "write", and  
>> "execute" for the full list of SELinux object classes found here:   
>> http://www.tresys.com/selinux/obj_perms_help.html
>
> Smack is designed to treat objects as consistantly as is  
> reasonable.  The list of object classes defined by SELinux is great  
> for a system designed to treat accesses with the highest possible  
> granularity. This is not a design goal for Smack.
>
>> I was considering compiling the complete list, but such an  
>> exercise would take me at least an hour to do properly and which  
>> categories individual permissions should be placed in could be  
>> argued for weeks.
>
> I will be happy to consider your arguement when you are willing to  
> present the complete argument.

Here's my complete argument:

Regardless of how you categorize "read", "write", "execute", and  
"doesnt-need-protection" in your policy language, I can write an  
SELinux policy and a list of labels which expresses that policy.   
Moreover, without too much work I can probably write a Perl script to  
do it for you.  On the other hand I can only do that if you tell me  
exactly how you want to categorize those things, though.  In my  
personal opinion they cannot be reasonably categorized without  
breaking all sorts of tools or leaving gaping holes; precisely the  
reason that SELinux uses such a fine-grained list.

>> Specifically, do you classify the bind() syscall as a "read" or a  
>> "write" operation.
>
> Neither. Bind attaches a name (port number) to a socket (which is a  
> data structure that is part of your process) from a global  
> namespace.  No objects are involved, hence no accesses.

So "bind()" doesn't present a security hole at all and any program  
may bind to any port?  Sounds fun!  I'm sure lots of crackers would  
love to get ahold of an account on such a web-server; what havoc they  
could wreak!  Even the <1024 restriction doesn't sufficiently limit  
things these days, as many critical services use ports >=1024.

>>>> And now to describe these rules:
>>>>
>>>>> Smack defines and uses these labels:
>>>>>   "*" - pronounced "star"
>>>>>   "_" - pronounced "floor"
>>>>>   "^" - pronounced "hat"
>>>>>   "?" - pronounced "huh"
>>>>>
>>>>> The access rules enforced by Smack are, in order:
>>>>>
>>>>> 1. Any access requested by a task labeled "*" is denied.
>>>>> 2. A read or execute access requested by a task labeled "^" is  
>>>>> permitted.
>>>>> 3. A read or execute access requested on an object labeled "_"  
>>>>> is permitted.
>>>>> 4. Any access requested on an object labeled "*" is permitted.
>>>>> 5. Any access requested by a task on an object with the same  
>>>>> label is permitted.
>>>>> 6. Any access requested that is explicitly defined in the  
>>>>> loaded rule set is permitted.
>>>>> 7. Any other access is denied.
>>>>
>>>> ## These are calls to the above macros which plug in the  
>>>> necessary arguments
>>>> r(hat, {*})
>>>> x(hat, {*})
>>>> r(~{star}, floor)
>>>> x(~{star}, floor)
>>>> r(~{star}, star)
>>>> w(~{star}, star)
>>>> x(~{star}, star)
>>>> r(~{star}, self)
>>>> w(~{star}, self)
>>>> x(~{star}, self)
>>>> ## Include your "loaded rule set" here ##
>>>
>>> What would that look like?
>>
>> The same kind of thing as the r, x, and w above, with occasional  
>> "type my_type_t; role rr types my_type_t;" to declare a type  
>> before use.  If you wanted to add support for attributes which  
>> apply to multiple types, you could put those after a comma after  
>> the "type my_type_t" portion of the type declaration.
>
> Well, I'm interested in seeing the actual code, not "the same kind  
> of thing" as arguement.

Ok, you want sample policy to match your "MLS" sample?  For  
convenience here's one more macro:
define(`rx',`r(`$1',`$2') x(`$1',`$2')')

type unclass;
type c;
type s;
type ts;
rx(c, unclass)
rx(s, c)
rx(s, unclass)
rx(ts, s)
rx(ts, c)
rx(ts, unclass)

In case you don't have the policy you typed into your email, it looks  
almost identical with a few exceptions for slightly modified syntax:
> C        Unclass rx
> S        C       rx
> S        Unclass rx
> TS       S       rx
> TS       C       rx
> TS       Unclass rx

>>>>> Smack rule sets can be easily defined that describe  
>>>>> Bell&LaPadula sensitivity, Biba integrity, and a variety of  
>>>>> interesting configurations. Smack rule sets can be modified on  
>>>>> the fly to accomodate changes in the operating environment or  
>>>>> even the time of day.
>>>>
>>>> SELinux can do this as well.  It even includes support for  
>>>> conditional policy:
>>>>
>>>> bool foo_can_do_logging true;
>>>> if (foo_can_do_logging) {
>>>> 	allow foo_t foo_log_t:file { create read getattr append };
>>>> }
>>>
>>> You have to build the booleans into the policy in advance.
>>
>> Well, yes, but a policy which completely ignores
>
> This sentence no verb.

Whoops, I think I must have smashed the delete key or something while  
sending.  Here's the paragraphs which got elided:

Well, yes, but a policy which completely ignores future expandability  
can't be expanded upon regardless.  It would also be very hard to add  
new policy without a lot of duplication under your system.  On the  
other hand, with SELinux you can very easily add attribute-based  
policy so adding new capabilities is as simple as sticking existing  
attributes on newly defined types.  For example:

type my_log_t, file_type, log_file;
type my_log_daemon, daemon;

Right there I just gave permission for the logrotate to recycle files  
labelled my_log_t, which the sysadmin and audit admin can also read  
(and the audit admin can delete).  I also gave permission for my  
daemon to send SIGCHLD to init, and for init/initscripts to send it a  
SIGTERM/SIGQUIT.  All without writing a SINGLE policy rule.   
Basically all of those existing behaviors are found in allow rules  
built on the "file_type", "log_file", and "daemon" attributes.

>>>> The SELinux tools also have support for policy modules, so you  
>>>> can extend the policy without modifying the base system.
>>>
>>> And that's a good thing, but you still have to compile and reload  
>>> your policy, and maybe relabel you filesystem when you do so.
>>
>> What exactly prevents you from having to "reload" and "relabel the  
>> filesystem" when using your system?
>
> Good question. First, changing Smack rules is no big deal. They can  
> be added or changed one by one as required while the system is  
> running, and there are uses that exploit that. One example is to  
> put the label "Game" on certain programs and:
>
>    at 8:00am "Worker Game no"
>    at 5:00pm "Worker Game x"
>
> Thus Worker processes can access Game files only during off hours.

This is fundamentally broken:  First of all we have no fd revoke  
support yet, so all a user has to do is start the game at 5:05pm just  
before they leave, then leave it running in the background during the  
day for them to play at leisure.  Secondly, you can already do the  
same thing with DAC and a PAM groups-from-time-of-day module, I don't  
see why such a thing is special enough to need MAC.  Thirdly, I could  
do exactly the same thing with an SELinux boolean and a cronjob (once  
we get proper revoke support):

## Rule to allow cron to tweak the "can_play_games" boolean value
if (can_play_games) {
	## Insert game-playing allow rules here
}

Then in cron:
0  8 * * * root setsebool can_play_games false
0 17 * * * root setsebool can_play_games true


> As far as relabeling the file system goes, the rules apply to  
> processes and objects, not to programs. The label on a program  
> describes who can access it, it will run with the label of the  
> process that exec's it. A change in the rules does not require a  
> change to the labels on the file system for things to work  
> according to the rules of engagement.

By this logic, every program will always have the same label, unless  
you recode every program to explicitly change it when it starts;  
precisely the thing that the SELinux type transitions were designed  
to avoid.

>> When you change the meaning of new types, you clearly would need  
>> to first reload the policy then relaunch programs or relabel files  
>> to take advantage of the new types, otherwise they would be  
>> categorically ignored by the system.
>
> I'm sorry, but again, I don't know what you mean by "changing the  
> meaning of new types".

Oh, say something like "Oh, drat, I wanted this daemon to run as some  
other type".  Unless you relabel the files and relaunch the daemon  
the system will have no idea how the system will change.  And if you  
let arbitrary root processes relabel things on the fly then you've  
lost all the security advantages to a MAC system.

> I think you may be making assumptions about the behavior of Smack  
> based on what SELinux does that don't hold. I hesitate to call a  
> Smack rule list a language.

Well, it's a syntactic construction to describe an idea, ergo it's a  
language.

>> I suspect you'd get shot down instantly if you tried to stuff the  
>> policy compiler in the kernel too.
>
> Smack rule specifications are really really basic, just the subject  
> label, the object label, and the access permitted.  There are no  
> wildcards, no expressions (regular or otherwise) and they apply to  
> all objects. Only the labels are taken into account on an access  
> check, not the userid, the current directory, the time of day, or  
> the binary involved. Oh, there is a capability to override the  
> check, but that's just basic Linux behavior and I wouldn't want to  
> muck that up.

I think you may be making assumptions about the behaviour of SELinux  
based on what other OSes do which don't hold:

(a)  SELinux does not care about user id, current directory, time of  
day, etc.  It cares solely about 3 things:
the Subject, the Object, and the Action.  For example, if an init  
script attempts to execute the apache binary then SELinux gets the  
following data for parameters:   
subject="system_u:system_r:initrc_t:SystemLow-SystemHigh"  
object="system_u:object_r:httpd_exec_t:SystemLow" action="file- 
 >execute".

(b)  SELinux does NOT have a capability which overrides it.  If you  
want to do something that the policy categorically does not allow,  
you have 2 choices:  change the policy or disable SELinux.  You can  
also use a policy which disables both of those options

>> Ok, let's say you want to use your model to restrict Apache and  
>> MySQL running at the same classification level.  You have to  
>> define combined labels, such as:
>>    S_Apache   S_MySQL rx
>>    [...]
>>
>> Now if you want to run an apache/mysql pair at TS, you have to  
>> copy all those rules and substitute "S_" with "TS_".
>
> There is only one rule to copy. I think most sysadmins can insert a  
> "T" with sufficient confidence that this is not going to be a major  
> issue.

Which means that for every new category/level-alteration you have to  
modify a significant portion of your policy.  With SELinux I get to  
either add 2 lines to a local policy module or run a couple  
"semanage" commands.

>> With SELinux, you don't have to do anything other than define new  
>> labels for the secret-web-docs and the top-secret-web-docs folders,
>
> Which if you actually write out the change is going to require more  
> than inserting a "T".

Umm, how so?  Any of these will work:
   * The security administrator creates my /www_S and /www_TS  
folders, labels them, and remembers not to run "restorecon" on those  
folders.

   * The security administrator loads a local policy module with just  
an fc file containing:
       /www_S(/.*)?  system_u:object_r:web_docs_t:Secret
       /www_TS(/.*)? system_u:object_r:web_docs_t:TopSecret

   * The security administrator runs these commands:
       semanage fcontext -a -r Secret-Secret       -s system_u -t  
web_docs_t '/www_S(/.*)?'
       semanage fcontext -a -r TopSecret-TopSecret -s system_u -t  
web_docs_t '/www_TS(/.*)?'

>>>> This is exactly what my company does, but the ability to  
>>>> restrict *exactly* what mechanisms are used is important.  You  
>>>> restrict against file-system access implicitly, whereas SELinux  
>>>> does it explicitly:
>>>>    allow foo_t foo_sock_t:socket { .... };
>>>> versus:
>>>>    allow foo_t foo_log_t:file { ... };
>>>>
>>>> With SELinux you can also allow your program to create files  
>>>> labelled as "log files" in one directory in one type and  
>>>> "transfer files" in another directory in a completely different  
>>>> type.
>>>
>>> I would be very interested to see the policy that your guard box  
>>> uses.
>>
>> Unfortunately that's still considered company-proprietary  
>> information at the moment, although that's likely to change at  
>> some point in the future.  We're not all that different from the  
>> httpd policies and similar stuff found in the SELinux "refpolicy"  
>> available from tresys' website.
>
> I think there's a rule against using proprietary information that  
> you can't share in a friendly debate on the LKML.

Well, you were the one who asked.  It's mostly irrelevant to the  
discussion since the *same* kind of stuff is found in almost every  
module in the tresys-distributed refpolicy.

>>>> I'm proud to say that the software of the company I work for  
>>>> does not need any extra privilege at all (aside from binding to  
>>>> ports <1024) to run under SELinux with strict MLS.
>>>
>>> That is an aspect of SELinux that has its dark side. While you  
>>> are not explicitly violating a policy (e.g. requiring a  
>>> capability) you are doing things that some of us would argue  
>>> ought to require a capability. SELinux integrates privilege into  
>>> the policy mechanism.
>>
>> How does "moving data around a system" require root privileges?
>
> Hmm. You snuck the adjective "root" into the discussion when it  
> wasn't there before.

Ok, fine, how does "moving data around a system" require anything  
more than bog-standard user-level privileges?  Normal users under  
Linux are not permitted to change "security.*" attributes at all, but  
they may bind to sockets, etc.  You can define a "capability" which  
lets you do all that, but then you're just blindly giving processes  
more privileges than they need to complete an operation.  Why should  
you get the "rename all files" priv when all you need is "Make my log  
files get $LABEL when I put them in /var/log/mydaemon/"?


>> Why should it?  Admittedly, moving data from "TopSecret" to  
>> "Secret" requires a process labeled with a range including at  
>> least "S-TS"  *and* with the MLS "read-to-clearance" attribute,  
>> but you can be as stingy with that attribute as you like.
>
> Yup. And plenty of people like you think that is really spiffy.

Please explain why you think it isn't?


>> That attribute is explicitly given its magic abilities in the  
>> mlsconstrain rules defined in the policy file itself, so it's also  
>> possible to do information flow analysis on it.
>
> I much prefer strait-up process capabilities to magic attributes.   
> Call me old fashioned if you want to.

You can call them "process capabilities" or "magic attributes",  
they're the same thing, just more fine-grained.  Instead of (Note: r1  
== subject role, r2 == target role, t2 == target type):
   mlsconstrain process transition ( (r1 == r2) || (t1 ==  
i_am_a_role_changing_capability) )

you have (Note: t1 == subject type):
   mlsconstrain process transition ( (r1 == r2) || (r1 == system_r &&  
t1 == i_am_a_login_process && t2 == i_am_a_user_entrypoint) )

The latter is like the former, except instead of one single ultimate  
"change-any-role" capability, you have a capability which allows a  
system login process to change roles *ONLY* if it's also changing to  
a user entrypoint.  Please tell me which you think is more secure.


>> Under SELinux the labeling is implicit *AND* the transitions are  
>> entirely within the policy.  This means that you can do  
>> information flow analysis (as I described above) and it *ALSO*  
>> means that the program cannot possibly "abuse" its privileges  
>> because it has none.
>
> It means you have not only the program to worry about being written  
> correctly, but the policy as well.

If your security policy sucks then you might as well not have MAC at  
all.  At least under SELinux the absolute worst possible case is that  
you always fall back to DAC-based security.

>> So the implicit labeling of files actually restricts every process  
>> *FURTHER*.  They no longer have even an inkling of a choice about  
>> file labeling, and that's a GOOD thing.
>
> That's true about Smack, you know. The process has no choice about  
> the label that the files get.

So how do you selectively label files based on criteria such as  
"where did I get put"?  How do you distinguish between a "log file"  
which is create-and-append-only, a "database file" which I can modify  
however I want to, and a "unix socket" which I can bind in /var/run  
and get connections from user processes?

>> The only remaining extension we need to really thoroughly lock  
>> down our systems is to allow last-path-component matching in type- 
>> transitions and allow rules (EG: When "vipw" creates a file named  
>> "passwd" in an "etc_t" directory, it is automatically labeled  
>> "etc_passwd_t")
>
> Hey, and AppArmor does that today!

No, AppArmor doesn't.  It says: "/usr/sbin/httpd may not access /etc/ 
shadow", for example, whereas SELinux with the proposed extension  
says: "Only the 'passwd' program or 'vipw' by a sysadmin may modify  
*ANY* password shadow file, and if I create a "shadow" file in *ANY*  
etc_t directory then it's automatically a shadow file.  The  
difference is also in the treatment of hard-links.  Under SELinux I  
can guarantee that the data in the shadow_t file is secure, no matter  
where somebody manages to get it linked to, and in addition I can  
guarantee that nobody can spoof me and make me create the shadow file  
elsewhere or with the wrong label.

>> From what I understand Stephen Smalley and others are thinking  
>> that over even now.  I'll do it myself as soon as I get time at  
>> work beyond prepping systems for shipping to clients if they  
>> haven't finished it by them.
>>
>
> You might want to review the archives on how that experiment ended  
> up before saying much more about it.

Hmm, I haven't seen anything pass LKML and digging in the  
lsm@vger.kernel.org archives (as well as google) doesn't seem to be  
turning up anything even vaguely related.  Do you happen to have the  
link handy?

> Thank you for your comments.    I hope that I have made the  
> behavior and value of Smack clearer in responding to them.

You're welcome.  I endeavor to poke my nose into every little LSM- 
related corner in the kernel, this one included.

Cheers,
Kyle Moffett

