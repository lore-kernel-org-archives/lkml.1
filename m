Return-Path: <linux-kernel-owner+w=401wt.eu-S1761297AbXFIUos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761297AbXFIUos (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 16:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760032AbXFIUoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 16:44:38 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:46972
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760000AbXFIUog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 16:44:36 -0400
Date: Sat, 9 Jun 2007 13:43:20 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Kyle Moffett <mrmacman_g4@mac.com>
cc: Greg KH <greg@kroah.com>, Andreas Gruenbacher <agruen@suse.de>,
       Stephen Smalley <sds@tycho.nsa.gov>, Pavel Machek <pavel@ucw.cz>,
       jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
 pathname matching
In-Reply-To: <D5D584BB-21D0-4BBA-B70E-FCBA07960646@mac.com>
Message-ID: <Pine.LNX.4.64.0706091307590.6313@asgard.lang.hm>
References: <20070514110607.549397248@suse.de> <200706042303.28785.agruen@suse.de>
 <1181136386.3699.70.camel@moss-spartans.epoch.ncsc.mil> <200706090003.57722.agruen@suse.de>
 <20070609001703.GA17644@kroah.com> <Pine.LNX.4.64.0706082207260.6675@asgard.lang.hm>
 <23C85F2D-9715-4C9B-BD4D-B7186A71F33D@mac.com> <Pine.LNX.4.64.0706090930380.6313@asgard.lang.hm>
 <DA41D175-3EA3-4ED9-B532-2AA577690980@mac.com> <Pine.LNX.4.64.0706091028540.6313@asgard.lang.hm>
 <D5D584BB-21D0-4BBA-B70E-FCBA07960646@mac.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Jun 2007, Kyle Moffett wrote:

> On Jun 09, 2007, at 13:32:05, david@lang.hm wrote:
>> On Sat, 9 Jun 2007, Kyle Moffett wrote:
>> > On Jun 09, 2007, at 12:46:40, david@lang.hm wrote:
>> > > so as I understand this with SELinux you will have lots of labels 
>> > > around your system (more as you lock down the system more) you need to 
>> > > define policy so that your unrestricted users must have access to every 
>> > > label, and every time you create a new label you need to go back to all 
>> > > your policies to see if the new label needs to be allowed from that 
>> > > policy
>> > 
>> > Actually, it's easier than that.  There are type attributes which may be 
>> > assigned to an arbitrary set of types, and each "type" field in an access 
>> > rule may use either a type or an attribute.  So you don't actually need 
>> > to modify existing rules when adding new types, you just add the 
>> > appropriate existing attributes to your new type.  For example, you could 
>> > set up a "logfile" attribute which allows logrotate to archive old 
>> > versions and allows audit-admin users to modify/delete them, then 
>> > whenever you need to add a new logfile you just declare the 
>> > "my_foo_log_t" type to have the "logfile" attribute.
>> 
>> isn't this just the flip side of the same problem?
>> 
>> every time you define a new attribute you need to go through all the files 
>> and decide if the new attribute needs to be given to that file.
>
> No you don't, you can add attributes to a type after-the-fact.  In concept 
> this problem is very similar to programming:  You have various documented 
> interfaces used by different policy files to interact with each other.  As 
> long as your policy files conform to the documented interfaces then you 
> *DONT* have to manually inspect each file because you can make basic 
> assumptions.  On the other hand, when you break that interface "contract" you 
> will get very unexpected results.  For the above example:
>
> My syslog policy file would create a "logfile" attribute and types for 
> "/var/log/auth/auth.log", "/var/log/kern/kern.log", and "/var/log/messages". 
> It would also create a "logdaemon" attribute which has automatic type 
> transitions to create files in different "/var/log/*" directories  Finally, 
> it would allow the syslogd type to create and append to its specific file 
> types for "auth.log", "kern.log", and "messages".
>
> My logrotate policy file would depend on the syslog policy and would declare 
> the logrotate daemon type as a "logdaemon", and additionally allow logrotate 
> to read, rename, append, and delete "logfile" types.  Since logrotate is a 
> "logdaemon", it already has the appropriate type transitions for new types.
>
> My samba policy file would depend on the syslog policy and would declare the 
> samba daemon type as a "logdaemon" and the "/var/log/samba/*" type as a 
> "logfile".  Then it would add a type transition rule so when "logdaemon" 
> creates new files in "samba_log_dir_t", they have the appropriate 
> "samba_log_t" label.  Finally, samba would allow itself to append to 
> "samba_log_t" files.

if you have your policy figured out and then go and apply it to 
applications then you are correct.

I'm talking about the situation where you start off by defining a policy 
for Samba, and then afterwords decide that you want to have seperate 
"logfile" and "logdaemon" type then you would need to go back and 
re-examine all the files to tell what needs to be labeled as what.

if you can do all the policy design in advance (and get it right) then 
SELinux is a great solution. if you don't have that time and have to do 
the policy incrementaly you will end up revisiting and revising your 
entire policy each time you go to add something.

> Note that now when "logrotate" runs and rotates files in /var/log/samba, it 
> will automatically create the new files with type "samba_log_t", even though 
> there are no *direct* associations between those types.  If the syslog policy 
> file was poorly written it could seriously adversely affect the security of 
> the system, but hopefully that's obvious :-D.  Policy development is _hard_, 
> it's a whole separate state-machine and pseudo-programming-language that 
> should mostly be left to security professionals or very experienced 
> developers/sysadmins.

I _am_ a security professional. I've been doing security sysadmin work on 
Linux for over a decade now. From your description I'm exactly the type of 
person you are saying should be figuring this out. So please back off of 
the 'this is hard, you should leave it to the professionals' line a 
little bit ;-)

if the AA policies can be compiled into SELinux policies that would work 
(currently they can't and many SELinux people oppose the features that 
would need to be added to make it possible) but the compile process leaves 
room for more bugs in an areas that's going to be hard to investigate. 
(This isn't a fault of SELinux, it's a common issue with compilers, the 
compiled 'thing' is designed to be machine friendly, not user friendly. it 
doesn't matte if it's compiling C into machine code or high-level firewall 
rules into iptables commands or AA policies into SELinux labels and 
policies). adding a complex intermediate layer does not nessasarily add 
security, but it definantly adds complication.

once SELinux has a way for a trusted user to edit a security sensitive 
file (via the process of creating a file and renameing it into place) 
without needing SELinux aware tools and have the result accepted as valid 
by the rest of the system then it becomes possible to implement an AA to 
SELinux policy compiler, but saying that AA should not be accepted becouse 
it's possible to modify SELinux and write such a compile with sufficant 
effort is not reasonable. While there are many cases where multiple ways 
of doing something are not allowed into the kernel (suspend/hibernate is 
an example) there are also cases where multiple ways of doing things are 
allowed, and the LSM hooks are in place explicitly to permit different 
types of security modules to use them.

David Lang
