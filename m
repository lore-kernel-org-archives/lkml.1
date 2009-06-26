Return-Path: <linux-kernel-owner+w=401wt.eu-S1756733AbZFZXAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733AbZFZXAS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 19:00:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753279AbZFZXAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 19:00:07 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:34149 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501AbZFZXAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 19:00:06 -0400
To: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
Cc: Greg KH <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel@vger.kernel.org
References: <20090626143652.GB6281@localdomain.by>
	<20090626144949.GA24173@suse.de>
	<20090626222937.GA3858@localdomain.by>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 26 Jun 2009 16:00:04 -0700
In-Reply-To: <20090626222937.GA3858@localdomain.by> (Sergey Senozhatsky's message of "Sat\, 27 Jun 2009 01\:29\:37 +0300")
Message-ID: <m17hyyfvnv.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: sergey.senozhatsky@mail.by, linux-kernel@vger.kernel.org, kay.sievers@vrfy.org, gregkh@suse.de
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Sergey Senozhatsky <sergey.senozhatsky@mail.by>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH] kobject_set_name_vargs memory leak
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sergey Senozhatsky <sergey.senozhatsky@mail.by> writes:

> On (06/26/09 07:49), Greg KH wrote:
>> Date: Fri, 26 Jun 2009 07:49:49 -0700
>> From: Greg KH <gregkh@suse.de>
>> To: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
>> Cc: Kay Sievers <kay.sievers@vrfy.org>,
>> 	"Eric W. Biederman" <ebiederm@xmission.com>,
>> 	linux-kernel@vger.kernel.org
>> Subject: Re: [PATCH] kobject_set_name_vargs memory leak
>> User-Agent: Mutt/1.5.19 (2009-01-05)
>> 
>> On Fri, Jun 26, 2009 at 05:36:52PM +0300, Sergey Senozhatsky wrote:
>> > Hello.
>> > I suppose this patch fixes memory leak in kobject.c
>> > Correct me if I'm wrong.
>> > Thanks.
>> > -----------
>> > 
>> > Fix memory leak when kobject_set_name_vargs returns -ENOMEM.
>> > 
>> > Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
>> > ---
>> > diff --git a/lib/kobject.c b/lib/kobject.c
>> > index b512b74..922cd8c 100644
>> > --- a/lib/kobject.c
>> > +++ b/lib/kobject.c
>> > @@ -222,8 +222,10 @@ int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
>> >  		return 0;
>> >  
>> >  	kobj->name = kvasprintf(GFP_KERNEL, fmt, vargs);
>> > -	if (!kobj->name)
>> > +	if (!kobj->name) {
>> > +		kfree(old_name);
>> >  		return -ENOMEM;
>> > +	}
>> 
>> We've been through this before (search lkml archives).  If kvasprintf
>> fails, then we don't want to free old_name, as the caller might want to
>> do something with it.
>> 
> Hello Greg,
>
> int kobject_set_name_vargs.... {
> 	const char *old_name = kobj->name;
>
> old_name is local variable.
>
> In the following lines we overwrite kobject->name.
>
> 	kobj->name = kvasprintf(GFP_KERNEL, fmt, vargs);
> 	if (!kobj->name)
> 		return -ENOMEM;
>
> It's not clear to me how we can do anything (including kfree) with old_name after 'return -ENOMEM'.

My feel is that if we fail we should restore kobject->name to old_name.

That should also prevent the leak without getting us into trouble elsewhere.

Eric

