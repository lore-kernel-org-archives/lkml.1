Return-Path: <linux-kernel-owner+w=401wt.eu-S1756543AbXHVDnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543AbXHVDnb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 23:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754775AbXHVDnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 23:43:21 -0400
Received: from smtpout.mac.com ([17.250.248.185]:59220 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754754AbXHVDnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 23:43:19 -0400
In-Reply-To: <583405.53562.qm@web36609.mail.mud.yahoo.com>
References: <583405.53562.qm@web36609.mail.mud.yahoo.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <358B80A7-A00F-4E89-834B-0F7038602AE9@mac.com>
Cc: Valdis.Kletnieks@vt.edu, Pavel Machek <pavel@ucw.cz>,
       linux-security-module@vger.kernel.org,
       LKML Kernel <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [PATCH] Smack: Simplified Mandatory Access Control Kernel
Date: Tue, 21 Aug 2007 23:43:08 -0400
To: casey@schaufler-ca.com
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 21, 2007, at 11:50:48, Casey Schaufler wrote:
> --- Kyle Moffett <mrmacman_g4@mac.com> wrote:
>> Well, in this case the "box" I want to secure will eventually be  
>> running multi-user X on a multi-level-with-IPsec network.  For  
>> that kind of protection profile, there is presently no substitute  
>> for SELinux with some X11 patches.  AppArmor certainly doesn't  
>> meet the confidentiality requirements (no data labelling), and  
>> SMACK has no way of doing the very tight per-syscall security  
>> requirements we have to meet.
>
> And what requirements would those be? Seriously, I've done Common  
> Criteria and TCSEC evaluations on systems with less flexibility and  
> granularity than Smack that included X, NFSv3, NIS, clusters, and  
> all sorts of spiffy stuff.

These are requirements more of the "give the client warm fuzzies".   
On the other hand, when designing a box that could theoretically be  
run on a semi-public unclassified network and yet still be safe  
enough to run classified data over IPsec links, you want to give the  
client all the warm fuzzies they ask for and more.


> I mean, if the requirement is anything short of "runs SELinux" I  
> have good reason to believe that a Smack based system is up to it.

"up to it", yes, but I think you'll find that beyond the simplest  
policies, an SELinux policy that properly uses the SELinux  
infrastructure will be much shorter than the equivalent SMACK policy,  
not even including all the things that SELinux does and SMACK doesn't.


>> I didn't make this clear initially but that is the kind of system  
>> I'm talking about wanting to secure some 50 million lines of code on.
>
> Cool. SELinux provides one approach to dealing with that, and the  
> huge multiuser general purpose machine chuck full of legacy  
> software hits the SELinux sweet spot.

Well, given that 99.9% of the systems people are really concerned  
about security on are multi-user general-purpose machines chuck full  
of legacy software, that seems to work just fine.  If it's a single- 
user box then you don't even need MAC, just a firewall, a good locked  
rack/case/keyboard/etc, and decent physical security.  If it's  
entirely custom-controlled software then you can just implement the  
"MAC" entirely in your own software.  "General-purpose" vs "special- 
purpose" is debatable, so I'll just leave that one lie.

Replying to another email:
>> but you written it in wrong language. You written it in C, while  
>> you should have written it in SELinux policy language (and your  
>> favourite scripting language as frontend).
>
> I have often marvelled at the notion of a simplification layer.  I  
> believe that you build complex things on top of simple things, not  
> the other way around.

There is no "one answer" to this question in software development.   
Generally you prioritize things based on maximizing maintainability  
and speed and minimizing code, bugs, and complexity.  Those are often  
both conflicting and in agreement.  Here are a few common examples of  
simple-thing-on-complex-thing:
   *  pthreads on top of clone()
   *  open(some_string) on top of all the complex VFS machinery
   *  "netcat" on top of the vast Linux network stack including  
support for arbitrary packet filtering and transformation.

In addition, "simple" is undesirable if it makes the implementation  
less generic for no good reason.  Would you want to use the "simple"  
MS Windows disk-drive model under Linux?  Every disk is its own  
letter and has its files under it.  Oh, you wanted to mount a  
filesystem over C:\tmp?  Sorry, we don't support that, too bad.   
Under Linux we have a very flexible and powerful VFS which lets you  
do very crazy things, and then for the user's convenience we have  
various "simple" interfaces (like Gnome/KDE/XFCE).

Software development is very much about finding the Right Model(TM)  
to underlie the system, and then building any simplifications-to-the- 
user on top of the very simple model.

Look at the SELinux model again; it has the following things:
   (A) Labels on almost-all user-visible kernel objects
   (B) Individual access rules for almost every operation on those  
objects
   (C) "Transition" rules to set the label on newly created objects.
   (D) Fundamental "constraints" which enforce hard limits on what  
may be permitted with "allow" rules

 From a fundamental standpoint it's harder to get much simpler than  
that.  On top of that model, we also have a bit of additional  
*flexibility* for MLS/RBAC, although that flexibility may be ignored  
completely.
   (1) You can define "users" which may only assume some "roles"
   (2) You can define "roles" may only run in some "types"
   (3) There's a simple way of declaring multiple "levels" and  
"dominance".

So you see, SELinux is a pretty fundamental description of the  
degrees of flexibility needed to secure everything.  That kind of  
FUNDAMENTAL description is what belongs in the kernel.  Anything else  
can and should be built on top with better libraries and/or user  
interfaces.

As for the script, I'm partway through debugging it but my time is  
all chewed up with other stuff now, so it may take me an extra couple  
days.

Cheers,
Kyle Moffett



