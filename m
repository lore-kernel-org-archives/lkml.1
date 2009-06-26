Return-Path: <linux-kernel-owner+w=401wt.eu-S1752116AbZFZUDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116AbZFZUDW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 16:03:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751618AbZFZUDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 16:03:14 -0400
Received: from mx2.redhat.com ([66.187.237.31]:32892 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875AbZFZUDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 16:03:14 -0400
Date: Fri, 26 Jun 2009 18:48:19 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       earl_chew@agilent.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 2/2] exec: Make do_coredump more robust and safer when
	using pipes in core_pattern: wait for core collectors
Message-ID: <20090626164819.GA12063@redhat.com>
References: <20090622172818.GB14673@hmsreliant.think-freely.org> <20090625163050.d6a71a13.akpm@linux-foundation.org> <20090626180355.GE7337@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090626180355.GE7337@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26, Neil Horman wrote:
>
> - 		if (call_usermodehelper_pipe(corename+1, helper_argv, NULL,
> -				&file)) {
> + 		if (call_usermodehelper_pipe(helper_argv[0], helper_argv, NULL,
> +				&file, &pid) < 0) {

...


> +	if (ispipe && core_pipe_limit)
> +		sys_wait4(pid, NULL, 0, NULL);

How this can work? sys_wait4() can only wait for our childs, but the parent
of the dumping thread is khelper.


If we change kmod.c, then I think we need UMH_WAIT_CUSTOM_COMPLETION.


But perhaps do_coredump() can just sleep on file->...->i_pipe->wait waiting
for pipe_inode_info->readers == 0 ?

Oleg.

