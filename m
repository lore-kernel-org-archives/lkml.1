Return-Path: <linux-kernel-owner+w=401wt.eu-S1753257AbXCWRXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257AbXCWRXq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 13:23:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753261AbXCWRXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 13:23:46 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35273 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257AbXCWRXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 13:23:44 -0400
Date: Fri, 23 Mar 2007 17:23:34 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       SystemTAP <systemtap@sources.redhat.com>,
       Satoshi Oshima <soshima@redhat.com>, Hideo Aoki <haoki@redhat.com>,
       Yumiko Sugita <yumiko.sugita.yf@hitachi.com>,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [RFC][Patch 1/4] kprobe fast unregistration
Message-ID: <20070323172334.GA7442@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
	Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
	"Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
	Prasanna S Panchamukhi <prasanna@in.ibm.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	SystemTAP <systemtap@sources.redhat.com>,
	Satoshi Oshima <soshima@redhat.com>, Hideo Aoki <haoki@redhat.com>,
	Yumiko Sugita <yumiko.sugita.yf@hitachi.com>,
	"Frank Ch. Eigler" <fche@redhat.com>
References: <4603E7A4.50300@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4603E7A4.50300@hitachi.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2007 at 11:43:48PM +0900, Masami Hiramatsu wrote:
> I'd like to suggest introducing following two interfaces for this issue.
> The first interface is unregister_*probe_fast(). This removes
> breakpoint instruction from kernel code and adds specified probe
> to the unregistering list.
> The second interface is commit_kprobes(). This waits the rcu
> synchronization and clean up each probe on the unregistering list.
> This patch also adds a list_head member to the kprobe data structure
> for linking to the unregistering list.
> 
> If using these interfaces, the probe handlers of unregistering probes
> might be called after unregister_*probe_fast() is called. So, you MUST
> call commit_kprobes() after calling unregisnter_*probe_fast() for all
> probes.

Speeding up the unregistration is a very good idea, but this interface
is rather horrible.  It's almost a receipe for users to get it wrong.

Instead just changes the register and unregister functions to take
a NULL-terminated array of probes that get registered and unregisters
at the same time (and renames them from *probe* to *probes*, please)

