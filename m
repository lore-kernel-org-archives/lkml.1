Return-Path: <linux-kernel-owner+w=401wt.eu-S1753661AbZL3Upt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661AbZL3Upt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 15:45:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753429AbZL3Upr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 15:45:47 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:57072 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424AbZL3Upq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 15:45:46 -0500
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Bryan Donlan <bdonlan@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Benny Amorsen <benny+usenet@amorsen.dk>,
       Michael Stone <michael@laptop.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, David Lang <david@lang.hm>,
       Oliver Hartkopp <socketcan@hartkopp.net>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
       Evgeniy Polyakov <zbr@ioremap.net>,
       "C. Scott Ananian" <cscott@cscott.net>,
       James Morris <jmorris@namei.org>, Bernie Innocenti <bernie@codewiz.org>,
       Mark Seaborn <mrs@mythic-beasts.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       Samir Bellabes <sam@synack.fr>,
       Casey Schaufler <casey@schaufler-ca.com>, Pavel Machek <pavel@ucw.cz>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC][PATCH v2] Unprivileged: Disable raising of privileges
References: <m3oclhzgm4.fsf@ursa.amorsen.dk>
	<m17hs5y0mg.fsf@fess.ebiederm.org>
	<20091229211139.0732a0c1@lxorguk.ukuu.org.uk>
	<m1iqbpwjtp.fsf@fess.ebiederm.org> <20091229223631.GB22578@us.ibm.com>
	<m1aax1uoa3.fsf_-_@fess.ebiederm.org>
	<3e8340490912291954v5a837a26p64bd776102d281d7@mail.gmail.com>
	<m1r5qdt721.fsf@fess.ebiederm.org>
	<3e8340490912292057g3e87eaabn115f85b78af2b08c@mail.gmail.com>
	<m1d41w62zc.fsf_-_@fess.ebiederm.org>
	<20091230182933.GB14493@us.ibm.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 30 Dec 2009 12:45:41 -0800
In-Reply-To: <20091230182933.GB14493@us.ibm.com> (Serge E. Hallyn's message of "Wed\, 30 Dec 2009 12\:29\:33 -0600")
Message-ID: <m1vdfotclm.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serue@us.ibm.com> writes:

>> @@ -869,6 +869,18 @@ int cap_task_prctl(int option, unsigned long arg2, unsigned long arg3,
>>  			new->securebits &= ~issecure_mask(SECURE_KEEP_CAPS);
>>  		goto changed;
>> 
>> +	case PR_SET_NOSUID:
>> +	{
>> +		const struct cred *cred = current->cred;
>> +		error = -EINVAL;
>
> Should this be -EPERM?  not sure...

I intended -EINVAL to say it is simply a set of initial conditions
that are not supported today.  But could be supported if someone
does the audit, and found there are no security issues.

>> +		/* Perform the capabilities checks */
>> +		if (!cap_isclear(cred->cap_permitted) ||
>> +		    !cap_isclear(cred->cap_effective))
>
> No need to check cap_effective, as no bits can be there which are not
> in cap_permitted.
>
> To be honest, I don't think there is much reason to not have this
> check done in the main sys_prctl(0 - capabilities themselves are not
> optional in the kernel, while cap_task_prctl() is.  So you are setting
> us up to have cases where say an apparmor user can call this with uid
> 0 and/or active capabilities.

Sounds fine to me.  I had noticed all of the capabilities checks were
off in their own file, so I had tried to maintain that.  But you are
right we can't remove capabilities so splitting the code like this only
obfuscates it.

>> @@ -2147,7 +2147,7 @@ static int selinux_bprm_set_creds(struct linux_binprm *bprm)
>>  	COMMON_AUDIT_DATA_INIT(&ad, FS);
>>  	ad.u.fs.path = bprm->file->f_path;
>> 
>> -	if (bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID)
>> +	if (bprm->nosid)
>
> typo - nosuid?

Yep.

Eric
