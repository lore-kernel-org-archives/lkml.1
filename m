Return-Path: <linux-kernel-owner+w=401wt.eu-S1755951AbZCEAcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951AbZCEAcY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 19:32:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753786AbZCEAcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 19:32:13 -0500
Received: from mail-bw0-f178.google.com ([209.85.218.178]:62512 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296AbZCEAcM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 19:32:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=roa+JuWozqxAehrRzWU+k4xgtZHTwmuYlqH1BRviRYaxVOINlQ5h3nXZbmdUfiV/r8
         BY3+RHCF3qvm2bpOsX7XYEMOieRZFmAGdlsK7mfl74YiM0SRNeW+3iRgbVTOs8yNMrHq
         uGb58twK6t2RsBWNf+kNpaUx/M0UL0wlOYJRg=
MIME-Version: 1.0
In-Reply-To: <20090304233458.GA8303@ami.dom.local>
References: <a5d9929e0903011636w6bff1032y28ab58c0ff8c8052@mail.gmail.com>
	 <20090301165729.8e08e1d7.akpm@linux-foundation.org>
	 <49AC28FF.1040102@gmail.com>
	 <a5d9929e0903031510r7f173f5cib7bd1a2426e92473@mail.gmail.com>
	 <1236135028.7883.44.camel@Maple> <20090304233458.GA8303@ami.dom.local>
Date: Thu, 5 Mar 2009 00:32:08 +0000
Message-ID: <a5d9929e0903041632r56af217r3b6645d3d01c8ca5@mail.gmail.com>
Subject: Re: [PATCH] Re: some tc commands fail on 2.6.29-rc6-git5, works on 
	2.6.28.7
From: Joao Correia <joaomiguelcorreia@gmail.com>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: John Dykstra <john.dykstra1@gmail.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, akpm@linux-foundation.org,
       Stephen Hemminger <shemminger@vyatta.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

Confirmed working now on latest 2.6.29-rc6 git.

Thank you very much all for the prompt answer and solution, really impressive.

Back to work on the ultimate custom firewall *evil laugh*.

Cheers,
Joao Correia
Centro de Informatica
Universidade da Beira Interior
Portugal

On Wed, Mar 4, 2009 at 11:34 PM, Jarek Poplawski <jarkao2@gmail.com> wrote:
> On Tue, Mar 03, 2009 at 08:50:28PM -0600, John Dykstra wrote:
>> On Tue, 2009-03-03 at 23:10 +0000, Joao Correia wrote:
>> > I have confirmed again that the exact same commands (as on the
>> > original message), work flawlessly on 2.6.28.7 without a hitch, and,
>> > AFAIK, work as intended. I have also tried the latest 2.6.29-rc6-git7
>> > and it still fails like on git6.
>>
>> I have also reproduced this on Linus' latest 2.6.29-rc6 tree, using tc
>> version iproute2-ss071016 and a kernel config with all traffic control
>> features enabled.
>>
>> The error reported by tc comes from the kernel-level check added by:
>>
>>       commit c1b56878fb68e9c14070939ea4537ad4db79ffae
>>       Author: Stephen Hemminger <shemminger@vyatta.com>
>>       Date:   Tue Nov 25 21:14:06 2008 -0800
>>
>>       tc: policing requires a rate estimator
>>
>>     Found that while trying average rate policing, it was possible to
>>     request average rate policing without a rate estimator. This results
>>     in no policing which is harmless but incorrect.
>>
>>     Since policing could be setup in two steps, need to check
>>     in the kernel.
>>
>>     Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
>>     Signed-off-by: David S. Miller <davem@davemloft.net>
>>
>> I got the same error when using the tc version iproute2-ss090115 built
>> this evening from the public git repository.
>>
>>   -- John
>>
>
> Very nice diagnose, thanks!
> Jarek P.
>
> PS: after upgrading iproute I couldn't reproduce this seemingly OK
> test with older versions anymore...
>
> ------------------->
> pkt_sched: act_police: Fix a rate estimator test.
>
> A commit c1b56878fb68e9c14070939ea4537ad4db79ffae "tc: policing requires
> a rate estimator" introduced a test which invalidates previously working
> configs, based on examples from iproute2: doc/actions/actions-general.
> This is too rigorous: a rate estimator is needed only when police's
> "avrate" option is used.
>
> Reported-by: Joao Correia <joaomiguelcorreia@gmail.com>
> Diagnosed-by: John Dykstra <john.dykstra1@gmail.com>
> Signed-off-by: Jarek Poplawski <jarkao2@gmail.com>
> ---
>
>  net/sched/act_police.c |   13 ++++++-------
>  1 files changed, 6 insertions(+), 7 deletions(-)
>
> diff --git a/net/sched/act_police.c b/net/sched/act_police.c
> index 5c72a11..f8f047b 100644
> --- a/net/sched/act_police.c
> +++ b/net/sched/act_police.c
> @@ -183,13 +183,6 @@ override:
>                if (R_tab == NULL)
>                        goto failure;
>
> -               if (!est && (ret == ACT_P_CREATED ||
> -                            !gen_estimator_active(&police->tcf_bstats,
> -                                                  &police->tcf_rate_est))) {
> -                       err = -EINVAL;
> -                       goto failure;
> -               }
> -
>                if (parm->peakrate.rate) {
>                        P_tab = qdisc_get_rtab(&parm->peakrate,
>                                               tb[TCA_POLICE_PEAKRATE]);
> @@ -205,6 +198,12 @@ override:
>                                            &police->tcf_lock, est);
>                if (err)
>                        goto failure_unlock;
> +       } else if (tb[TCA_POLICE_AVRATE] &&
> +                  (ret == ACT_P_CREATED ||
> +                   !gen_estimator_active(&police->tcf_bstats,
> +                                         &police->tcf_rate_est))) {
> +               err = -EINVAL;
> +               goto failure_unlock;
>        }
>
>        /* No failure allowed after this point */
>
