Return-Path: <linux-kernel-owner+w=401wt.eu-S1752759AbXLDUSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbXLDUSV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 15:18:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751079AbXLDUSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 15:18:09 -0500
Received: from smtp117.sbc.mail.re3.yahoo.com ([66.196.96.90]:27731 "HELO
	smtp117.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750969AbXLDUSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 15:18:07 -0500
X-YMail-OSG: ni3D14kVM1mY0Sv4Up1WNdSjdh4BTRqqIQ6lq1Imd8t7oz2wltLjiJsmiQFdPUyJoqUn_WeZOQ--
Date: Tue, 4 Dec 2007 14:17:13 -0600
From: serge@hallyn.com
To: KaiGai Kohei <kaigai@ak.jp.nec.com>
Cc: Andrew Morgan <morgan@kernel.org>, "Serge E. Hallyn" <serue@us.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org,
       Chris Wright <chrisw@sous-sol.org>,
       Stephen Smalley <sds@epoch.ncsc.mil>, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] capabilities: introduce per-process capability
	bounding set (v10)
Message-ID: <20071204201709.GA9915@vino.hallyn.com>
References: <20071126200908.GA13287@sergelap.austin.ibm.com> <4754D76B.8080406@ak.jp.nec.com> <4754F053.8060303@kernel.org> <4755701C.7070407@ak.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4755701C.7070407@ak.jp.nec.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting KaiGai Kohei (kaigai@ak.jp.nec.com):
> Andrew Morgan wrote:
>> -----BEGIN PGP SIGNED MESSAGE-----
>> Hash: SHA1
>> KaiGai Kohei wrote:
>>> Serge,
>>>
>>> Please tell me the meanings of the following condition.
>>>
>>>> diff --git a/security/commoncap.c b/security/commoncap.c
>>>> index 3a95990..cb71bb0 100644
>>>> --- a/security/commoncap.c
>>>> +++ b/security/commoncap.c
>>>> @@ -133,6 +119,12 @@ int cap_capset_check (struct task_struct *target,
>>>> kernel_cap_t *effective,
>>>>          /* incapable of using this inheritable set */
>>>>          return -EPERM;
>>>>      }
>>>> +    if (!!cap_issubset(*inheritable,
>>>> +               cap_combine(target->cap_inheritable,
>>>> +                       current->cap_bset))) {
>>>> +        /* no new pI capabilities outside bounding set */
>>>> +        return -EPERM;
>>>> +    }
>>>>       /* verify restrictions on target's new Permitted set */
>>>>      if (!cap_issubset (*permitted,
>>> It seems to me this condition requires the new inheritable capability
>>> set must have a capability more than bounding set, at least.
>>> What is the purpose of this checking?
>> Yes, the !! was a bug. The correct check is a single !.
>
> I was in trouble with getting -EPERM at pam_cap.so :-)
>
>> (Thus, the correct check says no 'new' pI bits can be outside cap_bset.)
>
> If this condition intends to dominate 'new' pI bits by 'old' pI bits masked
> with bounding set, we should not apply cap_combine() here.
> I think applying cap_intersect() is correct for the purpose.

That would have been my first inclination, but Andrew actually
wanted to be able to keep a pI with bits not in the capability
bounding set.  And it's really not a big problem, since

	1. you can never grow cap_bset
	2. the capbound.c program just makes sure to call capset
	   to take the bit being removed from cap_bset out of
	   pI'
	3. It could be advantageous for some daemon to keep a bit
	   in pI which can never be gained through fP but can be
	   gained by a child through (fI&pI).

Does that seem reasonable to you?

(On the one hand man 7 capabilities shows cap_bset affecting
fP and not pP', on the other hand we're definately getting into
the territory where we'll have to rewrite the manpages anyway)

thanks,
-serge
