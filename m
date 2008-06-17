Return-Path: <linux-kernel-owner+w=401wt.eu-S1757342AbYFQIxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757342AbYFQIxP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 04:53:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755487AbYFQIxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 04:53:00 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:54014 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755273AbYFQIw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 04:52:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=s4d8Ov46Ebd+eG08aTAuMxIytqiYvZkcOE7A+ULX64Vmv1FVYHsq+Dbc88TEe0gHJj
         OX5cPQWjmaZjC3gRXUpZ+pzw4fn6zJtiopBMiw1yhXwPC2h3P4iz8YskGq0z6G9zBk8H
         NCz47Ew4pRLWhqwYc2+UUHakx4+5OuyeNG6Eg=
Message-ID: <7c86c4470806170152rba7a4d0ieebca667ae81afaa@mail.gmail.com>
Date: Tue, 17 Jun 2008 10:52:59 +0200
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Greg KH" <greg@kroah.com>
Subject: Re: [patch 12/21] perfmon2 minimal: sysfs interface
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <7c86c4470806131531n4b24bc4dmc22d4b2277e75f24@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <484daff1.1358560a.0808.0267@mx.google.com>
	 <20080611144955.GA20145@kroah.com>
	 <7c86c4470806110800w465f1c91k7e8f0bb8fba18ca3@mail.gmail.com>
	 <7c86c4470806120554w38a11307qa34511cf4f8b4aba@mail.gmail.com>
	 <20080613035339.GE17872@kroah.com>
	 <7c86c4470806131531n4b24bc4dmc22d4b2277e75f24@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

I looked at this some more today.
I was able to remove the need for a custom attribute structure for one
of the objects.

I think it is not possible to use the generic kobj_attribute if you
need to refer to a particular
object in the show/store, i.e, not a global data structure. In other
words, if you need to use
the kobj pointer passed to the show() routine to access your data
structure, then you need to
rely on container_of() and thus the kobject MUST be embedded into the
data structure defining
the object. It cannot just be a kobject pointer.

The kobject interface to create and add objects come in two forms, the
one which requires
a ktype and the one which does not, i.e., kobject_create() and its
derivatives. It seems like
if you want to leverage the kobj_attribute, you need to avoid all
calls which require a ktype.
But then there is no such function which would work on an already
allocated kobject.
kobject_create_and_add() does allocate the kobject. You do not want
that because it means
the kobject is not embedded into your data structure anymore.

Am I missing something here?

Thanks.



On Sat, Jun 14, 2008 at 12:31 AM, stephane eranian
<eranian@googlemail.com> wrote:
> Greg,
>
>
>
> On Fri, Jun 13, 2008 at 5:53 AM, Greg KH <greg@kroah.com> wrote:
>> On Thu, Jun 12, 2008 at 02:54:15PM +0200, stephane eranian wrote:
>>>
>>> In any case, let me know if there are still things that must be
>>> changed/simplified in my file.
>>
>> This looks much better.  I wonder if you could use the "default" kobject
>> attributes, which might allow you to remove some of your show/store
>> wrappers, but in general, it's much better than before.
>>
> Well, I wondered about that myself, but I think I am missing one piece.
> The difference between some of the show/store functions and others
> is that if you look closely, you see that some make reference to global
> structures, e.g., pfm_controls, or call out to routines in others modules.
> For those, I have switched to the default attribute. But the other show/store
> functions need to access the particular object where the kobj is embedded.
> And for that, it seems you need to glue function:
>
> #define to_pmu(n) container_of(n, struct pfm_pmu_config, kobj)
>
> static ssize_t pfm_pmu_attr_show(struct kobject *kobj,
>                struct attribute *attr, char *buf)
> {
>        struct pfm_pmu_config *pmu = to_pmu(kobj);
>        struct pfm_attribute *attribute = to_attr(attr);
>        return attribute->show ? attribute->show(pmu, attribute, buf) : -EIO;
> }
>
> which basically calls the container_of() routine..
>
> Yet, I get the feeling that is the show routein gets the same kobj,
> then I could as well do the
> to_pmu() there. And the attr (use the the strcmp()) would be the default.
>
> If you tell me this is the way to go, I will certainly be happy to
> make the change and remove even
> more code!
>
>
> Thanks.
>
