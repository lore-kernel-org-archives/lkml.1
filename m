Return-Path: <linux-kernel-owner+w=401wt.eu-S1754038AbZHHG7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038AbZHHG7U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 02:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753081AbZHHG7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 02:59:19 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:40556 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051AbZHHG7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 02:59:18 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stefani Seibold <stefani@seibold.net>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
References: <1249676830.27640.16.camel@wall-e>
	<20090807135806.ffd068e9.akpm@linux-foundation.org>
	<1249681387.17422.10.camel@wall-e>
	<20090807151657.d577dd2d.akpm@linux-foundation.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 07 Aug 2009 23:59:12 -0700
In-Reply-To: <20090807151657.d577dd2d.akpm@linux-foundation.org> (Andrew Morton's message of "Fri\, 7 Aug 2009 15\:16\:57 -0700")
Message-ID: <m1tz0idc5b.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, stefani@seibold.net
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH] Fix proc_file_write missing ppos update
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Fri, 07 Aug 2009 23:43:07 +0200
> Stefani Seibold <stefani@seibold.net> wrote:
>

>> So what is your suggestion? Should we drop this patch or should we
>> analyze the users and fix it?
>
> Well.
>
> We could review all implementations of ->write_proc.  There only seem
> to be twenty or so.
>
> If any of them will have their behaviour altered by this patch then
> let's look at those on a case-by-case basis and decide whether making
> this change will have an acceptable risk.
>
> If we _do_ find one for which we simply cannot make this behavioural
> change then..  ugh.  We could perhaps add a new `bool
> proc_dir_entry.implement_old_broken_behaviour' and set that flag for
> the offending driver(s) and test it within proc_write_file().
>
> Or we could do
>
> 	if (pde->write_proc_new) {
> 		rv = pde->write_proc_new(file, buffer, count, pde->data);
> 		*ppos += rv;
> 	} else {
> 		rv = pde->write_proc(file, buffer, count, pde->data);
> 	}
>
> which is really the same thing and isn't obviously better ;)
>
>> My opinion is to fix it, because it is wrong and it limits the usage of
>> the proc_write operation. Many embedded developers like me count on proc
>> support, because it is much simpler to use than the seqfile thing.

The simple and portable answer is to implement your own file_operations.

It is unlikely that implementing a new totally unstructured proc file is
a good idea.

I'm not quite up to speed on write_proc but I believe we have been spraying
read_proc and write_proc because of problems with the interface.

Eric
