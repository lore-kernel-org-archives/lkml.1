Return-Path: <linux-kernel-owner+w=401wt.eu-S1756818AbYGWXyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818AbYGWXyZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 19:54:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755241AbYGWXyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 19:54:16 -0400
Received: from smtp-out.google.com ([216.239.33.17]:41153 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755161AbYGWXyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 19:54:14 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=JWOM+lwWmXx6BymrK0y9LFmjTk1WFrOPPp0wSNLt22wc8EoNK9+kBGVRTU2DW7azQ
	Qzji18R6rf5kUReGWbKkw==
Message-ID: <166fe7950807231654ib5759e1kae54887f0918d3fb@mail.gmail.com>
Date: Wed, 23 Jul 2008 16:54:03 -0700
From: "Ranjit Manomohan" <ranjitm@google.com>
To: "Patrick McHardy" <kaber@trash.net>
Subject: Re: [PATCH] Traffic control cgroups subsystem
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, lizf@cn.fujitsu.com, menage@google.com
In-Reply-To: <4887B1F0.3000407@trash.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0807221041210.1091@ranjit.corp.google.com>
	 <20080723150536.ded38b22.akpm@linux-foundation.org>
	 <4887B1F0.3000407@trash.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2008 at 3:34 PM, Patrick McHardy <kaber@trash.net> wrote:
> Andrew Morton wrote:
>>
>> On Tue, 22 Jul 2008 10:44:18 -0700 (PDT)
>> Ranjit Manomohan <ranjitm@google.com> wrote:
>>
>>> @@ -359,7 +370,12 @@ static int flow_classify(struct sk_buff *skb, struct
>>> tcf_proto *tp,
>>>                        classid %= f->divisor;
>>>
>>>                res->class   = 0;
>>> -               res->classid = TC_H_MAKE(f->baseclass, f->baseclass +
>>> classid);
>>> +
>>> +               if (key == FLOW_KEY_CGROUP_CLASSID)
>>> +                       res->classid = TC_H_MAKE(f->baseclass, classid);
>>> +               else
>>> +                       res->classid = TC_H_MAKE(f->baseclass,
>>> +                                                f->baseclass + classid);
>>
>> This causes a warning:
>>
>> net/sched/cls_flow.c: In function 'flow_classify':
>> net/sched/cls_flow.c:344: warning: 'key' may be used uninitialized in this
>> function
>>
>> that warning is a non-issue if we happen to know that f->nkeys can
>> never be zero.  I don't know if that is guaranteed at this code site?
>
> It is by the flow_change() function, but special casing the
> CGROUP_CLASSID is not acceptable anyway. There should be no
> need for that, a simple linear mapping to classids is done
> by default in mapping mode, the sk_cgroup_classid simply
> shouldn't include qdisc IDs.

I did not want to special case it but I want an identity mapping not a
linear one.  For some reason a baseclass of X:0 is not allowed, and
there does not seem to be a clean way to get a 1-1 mapping (tc.classid
-> X:tc.classid). I would have to workaround it by using a baseclass
of the form X:Y and then subtracting Y from the value written to
tc.classid which seemed very non intuitive.

Any particular reason for this restriction? Am I missing any other
technique of getting a 1-1 mapping using the flow classifier?

-Thanks,
Ranjit

>
