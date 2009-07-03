Return-Path: <linux-kernel-owner+w=401wt.eu-S1754603AbZGCLnF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603AbZGCLnF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 07:43:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752850AbZGCLmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 07:42:54 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:49536 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752828AbZGCLmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 07:42:53 -0400
Subject: Re: Memory leak in iwlwifi or false positive?
From: Catalin Marinas <catalin.marinas@arm.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1246573533.17896.867.camel@rc-desk>
References: <1246570323.24044.16.camel@pc1117.cambridge.arm.com>
	 <1246573533.17896.867.camel@rc-desk>
Content-Type: text/plain
Organization: ARM Ltd
Date: Fri, 03 Jul 2009 12:42:52 +0100
Message-Id: <1246621372.24965.30.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Jul 2009 11:42:53.0320 (UTC) FILETIME=[66817080:01C9FBD3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Reinette,

On Thu, 2009-07-02 at 15:25 -0700, reinette chatre wrote:
> On Thu, 2009-07-02 at 14:32 -0700, Catalin Marinas wrote:
> > I'm trying to get kmemleak more robust and with the latest patches (not
> 
> I just compiled my 2.6.31 kernel with kmemleak but did not yet look into
> how it works ... I do see a lot of messages though. 

There are some patches in the latest mainline git tree to make it less
verbose and some pending patches in my kmemleak branch (on
git://linux-arm.org/linux-2.6.git).

Basically, it basically tracks all the allocated memory blocks. It scans
starting with the data sections and stacks for pointers to (anywhere
inside of) allocated memory blocks. The blocks found are scanned as well
until it finishes scanning. If a memory block wasn't referred via any
pointer during a scan, it is reported as a suspected leak (you can look
at Documentation/kmemleak.txt).

> > This happens shortly after booting. Note that if an object is freed,
> > kmemleak no longer tracks it and therefore no reporting. But in this
> > case it looks like the iwlwifi code really allocated ~4800 blocks. Is it
> > normal for this code to keep so many blocks allocated? If yes, it is
> > probably kmemleak missing some root object in the references tree.
> 
> Yes - this sounds about right. You tested with 5100 hardware which by
> default initializes 20 TX queues. For each of these queues it maintains
> a 256 buffer array of commands with 356 bytes used for each command.
> 
> The 20 * 256 gives me 5120 ... would that explain the ~4800?

OK, thanks. It could be a bug in kmemleak but I'll do some more testing
tonight and let you know.

It may be that I missed tracing some kmalloc calls.

Thanks.

-- 
Catalin

