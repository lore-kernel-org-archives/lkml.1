Return-Path: <linux-kernel-owner+w=401wt.eu-S1762807AbXHKVBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762807AbXHKVBW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 17:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757700AbXHKVBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 17:01:13 -0400
Received: from web36611.mail.mud.yahoo.com ([209.191.85.28]:21791 "HELO
	web36611.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756126AbXHKVBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 17:01:11 -0400
X-YMail-OSG: PtawvTAVM1nQBTSHA2SJaHT6Kl3javxiYAgf4SkzsT.nl6RPBseEvMXA_ilTReJMnoR.fDPX6A--
X-RocketYMMF: rancidfat
Date: Sat, 11 Aug 2007 14:01:09 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH] Smack: Simplified Mandatory Access Control Kernel
To: Kyle Moffett <mrmacman_g4@mac.com>, casey@schaufler-ca.com
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@osdl.org, torvalds@osdl.org
In-Reply-To: <55459F0C-3B27-4C26-9308-B2775C512398@mac.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <976827.87061.qm@web36611.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Kyle Moffett <mrmacman_g4@mac.com> wrote:

> On Aug 11, 2007, at 13:57:31, Casey Schaufler wrote:
> > Smack implements mandatory access control (MAC) using labels  
> > attached to tasks and data containers, including files, SVIPC, and  
> > other tasks. Smack is a kernel based scheme that requires an  
> > absolute minimum of application support and a very small amount of  
> > configuration data.
> 
> For starters, we would appear to already have a very capable  
> labelling system 

I am not going to argue that SELinux is not a capable
labelling system. SELinux is a fine implementation of
of Type Enforcement.

> which can do *all* of this, completely and without  
> exceptions,

That's quite a strong assertion.

> in a much more flexible way.

Indeed, SELinux provides tremendous flexibility.

> Admittedly it's more complicated,

Yes, it is.

> but one does have to have complexity in order to handle  
> everything from CD burning in X, to Apache daemons, to only allowing  
> Top-Secret-level logins over the IPsec tunnel on the Top Secret  
> network, etc.

I do not agree with you. The MLS systems from the 1990's could do all
that (except the IPsec tunnel, the function of which was preceeded by
TSIG interfaces and protocols) without the complexity required by
SELinux policy.

> Do you see any particular reason this couldn't be  
> implemented as a very *very* simplified SELinux wrapper?

I would be interested to see the attempt made, but I have no interest
in doing so myself. I think that some of the reasons will come out
as we progress through your examples.

