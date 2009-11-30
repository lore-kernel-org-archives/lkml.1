Return-Path: <linux-kernel-owner+w=401wt.eu-S1753503AbZK3GjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503AbZK3GjO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 01:39:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751069AbZK3GjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 01:39:13 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:41358 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbZK3GjM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 01:39:12 -0500
To: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Vlad Yasevich <vladislav.yasevich@hp.com>,
       "David S. Miller" <davem@davemloft.net>
References: <20091130164415.f418834b.sfr@canb.auug.org.au>
	<2375c9f90911292151t2deb8530idd96ce50ced74d80@mail.gmail.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 29 Nov 2009 22:39:12 -0800
In-Reply-To: <2375c9f90911292151t2deb8530idd96ce50ced74d80@mail.gmail.com>
 (=?utf-8?Q?=22Am=C3=A9rico?= Wang"'s message of "Mon\, 30 Nov 2009
 13\:51\:03 +0800")
Message-ID: <m1r5rga54f.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: =?ISO-8859-1?Q?;Am=c3=a9rico Wang <xiyou.wangcong@gmail.com>?=
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: linux-next: manual merge of the sysctl tree with the net tree
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Américo Wang <xiyou.wangcong@gmail.com> writes:

> On Mon, Nov 30, 2009 at 1:44 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> Hi Eric,
>>
>> Today's linux-next merge of the sysctl tree got a conflict in
>> net/sctp/sysctl.c between commit 90f2f5318b3a5b0898fef0fec9b91376c7de7a2c
>> ("sctp: Update SWS avaoidance receiver side algorithm") from the net tree
>> and commit f8572d8f2a2ba75408b97dc24ef47c83671795d7 ("sysctl net: Remove
>> unused binary sysctl code") from the sysctl tree.
>>
>> I fixed it up (see below) and can carry the fix as necessary.  I also
>> removed the strategy member from the new added ctl_table entry.
>> --
>> Cheers,
>> Stephen Rothwell                    sfr@canb.auug.org.au
>>
>> diff --cc net/sctp/sysctl.c
>> index ae03ded,d50a042..0000000
>> --- a/net/sctp/sysctl.c
>> +++ b/net/sctp/sysctl.c
>> @@@ -285,19 -241,7 +242,17 @@@ static ctl_table sctp_table[] =
>>                .extra1         = &zero,
>>                .extra2         = &addr_scope_max,
>>        },
>>  +      {
>> -               .ctl_name       = CTL_UNNUMBERED,
>>  +              .procname       = "rwnd_update_shift",
>>  +              .data           = &sctp_rwnd_upd_shift,
>>  +              .maxlen         = sizeof(int),
>>  +              .mode           = 0644,
>> -               .proc_handler   = &proc_dointvec_minmax,
>> -               .strategy       = &sysctl_intvec,
>> ++              .proc_handler   = proc_dointvec_minmax,
>
> Hey, what's this??

The short version is I am running a git tree that holds all of
the necessary cleanups to remove the support for binary sysctl handlers.

The binary sysctl support continues to be provided in kernel/sysctl_binary.c
with a compatibility wrapper.  This has been reviewed on linux-kernel
and written up in lwn.

In my tree .ctl_name and .strategy have been removed as they exist
only to support binary sysctls and are not strictly needed today.
.ctl_name = CTL_UNNUMBERED is equivalent to .ctl_name = 0, and setting
.strategy on new sysctl table entries without a ctl_name is a harmless
bug.  Since I was in there I also removed all of the unnecessary ampersands
from in front of proc_dointvec_minmax.

Since I have touched practically every sysctl table entry in the kernel
new sysctl additions will almost inevitably cause a small by trivially
to resolve conflict (due to the fact I have almost certainly changed
the proceeding and succeeding sysctl table entries).

Currently this only the second sysctl added this kernel cycle, and it
looks like this work happened in parallel, with my changes, and somehow
David missed this commit in his September pull, so the changes just
showed up in net-next.

It would seem to require talent to mess up the merge conflicts, and
getting it wrong will result in a tree that won't compile so I am not
going to worry about it until Linux pulls one of our trees.

Eric


