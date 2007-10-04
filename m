Return-Path: <linux-kernel-owner+w=401wt.eu-S1760748AbXJDUVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760748AbXJDUVg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 16:21:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755484AbXJDUV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 16:21:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40694 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756659AbXJDUV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 16:21:26 -0400
Message-ID: <47054B2E.1050906@redhat.com>
Date: Thu, 04 Oct 2007 16:21:02 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>
CC: Luca Tettamanti <kronos.it@gmail.com>, Frans Pop <elendil@planet.nl>,
       Willy Tarreau <w@1wt.eu>, LKML <linux-kernel@vger.kernel.org>,
       =?ISO-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
       "Alexander E. Patrakov" <patrakov@ums.usu.ru>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Decreasing stime running confuses top
References: <200710031433.34504.elendil@planet.nl> <20071004191921.GA24011@dreamland.darkstar.lan> <47053FC7.2070308@redhat.com> <200710042200.03489.borntraeger@de.ibm.com>
In-Reply-To: <200710042200.03489.borntraeger@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2007 04:00 PM, Christian Borntraeger wrote:
> Am Donnerstag, 4. Oktober 2007 schrieb Chuck Ebbert:
>> Is CONFIG_VIRT_CPU_ACCOUNTING set?
> 
> This is s390 and powerpc only, so the answer is probably no ;-)
> 

The code in fs/proc/array.c is... interesting.

1. task_stime() converts p->se.sum_exec_runtime to a clock_t

2. it calls task_utime() which does the same thing (can it change
   between the two reads?), does some calculations that yield a 
   clock_t, turns the result into a cputime and returns that

3. task_stime() then converts that result back into a clock_t and
   uses it!


static cputime_t task_stime(struct task_struct *p)
{
        clock_t stime;

        stime = nsec_to_clock_t(p->se.sum_exec_runtime) -
                        cputime_to_clock_t(task_utime(p));

        return clock_t_to_cputime(stime);
}

static cputime_t task_utime(struct task_struct *p)
{
        clock_t utime = cputime_to_clock_t(p->utime),
                total = utime + cputime_to_clock_t(p->stime);
        u64 temp;

        temp = (u64)nsec_to_clock_t(p->se.sum_exec_runtime);

        if (total) {
                temp *= utime;
                do_div(temp, total);
        }
        utime = (clock_t)temp;

        return clock_t_to_cputime(utime);
}
