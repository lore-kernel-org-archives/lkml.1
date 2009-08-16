Return-Path: <linux-kernel-owner+w=401wt.eu-S1756500AbZHPXZL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756500AbZHPXZL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 19:25:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756431AbZHPXZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 19:25:10 -0400
Received: from cyrus.watson.org ([65.122.17.42]:52631 "EHLO cyrus.watson.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755634AbZHPXZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 19:25:09 -0400
Cc: oliver.pntr@gmail.com (Oliver Pinter), freebsd-hackers@FreeBSD.org,
       linux-kernel@vger.kernel.org
Message-Id: <7F29E9E1-AB92-45E3-9DF3-C8455533BA19@FreeBSD.org>
From: "Robert N. M. Watson" <rwatson@FreeBSD.org>
To: David Wagner <daw@cs.berkeley.edu>
In-Reply-To: <200908162109.n7GL9JNK029605@taverner.cs.berkeley.edu>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: Security: information leaks in /proc enable keystroke recovery
Date: Mon, 17 Aug 2009 00:25:07 +0100
References: <200908162109.n7GL9JNK029605@taverner.cs.berkeley.edu>
X-Mailer: Apple Mail (2.936)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 16 Aug 2009, at 22:09, David Wagner wrote:

>> Beyond this, and assuming the correct implementation of the above,
>> we're into the grounds of classic trusted OS covert channel analysis,
>> against which no COTS UNIX OSes I'm aware of are hardened.  This  
>> isn't to
>> dismiss these attacks as purely hypothetical -- we've seen some  
>> rather
>> compelling examples of covert channels being exploited in unexpected
>> and remarkably practical ways in the last few years (Steven Murdoch's
>> "Hot or Not" paper takes the cake in that regard, I think).
>
> To be pedantic, I'd say that the Usenix Security paper describes a  
> side
> channel, not a covert channel.  The paper shows how a malicious  
> attacker
> can attack an unsuspecting victim application.
>
> Covert channels are when both the sender and the receiver are  
> malicious
> and cooperating to transmit information from the sender to the  
> receiver.
> In contrast, side channels arise when the "sender" is unintentionally
> and inadvertently leaking information that can be decoded by a  
> malicious
> receiver, against the interests of the "sender".  The attack in the
> paper is a side channel, not a covert channel.  When it comes to  
> covert
> channels, it is indeed reasonable to throw up your hands and say that
> defending against covert channels is basically impossible, so why  
> bother?
> For side channels, though, it's less clear that this is a persuasive
> argument.

Hi David--

I see what you're saying, but I'm not sure I entirely agree on the  
pedantic definitions front ("two can play at this game"). Historically  
interesting definitions in DoD 5200.28-STD ("The Orange Book") and  
NCSC-TG-030 ("A Guide to Understanding Covert Channel Analysis of  
Trusted Systems") are decidedly hazy on the concept of intention, with  
some portions specific on its involvement and others entirely  
disregarding it. These definitions come out of trusted OS research/ 
development, and might be considered historically anachronistic by  
some. To my mind, the OS timing issue we're discussing meet two of the  
definitions of "covert channel" presented in NCSC-TG-030:

   Definition 4: Covert channels are those that "use entities not  
normally viewed as data objects to transfer information from one  
subject to another."

   Definition 5: Given a non-discretionary (e.g., mandatory) security  
policy model M and its interpretation I(M) in an operating system, any  
potential communication between two subjects I(Sh) and I(Si) of I(m)  
is covert if and only if any communication between the corresponding  
subject Sh and Si of the model M is illegal in M.

Which is to say: what makes something a "covert channel" is not the  
intention to communicate in violation of a policy, but the  
*possibility* of communication in violation of system design or  
security policy. Both documents are concerned primarily with  
intentional leakage/corruption of information in confidentiality and  
integrity policies, but their definitions appear more general.

The use of the word "mandatory" here is certainly one that also bears  
consideration: I would argue that the system integrity constraints of  
historic UNIX, such as those on inter-process control vectors  
(debugging, signals, ...) do in fact constitute a mandatory policy,  
albeit not based on information flow control or a particularly clean  
or well-documented model. As an example: unprivileged users are  
permitted only limited scope under the discretionary access control  
policy to delegate rights for objects they own. They can delegate to  
another user write access to a file via open(2), but not the right to  
chown the file using chown(2), signal a process using kill(2), etc,  
making the protections that prevent these operations "mandatory".

I would argue that undesired information leakage via I/O timing across  
process monitoring interfaces qualifies as a covert channel under both  
definitions above: it's not an intended communication channel provided  
by the OS design, and that the OS security policy is not intended to  
allow unintentional communication of I/O data without explicit  
delegation. The historic covert channel analysis of the timing  
problem, drawn out in somewhat painful detail in NCSC-TG-030, seems  
pretty much to apply to this problem.

I wouldn't argue that EIP leakage in procfs counted, on the other  
hand, as it appears to be an intentional, if in retrospect  
unfortunate, part of the design and policy. I wouldn't doubt that  
countless other similar "oh, perhaps not" cases of information leakage  
exist across countless variations on the UNIX theme due to monitoring  
and debugging interfaces -- for example, netstat's reporting of TCP  
pending send/receive queues seems likely subject to quite similar  
problems, as with timestamps on device nodes in /dev, even network  
interface or protocol statistics from netstat.

Coming down on the other side of pedantic, BTW, the Orange Book's  
definition of "Covert storage channels" seems to ignore intention,  
"Covert timing channels" seems to require it.

>> However, this next step up from "the kernel doesn't reveal  
>> information on
>> processes from other users" involves scheduler hardening,  
>> consideration
>> of inter-CPU/core/thread cache interactions, and so on -- things  
>> that we
>> don't have a good research, let alone production, OS understanding  
>> of.
>
> Indeed.  A major challenge.  Good to hear that, in its default
> configuration, FreeBSD does eliminate the attack vector described in
> the Usenix Security paper (the EIP/ESP leak).  It seems a good  
> starting
> point would be to limit access to information that we know can enable
> keystroke recovery -- as FreeBSD apparently already does, but Linux
> apparently does not.


NCSC-TG-030 has quite a bit to say on the topic of these sorts of  
things, albeit addressed at a different context and in a different  
time. I find myself skeptical that the sorts of protections we are  
waving our hands at apply all that well to UNIX-like systems due to  
their origin as time-sharing systems. However, I think a more  
interesting place to direct this analysis would be the current flush  
of hypervisors, which appear (possibly even claim) to offer much  
stronger separation in a less time-sharesque way.

Robert
