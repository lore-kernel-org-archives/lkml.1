Return-Path: <linux-kernel-owner+w=401wt.eu-S1754882AbZFIDm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882AbZFIDm3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 23:42:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752749AbZFIDmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 23:42:21 -0400
Received: from smtp105.prem.mail.sp1.yahoo.com ([98.136.44.60]:30552 "HELO
	smtp105.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752547AbZFIDmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 23:42:20 -0400
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: 9gc.jJ0VM1kF4GLfZRQJ0pEGq1r5Ino3te4zwGHhrDyXI0fzIktiT42uxzCShTv38TjEyUYlBYZnHGEHhfFaP.9dIC9wn.BEIvewHXaof63SLiiR012h19jsDWdJMSmEGqWfDtPXXV.0jdtKQJ62urK4AmjqxWyRBo.RvtFlOoEPV7S5O_1H6akvLDp7xW680jZDeVX4DmWAsxK.u2oYa4mBDZcK7HxvxQGQ6xVS80QhooRORZ70ynR7MMidUuminbr9PEE3vstQT1ceIFTcWyTpmCTHmc0SS9JIIKu0h1Box9SJYQ7o144.8mErmYx6gJvLFF_vVqgXY7Y-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4A2DDA12.3020907@schaufler-ca.com>
Date: Mon, 08 Jun 2009 20:42:10 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
CC: James Morris <jmorris@namei.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Mimi Zohar <zohar@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Serge Hallyn <serue@us.ibm.com>, Al Viro <viro@zeniv.linux.org.uk>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       David Safford <safford@watson.ibm.com>
Subject: Re: [PATCH] integrity: fix IMA inode leak
References: <Pine.LNX.4.64.0906062109580.8365@sister.anvils>	 <alpine.LFD.2.01.0906061416170.6847@localhost.localdomain>	 <1244354901.3963.23.camel@dyn9002018117.watson.ibm.com>	 <alpine.LFD.2.01.0906071608040.6847@localhost.localdomain>	 <1244464135.3277.13.camel@dyn9002018117.watson.ibm.com>	 <alpine.LFD.2.01.0906080913020.6847@localhost.localdomain>	 <1244486655.3277.65.camel@dyn9002018117.watson.ibm.com>	 <alpine.LRH.2.00.0906090912120.6132@tundra.namei.org> <1244516211.3804.24.camel@dyn9002018117.watson.ibm.com>
In-Reply-To: <1244516211.3804.24.camel@dyn9002018117.watson.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mimi Zohar wrote:
> On Tue, 2009-06-09 at 09:16 +1000, James Morris wrote:
>   
>> On Mon, 8 Jun 2009, Mimi Zohar wrote:
>>
>>     
>>> Ok, so instead of having a full fledge single security layer, only add
>>> the security layer for those places where both the LSM hooks and IMA
>>> co-exist: security_file_mmap, security_bprm_check, security_inode_alloc,
>>> security_inode_free, and security_file_free. As the LSM hooks are called
>>> 'security_XXXX', the call would look something like:
>>>
>>> security_all_inode_free() {
>>>         ima_inode_free()
>>>         security_inode_free()
>>> }
>>>       
>> Yes, it only needs to be a wrapper.  The above is ugly, how about:
>>     
>
> agreed!  But changing only these 5 security_ hook names and leaving the
> rest alone is even uglier.
>
>   
>> security_inode_free()
>> {
>> 	ima_inode_free();
>> 	lsm_inode_free();
>> }
>>
>> I think we may have come full circle on the naming of the LSM hook, but 
>> 'security_*' was never great given that it's only supposed to be covering 
>> access control.
>>     
>
> so why not 'mac_'?
>   

An LSM could introduce a discretionary scheme. If you use SELinux with
just MCS that's what you get. Although POSIX ACLs can't be implemented
via the LSM (the mode bit interactions preclude doing so) there are other
ACL schemes that could use the LSM. I have gotten suggestions on "label
ownership" that would turn Smack into DAC. If you wanted to call it
Additional Access Control (AAC) or Supplemental Access Control (SAC)
I would go along with it, but not MAC.


> Mimi Zohar
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>   
