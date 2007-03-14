Return-Path: <linux-kernel-owner+w=401wt.eu-S1161108AbXCNKjK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161108AbXCNKjK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 06:39:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161093AbXCNKjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 06:39:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37936 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161120AbXCNKjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 06:39:09 -0400
Date: Wed, 14 Mar 2007 11:38:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH 58/59] sysctl: Reimplement the sysctl proc support
Message-ID: <20070314103832.GA16104@elte.hu>
References: <m1ac0jc4no.fsf@ebiederm.dsl.xmission.com> <11689657073389-git-send-email-ebiederm@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11689657073389-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric W. Biederman <ebiederm@xmission.com> wrote:

> From: Eric W. Biederman <ebiederm@xmission.com> - unquoted
> 
> With this change the sysctl inodes can be cached and nothing needs to 
> be done when removing a sysctl table.

your change is now upstream:

  commit 77b14db502cb85a031fe8fde6c85d52f3e0acb63
  Author: Eric W. Biederman <ebiederm@xmission.com>
  Date:   Wed Feb 14 00:34:12 2007 -0800

but it broke the latency tracer in -rt which uses create_proc_entry() to 
attach a custom handler to value changes in preempt_max_latency:

 #define PROCNAME_PML    "sys/kernel/preempt_max_latency"

 static __init int latency_fs_init(void)
 {
         struct proc_dir_entry *entry;

         if (!(entry = create_proc_entry(PROCNAME_PML, 0644, NULL)))
                 printk("latency_fs_init(): can't create %s\n", PROCNAME_PML);

with your change that broke because beyond /proc/sys/ there are no real 
proc entries anymore, there's no de->subdir directory for 
xlate_proc_name() to find. While the latency tracer isnt upstream, this 
change in semantics does not seem to be intended (the changelog is 
certainly silent about it).

	Ingo
