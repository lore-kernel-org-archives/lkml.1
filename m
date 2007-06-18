Return-Path: <linux-kernel-owner+w=401wt.eu-S1762681AbXFRLav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762681AbXFRLav (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 07:30:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762323AbXFRLal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 07:30:41 -0400
Received: from exchange.columbia.tresys.com ([216.250.243.126]:55873 "HELO
	exchange.columbia.tresys.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760823AbXFRLaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 07:30:39 -0400
Message-ID: <46766CB2.3040005@manicmethod.com>
Date: Mon, 18 Jun 2007 07:29:54 -0400
From: Joshua Brindle <method@manicmethod.com>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: casey@schaufler-ca.com
CC: James Morris <jmorris@namei.org>, Greg KH <greg@kroah.com>,
       Pavel Machek <pavel@ucw.cz>, Crispin Cowan <crispin@novell.com>,
       Andreas Gruenbacher <agruen@suse.de>,
       Stephen Smalley <sds@tycho.nsa.gov>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
 pathname matching
References: <822529.74206.qm@web36601.mail.mud.yahoo.com>
In-Reply-To: <822529.74206.qm@web36601.mail.mud.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Jun 2007 11:30:37.0810 (UTC) FILETIME=[17F20520:01C7B19C]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler wrote:
> --- James Morris <jmorris@namei.org> wrote:
>
>   
>> On Fri, 15 Jun 2007, Casey Schaufler wrote:
>>
>>     
>>> --- James Morris <jmorris@namei.org> wrote:
>>>
>>>       
>>>> On my system, it takes about 1.2 seconds to label a fully checked out 
>>>> kernel source tree with ~23,000 files in this manner
>>>>         
>>> That's an eternity for that many files to be improperly labeled.
>>> If, and the "if" didn't originate with me, your policy is
>>> demonstrably correct (how do you do that?) for all domains
>>> you could claim that the action is safe, if not ideal. 
>>> I can't say if an evaluation team would buy the "safe"
>>> argument. They've been known to balk before.
>>>       
>> To clarify:
>>
>> We are discussing a scheme where the underlying SELinux labeling policy 
>> always ensures a safe label on a file, and then relabeling newly created 
>> files according to their pathnames.
>>     
>
> To counter clarify:
>
> You are saying two things:
> 1. The policy always ensures a safe label.
> 2. Files can be relabeled in a reasonable and timely manner.
>
> I have no questions about 2. It's a hack, but you've already
> acknowledged that and it will work, allowing for some potential
> cases where someone is overeager about getting a file-in-transition.
>
> Regarding 1: This is a founding premise of the arguement, that
> the "policy" is written correctly such that there is no case
> where a file gets created with an unsafe label. Given the external
> nature of the policy, and the number of attributes used within
> the policy, and the overall sophistication of the policy mechanism,
> how does one ...
>
>     a. know that a label is "safe"
>     b. know that a file will get a "safe" label
>     c. know that the policy is "correctly" written as required
>
> The question is not if fixxerupperd can set things right.
> The question is about the properly written policy that is
> required to make the mechanism worth discussing.
>
>   

There are only about 850 file type_transition rules in the policy 
shipped with RHEL and the vast majority of them are templated so this 
isn't as hard as you think. Most are things like:
   type_transition ftpd_t tmp_t : file ftpd_tmp_t;

which 1) don't require relabeling to something else and 2) very easy to 
audit. A quick look suggests that the potentially less-restrictive label 
is never chosen, for example you'll see:
   type_transition groupadd_t etc_t : file shadow_t;
   type_transition useradd_t etc_t : file shadow_t;

Instead of the default transition being etc_t they are labeled as 
shadow_t (more restrictive) and then potentially relabled to etc_t.

That said, the lack of a type_transition in this case is as important as 
having one if the default type (the parent directory) is less 
restrictive. We already have tools that analyze policy and even tools to 
warn about potential errors in policy (apol and sechecker). It might be 
a good idea to add some more analysis to these tools to point out 
potential labeling errors that can be used in automatic analysis, which 
shouldn't be hard, I'll be sure to suggest that to the setools developers.

>> There is no expectation that this scheme would be submitted for 
>> certification.
>>     
>
> De-nial.
>
>   

Several systems have gone off to ct&e and none of them use restorecond. 
These are custom build systems and relabeling is kept to a minimum and 
the applications are architected in a way that precludes this being 
necessary so I don't know what you are trying to get at here.

>> Its purpose is to merely to provide pathname-based 
>> labeling outside of the kernel.
>>     
>
> If you already have an in-kernel labeling scheme that you
> trust to make the world safe until you get around to doing
> the labeling externally you can argue that it's good enough.
> But, to quote Cinderella's Stepmother, "I said "if"".
>   

The "if" for SELinux is alot easier than you suggest. It certainly 
outweighs the disadvantages of the path based scheme IMHO.
