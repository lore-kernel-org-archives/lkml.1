Return-Path: <linux-kernel-owner+w=401wt.eu-S1754482AbZJUQhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482AbZJUQhi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 12:37:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754065AbZJUQhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 12:37:38 -0400
Received: from mail-yw0-f202.google.com ([209.85.211.202]:33529 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615AbZJUQhh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 12:37:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=T+zGV5aCT+sdikQA2b+DqbuhNugO8lvfxdidD3+tqUceyfjll+kRnFw20Q1XR+Qx9R
         9p1Cigo3Vlj1vTirMGg4p1PSqfGIk+znufzlTcKSFovCeNl5NnE80qIW4uMNYrO2WTWE
         VNCiwvaHLRLnu1xjuUYMxJ2EEcOyrRIPPpD+8=
MIME-Version: 1.0
In-Reply-To: <x49eiow9202.fsf@segfault.boston.devel.redhat.com>
References: <200910202012.12007.czoccolo@gmail.com>
	 <x49eiow9202.fsf@segfault.boston.devel.redhat.com>
Date: Wed, 21 Oct 2009 18:37:41 +0200
Message-ID: <4e5e476b0910210937y71d2018en2b8b4a23c4bb1aa1@mail.gmail.com>
Subject: Re: [RFC V2 PATCH 3/5] cfq-iosched: reimplement priorities using 
	different service trees
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 21, 2009 at 5:54 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Corrado Zoccolo <czoccolo@gmail.com> writes:
>
>> We use different service trees for different priority classes.
>> This allows a simplification in the service tree insertion code, that no
>> longer has to consider priority while walking the tree.
>
> This is kind of funny, considering things used to be divied up into
> lists by class and priority.
>
>> + * Index in the service_trees.
>> + * IDLE is handled separately, so it has negative index
>> + */
>> +enum wl_prio_t {
>> +     IDLE_WORKLOAD = -1,
>> +     BE_WORKLOAD = 0,
>> +     RT_WORKLOAD = 1
>> +};
>
> What's wrong with IOPRIO_CLASS_(RT|BE|IDLE)?  Why invent another enum?
Because I want to index inside my internal structures, and I have no
control over the former ones.
>
>> +
>> +/*
>>   * Per block device queue structure
>>   */
>>  struct cfq_data {
> [...]
>> +     struct cfq_rb_root service_trees[2];
>> +     struct cfq_rb_root service_tree_idle;
>
> Why separate out the idle service tree from the others?
>
In a subsequent patch, I will transform the first [2] in a [2][3],
while the idle tree will remain unchanged.

>> +static struct cfq_rb_root *service_tree_for(enum wl_prio_t prio,
>> +                                         struct cfq_data *cfqd)
>> +{
>> +     if (prio == IDLE_WORKLOAD)
>> +             return &cfqd->service_tree_idle;
>> +
>> +     return &cfqd->service_trees[prio];
>> +}
>
> This should just turn into cfqd->service_trees[IOPRIO_CLASS_*] in the
> callers.
I need the special treatment for idle in next patches, so I had chosen
the different approach.

>
> [...]
>
>>  /*
>> @@ -1106,6 +1134,10 @@ static struct cfq_queue *cfq_close_cooperator(struct cfq_data *cfqd,
>>       if (cfq_cfqq_coop(cfqq))
>>               return NULL;
>>
>> +     /* we don't want to mix processes with different characteristics */
>> +     if (cfqq->service_tree != cur_cfqq->service_tree)
>> +             return NULL;
>> +
>
> Hmm, that looks like a current bug in the close cooperator code.  It
> shouldn't allow cooperation between differring scheduling classes.

Maybe. Anyway, this check for me has more impact, when the service
trees are subsequently splitted in SYNC, SYNC_NOIDLE, and ASYNC. I
don't want close cooperation between them as well.

Corrado

>
> Cheers,
> Jeff
>



-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
The self-confidence of a warrior is not the self-confidence of the average
man. The average man seeks certainty in the eyes of the onlooker and calls
that self-confidence. The warrior seeks impeccability in his own eyes and
calls that humbleness.
                               Tales of Power - C. Castaneda
