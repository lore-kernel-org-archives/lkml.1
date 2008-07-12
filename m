Return-Path: <linux-kernel-owner+w=401wt.eu-S1756266AbYGLDwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266AbYGLDwS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 23:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753326AbYGLDwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 23:52:06 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:50329 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535AbYGLDwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 23:52:04 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Stoyan Gaydarov" <stoyboyker@gmail.com>
Cc: "Denis V. Lunev" <den@openvz.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, "Alexey Dobriyan" <adobriyan@openvz.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "David S. Miller" <davem@davemloft.net>
References: <1209467538.29647.11.camel@iris.sw.ru>
	<1209467602-20001-9-git-send-email-den@openvz.org>
	<6d291e080807112012r7ae44318oc41366b83d484b7f@mail.gmail.com>
Date: Fri, 11 Jul 2008 20:42:51 -0700
In-Reply-To: <6d291e080807112012r7ae44318oc41366b83d484b7f@mail.gmail.com>
	(Stoyan Gaydarov's message of "Fri, 11 Jul 2008 22:12:30 -0500")
Message-ID: <m1abgn6a4k.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Stoyan Gaydarov" <stoyboyker@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0024]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 9/12] ipv4: assign PDE->data before gluing PDE into /proc tree
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Stoyan Gaydarov" <stoyboyker@gmail.com> writes:

> First off, sorry to bring such an old email back but I can seem to get
> a bad feeling when looking back over it.
>
> On Tue, Apr 29, 2008 at 6:13 AM, Denis V. Lunev <den@openvz.org> wrote:
>> The check for PDE->data != NULL becomes useless after the replacement
>> of proc_net_fops_create with proc_create_data.
>>
>> Signed-off-by: Denis V. Lunev <den@openvz.org>
>> Cc: Alexey Dobriyan <adobriyan@openvz.org>
>> Cc: Eric W. Biederman <ebiederm@xmission.com>
>> Cc: David S. Miller <davem@davemloft.net>
>> ---
>>  net/ipv4/tcp_ipv4.c |   10 +++-------
>>  net/ipv4/udp.c      |    7 +++----
>>  2 files changed, 6 insertions(+), 11 deletions(-)
>>
>> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
>> index 7766151..4d97b28 100644
>> --- a/net/ipv4/tcp_ipv4.c
>> +++ b/net/ipv4/tcp_ipv4.c
>> @@ -2214,9 +2214,6 @@ static int tcp_seq_open(struct inode *inode, struct file
> *file)
>>        struct tcp_iter_state *s;
>>        int err;
>>
>> -       if (unlikely(afinfo == NULL))
>> -               return -EINVAL;
> I think that this check needs to stay in some form, reason below.
>> -
>>        err = seq_open_net(inode, file, &afinfo->seq_ops,
>>                          sizeof(struct tcp_iter_state));
>>        if (err < 0)
>> @@ -2241,10 +2238,9 @@ int tcp_proc_register(struct net *net, struct
> tcp_seq_afinfo *afinfo)
>>        afinfo->seq_ops.next            = tcp_seq_next;
>>        afinfo->seq_ops.stop            = tcp_seq_stop;
>>
>> - p = proc_net_fops_create(net, afinfo->name, S_IRUGO, &afinfo->seq_fops);
>> -       if (p)
>> -               p->data = afinfo;
>> -       else
>> +       p = proc_create_data(afinfo->name, S_IRUGO, net->proc_net,
>
> When you try to pass in afinfo->name (and also the seq_fops) you are
> assuming that afinfo is not null meaning in the unlikely(as shown
> above) even that it is null you get a very bad null pointer problem.
> If I am just way off do let me know because this just seams to me like
> a bad idea. This is also still present in 2.6.26-rc9.

It appears you are getting things confused.  The original window is that tcp_seq_open
(which is what get called when you open the proc file) had a small race that p->data
could be read before it was set.

With proc_create_data that race was closed.

You are saying that it is a problem for tcp_seq_open to be passed a NULL afinfo.
It is.  That has nothing to do with the original race (as that is a very
different part of the code).  Feel free to audit all of the callers if
you like.  That problem however is not subtle or racy.

So I see nothing wrong with this patch unless you can find a problem with
proc_create_data.

Eric
