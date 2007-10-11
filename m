Return-Path: <linux-kernel-owner+w=401wt.eu-S1755648AbXJKKrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648AbXJKKrb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 06:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753148AbXJKKrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 06:47:23 -0400
Received: from smtpoutm.mac.com ([17.148.16.81]:51249 "EHLO smtpoutm.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752368AbXJKKrW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 06:47:22 -0400
In-Reply-To: <438747.71497.qm@web36613.mail.mud.yahoo.com>
References: <438747.71497.qm@web36613.mail.mud.yahoo.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <115705D2-825B-4508-8019-27E964E85085@mac.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Serge E. Hallyn" <serge@hallyn.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bill Davidsen <davidsen@tmr.com>, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [PATCH] Version 3 (2.6.23-rc8) Smack: Simplified Mandatory Access Control Kernel
Date: Thu, 11 Oct 2007 06:46:45 -0400
To: casey@schaufler-ca.com
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, finally getting some time to work on this stuff once again (life  
gets really crazy sometimes).  I would like to postulate that you can  
restate any SMACK policy as a functionally equivalent SELinux policy  
(with a few slight technical differences, see below).  I've been  
working on a script to do this but keep getting stuck tracking down  
minor bugs and then get dragged off on other things I need to do.   
Here is the method I am presently trying to implement:

First divide the SELinux access vectors into 7 groups based on which  
ones SMACK wishes to influence:
	(R) Requires "read" permissions (the 'r' bit)
	(W) Requires "write" permissions (the 'w' bit)
	(X) Requires "execute" permissions (the 'x' bit)
	(A) Requires "append" OR "write" permissions (the 'a' bit)
	(P) Requires CAP_MAC_OVERRIDE
	(K) May not be performed by a non-CAP_MAC_OVERRIDE process on a  
CAP_MAC_OVERRIDE process
	(N) Does not require any special permissions

The letters in front indicate the names I will use in the rest of  
this document to describe the sets of access vectors.

Next define a single SELinux user "smack", and two independent roles,  
"priv" and "unpriv".  We create the set of SMACK equivalence-classes  
defined as various SELinux types with substitutions for "*", "^",  
"_", and "?", and then completely omit the MLS portions of the  
SELinux policy.

The next step is to establish the fundamental constraints of the  
policy.  To prevent processes from gaining CAP_MAC_OVERRIDE we  
iterate over the access vectors in (K) and add the following  
constraint for each vector:
	constrain $OBJECT_CLASS $ACCESS_VECTOR ((r1 == r2) || (r1 == priv))

This also includes:
	constrain process transition ((r1 == r2) || (r1 == priv))

Then we require privilege to access the (P) vectors; for each vector  
in (P) we add a constraint:
	constrain $OBJECT_CLASS $ACCESS_VECTOR (r1 == priv)

At this point the only rules left to add are the between-type rules.   
Here it gets mildly complicated because SMACK is a linear-lookup  
system (each rule must be matched in order) whereas SELinux is a  
globally-unique-lookup system (all rules are mutually exclusive and  
matched simultaneously).  Essentially for each SMACK rule:
	$SOURCE $DEST $PERM_BITS

We iterate over all of the classes represented in the access vector  
lists in $PERM_BITS and create rules for each one:
	allow { $SOURCE } { $DEST }:$PERM_CLASS { $PERM_VECTORS };

If you need SMACK to allow subtractive permissions then you need to  
expand that further, however I believe as an initial cut that it  
sufficient.

The only other task is to prepend the auto-generated object-class and  
access-vector lists to the policy and append the initial SIDs that  
smack wants various objects to have, as well as allowing the "smack"  
user the "priv" and "nopriv" roles and allowing those two roles entry  
into all of the SMACK types.  The resulting SELinux-ified SMACK  
labels would go from:

SomeLabel (with CAP_MAC_OVERRIDE)
AnotherLabel
YetAnotherLabel

to:

smack:priv:SomeLabel
smack:nopriv:AnotherLabel
smack:nopriv:YetAnotherLabel


Casey, hopefully this gives you some ideas about how I think you  
could modify the SELinux code to compile out the "user" field and  
simplify the "role" field as needed.  I'm still not seeing anything  
which SELinux cannot directly implement without additional code, even  
the "CAP_MAC_OVERRIDE" bit.  If the semantics don't seem quite right,  
please provide details about how you think the models differ and I  
will try to address the concerns.

Cheers,
Kyle Moffett

