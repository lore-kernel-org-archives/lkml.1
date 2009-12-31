Return-Path: <linux-kernel-owner+w=401wt.eu-S1753172AbZLaCoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172AbZLaCoc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 21:44:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752991AbZLaCob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 21:44:31 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:61188 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891AbZLaCoa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 21:44:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=TtlFY8E2brRg5zB+ZYA2+yncdbY+mmqjmhP+RH3YF90xQJ89K7UDjLZeXMpJj/kOYr
         XAVNPPPUKEl21bC7Z9Vroz3DWf3TY8BPMJUOXy9B3Xyrvv4QEymeyzgmbMQJRD/SrAvZ
         7hvRl+ab6Hk1gh0eeZYv7SDk65kMU8CG0wI9U=
MIME-Version: 1.0
In-Reply-To: <20091230230042.5d2e78ac@lxorguk.ukuu.org.uk>
References: <m1iqbpwjtp.fsf@fess.ebiederm.org> <m1d41w62zc.fsf_-_@fess.ebiederm.org> 
	<551280e50912300652r1007dee0j8de750bf33af9b3c@mail.gmail.com> 
	<20091230183513.GC14493@us.ibm.com> <m1fx6suswz.fsf@fess.ebiederm.org> 
	<20091230201712.GA23999@us.ibm.com> <m1hbr8tb8q.fsf_-_@fess.ebiederm.org> 
	<20091230212931.233003b9@lxorguk.ukuu.org.uk> <m1skasrvnq.fsf@fess.ebiederm.org> 
	<20091230230042.5d2e78ac@lxorguk.ukuu.org.uk>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Wed, 30 Dec 2009 21:44:05 -0500
Message-ID: <3e8340490912301844p4fddaf57ke58ceeba9582e0fa@mail.gmail.com>
Subject: Re: [RFC][PATCH v3] Unprivileged: Disable raising of privileges
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       "Andrew G. Morgan" <morgan@kernel.org>,
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
       =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       Samir Bellabes <sam@synack.fr>,
       Casey Schaufler <casey@schaufler-ca.com>, Pavel Machek <pavel@ucw.cz>,
       Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 30, 2009 at 6:00 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Wed, 30 Dec 2009 13:36:57 -0800
> ebiederm@xmission.com (Eric W. Biederman) wrote:
>
>> Alan Cox <alan@lxorguk.ukuu.org.uk> writes:
>>
>> >> Added bprm->nosuid to make remove the need to add
>> >> duplicate error prone checks.  This ensures that
>> >> the disabling of suid executables is exactly the
>> >> same as MNT_NOSUID.
>> >
>> > Another fine example of why we have security hooks so that we don't get a
>> > kernel full of other "random security idea of the day" hacks.
>>
>> Well it comes from plan 9.  Except there they just simply did not
>> implement suid.  What causes you to think dropping the ability
>> to execute suid executables is a random security idea of the day?
>
> Well to be fair its random regurgitated security idea of every year or
> two.
>
> More to the point - we have security_* hooks so this kind of continuous
> security proposal turdstream can stay out of the main part of the kernel.
>
> Cleaning up the mechanism by which NOSUID is handled in kernel seems a
> good idea. Adding wacky new prctls and gunk for it doesn't, and belongs
> in whatever security model you are using via the security hooks.

I see this as being a security-model agnostic API - the reason being,
the application is specifying a policy for itself that has meaning in
all existing security models, and which does not require administrator
intervention to configure. Rather than reimplementing this for each
security model, it's far better to do it just once. Moreover, by
having a single, common API, the application can state the general
policy "I will never need to gain priviliges over exec" without
needing to know what LSM is in use.

The future goal of this API is to allow us to relax restrictions on
creating new namespaces, chrooting, and otherwise altering the task's
environment in ways that may confuse privileged applications. Since
security hooks are all about making the existing security restrictions
_stricter_, it's not easy to later relax these using the security hook
model. And once we put in the general requirement that "this task
shall never gain privilege", it should be safe to relax these
restrictions for _all_ security models.

In short, this is something which is meaningful for all existing LSMs
and should be implemented in a central point, it will make things
easier for the namespace folks, and since it will lead to relaxing
restrictions later, it doesn't make sense to put it in a LSM as they
stand now.