> For  
> example, this set of rules basically defines your described "read-vs- 
> write-vs-exec" policy as best I can figure out:
> 
> user uu roles rr;
> 
> role rr types { star floor hat huh };
> 
> define(`r',`
> allow $1 $2:file { read getattr };
> allow $1 $2:socket { read getattr getopt recvfrom recv_msg };
> allow $1 $2:ipc { getattr read associate unix_read };
> ## List of more "read" allow rules for different types of objects... ##
> ')

It would be instructive for those who are not well versed in the
nuances of SELinux policy if you actually spelled out the whole
thing, rather than using "## and more ##". Part of the point of
Smack is the makeup of the full list that would be required here.

> define(`w',`
> allow $1 $2:file { ioctl write create setattr lock append unlink link  
> rename swapon quotaon mounton };
> allow $1 $2:socket { ioctl write create setattr lock append bind  
> connect listen accept setopt shutdown sendto send_msg name_bind };
> allow $1 $2:ipc { create destroy setattr write unix_write };
> ## List of more "write" allow rules for different types of objects... ##
> ')

Again, I suggest you present the complete list.

> define(`x',`
> allow $1 $2:file { execute };
> allow $1 $2:dir { search };
> ## List of more "execute" allow rules for different types of  
> objects... ##
> ')

Here too. 

> And now to describe these rules:
> 
> > Smack defines and uses these labels:
> >   "*" - pronounced "star"
> >   "_" - pronounced "floor"
> >   "^" - pronounced "hat"
> >   "?" - pronounced "huh"
> >
> > The access rules enforced by Smack are, in order:
> >
> > 1. Any access requested by a task labeled "*" is denied.
> > 2. A read or execute access requested by a task labeled "^"
> >    is permitted.
> > 3. A read or execute access requested on an object labeled "_"
> >    is permitted.
> > 4. Any access requested on an object labeled "*" is permitted.
> > 5. Any access requested by a task on an object with the same
> >    label is permitted.
> > 6. Any access requested that is explicitly defined in the loaded
> >    rule set is permitted.
> > 7. Any other access is denied.
> 
> ## These are calls to the above macros which plug in the necessary  
> arguments
> r(hat, {*})
> x(hat, {*})
> r(~{star}, floor)
> x(~{star}, floor)
> r(~{star}, star)
> w(~{star}, star)
> x(~{star}, star)
> r(~{star}, self)
> w(~{star}, self)
> x(~{star}, self)
> ## Include your "loaded rule set" here ##

What would that look like?


> > Rules may be explicitly defined by writing subject,object,access  
> > triples to /smack/load.
> 
> Maybe worth a little utility to convert a file full of  
> "subject,object,access" triples to an appropriate SELinux policy  
> would be appropriate?

Maybe. It would at least be educational for comparisons by those
looking to choose between the schemes.
 
> > Smack rule sets can be easily defined that describe Bell&LaPadula  
> > sensitivity, Biba integrity, and a variety of interesting  
> > configurations. Smack rule sets can be modified on the fly to  
> > accomodate changes in the operating environment or even the time of  
> > day.
> 
> SELinux can do this as well.  It even includes support for  
> conditional policy:
> 
> bool foo_can_do_logging true;
> if (foo_can_do_logging) {
> 	allow foo_t foo_log_t:file { create read getattr append };
> }

You have to build the booleans into the policy in advance.

> The SELinux tools also have support for policy modules, so you can  
> extend the policy without modifying the base system.

And that's a good thing, but you still have to compile and reload
your policy, and maybe relabel you filesystem when you do so.

> Plus the stuff has been very heavily tested

It does have the advantage of maturity.

> and even supports X (as soon as the beta  
> X code gets improved and merged in the upstream X.org codebase).

The MLS systems of the 1990s did that, and having done MLS X
myself I can assure you that although it has an interesting
set of issues to address (object definition in particular)
and a programming model that is very different from the kernel
it's not that big a deal.

> > Some practical use cases:
> >
> > Hierarchical levels. The less common of the two usual uses for MLS  
> > systems is to define hierarchical levels, often unclassified,  
> > confidential, secret, and so on. To set up smack to support this,  
> > these rules could be defined:
> >
> >    C        Unclass rx
> >    S        C       rx
> >    S        Unclass rx
> >    TS       S       rx
> >    TS       C       rx
> >    TS       Unclass rx
> >
> > A TS process can read S, C, and Unclass data, but cannot write it.
> > An S process can read C and Unclass. Note that specifying that
> > TS can read S and S can read C does not imply TS can read C, it
> > has to be explicitly stated.
> 
> The big problem here is the duplication.  Say you have a locked-down  
> Apache configuration and you want to run 2 apache processes, one at  
> Secret and one at Top-Secret.  Under your model you have to copy- 
> paste the policy and make sure to apply fixes/changes to both  
> places.

I'm sorry, but I don't understand your point at all.

>     Under SELinux, you can have processes as:
>    system_u:system_r:httpd_t:Secret:UFOSightings,AlienDissection
>    system_u:system_r:httpd_t:TopSecret:NukeTests
> 
> They can only read and write objects for which multiple conditions  
> are true:  First, the object must match the Bell-Padula model with  
> respect to the sensitivities and categories  
> ("Secret:UFOSightings,AlienDissection", etc) *and* it must also be  
> objects that httpd_t is allowed to read/write.  That also includes  
> network traffic, and your firewall can appropriately label data over  
> a given IPsec link as one classification level while data over the  
> raw network is labeled as another.  Oh, and you can tweak the MLS  
> constraints of the Bell-Padula model as necessary too.

Ok.

> > Another case that I especially like:
> >
> >     SatData Guard   w
> >     Guard   Publish w
> >
> > A program running with the Guard label opens a UDP socket and  
> > accepts messages sent by a program running with a SatData label.   
> > The Guard program inspects the message to ensure it is wholesome  
> > and if it is sends it to a program running with the Publish label.   
> > This program then puts the information passed in an appropriate  
> > place. Note that the Guard program cannot write to a Publish file  
> > system object because file system semanitic require read aswell as  
> > write.
> 
> This is exactly what my company does, but the ability to restrict  
> *exactly* what mechanisms are used is important.  You restrict  
> against file-system access implicitly, whereas SELinux does it  
> explicitly:
>    allow foo_t foo_sock_t:socket { .... };
> versus:
>    allow foo_t foo_log_t:file { ... };
> 
> With SELinux you can also allow your program to create files labelled  
> as "log files" in one directory in one type and "transfer files" in  
> another directory in a completely different type.

I would be very interested to see the policy that your guard box uses.
 
> > The four cases (categories, levels, mutual read, guardbox) here are  
> > all quite real, and problems I've been asked to solve over the  
> > years. The first two are easy to do with traditonal MLS systems  
> > while the last two you can't without invoking privilege, at least  
> > for a while.
> 
> I'm proud to say that the software of the company I work for does not  
> need any extra privilege at all (aside from binding to ports <1024)  
> to run under SELinux with strict MLS.

That is an aspect of SELinux that has its dark side. While you
are not explicitly violating a policy (e.g. requiring a capability)
you are doing things that some of us would argue ought to require
a capability. SELinux integrates privilege into the policy mechanism.

Smack does not. Smack is designed to use traditional Linux
mechanisms for privilege. 

> Under Trusted Solaris and such  
> we needed all sorts of dirty privilege hacks to relabel the files  
> consistently, but under SELinux the policy does all the relabeling  
> for us, we don't need to do a thing.

Yeah. Well, you won't like Smack then. Implicit relabeling of
processes and files does not happen. This is a major philisophical
difference.


Casey Schaufler
casey@schaufler-ca.com
