Return-Path: <linux-kernel-owner+w=401wt.eu-S1756452AbZBKMKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756452AbZBKMKY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 07:10:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754848AbZBKMKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 07:10:08 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:3494 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754498AbZBKMKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 07:10:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FjXEtOVOngTXRHCJggtaWufVY2tGwhf187h/dvAQAYXA95ctMI0+S4Qaeh0DqWKgIt
         cU63VKEthc6NiR7C4DXYJyZwY0yySi5Yuvx4W9Q7Vsgokc2ICs3VRMD7zFG2u8MAhf10
         pYZ0UZDW2urwbPOKs6MxgxYUBg/sx8RMp3TIc=
MIME-Version: 1.0
In-Reply-To: <20090211115357.GG16317@balbir.in.ibm.com>
References: <b6a2d2e20902091130ha452a97rcfaa2972bfdbe710@mail.gmail.com>
	 <b6a2d2e20902091204p2391799p160ce13971e9f779@mail.gmail.com>
	 <1234271177.23438.24.camel@twins>
	 <b6a2d2e20902100646q6c7073cse86b8f5790a120ac@mail.gmail.com>
	 <1234281602.23438.96.camel@twins>
	 <b6a2d2e20902100932i475c1ee8va99de6e433a6d89a@mail.gmail.com>
	 <1234295613.4699.1.camel@laptop>
	 <b6a2d2e20902110333j37cf76b4v73abc2be3631738c@mail.gmail.com>
	 <1234352534.23438.130.camel@twins>
	 <20090211115357.GG16317@balbir.in.ibm.com>
Date: Wed, 11 Feb 2009 12:10:06 +0000
Message-ID: <b6a2d2e20902110410sdff3213maa398d2a1f1f7b86@mail.gmail.com>
Subject: Re: cgroup, RT reservation per core(s)?
From: Rolando Martins <rolando.martins@gmail.com>
To: balbir@linux.vnet.ibm.com
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Paul Menage <menage@google.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/11/09, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> * Peter Zijlstra <peterz@infradead.org> [2009-02-11 12:42:14]:
>
>
>  > On Wed, 2009-02-11 at 11:33 +0000, Rolando Martins wrote:
>  >
>  > > Hi again,
>  > >
>  > > is there any way to have multiple "distinct" sched domains, i.e.:
>  > > mount -t cgroup -o cpu none /dev/sched_domain_0
>  > > .... setup sched_domain_0 (ex:  90% RT, 10% Others)
>  > > mount -t cgroup -o cpu none /dev/sched_domain_1
>  > > .... setup sched_domain_1 (ex:  20% RT, 80% Others)
>  > > Then give sched_domain_0 to cpuset A and sched_domain_1 to B?
>  >
>  > Nope.
>  >
>  > We currently only support a single instance of a cgroup controller.
>  >
>  > I see the use for what you propose, however implementing that will be
>  > 'interesting'.
>
>
> I am confused, if you cpusets, you get your own sched_domain. If you
>  mount cpusets and cpu controller together, you'll get what you want.
>  Is this a figment of my imagination. You might need to use exclusive
>  CPUsets though.
>
>  --
>
>         Balbir
>
I don't know if you meant the following situation (mounting cpuset and
cpu together):

                                                            R
                                              -----------------------
      (80% RT, 20%Others)      A                        B (100% RT, 0%
Others)
      (Cpus 0-2)                                                 (CPU 3)

If so, we can't do this because  of the restriction imposed by global
rt_runtime_ns.
Perhaps a "feasible" solution could be implemented by having distinct
global rt_runtime_ns (one for each cpu, i.e.: rt_runtime_ns_0; ...;
rt_runtime_n )

                                                            R
                                              -----------------------
      (80% RT, 20%Others)      A                        B (100% RT, 0%
Others)
      (Cpus 0-2)                                                 (CPU 3)
capacity_used_cpu_0_rt = 0.8                        capacity_used_cpu_3_rt = 1
capacity_used_cpu_1_rt = 0.8
capacity_used_cpu_2_rt = 0.8

Given a i processor: we have the global restriction enforced:
SUM(capacity_used_cpu_i_rt) < rt_runtime_i

Rol
