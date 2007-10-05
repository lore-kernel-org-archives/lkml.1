Return-Path: <linux-kernel-owner+w=401wt.eu-S1758082AbXJEDFM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758082AbXJEDFM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 23:05:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753408AbXJEDE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 23:04:58 -0400
Received: from smtpoutm.mac.com ([17.148.16.77]:52836 "EHLO smtpoutm.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751537AbXJEDE4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 23:04:56 -0400
In-Reply-To: <m17im2pc7x.fsf@ebiederm.dsl.xmission.com>
References: <46FEEBD4.5050401@schaufler-ca.com> <20070930011618.ccb8351b.akpm@linux-foundation.org> <Xine.LNX.4.64.0710010146100.13671@us.intercode.com.au> <alpine.LFD.0.999.0710010803280.3579@woody.linux-foundation.org> <1191253239.7672.76.camel@moss-spartans.epoch.ncsc.mil> <alpine.LFD.0.999.0710010854120.3579@woody.linux-foundation.org> <4702B1D5.5050502@tmr.com> <alpine.LFD.0.999.0710021410470.3579@woody.linux-foundation.org> <4703126D.70703@tmr.com> <alpine.LFD.0.999.0710022050560.3579@woody.linux-foundation.org> <m17im2pc7x.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <15E46546-914A-4A1E-BB0B-642FDA17396B@mac.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Bill Davidsen <davidsen@tmr.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, casey@schaufler-ca.com,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Serge E. Hallyn" <serge@hallyn.com>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [PATCH] Version 3 (2.6.23-rc8) Smack: Simplified Mandatory Access Control Kernel
Date: Thu, 4 Oct 2007 23:04:08 -0400
To: "Eric W. Biederman" <ebiederm@xmission.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct 04, 2007, at 21:44:02, Eric W. Biederman wrote:
> What we want from the LSM is the ability to say -EPERM when we can  
> clearly articulate that we want to disallow something.

This sort of depends on perspective; typically with security  
infrastructure you actually want "... the ability to return success  
when we can clearly articulate that we want to *ALLOW* something".   
File permissions work this way; we don't have a list of forbidden  
users attached to each file, we have an owner, a group, and a mode  
representing positive permissions.  With that said in certain high- 
risk environments you need something even stronger that cannot be  
changed by the "owner" of the file, if we don't entirely trust them,

> SElinux is not all encompassing or it is generally incomprehensible  
> I don't know which.  Or someone long ago would have said a better  
> way to implement containers was with a selinux ruleset, here is a  
> selinux ruleset that does that.  Although it is completely possible  
> to implement all of the isolation with the existing LSM hooks as  
> Serge showed.

The difference between SELinux and containers is that SELinux (and  
LSM as a whole) returns -EPERM to operations outside the scope of the  
subject, whereas containers return -ENOENT (because it's not even in  
the same namespace).


> We also have in the kernel another parallel security mechanism (for  
> what is generally a different class of operations) that has been  
> quite successful, and different groups get along quite well, and  
> ordinary mortals can understand it.   The linux firewalling code.

Well, I wouldn't go so far as the "ordinary mortals can understand  
it" part; it's still pretty high on the obtuse-o-meter.


> The linux firewalling codes has hooks all throughout the networking  
> stack, just like the LSM has hooks all throughout the rest of linux  
> kernel.  There is a difference however.  The linux firewalling code  
> in addition to hooks has tables behind those hooks that it  
> consults. There is generic code to walk those tables and consult  
> with different kernel modules to decide if we should drop a  
> packet.  Each of those kernel modules provides a different  
> capability that can be used to generate a firewall.

This is almost *EXACTLY* what SELinux provides as an LSM module.  The  
one difference is that with SELinux some compromises and restrictions  
have been made so that (theoretically) the resulting policy can be  
exhaustively analyzed to *prove* what it allows and disallows.  It  
may be that SELinux should be split into 2 parts, one that provides  
the underlying table-matching and the other that uses it to provide  
the provability guarantees.  Here's a direct comparison:

netfilter:
   (A) Each packet has src, dst, port, etc that can be matched
   (B) Table of rules applied sequentially (MATCH => ACTION)
   (C) Rules may alter the properties of packets as they are routed/ 
bridged/etc

selinux:
   (A) Each object has user, role, and type that can be matched
   (B) Table of rules searched by object parameters (MATCH => allow/ 
auditallow/transition)
   (C) Rules may alter the properties of objects through transition  
rules.

If there are areas where people are confused about SELinux, think it  
may be improved, etc, we would be *GLAD* to hear it.  I'm currently  
struggling to find the time between a hundred other things to finish  
a script I offered to Casey Schaufler a month and a half ago which  
generated an SELinux policy based on a SMACK ruleset.


> So I propose that if people want to work towards a one true linux  
> solution for additional security checks, then they should look  
> towards the linux firewalling code.  It works and it seems to very  
> nicely allow cooperations between different groups.  For the people  
> who will scream mixing security models causes problems, the answer  
> is simple recommend users don't set up their policies that way.

Actually the one thing which really frustrates me about the Linux  
firewalling code is that you cannot selectively apply various  
transformation phases, they are automatically applied for you.  I  
have had a couple very-transparent-routing-firewalling-bridging  
scenarios where I wished I could run the bridging phase, compare-and- 
change the result, and then run the bridging phase again to forward  
the packet elsewhere.  For example if I was to set up a diverted  
ethernet port I would need to apply the bridging code, compare the  
destination port against the selected diverted port and change the  
MAC address, then reapply the bridging code.  To mirror you would  
also need a phase which could create multiple clones of packets and  
conditionalize rules based on which of the copies it was.


> I'm not yet annoyed enough to go implement an iptables like  
> interface to the LSM enhancing it with more generic mechanism to  
> make the problem simpler, but I'm getting there.  Perhaps next time  
> I'm bored.

I think a fair amount of what we need is already done in SELinux, and  
efforts would be better spent in figuring out what seems too  
complicated in SELinux and making it simpler.  Probably a fair amount  
of that just means better tools.

Cheers,
Kyle Moffett

