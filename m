Return-Path: <linux-kernel-owner+w=401wt.eu-S1753333AbZIBSoG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbZIBSoG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 14:44:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753261AbZIBSoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 14:44:05 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:38934 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259AbZIBSoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 14:44:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=CWVGhR70uMoRsq3YGq/XcxMCt72R1xDLRkeyS3jeqZXS6i4hi7BmfAQpSGp6qNqOWT
         YC3LnyJO5PPO0AIaQzoH/ji5ouNbV+miSJT5fFeLBANm4qQfGbLpY0eF97cSlXlqDWAB
         nklN+w27RoySN67CLTfu3N+Yi9Wq2gs6qrfzA=
Message-ID: <4A9EBCF8.1020609@gmail.com>
Date: Wed, 02 Sep 2009 20:44:08 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.1) Gecko/20090715 SUSE/3.0b3-8.4 Thunderbird/3.0b3
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: akpm@linux-foundation.org, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] core: allow setrlimit to non-current tasks
References: <1251884703-14523-1-git-send-email-jirislaby@gmail.com> <1251884703-14523-2-git-send-email-jirislaby@gmail.com> <20090902135024.GA6452@redhat.com>
In-Reply-To: <20090902135024.GA6452@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2009 03:50 PM, Oleg Nesterov wrote:
> But there is another minor problem. If we use read_lock(ttasklist), then
> the write to /proc/application_pid/limits can race with application doing
> sys_setrlimits().
> 
> Nothing bad can happen, but this means that "echo ... > /proc/limits" can
> be lost. Not good, if admin wants to lower ->rlim_max we should try to ensure
> this always works.

Actually, process cpu timer may be set to a wrong value. When
* somebody unrelated holds sighand->siglock
* process one stores rlim_new to rlim and gets stuck on spin_lock(siglock)
* process two does the same
* somebody releases sighand->siglock
* process one continues...

I can't think of anything else than doing all the checks and updates
under alloc_lock, introducing coarse grained static mutex in setrlimit
to protect it, or some other(I-don't-know-of)/new lock. Any ideas?

Thanks.
