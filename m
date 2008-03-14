Return-Path: <linux-kernel-owner+w=401wt.eu-S1756873AbYCNOPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873AbYCNOPt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 10:15:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753021AbYCNOPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 10:15:39 -0400
Received: from sacred.ru ([62.205.161.221]:46475 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903AbYCNOPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 10:15:38 -0400
Message-ID: <47DA861A.2020905@openvz.org>
Date: Fri, 14 Mar 2008 17:05:14 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: James Morris <jmorris@namei.org>, lkml <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org, Greg KH <greg@kroah.com>,
       Stephen Smalley <sds@epoch.ncsc.mil>,
       Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [RFC] cgroups: implement device whitelist lsm (v2)
References: <20080313032749.GA13258@sergelap.austin.ibm.com> <Xine.LNX.4.64.0803132022530.6358@us.intercode.com.au> <20080313131818.GA9771@sergelap.austin.ibm.com> <Xine.LNX.4.64.0803140049270.9059@us.intercode.com.au> <20080313143803.GA11265@sergelap.austin.ibm.com> <Xine.LNX.4.64.0803140925410.30342@us.intercode.com.au> <20080313224616.GA9139@sergelap.austin.ibm.com> <Xine.LNX.4.64.0803141046340.1545@us.intercode.com.au> <20080314014121.GA8320@sergelap.austin.ibm.com> <47DA4533.8030106@openvz.org> <20080314135817.GE8744@sergelap.austin.ibm.com>
In-Reply-To: <20080314135817.GE8744@sergelap.austin.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Fri, 14 Mar 2008 17:05:16 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn wrote:
> Quoting Pavel Emelyanov (xemul@openvz.org):
>> Serge E. Hallyn wrote:
>>> Quoting James Morris (jmorris@namei.org):
>>>> On Thu, 13 Mar 2008, Serge E. Hallyn wrote:
>>>>
>>>>> Quoting James Morris (jmorris@namei.org):
>>>>>> On Thu, 13 Mar 2008, Serge E. Hallyn wrote:
>>>>>>
>>>>>>> True, but while this change simplifies the code a bit, the semantics
>>>>>>> seem more muddled - devcg will be enforcing when CONFIG_CGROUP_DEV=y
>>>>>>> and:
>>>>>>>
>>>>>>> 	SECURITY=n or
>>>>>>> 	rootplug is enabled
>>>>>>> 	capabilities is enabled
>>>>>>> 	smack is enabled
>>>>>>> 	selinux+capabilities is enabled
>>>>>> Well, this is how real systems are going to be deployed.
>>>>> Sorry, do you mean with capabilities?
>>>> Yes.
>>>>
>>>> All Fedora, RHEL, CentOS etc. ship with SELinux+capabilities.  I can't 
>>>> imagine not enabling them on other kernels.
>>>>
>>>>>> It becomes confusing, IMHO, if you have to change which secondary LSM you 
>>>>>> stack with SELinux to enable a cgroup feature.
>>>>> So you're saying selinux without capabilities should still be able to
>>>>> use dev_cgroup?  (Just making sure I understand right)
>>>> Nope, SELinux always stacks with capabilities, so havng the cgroup hooks 
>>>> in capabilities makes sense (rather than having us change the secondary 
>>>> stacking LSM just to enable a feature).
>>> Oh, ok.
>>>
>>> Will let the patch stand until Pavel and Greg comment then.
>> Well, I saw your previous patch, that was implemented as just another
>> LSM module and I liked it except for the LSM dependency.
> 
> James and Stephen agree with your LSM qualms.  I suppose we could add

Thanks!

> cgroups next to the lsm hooks.  I suspect Paul Menage would complain
> about that (Paul?), and I do think it's silly as they are security
> questions, not group tracking questions, but if it's what people want
> I can send out a new patch next week.

The way I see this is: cgroups provide a common way to group tasks
and an API for general configuration - that's the controller "face", 
and it's up to the controller to decide where he turns his "back",
IOW where the hooks are placed. For the memory controller - they are
injected directly into the mm code. For this controller, I think it
would be OK to use LSM or about-LSM hooks.

>> Since this version can happily work w/o LSM, I like it too :)
> 
> In an earlier version I asked whether you had any experience with usual
> # rules per container.  Do you have an idea?  Right now the whitelist is
> a straight list we search through linearly.  If # rules is generally
> tiny then I'm inclined to keep it that way...

The # of rules usually has a linear dependency on the number of containers
(each of then has to have an access to /dev/null,zero,random at least), so
having 100 containers we will have to scan through a 300-entries list. I'd
vote for a hash table or a radix/binary/rb tree for that. Or any other way
for non-linear search you can provide :)

> thanks,
> -serge
> 

