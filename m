Return-Path: <linux-kernel-owner+w=401wt.eu-S1759093AbXJKPlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759093AbXJKPlu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 11:41:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758774AbXJKPli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 11:41:38 -0400
Received: from web36604.mail.mud.yahoo.com ([209.191.85.21]:47827 "HELO
	web36604.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758502AbXJKPlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 11:41:35 -0400
X-YMail-OSG: j_XOcYIVM1k92euEY1fuF5rdtTXqu1PG74mN3BiuBKyFksulH0HkfZTrXbgnmN4RNlNPR0ic2Q--
X-RocketYMMF: rancidfat
Date: Thu, 11 Oct 2007 08:41:34 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH] Version 3 (2.6.23-rc8) Smack: Simplified Mandatory Access Control Kernel
To: Kyle Moffett <mrmacman_g4@mac.com>, casey@schaufler-ca.com
Cc: Stephen Smalley <sds@tycho.nsa.gov>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Serge E. Hallyn" <serge@hallyn.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bill Davidsen <davidsen@tmr.com>, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <115705D2-825B-4508-8019-27E964E85085@mac.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <928423.71088.qm@web36604.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Kyle Moffett <mrmacman_g4@mac.com> wrote:

> Ok, finally getting some time to work on this stuff once again (life  
> gets really crazy sometimes).  I would like to postulate that you can  
> restate any SMACK policy as a functionally equivalent SELinux policy  
> (with a few slight technical differences, see below).  I've been  
> working on a script to do this but keep getting stuck tracking down  
> minor bugs and then get dragged off on other things I need to do.   
> Here is the method I am presently trying to implement:
> 
> First divide the SELinux access vectors into 7 groups based on which  
> ones SMACK wishes to influence:
> 	(R) Requires "read" permissions (the 'r' bit)
> 	(W) Requires "write" permissions (the 'w' bit)
> 	(X) Requires "execute" permissions (the 'x' bit)
> 	(A) Requires "append" OR "write" permissions (the 'a' bit)
> 	(P) Requires CAP_MAC_OVERRIDE
> 	(K) May not be performed by a non-CAP_MAC_OVERRIDE process on a  
> CAP_MAC_OVERRIDE process
> 	(N) Does not require any special permissions
> 
> The letters in front indicate the names I will use in the rest of  
> this document to describe the sets of access vectors.
> 
> Next define a single SELinux user "smack", and two independent roles,  
> "priv" and "unpriv".  We create the set of SMACK equivalence-classes  
> defined as various SELinux types with substitutions for "*", "^",  
> "_", and "?", and then completely omit the MLS portions of the  
> SELinux policy.
> 
> The next step is to establish the fundamental constraints of the  
> policy.  To prevent processes from gaining CAP_MAC_OVERRIDE we  
> iterate over the access vectors in (K) and add the following  
> constraint for each vector:
> 	constrain $OBJECT_CLASS $ACCESS_VECTOR ((r1 == r2) || (r1 == priv))
> 
> This also includes:
> 	constrain process transition ((r1 == r2) || (r1 == priv))
> 
> Then we require privilege to access the (P) vectors; for each vector  
> in (P) we add a constraint:
> 	constrain $OBJECT_CLASS $ACCESS_VECTOR (r1 == priv)
> 
> At this point the only rules left to add are the between-type rules.   
> Here it gets mildly complicated because SMACK is a linear-lookup  
> system (each rule must be matched in order) whereas SELinux is a  
> globally-unique-lookup system (all rules are mutually exclusive and  
> matched simultaneously).  Essentially for each SMACK rule:
> 	$SOURCE $DEST $PERM_BITS
> 
> We iterate over all of the classes represented in the access vector  
> lists in $PERM_BITS and create rules for each one:
> 	allow { $SOURCE } { $DEST }:$PERM_CLASS { $PERM_VECTORS };
> 
> If you need SMACK to allow subtractive permissions then you need to  
> expand that further, however I believe as an initial cut that it  
> sufficient.
> 
> The only other task is to prepend the auto-generated object-class and  
> access-vector lists to the policy and append the initial SIDs that  
> smack wants various objects to have, as well as allowing the "smack"  
> user the "priv" and "nopriv" roles and allowing those two roles entry  
> into all of the SMACK types.  The resulting SELinux-ified SMACK  
> labels would go from:
> 
> SomeLabel (with CAP_MAC_OVERRIDE)
> AnotherLabel
> YetAnotherLabel
> 
> to:
> 
> smack:priv:SomeLabel
> smack:nopriv:AnotherLabel
> smack:nopriv:YetAnotherLabel
> 
> 
> Casey, hopefully this gives you some ideas about how I think you  
> could modify the SELinux code to compile out the "user" field and  
> simplify the "role" field as needed.  I'm still not seeing anything  
> which SELinux cannot directly implement without additional code, even  
> the "CAP_MAC_OVERRIDE" bit.  If the semantics don't seem quite right,  
> please provide details about how you think the models differ and I  
> will try to address the concerns.

I'm still waiting to see the proposed SELinux policy that does
what Smack does. I can accept that you don't see anything that
can't be implemented thus, but that's not the point. You've
provided some really clear design notes, and that's great, but
it ain't the code. You said that you could write a 500 line
perl script that would do the whole thing, and that left some
people with an impression that Smack is a subset of SELinux.
Well, I'm already finding myself digging out from under that
missunderstanding, and with people who are assuming that your
policy has been done, "proving" the point.

I see nothing wrong with your approach, although I'm curious
about how your emulation of capabilities will work, or if it's
even rational to include in the SELinux context. I have my
benchmark lab* ready to go when you have a policy for me to try.

Thank you.

----
* It's a sony VAIO laptop with an 800MHZ AMD processor.


Casey Schaufler
casey@schaufler-ca.com
