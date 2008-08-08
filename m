Return-Path: <linux-kernel-owner+w=401wt.eu-S1757228AbYHHDAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757228AbYHHDAQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 23:00:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754569AbYHHC7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 22:59:49 -0400
Received: from mga03.intel.com ([143.182.124.21]:53156 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754525AbYHHC7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 22:59:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,324,1215414000"; 
   d="scan'208";a="31249510"
Subject: Re: [PATCH 6/6] kexec jump: fix for ftrace
From: Huang Ying <ying.huang@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>
In-Reply-To: <20080807133805.GD27783@redhat.com>
References: <1218099937.5164.37.camel@caritas-dev.intel.com>
	 <20080807133805.GD27783@redhat.com>
Content-Type: text/plain
Date: Fri, 08 Aug 2008 10:59:31 +0800
Message-Id: <1218164371.22039.20.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-08-07 at 09:38 -0400, Vivek Goyal wrote:
[...]
> What kind of problem we run into if we don't disable the ftracer?
> 
> I think there are too many #ifdefs now and probably we can at least
> get rid if #ifdef CONFIG_FTRACE thing.
> 
> I think ftracer needs to export the function to enable the tracer
> back (tracer_enable()) so that we don't directly play with ftrace_enabled
> variable. tracer_enable() can be do {} while{0} in case of CONFIG_FTRACE=n
> so that we can get rid of #ifdefs here.

The ftracer issue for kexec is reported by Dhaval Giani and fixed by
Ingo as in following thread:

http://lkml.org/lkml/2008/2/19/175

After some testing, I found that if we enable ftrace before
restore_processor_state(), system will hang. I think maybe ftracer
depends on some processor state that we destroyed during kexec and
restored by restore_processor_state(). So I move save_processor_state()
and restore_processor_state() into machine_kexec() and enable ftrace
after restore_processor_state().

The #ifdef CONFIG_FTRACE should be removed. I think an interface like
irq_save/restore is good for this.

saved_ftrace_enabled = ftrace_save_enabled()
<...>
ftrace_restore_enabled(saved_ftrace_enabled)

Best Regards,
Huang Ying


