Return-Path: <linux-kernel-owner+w=401wt.eu-S1752904AbXDRM3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904AbXDRM3n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 08:29:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752683AbXDRM3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 08:29:43 -0400
Received: from tresys.irides.com ([216.250.243.126]:23155 "HELO
	exchange.columbia.tresys.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752661AbXDRM3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 08:29:41 -0400
X-Greylist: delayed 849 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Apr 2007 08:29:40 EDT
Message-ID: <46260BE1.4060509@tresys.com>
Date: Wed, 18 Apr 2007 08:15:29 -0400
From: Joshua Brindle <jbrindle@tresys.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: capibara@xs4all.nl
CC: Karl MacMillan <kmacmill@redhat.com>, James Morris <jmorris@namei.org>,
       John Johansen <jjohansen@suse.de>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: AppArmor FAQ
References: <20070416213350.GB4030@suse.de>    <Line.LNX.4.64.0704161846110.13905@d.namei>    <1176846917.5946.79.camel@localhost.localdomain> <19259.213.222.28.155.1176880873.squirrel@webmail.xs4all.nl>
In-Reply-To: <19259.213.222.28.155.1176880873.squirrel@webmail.xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Apr 2007 12:15:30.0737 (UTC) FILETIME=[41DB5210:01C781B3]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Meijer wrote:
> On Tue, April 17, 2007 23:55, Karl MacMillan wrote:
>   
>> On Mon, 2007-04-16 at 20:20 -0400, James Morris wrote:
>>     
>>> On Mon, 16 Apr 2007, John Johansen wrote:
>>>
>>>       
>>>> Label-based security (exemplified by SELinux, and its predecessors in
>>>> MLS systems) attaches security policy to the data. As the data flows
>>>> through the system, the label sticks to the data, and so security
>>>> policy with respect to this data stays intact. This is a good approach
>>>> for ensuring secrecy, the kind of problem that intelligence agencies
>>>>         
>>> have.
>>>
>>> Labels are also a good approach for ensuring integrity, which is one of
>>> the most fundamental aspects of the security model implemented by
>>> SELinux.
>>>
>>> Some may infer otherwise from your document.
>>>
>>>       
>> Not only that, the implication that secrecy is only useful to
>> intelligence agencies is pretty funny. Personally, I think that
>> protecting the confidentiality of my data is important (and my bank and
>> health care providers protecting the data they have about me). Type
>> Enforcement was specifically designed to be able to address integrity
>> _and_ confidentiality in a way acceptable to commercial organizations.
>>
>> Karl
>>     
>
> Shouldn't that be _OR_, as I have always understood confidentialy
> models like BLP are by their very nature incompatible with integrity
> models like Biba. Given this incompatibity, I think the idea that
> BLP style use of lables (ss/* property and the likes) is only usefull
> to intelligence agencies may well be correct, while usage for integrity
> models like Biba and CW would be much broader than that.
>   
Biba and BLP are only incompatible if they are using the same label, if 
each object has a confidentiality and integrity label they work fine 
together (as well as MLS systems work in general that is). Type 
enforcement, however, lets you accomplish both integrity and 
confidentiality (though not easily hierarchal confidentiality*). Take a 
mail client for example, I could argue that my mail is confidential so I 
label it my_mail_t and only give access to my mail client to read it and 
the MTA to write it. Further I limit access of my mail client to objects 
that can reduce its integrity such as untrusted files in /tmp, less 
trusted user home directories and so on. Despite AA advocate claims that 
info flow doesn't matter to integrity it does. I must be able to see 
what can write to objects that my mail client can read if I want to make 
any claims about its integrity.

* hierarchal confidentiality is obtained with an additional BLP label 
that is evaluated as set of constraints over the type enforcement 
permissions. SELinux is extensible in this way where AA is not.

> A path based 'least priviledge' (POLP) solution would I think on its own
> address neither integity nor confidentiality, and next to this would
> proof to be yet an other 'fat profile' administration hell.
>
> Having said that, I feel a path based solution could have great potential
> if it could be used in conjunction with the object capability model, that
> I would consider a simple and practical alternative integrity model that
> does not require lables in an MLS maner, and that extends on the POLP
> concept in a way that would be largely more practical.
>   
This would be combining two bad systems to get a worse one IMO. 
Capability systems are inherently discretionary since propagated 
capabilities must be removed at the discretion of the possessor of the 
capabilities.

The argument that labels are not practical has yet to be shown but is 
thrown around as if it is fact. Path based systems are inferior to label 
based systems based if for no other reason than path based systems can't 
control transient objects. With policy based type transition in SELinux 
when my ssh client writes my agent socket to /tmp/ssh-xxxxxxxxxx SELinux 
calculates a type transition based off my domain to label it 
sysadm_ssh_t (or whatever is appropriate) whereas path based systems 
can't possibly control access to these objects. The same goes for any 
files written to home directories by user apps.

> That is, using 'thin' path based profiles would become very practical if
> all further authority can be communicated using handles in the same way
> that an open file handle can be communicated.
>   

Once again, this creates a discretionary system that would not work 
without modifying every single application that uses such authority (and 
trusting the code is bug free so that it does the right thing) and gives 
you an inflexible, decentralized, unmaintainable, unanalyzable policy 
since it is distributed throughout code all over the system, you give 
users no way to change the security characteristics of the system.
